package loader

import (
	"encoding/json"
	"fmt"
)

var JsonTypeDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i InputFile) (Loader, error) {
		if i.Ext != ".json" {
			return nil, nil
		}
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}
		j := &struct {
			AWSTemplateFormatVersion string `yaml:"AWSTemplateFormatVersion"`
			TerraformVersion         string `json:"terraform_version"`
		}{}
		if err := json.Unmarshal(contents, j); err != nil {
			return nil, err
		}
		if j.AWSTemplateFormatVersion == "" && j.TerraformVersion == "" {
			return nil, nil
		}
		return baseJsonLoaderFactory(i.Path, contents)
	},
})

var TfPlanDetector = *NewTypeDetector(&TypeDetector{
	DetectFile: func(i InputFile) (Loader, error) {
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}
		return baseTfPlanDetector(i.Path, contents)
	},
})

func baseTfPlanDetector(path string, contents []byte) (Loader, error) {
	j := &struct {
		TerraformVersion string `json:"terraform_version"`
	}{}
	if err := json.Unmarshal(contents, j); err != nil {
		return nil, err
	}
	if j.TerraformVersion == "" {
		return nil, nil
	}
	return baseJsonLoaderFactory(path, contents)
}

var CfnJsonDetector = *NewTypeDetector(&TypeDetector{
	DetectFile: func(i InputFile) (Loader, error) {
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}
		return baseCfnJsonDetector(i.Path, contents)
	},
})

func baseCfnJsonDetector(path string, contents []byte) (Loader, error) {
	j := &struct {
		AWSTemplateFormatVersion string `yaml:"AWSTemplateFormatVersion"`
	}{}
	if err := json.Unmarshal(contents, j); err != nil {
		return nil, err
	}
	if j.AWSTemplateFormatVersion == "" {
		return nil, nil
	}
	return baseJsonLoaderFactory(path, contents)
}

func JsonLoaderFactory(i InputPath) (Loader, error) {
	if i.IsDir() {
		return nil, nil
	}
	f, ok := i.(InputFile)
	if !ok {
		return nil, fmt.Errorf("Unable to cast input as file: %v", i.GetPath())
	}
	contents, err := f.ReadContents()
	if err != nil {
		return nil, err
	}
	return baseJsonLoaderFactory(f.Path, contents)
}

func baseJsonLoaderFactory(path string, contents []byte) (Loader, error) {
	c := &map[string]interface{}{}
	if err := json.Unmarshal(contents, c); err != nil {
		return nil, fmt.Errorf("Unable to parse %v as recognized JSON type: %v", path, err)
	}
	return &jsonLoader{
		path:    path,
		content: c,
	}, nil
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
