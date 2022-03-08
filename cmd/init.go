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

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/fugue/regula/v2/pkg/reporter"
	"github.com/manifoldco/promptui"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewInitCommand() *cobra.Command {
	description := "Create a new Regula configuration file in the current working directory."
	v := viper.New()
	cmd := &cobra.Command{
		Use:   "init [input...]",
		Short: description,
		Long: joinDescriptions(
			description,
			"Pass one or more inputs (like you would with the 'regula run' command) in order to change the default inputs for 'regula run'.",
		),
		RunE: func(cmd *cobra.Command, paths []string) error {
			configPath := filepath.Join(".", ".regula.yaml")
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

			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true

			if _, err := os.Stat(configPath); err == nil {
				shouldOverwrite, err := overwritePrompt(configPath)
				if err != nil {
					return err
				}
				if force || shouldOverwrite {
					if err := v.WriteConfig(); err != nil {
						return err
					}
				} else {
					logrus.Infof("Not overwriting %s", configPath)
					return nil
				}
			} else {
				if err := v.WriteConfig(); err != nil {
					return err
				}
			}

			logrus.Infof("Wrote configuration file to %s", configPath)
			return nil
		},
	}

	addEnvironmentIDFlag(cmd, v)
	addExcludeFlag(cmd, v)
	addForceFlag(cmd)
	addFormatFlag(cmd, v)
	addIncludeFlag(cmd)
	addInputTypeFlag(cmd, v)
	addNoBuiltInsFlag(cmd, v)
	addNoIgnoreFlag(cmd, v)
	addOnlyFlag(cmd, v)
	addSeverityFlag(cmd, v)
	addSyncFlag(cmd, v)
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

func init() {
	rootCmd.AddCommand(NewInitCommand())
}
