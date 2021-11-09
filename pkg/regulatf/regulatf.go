// Look in `/pkg/regulatf/README.md` for an explanation of how this works.
package regulatf

import (
	"github.com/hashicorp/hcl/v2"
	"github.com/sirupsen/logrus"
	"github.com/zclconf/go-cty/cty"

	"github.com/fugue/regula/pkg/terraform/lang"

	"github.com/fugue/regula/pkg/topsort"
)

type Analysis struct {
	Modules     map[string]*ModuleMeta
	Resources   map[string]*ResourceMeta
	Expressions map[string]hcl.Expression
}

func AnalyzeModuleTree(mtree *ModuleTree) *Analysis {
	analysis := &Analysis{
		Modules:     map[string]*ModuleMeta{},
		Resources:   map[string]*ResourceMeta{},
		Expressions: map[string]hcl.Expression{},
	}
	mtree.Walk(analysis)
	return analysis
}

func (v *Analysis) VisitModule(name ModuleName, meta *ModuleMeta) {
	v.Modules[ModuleNameToString(name)] = meta
}

func (v *Analysis) VisitResource(name FullName, resource *ResourceMeta) {
	v.Resources[name.ToString()] = resource
}

func (v *Analysis) VisitExpr(name FullName, expr hcl.Expression) {
	v.Expressions[name.ToString()] = expr
}

type dependency struct {
	destination FullName
	source      *FullName
	value       *cty.Value
}

// Iterate all dependencies of a the given expression with the given name.
func (v *Analysis) dependencies(name FullName, expr hcl.Expression) []dependency {
	deps := []dependency{}
	for _, traversal := range expr.Variables() {
		local, err := TraversalToLocalName(traversal)
		if err != nil {
			logrus.Warningf("Skipping dependency with bad key: %s", err)
			continue
		}
		full := FullName{Module: name.Module, Local: local}
		_, exists := v.Expressions[full.ToString()]
		var dep *dependency

		if exists {
			dep = &dependency{full, &full, nil}
		} else if moduleOutput := full.AsModuleOutput(); moduleOutput != nil {
			// Rewrite module outputs.
			dep = &dependency{full, moduleOutput, nil}
		} else if asDefault := full.AsDefault(); asDefault != nil {
			// Rewrite variables either as default, or as module input.
			asModuleInput := full.AsModuleInput()
			if asModuleInput != nil {
				if _, ok := v.Expressions[asModuleInput.ToString()]; ok {
					dep = &dependency{full, asModuleInput, nil}
				}
			}
			if dep == nil {
				dep = &dependency{full, asDefault, nil}
			}
		} else if asResourceName, _ := full.AsResourceName(); asResourceName != nil {
			// Rewrite resource references.
			resourceKey := asResourceName.ToString()
			if _, ok := v.Resources[resourceKey]; ok {
				val := cty.StringVal(resourceKey)
				dep = &dependency{full, nil, &val}
			} else {
				// In other cases, just use the local name.  This is sort of
				// a catch-all and we should try to not rely on this too much.
				val := cty.StringVal(LocalNameToString(local))
				dep = &dependency{full, nil, &val}
			}
		}

		if dep != nil {
			dst := dep.destination.ToString()
			src := "?"
			if dep.source != nil {
				src = dep.source.ToString()
			} else if dep.value != nil {
				src = dep.value.GoString()
			}
			logrus.Debugf("%s: %s -> %s", name.ToString(), dst, src)
			deps = append(deps, *dep)
		} else {
			logrus.Debugf("%s: %s -> missing", name.ToString(), full.ToString())
		}
	}
	return deps
}

// Iterate all expressions to be evaluated in the "correct" order.
func (v *Analysis) order() ([]FullName, error) {
	graph := map[string][]string{}
	for key, expr := range v.Expressions {
		name, err := StringToFullName(key)
		if err != nil {
			logrus.Warningf("Skipping expression with bad key %s: %s", key, err)
			continue
		}

		graph[key] = []string{}
		for _, dep := range v.dependencies(*name, expr) {
			if dep.source != nil {
				graph[key] = append(graph[key], dep.source.ToString())
			}
		}
	}

	sorted, err := topsort.Topsort(graph)
	if err != nil {
		return nil, err
	}

	sortedNames := []FullName{}
	for _, key := range sorted {
		name, err := StringToFullName(key)
		if err != nil {
			logrus.Warningf("Skipping sorted with bad key: %s: %s", key, err)
			continue
		}
		sortedNames = append(sortedNames, *name)
	}
	return sortedNames, nil
}

