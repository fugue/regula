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
	"strings"

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/sirupsen/logrus"
)

const REPORT_QUERY = "data.fugue.regula.report"
const SCAN_VIEW_QUERY = "data.fugue.regula.scan_view"

type RunRulesOptions struct {
	Providers []RegoProvider
	Input     []loader.RegulaInput
	Query     string
}

type RunRulesTracer struct {
}

func (t *RunRulesTracer) Enabled() bool {
	return true
}

func (t *RunRulesTracer) TraceEvent(e topdown.Event) {
	if e.Op != topdown.EvalOp {
		return
	}

	if strings.HasPrefix(e.Location.File, "lib/fugue") {
		return
	}

	if expr, ok := e.Node.(*ast.Expr); ok {
		// if term, ok := expr.Terms.(*ast.Term); ok {
		// 	if ref, ok := term.Value.(ast.Ref); ok {
		// 		logrus.Info(ref)
		// 	}
		// } else if terms, ok := expr.Terms.([]*ast.Term); ok {
		// 	for _, t := range terms {
		// 		if ref, ok := t.Value.(ast.Ref); ok {
		// 			for _, t := range ref {
		// 				if t.Equal(ast.InputRootDocument) {
		// 					logrus.Info(ref.String())
		// 				}
		// 			}
		// 		}
		// 	}
		// }

		if terms, ok := expr.Terms.([]*ast.Term); ok {
			for _, t := range terms {
				if ref, ok := t.Value.(ast.Ref); ok {
					for _, t := range ref {
						if t.Equal(ast.InputRootDocument) {
							logrus.Infof("%s accessed %s", e.Location.File, ref.String())
						}
					}
				}
			}
		}
	}
}

func (t *RunRulesTracer) Config() topdown.TraceConfig {
	return topdown.TraceConfig{
		PlugLocalVars: true,
	}
}

func RunRules(ctx context.Context, options *RunRulesOptions) (RegoResult, error) {
	query := options.Query
	if query == "" {
		query = REPORT_QUERY
	}
	regoFuncs := []func(r *rego.Rego){
		// rego.QueryTracer(&RunRulesTracer{}),
		rego.Query(query),
		rego.Runtime(RegulaRuntimeConfig()),
	}
	modules := make(map[string]*ast.Module, len(options.Providers))
	cb := func(r RegoFile) error {
		mod, err := r.AstModule()
		if err != nil {
			return err
		}
		modules[r.Path()] = mod
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
					module := regoQuery.Modules()[astError.Location.File]
					logrus.Info(module.String())
				}
			}
		}
		return nil, fmt.Errorf("Failed to initialize OPA: %v, %t", err, err)
	}
	if err != nil {
		return nil, err
	}
	// results, err := regoQuery.Eval(ctx, rego.EvalInput(options.Input), rego.EvalQueryTracer(newEvalTracer(modules)))
	results, err := regoQuery.Eval(ctx, rego.EvalInput(options.Input), rego.EvalQueryTracer(newInputTracer()))
	if err != nil {
		return nil, err
	}
	return &results[0], nil
}
