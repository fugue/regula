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

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/fugue/regula/v2/pkg/rego"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewREPLCommand() *cobra.Command {
	v := viper.New()
	cmd := &cobra.Command{
		Use:   "repl [paths containing rego or test inputs]",
		Short: "Start an interactive session for testing rules with Regula",
		RunE: func(cmd *cobra.Command, includes []string) error {
			noBuiltIns, err := cmd.Flags().GetBool(noBuiltInsFlag)
			if err != nil {
				return err
			}
			noTestInputs, err := cmd.Flags().GetBool(noTestInputsFlag)
			if err != nil {
				return err
			}
			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true

			ctx := context.Background()
			regoProviders := []rego.RegoProvider{
				rego.RegulaLibProvider(),
				rego.LocalProvider(includes),
			}
			if !noBuiltIns {
				regoProviders = append(regoProviders, rego.RegulaRulesProvider())
			}
			if !noTestInputs {
				regoProviders = append(
					regoProviders,
					rego.TestInputsProvider(includes, []loader.InputType{loader.Auto}),
				)
			}
			err = rego.RunREPL(ctx, &rego.RunREPLOptions{
				Providers: regoProviders,
			})
			if err != nil {
				return err
			}
			return nil
		},
	}

	addNoBuiltInsFlag(cmd, v)
	addNoTestInputsFlag(cmd)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewREPLCommand())
}