type Evaluation struct {
	Analysis *Analysis
	Modules  map[string]ValTree
}

func EvaluateAnalysis(analysis *Analysis) (*Evaluation, error) {
	eval := &Evaluation{
		Analysis: analysis,
		Modules:  map[string]ValTree{},
	}

	for moduleKey, _ := range analysis.Modules {
		eval.Modules[moduleKey] = EmptyObjectValTree()
	}

	if err := eval.evaluate(); err != nil {
		return nil, err
	}

	return eval, nil
}

func (v *Evaluation) prepareVariables(name FullName, expr hcl.Expression) ValTree {
	sparse := EmptyObjectValTree()
	for _, dep := range v.Analysis.dependencies(name, expr) {
		var dependency ValTree
		if dep.source != nil {
			sourceModule := ModuleNameToString(dep.source.Module)
			dependency = BuildValTree(
				dep.destination.Local,
				LookupValTree(v.Modules[sourceModule], dep.source.Local),
			)
		} else if dep.value != nil {
			dependency = SingletonValTree(dep.destination.Local, *dep.value)
		}
		if dependency != nil {
			sparse = MergeValTree(sparse, dependency)
		}
	}
	return sparse
}

func (v *Evaluation) evaluate() error {
	order, err := v.Analysis.order()
	if err != nil {
		return err
	}

	for _, name := range order {
		expr := v.Analysis.Expressions[name.ToString()]
		moduleKey := ModuleNameToString(name.Module)
		moduleMeta := v.Analysis.Modules[moduleKey]

		vars := v.prepareVariables(name, expr)
		vars = MergeValTree(vars, SingletonValTree(LocalName{"path", "module"}, cty.StringVal(moduleMeta.Dir)))

		data := Data{}
		scope := lang.Scope{
			Data:     &data,
			SelfAddr: nil,
			PureOnly: false,
		}
		ctx := hcl.EvalContext{
			Functions: scope.Functions(),
			Variables: ValTreeToVariables(vars),
		}

		val, diags := expr.Value(&ctx)
		if diags.HasErrors() {
			logrus.Warningf("    Value() error: %s", diags)
			val = cty.NilVal
		}

		singleton := SingletonValTree(name.Local, val)
		v.Modules[moduleKey] = MergeValTree(v.Modules[moduleKey], singleton)
	}

	return nil
}

func (v *Evaluation) Resources() map[string]interface{} {
	input := map[string]interface{}{}

	for resourceKey, resource := range v.Analysis.Resources {
		resourceName, err := StringToFullName(resourceKey)
		if err != nil {
			logrus.Warningf("Skipping resource with bad key %s: %s", resourceKey, err)
			continue
		}
		module := ModuleNameToString(resourceName.Module)

		resourceType := resource.Type
		if resource.Data {
			resourceType = "data." + resourceType
		}

		tree := SingletonValTree(LocalName{"id"}, cty.StringVal(resourceKey))
		tree = MergeValTree(tree, SingletonValTree(LocalName{"_type"}, cty.StringVal(resourceType)))
		tree = MergeValTree(tree, SingletonValTree(LocalName{"_provider"}, cty.StringVal(resource.Provider)))
		tree = MergeValTree(tree, SingletonValTree(LocalName{"_filepath"}, cty.StringVal(resource.Location.Filename)))

		attributes := LookupValTree(v.Modules[module], resourceName.Local)
		tree = MergeValTree(tree, attributes)

		if countTree := LookupValTree(tree, LocalName{"count"}); countTree != nil {
			if countVal, ok := countTree.(cty.Value); ok {
				count := ValueToInt(countVal)
				if count != nil && *count < 1 {
					continue
				}
			}
		}

		input[resourceKey] = ValueToInterface(ValTreeToValue(tree))
	}

	return input
}

func (v *Evaluation) Location(resourceKey string) []hcl.Range {
	resource, ok := v.Analysis.Resources[resourceKey]
	name, _ := StringToFullName(resourceKey)
	if !ok || name == nil {
		return nil
	}

	ranges := []hcl.Range{resource.Location}
	for i := len(name.Module); i >= 1; i-- {
		moduleKey := ModuleNameToString(name.Module[:i])
		if module, ok := v.Analysis.Modules[moduleKey]; ok && module.Location != nil {
			ranges = append(ranges, *module.Location)
		}
	}
	return ranges
}
