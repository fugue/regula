package loader

import (
	"fmt"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader/base"
	"github.com/fugue/regula/pkg/loader/cfn"
	"github.com/fugue/regula/pkg/loader/yaml"
)

func GetLoaderByFileName(path string) (base.Loader, error) {
	ext := filepath.Ext(path)

	switch ext {
	case ".yaml", ".yml":
		return yaml.DetectYamlLoader(path)
	default:
		return nil, fmt.Errorf("Unable to detect file type for file: %s", path)
	}
}

func GetLoaderByInputType(path string, inputType base.InputType) (base.Loader, error) {
	switch inputType {
	case base.CfnYaml:
		return cfn.NewCfnYamlLoader(path)
	default:
		return nil, fmt.Errorf("Unsupported input type: %s", base.InputTypeIds[inputType])
	}
}
