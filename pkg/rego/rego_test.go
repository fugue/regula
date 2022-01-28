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

package rego_test

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/fugue/regula/v2/pkg/rego"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/tester"
	"github.com/stretchr/testify/assert"
)

func formatFailedTest(r *tester.Result) string {
	return fmt.Sprintf("%s.%s in file %s", r.Package, r.Name, r.Location.String())
}

func runRegoTest(t *testing.T, providers []rego.RegoProvider) {
	rego.RegisterBuiltins()
	modules := map[string]*ast.Module{}
	cb := func(r rego.RegoFile) error {
		module, err := r.AstModule()
		if err != nil {
			return err
		}
		modules[r.Path()] = module
		return nil
	}
	ctx := context.Background()
	for _, p := range providers {
		if err := p(ctx, cb); err != nil {
			assert.Fail(t, "Failed to load rego files", err)
		}
	}
	ch, err := tester.NewRunner().SetStore(inmem.New()).Run(ctx, modules)
	if err != nil {
		assert.Fail(t, "Failed to run tests through OPA", err)
	}
	failedTests := []string{}
	hasFailures := false
	errors := []error{}
	for r := range ch {
		if r.Fail {
			hasFailures = true
			failedTests = append(failedTests, formatFailedTest(r))
		}
		hasFailures = hasFailures || r.Fail
		if r.Error != nil {
			errors = append(errors, r.Error)
		}
	}

	assert.Empty(t, errors)
	assert.Falsef(t, hasFailures, "Some tests failed:\n%v", strings.Join(failedTests, "\n"))
}

func TestRegulaLib(t *testing.T) {
	runRegoTest(t,
		[]rego.RegoProvider{
			rego.RegulaLibProvider(),
			rego.LocalProvider([]string{"tests/lib"}),
			rego.TestInputsProvider(
				[]string{"tests/lib"},
				[]loader.InputType{loader.Auto},
			),
		},
	)
}

func TestRegulaRules(t *testing.T) {
	runRegoTest(t,
		[]rego.RegoProvider{
			rego.RegulaLibProvider(),
			rego.RegulaRulesProvider(),
			rego.LocalProvider([]string{"tests/rules"}),
			rego.TestInputsProvider(
				[]string{"tests/rules"},
				[]loader.InputType{loader.Auto},
			),
		},
	)
}

func TestRegulaExamples(t *testing.T) {
	runRegoTest(t,
		[]rego.RegoProvider{
			rego.RegulaLibProvider(),
			rego.LocalProvider([]string{"examples", "tests/examples"}),
			rego.TestInputsProvider(
				[]string{"tests/examples"},
				[]loader.InputType{loader.Auto},
			),
		},
	)
}

// Trick to set the working directory to the rego directory
func init() {
	regoDir, err := filepath.Abs("../../rego")
	if err != nil {
		panic(err)
	}
	if err := os.Chdir(regoDir); err != nil {
		panic(err)
	}
}
