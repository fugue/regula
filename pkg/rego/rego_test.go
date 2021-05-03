package rego_test

import (
	"context"
	"fmt"
	"strings"
	"testing"

	"github.com/fugue/regula/pkg/rego"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/tester"
	"github.com/stretchr/testify/assert"
)

func formatFailedTest(r *tester.Result) string {
	return fmt.Sprintf("%s.%s in file %s", r.Package, r.Name, r.Location.String())
}

func TestRegulaLib(t *testing.T) {
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
	if err := rego.LoadRegula(true, cb); err != nil {
		assert.Fail(t, "Failed to load regula library", err)
	}
	if err := rego.LoadOSFiles([]string{"../../rego/tests/lib"}, cb); err != nil {
		assert.Fail(t, "Failed to load regula library tests", err)
	}
	ctx := context.Background()
	ch, err := tester.NewRunner().SetStore(inmem.New()).Run(ctx, modules)
	if err != nil {
		assert.Fail(t, "Failed to run library tests through OPA", err)
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

func TestRegulaRules(t *testing.T) {
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
	if err := rego.LoadRegula(false, cb); err != nil {
		assert.Fail(t, "Failed to load regula library and rules", err)
	}
	if err := rego.LoadOSFiles([]string{"../../rego/tests/rules"}, cb); err != nil {
		assert.Fail(t, "Failed to load regula rule tests", err)
	}
	ctx := context.Background()
	ch, err := tester.NewRunner().SetStore(inmem.New()).Run(ctx, modules)
	if err != nil {
		assert.Fail(t, "Failed to run rule tests through OPA", err)
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
