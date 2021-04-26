package reporter

import (
	"bytes"
	"encoding/json"

	"github.com/fugue/regula/pkg/loader"
)

func JsonReporter(l *loader.LoadedFiles, r *RegulaOutput) (string, error) {
	buf := &bytes.Buffer{}
	enc := json.NewEncoder(buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")
	if err := enc.Encode(r); err != nil {
		return "", err
	}
	return buf.String(), nil
}
