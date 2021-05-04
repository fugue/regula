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

func runRegoTest(t *testing.T, userOnly bool, includes []string) {
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
	if err := rego.LoadRegula(userOnly, cb); err != nil {
		assert.Fail(t, "Failed to load regula", userOnly, err)
	}
	if err := rego.LoadOSFiles(includes, cb); err != nil {
		assert.Fail(t, "Failed to load regula tests", err)
	}
	ctx := context.Background()
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
	runRegoTest(t, true, []string{"../../rego/tests/lib"})
}

func TestRegulaRules(t *testing.T) {
	runRegoTest(t, false, []string{"../../rego/tests/rules"})
}

func TestRegulaExamples(t *testing.T) {
	runRegoTest(t, true, []string{"../../rego/examples", "../../rego/tests/examples"})
}
