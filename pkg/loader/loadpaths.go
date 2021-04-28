package loader

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"

	"github.com/fugue/regula/pkg/git"
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
	NoIgnore  bool
}

func LoadPaths(options LoadPathsOptions) (*LoadedFiles, error) {
	loaders := map[string]Loader{}
	loaderFactory, err := loaderFactoryByInputType(options.InputType)
	if err != nil {
		return nil, err
	}
	walkFunc := func(i InputPath) error {
		// Ignore errors when we're recursing
		loader, _ := loaderFactory(i)
		if loader != nil {
			loaders[i.GetPath()] = loader
		}
		return nil
	}
	gitRepoFinder := git.NewGitRepoFinder()
	for _, path := range options.Paths {
		if path == "-" {
			loader, err := loaderFactory(InputFile{
				Path: "<stdin>",
				Name: "-",
				Ext:  "",
			})
			if err != nil {
				return nil, err
			}
			if loader != nil {
				loaders[path] = loader
			}
			continue
		}
		name := filepath.Base(path)
		info, err := os.Stat(path)
		if err != nil {
			return nil, err
		}
		var i InputPath
		if info.IsDir() {
			i, err = NewInputDirectory(NewInputDirectoryOptions{
				Path:          path,
				Name:          name,
				NoIgnore:      options.NoIgnore,
				GitRepoFinder: gitRepoFinder,
			})
			if err != nil {
				return nil, err
			}
		} else {
			i = NewInputFile(path, name)
		}
		loader, err := loaderFactory(i)
		if err != nil {
			return nil, err
		}
		if loader != nil {
			loaders[path] = loader
		}
		if err := i.Walk(walkFunc); err != nil {
			return nil, err
		}
	}
	if len(loaders) < 1 {
		return nil, fmt.Errorf("No loadable files in provided paths: %v", options.Paths)
	}

	return &LoadedFiles{
		Loaders: loaders,
	}, nil
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

func autoLoaderFactory(i InputPath) (Loader, error) {
	if i.IsDir() {
		return nil, nil
	}

	if i.GetPath() == "<stdin>" {
		l, err := JsonLoaderFactory(i)
		if err == nil {
			return l, nil
		}
		l, err = CfnYamlLoaderFactory(i)
		if err == nil {
			return l, nil
		}
		return nil, fmt.Errorf("Unable to detect input type of data from stdin.")
	}

	l, err := i.DetectType(*YamlTypeDetector)
	if err != nil {
		return nil, err
	}
	if l != nil {
		return l, nil
	}
	l, err = i.DetectType(*JsonTypeDetector)
	if err != nil {
		return nil, err
	}
	if l != nil {
		return l, nil
	}

	return nil, fmt.Errorf("Unable to detect file type for file: %s", i.GetPath())
}
