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

package rego

import (
	"encoding/json"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/types"
)

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
	configs, err := loader.LocalConfigurationLoader(options)()
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
		Paths:       []string{path},
		NoGitIgnore: false,
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

	inputType, err := loader.InputTypeFromString(inputTypeStr)
	if err != nil {
		return nil, err
	}

	path = resolvePath(path, ctx.Location.File)

	return loadToAstTerm(loader.LoadPathsOptions{
		Paths:       []string{path},
		InputTypes:  []loader.InputType{inputType},
		NoGitIgnore: false,
	})
}

func RegisterBuiltins() {
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
