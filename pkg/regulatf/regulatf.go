// Look in `/pkg/regulatf/README.md` for an explanation of how this works.
package regulatf

import (
	"strings"

	"github.com/hashicorp/hcl/v2"
	"github.com/sirupsen/logrus"
	"github.com/zclconf/go-cty/cty"

	"github.com/fugue/regula/v2/pkg/terraform/lang"

	"github.com/fugue/regula/v2/pkg/topsort"
)

type Analysis struct {
	// Module metadata
	Modules map[string]*ModuleMeta

	// Resource metadata
	Resources map[string]*ResourceMeta

	// Holds all keys to expressions within resources.  This is necessary if
	// we want to do dependency analysis and something depends on "all of
	// a resource".
	ResourceExpressions map[string][]FullName

	// All known expressions
	Expressions map[string]hcl.Expression

	// All known blocks
	Blocks []FullName

	// Visit state: current resource (if any)
	currentResource *string
}

func AnalyzeModuleTree(mtree *ModuleTree) *Analysis {
	analysis := &Analysis{
		Modules:             map[string]*ModuleMeta{},
		Resources:           map[string]*ResourceMeta{},
		ResourceExpressions: map[string][]FullName{},
		Expressions:         map[string]hcl.Expression{},
		Blocks:              []FullName{},
		currentResource:     nil,
	}
	mtree.Walk(analysis)
	return analysis
}

func (v *Analysis) VisitModule(name ModuleName, meta *ModuleMeta) {
	v.Modules[ModuleNameToString(name)] = meta
}

func (v *Analysis) EnterResource(name FullName, resource *ResourceMeta) {
	resourceKey := name.ToString()
	v.Resources[resourceKey] = resource
	v.ResourceExpressions[resourceKey] = []FullName{}
	v.currentResource = &resourceKey
}

func (v *Analysis) LeaveResource() {
	v.currentResource = nil
}

func (v *Analysis) VisitBlock(name FullName) {
	v.Blocks = append(v.Blocks, name)
}

func (v *Analysis) VisitExpr(name FullName, expr hcl.Expression) {
	v.Expressions[name.ToString()] = expr
	if v.currentResource != nil {
		v.ResourceExpressions[*v.currentResource] = append(
			v.ResourceExpressions[*v.currentResource],
			name,
		)
	}
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

		if exists || full.IsBuiltin() {
			deps = append(deps, dependency{full, &full, nil})
		} else if moduleOutput := full.AsModuleOutput(); moduleOutput != nil {
			// Rewrite module outputs.
			deps = append(deps, dependency{full, moduleOutput, nil})
		} else if asDefault := full.AsDefault(); asDefault != nil {
			// Rewrite variables either as default, or as module input.
			asModuleInput := full.AsModuleInput()
			isModuleInput := false
			if asModuleInput != nil {
				if _, ok := v.Expressions[asModuleInput.ToString()]; ok {
					deps = append(deps, dependency{full, asModuleInput, nil})
					isModuleInput = true
				}
			}
			if !isModuleInput {
				deps = append(deps, dependency{full, asDefault, nil})
			}
		} else if asResourceName, _, trailing := full.AsResourceName(); asResourceName != nil {
			// Rewrite resource references.
			resourceKey := asResourceName.ToString()
			if resourceMeta, ok := v.Resources[resourceKey]; ok {
				// Keep track of attributes already added, and add "real"
				// resource expressions.
				attrs := map[string]struct{}{}
				for _, re := range v.ResourceExpressions[resourceKey] {
					attr := re
					attrs[attr.ToString()] = struct{}{}
					deps = append(deps, dependency{attr, &attr, nil})
				}

				// There may be absent attributes as well, such as "id" and
				// "arn".  We will fill these in with the resource key.

				// Construct attribute name where we will place these.
				resourceKeyVal := cty.StringVal(resourceKey)
				resourceName := *asResourceName
				if resourceMeta.Count {
					resourceName = resourceName.AddIndex(0)
				}

				// Add attributes that are not in `attrs` yet.  Include
				// the requested one (`trailing`) as well as any possible
				// references we find in the expression (`ExprAttributes`).
				absentAttrs := ExprAttributes(expr)
				if len(trailing) > 0 {
					absentAttrs = append(absentAttrs, trailing)
				}
				for _, attr := range absentAttrs {
					attrName := resourceName.AddLocalName(attr)
					if _, ok := attrs[attrName.ToString()]; !ok {
						deps = append(deps, dependency{attrName, nil, &resourceKeyVal})
					}
				}
			} else {
				// In other cases, just use the local name.  This is sort of
				// a catch-all and we should try to not rely on this too much.
				val := cty.StringVal(LocalNameToString(local))
				deps = append(deps, dependency{full, nil, &val})
			}
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

	for moduleKey := range analysis.Modules {
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
	// Obtain order
	order, err := v.Analysis.order()
	if err != nil {
		return err
	}

	// Initialize a skeleton with blocks, to ensure empty blocks are present
	for _, name := range v.Analysis.Blocks {
		moduleKey := ModuleNameToString(name.Module)
		tree := BuildValTree(name.Local, EmptyObjectValTree())
		v.Modules[moduleKey] = MergeValTree(v.Modules[moduleKey], tree)
	}

	// Evaluate expressions
	for _, name := range order {
		logrus.Debugf("evaluate: %s", name.ToString())
		expr := v.Analysis.Expressions[name.ToString()]
		moduleKey := ModuleNameToString(name.Module)
		moduleMeta := v.Analysis.Modules[moduleKey]

		vars := v.prepareVariables(name, expr)
		vars = MergeValTree(vars, SingletonValTree(LocalName{"path", "module"}, cty.StringVal(moduleMeta.Dir)))
		vars = MergeValTree(vars, SingletonValTree(LocalName{"terraform", "workspace"}, cty.StringVal("default")))

		// Add count.index if inside a counted resource.
		resourceName, _, _ := name.AsResourceName()
		if resourceName != nil {
			resourceKey := resourceName.ToString()
			if resource, ok := v.Analysis.Resources[resourceKey]; ok {
				if resource.Count {
					vars = MergeValTree(vars, SingletonValTree(LocalName{"count", "index"}, cty.NumberIntVal(0)))
				}
			}
		}

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
			logrus.Debugf("evaluate: error: %s", diags)
			val = cty.NullVal(val.Type())
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
		if err != nil || resourceName == nil {
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

		resourceAttrsName := *resourceName
		if resource.Count {
			resourceAttrsName = resourceAttrsName.AddIndex(0)
		}

		attributes := LookupValTree(v.Modules[module], resourceAttrsName.Local)
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
		PopulateTags(input[resourceKey])
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
