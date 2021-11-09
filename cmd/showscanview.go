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
	"fmt"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewShowScanViewCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "scan-view [file...]",
		Short: "Show the JSON output being passed to Fugue.",
		RunE: func(cmd *cobra.Command, args []string) error {
			// Config-file specific options
			var rootDir string
			configPath, err := cmd.Flags().GetString(configFlag)
			if err != nil {
				return err
			}
			if err := loadConfigFile(configPath); err != nil {
				return err
			}
			if c := viper.ConfigFileUsed(); c != "" {
				rootDir = filepath.Dir(c)
			}

			if rootDir == "" {
				return fmt.Errorf("show scan-view requires a configuration file. The location of the configuration file is used to produce consistent relative filepaths in rule results.")
			}

			// Inputs
			configFileInputs := viper.GetStringSlice(inputsFlag)
			inputs, err := translateInputs(args, configFileInputs, rootDir)
			if err != nil {
				return err
			}

			// Enum types
			inputTypeNames, err := getStringSlice(cmd, inputTypeFlag)
			if err != nil {
				return err
			}
			inputTypes, err := loader.InputTypesFromStrings(inputTypeNames)
			if err != nil {
				return err
			}

			config := &runConfig{
				configPath:   configPath,
				environmenId: viper.GetString(environmentIDFlag),
				inputs:       inputs,
				inputTypes:   inputTypes,
				rootDir:      rootDir,
				sync:         true,
				upload:       true,
			}
			if err := config.Validate(); err != nil {
				return err
			}

			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true

			// Interpret configuration
			configLoader, err := config.ConfigurationLoader()
			if err != nil {
				return err
			}
			providers, err := config.Providers()
			if err != nil {
				return err
			}
			if err := os.Chdir(config.rootDir); err != nil {
				return fmt.Errorf("Unable to change to config file directory: %s", err)
			}

			// Execution
			ctx := context.Background()
			loadedConfigs, err := configLoader()
			if err != nil {
				return err
			}
			result, err := rego.RunRules(ctx, &rego.RunRulesOptions{
				Providers: providers,
				Input:     loadedConfigs.RegulaInput(),
				Query:     config.RunRulesQuery(),
			})
			if err != nil {
				return err
			}
			scanView, err := reporter.ParseScanView(loadedConfigs, result)
			if err != nil {
				return err
			}
			scanViewJSON, err := scanView.ToJSON()
			if err != nil {
				return err
			}
			fmt.Print(scanViewJSON)
			return nil
		},
	}

	addConfigFlag(cmd)
	addEnvironmentIDFlag(cmd)
	addInputTypeFlag(cmd)
	addNoIgnoreFlag(cmd)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	showCommand.AddCommand(NewShowScanViewCommand())
}
