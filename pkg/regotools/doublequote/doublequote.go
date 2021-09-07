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
	"strings"
)

const (
	initial = iota
	in_comment
	in_double_quote
	in_single_quote
	in_raw
)

// Doublequote turns Rego code that may have single quotes (as supported by
// fregot) into Rego code that doesn't have these without changing the meaning
// of the code.
func Doublequote(input string) string {
	var sb strings.Builder
	state := initial
	escaping := false

	for _, c := range input {
		switch state {
		case initial:
			switch c {
			case '#':
				state = in_comment
			case '"':
				state = in_double_quote
			case '\'':
				state = in_single_quote
				sb.WriteRune('"')
				continue
			case '`':
				state = in_raw
			}
		case in_comment:
			switch c {
			case '\n':
				state = initial
			}
		case in_double_quote:
			if !escaping {
				switch c {
				case '"':
					state = initial
				case '\\':
					escaping = true
					sb.WriteRune(c)
					continue
				}
			}
		case in_single_quote:
			if !escaping {
				switch c {
				case '\'':
					state = initial
					sb.WriteRune('"')
					continue
				case '"':
					sb.WriteRune('\\')
				case '\\':
					escaping = true
					sb.WriteRune(c)
					continue
				}
			}
		case in_raw:
			switch c {
			case '`':
				state = initial
			}
		}

		sb.WriteRune(c)
		escaping = false
	}

	return sb.String()
}
