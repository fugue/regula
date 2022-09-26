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

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/sirupsen/logrus"
)

const REPORT_QUERY = "data.fugue.regula.report"
const SCAN_VIEW_QUERY = "data.fugue.regula.scan_view"

type RunRulesOptions struct {
	Providers []RegoProvider
	Input     []loader.RegulaInput
	Query     string
}

func RunRules(ctx context.Context, options *RunRulesOptions) (RegoResult, error) {
	query := options.Query
	if query == "" {
		query = REPORT_QUERY
	}
	regoFuncs := []func(r *rego.Rego){
		rego.Query(query),
		rego.Runtime(RegulaRuntimeConfig()),
	}
	cb := func(r RegoFile) error {
		regoFuncs = append(regoFuncs, rego.Module(r.Path(), r.String()))
		return nil
	}
	for _, p := range options.Providers {
		if err := p(ctx, cb); err != nil {
			return nil, err
		}
	}
	regoQuery, err := rego.New(regoFuncs...).PrepareForEval(ctx)
	if err != nil {
		if regoErrors, ok := err.(rego.Errors); ok {
			for _, e := range regoErrors {
				if astError, ok := e.(*ast.Error); ok {
					logrus.Error(astError.Error())
				}
			}
		}
		return nil, fmt.Errorf("Failed to initialize OPA: %v, %t", err, err)
	}
	if err != nil {
		return nil, err
	}
	results, err := regoQuery.Eval(ctx, rego.EvalInput(options.Input))
	if err != nil {
		return nil, err
	}
	return &results[0], nil
}
