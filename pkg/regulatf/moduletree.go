// This module contains utilities for parsing and traversing everything in a
// configuration tree.
package regulatf

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/fugue/regula/pkg/terraform/configs"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/zclconf/go-cty/cty"
)

// We load the entire tree of submodules in one pass.
type ModuleTree struct {
	config   *hclsyntax.Body // Call to the module, nil if root.
	module   *configs.Module
	children map[string]*ModuleTree
}

func ParseModuleTree(dir string) (*ModuleTree, error) {
	parser := configs.NewParser(nil)
	module, diags := parser.LoadConfigDir(dir)
	if diags.HasErrors() {
		return nil, diags
	}

	children := map[string]*ModuleTree{}
	for key, moduleCall := range module.ModuleCalls {
		if body, ok := moduleCall.Config.(*hclsyntax.Body); ok {
			if attr, ok := body.Attributes["source"]; ok {
				if val, err := attr.Expr.Value(nil); err == nil && val.Type() == cty.String {
					source := val.AsString()
					full := TfFilePathJoin(dir, source)
					tree, err := ParseModuleTree(full)
					if err == nil {
						tree.config = body
						children[key] = tree
					}
				}
			}
		}
	}

	return &ModuleTree{nil, module, children}, nil
}

type Visitor interface {
	VisitModule(name ModuleName)
	VisitResource(name FullName, resource *configs.Resource)
	VisitExpr(name FullName, expr hcl.Expression)
}

func (mtree *ModuleTree) Walk(v Visitor) {
	walkModuleTree(v, EmptyModuleName, mtree)
}

func walkModuleTree(v Visitor, moduleName ModuleName, mtree *ModuleTree) {
	v.VisitModule(moduleName)
	walkModule(v, moduleName, mtree.module)
	for key, child := range mtree.children {
		childModuleName := make([]string, len(moduleName)+1)
		copy(childModuleName, moduleName)
		childModuleName[len(moduleName)] = key

		configName := FullName{childModuleName, LocalName{"var"}}
		walkBody(v, configName, child.config)

		walkModuleTree(v, childModuleName, child)
	}
}

func walkModule(v Visitor, moduleName ModuleName, module *configs.Module) {
	name := EmptyFullName(moduleName)

	for _, variable := range module.Variables {
		expr := hclsyntax.LiteralValueExpr{
			Val:      variable.Default,
			SrcRange: variable.DeclRange,
		}
		v.VisitExpr(name.AddKey("variable").AddKey(variable.Name), &expr)
	}

	for _, local := range module.Locals {
		v.VisitExpr(name.AddKey("local").AddKey(local.Name), local.Expr)
	}

	for _, resource := range module.DataResources {
		walkResource(v, moduleName, resource)
	}

	for _, resource := range module.ManagedResources {
		walkResource(v, moduleName, resource)
	}

	for _, output := range module.Outputs {
		v.VisitExpr(name.AddKey("output").AddKey(output.Name), output.Expr)
	}
}

func walkResource(v Visitor, moduleName ModuleName, resource *configs.Resource) {
	name := EmptyFullName(moduleName).AddKey(resource.Type).AddKey(resource.Name)
	v.VisitResource(name, resource)
	body, ok := resource.Config.(*hclsyntax.Body)
	if !ok {
		fmt.Fprintf(os.Stderr, "Missing body\n")
		return
	}

	walkBody(v, name, body)
}

func walkBody(v Visitor, name FullName, body *hclsyntax.Body) {
	for _, attribute := range body.Attributes {
		v.VisitExpr(name.AddKey(attribute.Name), attribute.Expr)
	}

	blockCounter := map[string]int{} // Which index we're at per block type.
	for _, block := range body.Blocks {
		idx := 0
		if i, ok := blockCounter[block.Type]; ok {
			idx = i
		} else {
			blockCounter[block.Type] = 1
		}
		walkBody(v, name.AddKey(block.Type).AddIndex(idx), block.Body)
	}
}

// TfFilePathJoin is like `filepath.Join` but avoids cleaning the path.  This
// allows to get unique paths for submodules including a parent module, e.g.:
//
//     .
//     examples/mssql/../../
//     examples/complete/../../
//
func TfFilePathJoin(leading, trailing string) string {
	if filepath.IsAbs(trailing) {
		return trailing
	} else if leading == "." {
		return trailing
	} else {
		trailing = filepath.FromSlash(trailing)
		sep := string(filepath.Separator)
		trailing = strings.TrimPrefix(trailing, "."+sep)
		return strings.TrimRight(leading, sep) + sep +
			strings.TrimLeft(trailing, sep)
	}
}
