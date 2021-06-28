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
	"bytes"
	"fmt"
	"io"

	"gopkg.in/yaml.v3"
)

var validK8sExts map[string]bool = map[string]bool{
	".yaml": true,
	".yml":  true,
}

func splitYAML(data []byte) ([]map[string]interface{}, error) {
	dec := yaml.NewDecoder(bytes.NewReader(data))
	var documents []map[string]interface{}
	for {
		var value map[string]interface{}
		err := dec.Decode(&value)
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, err
		}
		documents = append(documents, value)
	}
	return documents, nil
}

type KubernetesDetector struct{}

func (c *KubernetesDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if !opts.IgnoreExt && !validK8sExts[i.Ext()] {
		return nil, fmt.Errorf("file does not have .yaml or .yml extension: %v", i.Path())
	}
	contents, err := i.Contents()
	if err != nil {
		return nil, err
	}
	documents, err := splitYAML(contents)
	if err != nil {
		return nil, err
	}
	if len(documents) == 0 {
		return nil, fmt.Errorf("no valid yaml documents found in %v", i.Path())
	}

	// Model each YAML document as a resource
	resources := map[string]interface{}{}
	content := map[string]interface{}{
		"k8s_resource_view_version": "0.0.1",
		"resources":                 resources,
	}

	for _, document := range documents {
		var name string
		kind, ok := document["kind"]
		if !ok {
			return nil, fmt.Errorf("input file does not define a kind: %v", i.Path())
		}
		if metadata, ok := document["metadata"].(map[string]interface{}); ok {
			name, _ = metadata["name"].(string)
		}
		if name == "" {
			return nil, fmt.Errorf("input file does not define a name: %v", i.Path())
		}
		resources[fmt.Sprintf("%s.%s", kind, name)] = document
	}

	return &k8sConfiguration{
		path:    i.Path(),
		content: content,
	}, nil
}

func (c *KubernetesDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	return nil, nil
}

type k8sConfiguration struct {
	path    string
	content map[string]interface{}
}

func (l *k8sConfiguration) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}

func (l *k8sConfiguration) Location(attributePath []string) (*Location, error) {
	return &Location{
		Path: l.path,
		Line: 0,
		Col:  0,
	}, nil
}

func (l *k8sConfiguration) LoadedFiles() []string {
	return []string{l.path}
}
