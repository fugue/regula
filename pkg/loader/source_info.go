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
// information from generic JSON / YAML files.

package loader

import (
	"bytes"
	"fmt"
	"io"
	"strconv"
	"strings"

	"gopkg.in/yaml.v3"
)

type SourceInfoNode struct {
	key  *yaml.Node // Possibly nil
	body *yaml.Node
}

func LoadSourceInfoNode(contents []byte) (*SourceInfoNode, error) {
	multi, err := LoadMultiSourceInfoNode(contents)
	if err != nil {
		return nil, err
	}
	return &multi[0], nil
}

// LoadMultiSourceInfoNode parses YAML documents with multiple entries, or
// normal single YAML/JSON documents.
func LoadMultiSourceInfoNode(contents []byte) ([]SourceInfoNode, error) {
	dec := yaml.NewDecoder(bytes.NewReader(contents))
	var documents []*yaml.Node
	for {
		value := yaml.Node{}
		err := dec.Decode(&value)
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, err
		}
		if value.Kind == yaml.DocumentNode {
			for _, doc := range value.Content {
				documents = append(documents, doc)
			}
		} else {
			documents = append(documents, &value)
		}
	}

	if len(documents) < 1 {
		return nil, fmt.Errorf("No document contents")
	}

	nodes := []SourceInfoNode{}
	for _, doc := range documents {
		nodes = append(nodes, SourceInfoNode{body: doc})
	}
	return nodes, nil
}

func (node *SourceInfoNode) GetKey(key string) (*SourceInfoNode, error) {
	if node.body.Kind != yaml.MappingNode {
		return nil, fmt.Errorf("GetKey: Expected MappingNode")
	}

	for i := 0; i+1 < len(node.body.Content); i += 2 {
		if node.body.Content[i].Value == key {
			return &SourceInfoNode{key: node.body.Content[i], body: node.body.Content[i+1]}, nil
		}
	}

	return nil, fmt.Errorf("DocSourceGetKey: Key %s not found", key)
}

func (node *SourceInfoNode) GetIndex(index int) (*SourceInfoNode, error) {
	if node.body.Kind != yaml.SequenceNode {
		return nil, fmt.Errorf("DocSourceGetIndex: Expected SequenceNode")
	}

	if index < 0 || index >= len(node.body.Content) {
		return nil, fmt.Errorf("DocSourceGetIndex: index out of bounds: %d", index)
	}

	return &SourceInfoNode{body: node.body.Content[index]}, nil
}

// GetPath tries to retrieve a path as far as possible.
func (node *SourceInfoNode) GetPath(path []string) (*SourceInfoNode, error) {
	if len(path) == 0 {
		return node, nil
	}

	key := path[0]
	switch node.body.Kind {
	case yaml.MappingNode:
		child, err := node.GetKey(key)
		if err != nil {
			return node, err
		} else {
			return child.GetPath(path[1:])
		}
	case yaml.SequenceNode:
		index, err := strconv.Atoi(key)
		if err != nil {
			return node, err
		} else {
			child, err := node.GetIndex(index)
			if err != nil {
				return node, err
			} else {
				return child.GetPath(path[1:])
			}
		}
	}

	return node, fmt.Errorf("DocSourceGetPath: Expected map or array %s", strings.Join(path, "."))
}

func (node *SourceInfoNode) Location() (int, int) {
	if node.key != nil {
		return node.key.Line, node.key.Column
	} else {
		return node.body.Line, node.body.Column
	}
}
