/*
 * MinIO Cloud Storage, (C) 2015, 2016 MinIO, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package rule_waivers

// MatchSimple - finds whether the text matches/satisfies the pattern string.
// supports only '*' wildcard in the pattern.
// considers a file system path as a flat name space.
func MatchSimple(pattern, name string) bool {
	if pattern == "" {
		return name == pattern
	}

	if pattern == "*" {
		return true
	}
	// Does only wildcard '*' match.
	return deepMatchRune([]rune(name), []rune(pattern), true)
}

// Match -  finds whether the text matches/satisfies the pattern string.
// supports  '*' and '?' wildcards in the pattern string.
// unlike path.Match(), considers a path as a flat name space while matching the pattern.
// The difference is illustrated in the example here https://play.golang.org/p/Ega9qgD4Qz .
func Match(pattern, name string) (matched bool) {
	if pattern == "" {
		return name == pattern
	}

	if pattern == "*" {
		return true
	}
	// Does extended wildcard '*' and '?' match.
	return deepMatchRune([]rune(name), []rune(pattern), false)
}

func MatchList(pattern string, names []string) []bool {
	var matches []bool
	for _, name := range names {
		res := Match(pattern, name)
		matches = append(matches, res)
	}
	return matches
}

func MatchListAny(pattern string, names []string) bool {
	res := MatchList(pattern, names)
	for _, v := range res {
		if v {
			return true
		}
	}
	return false
}

func MatchListAll(pattern string, names []string) bool {
	res := MatchList(pattern, names)
	for _, v := range res {
		if !v {
			return false
		}
	}
	return true
}

func deepMatchRune(str, pattern []rune, simple bool) bool {
	for len(pattern) > 0 {
		switch pattern[0] {
		default:
			if len(str) == 0 || str[0] != pattern[0] {
				return false
			}
		case '?':
			if len(str) == 0 && !simple {
				return false
			}
		case '*':
			return deepMatchRune(str, pattern[1:], simple) ||
				(len(str) > 0 && deepMatchRune(str[1:], pattern, simple))
		case '\\':
			if len(pattern) > 1 && (pattern[1] == '?' || pattern[1] == '*') {
				if str[0] != pattern[1] {
					return false
				}
				pattern = pattern[1:]
			}
		}

		str = str[1:]
		pattern = pattern[1:]
	}

	return len(str) == 0 && len(pattern) == 0
}
