package loader

import (
	"fmt"
	"io/fs"
	"io/ioutil"
	"os"
	"path/filepath"
	"sort"

	"github.com/fugue/regula/pkg/loader/base"
	"github.com/fugue/regula/pkg/loader/cfn"
	"github.com/fugue/regula/pkg/loader/yaml"
)

type LoadedFiles struct {
	Loaders map[string]base.Loader
}

func (l *LoadedFiles) RegulaInput() []base.RegulaInput {
	keys := []string{}
	for k, _ := range l.Loaders {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	input := []base.RegulaInput{}
	for _, k := range keys {
		input = append(input, l.Loaders[k].RegulaInput())
	}
	return input
}

func LoadPaths(paths []string, inputType base.InputType) (*LoadedFiles, error) {
	loaders := map[string]base.Loader{}
	loaderFunc, err := getLoader(inputType)
	if err != nil {
		return nil, err
	}
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
		contents, err := ioutil.ReadFile(path)
		if err != nil {
			// Want to ignore files we can't load when we're
			// recursing through a directory.
			return nil
		}
		loader, err := loaderFunc(path, contents)
		if err != nil {
			// Want to ignore files we can't load when we're
			// recursing through a directory.
			return nil
		}
		loaders[path] = loader
		return nil
	}
	for _, path := range paths {
		if path == "-" {
			loader, err := loadStdin(inputType)
			if err != nil {
				return nil, err
			}
			loaders[path] = loader
			continue
		}
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
		contents, err := ioutil.ReadFile(path)
		if err != nil {
			return nil, err
		}
		loader, err := loaderFunc(path, contents)
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

func loadFile(path string, contents []byte) (base.Loader, error) {
	switch ext := filepath.Ext(path); ext {
	case ".yaml", ".yml":
		return yaml.DetectYamlLoader(path, contents)
	default:
		return nil, fmt.Errorf("Unable to detect file type for file: %s", path)
	}
}

func getLoader(inputType base.InputType) (func(path string, contents []byte) (base.Loader, error), error) {
	if inputType == base.Auto {
		return loadFile, nil
	}
	switch inputType {
	case base.CfnYaml:
		return func(path string, contents []byte) (base.Loader, error) {
			return cfn.NewCfnYamlLoader(path, contents)
		}, nil
	default:
		return nil, fmt.Errorf("Unsupported input type %v", base.InputTypeIds[inputType])
	}
}

func loadStdin(inputType base.InputType) (base.Loader, error) {
	contents, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		return nil, err
	}
	switch inputType {
	case base.CfnYaml:
		return cfn.NewCfnYamlLoader("<stdin>", contents)
	default:
		return nil, fmt.Errorf("Unsupported input type %v", base.InputTypeIds[inputType])
	}
}
