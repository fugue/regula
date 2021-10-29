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
	"path/filepath"

	"github.com/sirupsen/logrus"
	"github.com/spf13/afero"

	"github.com/fugue/regula/pkg/regulatf"
)

type TfDetector struct{}

func (t *TfDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if !opts.IgnoreExt && i.Ext() != ".tf" {
		return nil, fmt.Errorf("Expected a .tf extension for %s", i.Path())
	}
	dir := filepath.Dir(i.Path())

	var inputFs afero.Fs
	var err error
	if i.Path() == stdIn {
		inputFs, err = makeStdInFs(i)
		if err != nil {
			return nil, err
		}
	}

	moduleTree, err := regulatf.ParseFiles(nil, inputFs, false, dir, []string{i.Path()})
	if err != nil {
		return nil, err
	}

	return &HclConfiguration{moduleTree}, nil
}

func makeStdInFs(i InputFile) (afero.Fs, error) {
	contents, err := i.Contents()
	if err != nil {
		return nil, err
	}
	inputFs := afero.NewMemMapFs()
	afero.WriteFile(inputFs, i.Path(), contents, 0644)
	return inputFs, nil
}

func (t *TfDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	if opts.IgnoreDirs {
		return nil, nil
	}
	// First check that a `.tf` file exists in the directory.
	tfExists := false
	for _, child := range i.Children() {
		if c, ok := child.(InputFile); ok && c.Ext() == ".tf" {
			tfExists = true
		}
	}
	if !tfExists {
		return nil, nil
	}

	moduleRegister := regulatf.NewTerraformRegister(i.Path())
	moduleTree, err := regulatf.ParseDirectory(moduleRegister, nil, i.Path())
	if err != nil {
		return nil, err
	}

	if moduleTree != nil {
		for _, warning := range moduleTree.Warnings() {
			logrus.Warn(warning)
		}
	}

	return &HclConfiguration{moduleTree}, nil
}

type HclConfiguration struct {
	moduleTree *regulatf.ModuleTree
}

func (c *HclConfiguration) LoadedFiles() []string {
	return c.moduleTree.LoadedFiles()
}

func (c *HclConfiguration) Location(path []string) (LocationStack, error) {
	return nil, nil
}

func (c *HclConfiguration) RegulaInput() RegulaInput {
	return map[string]interface{}{}
}
