package loader

import (
	"encoding/json"
	"fmt"
)

func JsonLoaderFactory(path string, contents []byte) (Loader, error) {
	d := &jsonDetector{}
	if err := json.Unmarshal(contents, d); err != nil {
		return nil, fmt.Errorf("Unable to parse %v as json: %v", path, err)
	}
	if d.AWSTemplateFormatVersion == "" && d.TerraformVersion == "" {
		return nil, fmt.Errorf("Unrecognized json file: %v", path)
	}

	c := &map[string]interface{}{}
	if err := json.Unmarshal(contents, c); err != nil {
		return nil, fmt.Errorf("Unable to parse %v as recognized JSON type: %v", path, err)
	}
	return &jsonLoader{
		path:    path,
		content: c,
	}, nil
}

type jsonDetector struct {
	AWSTemplateFormatVersion string `json:"AWSTemplateFormatVersion"`
	TerraformVersion         string `json:"terraform_version"`
}

type jsonLoader struct {
	path    string
	content *map[string]interface{}
}

func (l *jsonLoader) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}
