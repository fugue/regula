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
	_ "embed"
	"fmt"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/manifoldco/promptui"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewInitCommand() *cobra.Command {
	inputTypes := []loader.InputType{}
	severity := reporter.Unknown
	description := "Create a new Regula configuration file in the current working directory."
	cmd := &cobra.Command{
		Use:   "init [input...]",
		Short: description,
		Long: joinDescriptions(
			description,
			"Pass one or more inputs (like you would with the 'regula run' command) in order to change the default inputs for 'regula run'.",
		),
		Run: func(cmd *cobra.Command, paths []string) {
			configPath := filepath.Join(".", ".regula.yaml")
			v := viper.New()
			v.SetConfigType("yaml")
			v.SetConfigFile(configPath)

			if cmd.Flags().Lookup(inputTypeFlag).Changed {
				configuredInputTypes := []string{}
				for _, t := range inputTypes {
					configuredInputTypes = append(
						configuredInputTypes,
						loader.InputTypeIDs[t][0],
					)
				}
				v.Set(inputTypeFlag, configuredInputTypes)
			}

			if cmd.Flags().Lookup(severityFlag).Changed {
				configuredSeverity := reporter.SeverityIds[severity][0]
				v.Set(severityFlag, configuredSeverity)
			}

			if cmd.Flags().Lookup(includeFlag).Changed {
				configuredIncludes, err := cmd.Flags().GetStringSlice(includeFlag)
				if err != nil {
					logrus.Fatal(err)
				}
				v.Set(includeFlag, configuredIncludes)
			}

			if cmd.Flags().Lookup(userOnlyFlag).Changed {
				configuredUserOnly, err := cmd.Flags().GetBool(userOnlyFlag)
				if err != nil {
					logrus.Fatal(err)
				}
				v.Set(userOnlyFlag, configuredUserOnly)
			}

			if len(paths) > 0 {
				v.Set(inputsFlag, paths)
			}

			force, err := cmd.Flags().GetBool(forceFlag)
			if err != nil {
				logrus.Fatal(err)
			}

			if _, err := os.Stat(configPath); err == nil {
				if force || overwritePrompt(configPath) {
					v.WriteConfig()
				} else {
					logrus.Infof("Not overwriting %s", configPath)
					return
				}
			} else {
				v.WriteConfig()
			}

			logrus.Infof("Wrote configuration file to %s", configPath)
		},
	}

	addForceFlag(cmd)
	addIncludeFlag(cmd)
	addUserOnlyFlag(cmd)
	addInputTypeFlag(cmd, &inputTypes)
	addSeverityFlag(cmd, &severity)

	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func overwritePrompt(configPath string) bool {
	prompt := promptui.Select{
		Label: fmt.Sprintf("Overwrite existing %s? [Yes/No]", configPath),
		Items: []string{"Yes", "No"},
	}
	_, result, err := prompt.Run()
	if err != nil {
		logrus.Fatalf(".regula.yaml exists and unable to prompt to overwrite. Use --force to disable the prompt.")
	}
	return result == "Yes"
}

func init() {
	rootCmd.AddCommand(NewInitCommand())
}
