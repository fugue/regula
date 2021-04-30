package rego

import (
	"embed"
	"encoding/json"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/types"
)

//go:embed lib
var regulaLib embed.FS

//go:embed rules
var regulaRules embed.FS

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

func defineLoadFunction() func(r *rego.Rego) {
	return rego.Function1(
		&rego.Function{
			Name: "regula.load",
			Decl: types.NewFunction(types.Args(types.S), types.A),
		},
		func(_ rego.BuiltinContext, a *ast.Term) (*ast.Term, error) {
			if str, ok := a.Value.(ast.String); ok {
				path := string(str)
				configs, err := loader.LoadPaths(loader.LoadPathsOptions{
					Paths:     []string{path},
					InputType: loader.Auto,
					NoIgnore:  false,
				})
				if err != nil {
					return nil, err
				}

				v, err := ast.InterfaceToValue(configs.RegulaInput())
				if err != nil {
					return nil, err
				}

				return ast.NewTerm(v), nil
			}
			return nil, nil
		},
	)
}

func defineLoadFunction2() {
	rego.RegisterBuiltin1(
		&rego.Function{
			Name:    "regula.load",
			Decl:    types.NewFunction(types.Args(types.S), types.A),
			Memoize: true,
		},
		func(_ rego.BuiltinContext, a *ast.Term) (*ast.Term, error) {
			var path string
			if err := ast.As(a.Value, &path); err != nil {
				return nil, err
			}

			configs, err := loader.LoadPaths(loader.LoadPathsOptions{
				Paths:     []string{path},
				InputType: loader.Auto,
				NoIgnore:  false,
			})
			if err != nil {
				return nil, err
			}

			// testVal := map[string]string{
			// 	"foo": "bar",
			// }
			testVal := []interface{}{}

			bts, _ := json.Marshal(configs.RegulaInput())
			_ = json.Unmarshal(bts, &testVal)

			// v, err := ast.InterfaceToValue(configs.RegulaInput())
			v, err := ast.InterfaceToValue(testVal)
			if err != nil {
				return nil, err
			}

			return ast.NewTerm(v), nil
		},
	)
}

type osFs struct{}

func (o osFs) Open(name string) (fs.File, error) {
	f, err := os.Open(name)
	if err != nil {
		return nil, err
	}
	return f, nil
}
