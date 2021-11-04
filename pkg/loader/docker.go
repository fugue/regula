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
	"encoding/json"
	"fmt"
	"strings"

	"github.com/moby/buildkit/frontend/dockerfile/parser"
)

type dockerfileInstruction struct {
	Type       string                   `json:"type"`
	Arguments  interface{}              `json:"arguments"`
	Original   string                   `json:"original"`
	Attributes map[string]bool          `json:"attributes"`
	StartLine  int                      `json:"start_line"`
	EndLine    int                      `json:"end_line"`
	Flags      []string                 `json:"flags"`
	Children   []*dockerfileInstruction `json:"children"`
}

type DockerfileDetector struct{}

func dockerCommandFromNode(node *parser.Node) *dockerfileInstruction {
	children := dockerSubcommandsFromNode(node)
	// Push the StartLine and EndLine values down to children, since they don't
	// otherwise have line numbers attached
	for _, sc := range children {
		sc.StartLine = node.StartLine
		sc.EndLine = node.EndLine
	}
	attributes := node.Attributes
	if attributes == nil {
		attributes = map[string]bool{}
	}
	if children == nil {
		children = []*dockerfileInstruction{}
	}
	isJSON := attributes["json"]
	var arguments interface{}
	fields := strings.Fields(node.Original)
	if len(fields) > 1 {
		argStr := strings.TrimSpace(node.Original[len(fields[0]):])
		if isJSON {
			// Deliberately ignoring errors here. If this fails then
			// argumentsJSON will just be empty.
			json.Unmarshal([]byte(argStr), &arguments)
		} else {
			arguments = argStr
		}
	}
	return &dockerfileInstruction{
		Type:       strings.ToUpper(node.Value), // from -> FROM
		Original:   node.Original,               // FROM alpine:3.12.1
		Arguments:  arguments,                   // alpine:3.12.1
		Attributes: attributes,
		StartLine:  node.StartLine,
		EndLine:    node.EndLine,
		Flags:      node.Flags,
		Children:   children,
	}
}

// Extract subcommands. Typically this is ONBUILD commands which have subcommands.
func dockerSubcommandsFromNode(node *parser.Node) []*dockerfileInstruction {
	var subcommands []*dockerfileInstruction
	for ; node.Next != nil; node = node.Next {
		arg := node.Next
		if len(arg.Children) >= 1 {
			subcommands = append(subcommands, dockerCommandFromNode(arg.Children[0]))
		}
	}
	return subcommands
}

func (c *DockerfileDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if i.Ext() != ".dockerfile" && i.Name() != "Dockerfile" {
		return nil, fmt.Errorf("file does not appear to be a dockerfile: %v", i.Path())
	}
	contents, err := i.Contents()
	if err != nil {
		return nil, err
	}
	dockerfile, err := parser.Parse(bytes.NewReader(contents))
	if err != nil {
		return nil, err
	}
	var commands []*dockerfileInstruction
	for _, n := range dockerfile.AST.Children {
		commands = append(commands, dockerCommandFromNode(n))
	}
	content := map[string]interface{}{
		"dockerfile_resource_view_version": "0.0.1",
		"commands":                         commands,
	}
	return &dockerConfiguration{
		path:    i.Path(),
		content: content,
	}, nil
}

func (c *DockerfileDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	return nil, nil
}

type dockerConfiguration struct {
	path    string
	content map[string]interface{}
}

func (l *dockerConfiguration) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}

func (l *dockerConfiguration) Location(path []string) (LocationStack, error) {
	return nil, nil
}

func (l *dockerConfiguration) LoadedFiles() []string {
	return []string{l.path}
}
