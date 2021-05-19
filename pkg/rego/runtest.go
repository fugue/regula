package rego

import (
	"context"
	"os"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/tester"
)

type RunTestOptions struct {
	Ctx          context.Context
	Includes     []string
	Trace        bool
	NoTestInputs bool
}

func RunTest(options *RunTestOptions) error {
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
	if err := LoadRegula(true, cb); err != nil {
		return err
	}
	if err := LoadOSFiles(options.Includes, cb); err != nil {
		return err
	}
	if !options.NoTestInputs {
		if err := LoadTestInputs(options.Includes, cb); err != nil {
			return err
		}
	}
	ch, err := tester.
		NewRunner().
		SetStore(inmem.New()).
		EnableTracing(options.Trace).
		Run(options.Ctx, modules)
	if err != nil {
		return err
	}
	reporter := tester.PrettyReporter{
		Output:      os.Stdout,
		FailureLine: true,
		Verbose:     options.Trace,
	}
	reporter.Report(ch)
	return nil
}
