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
	"strings"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/manifoldco/promptui"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

func NewInitCommand() *cobra.Command {
	description := "Create a new Regula configuration file in the current working directory."
	cmd := &cobra.Command{
		Use:   "init [input...]",
		Short: description,
		Long: joinDescriptions(
			description,
			"Pass one or more inputs (like you would with the 'regula run' command) in order to change the default inputs for 'regula run'.",
		),
		RunE: func(cmd *cobra.Command, paths []string) error {
			configPath := filepath.Join(".", ".regula.yaml")
			v := viper.New()
			v.SetConfigType("yaml")
			v.SetConfigFile(configPath)

			if err := configureStringIfSet(cmd, v, environmentIDFlag); err != nil {
				return err
			}
			if err := configureStringSliceIfSet(cmd, v, excludeFlag); err != nil {
				return err
			}
			if err := configureEnumIfSet(cmd, v, formatFlag, reporter.ValidateFormat); err != nil {
				return err
			}
			if err := configureStringSliceIfSet(cmd, v, includeFlag); err != nil {
				return err
			}
			if err := configureEnumSliceIfSet(cmd, v, inputTypeFlag, loader.ValidateInputTypes); err != nil {
				return err
			}
			if err := configureBoolIfSet(cmd, v, noBuiltInsFlag); err != nil {
				return err
			}
			if err := configureBoolIfSet(cmd, v, noIgnoreFlag); err != nil {
				return err
			}
			if err := configureStringSliceIfSet(cmd, v, onlyFlag); err != nil {
				return err
			}
			if err := configureEnumIfSet(cmd, v, severityFlag, reporter.ValidateSeverity); err != nil {
				return err
			}
			if err := configureBoolIfSet(cmd, v, syncFlag); err != nil {
				return err
			}
			if len(paths) > 0 {
				v.Set(inputsFlag, paths)
			}

			force, err := cmd.Flags().GetBool(forceFlag)
			if err != nil {
				return err
			}

			if _, err := os.Stat(configPath); err == nil {
				shouldOverwrite, err := overwritePrompt(configPath)
				if err != nil {
					return err
				}
				if force || shouldOverwrite {
					if err := writeConfig(v); err != nil {
						return err
					}
				} else {
					logrus.Infof("Not overwriting %s", configPath)
					return nil
				}
			} else {
				if err := writeConfig(v); err != nil {
					return err
				}
			}

			logrus.Infof("Wrote configuration file to %s", configPath)
			return nil
		},
	}

	addEnvironmentIDFlag(cmd)
	addExcludeFlag(cmd)
	addForceFlag(cmd)
	addFormatFlag(cmd)
	addIncludeFlag(cmd)
	addInputTypeFlag(cmd)
	addNoBuiltInsFlag(cmd)
	addNoIgnoreFlag(cmd)
	addOnlyFlag(cmd)
	addSeverityFlag(cmd)
	addSyncFlag(cmd)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func configureStringIfSet(cmd *cobra.Command, v *viper.Viper, flagName string) error {
	if !cmd.Flags().Changed(flagName) {
		return nil
	}
	val, err := cmd.Flags().GetString(flagName)
	if err != nil {
		return err
	}
	v.Set(flagName, val)
	return nil
}

func configureStringSliceIfSet(cmd *cobra.Command, v *viper.Viper, flagName string) error {
	if !cmd.Flags().Changed(flagName) {
		return nil
	}
	val, err := cmd.Flags().GetStringSlice(flagName)
	if err != nil {
		return err
	}
	v.Set(flagName, val)
	return nil
}

func configureBoolIfSet(cmd *cobra.Command, v *viper.Viper, flagName string) error {
	if !cmd.Flags().Changed(flagName) {
		return nil
	}
	val, err := cmd.Flags().GetBool(flagName)
	if err != nil {
		return err
	}
	v.Set(flagName, val)
	return nil
}

func configureEnumIfSet(cmd *cobra.Command, v *viper.Viper, flagName string, validate func(s string) error) error {
	if !cmd.Flags().Changed(flagName) {
		return nil
	}
	val, err := cmd.Flags().GetString(flagName)
	if err != nil {
		return err
	}
	if err := validate(val); err != nil {
		return err
	}
	v.Set(flagName, val)
	return nil
}

func configureEnumSliceIfSet(cmd *cobra.Command, v *viper.Viper, flagName string, validate func(s []string) error) error {
	if !cmd.Flags().Changed(flagName) {
		return nil
	}
	val, err := cmd.Flags().GetStringSlice(flagName)
	if err != nil {
		return err
	}
	if err := validate(val); err != nil {
		return err
	}
	v.Set(flagName, val)
	return nil
}

func overwritePrompt(configPath string) (bool, error) {
	prompt := promptui.Select{
		Label: fmt.Sprintf("Overwrite existing %s? [Yes/No]", configPath),
		Items: []string{"Yes", "No"},
	}
	_, result, err := prompt.Run()
	if err != nil {
		return false, fmt.Errorf(".regula.yaml exists and unable to prompt to overwrite. Use --force to disable the prompt.")
	}
	return result == "Yes", nil
}

func writeConfig(v *viper.Viper) error {
	defaults := map[string]interface{}{}
	if !v.IsSet(environmentIDFlag) {
		defaults[environmentIDFlag] = ""
	}
	if !v.IsSet(excludeFlag) {
		defaults[excludeFlag] = []string{}
	}
	if !v.IsSet(formatFlag) {
		defaults[formatFlag] = reporter.DefaultFormat
	}
	if !v.IsSet(includeFlag) {
		defaults[includeFlag] = []string{}
	}
	if !v.IsSet(inputTypeFlag) {
		defaults[inputTypeFlag] = loader.DefaultInputTypes
	}
	if !v.IsSet(noBuiltInsFlag) {
		defaults[noBuiltInsFlag] = false
	}
	if !v.IsSet(noIgnoreFlag) {
		defaults[noIgnoreFlag] = false
	}
	if !v.IsSet(onlyFlag) {
		defaults[onlyFlag] = []string{}
	}
	if !v.IsSet(severityFlag) {
		defaults[severityFlag] = reporter.DefaultSeverity
	}
	if !v.IsSet(syncFlag) {
		defaults[syncFlag] = false
	}
	if !v.IsSet(inputsFlag) {
		defaults[inputsFlag] = []string{}
	}
	if len(defaults) < 1 {
		return v.WriteConfig()
	}
	defaultsBytes, err := yaml.Marshal(defaults)
	if err != nil {
		return err
	}
	defaultsLines := strings.Split(string(defaultsBytes), "\n")
	commentedDefaults := make([]string, len(defaultsLines))
	for i, l := range defaultsLines {
		if l != "" {
			commentedDefaults[i] = "# " + l
		}
	}
	if err := v.WriteConfig(); err != nil {
		return err
	}
	f, err := os.OpenFile(v.ConfigFileUsed(), os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	if _, err := f.WriteString(strings.Join(commentedDefaults, "\n")); err != nil {
		return err
	}
	return nil
}

func init() {
	rootCmd.AddCommand(NewInitCommand())
}
