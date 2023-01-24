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

	"github.com/fugue/regula/v3/pkg/loader"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
)

type RegoFile interface {
	Raw() []byte
	String() string
	AstModule() (*ast.Module, error)
	RegoModule() func(r *rego.Rego)
	Path() string
}

type RegoProcessor func(r RegoFile) error

type RegoProvider func(ctx context.Context, p RegoProcessor) error

type RegoResult *rego.Result

type RegoResultProcessor func(ctx context.Context, c loader.LoadedConfigurations, r RegoResult) error
