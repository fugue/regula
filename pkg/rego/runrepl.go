package rego

import (
	"context"
	"os"

	"github.com/open-policy-agent/opa/repl"
	"github.com/open-policy-agent/opa/storage"
	"github.com/open-policy-agent/opa/storage/inmem"
)

type RunREPLOptions struct {
	Ctx      context.Context
	UserOnly bool
	Includes []string
}

func RunREPL(options *RunREPLOptions) error {
	registerBuiltins()
	store, err := initStore(options.Ctx, options.UserOnly, options.Includes)
	if err != nil {
		return err
	}
	r := repl.New(store, "./.regula-history", os.Stdout, "", 50, "Regula REPL")
	r.Loop(options.Ctx)
	return nil
}

func initStore(ctx context.Context, userOnly bool, includes []string) (storage.Store, error) {
	store := inmem.New()
	txn, err := store.NewTransaction(ctx, storage.TransactionParams{
		Write: true,
	})
	if err != nil {
		return nil, err
	}
	cb := func(r RegoFile) error {
		return store.UpsertPolicy(ctx, txn, r.Path(), r.Raw())
	}
	if err := loadRegula(userOnly, cb); err != nil {
		return nil, err
	}
	if err := loadOsFiles(includes, cb); err != nil {
		return nil, err
	}
	if err := store.Commit(ctx, txn); err != nil {
		return nil, err
	}
	return store, nil
}
