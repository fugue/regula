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
	"context"
	"fmt"

	"github.com/fugue/regula/pkg/loader"
	"github.com/open-policy-agent/opa/rego"
)

// RunRulesOptions is the set of options for RunRules
type ScanViewOptions struct {
	Ctx      context.Context
	UserOnly bool
	Includes []string
	Input    []loader.RegulaInput
}

// RunRules runs regula and user-specified rules on loaded inputs
func ScanView(options *ScanViewOptions) (*rego.Result, error) {
	RegisterBuiltins()
	query, err := prepareScanView(options.Ctx, options.UserOnly, options.Includes)
	if err != nil {
		return nil, err
	}
	results, err := query.Eval(options.Ctx, rego.EvalInput(options.Input))
	if err != nil {
		return nil, err
	}
	return &results[0], nil
}

func prepareScanView(ctx context.Context, userOnly bool, includes []string) (*rego.PreparedEvalQuery, error) {
	regoFuncs := []func(r *rego.Rego){
		rego.Query("data.fugue.scan_view.scan_view"),
	}
	cb := func(r RegoFile) error {
		regoFuncs = append(regoFuncs, rego.Module(r.Path(), r.String()))
		return nil
	}
	if err := LoadRegula(userOnly, cb); err != nil {
		return nil, err
	}
	if err := LoadOSFiles(includes, cb); err != nil {
		return nil, err
	}
	query, err := rego.New(regoFuncs...).PrepareForEval(ctx)
	if err != nil {
		return nil, fmt.Errorf("Failed to initialize OPA: %v", err)
	}
	return &query, nil
}
