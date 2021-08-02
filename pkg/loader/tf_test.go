package loader_test

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"

	"github.com/fugue/regula/pkg/loader"
	"github.com/stretchr/testify/assert"
)

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
			dir := filepath.Join(testDir, entry.Name())
			outputPath := filepath.Join(testDir, entry.Name()+".json")

			hcl, err := loader.ParseDirectory([]string{}, dir, nil)
			if err != nil {
				t.Fatal(err)
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
		}
	}
}

func TestTfResourceLocation(t *testing.T) {
	dir := filepath.Join("tf_test", "example-terraform-modules")
	hcl, err := loader.ParseDirectory([]string{}, dir, nil)
	if err != nil {
		t.Fatal(err)
	}
	testInputs := []struct {
		path     []string
		expected loader.LocationStack
	}{
		{
			path: []string{"aws_security_group.parent"},
			expected: loader.LocationStack{
				loader.Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 22,
					Col:  1,
				},
			},
		},
		{
			path: []string{"aws_vpc.parent"},
			expected: loader.LocationStack{
				loader.Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 18,
					Col:  1,
				},
			},
		},
		{
			path: []string{"module.child1.aws_vpc.child"},
			expected: loader.LocationStack{
				loader.Location{
					Path: filepath.Join(dir, "child1", "main.tf"),
					Line: 9,
					Col:  1,
				},
				loader.Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 10,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child1.module.grandchild1.aws_security_group.grandchild"},
			expected: loader.LocationStack{
				loader.Location{
					Path: filepath.Join(dir, "child1", "grandchild1", "main.tf"),
					Line: 9,
					Col:  1,
				},
				loader.Location{
					Path: filepath.Join(dir, "child1", "main.tf"),
					Line: 6,
					Col:  12,
				},
				loader.Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 10,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child1.module.grandchild1.aws_vpc.grandchild"},
			expected: loader.LocationStack{
				loader.Location{
					Path: filepath.Join(dir, "child1", "grandchild1", "main.tf"),
					Line: 5,
					Col:  1,
				},
				loader.Location{
					Path: filepath.Join(dir, "child1", "main.tf"),
					Line: 6,
					Col:  12,
				},
				loader.Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 10,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child2.aws_security_group.child"},
			expected: loader.LocationStack{
				loader.Location{
					Path: filepath.Join(dir, "child2", "main.tf"),
					Line: 9,
					Col:  1,
				},
				loader.Location{
					Path: filepath.Join(dir, "main.tf"),
					Line: 14,
					Col:  12,
				},
			},
		},
		{
			path: []string{"module.child2.aws_vpc.child"},
			expected: []loader.Location{
				loader.Location{
					Path: filepath.Join(dir, "child2", "main.tf"),
					Line: 5,
					Col:  1,
				},
				loader.Location{
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
