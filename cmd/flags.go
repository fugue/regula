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

	"github.com/fugue/regula/v2/pkg/loader"
	"github.com/fugue/regula/v2/pkg/reporter"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

const noBuiltInsFlag = "no-built-ins"
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
const environmentIDFlag = "environment-id"
const syncFlag = "sync"
const uploadFlag = "upload"
const excludeFlag = "exclude"
const onlyFlag = "only"

const inputTypeDescriptions = `
Input types:
    auto        Automatically determine input types (default)
    tf-plan     Terraform plan JSON
    cfn         CloudFormation template in YAML or JSON format
    tf          Terraform directory or file
    k8s         Kubernetes manifest in YAML format
    arm         Azure Resource Manager (ARM) JSON templates (feature in preview)
`
const formatDescriptions = `
Output formats:
    text    A human friendly format (default)
    json    A JSON report containing rule results and a summary
    table   An ASCII table of rule results
    junit   The JUnit XML format
    tap     The Test Anything Protocol format
    compact An alternate, more compact human friendly format
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

func addNoBuiltInsFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().BoolP(noBuiltInsFlag, "n", false, "Disable built-in rules")
	v.BindPFlag(noBuiltInsFlag, cmd.Flags().Lookup(noBuiltInsFlag))
}

func addNoTestInputsFlag(cmd *cobra.Command) {
	cmd.Flags().Bool(noTestInputsFlag, false, "Disable loading test inputs")
}

func addIncludeFlag(cmd *cobra.Command) {
	cmd.Flags().StringSliceP(includeFlag, "i", nil, "Specify additional rego files or directories to include")
}

func addNoIgnoreFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().Bool(noIgnoreFlag, false, "Disable use of .gitignore")
	v.BindPFlag(noIgnoreFlag, cmd.Flags().Lookup(noIgnoreFlag))
}

func addInputTypeFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().StringSliceP(inputTypeFlag, "t", loader.DefaultInputTypes, "Search for or assume the input type for the given paths. Can be specified multiple times.")
	v.BindPFlag(inputTypeFlag, cmd.Flags().Lookup(inputTypeFlag))
	cmd.Long = joinDescriptions(cmd.Long, inputTypeDescriptions)
}

func addSeverityFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().StringP(severityFlag, "s", reporter.DefaultSeverity, "Set the minimum severity that will result in a non-zero exit code.")
	v.BindPFlag(severityFlag, cmd.Flags().Lookup(severityFlag))
	cmd.Long = joinDescriptions(cmd.Long, severityDescriptions)
}

func addFormatFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().StringP(formatFlag, "f", reporter.DefaultFormat, "Set the output format")
	v.BindPFlag(formatFlag, cmd.Flags().Lookup(formatFlag))
	v.BindEnv(formatFlag, "REGULA_FORMAT")
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
	cmd.Flags().Bool(forceFlag, false, "Overwrite configuration file without prompting for confirmation.")
}

func addEnvironmentIDFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().StringP(environmentIDFlag, "e", "", "Environment ID in Fugue")
	v.BindPFlag(environmentIDFlag, cmd.Flags().Lookup(environmentIDFlag))
	v.BindEnv(environmentIDFlag, "ENVIRONMENT_ID")
}

func addSyncFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().Bool(syncFlag, false, "Fetch rules and configuration from Fugue")
	v.BindPFlag(syncFlag, cmd.Flags().Lookup(syncFlag))
}

func addUploadFlag(cmd *cobra.Command) {
	cmd.Flags().Bool(uploadFlag, false, "Upload rule results to Fugue")
}

func addExcludeFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().StringSliceP(excludeFlag, "x", nil, "Rule IDs or names to exclude. Can be specified multiple times.")
	v.BindPFlag(excludeFlag, cmd.Flags().Lookup(excludeFlag))
}

func addOnlyFlag(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().StringSliceP(onlyFlag, "o", nil, "Rule IDs or names to run. All other rules will be excluded. Can be specified multiple times.")
	v.BindPFlag(onlyFlag, cmd.Flags().Lookup(onlyFlag))
}

func joinDescriptions(descriptions ...string) string {
	normalizedDescriptions := make([]string, len(descriptions))
	for i, d := range descriptions {
		normalizedDescriptions[i] = strings.TrimSpace(d)
	}
	return strings.Join(normalizedDescriptions, "\n\n")
}

func loadConfigFile(configPath string, v *viper.Viper) error {
	v.SetConfigType("yaml")
	if configPath != "" {
		v.SetConfigFile(configPath)
	} else {
		v.SetConfigName(".regula.yaml")
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
			v.AddConfigPath(currDir)
			prevDir = currDir
			currDir = filepath.Dir(currDir)
		}
	}

	if err := v.ReadInConfig(); err != nil {
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

	if p := v.ConfigFileUsed(); p != "" {
		fmt.Fprintf(os.Stderr, "Using config file '%s'\n", p)
	}

	return nil
}
