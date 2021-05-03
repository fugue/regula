package rego

import (
	"context"
	"embed"
	"encoding/json"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/storage"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/types"
)

//go:embed lib
var regulaLib embed.FS

//go:embed rules
var regulaRules embed.FS

//go:embed test_helper.rego
var testHelperRego []byte

var loadExts map[string]bool = map[string]bool{
	".rego": true,
	".yaml": true,
	".yml":  true,
	".json": true,
}

func loadModule(fsys fs.FS, path string) (func(r *rego.Rego), error) {
	contents, err := fs.ReadFile(fsys, path)
	if err != nil {
		return nil, err
	}
	return rego.Module(path, string(contents)), nil
}

func loadDirectory(fsys fs.FS, path string) ([]func(r *rego.Rego), error) {
	modules := []func(r *rego.Rego){}
	walkDirFunc := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		if ext := filepath.Ext(path); !loadExts[ext] {
			return nil
		}
		module, err := loadModule(fsys, path)
		if err != nil {
			return err
		}
		modules = append(modules, module)
		return nil
	}

	if err := fs.WalkDir(fsys, path, walkDirFunc); err != nil {
		return nil, err
	}

	return modules, nil
}

func loadIncludesAst(includes []string) (map[string]*ast.Module, error) {
	modules := map[string]*ast.Module{}
	walkDirFunc := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		if ext := filepath.Ext(path); !loadExts[ext] {
			return nil
		}
		contents, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		module, err := ast.ParseModule(path, string(contents))
		if err != nil {
			return err
		}
		modules[path] = module
		return nil
	}
	for _, path := range includes {
		info, err := os.Stat(path)
		if err != nil {
			return nil, err
		}
		if info.IsDir() {
			if err := filepath.WalkDir(path, walkDirFunc); err != nil {
				return nil, err
			}
			continue
		}
		contents, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		module, err := ast.ParseModule(path, string(contents))
		if err != nil {
			return nil, err
		}
		modules[path] = module
	}
	return modules, nil
}

func loadIncludes(includes []string) ([]func(r *rego.Rego), error) {
	modules := []func(r *rego.Rego){}
	o := osFs{}
	for _, path := range includes {
		info, err := fs.Stat(o, path)
		if err != nil {
			return nil, err
		}
		if info.IsDir() {
			dirModules, err := loadDirectory(o, path)
			if err != nil {
				return nil, err
			}

			modules = append(modules, dirModules...)
			continue
		}
		if ext := filepath.Ext(path); !loadExts[ext] {
			return nil, fmt.Errorf("Unsupported file type %v in includes: %v", ext, path)
		}
		module, err := loadModule(o, path)
		if err != nil {
			return nil, err
		}
		if module != nil {
			modules = append(modules, module)
		}
	}

	return modules, nil
}

func loadRegula(userOnly bool) ([]func(r *rego.Rego), error) {
	modules, err := loadDirectory(regulaLib, "lib")
	if err != nil {
		return nil, err
	}

	if !userOnly {
		rules, err := loadDirectory(regulaRules, "rules")
		if err != nil {
			return nil, err
		}
		modules = append(modules, rules...)
	}
	return modules, nil
}

func loadDirectoryRaw(fsys fs.FS, path string) (map[string][]byte, error) {
	modules := map[string][]byte{}
	walkDirFunc := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		if ext := filepath.Ext(path); !loadExts[ext] {
			return nil
		}
		raw, err := fs.ReadFile(fsys, path)
		if err != nil {
			return err
		}
		modules[path] = raw
		return nil
	}
	if err := fs.WalkDir(fsys, path, walkDirFunc); err != nil {
		return nil, err
	}

	return modules, nil
}

func loadRegulaRaw(userOnly bool) (map[string][]byte, error) {
	libModules, err := loadDirectoryRaw(regulaLib, "lib")
	if err != nil {
		return nil, err
	}
	if !userOnly {
		rulesModules, err := loadDirectoryRaw(regulaRules, "rules")
		if err != nil {
			return nil, err
		}
		for k, v := range rulesModules {
			libModules[k] = v
		}
	}
	libModules["test_helper.rego"] = testHelperRego
	return libModules, nil
}

func resolvePath(path, location string) string {
	if !filepath.IsAbs(path) {
		if location == "" {
			location = "."
		} else {
			location = filepath.Dir(location)
		}
		path = filepath.Join(location, path)
	}
	return path
}

func loadToAstTerm(options loader.LoadPathsOptions) (*ast.Term, error) {
	configs, err := loader.LoadPaths(options)
	if err != nil {
		return nil, err
	}

	parseable := []interface{}{}

	raw, _ := json.Marshal(configs.RegulaInput())
	_ = json.Unmarshal(raw, &parseable)

	v, err := ast.InterfaceToValue(parseable)
	if err != nil {
		return nil, err
	}

	return ast.NewTerm(v), nil
}

func regulaLoad(ctx rego.BuiltinContext, a *ast.Term) (*ast.Term, error) {
	var path string
	if err := ast.As(a.Value, &path); err != nil {
		return nil, err
	}

	path = resolvePath(path, ctx.Location.File)

	return loadToAstTerm(loader.LoadPathsOptions{
		Paths:     []string{path},
		InputType: loader.Auto,
		NoIgnore:  false,
	})
}

func regulaLoadType(ctx rego.BuiltinContext, a *ast.Term, b *ast.Term) (*ast.Term, error) {
	var path string
	var inputTypeStr string
	if err := ast.As(a.Value, &path); err != nil {
		return nil, err
	}
	if err := ast.As(b.Value, &inputTypeStr); err != nil {
		return nil, err
	}

	var inputType loader.InputType
	switch inputTypeStr {
	case "cfn":
		inputType = loader.Cfn
	case "tf-plan":
		inputType = loader.TfPlan
	default:
		return nil, fmt.Errorf("Unrecognized input type %v", inputTypeStr)
	}

	path = resolvePath(path, ctx.Location.File)

	return loadToAstTerm(loader.LoadPathsOptions{
		Paths:     []string{path},
		InputType: inputType,
		NoIgnore:  false,
	})
}

func defineLoadFunction() {
	rego.RegisterBuiltin1(
		&rego.Function{
			Name:    "regula_load",
			Decl:    types.NewFunction(types.Args(types.S), types.A),
			Memoize: true,
		},
		regulaLoad,
	)
	rego.RegisterBuiltin2(
		&rego.Function{
			Name:    "regula_load_type",
			Decl:    types.NewFunction(types.Args(types.S, types.S), types.A),
			Memoize: true,
		},
		regulaLoadType,
	)
}

type InitStoreOptions struct {
	Ctx      context.Context
	UserOnly bool
}

func initStore(options *InitStoreOptions) (storage.Store, error) {
	modules, err := loadRegulaRaw(options.UserOnly)
	if err != nil {
		return nil, err
	}
	store := inmem.New()
	txn, err := store.NewTransaction(options.Ctx, storage.TransactionParams{
		Write: true,
	})
	if err != nil {
		return nil, err
	}
	// defer store.Abort(options.Ctx, txn)
	for path, raw := range modules {
		if err := store.UpsertPolicy(options.Ctx, txn, path, raw); err != nil {
			return nil, err
		}
	}
	if err := store.Commit(options.Ctx, txn); err != nil {
		return nil, err
	}
	return store, nil
}

type osFs struct{}

func (o osFs) Open(name string) (fs.File, error) {
	f, err := os.Open(name)
	if err != nil {
		return nil, err
	}
	return f, nil
}
