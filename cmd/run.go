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
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

//go:embed run.txt
var runDescription string

func NewRunCommand() *cobra.Command {
	inputTypes := []loader.InputType{loader.Auto}
	format := reporter.Text
	severity := reporter.Unknown
	cmd := &cobra.Command{
		Use:   "run [input...]",
		Short: "Evaluate rules against infrastructure as code with Regula.",
		Long:  runDescription,
		Run: func(cmd *cobra.Command, args []string) {
			noConfig, err := cmd.Flags().GetBool(noConfigFlag)
			if err != nil {
				logrus.Fatal(err)
			}

			var configDir string
			if !noConfig {
				configPath, err := cmd.Flags().GetString(configFlag)
				if err != nil {
					logrus.Fatal(err)
				}
				if err := loadConfigFile(configPath); err != nil {
					logrus.Fatal(err)
				}
				if err := setEnumFromConfig(cmd, inputTypeFlag); err != nil {
					logrus.Fatal(err)
				}
				if err := setEnumFromConfig(cmd, severityFlag); err != nil {
					logrus.Fatal(err)
				}
				if c := viper.ConfigFileUsed(); c != "" {
					configDir = filepath.Dir(c)
				}
			}

			includes, err := translateIncludes(cmd, configDir)
			if err != nil {
				logrus.Fatal(err)
			}
			inputs, err := translateInputs(args, configDir)
			if err != nil {
				logrus.Fatal(err)
			}
			userOnly := viper.GetBool(userOnlyFlag)
			noIgnore, err := cmd.Flags().GetBool(noIgnoreFlag)
			if err != nil {
				logrus.Fatal(err)
			}
			ctx := context.TODO()

			if configDir != "" {
				// Changing directories is the easiest and most robust way to
				// get all paths relative to the config file.
				if err := os.Chdir(configDir); err != nil {
					// Not sure whether this error is possible here since we were
					// able to load the file. But, just in case.
					logrus.Fatal(fmt.Errorf("Unable to change to config file directory: %s", err))
				}
			}

			loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
				Paths:       inputs,
				InputTypes:  inputTypes,
				NoGitIgnore: noIgnore,
			})
			if err != nil {
				logrus.Fatal(err)
			}
			result, err := rego.RunRules(&rego.RunRulesOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Includes: includes,
				Input:    loadedFiles.RegulaInput(),
			})
			if err != nil {
				logrus.Fatal(err)
			}
			reporterFunc, err := reporter.GetReporter(format)
			if err != nil {
				logrus.Fatal(err)
			}
			output, err := reporter.ParseRegulaOutput(loadedFiles, *result)
			if err != nil {
				logrus.Fatal(err)
			}
			report, err := reporterFunc(output)
			if err != nil {
				logrus.Fatal(err)
			}
			if report != "" {
				fmt.Println(report)
			}
			if output.ExceedsSeverity(severity) {
				os.Exit(1)
			}
		},
	}

	addConfigFlag(cmd)
	addNoConfigFlag(cmd)
	addIncludeFlag(cmd)
	addUserOnlyFlag(cmd)
	addNoIgnoreFlag(cmd)
	addInputTypeFlag(cmd, &inputTypes)
	addFormatFlag(cmd, &format)
	addSeverityFlag(cmd, &severity)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func translateInputs(inputs []string, configDir string) (newInputs []string, err error) {
	if len(inputs) < 1 {
		stat, _ := os.Stdin.Stat()
		if (stat.Mode() & os.ModeCharDevice) == 0 {
			// Input is stdin
			newInputs = []string{"-"}
		} else {
			if p := viper.GetStringSlice(inputsFlag); p != nil {
				// Inputs are set in config file
				newInputs = p
			} else {
				// Use CWD which is made relative to configDir if set
				newInputs, err = translatePaths([]string{"."}, configDir)
			}
		}
	} else {
		// Use paths specified in CLI args, made relative to configDir if set
		newInputs, err = translatePaths(inputs, configDir)
	}

	return
}

func translateIncludes(cmd *cobra.Command, configDir string) ([]string, error) {
	if cmd.Flags().Lookup(includeFlag).Changed {
		includes, err := cmd.Flags().GetStringSlice(includeFlag)
		if err != nil {
			return nil, err
		}
		return translatePaths(includes, configDir)
	}
	return viper.GetStringSlice(includeFlag), nil
}

func translatePaths(paths []string, configDir string) (newPaths []string, err error) {
	if configDir == "" {
		newPaths = paths
		return
	}

	newPaths = make([]string, len(paths))
	for i, p := range paths {
		absP, err := filepath.Abs(p)
		if err != nil {
			return nil, err
		}
		newPaths[i], err = filepath.Rel(configDir, absP)
		if err != nil {
			return nil, err
		}
	}

	return
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
