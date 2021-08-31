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
	"github.com/sirupsen/logrus"
	"github.com/spf13/afero"
	"github.com/zclconf/go-cty/cty"

	"tf_resource_schemas"
)

type TfDetector struct{}

func (t *TfDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if !opts.IgnoreExt && i.Ext() != ".tf" {
		return nil, fmt.Errorf("Expected a .tf extension for %s", i.Path())
	}
	dir := filepath.Dir(i.Path())

	var inputFs afero.Fs
	var err error
	if i.Path() == stdIn {
		inputFs, err = makeStdInFs(i)
		if err != nil {
			return nil, err
		}
	}

	return parseFiles([]string{}, dir, nil, false, []string{i.Path()}, inputFs)
}

func (t *TfDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	if opts.IgnoreDirs {
		return nil, nil
	}
	// First check that a `.tf` file exists in the directory.
	tfExists := false
	for _, child := range i.Children() {
		if c, ok := child.(InputFile); ok && c.Ext() == ".tf" {
			tfExists = true
		}
	}
	if !tfExists {
		return nil, nil
	}

	configuration, err := ParseDirectory([]string{}, i.Path(), nil)

	if err != nil {
		return nil, err
	}

	if configuration != nil && len(configuration.missingRemoteModules) > 0 {
		logrus.Warn(
			missingRemoteModulesMessage(
				i.Path(),
				configuration.missingRemoteModules,
			),
		)
	}

	return configuration, nil
}

func missingRemoteModulesMessage(inputPath string, missingModules []string) string {
	missingModulesList := strings.Join(missingModules, ", ")
	firstSentence := "Could not load some remote submodules"
	if inputPath != "." {
		firstSentence += fmt.Sprintf(
			" that are used by '%s'",
			inputPath,
		)
	}
	return fmt.Sprintf(
		"%s. Run 'terraform init' if you would like to include them in the evaluation: %s",
		firstSentence,
		missingModulesList,
	)
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

	// Cached values of locals.
	locals map[string]interface{}

	// Locations of terraform modules.
	moduleRegister *terraformModuleRegister

	// Location at which this module was included (i.e. the caller of this
	// module.
	location *Location

	// Remote modules that were missing from the moduleRegister
	missingRemoteModules []string
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

	// ConfigDirFiles will return `main.tf` rather than `foo/bar/../../main.tf`.
	// Rejoin the files using `TfFilePathJoin` to fix this.
	filepaths := make([]string, len(primary))
	for i, file := range primary {
		filepaths[i] = TfFilePathJoin(dir, filepath.Base(file))
	}

	return parseFiles(path, dir, moduleRegister, true, filepaths, nil)
}

func parseFiles(
	path []string,
	dir string,
	moduleRegister *terraformModuleRegister,
	recurse bool,
	filepaths []string,
	parserFs afero.Fs,
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

	parser := configs.NewParser(parserFs)
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
		logrus.Warn(diags.Error())
	}
	if configuration.module == nil {
		// Only actually throw an error if we don't have a module.  We can
		// still try and validate what we can.
		return nil, fmt.Errorf(diags.Error())
	}

	configuration.schemas = tf_resource_schemas.LoadResourceSchemas()

	// We're evaluating a few things but here, like the source attribute, and
	// the values of default variables.  We do this with a minimal context
	// that doesn't have any variables itself.
	ctx := renderContext{
		dir:     dir,
		resolve: func(path []string) interface{} { return nil },
	}

	// Load children
	configuration.children = make(map[string]*HclConfiguration)
	if recurse {
		for key, moduleCall := range module.ModuleCalls {
			logrus.Debugf("Loading submodule %s", key)
			body, ok := moduleCall.Config.(*hclsyntax.Body)
			if ok {
				properties := ctx.RenderBody(body)
				if source, ok := properties["source"]; ok {
					if str, ok := source.(string); ok {
						childDir := TfFilePathJoin(dir, str)
						if register := configuration.moduleRegister.getDir(str); register != nil {
							childDir = *register
						} else if !moduleIsLocal(str) {
							logrus.Debugf("Remote submodule missing from registry '%s'", str)
							configuration.missingRemoteModules = append(
								configuration.missingRemoteModules,
								str,
							)
							continue
						}
						logrus.Debugf("Loading source from %s", childDir)

						// Construct child path, e.g. `module.child1.aws_vpc.child`.
						childPath := make([]string, len(configuration.path))
						copy(childPath, path)
						childPath = append(childPath, "module")
						childPath = append(childPath, key)

						child, err := ParseDirectory(childPath, childDir, configuration.moduleRegister)

						if err == nil {
							child = child.withLocation(rangeToLocation(moduleCall.SourceAddrRange))
							configuration.children[key] = child
							configuration.missingRemoteModules = append(
								configuration.missingRemoteModules,
								child.missingRemoteModules...,
							)
						} else {
							logrus.Warnf("Error loading submodule '%s': %s", key, err)
						}
					}
				}
			}
		}
	}

	configuration.childrenVars = make(map[string]map[string]interface{})

	configuration.vars = make(map[string]interface{})
	for k, variable := range module.Variables {
		if !variable.Default.IsNull() {
			val := ctx.RenderValue(variable.Default)
			configuration.vars[k] = val
			logrus.Debugf("Setting default value for %s -> %v", k, val)
		}
	}

	configuration.locals = nil

	return configuration, nil
}

