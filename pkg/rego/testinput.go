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

package rego

import (
	"bytes"
	_ "embed"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"github.com/fugue/regula/v2/pkg/loader"
)

//go:embed testinput.tmpl
var inputTemplate string

type templateArgs struct {
	Package string
	Config  string
}

func NewTestInput(regulaInput loader.RegulaInput) (RegoFile, error) {
	t, err := template.New("testInput").Parse(inputTemplate)
	if err != nil {
		return nil, err
	}
	f, ok := regulaInput["filepath"]
	if !ok {
		return nil, fmt.Errorf("Failed to extract filepath from test input.")
	}
	path, ok := f.(string)
	if !ok {
		return nil, fmt.Errorf("Invalid type for filepath in test input.")
	}
	content, ok := regulaInput["content"]
	if !ok {
		return nil, fmt.Errorf("Failed to extract content from test input %v.", path)
	}
	buf := &bytes.Buffer{}
	enc := json.NewEncoder(buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")
	if err := enc.Encode(content); err != nil {
		return nil, err
	}
	contentBuf := &bytes.Buffer{}
	args := templateArgs{
		Package: pathToPackage(path),
		Config:  buf.String(),
	}
	if err := t.Execute(contentBuf, args); err != nil {
		return nil, err
	}
	return &regoFile{
		path:     pathToRegoPath(path),
		contents: contentBuf.Bytes(),
	}, nil
}

func pathToRegoPath(path string) string {
	ext := filepath.Ext(path)
	return strings.Join([]string{
		strings.TrimSuffix(path, ext),
		strings.ReplaceAll(ext, ".", "_"),
		".rego",
	}, "")
}

func pathToPackage(path string) string {
	p := strings.TrimPrefix(path, filepath.VolumeName(path))
	p = strings.TrimPrefix(p, string(os.PathSeparator))
	p = strings.ReplaceAll(p, ".", "_")
	p = strings.ReplaceAll(p, "-", "_")
	return strings.ReplaceAll(p, string(os.PathSeparator), ".")
}
