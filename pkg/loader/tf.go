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

	"github.com/fugue/regula/v2/pkg/regulatf"
)

// This is the loader that supports reading files and directories of HCL (.tf)
// files.  The implementation is in the `./pkg/regulatf/` package in this
// repository: this file just wraps that.  That directory also contains a
// README explaining how everything fits together.
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

	moduleTree, err := regulatf.ParseFiles(nil, inputFs, false, dir, []string{i.Path()}, []string{})
	if err != nil {
		return nil, err
	}

	return newHclConfiguration(moduleTree)
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

	return newHclConfiguration(moduleTree)
}

type HclConfiguration struct {
	moduleTree *regulatf.ModuleTree
	evaluation *regulatf.Evaluation
}

func newHclConfiguration(moduleTree *regulatf.ModuleTree) (*HclConfiguration, error) {
	analysis := regulatf.AnalyzeModuleTree(moduleTree)
	evaluation, err := regulatf.EvaluateAnalysis(analysis)
	if err != nil {
		return nil, err
	}

	return &HclConfiguration{
		moduleTree: moduleTree,
		evaluation: evaluation,
	}, nil
}

func (c *HclConfiguration) LoadedFiles() []string {
	return c.moduleTree.LoadedFiles()
}

func (c *HclConfiguration) Location(path []string) (LocationStack, error) {
	if len(path) < 1 {
		return nil, nil
	}

	ranges := c.evaluation.Location(path[0])
	locs := LocationStack{}
	for _, r := range ranges {
		locs = append(locs, Location{
			Path: r.Filename,
			Line: r.Start.Line,
			Col:  r.Start.Column,
		})
	}
	return locs, nil
}

func (c *HclConfiguration) RegulaInput() RegulaInput {
	return map[string]interface{}{
		"filepath": c.moduleTree.FilePath(),
		"content": map[string]interface{}{
			"hcl_resource_view_version": "0.0.1",
			"resources":                 c.evaluation.Resources(),
		},
	}
}
