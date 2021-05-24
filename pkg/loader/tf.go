// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package loader

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strconv"
	"strings"

	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/hashicorp/terraform/addrs"
	"github.com/hashicorp/terraform/configs"
	"github.com/hashicorp/terraform/lang"
	"github.com/hashicorp/terraform/tfdiags"
	"github.com/zclconf/go-cty/cty"

	"tf_resource_schemas"
)

type TfDetector struct{}

func (t *TfDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if i.Ext() != ".tf" {
		return nil, fmt.Errorf("Expected a .tf extension for %s", i.Path())
	}
	dir := filepath.Dir(i.Path())

	return parseFiles([]string{}, dir, nil, false, []string{i.Path()})
}

func (t *TfDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	// First check that a `.tf` file exists in the directory.
	tfExists := false
	for _, child := range i.Children() {
		if c, ok := child.(InputFile); ok && c.Ext() == ".tf" {
			tfExists = true
		}
	}
	if !tfExists {
		return nil, fmt.Errorf("Directory does not contain a .tf file: %s", i.Path())
	}

	return ParseDirectory([]string{}, i.Path(), nil)
}

type HclConfiguration struct {
	// Path of the module.  This indicates its position in the module tree.
	// Example: `[]` for the root module, `["child1"]` for children.
	path []string

	// Directory the configuration is loaded from.  Necessary to find the
	// locations of child modules, and do `file()` calls.
	dir string

	// Recursively load submodules.
	recurse bool

	// Filepaths that have been loaded.
	filepaths []string

	// The actual HCL module.
	module *configs.Module

	// A pointer to schemas we can use.
	schemas tf_resource_schemas.ResourceSchemas

	// A map of loaded child modules.
	children map[string]*HclConfiguration

	// Cached inputs (vars) for the child modules
	childrenVars map[string]map[string]interface{}

	// Values of variables.  Maybe we should make this lazy to handle cycles
	// better?
	vars map[string]interface{}

	// Locations of terraform modules.
	moduleRegister *terraformModuleRegister
}

func ParseDirectory(
	path []string,
	dir string,
	moduleRegister *terraformModuleRegister,
) (*HclConfiguration, error) {
	parser := configs.NewParser(nil)
	var diags hcl.Diagnostics

	primary, _, diags := parser.ConfigDirFiles(dir)
	if diags.HasErrors() {
		return nil, diags
	}

	return parseFiles(path, dir, moduleRegister, true, primary)
}

func parseFiles(
	path []string,
	dir string,
	moduleRegister *terraformModuleRegister,
	recurse bool,
	filepaths []string,
) (*HclConfiguration, error) {
	configuration := new(HclConfiguration)
	configuration.path = path
	configuration.dir = dir
	configuration.recurse = recurse
	configuration.filepaths = filepaths

	if moduleRegister == nil {
		configuration.moduleRegister = newTerraformRegister(dir)
	} else {
		configuration.moduleRegister = moduleRegister
	}

	parser := configs.NewParser(nil)
	var diags hcl.Diagnostics
	parsedFiles := make([]*configs.File, 0)
	overrideFiles := make([]*configs.File, 0)

	for _, file := range filepaths {
		f, fDiags := parser.LoadConfigFile(file)
		diags = append(diags, fDiags...)
		parsedFiles = append(parsedFiles, f)
	}
	module, lDiags := configs.NewModule(parsedFiles, overrideFiles)
	configuration.module = module
	diags = append(diags, lDiags...)
	if diags.HasErrors() {
		fmt.Fprintf(os.Stderr, "%s\n", diags.Error())
	}
	if configuration.module == nil {
		// Only actually throw an error if we don't have a module.  We can
		// still try and validate what we can.
		return nil, fmt.Errorf(diags.Error())
	}

	configuration.schemas = tf_resource_schemas.LoadResourceSchemas()

	// Load children
	configuration.children = make(map[string]*HclConfiguration)
	if recurse {
		for key, moduleCall := range module.ModuleCalls {
			fmt.Fprintf(os.Stderr, "Key: %s\n", key)
			body, ok := moduleCall.Config.(*hclsyntax.Body)
			if ok {
				// We're only interested in getting the `source` attribute, this
				// should not have any variables in it.
				ctx := renderContext{
					dir:     dir,
					resolve: func(path []string) interface{} { return nil },
				}
				properties := ctx.RenderBody(body)
				if source, ok := properties["source"]; ok {
					if str, ok := source.(string); ok {
						fmt.Fprintf(os.Stderr, "Loading submodule: %s\n", str)
						childDir := filepath.Join(dir, str)
						if register := configuration.moduleRegister.getDir(str); register != nil {
							childDir = filepath.Join(dir, *register)
						}

						// Construct child path, e.g. `module.child1.aws_vpc.child`.
						childPath := make([]string, len(configuration.path))
						copy(childPath, path)
						childPath = append(childPath, "module")
						childPath = append(childPath, key)

						child, err := ParseDirectory(childPath, childDir, configuration.moduleRegister)
						if err == nil {
							configuration.children[key] = child
						} else {
							fmt.Fprintf(os.Stderr, "warning: Error loading submodule: %s\n", err)
						}
					}
				}
			}
		}
	}

	configuration.childrenVars = make(map[string]map[string]interface{})
	configuration.vars = make(map[string]interface{})

	return configuration, nil
}

