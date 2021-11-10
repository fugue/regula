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
	"fmt"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

//go:embed run.txt
var runDescription string

func NewRunCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "run [input...]",
		Short: "Evaluate rules against infrastructure as code with Regula.",
		Long:  runDescription,
		RunE: func(cmd *cobra.Command, args []string) error {
			// CLI-arg-only options
			noConfig, err := cmd.Flags().GetBool(noConfigFlag)
			if err != nil {
				return err
			}
			upload, err := cmd.Flags().GetBool(uploadFlag)
			if err != nil {
				return err
			}

			// Config-file specific options
			var rootDir string
			var configPath string
			if !noConfig {
				configPath, err = cmd.Flags().GetString(configFlag)
				if err != nil {
					return err
				}
				if err := loadConfigFile(configPath); err != nil {
					return err
				}
				if c := viper.ConfigFileUsed(); c != "" {
					rootDir = filepath.Dir(c)
				}
			}
			// Inputs
			configFileInputs := viper.GetStringSlice(inputsFlag)
			inputs, err := translateInputs(args, configFileInputs, rootDir)
			if err != nil {
				return err
			}

			// Includes
			cliIncludes, err := cmd.Flags().GetStringSlice(includeFlag)
			if err != nil {
				return err
			}
			configFileIncludes := viper.GetStringSlice(includeFlag)
			includes, err := translateIncludes(cliIncludes, configFileIncludes, rootDir)
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
			format, err := reporter.FormatFromString(viper.GetString(formatFlag))
			if err != nil {
				return err
			}
			severity, err := reporter.SeverityFromString(viper.GetString(severityFlag))
			if err != nil {
				return err
			}

			// String slices
			excludes, err := getStringSlice(cmd, excludeFlag)
			if err != nil {
				return err
			}
			only, err := getStringSlice(cmd, onlyFlag)
			if err != nil {
				return err
			}

			config := &runConfig{
				configPath:   configPath,
				environmenId: viper.GetString(environmentIDFlag),
				excludes:     excludes,
				format:       format,
				includes:     includes,
				inputs:       inputs,
				inputTypes:   inputTypes,
				noBuiltIns:   viper.GetBool(noBuiltInsFlag),
				noConfig:     noConfig,
				noIgnore:     viper.GetBool(noIgnoreFlag),
				only:         only,
				rootDir:      rootDir,
				severity:     severity,
				sync:         viper.GetBool(syncFlag),
				upload:       upload,
			}
			if err := config.Validate(); err != nil {
				return err
			}

			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true

			// Interpret configuration
			// config, err := RunConfigFromCmd(cmd, args)
			if err != nil {
				return err
			}
			configLoader, err := config.ConfigurationLoader()
			if err != nil {
				return err
			}
			providers, err := config.Providers()
			if err != nil {
				return err
			}
			resultProcessor := config.ResultProcessor()
			if config.rootDir != "" {
				// Changing directories is the easiest and most robust way to
				// get all paths relative to the config file.
				if err := os.Chdir(config.rootDir); err != nil {
					// Not sure whether this error is possible here since we were
					// able to load the file. But, just in case.
					return fmt.Errorf("Unable to change to config file directory: %s", err)
				}
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
			if err := resultProcessor(ctx, loadedConfigs, result); err != nil {
				return err
			}
			return nil
		},
	}

	addConfigFlag(cmd)
	addEnvironmentIDFlag(cmd)
	addExcludeFlag(cmd)
	addFormatFlag(cmd)
	addIncludeFlag(cmd)
	addInputTypeFlag(cmd)
	addNoBuiltInsFlag(cmd)
	addNoConfigFlag(cmd)
	addNoIgnoreFlag(cmd)
	addOnlyFlag(cmd)
	addSeverityFlag(cmd)
	addSyncFlag(cmd)
	addUploadFlag(cmd)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
