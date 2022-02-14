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
	"strings"
)

//go:generate mockgen -destination=../mocks/mock_iacconfiguration.go -package=mocks github.com/fugue/regula/v2/pkg/loader IACConfiguration
//go:generate mockgen -destination=../mocks/mock_configurationdetector.go -package=mocks github.com/fugue/regula/v2/pkg/loader ConfigurationDetector
//go:generate mockgen -destination=../mocks/mock_inputpath.go -package=mocks github.com/fugue/regula/v2/pkg/loader InputPath
//go:generate mockgen -destination=../mocks/mock_inputdirectory.go -package=mocks github.com/fugue/regula/v2/pkg/loader InputDirectory
//go:generate mockgen -destination=../mocks/mock_inputfile.go -package=mocks github.com/fugue/regula/v2/pkg/loader InputFile
//go:generate mockgen -destination=../mocks/mock_loadedconfigurations.go -package=mocks github.com/fugue/regula/v2/pkg/loader LoadedConfigurations

// stdIn is the path used for stdin.
const stdIn = "<stdin>"

// InputType is a flag that determines which types regula should look for.
type InputType int

const (
	// Auto means that regula will automatically try to determine which input types are
	// in the given paths.
	Auto InputType = iota
	// TfPlan means that regula will only look for Terraform plan JSON files in given
	// directories and it will assume that given files are Terraform plan JSON.
	TfPlan
	// Cfn means that regula will only look for CloudFormation template files in given
	// directories and it will assume that given files are CloudFormation YAML or JSON.
	Cfn
	// Tf means that regula will load the HCL in the directory in a similar
	// way to terraform plan, or it can also load individual files.
	Tf
	// Kubernetes manifests will be loaded
	K8s
	// Azure Resource Manager JSON
	Arm
)

// InputTypeIDs maps the InputType enums to string values that can be specified in
// CLI options.
var InputTypeIDs = map[InputType][]string{
	Auto:   {"auto"},
	TfPlan: {"tf-plan", "tf_plan"},
	Cfn:    {"cfn"},
	Tf:     {"tf"},
	K8s:    {"k8s", "kubernetes"},
	Arm:    {"arm"},
}

var DefaultInputTypes = InputTypeIDs[Auto]

func InputTypeFromString(name string) (InputType, error) {
	lower := strings.ToLower(name)
	for t, ids := range InputTypeIDs {
		for _, i := range ids {
			if lower == i {
				return t, nil
			}
		}
	}
	return -1, fmt.Errorf("Unrecognized input type %v", name)
}

func ValidateInputType(name string) error {
	if _, err := InputTypeFromString(name); err != nil {
		return err
	}
	return nil
}

func InputTypesFromStrings(names []string) ([]InputType, error) {
	inputTypes := make([]InputType, len(names))
	for idx, n := range names {
		t, err := InputTypeFromString(n)
		if err != nil {
			return nil, err
		}
		inputTypes[idx] = t
	}
	return inputTypes, nil
}

func ValidateInputTypes(names []string) error {
	if _, err := InputTypesFromStrings(names); err != nil {
		return err
	}
	return nil
}

// LoadedConfigurations is a container for IACConfigurations loaded by Regula.
type LoadedConfigurations interface {
	// AddConfiguration adds a configuration entry for the given path
	AddConfiguration(path string, config IACConfiguration)
	// Location resolves a file path and attribute path from the regula output to a
	// location within a file.
	Location(path string, attributePath []string) (LocationStack, error)
	// AlreadyLoaded indicates whether the given path has already been loaded as part
	// of another IACConfiguration.
	AlreadyLoaded(path string) bool
	// RegulaInput renders the RegulaInput from all of the contained configurations.
	RegulaInput() []RegulaInput
	// Count returns the number of loaded configurations.
	Count() int
}

type ConfigurationLoader func() (LoadedConfigurations, error)

// RegulaInput is a generic map that can be fed to OPA for regula.
type RegulaInput map[string]interface{}

// IACConfiguration is a loaded IaC Configuration.
type IACConfiguration interface {
	// RegulaInput returns a input for regula.
	RegulaInput() RegulaInput
	// LoadedFiles are all of the files contained within this configuration.
	LoadedFiles() []string
	// Location resolves an attribute path to to a file, line and column.
	// The first element of the attributePath is usually the resource ID.
	Location(attributePath []string) (LocationStack, error)
}

// Location is a filepath, line and column.
type Location struct {
	Path string `json:"path"`
	Line int    `json:"line"`
	Col  int    `json:"column"`
}

// In some cases, we have more than one location, for example:
//
//     attribute "foo" at line 4...
//     included in "rds" module at line 8...
//     included in "main" module at line 3...
//
// These are stored as a call stack, with the most specific location in the
// first position, and the "root of the call stack" at the last position.
type LocationStack = []Location

func (l Location) String() string {
	return fmt.Sprintf("%s:%d:%d", l.Path, l.Line, l.Col)
}

// DetectOptions are options passed to the configuration detectors.
type DetectOptions struct {
	IgnoreExt  bool
	IgnoreDirs bool
}

// ConfigurationDetector implements the visitor part of the visitor pattern for the
// concrete InputPath implementations. A ConfigurationDetector implementation must
// contain functions to visit both directories and files. An empty implementation
// must return nil, nil to indicate that the InputPath has been ignored.
type ConfigurationDetector interface {
	DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error)
	DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error)
}

// InputPath is a generic interface to represent both directories and files that
// can serve as inputs for a ConfigurationDetector.
type InputPath interface {
	DetectType(d ConfigurationDetector, opts DetectOptions) (IACConfiguration, error)
	IsDir() bool
	Path() string
	Name() string
}

// WalkFunc is a callback that's invoked on each descendent of an InputDirectory. It
// returns a boolean that, when true, indicates that i.Walk() should not be called.
type WalkFunc func(i InputPath) (skip bool, err error)

type InputDirectory interface {
	InputPath
	Walk(w WalkFunc) error
	Children() []InputPath
}

type InputFile interface {
	InputPath
	Ext() string
	Contents() ([]byte, error)
}
