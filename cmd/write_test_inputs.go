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
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewWriteTestInputsCommand() *cobra.Command {
	description := "Persist dynamically-generated test inputs for use with other Rego interpreters"
	v := viper.New()
	cmd := &cobra.Command{
		Use:   "write-test-inputs [input...]",
		Short: description,
		Long:  description,
		RunE: func(cmd *cobra.Command, paths []string) error {
			inputTypeNames := v.GetStringSlice(inputTypeFlag)
			inputTypes, err := loader.InputTypesFromStrings(inputTypeNames)
			if err != nil {
				return err
			}
			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true
			cb := func(r rego.RegoFile) error {
				return os.WriteFile(r.Path(), r.Raw(), 0644)
			}
			provider := rego.TestInputsProvider(paths, inputTypes)
			ctx := context.Background()
			if err := provider(ctx, cb); err != nil {
				return err
			}
			return nil
		},
	}

	addInputTypeFlag(cmd, v)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewWriteTestInputsCommand())
}
