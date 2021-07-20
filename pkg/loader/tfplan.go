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

package loader

import (
	"fmt"

	"gopkg.in/yaml.v3"
)

type TfPlanDetector struct{}

func (t *TfPlanDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if !opts.IgnoreExt && i.Ext() != ".json" {
		return nil, fmt.Errorf("File does not have .json extension: %v", i.Path())
	}
	contents, err := i.Contents()
	if err != nil {
		return nil, err
	}
	j := &map[string]interface{}{}
	if err := yaml.Unmarshal(contents, j); err != nil {
		return nil, fmt.Errorf("Failed to parse JSON file %v: %v", i.Path(), err)
	}
	_, hasTerraformVersion := (*j)["terraform_version"]

	if !hasTerraformVersion {
		return nil, fmt.Errorf("Input file is not Terraform Plan JSON: %v", i.Path())
	}

	return &tfPlanLoader{
		path:    i.Path(),
		content: j,
	}, nil
}

func (c *TfPlanDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	return nil, nil
}

type tfPlanLoader struct {
	path    string
	content *map[string]interface{}
}

func (l *tfPlanLoader) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}

func (l *tfPlanLoader) LoadedFiles() []string {
	return []string{l.path}
}

func (l *tfPlanLoader) Location(attributePath []string) (*Location, error) {
	return nil, nil
}
