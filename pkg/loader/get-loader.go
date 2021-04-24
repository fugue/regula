package loader

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader/base"
	"github.com/fugue/regula/pkg/loader/yaml"
)

type LoadedFiles struct {
	Loaders map[string]base.Loader
}

func (l *LoadedFiles) RegulaInput() []base.RegulaInput {
	input := []base.RegulaInput{}
	for _, loader := range l.Loaders {
		input = append(input, loader.RegulaInput())
	}
	return input
}

func LoadPaths(paths []string) (*LoadedFiles, error) {
	loaders := map[string]base.Loader{}
	walkDirFunc := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		ext := filepath.Ext(path)
		if !recognizedExts[ext] {
			return nil
		}
		loader, err := loadFile(path)
		if err != nil {
			// Want to ignore files we can't load when we're
			// recursing through a directory.
			return nil
		}
		loaders[path] = loader
		return nil
	}
	for _, path := range paths {
		info, err := os.Stat(path)
		if err != nil {
			return nil, err
		}
		if info.IsDir() {
			err := filepath.WalkDir(path, walkDirFunc)
			if err != nil {
				return nil, err
			}
			continue
		}
		loader, err := loadFile(path)
		if err != nil {
			return nil, err
		}
		loaders[path] = loader
	}

	if len(loaders) < 1 {
		return nil, fmt.Errorf("No loadable files in provided paths: %v", paths)
	}

	return &LoadedFiles{
		Loaders: loaders,
	}, nil
}

var recognizedExts map[string]bool = map[string]bool{
	".yaml": true,
	".yml":  true,
}

func loadFile(path string) (base.Loader, error) {
	switch ext := filepath.Ext(path); ext {
	case ".yaml", ".yml":
		return yaml.DetectYamlLoader(path)
	default:
		return nil, fmt.Errorf("Unable to detect file type for file: %s", path)
	}
}

// func LoadPathsByInputType(paths []string, inputType base.InputType) (LoadedFiles, error) {

// }

// func GetLoaderByFileName(path string) (base.Loader, error) {

// }

// func GetLoaderByInputType(path string, inputType base.InputType) (base.Loader, error) {
// 	switch inputType {
// 	case base.CfnYaml:
// 		return cfn.NewCfnYamlLoader(path)
// 	default:
// 		return nil, fmt.Errorf("Unsupported input type: %s", base.InputTypeIds[inputType])
// 	}
// }
