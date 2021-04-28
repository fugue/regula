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

var CfnJSONDetector = NewConfigurationDetector(&ConfigurationDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (IACConfiguration, error) {
		if !opts.IgnoreExt && i.Ext != ".json" {
			return nil, fmt.Errorf("File does not have .json extension: %v", i.Path)
		}
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}

		c := &map[string]interface{}{}
		if err := json.Unmarshal(contents, c); err != nil {
			return nil, fmt.Errorf("Failed to parse JSON file %v: %v", i.Path, err)
		}
		_, hasTemplateFormatVersion := (*c)["AWSTemplateFormatVersion"]
		_, hasResources := (*c)["Resources"]

		if !hasTemplateFormatVersion && !hasResources {
			return nil, fmt.Errorf("Input file is not CloudFormation JSON: %v", i.Path)
		}

		return &cfnJSON{
			path:    i.Path,
			content: c,
		}, nil
	},
})

type cfnJSON struct {
	path    string
	content *map[string]interface{}
}

func (l *cfnJSON) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}

func (l *cfnJSON) Location(attributePath []string) (*Location, error) {
	return &Location{
		Path: l.path,
		Line: 0,
		Col:  0,
	}, nil
}

func (l *cfnJSON) LoadedFiles() []string {
	return []string{l.path}
}
