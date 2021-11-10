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
	"os"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/tester"
)

type RunTestOptions struct {
	Providers []RegoProvider
	Trace     bool
}

type TestsFailedError struct {
	fails int
}

func (e *TestsFailedError) Error() string {
	return fmt.Sprintf("%v tests failed", e.fails)
}

func RunTest(ctx context.Context, options *RunTestOptions) error {
	RegisterBuiltins()
	modules := map[string]*ast.Module{}
	cb := func(r RegoFile) error {
		module, err := r.AstModule()
		if err != nil {
			return err
		}
		modules[r.Path()] = module
		return nil
	}
	for _, p := range options.Providers {
		if err := p(ctx, cb); err != nil {
			return err
		}
	}
	ch, err := tester.
		NewRunner().
		SetStore(inmem.New()).
		EnableTracing(options.Trace).
		Run(ctx, modules)
	if err != nil {
		return err
	}
	dup := make(chan *tester.Result)
	fails := 0
	go func() {
		defer close(dup)
		for tr := range ch {
			if !tr.Pass() && !tr.Skip {
				fails += 1
			}
			dup <- tr
		}
	}()

	reporter := tester.PrettyReporter{
		Output:      os.Stdout,
		FailureLine: true,
		Verbose:     options.Trace,
	}
	if err := reporter.Report(dup); err != nil {
		return err
	}
	if fails > 0 {
		return &TestsFailedError{
			fails: fails,
		}
	}
	return nil
}
