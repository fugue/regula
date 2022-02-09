// Copyright 2022 Fugue, Inc.
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
	"os"
	"strings"

	"github.com/fugue/regula/pkg/version"
	"github.com/open-policy-agent/opa/ast"
)

var regulaRuntimeConfig *ast.Term

func init() {
	env := [][2]*ast.Term{}
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		key := pair[0]
		val := pair[1]
		env = append(env, [2]*ast.Term{ast.StringTerm(key), ast.StringTerm(val)})
	}

	regulaRuntimeConfig = ast.ObjectTerm(
		[2]*ast.Term{ast.StringTerm("version"), ast.StringTerm(version.OPAVersion)},
		[2]*ast.Term{ast.StringTerm("env"), ast.ObjectTerm(env...)},
	)
}

// Returns information used by the `opa.runtime()` builtin.
func RegulaRuntimeConfig() *ast.Term {
	return regulaRuntimeConfig
}
