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
	"os"
	"path/filepath"
	"sort"

	"github.com/sirupsen/logrus"

	"github.com/fugue/regula/pkg/git"
)

type LoadPathsOptions struct {
	Paths       []string
	InputType   InputType
	NoGitIgnore bool
	IgnoreDirs  bool
}

type NoLoadableConfigsError struct {
	paths []string
}

func (e *NoLoadableConfigsError) Error() string {
	return fmt.Sprintf("No loadable files in provided paths: %v", e.paths)
}

func LoadPaths(options LoadPathsOptions) (LoadedConfigurations, error) {
	configurations := newLoadedConfigurations()
	detector, err := DetectorByInputType(options.InputType)
	if err != nil {
		return nil, err
	}
	walkFunc := func(i InputPath) error {
		if configurations.AlreadyLoaded(i.Path()) {
			return nil
		}
		// Ignore errors when we're recursing
		loader, _ := i.DetectType(detector, DetectOptions{
			IgnoreExt:  false,
			IgnoreDirs: options.IgnoreDirs,
		})
		if loader != nil {
			configurations.AddConfiguration(i.Path(), loader)
		}
		return nil
	}
	gitRepoFinder := git.NewRepoFinder(options.Paths)
	for _, path := range options.Paths {
		if path == "-" {
			path = stdIn
		} else {
			path = filepath.Clean(path)
		}
		if configurations.AlreadyLoaded(path) {
			continue
		}
		if path == stdIn {
			i := newFile(stdIn, stdIn)
			loader, err := i.DetectType(detector, DetectOptions{
				IgnoreExt: true,
			})
			if err != nil {
				return nil, err
			}
			if loader != nil {
				configurations.AddConfiguration(stdIn, loader)
			} else {
				return nil, fmt.Errorf("Unable to detect input type of stdin")
			}
			continue
		}
		name := filepath.Base(path)
		info, err := os.Stat(path)
		if err != nil {
			return nil, err
		}
		if info.IsDir() {
			// We want to override the gitignore behavior if the user explicitly gives
			// us a directory that is ignored.
			noIgnore := options.NoGitIgnore
			if !noIgnore {
				if repo := gitRepoFinder.FindRepo(path); repo != nil {
					noIgnore = repo.IsPathIgnored(path, true)
				}
			}
			i, err := newDirectory(directoryOptions{
				Path:          path,
				Name:          name,
				NoGitIgnore:   noIgnore,
				GitRepoFinder: gitRepoFinder,
			})
			if err != nil {
				return nil, err
			}
			loader, err := i.DetectType(detector, DetectOptions{
				IgnoreExt:  options.InputType != Auto,
				IgnoreDirs: options.IgnoreDirs,
			})
			if err != nil {
				return nil, err
			}
			if loader != nil {
				configurations.AddConfiguration(path, loader)
			}
			if err := i.Walk(walkFunc); err != nil {
				return nil, err
			}
		} else {
			i := newFile(path, name)
			loader, err := i.DetectType(detector, DetectOptions{
				IgnoreExt: options.InputType != Auto,
			})
			if err != nil {
				return nil, err
			}
			if loader != nil {
				configurations.AddConfiguration(path, loader)
			} else {
				return nil, fmt.Errorf("Unable to detect input type of file %v", i.Path())
			}
		}
	}
	if configurations.Count() < 1 {
		return nil, &NoLoadableConfigsError{options.Paths}
	}

	return configurations, nil
}

type loadedConfigurations struct {
	configurations map[string]IACConfiguration
	// The corresponding key in configurations for every loaded path
	loadedPaths map[string]string
}

func newLoadedConfigurations() *loadedConfigurations {
	return &loadedConfigurations{
		configurations: map[string]IACConfiguration{},
		loadedPaths:    map[string]string{},
	}
}

func (l *loadedConfigurations) AddConfiguration(path string, config IACConfiguration) {
	l.configurations[path] = config
	l.loadedPaths[path] = path
	for _, f := range config.LoadedFiles() {
		l.loadedPaths[f] = path
		logrus.Debugf("loadedPaths[%s] -> %s", f, path)
	}
}

func (l *loadedConfigurations) RegulaInput() []RegulaInput {
	keys := []string{}
	for k := range l.configurations {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	input := []RegulaInput{}
	for _, k := range keys {
		input = append(input, l.configurations[k].RegulaInput())
	}
	return input
}

func (l *loadedConfigurations) Location(path string, attributePath []string) (LocationStack, error) {
	canonical, ok := l.loadedPaths[path]
	if !ok {
		return nil, fmt.Errorf("Unable to determine location for given path %v and attribute path %v", path, attributePath)
	}
	loader, _ := l.configurations[canonical]
	return loader.Location(attributePath)
}

func (l *loadedConfigurations) AlreadyLoaded(path string) bool {
	_, ok := l.loadedPaths[path]
	return ok
}

func (l *loadedConfigurations) Count() int {
	return len(l.configurations)
}

func DetectorByInputType(inputType InputType) (ConfigurationDetector, error) {
	switch inputType {
	case Auto:
		return NewAutoDetector(
			&CfnDetector{},
			&TfPlanDetector{},
			&TfDetector{},
			&ArmDetector{},
		), nil
	case Cfn:
		return &CfnDetector{}, nil
	case TfPlan:
		return &TfPlanDetector{}, nil
	case Tf:
		return &TfDetector{}, nil
	case Arm:
		return &ArmDetector{}, nil
	default:
		return nil, fmt.Errorf("Unsupported input type: %v", inputType)
	}
}
