package rego

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/version"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/repl"
	"github.com/open-policy-agent/opa/storage"
	"github.com/open-policy-agent/opa/storage/inmem"
)

type RunREPLOptions struct {
	Ctx          context.Context
	UserOnly     bool
	Includes     []string
	NoTestInputs bool
}

func RunREPL(options *RunREPLOptions) error {
	RegisterBuiltins()
	store, err := initStore(options.Ctx, options.UserOnly, options.Includes, options.NoTestInputs)
	if err != nil {
		return err
	}
	var historyPath string
	if homeDir, err := os.UserHomeDir(); err == nil {
		historyPath = filepath.Join(homeDir, ".regula-history")
	} else {
		historyPath = filepath.Join(".", ".regula-history")
	}
	r := repl.New(
		store,
		historyPath,
		os.Stdout,
		"pretty",
		ast.CompileErrorLimitDefault,
		getBanner())
	r.OneShot(options.Ctx, "strict-builtin-errors")
	r.Loop(options.Ctx)
	return nil
}

func initStore(ctx context.Context, userOnly bool, includes []string, noTestInputs bool) (storage.Store, error) {
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
	if err := LoadRegula(userOnly, cb); err != nil {
		return nil, err
	}
	if err := LoadOSFiles(includes, cb); err != nil {
		return nil, err
	}
	if !noTestInputs {
		if err := LoadTestInputs(includes, []loader.InputType{loader.Auto}, cb); err != nil {
			return nil, err
		}
	}
	if err := store.Commit(ctx, txn); err != nil {
		return nil, err
	}
	return store, nil
}

func getBanner() string {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("Regula %v - built with OPA v%v\n", version.Version, version.OPAVersion))
	sb.WriteString("Run 'help' to see a list of commands.")
	return sb.String()
}
