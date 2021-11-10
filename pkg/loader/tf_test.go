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
	"encoding/json"
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"

	"github.com/fugue/regula/pkg/git"

	"github.com/stretchr/testify/assert"
)

// Utility for loading TF directories.
func DefaultParseTfDirectory(dirPath string) (IACConfiguration, error) {
	name := filepath.Base(dirPath)
	repoFinder := git.NewRepoFinder([]string{})
	directoryOpts := directoryOptions{
		Path:          dirPath,
		Name:          name,
		NoGitIgnore:   false,
		GitRepoFinder: repoFinder,
	}
	dir, err := newDirectory(directoryOpts)
	if err != nil {
		return nil, err
	}

	detectOpts := DetectOptions{
		IgnoreExt:  false,
		IgnoreDirs: false,
	}
	detector := TfDetector{}
	return detector.DetectDirectory(dir, detectOpts)
}

func TestTf(t *testing.T) {
	testDir := "tf_test"

	c, err := ioutil.ReadDir(testDir)
	if err != nil {
		t.Fatal(err)
	}

	fixTests := false
	for _, arg := range os.Args {
		if arg == "tf-test-fix" {
			fixTests = true
		}
	}

	for _, entry := range c {
		if entry.IsDir() {
			path := filepath.Join(testDir, entry.Name())
			t.Run(path, func(t *testing.T) {
				outputPath := filepath.Join(testDir, entry.Name()+".json")
				hcl, err := DefaultParseTfDirectory(path)
				if err != nil {
					t.Fatal(err)
				}
				if hcl == nil {
    				t.Fatalf("No configuration found in %s", path)
				}

				actualBytes, err := json.MarshalIndent(hcl.RegulaInput(), "", "  ")
				if err != nil {
					t.Fatal(err)
				}

				expectedBytes := []byte{}
				if _, err := os.Stat(outputPath); err == nil {
					expectedBytes, _ = ioutil.ReadFile(outputPath)
					if err != nil {
						t.Fatal(err)
					}
				}

				actual := string(actualBytes)
				expected := string(expectedBytes)
				assert.Equal(t, expected, actual)

				if fixTests {
					ioutil.WriteFile(outputPath, actualBytes, 0644)
				}
			})
		}
	}
}

func TestTfResourceLocation(t *testing.T) {
	dir := filepath.Join("tf_test", "example-terraform-modules")
	hcl, err := DefaultParseTfDirectory(dir)
	if err != nil {
		t.Fatal(err)
	}
	testInputs := []struct {
		path     []string
		expected LocationStack
	}{
		{
			path: []string{"aws_security_group.parent"},
			expected: LocationStack{
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 22,
					Col:  1,
				},
			},
		},
		{
			path: []string{"aws_vpc.parent"},
			expected: LocationStack{
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 18,
					Col:  1,
				},
			},
		},
		{
			path: []string{"module.child1.aws_vpc.child"},
			expected: LocationStack{
				Location{
					Path: filepath.Join(dir, "child1", "main.tf"),
					Line: 9,
					Col:  1,
				},
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 10,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child1.module.grandchild1.aws_security_group.grandchild"},
			expected: LocationStack{
				Location{
					Path: filepath.Join(dir, "child1", "grandchild1", "main.tf"),
					Line: 9,
					Col:  1,
				},
				Location{
					Path: filepath.Join(dir, "child1", "main.tf"),
					Line: 6,
					Col:  12,
				},
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 10,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child1.module.grandchild1.aws_vpc.grandchild"},
			expected: LocationStack{
				Location{
					Path: filepath.Join(dir, "child1", "grandchild1", "main.tf"),
					Line: 5,
					Col:  1,
				},
				Location{
					Path: filepath.Join(dir, "child1", "main.tf"),
					Line: 6,
					Col:  12,
				},
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 10,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child2.aws_security_group.child"},
			expected: LocationStack{
				Location{
					Path: filepath.Join(dir, "child2", "main.tf"),
					Line: 9,
					Col:  1,
				},
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 14,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child2.aws_vpc.child"},
			expected: []Location{
				Location{
					Path: filepath.Join(dir, "child2", "main.tf"),
					Line: 5,
					Col:  1,
				},
				Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 14,
					Col:  12,
				},
			},
		},
	}
	for _, i := range testInputs {
		loc, err := hcl.Location(i.path)
		if err != nil {
			t.Fatal(err)
		}
		assert.Equal(t, i.expected, loc)
	}
}
