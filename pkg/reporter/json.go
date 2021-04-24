package reporter

import (
	"encoding/json"

	"github.com/fugue/regula/pkg/loader"
)

func JsonReporter(l *loader.LoadedFiles, r *RegulaOutput) (string, error) {
	j, err := json.MarshalIndent(r, "", "  ")
	if err != nil {
		return "", err
	}
	return string(j), nil
}
