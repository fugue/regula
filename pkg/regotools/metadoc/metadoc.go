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

package metadoc

import (
	"encoding/json"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

// Utility to modify metadata of rego files.
//
// You can load this using `RegoMetaFromPath` or `RegoMetaFromString`.
//
// Then, you read and/or modify the public fields of this structure.  When
// you're done, you can turn it into a string again using `String()` and pass
// it to OPA or write it to disk.
type RegoMeta struct {
	lines []string // Lines in the file

	PackageName     string // Optional package name
	packageNameLine int    // Original package name line, -1 if not present.

	Imports         map[Import]struct{} // Imports (without aliases)
	originalImports map[Import]struct{} // Helper to determine new imports

	metadocStartLine int                    // Start of metadoc, -1 if not present
	metadocEndLine   int                    // End of metadoc, -1 if not present
	metadoc          map[string]interface{} // Dynamic metadoc

	Id          string
	Title       string
	Description string
	Severity    string
	Controls    map[string][]string

	ResourceType     string // Resource type
	resourceTypeLine int

	InputType     string // Input type
	inputTypeLine int
}

type Import struct {
	Path string
	As   string
}

func RegoMetaFromPath(path string) (*RegoMeta, error) {
	content, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}

	return RegoMetaFromString(string(content))
}

type metadocCustom struct {
	Severity string              `json:"severity"`
	Controls map[string][]string `json:"controls"`
}

type metadoc struct {
	Id          string         `json:"id"`
	Title       string         `json:"title"`
	Description string         `json:"description"`
	Custom      *metadocCustom `json:"custom,omitempty"`
}

func assignment(str string) bool {
	return str == "=" || str == ":="
}

func importFromLine(line string) *Import {
	words := strings.Fields(line)
	if len(words) == 2 && words[0] == "import" {
		return &Import{Path: words[1]}
	} else if len(words) == 4 && words[0] == "import" && words[2] == "as" {
		return &Import{Path: words[1], As: words[3]}
	} else {
		return nil
	}
}

func (imp Import) String() string {
	if imp.As == "" {
		return "import " + imp.Path
	} else {
		return "import " + imp.Path + " as " + imp.As
	}
}

func RegoMetaFromString(str string) (*RegoMeta, error) {
	// Split on lines.
	rego := RegoMeta{}
	rego.lines = regexp.MustCompile(`(\r\n)|\n`).Split(str, -1)

	// Initialize
	rego.Imports = map[Import]struct{}{}
	rego.originalImports = map[Import]struct{}{}
	rego.packageNameLine = -1
	rego.metadocStartLine = -1
	rego.metadocEndLine = -1
	rego.resourceTypeLine = -1
	rego.inputTypeLine = -1

	// Run through lines to parse some bits.
	for i := 0; i < len(rego.lines); i++ {
		line := rego.lines[i]
		// Skip non-toplevel lines
		if len(line) > 0 && line[0] != ' ' && line[0] != '\t' {
			words := strings.Fields(line)
			if len(words) == 2 && words[0] == "package" {
				rego.PackageName = words[1]
				rego.packageNameLine = i
			}

			if len(words) == 3 && words[0] == "resource_type" &&
				assignment(words[1]) {
				if val, err := strconv.Unquote(words[2]); err == nil {
					rego.ResourceType = val
					rego.resourceTypeLine = i
				}
			}

			if len(words) == 3 && words[0] == "input_type" &&
				assignment(words[1]) {
				if val, err := strconv.Unquote(words[2]); err == nil {
					rego.InputType = val
					rego.inputTypeLine = i
				}
			}

			if len(words) == 3 && words[0] == "__rego__metadoc__" &&
				assignment(words[1]) && words[2] == "{" {
				rego.metadocStartLine = i
				for i+1 < len(rego.lines) && rego.metadocEndLine < 0 {
					i += 1
					if rego.lines[i] == "}" {
						rego.metadocEndLine = i
					}
				}
			}

			if imp := importFromLine(line); imp != nil {
				rego.Imports[*imp] = struct{}{}
				rego.originalImports[*imp] = struct{}{}
			}
		}
	}

	// Parse metadoc if appropriate.
	if rego.metadocStartLine >= 0 {
		metadoc := metadoc{}
		lines := []string{"{"}
		lines = append(lines, rego.lines[rego.metadocStartLine+1:rego.metadocEndLine+1]...)
		jsonBytes := []byte(strings.Join(lines, "\n"))
		if err := json.Unmarshal(jsonBytes, &metadoc); err != nil {
			return nil, err
		}

		rego.metadoc = map[string]interface{}{}
		if err := json.Unmarshal(jsonBytes, &rego.metadoc); err != nil {
			return nil, err
		}

		rego.Id = metadoc.Id
		rego.Title = metadoc.Title
		rego.Description = metadoc.Description
		if metadoc.Custom != nil {
			rego.Controls = metadoc.Custom.Controls
			rego.Severity = metadoc.Custom.Severity
		}
	}

	return &rego, nil
}

