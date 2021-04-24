package reporter

import (
	"encoding/json"

	"github.com/fugue/regula/pkg/loader/base"
)

func JsonReporter(l *base.Loader, r *RegulaOutput) (string, error) {
	j, err := json.MarshalIndent(r, "", "  ")
	if err != nil {
		return "", err
	}
	return string(j), nil
}
