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

	"github.com/fugue/regula/pkg/fugue"
	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

type runConfig struct {
	configPath   string
	environmenId string
	excludes     []string
	format       reporter.Format
	includes     []string
	inputs       []string
	inputTypes   []loader.InputType
	noBuiltIns   bool
	noConfig     bool
	noIgnore     bool
	only         []string
	rootDir      string
	severity     reporter.Severity
	sync         bool
	upload       bool
}

func (c *runConfig) Validate() error {
	if c.sync && (len(c.excludes) > 0 || len(c.includes) > 0 || len(c.only) > 0 || c.noBuiltIns) {
		logrus.Warn("--sync takes precedence over options that modify the rule set (--excludes, --includes, --only, --no-built-ins). Those options will be ignored.")
	}

	if c.upload {
		if c.rootDir == "" {
			return fmt.Errorf("--upload requires a configuration file. The location of the configuration file is used to produce consistent relative filepaths in rule results.")
		}
		if !c.sync {
			return fmt.Errorf("--sync is required when --upload is specified")
		}
	}

	return nil
}

func (c *runConfig) Providers() ([]rego.RegoProvider, error) {
	if c.sync {
		client, err := fugue.NewFugueClient()
		if err != nil {
			return nil, err
		}
		return []rego.RegoProvider{
			rego.RegulaLibProvider(),
			rego.RegulaRulesProvider(),
			client.CustomRulesProvider(),
		}, nil
	}

	providers := []rego.RegoProvider{
		rego.RegulaLibProvider(),
		rego.RegulaConfigProvider(c.excludes, c.only),
		rego.LocalProvider(c.includes),
	}
	if !c.noBuiltIns {
		providers = append(providers, rego.RegulaRulesProvider())
	}

	return providers, nil
}

func (c *runConfig) ConfigurationLoader() (loader.ConfigurationLoader, error) {
	inputTypes := c.inputTypes
	if c.upload {
		inputTypes = filterInputTypes(inputTypes)
	}

	return loader.LocalConfigurationLoader(loader.LoadPathsOptions{
		Paths:       c.inputs,
		InputTypes:  inputTypes,
		NoGitIgnore: c.noIgnore,
	}), nil
}

func (c *runConfig) ResultProcessor() rego.RegoResultProcessor {
	if c.upload {
		return func(ctx context.Context, conf loader.LoadedConfigurations, r rego.RegoResult) error {
			client, err := fugue.NewFugueClient()
			if err != nil {
				return err
			}
			scanView, err := reporter.ParseScanView(conf, r)
			if err != nil {
				return err
			}
			if err := client.UploadScan(ctx, c.environmenId, *scanView); err != nil {
				return err
			}
			reporter, err := reporter.GetReporter(c.format)
			if err != nil {
				return err
			}
			reportStr, err := reporter(&scanView.Report)
			if err != nil {
				return err
			}
			if reportStr != "" {
				fmt.Print(reportStr)
			}
			if scanView.Report.ExceedsSeverity(c.severity) {
				return &ExceedsSeverityError{
					configuredSeverity: c.severity.String(),
				}
			}

			return nil
		}
	}

	return func(_ context.Context, conf loader.LoadedConfigurations, r rego.RegoResult) error {
		report, err := reporter.ParseRegulaOutput(conf, r)
		if err != nil {
			return err
		}
		reporter, err := reporter.GetReporter(c.format)
		if err != nil {
			return err
		}
		reportStr, err := reporter(report)
		if err != nil {
			return err
		}
		if reportStr != "" {
			fmt.Print(reportStr)
		}
		if report.ExceedsSeverity(c.severity) {
			return &ExceedsSeverityError{
				configuredSeverity: c.severity.String(),
			}
		}

		return nil
	}
}

func (c *runConfig) RunRulesQuery() string {
	if c.upload {
		return rego.SCAN_VIEW_QUERY
	}

	return rego.REPORT_QUERY
}

type ExceedsSeverityError struct {
	configuredSeverity string
}

func (e *ExceedsSeverityError) Error() string {
	return fmt.Sprintf("Minimum severity (%v) exceeded.", e.configuredSeverity)
}

type RunOption interface {
	apply(c *runConfig)
}

type runOption func(c *runConfig)

func (fn runOption) apply(c *runConfig) {
	fn(c)
}

func scanInputTypes() []loader.InputType {
	scanInputTypes := make([]loader.InputType, len(loader.InputTypeIDs)-2)
	for i := range loader.InputTypeIDs {
		if i == loader.Auto || i == loader.TfPlan {
			continue
		}
		scanInputTypes = append(scanInputTypes, i)
	}
	return scanInputTypes
}

func filterInputTypes(inputTypes []loader.InputType) []loader.InputType {
	autoTypes := scanInputTypes()
	filtered := []loader.InputType{}
	for _, i := range inputTypes {
		switch i {
		case loader.Auto:
			filtered = append(filtered, autoTypes...)
		case loader.TfPlan:
			logrus.Warn("Ignoring tf-plan in input types because --upload was specified. Terraform plan files are not supported in Fugue at this time.")
		default:
			filtered = append(filtered, i)
		}
	}
	if len(filtered) < 1 {
		logrus.Warn("No supported input types configured. Defaulting to 'auto'.")
		return autoTypes
	}
	return filtered
}

func translateInputs(cliInputs []string, configFileInputs []string, rootDir string) ([]string, error) {
	stat, _ := os.Stdin.Stat()
	inputIsStdin := (stat.Mode() & os.ModeCharDevice) == 0

	if len(cliInputs) > 0 {
		return translatePaths(cliInputs, rootDir)
	} else if inputIsStdin {
		return []string{"-"}, nil
	} else if len(configFileInputs) > 0 {
		return configFileInputs, nil
	}

	return []string{"."}, nil
}

func translateIncludes(cliIncludes []string, configFileIncludes []string, rootDir string) ([]string, error) {
	if len(cliIncludes) > 0 {
		return translatePaths(cliIncludes, rootDir)
	}

	return configFileIncludes, nil
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

// TODO: Since we're using Viper's BindPFlag(), we should just be able to get the
// value through viper like every other type of flag we use. For some reason, these
// string slices are always coming back empty if they're not set in the config file.
func getStringSlice(cmd *cobra.Command, flagName string) ([]string, error) {
	if cmd.Flags().Changed(flagName) {
		fromCmd, err := cmd.Flags().GetStringSlice(flagName)
		if err != nil {
			return nil, err
		}
		return fromCmd, nil
	}

	return viper.GetStringSlice(flagName), nil
}
