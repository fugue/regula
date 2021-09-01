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
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/thediveo/enumflag"
)

const userOnlyFlag = "user-only"
const noTestInputsFlag = "no-test-inputs"
const includeFlag = "include"
const noIgnoreFlag = "no-ignore"
const inputTypeFlag = "input-type"
const severityFlag = "severity"
const formatFlag = "format"
const traceFlag = "trace"
const configFlag = "config"
const noConfigFlag = "no-config"
const inputsFlag = "inputs"
const forceFlag = "force"
const environmentIdFlag = "environment-id"

const inputTypeDescriptions = `
Input types:
    auto        Automatically determine input types (default)
    tf-plan     Terraform plan JSON
    cfn         CloudFormation template in YAML or JSON format
    tf          Terraform directory or file
`
const formatDescriptions = `
Output formats:
    text    A human friendly format (default)
    json    A JSON report containing rule results and a summary
    table   An ASCII table of rule results
    junit   The JUnit XML format
    tap     The Test Anything Protocol format
    none    Do not print any output on stdout
`
const severityDescriptions = `
Severities:
    unknown         Lowest setting. Used for rules without a severity specified (default)
    informational
    low
    medium
    high
    critical
    off             Never exit with a non-zero exit code.
`

func addUserOnlyFlag(cmd *cobra.Command) {
	cmd.Flags().BoolP(userOnlyFlag, "u", false, "Disable built-in rules")
	viper.BindPFlag(userOnlyFlag, cmd.Flags().Lookup(userOnlyFlag))
}

func addNoTestInputsFlag(cmd *cobra.Command) {
	cmd.Flags().Bool(noTestInputsFlag, false, "Disable loading test inputs")
}

func addIncludeFlag(cmd *cobra.Command) {
	cmd.Flags().StringSliceP(includeFlag, "i", nil, "Specify additional rego files or directories to include")
	viper.BindPFlag(includeFlag, cmd.Flags().Lookup(includeFlag))
}

func addNoIgnoreFlag(cmd *cobra.Command) {
	cmd.Flags().BoolP(noIgnoreFlag, "n", false, "Disable use of .gitignore")
}

func addInputTypeFlag(cmd *cobra.Command, inputTypes *[]loader.InputType) {
	cmd.Flags().VarP(
		enumflag.NewSlice(inputTypes, "string", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
		inputTypeFlag, "t",
		"Search for or assume the input type for the given paths. Can be specified multiple times.")
	viper.BindPFlag(inputTypeFlag, cmd.Flags().Lookup(inputTypeFlag))
	cmd.Long = joinDescriptions(cmd.Long, inputTypeDescriptions)
}

func addSeverityFlag(cmd *cobra.Command, severity *reporter.Severity) {
	cmd.Flags().VarP(
		enumflag.New(severity, "string", reporter.SeverityIds, enumflag.EnumCaseInsensitive),
		severityFlag, "s",
		"Set the minimum severity that will result in a non-zero exit code.")
	viper.BindPFlag(severityFlag, cmd.Flags().Lookup(severityFlag))
	cmd.Long = joinDescriptions(cmd.Long, severityDescriptions)
}

func addFormatFlag(cmd *cobra.Command, format *reporter.Format) {
	cmd.Flags().VarP(
		enumflag.New(format, "string", reporter.FormatIds, enumflag.EnumCaseInsensitive),
		formatFlag, "f",
		"Set the output format")
	cmd.Long = joinDescriptions(cmd.Long, formatDescriptions)
}

func addTraceFlag(cmd *cobra.Command) {
	cmd.Flags().BoolP(traceFlag, "t", false, "Enable trace output")
}

func addConfigFlag(cmd *cobra.Command) {
	cmd.Flags().StringP(configFlag, "c", "", "Path to .regula.yaml file. By default regula will look in the current working directory and its parents.")
}

func addNoConfigFlag(cmd *cobra.Command) {
	cmd.Flags().Bool(noConfigFlag, false, "Do not look for or load a regula config file.")
}

func addForceFlag(cmd *cobra.Command) {
	cmd.Flags().BoolP(forceFlag, "f", false, "Overwrite configuration file without prompting for confirmation.")
}

func addEnvironmentIdFlag(cmd *cobra.Command) {
	cmd.Flags().StringP(environmentIdFlag, "e", "", "Environment ID in Fugue SaaS")
}

func joinDescriptions(descriptions ...string) string {
	normalizedDescriptions := make([]string, len(descriptions))
	for i, d := range descriptions {
		normalizedDescriptions[i] = strings.TrimSpace(d)
	}
	return strings.Join(normalizedDescriptions, "\n\n")
}

func loadConfigFile(configPath string) error {
	viper.SetConfigType("yaml")

	if configPath != "" {
		viper.SetConfigFile(configPath)
	} else {
		viper.SetConfigName(".regula.yaml")
		currDir, err := os.Getwd()
		if err != nil {
			return err
		}

		prevDir := ""
		for currDir != prevDir {
			// This is to avoid errors from viper if the user doesn't have permission
			// to some parent directories.
			if _, err := os.Stat(currDir); err != nil {
				break
			}
			viper.AddConfigPath(currDir)
			prevDir = currDir
			currDir = filepath.Dir(currDir)
		}
	}

	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); ok {
			logrus.Debugf("Could not find configuration file: %s", err)
			// This is only considered an error if the user specified a config file
			if configPath != "" {
				return err
			}
		} else {
			return err
		}
	}

	if p := viper.ConfigFileUsed(); p != "" {
		fmt.Fprintf(os.Stderr, "Using config file '%s'\n", p)
	}

	return nil
}

func setEnumFromConfig(cmd *cobra.Command, flagName string) error {
	flag := cmd.Flags().Lookup(flagName)

	if flag.Changed {
		return nil
	}

	if viper.IsSet(flagName) {
		value := strings.Join(viper.GetStringSlice(flagName), ",")
		if err := flag.Value.Set(value); err != nil {
			return fmt.Errorf("Invalid value for '%s' in config file: %s", flagName, err)
		}
	}

	return nil
}
