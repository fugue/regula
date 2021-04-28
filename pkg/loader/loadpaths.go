package loader

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"

	"github.com/fugue/regula/pkg/git"
)

type LoadedFiles struct {
	loaders     map[string]Loader
	loadedFiles map[string]bool
}

func NewLoadedFiles() *LoadedFiles {
	return &LoadedFiles{
		loaders:     map[string]Loader{},
		loadedFiles: map[string]bool{},
	}
}

func (l *LoadedFiles) AddLoader(path string, loader Loader) {
	l.loaders[path] = loader
	for _, f := range loader.LoadedFiles() {
		l.loadedFiles[f] = true
	}
}

func (l *LoadedFiles) RegulaInput() []RegulaInput {
	keys := []string{}
	for k := range l.loaders {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	input := []RegulaInput{}
	for _, k := range keys {
		input = append(input, l.loaders[k].RegulaInput())
	}
	return input
}

func (l *LoadedFiles) Location(path string, attributePath []string) (*Location, error) {
	loader, ok := l.loaders[path]
	if !ok {
		return nil, fmt.Errorf("Unable to determine location for given path %v and attribute path %v", path, attributePath)
	}
	return loader.Location(attributePath)
}

func (l *LoadedFiles) AlreadyLoaded(path string) bool {
	return l.loadedFiles[path]
}

func (l *LoadedFiles) LoadedConfigurations() int {
	return len(l.loadedFiles)
}

type LoadPathsOptions struct {
	Paths     []string
	InputType InputType
	NoIgnore  bool
}

func LoadPaths(options LoadPathsOptions) (*LoadedFiles, error) {
	loadedFiles := NewLoadedFiles()
	detector, err := detectorByInputType(options.InputType)
	if err != nil {
		return nil, err
	}
	walkFunc := func(i *InputPath) error {
		inputPath := *i
		if loadedFiles.AlreadyLoaded(inputPath.GetPath()) {
			return nil
		}
		// Ignore errors when we're recursing
		loader, _ := inputPath.DetectType(*detector, DetectOptions{
			IgnoreExt: false,
		})
		if loader != nil {
			loadedFiles.AddLoader(inputPath.GetPath(), loader)
		}
		return nil
	}
	gitRepoFinder := git.NewGitRepoFinder()
	for _, path := range options.Paths {
		if path == "-" {
			path = StdIn
		}
		if loadedFiles.AlreadyLoaded(path) {
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
				loadedFiles.AddLoader(StdIn, loader)
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
			loadedFiles.AddLoader(path, loader)
		}
		if err := i.Walk(walkFunc); err != nil {
			return nil, err
		}
	}
	if loadedFiles.LoadedConfigurations() < 1 {
		return nil, fmt.Errorf("No loadable files in provided paths: %v", options.Paths)
	}

	return loadedFiles, nil
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