func (rego *RegoMeta) String() string {
	// Sync metadoc
	if rego.metadoc == nil {
		rego.metadoc = map[string]interface{}{}
	}
	if rego.Id == "" {
		delete(rego.metadoc, "id")
	} else {
		rego.metadoc["id"] = rego.Id
	}
	if rego.Title == "" {
		delete(rego.metadoc, "title")
	} else {
		rego.metadoc["title"] = rego.Title
	}
	if rego.Description == "" {
		delete(rego.metadoc, "description")
	} else {
		rego.metadoc["description"] = rego.Description
	}
	custom := map[string]interface{}{}
	if c, ok := rego.metadoc["custom"]; ok {
		custom, _ = c.(map[string]interface{})
	}
	if rego.Severity == "" {
		delete(custom, "severity")
	} else {
		custom["severity"] = rego.Severity
	}
	if len(rego.Controls) == 0 {
		delete(custom, "controls")
	} else {
		custom["controls"] = rego.Controls
	}
	if len(custom) == 0 {
		delete(custom, "custom")
	} else {
		rego.metadoc["custom"] = custom
	}

	// Render metadoc
	haveMetadoc := len(rego.metadoc) > 0
	metadocString := "__rego__metadoc__ := {\n}"
	if metadocBytes, err := json.MarshalIndent(rego.metadoc, "", "  "); err == nil {
		metadocString = "__rego__metadoc__ := " + string(metadocBytes)
	}

	// Find new imports
	newImports := []string{}
	for imp := range rego.Imports {
    	if _, ok := rego.originalImports[imp]; !ok {
        	newImports = append(newImports, imp.String())
    	}
	}

	// Render a list of lines that will be placed below the package name.
	// This includes all the things that weren't in the original file.
	belowPackage := []string{}
	if len(newImports) > 0 {
    	belowPackage = append(belowPackage, strings.Join(newImports, "\n"))
	}
	if rego.metadocStartLine < 0 && haveMetadoc {
		belowPackage = append(belowPackage, metadocString)
	}
	resourceTypeString := "resource_type := " + strconv.Quote(rego.ResourceType)
	if rego.resourceTypeLine < 0 && rego.ResourceType != "" {
		belowPackage = append(belowPackage, resourceTypeString)
	}
	inputTypeString := "input_type := " + strconv.Quote(rego.InputType)
	if rego.inputTypeLine < 0 && rego.InputType != "" {
		belowPackage = append(belowPackage, inputTypeString)
	}

	// Now construct all the lines.
	lines := []string{}
	if rego.packageNameLine < 0 {
		if rego.PackageName != "" {
			lines = append(lines, "package "+rego.PackageName)
		}

		for _, l := range belowPackage {
			lines = append(lines, "", l)
		}

		if rego.PackageName != "" {
			lines = append(lines, "")
		}
	}

	for i := 0; i < len(rego.lines); i++ {
		if i == rego.packageNameLine {
			if rego.PackageName != "" {
				lines = append(lines, "package "+rego.PackageName)
			}
			for _, l := range belowPackage {
				lines = append(lines, "", l)
			}
		} else if i == rego.metadocStartLine {
			lines = append(lines, metadocString)
			i = rego.metadocEndLine
		} else if i == rego.resourceTypeLine {
			lines = append(lines, resourceTypeString)
		} else if i == rego.inputTypeLine {
			lines = append(lines, inputTypeString)
		} else if imp := importFromLine(rego.lines[i]); imp != nil {
			// Skip if deleted
			if _, ok := rego.Imports[*imp]; ok {
				lines = append(lines, rego.lines[i])
			}
		} else {
			lines = append(lines, rego.lines[i])
		}
	}

	return strings.Join(lines, "\n")
}
