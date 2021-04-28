package loader

import (
	"encoding/json"
	"fmt"
)

var CfnJsonDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (Loader, error) {
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
		_, hasTemplateFormatVersion := (*c)["AWSTemplateFormatVersion"]
		_, hasResources := (*c)["Resources"]

		if !hasTemplateFormatVersion && !hasResources {
			return nil, fmt.Errorf("Input file is not CloudFormation JSON: %v", i.Path)
		}

		return &cfnJsonLoader{
			path:    i.Path,
			content: c,
		}, nil
	},
})

type cfnJsonLoader struct {
	path    string
	content *map[string]interface{}
}

func (l *cfnJsonLoader) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}

func (l *cfnJsonLoader) Location(attributePath []string) (*Location, error) {
	return &Location{
		Path: l.path,
		Line: 0,
		Col:  0,
	}, nil
}

func (l *cfnJsonLoader) LoadedFiles() []string {
	return []string{l.path}
}
