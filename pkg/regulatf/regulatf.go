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

type AnalyzeVisitor struct {
	Modules     map[string]ValTree
	Resources   map[string]*configs.Resource
	Expressions map[string]hcl.Expression
}

func NewAnalyzeVisitor() *AnalyzeVisitor {
	return &AnalyzeVisitor{
		Modules:     map[string]ValTree{},
		Resources:   map[string]*configs.Resource{},
		Expressions: map[string]hcl.Expression{},
	}
}

func (v *AnalyzeVisitor) VisitModule(name ModuleName) {
	v.Modules[ModuleNameToString(name)] = EmptyObjectValTree()
}

func (v *AnalyzeVisitor) VisitResource(name FullName, resource *configs.Resource) {
	v.Resources[name.ToString()] = resource
}

func (v *AnalyzeVisitor) VisitExpr(name FullName, expr hcl.Expression) {
	v.Expressions[name.ToString()] = expr
}

func (v *AnalyzeVisitor) PrepareVariables(name FullName, expr hcl.Expression) ValTree {
	moduleKey := ModuleNameToString(name.Module)
	sparse := EmptyObjectValTree()
	for _, traversal := range expr.Variables() {
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
			if _, ok := v.Resources[resourceKey]; ok {
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

func (v *AnalyzeVisitor) Sort() ([]string, error) {
	graph := map[string][]string{}
	for key, expr := range v.Expressions {
		graph[key] = []string{}
		name, err := StringToFullName(key)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Skipping expression with bad key %s: %s\n", key, err)
			continue
		}

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
				graph[key] = append(graph[key], moduleOutput.ToString())
				continue
			}

			// Rewrite variables. Add a dependency both on the actual variable
			// as well as the default.
			asDefault := full.AsDefault()
			if asDefault != nil {
				fmt.Fprintf(os.Stderr, "-> %s\n", asDefault.ToString())
				graph[key] = append(graph[key], full.ToString())
				graph[key] = append(graph[key], asDefault.ToString())
				continue
			}

			graph[key] = append(graph[key], full.ToString())
		}
	}

	sorted, err := topsort.Topsort(graph)
	if err != nil {
		return nil, err
	}

	for _, key := range sorted {
		fmt.Fprintf(os.Stderr, "Sorted: %s\n", key)
		expr := v.Expressions[key]
		name, err := StringToFullName(key)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Skipping sorted with bad key: %s: %s\n", key, err)
			continue
		}
		moduleKey := ModuleNameToString(name.Module)

		variables := v.PrepareVariables(*name, expr)
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

	return sorted, nil
}
