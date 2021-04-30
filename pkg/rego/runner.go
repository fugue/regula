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

// RuleRunner wraps the logic to load Regula into OPA and evaluate rules
// against an input
type RuleRunner struct {
	Ctx   context.Context
	Query rego.PreparedEvalQuery
}

// RuleRunnerOptions is a set of options to instantiate a RuleRunner object.
type RuleRunnerOptions struct {
	Ctx      context.Context
	UserOnly bool
	Includes []string
	Debug    bool
}

// NewRuleRunner instantiates a new RuleRunner
func NewRuleRunner(options *RuleRunnerOptions) (*RuleRunner, error) {
	// paths := append(options.RulesDirs, options.LibraryDir)
	regula, err := loadRegula(options.UserOnly)
	if err != nil {
		return nil, fmt.Errorf("Failed to load Regula: %v", err)
	}

	includes, err := loadIncludes(options.Includes)
	if err != nil {
		return nil, fmt.Errorf("Failed to load includes: %v", err)
	}
	regoFuncs := append(regula, includes...)
	regoFuncs = append(regoFuncs, rego.Query("data.fugue.regula.report"))
	query, err := rego.New(
		regoFuncs...,
	).PrepareForEval(options.Ctx)

	if err != nil {
		return nil, fmt.Errorf("Failed to initialize OPA: %v", err)
	}

	return &RuleRunner{
		Ctx:   options.Ctx,
		Query: query,
	}, nil
}

// Run evaluates rules against an input.
func (r *RuleRunner) Run(input []loader.RegulaInput) (rego.ResultSet, error) {
	results, err := r.Query.Eval(r.Ctx, rego.EvalInput(input))

	if err != nil {
		return nil, fmt.Errorf("Failed to evaluate against input: %v", err)
	}

	return results, nil
}
