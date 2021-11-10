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
	"path/filepath"
	"strings"

	"github.com/fugue/regula/pkg/version"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/repl"
	"github.com/open-policy-agent/opa/storage"
	"github.com/open-policy-agent/opa/storage/inmem"
)

type RunREPLOptions struct {
	Providers []RegoProvider
}

func RunREPL(ctx context.Context, options *RunREPLOptions) error {
	store := inmem.New()
	txn, err := store.NewTransaction(ctx, storage.TransactionParams{
		Write: true,
	})
	if err != nil {
		return err
	}
	cb := func(r RegoFile) error {
		return store.UpsertPolicy(ctx, txn, r.Path(), r.Raw())
	}
	for _, p := range options.Providers {
		if err := p(ctx, cb); err != nil {
			return err
		}
	}
	if err := store.Commit(ctx, txn); err != nil {
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
	r.OneShot(ctx, "strict-builtin-errors")
	r.Loop(ctx)
	return nil
}

func getBanner() string {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("Regula %v - built with OPA v%v\n", version.Version, version.OPAVersion))
	sb.WriteString("Run 'help' to see a list of commands.")
	return sb.String()
}
