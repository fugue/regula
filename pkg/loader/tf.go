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
	"strings"

	"github.com/sirupsen/logrus"
	"github.com/spf13/afero"

	"github.com/snyk/policy-engine/pkg/hcl_interpreter"
)

// This is the loader that supports reading files and directories of HCL (.tf)
// files.  The implementation is in the `./pkg/hcl_interpreter/` package in the
// upgraded policy engine: this file just wraps that.  That directory also
// contains a README explaining how everything fits together.
type TfDetector struct{}

func (t *TfDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	if !opts.IgnoreExt && !hasTerraformExt(i.Path()) {
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

	moduleTree, err := hcl_interpreter.ParseFiles(nil, inputFs, false, dir, []string{i.Path()}, opts.VarFiles)
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
		if c, ok := child.(InputFile); ok && hasTerraformExt(c.Path()) {
			tfExists = true
		}
	}
	if !tfExists {
		return nil, nil
	}

	fs := &afero.OsFs{}
	moduleRegister := hcl_interpreter.NewTerraformRegister(fs, i.Path())
	moduleTree, err := hcl_interpreter.ParseDirectory(moduleRegister, fs, i.Path(), opts.VarFiles)
	if err != nil {
		return nil, err
	}

	if moduleTree != nil {
		for _, warning := range moduleTree.Errors() {
			logrus.Warn(warning)
		}
	}

	return newHclConfiguration(moduleTree)
}

type HclConfiguration struct {
	moduleTree *hcl_interpreter.ModuleTree
	evaluation *hcl_interpreter.Evaluation
}

func newHclConfiguration(moduleTree *hcl_interpreter.ModuleTree) (*HclConfiguration, error) {
	analysis := hcl_interpreter.AnalyzeModuleTree(moduleTree)
	evaluation, err := hcl_interpreter.EvaluateAnalysis(analysis)
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

	head := path[0]
	tail := []interface{}{}
	for _, part := range path[1:] {
		tail = append(tail, part)
	}

	ranges := c.evaluation.Location(head, tail)
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
			"resources":                 adapter(c.evaluation.Resources()),
		},
	}
}

func hasTerraformExt(path string) bool {
	return strings.HasSuffix(path, ".tf") || strings.HasSuffix(path, ".tf.json")
}

func adapter(resources []hcl_interpreter.Resource) map[string]interface{} {
	out := map[string]interface{}{}
	for _, model := range resources {
		resource := map[string]interface{}{}
		for k, attr := range model.Model.Attributes {
			resource[k] = attr
		}
		resource["id"] = model.Model.Id
		resource["_type"] = model.Model.ResourceType
		resource["_filepath"] = model.Meta.Location.Filename
		resource["_provider"] = model.Meta.ProviderName
		tf_populateTags(resource)
		out[model.Model.Id] = resource
	}

	return out
}

// tf_populateTags adds tags for terraform resources.  This code should be
// ported to policy-engine when we want to support tags there.
func tf_populateTags(resource interface{}) {
	resourceObj := map[string]interface{}{}
	if obj, ok := resource.(map[string]interface{}); ok {
		resourceObj = obj
	}

	tagObj := map[string]interface{}{}

	if typeStr, ok := resourceObj["_type"].(string); ok {
		if typeStr == "aws_autoscaling_group" {
			if arr, ok := resourceObj["tag"].([]interface{}); ok {
				for i := range arr {
					if obj, ok := arr[i].(map[string]interface{}); ok {
						if key, ok := obj["key"].(string); ok {
							if value, ok := obj["value"]; ok {
								tagObj[key] = value
							}
						}
					}
				}
			}
		}
	}

	if providerStr, ok := resourceObj["_provider"].(string); ok {
		if provider := strings.SplitN(providerStr, ".", 2); len(provider) > 0 {
			switch provider[0] {
			case "google":
				if tags, ok := resourceObj["labels"].(map[string]interface{}); ok {
					for k, v := range tags {
						tagObj[k] = v
					}
				}
				if tags, ok := resourceObj["tags"].([]interface{}); ok {
					for _, key := range tags {
						if str, ok := key.(string); ok {
							tagObj[str] = nil
						}
					}
				}
			default:
				if tags, ok := resourceObj["tags"].(map[string]interface{}); ok {
					for k, v := range tags {
						tagObj[k] = v
					}
				}
			}
		}
	}

	// Keep only string and nil tags
	tags := map[string]interface{}{}
	for k, v := range tagObj {
		if str, ok := v.(string); ok {
			tags[k] = str
		} else if v == nil {
			tags[k] = nil
		}
	}

	resourceObj["_tags"] = tags
}
