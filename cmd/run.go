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

	"github.com/fugue/regula/v3/pkg/loader"
	"github.com/fugue/regula/v3/pkg/rego"
	"github.com/fugue/regula/v3/pkg/reporter"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

//go:embed run.txt
var runDescription string

func NewRunCommand() *cobra.Command {
	v := viper.New()
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
				if err := loadConfigFile(configPath, v); err != nil {
					return err
				}
				if c := v.ConfigFileUsed(); c != "" {
					rootDir = filepath.Dir(c)
				}
			}
			// Inputs
			configFileInputs := v.GetStringSlice(inputsFlag)
			inputs, err := translateInputs(args, configFileInputs, rootDir)
			if err != nil {
				return err
			}

			// Includes
			cliIncludes, err := cmd.Flags().GetStringSlice(includeFlag)
			if err != nil {
				return err
			}
			configFileIncludes := v.GetStringSlice(includeFlag)
			includes, err := translateIncludes(cliIncludes, configFileIncludes, rootDir)
			if err != nil {
				return err
			}

			// Enum types
			inputTypeNames := v.GetStringSlice(inputTypeFlag)
			inputTypes, err := loader.InputTypesFromStrings(inputTypeNames)
			if err != nil {
				return err
			}
			format, err := reporter.FormatFromString(v.GetString(formatFlag))
			if err != nil {
				return err
			}
			severity, err := reporter.SeverityFromString(v.GetString(severityFlag))
			if err != nil {
				return err
			}

			config := &runConfig{
				configPath:    configPath,
				environmentId: v.GetString(environmentIDFlag),
				excludes:      v.GetStringSlice(excludeFlag),
				format:        format,
				includes:      includes,
				inputs:        inputs,
				inputTypes:    inputTypes,
				noBuiltIns:    v.GetBool(noBuiltInsFlag),
				noConfig:      noConfig,
				noIgnore:      v.GetBool(noIgnoreFlag),
				only:          v.GetStringSlice(onlyFlag),
				rootDir:       rootDir,
				severity:      severity,
				sync:          v.GetBool(syncFlag),
				upload:        upload,
				varFiles:      v.GetStringSlice(varFileFlag),
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
	addEnvironmentIDFlag(cmd, v)
	addExcludeFlag(cmd, v)
	addFormatFlag(cmd, v)
	addIncludeFlag(cmd)
	addInputTypeFlag(cmd, v)
	addNoBuiltInsFlag(cmd, v)
	addNoConfigFlag(cmd)
	addNoIgnoreFlag(cmd, v)
	addOnlyFlag(cmd, v)
	addSeverityFlag(cmd, v)
	addSyncFlag(cmd, v)
	addUploadFlag(cmd)
	addVarFileFlag(cmd, v)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
