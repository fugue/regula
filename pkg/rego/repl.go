package rego

import (
	_ "embed"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/bundle"
	"github.com/open-policy-agent/opa/metrics"
	"github.com/open-policy-agent/opa/repl"
	"github.com/open-policy-agent/opa/runtime"
	"github.com/open-policy-agent/opa/storage"
	"github.com/open-policy-agent/opa/storage/inmem"
)

//go:embed test_helper.rego
var testHelperRego []byte

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

func loadAstModule(fsys fs.FS, path string) (*ast.Module, error) {
	contents, err := fs.ReadFile(fsys, path)
	if err != nil {
		return nil, err
	}
	return ast.ParseModule(path, string(contents))
}

func loadDirectoryAst(fsys fs.FS, path string) (map[string]*ast.Module, error) {
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
		module, err := loadAstModule(fsys, path)
		if err != nil {
			return err
		}
		modules[path] = module
		return nil
	}
	if err := fs.WalkDir(fsys, path, walkDirFunc); err != nil {
		return nil, err
	}

	return modules, nil
}

func loadRegulaAst() (map[string]*ast.Module, error) {
	libModules, err := loadDirectoryAst(regulaLib, "lib")
	if err != nil {
		return nil, err
	}
	rulesModules, err := loadDirectoryAst(regulaRules, "rules")
	if err != nil {
		return nil, err
	}
	for k, v := range rulesModules {
		libModules[k] = v
	}
	return libModules, nil
}

func loadRegulaRaw() (map[string][]byte, error) {
	libModules, err := loadDirectoryRaw(regulaLib, "lib")
	if err != nil {
		return nil, err
	}
	rulesModules, err := loadDirectoryRaw(regulaRules, "rules")
	if err != nil {
		return nil, err
	}
	for k, v := range rulesModules {
		libModules[k] = v
	}
	libModules["test_helper.rego"] = testHelperRego
	return libModules, nil
}

func initStore(options *RuleRunnerOptions) (storage.Store, error) {
	modules, err := loadRegulaAst()
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
	c := ast.NewCompiler()
	// txn := storage.New(options.Ctx, store)
	defer store.Abort(options.Ctx, txn)
	bundleOpts := &bundle.ActivateOpts{
		Ctx:          options.Ctx,
		Store:        store,
		Txn:          txn,
		Compiler:     c,
		Metrics:      metrics.New(),
		Bundles:      map[string]*bundle.Bundle{},
		ExtraModules: modules,
	}
	if err := bundle.Activate(bundleOpts); err != nil {
		return nil, err
	}
	// if err := store.Commit(options.Ctx, txn); err != nil {
	// 	return nil, err
	// }
	return store, nil
}

func initStore2(options *RuleRunnerOptions) (storage.Store, error) {
	modules, err := loadRegulaRaw()
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

func NewREPL(options *RuleRunnerOptions) error {
	defineLoadFunction2()
	store, err := initStore2(options)
	if err != nil {
		return err
	}
	txn, err := store.NewTransaction(options.Ctx, storage.TransactionParams{
		Write: false,
	})
	defer store.Abort(options.Ctx, txn)
	if err != nil {
		return err
	}
	policies, err := store.ListPolicies(options.Ctx, txn)
	if err != nil {
		return err
	}
	fmt.Println(policies)
	// regula, err := loadRegula(options.UserOnly)
	// if err != nil {
	// 	return nil, fmt.Errorf("Failed to load Regula: %v", err)
	// }

	// includes, err := loadIncludes(options.Includes)
	// if err != nil {
	// 	return nil, fmt.Errorf("Failed to load includes: %v", err)
	// }
	// regoFuncs := []func(r *rego.Rego){rego.Store(store)}
	// regoFuncs = append(regoFuncs, regula...)
	// regoFuncs = append(regoFuncs, includes...)

	// // regoFuncs = append(regoFuncs, defineLoadFunction())
	// // regoFuncs = append(regoFuncs, )
	// regoFuncs = append(regoFuncs, rego.Query("data.fugue.regula.report"))
	// _, err = rego.New(
	// 	regoFuncs...,
	// ).PrepareForPartial(options.Ctx)
	// // _, err = query.Compile(options.Ctx, rego.CompilePartial(false))
	// if err != nil {
	// 	return nil, err
	// }

	// policies, err := store.ListPolicies(options.Ctx, txn)
	// if err != nil {
	// 	return err
	// }
	// fmt.Println(policies)

	r := repl.New(store, "./.regula-history", os.Stdout, "", 50, "foo")
	r.Loop(options.Ctx)
	return nil
}

func StartREPL(options *RuleRunnerOptions) error {
	defineLoadFunction2()
	r, err := runtime.NewRuntime(options.Ctx, runtime.Params{
		Output: os.Stdout,
	})
	if err != nil {
		return err
	}

	r.StartREPL(options.Ctx)
	return nil
}
