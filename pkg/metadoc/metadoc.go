package metadoc

import (
	"encoding/json"
	"io/ioutil"
	"regexp"
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

	metadocStartLine int                    // Start of metadoc, -1 if not present
	metadocEndLine   int                    // End of metadoc, -1 if not present
	metadoc          map[string]interface{} // Dynamic metadoc

	Id          string
	Title       string
	Description string
	Severity    string
	Controls    map[string][]string
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

func RegoMetaFromString(str string) (*RegoMeta, error) {
	// Split on lines.
	rego := RegoMeta{}
	rego.lines = regexp.MustCompile(`(\r\n)|\n`).Split(str, -1)

	// Run through lines to parse some bits.
	rego.packageNameLine = -1
	rego.metadocStartLine = -1
	rego.metadocEndLine = -1
	for i := 0; i < len(rego.lines); i++ {
		line := rego.lines[i]
		words := strings.Fields(line)
		if len(words) == 2 && words[0] == "package" {
			rego.PackageName = words[1]
			rego.packageNameLine = i
		}

		if len(words) == 3 && words[0] == "__rego__metadoc__" &&
			(words[1] == ":=" || words[1] == "=") &&
			words[2] == "{" {
			rego.metadocStartLine = i
			for i+1 < len(rego.lines) && rego.metadocEndLine < 0 {
				i += 1
				if rego.lines[i] == "}" {
					rego.metadocEndLine = i
				}
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

	lines := []string{}
	if rego.packageNameLine < 0 && rego.PackageName != "" {
		lines = append(lines, "package "+rego.PackageName)
		if rego.metadocStartLine < 0 && haveMetadoc {
			lines = append(lines, "", metadocString, "")
		}
	}

	for i := 0; i < len(rego.lines); i++ {
		if i == rego.packageNameLine {
			if rego.PackageName != "" {
				lines = append(lines, "package "+rego.PackageName)
			}
			if rego.metadocStartLine < 0 && haveMetadoc {
				lines = append(lines, "", metadocString)
			}
		} else if i == rego.metadocStartLine {
			lines = append(lines, metadocString)
			i = rego.metadocEndLine
		} else {
			lines = append(lines, rego.lines[i])
		}
	}

	return strings.Join(lines, "\n")
}