// Return a copy of a HclConfiguration with updated variables.
func (c0 *HclConfiguration) withVars(vars map[string]interface{}) *HclConfiguration {
	c1 := c0
	c1.vars = vars
	return c1
}

func (c *HclConfiguration) LoadedFiles() []string {
	filepaths := []string{}
	if c.recurse {
		filepaths = append(filepaths, c.dir)
	}
	fmt.Fprintf(os.Stderr, "%v\n", c.filepaths)
	for _, fp := range c.filepaths {
		filepaths = append(filepaths, fp)
	}
	for _, child := range c.children {
		if child != nil {
			filepaths = append(filepaths, child.LoadedFiles()...)
		}
	}
	return filepaths
}

func (c *HclConfiguration) Location(attributePath []string) (*Location, error) {
	return nil, nil
}

func (c *HclConfiguration) RegulaInput() RegulaInput {
	path := ""
	if c.recurse {
		path = c.dir
	} else {
		path = c.filepaths[0]
	}

	return RegulaInput{
		"filepath": path,
		"content":  c.renderResourceView(),
	}
}

func (c *HclConfiguration) renderResourceView() map[string]interface{} {
	resourceView := make(map[string]interface{})
	resourceView["hcl_resource_view_version"] = "0.0.1"
	resourceView["resources"] = c.renderResources()
	return resourceView
}

func (c *HclConfiguration) qualifiedResourceId(localId string) string {
	if len(c.path) == 0 {
		return localId
	} else {
		return strings.Join(c.path, ".") + "." + localId
	}
}

func (c *HclConfiguration) renderResources() map[string]interface{} {
	resources := make(map[string]interface{})

	for resourceId, resource := range c.module.ManagedResources {
		resourceId = c.qualifiedResourceId(resourceId)
		resources[resourceId] = c.renderResource(resourceId, resource)
	}
	for resourceId, resource := range c.module.DataResources {
		resourceId = c.qualifiedResourceId(resourceId)
		resources[resourceId] = c.renderResource(resourceId, resource)
	}

	for key, _ := range c.children {
		if child, ok := c.GetChild(key); ok {
			for resourceId, resource := range child.renderResources() {
				resources[resourceId] = resource
			}
		}
	}

	return resources
}

func (c *HclConfiguration) renderResource(
	resourceId string, resource *configs.Resource,
) interface{} {
	context := c.renderContext(resourceId)
	context.schema = c.schemas[resource.Type]

	properties := make(map[string]interface{})
	properties["_type"] = resource.Type
	properties["id"] = resourceId

	body, ok := resource.Config.(*hclsyntax.Body)
	if !ok {
		return properties
	}

	bodyProperties := context.RenderBody(body)
	for k, v := range bodyProperties {
		properties[k] = v
	}

	// `provider` may be explicitly set.
	if provider, ok := properties["provider"]; ok {
		properties["_provider"] = provider
		delete(properties, "provider")
	} else {
		properties["_provider"] = resource.Provider.ForDisplay()
	}

	return properties
}

