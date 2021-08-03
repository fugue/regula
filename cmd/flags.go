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
	"strings"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/spf13/cobra"
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
}

func addNoTestInputsFlag(cmd *cobra.Command) {
	cmd.Flags().Bool(noTestInputsFlag, false, "Disable loading test inputs")
}

func addIncludeFlag(cmd *cobra.Command) {
	cmd.Flags().StringSliceP(includeFlag, "i", nil, "Specify additional rego files or directories to include")
}

func addNoIgnoreFlag(cmd *cobra.Command) {
	cmd.Flags().BoolP(noIgnoreFlag, "n", false, "Disable use of .gitignore")
}

func addInputTypeFlag(cmd *cobra.Command, inputTypes *[]loader.InputType) {
	cmd.Flags().VarP(
		enumflag.NewSlice(inputTypes, "string", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
		inputTypeFlag, "t",
		"Search for or assume the input type for the given paths. Can be specified multiple times.")
}

func addSeverityFlag(cmd *cobra.Command, severity *reporter.Severity) {
	cmd.Flags().VarP(
		enumflag.New(severity, "string", reporter.SeverityIds, enumflag.EnumCaseInsensitive),
		severityFlag, "s",
		"Set the minimum severity that will result in a non-zero exit code.")
}

func addFormatFlag(cmd *cobra.Command, format *reporter.Format) {
	cmd.Flags().VarP(
		enumflag.New(format, "string", reporter.FormatIds, enumflag.EnumCaseInsensitive),
		formatFlag, "f",
		"Set the output format")
}

func addTraceFlag(cmd *cobra.Command) {
	cmd.Flags().BoolP(traceFlag, "t", false, "Enable trace output")
}

func joinDescriptions(descriptions ...string) string {
	normalizedDescriptions := make([]string, len(descriptions))
	for i, d := range descriptions {
		normalizedDescriptions[i] = strings.TrimSpace(d)
	}
	return strings.Join(normalizedDescriptions, "\n\n")
}
