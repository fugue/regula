package loader

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"

	"github.com/fugue/regula/pkg/git"
)

type LoadPathsOptions struct {
	Paths     []string
	InputType InputType
	NoIgnore  bool
}

func LoadPaths(options LoadPathsOptions) (LoadedConfigurations, error) {
	configurations := newLoadedConfigurations()
	detector, err := detectorByInputType(options.InputType)
	if err != nil {
		return nil, err
	}
	walkFunc := func(i *InputPath) error {
		inputPath := *i
		if configurations.AlreadyLoaded(inputPath.GetPath()) {
			return nil
		}
		// Ignore errors when we're recursing
		loader, _ := inputPath.DetectType(*detector, DetectOptions{
			IgnoreExt: false,
		})
		if loader != nil {
			configurations.AddConfiguration(inputPath.GetPath(), loader)
		}
		return nil
	}
	gitRepoFinder := git.NewRepoFinder()
	for _, path := range options.Paths {
		if path == "-" {
			path = StdIn
		}
		if configurations.AlreadyLoaded(path) {
			continue
		}
		if path == StdIn {
			i := InputFile{
				Path: StdIn,
				Name: StdIn,
				Ext:  "",
			}
			loader, err := i.DetectType(*detector, DetectOptions{
				IgnoreExt: true,
			})
			if err != nil {
				return nil, err
			}
			if loader != nil {
				configurations.AddConfiguration(StdIn, loader)
				// loaders[path] = loader
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
			// We want to override the gitignore behavior if the user explicitly gives
			// us a directory that is ignored.
			noIgnore := options.NoIgnore
			if !noIgnore {
				repo := gitRepoFinder.FindRepo(path)
				ignored, _ := repo.IsPathIgnored(path)
				if ignored {
					noIgnore = true
				}
			}
			i, err = NewInputDirectory(NewInputDirectoryOptions{
				Path:          path,
				Name:          name,
				NoIgnore:      noIgnore,
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
			configurations.AddConfiguration(path, loader)
		}
		if err := i.Walk(walkFunc); err != nil {
			return nil, err
		}
	}
	if configurations.Count() < 1 {
		return nil, fmt.Errorf("No loadable files in provided paths: %v", options.Paths)
	}

	return configurations, nil
}

type loadedConfigurations struct {
	configurations map[string]IACConfiguration
	loadedPaths    map[string]bool
}

func newLoadedConfigurations() *loadedConfigurations {
	return &loadedConfigurations{
		configurations: map[string]IACConfiguration{},
		loadedPaths:    map[string]bool{},
	}
}

func (l *loadedConfigurations) AddConfiguration(path string, config IACConfiguration) {
	l.configurations[path] = config
	for _, f := range config.LoadedFiles() {
		l.loadedPaths[f] = true
	}
}

func (l *loadedConfigurations) RegulaInput() []RegulaInput {
	keys := []string{}
	for k := range l.configurations {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	input := []RegulaInput{}
	for _, k := range keys {
		input = append(input, l.configurations[k].RegulaInput())
	}
	return input
}

func (l *loadedConfigurations) Location(path string, attributePath []string) (*Location, error) {
	loader, ok := l.configurations[path]
	if !ok {
		return nil, fmt.Errorf("Unable to determine location for given path %v and attribute path %v", path, attributePath)
	}
	return loader.Location(attributePath)
}

func (l *loadedConfigurations) AlreadyLoaded(path string) bool {
	return l.loadedPaths[path]
}

func (l *loadedConfigurations) Count() int {
	return len(l.configurations)
}

func detectorByInputType(inputType InputType) (*ConfigurationDetector, error) {
	switch inputType {
	case Auto:
		return AutoDetector, nil
	case CfnYAML:
		return CfnYAMLDetector, nil
	case CfnJSON:
		return CfnJSONDetector, nil
	case TfPlan:
		return TfPlanDetector, nil
	default:
		return nil, fmt.Errorf("Unsupported input type: %v", inputType)
	}
}

var AutoDetector = NewConfigurationDetector(&ConfigurationDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (IACConfiguration, error) {
		l, err := i.DetectType(*TfPlanDetector, opts)
		if err == nil {
			return l, nil
		}
		l, err = i.DetectType(*CfnJSONDetector, opts)
		if err == nil {
			return l, nil
		}
		l, err = i.DetectType(*CfnYAMLDetector, opts)
		if err == nil {
			return l, nil
		}

		return nil, fmt.Errorf("Unable to detect file type for file: %s", i.GetPath())
	},
})