func (c *HclConfiguration) getResource(id string) (*configs.Resource, bool) {
	if r, ok := c.module.ManagedResources[id]; ok {
		return r, true
	}
	if r, ok := c.module.DataResources[id]; ok {
		return r, true
	}
	return nil, false
}

func (c *HclConfiguration) resolveResourceReference(self string, path []string) interface{} {
	if len(path) < 1 {
		return nil
	}
	idx := 2
	if path[0] == "data" {
		idx = 3
	}

	if len(path) == 2 && path[0] == "var" {
		if value, ok := c.vars[path[1]]; ok {
			return value
		} else {
			return nil
		}
	}

	if len(path) == 3 && path[0] == "module" {
		if child, ok := c.GetChild(path[1]); ok {
			out := child.GetOutput(path[2])
			fmt.Fprintf(os.Stderr, "%v -> %v\n", path, out)
			return out
		}

		return nil
	}

	if len(path) > 2 && path[0] == "random_string" {
		// Random strings are occasionally used to name resource, e.g.:
		// "server-${random_string.foo.result}".  By not resolving these,
		// we get something like "server-random_string.foo.result" which
		// usually doesn't conform to naming constraints but it's unique
		// enough to make most validations work.
		return nil
	}

	resourceId := ""
	attributePath := []string{}

	if len(path) == 1 {
		// Assume it is a local reference and update `path` to point to this
		// reference inside `self`.
		resourceId = self
		attributePath = []string{path[0]}
	} else {
		resourceId = strings.Join(path[:idx], ".")
		attributePath = path[idx:]
	}

	if resource, ok := c.getResource(resourceId); ok {
		resourceNode := TfNode{Object: resource.Config, Range: resource.DeclRange}
		if node, err := resourceNode.GetDescendant(attributePath); err == nil {
			// NOTE: We could handle non-attribute cases but we're usually not
			// using these to work with lists and blocks.
			if node.Attribute != nil {
				expr := node.Attribute.Expr
				if e, ok := expr.(hclsyntax.Expression); ok {
					ctx := c.renderContext(resourceId)
					return ctx.RenderExpr(e)
				}
			}
		}

		return c.qualifiedResourceId(resourceId)
	}
	return nil
}

func (c *HclConfiguration) GetChild(name string) (*HclConfiguration, bool) {
	if child, ok := c.children[name]; ok {
		childVars, haveChildVars := c.childrenVars[name]
		if !haveChildVars {
			moduleCall := c.module.ModuleCalls[name]
			body, ok := moduleCall.Config.(*hclsyntax.Body)
			if ok {
				ctx := renderContext{
					dir: c.dir,
					resolve: func(path []string) interface{} {
						return c.resolveResourceReference("module."+name, path)
					},
				}
				childVars = ctx.RenderBody(body)
				for key, val := range childVars {
					fmt.Fprintf(os.Stderr, "%s: setting %v to %v\n", name, key, val)
				}
			} else {
				childVars = make(map[string]interface{})
			}

			c.childrenVars[name] = childVars
		}

		return child.withVars(childVars), true
	}

	return nil, false
}

func (c *HclConfiguration) GetOutput(name string) interface{} {
	if output, ok := c.module.Outputs[name]; ok {
		if e, ok := output.Expr.(hclsyntax.Expression); ok {
			ctx := c.renderContext("")
			return ctx.RenderExpr(e)
		}
	}

	return nil
}

func (c *HclConfiguration) renderContext(self string) renderContext {
	return renderContext{
		dir:     c.dir,
		resolve: func(path []string) interface{} { return c.resolveResourceReference(self, path) },
	}
}

// This is a structure passed down that contains all additional information
// apart from the thing being rendered, which is passed separately.
type renderContext struct {
	dir     string
	schema  *tf_resource_schemas.Schema
	resolve func([]string) interface{}
}

// Create a copy of the renderContext with a different schema
func (c *renderContext) WithSchema(schema *tf_resource_schemas.Schema) *renderContext {
	c1 := c
	c1.schema = schema
	return c1
}

