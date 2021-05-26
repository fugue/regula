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

package cmd

import (
	"context"
	_ "embed"

	"github.com/fugue/regula/pkg/rego"

	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

func NewREPLCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "repl [paths containing rego or test inputs]",
		Short: "Start an interactive session for testing rules with Regula",
		Run: func(cmd *cobra.Command, includes []string) {
			userOnly, err := cmd.Flags().GetBool("user-only")
			if err != nil {
				logrus.Fatal(err)
			}
			noTestInputs, err := cmd.Flags().GetBool("no-test-inputs")
			if err != nil {
				logrus.Fatal(err)
			}
			ctx := context.TODO()
			err = rego.RunREPL(&rego.RunREPLOptions{
				Ctx:          ctx,
				UserOnly:     userOnly,
				Includes:     includes,
				NoTestInputs: noTestInputs,
			})

			if err != nil {
				logrus.Fatal(err)
			}
		},
	}

	cmd.Flags().BoolP("user-only", "u", false, "Disable built-in rules")
	cmd.Flags().Bool("no-test-inputs", false, "Disable loading test inputs")
	return cmd
}

func init() {
	rootCmd.AddCommand(NewREPLCommand())
}
