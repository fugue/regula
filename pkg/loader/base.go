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
	"io"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/git"
	git2go "github.com/libgit2/git2go/v31"
)

// StdIn is the path used for stdin.
const StdIn = "<stdin>"

// InputType is a flag that determines which types regula should look for.
type InputType int

const (
	// Auto means that regula will automatically try to determine which input types are
	// in the given paths.
	Auto InputType = iota
	// TfPlan means that regula will only look for Terraform plan JSON files in given
	// directories and it will assume that given files are Terraform plan JSON.
	TfPlan
	// CfnJSON means that regula will only look for CloudFormation JSON files in given
	// directories and it will assume that given files are CloudFormation JSON.
	CfnJSON
	// CfnYAML means that regula will only look for CloudFormation YAML files in given
	// directories and it will assume that given files are CloudFormation YAML.
	CfnYAML
)

// InputTypeIDs maps the InputType enums to string values that can be specified in
// CLI options.
var InputTypeIDs = map[InputType][]string{
	Auto:    {"auto"},
	TfPlan:  {"tf-plan"},
	CfnJSON: {"cfn-json"},
	CfnYAML: {"cfn-yaml"},
}

// LoadedConfigurations is a container for IACConfigurations loaded by Regula.
type LoadedConfigurations interface {
	// AddConfiguration adds a configuration entry for the given path
	AddConfiguration(path string, config IACConfiguration)
	// Location resolves a file path and attribute path from the regula output to a
	// location within a file.
	Location(path string, attributePath []string) (*Location, error)
	// AlreadyLoaded indicates whether the given path has already been loaded as part
	// of another IACConfiguration.
	AlreadyLoaded(path string) bool
	// RegulaInput renders the RegulaInput from all of the contained configurations.
	RegulaInput() []RegulaInput
	// Count returns the number of loaded configurations.
	Count() int
}

// RegulaInput is a generic map that can be fed to OPA for regula.
type RegulaInput map[string]interface{}

// IACConfiguration is a loaded IaC Configuration.
type IACConfiguration interface {
	// RegulaInput returns a input for regula.
	RegulaInput() RegulaInput
	// LoadedFiles are all of the files contained within this configuration.
	LoadedFiles() []string
	// Location resolves an attribute path to to a file, line and column.
	Location(attributePath []string) (*Location, error)
}

// Location is a filepath, line and column.
type Location struct {
	Path string
	Line int
	Col  int
}

// DetectOptions are options passed to the configuration detectors.
type DetectOptions struct {
	IgnoreExt bool
}

// ConfigurationDetector implements the visitor part of the visitor pattern for the
// concrete InputPath implementations. A ConfigurationDetector implementation must
// contain functions to visit both directories and files.
type ConfigurationDetector struct {
	DetectDirectory func(i *InputDirectory, opts DetectOptions) (IACConfiguration, error)
	DetectFile      func(i *InputFile, opts DetectOptions) (IACConfiguration, error)
}

// NewConfigurationDetector is a convenience function that will fill in empty detection
// functions for a configuration detector.
func NewConfigurationDetector(t *ConfigurationDetector) *ConfigurationDetector {
	if t.DetectDirectory == nil {
		t.DetectDirectory = func(i *InputDirectory, opts DetectOptions) (IACConfiguration, error) {
			return nil, nil
		}
	}
	if t.DetectFile == nil {
		t.DetectFile = func(i *InputFile, opts DetectOptions) (IACConfiguration, error) {
			return nil, nil
		}
	}
	return t
}

// InputPath is a generic interface to represent both directories and files that
// can serve as inputs for a ConfigurationDetector.
type InputPath interface {
	DetectType(d ConfigurationDetector, opts DetectOptions) (IACConfiguration, error)
	Children() []*InputPath
	IsDir() bool
	Walk(w func(i *InputPath) error) error
	GetPath() string
}

// InputDirectory is a concrete implementation of the InputPath interface that
// represents a directory.
type InputDirectory struct {
	Path     string
	Name     string
	Contents []*InputPath
}

func (i *InputDirectory) DetectType(d ConfigurationDetector, opts DetectOptions) (IACConfiguration, error) {
	return d.DetectDirectory(i, opts)
}

func (i *InputDirectory) Children() []*InputPath {
	return i.Contents
}

func (i *InputDirectory) IsDir() bool {
	return true
}

func (i *InputDirectory) Walk(w func(i *InputPath) error) error {
	for _, c := range i.Contents {
		if err := w(c); err != nil {
			return err
		}
		if err := (*c).Walk(w); err != nil {
			return err
		}
	}
	return nil
}

func (i InputDirectory) GetPath() string {
	return i.Path
}

// NewInputDirectoryOptions contains options for instantiating a new InputDirectory
type NewInputDirectoryOptions struct {
	Path          string
	Name          string
	NoIgnore      bool
	GitRepoFinder *git.RepoFinder
}

func NewInputDirectory(opts NewInputDirectoryOptions) (*InputDirectory, error) {
	contents := []*InputPath{}
	entries, err := os.ReadDir(opts.Path)
	if err != nil {
		return nil, err
	}
	var repo *git2go.Repository
	if !opts.NoIgnore {
		repo = opts.GitRepoFinder.FindRepo(opts.Path)
	}
	for _, e := range entries {
		n := e.Name()
		p := filepath.Join(opts.Path, n)
		if repo != nil {
			if ignored, _ := repo.IsPathIgnored(p); ignored {
				continue
			}
		}
		var i InputPath
		if e.IsDir() {
			i, err = NewInputDirectory(NewInputDirectoryOptions{
				Path:          p,
				Name:          n,
				NoIgnore:      opts.NoIgnore,
				GitRepoFinder: opts.GitRepoFinder,
			})
			if err != nil {
				return nil, err
			}

		} else {
			i = NewInputFile(p, n)
		}
		contents = append(contents, &i)
	}
	return &InputDirectory{
		Path:     opts.Path,
		Name:     opts.Name,
		Contents: contents,
	}, nil
}

type InputFile struct {
	Path           string
	Name           string
	Ext            string
	cachedContents []byte
}

func (i *InputFile) DetectType(d ConfigurationDetector, opts DetectOptions) (IACConfiguration, error) {
	return d.DetectFile(i, opts)
}

func (i *InputFile) Children() []*InputPath {
	return nil
}

func (i *InputFile) IsDir() bool {
	return false
}

func (i *InputFile) Walk(w func(i *InputPath) error) error {
	return nil
}

func (i *InputFile) GetPath() string {
	return i.Path
}

func (i *InputFile) ReadContents() ([]byte, error) {
	if i.cachedContents != nil {
		return i.cachedContents, nil
	}

	if i.Name == StdIn {
		contents, err := io.ReadAll(os.Stdin)
		if err != nil {
			i.cachedContents = []byte{}
			return nil, err
		}
		i.cachedContents = contents
		return contents, nil
	}

	contents, err := os.ReadFile(i.Path)
	if err != nil {
		i.cachedContents = []byte{}
		return nil, err
	}
	i.cachedContents = contents
	return contents, nil
}

func NewInputFile(path string, name string) *InputFile {
	ext := filepath.Ext(path)
	return &InputFile{
		Path: path,
		Name: name,
		Ext:  ext,
	}
}
