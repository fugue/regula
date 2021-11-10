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

type AutoDetector struct {
	detectors []ConfigurationDetector
}

func (a *AutoDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	if opts.IgnoreDirs {
		return nil, nil
	}
	for _, d := range a.detectors {
		l, err := i.DetectType(d, opts)
		if err == nil && l != nil {
			return l, nil
		}
	}

	return nil, nil
}

func (a *AutoDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	for _, d := range a.detectors {
		l, err := i.DetectType(d, opts)
		if err == nil && l != nil {
			return l, nil
		}
	}

	return nil, nil
}

func NewAutoDetector(detectors ...ConfigurationDetector) *AutoDetector {
	return &AutoDetector{
		detectors: detectors,
	}
}
