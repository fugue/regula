package loader

import (
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"sort"
)

type LoadedFiles struct {
	Loaders map[string]Loader
}

func (l *LoadedFiles) RegulaInput() []RegulaInput {
	keys := []string{}
	for k := range l.Loaders {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	input := []RegulaInput{}
	for _, k := range keys {
		input = append(input, l.Loaders[k].RegulaInput())
	}
	return input
}

type LoadPathsOptions struct {
	Paths     []string
	InputType InputType
}

func LoadPaths(options LoadPathsOptions) (*LoadedFiles, error) {
	loaders := map[string]Loader{}
	loaderFactory, err := loaderFactoryByInputType(options.InputType)
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
		if ext := filepath.Ext(path); !recognizedExts[ext] {
			return nil
		}
		contents, err := os.ReadFile(path)
		if err != nil {
			// Ignore files we can't read
			return nil
		}
		loader, err := loaderFactory(path, contents)
		if err != nil {
			// Ignore files we can't load
			return nil
		}
		loaders[path] = loader
		return nil
	}
	for _, path := range options.Paths {
		if path == "-" {
			contents, err := io.ReadAll(os.Stdin)
			if err != nil {
				return nil, err
			}
			loader, err := loaderFactory("<stdin>", contents)
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
		contents, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		loader, err := loaderFactory(path, contents)
		if err != nil {
			return nil, err
		}
		loaders[path] = loader
	}

	if len(loaders) < 1 {
		return nil, fmt.Errorf("No loadable files in provided paths: %v", options.Paths)
	}

	return &LoadedFiles{
		Loaders: loaders,
	}, nil
}

var recognizedExts map[string]bool = map[string]bool{
	".yaml": true,
	".yml":  true,
	".json": true,
}

func loaderFactoryByInputType(inputType InputType) (LoaderFactory, error) {
	switch inputType {
	case Auto:
		return autoLoaderFactory, nil
	case CfnYaml:
		return CfnYamlLoaderFactory, nil
	case CfnJson, TfPlan:
		return JsonLoaderFactory, nil
	default:
		return nil, fmt.Errorf("Unsupported input type: %v", inputType)
	}
}

func autoLoaderFactory(path string, contents []byte) (Loader, error) {
	if path == "<stdin>" {
		l, err := JsonLoaderFactory(path, contents)
		if err == nil {
			return l, nil
		}
		l, err = YamlLoaderFactory(path, contents)
		if err == nil {
			return l, nil
		}
		return nil, fmt.Errorf("Unable to detect input type of data from stdin.")
	}

	switch ext := filepath.Ext(path); ext {
	case ".yaml", ".yml":
		return YamlLoaderFactory(path, contents)
	case ".json":
		return JsonLoaderFactory(path, contents)
	default:
		return nil, fmt.Errorf("Unable to detect file type for file: %s", path)
	}
}
