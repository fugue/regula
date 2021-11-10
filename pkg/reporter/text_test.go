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
	assert.True(t, foundLines["[1]: r1"])
	assert.True(t, foundLines["in src/infra/compute.yaml"])

	assert.True(t, foundLines["RULE_002: checks databases [Medium]"])
	assert.True(t, foundLines["[1]: r2"])
	assert.True(t, foundLines["in src/infra/database.yaml"])

	assert.True(t, foundLines["Found 2 problems."])
}
