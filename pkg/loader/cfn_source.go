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

// This file contains some utilities to deal with extracting source code
// information from cloudformation.

package loader

import (
	"fmt"
	"strconv"

	"gopkg.in/yaml.v3"
)

type CfnSourceInfo struct {
	filepath  string
	Resources yaml.Node `yaml:"Resources"`
}

func LoadCfnSourceInfo(filepath string, contents []byte) (*CfnSourceInfo, error) {
	var template CfnSourceInfo
	if err := yaml.Unmarshal(contents, &template); err != nil {
		return nil, err
	}
	template.filepath = filepath
	return &template, nil
}

func cfnSourceGetKeyBody(node *yaml.Node, key string) (*yaml.Node, *yaml.Node, error) {
	if node.Kind != yaml.MappingNode {
		return nil, nil, fmt.Errorf("cfnSourceGetKey: Expected MappingNode")
	}

	for i := 0; i+1 < len(node.Content); i += 2 {
		if node.Content[i].Value == key {
			return node.Content[i], node.Content[i+1], nil
		}
	}

	return nil, nil, fmt.Errorf("cfnSourceGetKey: Key %s not found", key)
}

func cfnSourceGetIndex(node *yaml.Node, index int) (*yaml.Node, error) {
	if node.Kind != yaml.SequenceNode {
		return nil, fmt.Errorf("cfnSourceGetIndex: Expected SequenceNode")
	}

	if index < 0 || index >= len(node.Content) {
		return nil, fmt.Errorf("cfnSourceGetIndex: index out of bounds: %d", index)
	}

	return node.Content[index], nil
}

func cfnSourceGetPath(node *yaml.Node, path []string) (*yaml.Node, error) {
	if len(path) == 0 {
		return node, nil
	}

	key := path[0]
	switch node.Kind {
	case yaml.MappingNode:
		_, child, err := cfnSourceGetKeyBody(node, key)
		if err != nil {
			return nil, err
		} else {
			return cfnSourceGetPath(child, path[1:])
		}
	case yaml.SequenceNode:
		index, err := strconv.Atoi(key)
		if err != nil {
			return nil, err
		} else {
			child, err := cfnSourceGetIndex(node, index)
			if err != nil {
				return nil, err
			} else {
				return cfnSourceGetPath(child, path[1:])
			}
		}
	}

	return nil, fmt.Errorf("cfnSourceGetPath: Expected map or array")
}

func (source *CfnSourceInfo) Location(path []string) (*Location, error) {
	if len(path) < 1 {
		return nil, nil
	}
	resourceId := path[0]
	attributePath := path[1:]

	resourceKey, resource, err := cfnSourceGetKeyBody(&source.Resources, resourceId)
	if err != nil {
		return nil, fmt.Errorf("Resource %s not found", resourceId)
	}

	if len(attributePath) < 1 {
		return &Location{
			Path: source.filepath,
			Line: resourceKey.Line,
			Col:  resourceKey.Column,
		}, nil
	}

	_, properties, err := cfnSourceGetKeyBody(resource, "Properties")
	if err != nil {
		return &Location{
			Path: source.filepath,
			Line: resourceKey.Line,
			Col:  resourceKey.Column,
		}, nil
	}

	// TODO: This code should return the start of the key rather than the start of the
	// body. That's what people will expect once we've added support for attribute
	// paths.
	attribute, err := cfnSourceGetPath(properties, attributePath)
	if err != nil {
		return &Location{
			Path: source.filepath,
			Line: resourceKey.Line,
			Col:  resourceKey.Column,
		}, nil
	}

	return &Location{
		Path: source.filepath,
		Line: attribute.Line,
		Col:  attribute.Column,
	}, nil
}
