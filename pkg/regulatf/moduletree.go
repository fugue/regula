// This module contains utilities for parsing and traversing everything in a
// configuration tree.
package regulatf

import (
	"fmt"
	"path/filepath"
	"strings"

	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/sirupsen/logrus"
	"github.com/spf13/afero"
	"github.com/zclconf/go-cty/cty"

	"github.com/fugue/regula/v2/pkg/terraform/configs"
)

type ModuleMeta struct {
	Dir                  string
	Recurse              bool
	Filepaths            []string
	MissingRemoteModules []string
	Location             *hcl.Range
}

type ResourceMeta struct {
	Data     bool
	Type     string
	Provider string
	Count    bool
	Location hcl.Range
}

// We load the entire tree of submodules in one pass.
type ModuleTree struct {
	meta     *ModuleMeta
	config   *hclsyntax.Body // Call to the module, nil if root.
	module   *configs.Module
	children map[string]*ModuleTree
}

func ParseDirectory(
	moduleRegister *TerraformModuleRegister,
	parserFs afero.Fs,
	dir string,
) (*ModuleTree, error) {
	parser := configs.NewParser(parserFs)
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

	return ParseFiles(moduleRegister, parserFs, true, dir, filepaths)
}

func ParseFiles(
	moduleRegister *TerraformModuleRegister,
	parserFs afero.Fs,
	recurse bool,
	dir string,
	filepaths []string,
) (*ModuleTree, error) {
	meta := &ModuleMeta{
		Dir:       dir,
		Recurse:   recurse,
		Filepaths: filepaths,
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
	diags = append(diags, lDiags...)
	if diags.HasErrors() {
		logrus.Warn(diags.Error())
	}
	if module == nil {
		// Only actually throw an error if we don't have a module.  We can
		// still try and validate what we can.
		return nil, fmt.Errorf(diags.Error())
	}

	children := map[string]*ModuleTree{}
	if recurse {
		for key, moduleCall := range module.ModuleCalls {
			if body, ok := moduleCall.Config.(*hclsyntax.Body); ok {
				if attr, ok := body.Attributes["source"]; ok {
					if val, err := attr.Expr.Value(nil); err == nil && val.Type() == cty.String {
						source := val.AsString()
						childDir := TfFilePathJoin(dir, source)

						if register := moduleRegister.GetDir(source); register != nil {
							childDir = *register
						} else if !moduleIsLocal(source) {
							logrus.Debugf("Remote submodule missing from registry '%s'", source)
							meta.MissingRemoteModules = append(
								meta.MissingRemoteModules,
								source,
							)
							continue
						}
						logrus.Debugf("Loading source from %s", childDir)

						child, err := ParseDirectory(moduleRegister, parserFs, childDir)
						if err == nil {
							child.meta.Location = &moduleCall.SourceAddrRange
							child.config = body
							children[key] = child
						} else {
							logrus.Warnf("Error loading submodule '%s': %s", key, err)
						}
					}
				}
			}
		}
	}

	return &ModuleTree{meta, nil, module, children}, nil
}

func (mtree *ModuleTree) Warnings() []string {
	warnings := []string{}

	missingModules := mtree.meta.MissingRemoteModules
	if len(missingModules) > 0 {
		missingModulesList := strings.Join(missingModules, ", ")
		firstSentence := "Could not load some remote submodules"
		if mtree.meta.Dir != "." {
			firstSentence += fmt.Sprintf(
				" that are used by '%s'",
				mtree.meta.Dir,
			)
		}

		warnings = append(warnings, fmt.Sprintf(
			"%s. Run 'terraform init' if you would like to include them in the evaluation: %s",
			firstSentence,
			missingModulesList,
		))
	}

	for _, child := range mtree.children {
		warnings = append(warnings, child.Warnings()...)
	}

	return warnings
}

func (mtree *ModuleTree) FilePath() string {
	if mtree.meta.Recurse {
		return mtree.meta.Dir
	} else {
		return mtree.meta.Filepaths[0]
	}
}

func (mtree *ModuleTree) LoadedFiles() []string {
	filepaths := []string{filepath.Join(mtree.meta.Dir, ".terraform")}
	if mtree.meta.Recurse {
		filepaths = append(filepaths, mtree.meta.Dir)
	}
	for _, fp := range mtree.meta.Filepaths {
		filepaths = append(filepaths, fp)
	}
	for _, child := range mtree.children {
		if child != nil {
			filepaths = append(filepaths, child.LoadedFiles()...)
		}
	}
	return filepaths
}

// Takes a module source and returns true if the module is local.
func moduleIsLocal(source string) bool {
	// Relevant bit from terraform docs:
	//    A local path must begin with either ./ or ../ to indicate that a local path
	//    is intended, to distinguish from a module registry address.
	return strings.HasPrefix(source, "./") || strings.HasPrefix(source, "../")
}

type Visitor interface {
	VisitModule(name ModuleName, meta *ModuleMeta)
	EnterResource(name FullName, resource *ResourceMeta)
	LeaveResource()
	VisitBlock(name FullName)
	VisitExpr(name FullName, expr hcl.Expression)
}

func (mtree *ModuleTree) Walk(v Visitor) {
	walkModuleTree(v, EmptyModuleName, mtree)
}

func walkModuleTree(v Visitor, moduleName ModuleName, mtree *ModuleTree) {
	v.VisitModule(moduleName, mtree.meta)
	walkModule(v, moduleName, mtree.module)
	for key, child := range mtree.children {
		childModuleName := make([]string, len(moduleName)+1)
		copy(childModuleName, moduleName)
		childModuleName[len(moduleName)] = key

		// TODO: This is not good.  We end up walking child2 as it were child2.
		configName := FullName{moduleName, LocalName{"input", key}}
		walkBlock(v, configName, child.config)

		walkModuleTree(v, childModuleName, child)
	}
}

func walkModule(v Visitor, moduleName ModuleName, module *configs.Module) {
	name := EmptyFullName(moduleName)

	for _, variable := range module.Variables {
		if !variable.Default.IsNull() {
			expr := hclsyntax.LiteralValueExpr{
				Val:      variable.Default,
				SrcRange: variable.DeclRange,
			}
			v.VisitExpr(name.AddKey("variable").AddKey(variable.Name), &expr)
		}
	}

	for _, local := range module.Locals {
		v.VisitExpr(name.AddKey("local").AddKey(local.Name), local.Expr)
	}

	for _, resource := range module.DataResources {
		walkResource(v, moduleName, resource, true)
	}

	for _, resource := range module.ManagedResources {
		walkResource(v, moduleName, resource, false)
	}

	for _, output := range module.Outputs {
		v.VisitExpr(name.AddKey("output").AddKey(output.Name), output.Expr)
	}
}

func walkResource(v Visitor, moduleName ModuleName, resource *configs.Resource, isDataResource bool) {
	name := EmptyFullName(moduleName)
	if isDataResource {
		name = name.AddKey("data")
	}
	name = name.AddKey(resource.Type).AddKey(resource.Name)
	haveCount := resource.Count != nil

	resourceMeta := &ResourceMeta{
		Data:     isDataResource,
		Provider: resource.Provider.Type,
		Type:     resource.Type,
		Location: resource.DeclRange,
		Count:    haveCount,
	}
	v.EnterResource(name, resourceMeta)

	if haveCount {
		name = name.AddIndex(0)
		v.VisitExpr(name.AddKey("count"), resource.Count)
	}

	body, ok := resource.Config.(*hclsyntax.Body)
	if !ok {
		logrus.Warningf("Missing body for resource %s", name.ToString())
		return
	}

	walkBlock(v, name, body)
	v.LeaveResource()
}

func walkBlock(v Visitor, name FullName, body *hclsyntax.Body) {
	v.VisitBlock(name)

	for _, attribute := range body.Attributes {
		v.VisitExpr(name.AddKey(attribute.Name), attribute.Expr)
	}

	blockCounter := map[string]int{} // Which index we're at per block type.
	for _, block := range body.Blocks {
		idx := 0
		if i, ok := blockCounter[block.Type]; ok {
			idx = i
			blockCounter[block.Type] += 1
		} else {
			blockCounter[block.Type] = 1
		}
		walkBlock(v, name.AddKey(block.Type).AddIndex(idx), block.Body)
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