func (c *renderContext) RenderBody(body *hclsyntax.Body) map[string]interface{} {
	properties := make(map[string]interface{})

	for _, attribute := range body.Attributes {
		properties[attribute.Name] = c.WithSchema(
			tf_resource_schemas.GetAttribute(c.schema, attribute.Name),
		).RenderAttribute(attribute)
	}

	tf_resource_schemas.SetDefaultAttributes(c.schema, properties)

	renderedBlocks := make(map[string][]interface{})
	for _, block := range body.Blocks {
		if _, ok := renderedBlocks[block.Type]; !ok {
			renderedBlocks[block.Type] = make([]interface{}, 0)
		}

		childSchema := tf_resource_schemas.GetAttribute(c.schema, block.Type)
		if s := tf_resource_schemas.GetElem(childSchema); s != nil {
			childSchema = s
		}

		entry := c.WithSchema(childSchema).RenderBlock(block)
		renderedBlocks[block.Type] = append(renderedBlocks[block.Type], entry)
	}
	for key, renderedBlock := range renderedBlocks {
		properties[key] = renderedBlock
	}

	return properties
}

func (c *renderContext) RenderAttribute(attribute *hclsyntax.Attribute) interface{} {
	if attribute.Expr == nil {
		return nil
	}
	return c.RenderExpr(attribute.Expr)
}

func (c *renderContext) RenderBlock(block *hclsyntax.Block) interface{} {
	if block.Body == nil {
		return nil
	}
	return c.RenderBody(block.Body)
}

// This returns a string or array of references.
func (c *renderContext) ExpressionReferences(expr hclsyntax.Expression) interface{} {
	references := make([]interface{}, 0)
	for _, traversal := range expr.Variables() {
		path := c.RenderTraversal(traversal)
		resolved := c.resolve(path)
		if resolved != nil {
			references = append(references, resolved)
		}
	}
	if len(references) == 0 {
		return nil
	} else if len(references) == 1 {
		return references[0]
	} else {
		return references
	}
}

// Auxiliary function to determine if the expression should be ignored from
// sets, lists, etc.
func voidExpression(expr hclsyntax.Expression) bool {
	switch e := expr.(type) {
	case *hclsyntax.TemplateExpr:
		return len(e.Parts) == 0
	}
	return false
}

func (c *renderContext) RenderExpr(expr hclsyntax.Expression) interface{} {
	switch e := expr.(type) {
	case *hclsyntax.TemplateWrapExpr:
		return c.RenderExpr(e.Wrapped)
	case *hclsyntax.ScopeTraversalExpr:
		path := c.RenderTraversal(e.Traversal)
		ref := c.resolve(path)
		if ref != nil {
			return ref
		} else {
			// Is this useful?  This should just map to variables?
			return strings.Join(path, ".")
		}
	case *hclsyntax.TemplateExpr:
		if len(e.Parts) == 1 {
			return c.RenderExpr(e.Parts[0])
		}

		// This is commonly used to refer to resources, so we pick out the
		// references.
		refs := c.ExpressionReferences(e)
		if refs != nil {
			return refs
		}

		str := ""
		for _, part := range e.Parts {
			val := c.RenderExpr(part)
			if s, ok := val.(string); ok {
				str += s
			}
		}
		return str
	case *hclsyntax.LiteralValueExpr:
		return c.RenderValue(e.Val)
	case *hclsyntax.TupleConsExpr:
		arr := make([]interface{}, 0)
		ctx := c.WithSchema(tf_resource_schemas.GetElem(c.schema))
		for _, elem := range e.Exprs {
			if !voidExpression(elem) {
				arr = append(arr, ctx.RenderExpr(elem))
			}
		}
		return arr
	case *hclsyntax.ObjectConsExpr:
		object := make(map[string]interface{})
		for _, item := range e.Items {
			ctx := c.WithSchema(nil) // Or pass string+elem schema?
			key := ctx.RenderExpr(item.KeyExpr)
			val := ctx.RenderExpr(item.ValueExpr)
			if str, ok := key.(string); ok {
				object[str] = val
			} else {
				fmt.Fprintf(os.Stderr, "warning: non-string key: %s\n", reflect.TypeOf(key).String())
			}
		}
		return object
	case *hclsyntax.ObjectConsKeyExpr:
		// Keywords are interpreted as keys.
		if key := hcl.ExprAsKeyword(e); key != "" {
			return key
		} else {
			return c.RenderExpr(e.Wrapped)
		}
	case *hclsyntax.FunctionCallExpr:
		// This is handled using evaluation.
	default:
		fmt.Fprintf(os.Stderr, "warning: unhandled expression type %s\n", reflect.TypeOf(expr).String())
	}

	// Fall back to normal eval.
	return c.EvaluateExpr(expr)
}

