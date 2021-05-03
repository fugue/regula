package rego

import (
	"os"

	"github.com/open-policy-agent/opa/repl"
)

func REPL(options *RuleRunnerOptions) error {
	defineLoadFunction()
	store, err := initStore(&InitStoreOptions{
		Ctx: options.Ctx,
	})
	if err != nil {
		return err
	}
	r := repl.New(store, "./.regula-history", os.Stdout, "", 50, "Regula REPL")
	r.Loop(options.Ctx)
	return nil
}
