package loader

import (
	"encoding/json"
	"fmt"
)

var TfPlanDetector = NewConfigurationDetector(&ConfigurationDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (IACConfiguration, error) {
		if !opts.IgnoreExt && i.Ext != ".json" {
			return nil, fmt.Errorf("File does not have .json extension: %v", i.Path)
		}
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}
		c := &map[string]interface{}{}
		if err := json.Unmarshal(contents, c); err != nil {
			return nil, fmt.Errorf("Failed to parse JSON file %v: %v", i.Path, err)
		}
		_, hasTerraformVersion := (*c)["terraform_version"]

		if !hasTerraformVersion {
			return nil, fmt.Errorf("Input file is not Terraform Plan JSON: %v", i.Path)
		}

		return &tfPlanLoader{
			path:    i.Path,
			content: c,
		}, nil
	},
})

type tfPlanLoader struct {
	path    string
	content *map[string]interface{}
}

func (l *tfPlanLoader) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}

func (l *tfPlanLoader) LoadedFiles() []string {
	return []string{l.path}
}

func (l *tfPlanLoader) Location(attributePath []string) (*Location, error) {
	return &Location{
		Path: l.path,
		Line: 0,
		Col:  0,
	}, nil
}