func (c *renderContext) EvaluateExpr(expr hcl.Expression) interface{} {
	// We set up a scope and context to be close to regula terraform, and we
	// reuse the functions that it exposes.
	scope := lang.Scope{
		Data:     c,
		SelfAddr: nil,
		PureOnly: false,
	}
	// NOTE: we could try to convert the variables we have into native cty.Value
	// items and insert them again as variables.
	vars := map[string]cty.Value{
		"path": cty.MapVal(map[string]cty.Value{
			"module": cty.StringVal(c.dir),
		}),
	}
	ctx := hcl.EvalContext{
		Functions: scope.Functions(),
		Variables: vars,
	}

	val, err := expr.Value(&ctx)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Evaluation error: %s\n", err)
	}
	return c.RenderValue(val)
}

func (c *renderContext) RenderTraversal(traversal hcl.Traversal) []string {
	parts := make([]string, 0)

	for _, traverser := range traversal {
		switch t := traverser.(type) {
		case hcl.TraverseRoot:
			parts = append(parts, t.Name)
		case hcl.TraverseAttr:
			parts = append(parts, t.Name)
		case hcl.TraverseIndex:
			// Should be an integer but treat it a bit more generically.
			part := fmt.Sprintf("%v", c.RenderValue(t.Key))
			parts = append(parts, part)
		}
	}

	return parts
}

func (c *renderContext) RenderValue(val cty.Value) interface{} {
	if !val.IsKnown() {
		return nil
	}

	if val.Type() == cty.Bool {
		return val.True()
	} else if val.Type() == cty.Number {
		b := val.AsBigFloat()
		if b.IsInt() {
			i, _ := b.Int64()
			return i
		} else {
			f, _ := b.Float64()
			return f
		}
	} else if val.Type() == cty.String {
		return val.AsString()
	} else if val.Type().IsTupleType() || val.Type().IsSetType() || val.Type().IsListType() {
		ctx := c.WithSchema(tf_resource_schemas.GetElem(c.schema))
		array := make([]interface{}, 0)
		for _, elem := range val.AsValueSlice() {
			array = append(array, ctx.RenderValue(elem))
		}
		return array
	} else if val.Type().IsMapType() || val.Type().IsObjectType() {
		object := make(map[string]interface{}, 0)
		for key, attr := range val.AsValueMap() {
			ctx := c.WithSchema(tf_resource_schemas.GetAttribute(c.schema, key))
			object[key] = ctx.RenderValue(attr)
		}
		return object
	}

	fmt.Fprintf(os.Stderr, "Unknown type: %v\n", val.Type().GoString())
	fmt.Fprintf(os.Stderr, "Wholly known: %v\n", val.HasWhollyKnownType())
	return nil
}

////////////////////////////////////////////////////////////////////////////////
// This implements the lang.Data interface on the renderContext.  Most of the
// functions we're interested in do not use lang.Data, but we can't use a `nil`.

type UnsupportedOperationDiag struct {
}

func (d UnsupportedOperationDiag) Severity() tfdiags.Severity {
	return tfdiags.Error
}

func (d UnsupportedOperationDiag) Description() tfdiags.Description {
	return tfdiags.Description{
		Summary: "Unsupported operation",
		Detail:  "This operation cannot currently be performed by regula.",
	}
}

func (d UnsupportedOperationDiag) Source() tfdiags.Source {
	return tfdiags.Source{}
}

