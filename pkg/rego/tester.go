package rego

import (
	"context"
	"os"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/storage/inmem"
	"github.com/open-policy-agent/opa/tester"
)

type RunTestOptions struct {
	Ctx   context.Context
	Paths []string
}

func RunTest(options *RunTestOptions) error {
	defineLoadFunction()
	// store, err := initStore(&InitStoreOptions{
	// 	Ctx:      options.Ctx,
	// 	UserOnly: true,
	// })
	store := inmem.New()
	// if err != nil {
	// 	return err
	// }

	modules, err := loadIncludesAst(options.Paths)
	if err != nil {
		return err
	}

	regulaRaw, err := loadRegulaRaw(true)
	if err != nil {
		return err
	}
	for k, v := range regulaRaw {
		module, err := ast.ParseModule(k, string(v))
		if err != nil {
			return err
		}
		modules[k] = module
	}

	ch, err := tester.NewRunner().SetStore(store).EnableTracing(true).Run(options.Ctx, modules)
	if err != nil {
		return err
	}
	reporter := tester.PrettyReporter{
		Output:      os.Stdout,
		FailureLine: true,
		Verbose:     true,
	}
	reporter.Report(ch)
	return nil
}
