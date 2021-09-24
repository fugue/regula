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
	"encoding/json"
	"fmt"
)

var validArmExts map[string]bool = map[string]bool{
	".json": true,
}

type ArmDetector struct{}

func (c *ArmDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if !opts.IgnoreExt && !validArmExts[i.Ext()] {
		return nil, fmt.Errorf("File does not have .json extension: %v", i.Path())
	}
	contents, err := i.Contents()
	if err != nil {
		return nil, err
	}

	template := &armTemplate{}
	if err := json.Unmarshal(contents, &template.Contents); err != nil {
		return nil, fmt.Errorf("Failed to parse file as JSON %v: %v", i.Path(), err)
	}
	_, hasSchema := template.Contents["$schema"]
	_, hasResources := template.Contents["resources"]

	if !hasSchema && !hasResources {
		return nil, fmt.Errorf("Input file is not an ARM template: %v", i.Path())
	}
	path := i.Path()

	return &armConfiguration{
		path:     path,
		template: *template,
	}, nil
}

func (c *ArmDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	return nil, nil
}

type armConfiguration struct {
	path     string
	template armTemplate
	source   *CfnSourceInfo
}

func (l *armConfiguration) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.template.Contents,
	}
}

func (l *armConfiguration) Location(attributePath []string) (LocationStack, error) {
	if l.source == nil {
		return nil, nil
	}
	loc, err := l.source.Location(attributePath)
	if loc == nil || err != nil {
		return nil, err
	}
	return []Location{*loc}, nil
}

func (l *armConfiguration) LoadedFiles() []string {
	return []string{l.path}
}

type armTemplate struct {
	Contents map[string]interface{}
}
