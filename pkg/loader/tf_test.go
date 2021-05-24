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

			hcl, err := loader.ParseDirectory([]string{}, dir)
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