// Takes a module source and returns true if the module is local.
func moduleIsLocal(source string) bool {
	// Relevant bit from terraform docs:
	//    A local path must begin with either ./ or ../ to indicate that a local path
	//    is intended, to distinguish from a module registry address.
	return strings.HasPrefix(source, "./") || strings.HasPrefix(source, "../")
}

// Return a copy of a HclConfiguration with updated variables.
func (c0 *HclConfiguration) withVars(vars map[string]interface{}) *HclConfiguration {
	c1 := *c0
	c1.vars = make(map[string]interface{})
	for k, v := range c0.vars {
		c1.vars[k] = v // Set defaults
	}
	for k, v := range vars {
		c1.vars[k] = v // Set overrides
	}
	c1.locals = nil // Needs to be recomputed.
	return &c1
}

// Set the source code location at which a module was included.
func (c0 *HclConfiguration) withLocation(location Location) *HclConfiguration {
	c1 := *c0
	c1.location = &location
	return &c1
}

func (c *HclConfiguration) LoadedFiles() []string {
	filepaths := []string{filepath.Join(c.dir, ".terraform")}
	if c.recurse {
		filepaths = append(filepaths, c.dir)
	}
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

func (c *HclConfiguration) Location(path []string) (LocationStack, error) {
	if len(path) < 1 {
		return nil, nil
	}
	resourceId := path[0]
	attributePath := path[1:]

	// Find location recursively
	if strings.HasPrefix(resourceId, "module.") {
		resourcePath := strings.SplitN(resourceId, ".", 3)
		if len(resourcePath) < 3 {
			return nil, nil
		}
		child := c.children[resourcePath[1]]
		childPath := make([]string, len(path))
		copy(childPath, path)
		childPath[0] = resourcePath[2]
		loc, err := child.Location(childPath)
		if err != nil || loc == nil {
			return loc, err
		}
		if child.location != nil {
			loc = append(loc, *child.location)
		}

		return loc, nil
	}

	// Find location in this module
	if resource, ok := c.getResource(resourceId); ok {
		resourceNode := TfNode{Object: resource.Config, Range: resource.DeclRange}
		if node, err := resourceNode.GetDescendant(attributePath); err == nil {
			return []Location{rangeToLocation(node.Range)}, nil
		}
	}

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
		if r := c.renderResource(resourceId, resource); r != nil {
			resources[resourceId] = r
		}
	}
	for resourceId, resource := range c.module.DataResources {
		resourceId = c.qualifiedResourceId(resourceId)
		if r := c.renderResource(resourceId, resource); r != nil {
			resources[resourceId] = r
		}
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

func renderResourceType(r *configs.Resource) string {
	if r.Mode == addrs.DataResourceMode {
		return "data." + r.Type
	}

	return r.Type
}

func (c *HclConfiguration) renderResource(
	resourceId string, resource *configs.Resource,
) interface{} {
	context := c.renderContext(resourceId)
	context.schema = c.schemas[resource.Type]

	// Skip resources if `count = 0`
	if resource.Count != nil {
		count := context.EvaluateExpr(resource.Count)
		if n, ok := count.(int64); ok && n == 0 {
			logrus.Debugf("Skipping resource %s (count=0)", resourceId)
			return nil
		}
	}

	properties := make(map[string]interface{})
	properties["_type"] = renderResourceType(resource)
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
		properties["_provider"] = formatProvider(provider)
		delete(properties, "provider")
	} else {
		properties["_provider"] = formatProvider(resource.Provider.ForDisplay())
	}

	properties["_filepath"] = resource.DeclRange.Filename

	return properties
}

func formatProvider(provider interface{}) interface{} {
	p, ok := provider.(string)
	if !ok {
		return provider
	}
	split := strings.Split(p, "/")
	return split[len(split)-1]
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
			logrus.Debugf("Found output: %s -> %s", path, out)
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
	ctx := renderContext{
		dir:     c.dir,
		vars:    c.vars,
		locals:  c.locals,
		resolve: func(path []string) interface{} { return c.resolveResourceReference(self, path) },
	}

	if ctx.locals == nil {
		ctx.locals = make(map[string]interface{})
		for k, local := range c.module.Locals {
			ctx.locals[k] = ctx.EvaluateExpr(local.Expr)
		}
		c.locals = ctx.locals
	}

	return ctx
}

// This is a structure passed down that contains all additional information
// apart from the thing being rendered, which is passed separately.
type renderContext struct {
	dir     string
	schema  *tf_resource_schemas.Schema
	vars    map[string]interface{}
	locals  map[string]interface{}
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
		return c.resolve(path)
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
				if kty := reflect.TypeOf(key); kty != nil {
					logrus.Warnf("Skipping non-string object key: %s", kty.String())
				} else {
					// This can happen in the initial load before the variable defaults
					// have been populated.
					logrus.Debug("Skipping object key of unknown type")
				}
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
	case *hclsyntax.ParenthesesExpr:
		return c.RenderExpr(e.Expression)
	case *hclsyntax.FunctionCallExpr:
		// This is handled using evaluation.
	default:
		if ty := reflect.TypeOf(expr); ty != nil {
			logrus.Debugf("Unhandled expression type %s at %s, falling back to evaluation", ty.String(), e.Range())
		} else {
			logrus.Debug("Unknown expression type, falling back to evaluation")
		}
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
		"var":   makeValue(c.vars),
		"local": makeValue(c.locals),
	}
	ctx := hcl.EvalContext{
		Functions: scope.Functions(),
		Variables: vars,
	}

	val, err := expr.Value(&ctx)
	if err != nil {
		logrus.Debugf("Evaluation error: %s", err)
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
	if !val.IsKnown() || val.IsNull() {
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

	logrus.Debugf("Unhandled value type: %v\n", val.Type().GoString())
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

func (c *renderContext) GetInputVariable(v addrs.InputVariable, s tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
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

////////////////////////////////////////////////////////////////////////////////
// utilities for traversing to a path in a HCL tree somewhat generically
// `terraform init` downloads modules and writes a helpful file
// `.terraform/modules/modules.json` that tells us where to find modules

//{"Modules":[{"Key":"","Source":"","Dir":"."},{"Key":"acm","Source":"terraform-aws-modules/acm/aws","Version":"3.0.0","Dir":".terraform/modules/acm"}]}

type terraformModuleRegister struct {
	data terraformModuleRegisterFile
	dir  string
}

type terraformModuleRegisterFile struct {
	Modules []terraformModuleRegisterEntry `json:"Modules"`
}

type terraformModuleRegisterEntry struct {
	Source string `json:"Source"`
	Dir    string `json:"Dir"`
}

func newTerraformRegister(dir string) *terraformModuleRegister {
	registry := terraformModuleRegister{
		data: terraformModuleRegisterFile{
			[]terraformModuleRegisterEntry{},
		},
		dir: dir,
	}
	path := filepath.Join(dir, ".terraform/modules/modules.json")
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		return &registry
	}
	json.Unmarshal(bytes, &registry.data)
	logrus.Debugf("Loaded module register at %s", path)
	for _, entry := range registry.data.Modules {
		logrus.Debugf("Module register entry: %s -> %s", entry.Source, entry.Dir)
	}
	return &registry
}

func (r *terraformModuleRegister) getDir(source string) *string {
	for _, entry := range r.data.Modules {
		if entry.Source == source {
			joined := TfFilePathJoin(r.dir, entry.Dir)
			return &joined
		}
	}
	return nil
}

////////////////////////////////////////////////////////////////////////////////
// Utility for converting from regula go structures to `cty.Value`

func makeValue(val interface{}) cty.Value {
	if val == nil {
		return cty.NullVal(cty.DynamicPseudoType)
	}
	switch v := val.(type) {
	case string:
		return cty.StringVal(v)
	case bool:
		return cty.BoolVal(v)
	case float32:
		return cty.NumberFloatVal(float64(v))
	case float64:
		return cty.NumberFloatVal(v)
	case int:
		return cty.NumberIntVal(int64(v))
	case int32:
		return cty.NumberIntVal(int64(v))
	case int64:
		return cty.NumberIntVal(v)
	case []interface{}:
		arr := make([]cty.Value, len(v))
		for i, x := range v {
			arr[i] = makeValue(x)
		}
		return cty.TupleVal(arr)
	case map[string]interface{}:
		if len(v) == 0 {
			return cty.EmptyObjectVal
		} else {
			obj := make(map[string]cty.Value)
			for k, x := range v {
				obj[k] = makeValue(x)
			}
			return cty.ObjectVal(obj)
		}
	}
	return cty.UnknownVal(cty.DynamicPseudoType)
}

func makeStdInFs(i InputFile) (afero.Fs, error) {
	contents, err := i.Contents()
	if err != nil {
		return nil, err
	}
	inputFs := afero.NewMemMapFs()
	afero.WriteFile(inputFs, i.Path(), contents, 0644)
	return inputFs, nil
}

func rangeToLocation(r hcl.Range) Location {
	return Location{
		Path: r.Filename,
		Line: r.Start.Line,
		Col:  r.Start.Column,
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
