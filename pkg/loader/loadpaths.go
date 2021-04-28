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
	detector, err := detectorByInputType(options.InputType)
	if err != nil {
		return nil, err
	}
	walkFunc := func(i *InputPath) error {
		// Ignore errors when we're recursing
		loader, _ := (*i).DetectType(*detector, DetectOptions{
			IgnoreExt: false,
		})
		if loader != nil {
			loaders[(*i).GetPath()] = loader
		}
		return nil
	}
	gitRepoFinder := git.NewGitRepoFinder()
	for _, path := range options.Paths {
		if path == "-" {
			i := InputFile{
				Path: "<stdin>",
				Name: "-",
				Ext:  "",
			}
			loader, err := i.DetectType(*detector, DetectOptions{
				IgnoreExt: true,
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
		loader, err := i.DetectType(*detector, DetectOptions{
			IgnoreExt: options.InputType != Auto,
		})
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

func detectorByInputType(inputType InputType) (*TypeDetector, error) {
	switch inputType {
	case Auto:
		return AutoDetector, nil
	case CfnYaml:
		return CfnYamlDetector, nil
	case CfnJson:
		return CfnJsonDetector, nil
	case TfPlan:
		return TfPlanDetector, nil
	default:
		return nil, fmt.Errorf("Unsupported input type: %v", inputType)
	}
}

var AutoDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (Loader, error) {
		l, err := i.DetectType(*TfPlanDetector, opts)
		if err == nil {
			return l, nil
		}
		l, err = i.DetectType(*CfnJsonDetector, opts)
		if err == nil {
			return l, nil
		}
		l, err = i.DetectType(*CfnYamlDetector, opts)
		if err == nil {
			return l, nil
		}

		return nil, fmt.Errorf("Unable to detect file type for file: %s", i.GetPath())
	},
})
