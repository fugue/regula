package reporter

import (
	"bytes"
	"encoding/json"
)

func JSONReporter(r *RegulaOutput) (string, error) {
	buf := &bytes.Buffer{}
	enc := json.NewEncoder(buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")
	if err := enc.Encode(r); err != nil {
		return "", err
	}
	return buf.String(), nil
}
