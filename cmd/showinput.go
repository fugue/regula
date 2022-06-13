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
	"encoding/json"
	"fmt"

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewShowInputCommand() *cobra.Command {
	v := viper.New()
	cmd := &cobra.Command{
		Use:   "input [file...]",
		Short: "Show the JSON input being passed to regula",
		RunE: func(cmd *cobra.Command, paths []string) error {
			inputTypeNames := v.GetStringSlice(inputTypeFlag)
			inputTypes, err := loader.InputTypesFromStrings(inputTypeNames)
			if err != nil {
				return err
			}
			varFiles := v.GetStringSlice(varFileFlag)
			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true
			loadedFiles, err := loader.LocalConfigurationLoader(loader.LoadPathsOptions{
				Paths:      paths,
				InputTypes: inputTypes,
				VarFiles:   varFiles,
			})()
			if err != nil {
				return err
			}
			bytes, err := json.MarshalIndent(loadedFiles.RegulaInput(), "", "  ")
			if err != nil {
				return err
			}
			fmt.Println(string(bytes))
			return nil
		},
	}

	addInputTypeFlag(cmd, v)
	addVarFileFlag(cmd, v)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	showCommand.AddCommand(NewShowInputCommand())
}
