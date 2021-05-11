package test_inputs

import (
	"embed"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
)

//go:embed data
var data embed.FS

func Contents(t *testing.T, name string) []byte {
	contents, err := data.ReadFile(filepath.Join("data", name))
	if err != nil {
		assert.FailNow(t, err.Error())
	}
	return contents
}
