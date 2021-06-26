package reporter

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTextOutput(t *testing.T) {

	o := testOutput()
	result, err := TextReporter(&o)
	require.Nil(t, err)

	// For now, let's just confirm certain key aspects of the text output are
	// present, rather than checking for an exact string match. This will be
	// less fragile as we make adjustments for now.

	foundLines := map[string]bool{}
	lines := strings.Split(result, "\n")
	for _, line := range lines {
		foundLines[strings.TrimSpace(line)] = true
	}

	assert.True(t, foundLines["RULE_001: checks tags [High]"])
	assert.True(t, foundLines["[1]: t1.r1"])
	assert.True(t, foundLines["in src/infra/compute.yaml"])

	assert.True(t, foundLines["RULE_002: checks databases [Medium]"])
	assert.True(t, foundLines["[1]: t2.r2"])
	assert.True(t, foundLines["in src/infra/database.yaml"])

	assert.True(t, foundLines["Found 2 problems."])
}
