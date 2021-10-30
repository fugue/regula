package regulatf

import (
	"fmt"
	"os"

	"github.com/hashicorp/hcl/v2"
	"github.com/zclconf/go-cty/cty"

	"github.com/fugue/regula/pkg/terraform/configs"
	"github.com/fugue/regula/pkg/terraform/lang"

	"github.com/fugue/regula/pkg/topsort"
)

type Analysis struct {
	Modules     map[string]*ModuleMeta
	Resources   map[string]*configs.Resource
	Expressions map[string]hcl.Expression
}

func AnalyzeModuleTree(mtree *ModuleTree) *Analysis {
	analysis := &Analysis{
		Modules:     map[string]*ModuleMeta{},
		Resources:   map[string]*configs.Resource{},
		Expressions: map[string]hcl.Expression{},
	}
	mtree.Walk(analysis)
	return analysis
}

func (v *Analysis) VisitModule(name ModuleName, meta *ModuleMeta) {
	v.Modules[ModuleNameToString(name)] = meta
}

func (v *Analysis) VisitResource(name FullName, resource *configs.Resource) {
	v.Resources[name.ToString()] = resource
}

func (v *Analysis) VisitExpr(name FullName, expr hcl.Expression) {
	v.Expressions[name.ToString()] = expr
}

// Iterate all dependencies of a the given expression with the given name.
func (v *Analysis) dependencies(name FullName, expr hcl.Expression) []FullName {
	deps := []FullName{}
	for _, traversal := range expr.Variables() {
		local, err := TraversalToLocalName(traversal)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Skipping dependency with bad key: %s\n", err)
			continue
		}
		full := FullName{Module: name.Module, Local: local}
		fmt.Fprintf(os.Stderr, "- %s\n", full.ToString())

		// Rewrite module outputs.
		moduleOutput := full.AsModuleOutput()
		if moduleOutput != nil {
			fmt.Fprintf(os.Stderr, "-> %s\n", moduleOutput.ToString())
			deps = append(deps, *moduleOutput)
			continue
		}

		// Rewrite variables. Add a dependency both on the actual variable
		// as well as the default.  The order is important here: putting the
		// default first allows it to be overridden later.
		asDefault := full.AsDefault()
		if asDefault != nil {
			fmt.Fprintf(os.Stderr, "-> %s\n", asDefault.ToString())
			deps = append(deps, *asDefault)
			deps = append(deps, full)
			continue
		}

		deps = append(deps, full)
	}
	return deps
}

// Iterate all expressions to be evaluated in the "correct" order.
func (v *Analysis) order() ([]FullName, error) {
	graph := map[string][]string{}
	for key, expr := range v.Expressions {
		name, err := StringToFullName(key)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Skipping expression with bad key %s: %s\n", key, err)
			continue
		}

		graph[key] = []string{}
		for _, dependencyName := range v.dependencies(*name, expr) {
			graph[key] = append(graph[key], dependencyName.ToString())
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
			fmt.Fprintf(os.Stderr, "Skipping sorted with bad key: %s: %s\n", key, err)
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
	moduleKey := ModuleNameToString(name.Module)
	sparse := EmptyObjectValTree()
	for _, traversal := range expr.Variables() {
		// TODO: clean this up using .dependencies()
		local, err := TraversalToLocalName(traversal)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Skipping dependency with bad key: %s\n", err)
			continue
		}

		dependencyName := FullName{name.Module, local}
		var dependency ValTree

		// Grab outputs from other modules.
		asModuleOutput := dependencyName.AsModuleOutput()
		if dependency == nil && asModuleOutput != nil {
			module := ModuleNameToString(asModuleOutput.Module)
			val := LookupValTree(v.Modules[module], asModuleOutput.Local)
			dependency = SingletonValTree(local, ValTreeToValue(val))
		}

		// Normal execution
		if dependency == nil {
			dependency = SparseValTree(v.Modules[moduleKey], local)
		}

		// Rename variables to the name of their default.
		asDefault := dependencyName.AsDefault()
		if dependency == nil && asDefault != nil {
			val := LookupValTree(v.Modules[moduleKey], asDefault.Local)
			dependency = BuildValTree(dependencyName.Local, val)
		}

		// The attribute does not exist.  Most likely it is a reference to
		// a runtime attribute, like `arn`.  Replace it with a reference
		// to the resource.
		//
		// TODO: Better check to see if this belongs to a resource.
		if dependency == nil && len(local) > 2 {
			resourceName := FullName{name.Module, local[:2]}
			resourceKey := resourceName.ToString()
			if _, ok := v.Analysis.Resources[resourceKey]; ok {
				fmt.Fprintf(os.Stderr, "Found reference to resource %s\n", resourceName.ToString())
				dependency = SingletonValTree(local, cty.StringVal(resourceKey))
			}
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

		variables := v.prepareVariables(name, expr)
		fmt.Fprintf(os.Stderr, "    Context: %s\n", PrettyValTree(variables))

		data := Data{}
		scope := lang.Scope{
			Data:     &data,
			SelfAddr: nil,
			PureOnly: false,
		}
		ctx := hcl.EvalContext{
			Functions: scope.Functions(),
			Variables: ValTreeToVariables(variables),
		}

		val, diags := expr.Value(&ctx)
		if diags.HasErrors() {
			fmt.Fprintf(os.Stderr, "    Value() error: %s\n", diags)
			continue
		}

		singleton := SingletonValTree(name.Local, val)
		v.Modules[moduleKey] = MergeValTree(v.Modules[moduleKey], singleton)
	}

	for moduleKey, tree := range v.Modules {
		fmt.Fprintf(os.Stderr, "%s: %s\n", moduleKey, PrettyValTree(tree))
	}

	return nil
}

func (v *Evaluation) RegulaInput() map[string]interface{} {
	input := map[string]interface{}{}
	for moduleKey, valTree := range v.Modules {
		input[moduleKey] = ValueToInterface(ValTreeToValue(valTree))
	}
	return input
}
