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

package doublequote

import (
	"testing"
)

func Test_Doublequote(t *testing.T) {
	type Test struct {
		input    string
		expected string
	}

	tests := []Test{
		{
			input: `
# Comment 'quoted'
value = 'single_quoted'
value = "double_quoted"`,
			expected: `
# Comment 'quoted'
value = "single_quoted"
value = "double_quoted"`,
		},
		{
			input: `
raw_string = ` + "`" + `some value
with 'single quotes'` + "`" + `
# Comment 'quoted'`,
		},
		{
			input: `
value = 'some "resource" is bad'
value = "some 'resource' is bad"
value = 'some \"resource\" is bad'`,
			expected: `
value = "some \"resource\" is bad"
value = "some 'resource' is bad"
value = "some \"resource\" is bad"`,
		},
	}

	for _, tc := range tests {
		actual := Doublequote(tc.input)
		expected := tc.expected
		if expected == "" {
			expected = tc.input
		}
		if actual != expected {
			t.Fatalf("Expected: %s\nGot: %s", expected, actual)
		}
	}
}