func (d UnsupportedOperationDiag) FromExpr() *tfdiags.FromExpr {
	return nil
}

func (c *renderContext) StaticValidateReferences(refs []*addrs.Reference, self addrs.Referenceable) tfdiags.Diagnostics {
	return tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetCountAttr(addrs.CountAttr, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetForEachAttr(addrs.ForEachAttr, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetResource(addrs.Resource, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetLocalValue(addrs.LocalValue, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetModule(addrs.ModuleCall, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetPathAttr(attr addrs.PathAttr, diags tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetTerraformAttr(addrs.TerraformAttr, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *renderContext) GetInputVariable(addrs.InputVariable, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

////////////////////////////////////////////////////////////////////////////////
// utilities for traversing to a path in a HCL tree somewhat generically

// A `TfNode` represents a syntax tree in the HCL config.
type TfNode struct {
	// Exactly one of the next three fields will be set.
	Object    hcl.Body
	Array     hcl.Blocks
	Attribute *hcl.Attribute

	// This will always be set.
	Range hcl.Range
}

func (node *TfNode) GetChild(key string) (*TfNode, error) {
	child := TfNode{}

	if node.Object != nil {
		bodyContent, _, diags := node.Object.PartialContent(&hcl.BodySchema{
			Attributes: []hcl.AttributeSchema{
				{
					Name:     key,
					Required: false,
				},
			},
			Blocks: []hcl.BlockHeaderSchema{
				{
					Type: key,
				},
			},
		})
		if diags.HasErrors() {
			return nil, fmt.Errorf(diags.Error())
		}

		blocks := bodyContent.Blocks.OfType(key)
		if len(blocks) > 0 {
			child.Array = blocks
			child.Range = blocks[0].DefRange
		}

		if attribute, ok := bodyContent.Attributes[key]; ok {
			child.Attribute = attribute
			child.Range = attribute.Range
		}
	} else if node.Array != nil {
		index, err := strconv.Atoi(key)
		if err != nil {
			return nil, err
		} else {
			if index < 0 || index >= len(node.Array) {
				return nil, fmt.Errorf("TfNode.Get: out of bounds: %d", index)
			}

			child.Object = node.Array[index].Body
			child.Range = node.Array[index].DefRange
		}
	}

	return &child, nil
}

func (node *TfNode) GetDescendant(path []string) (*TfNode, error) {
	if len(path) == 0 {
		return node, nil
	}

	child, err := node.GetChild(path[0])
	if err != nil {
		return nil, err
	}

	return child.GetDescendant(path[1:])
}

func (node *TfNode) Location() string {
	return fmt.Sprintf(
		"%s:%d:%d",
		node.Range.Filename,
		node.Range.Start.Line,
		node.Range.Start.Column,
	)
}

////////////////////////////////////////////////////////////////////////////////
// utilities for traversing to a path in a HCL tree somewhat generically
// `terraform init` downloads modules and writes a helpful file
// `.terraform/modules/modules.json` that tells us where to find modules

//{"Modules":[{"Key":"","Source":"","Dir":"."},{"Key":"acm","Source":"terraform-aws-modules/acm/aws","Version":"3.0.0","Dir":".terraform/modules/acm"}]}
type terraformModuleRegister struct {
	Modules []terraformModuleRegisterEntry `json:"Modules"`
}

type terraformModuleRegisterEntry struct {
	Source string `json:"Source"`
	Dir    string `json:"Dir"`
}

func newTerraformRegister(dir string) *terraformModuleRegister {
	registry := terraformModuleRegister{
		Modules: []terraformModuleRegisterEntry{},
	}
	path := filepath.Join(dir, ".terraform/modules/modules.json")
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		return &registry
	}
	json.Unmarshal(bytes, &registry)
	for _, entry := range registry.Modules {
		fmt.Fprintf(os.Stderr, "Entry: %s -> %s", entry.Source, entry.Dir)
	}
	return &registry
}

func (r *terraformModuleRegister) getDir(source string) *string {
	for _, entry := range r.Modules {
		if entry.Source == source {
			return &entry.Dir
		}
	}
	return nil
}
