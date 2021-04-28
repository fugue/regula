package loader

import (
	"io"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/git"
	git2go "github.com/libgit2/git2go/v31"
)

const StdIn = "<stdin>"

type InputType int

const (
	Auto InputType = iota
	TfPlan
	CfnJson
	CfnYaml
)

var InputTypeIds = map[InputType][]string{
	Auto:    {"auto"},
	TfPlan:  {"tf-plan"},
	CfnJson: {"cfn-json"},
	CfnYaml: {"cfn-yaml"},
}

type LoadedPaths interface {
	AddLoader(loader Loader)
	Location(path string, attributePath []string) (*Location, error)
	AlreadyLoaded(path string) bool
	RegulaInput() []RegulaInput
	LoadedConfigurations() int
}

type RegulaInput map[string]interface{}

type Loader interface {
	RegulaInput() RegulaInput
	LoadedFiles() []string
	Location(attributePath []string) (*Location, error)
}

type Location struct {
	Path string
	Line int
	Col  int
}

type LocationAwareLoader interface {
}

type LoaderFactory func(inputPath InputPath) (Loader, error)

type DetectOptions struct {
	IgnoreExt bool
}

type TypeDetector struct {
	DetectDirectory func(i *InputDirectory, opts DetectOptions) (Loader, error)
	DetectFile      func(i *InputFile, opts DetectOptions) (Loader, error)
}

func NewTypeDetector(t *TypeDetector) *TypeDetector {
	if t.DetectDirectory == nil {
		t.DetectDirectory = func(i *InputDirectory, opts DetectOptions) (Loader, error) {
			return nil, nil
		}
	}
	if t.DetectFile == nil {
		t.DetectFile = func(i *InputFile, opts DetectOptions) (Loader, error) {
			return nil, nil
		}
	}
	return t
}

type InputPath interface {
	DetectType(d TypeDetector, opts DetectOptions) (Loader, error)
	Children() []*InputPath
	IsDir() bool
	Walk(w func(i *InputPath) error) error
	GetPath() string
}
type InputDirectory struct {
	Path     string
	Name     string
	Contents []*InputPath
}

func (i *InputDirectory) DetectType(d TypeDetector, opts DetectOptions) (Loader, error) {
	return d.DetectDirectory(i, opts)
}

func (i *InputDirectory) Children() []*InputPath {
	return i.Contents
}

func (i *InputDirectory) IsDir() bool {
	return true
}

func (i *InputDirectory) Walk(w func(i *InputPath) error) error {
	for _, c := range i.Contents {
		if err := w(c); err != nil {
			return err
		}
		if err := (*c).Walk(w); err != nil {
			return err
		}
	}
	return nil
}

func (i InputDirectory) GetPath() string {
	return i.Path
}

type NewInputDirectoryOptions struct {
	Path          string
	Name          string
	NoIgnore      bool
	GitRepoFinder *git.GitRepoFinder
}

func NewInputDirectory(opts NewInputDirectoryOptions) (*InputDirectory, error) {
	contents := []*InputPath{}
	entries, err := os.ReadDir(opts.Path)
	if err != nil {
		return nil, err
	}
	var repo *git2go.Repository
	if !opts.NoIgnore {
		repo = opts.GitRepoFinder.FindRepo(opts.Path)
	}
	for _, e := range entries {
		n := e.Name()
		p := filepath.Join(opts.Path, n)
		if repo != nil {
			if ignored, _ := repo.IsPathIgnored(p); ignored {
				continue
			}
		}
		var i InputPath
		if e.IsDir() {
			i, err = NewInputDirectory(NewInputDirectoryOptions{
				Path:          p,
				Name:          n,
				NoIgnore:      opts.NoIgnore,
				GitRepoFinder: opts.GitRepoFinder,
			})
			if err != nil {
				return nil, err
			}

		} else {
			i = NewInputFile(p, n)
		}
		contents = append(contents, &i)
	}
	return &InputDirectory{
		Path:     opts.Path,
		Name:     opts.Name,
		Contents: contents,
	}, nil
}

type InputFile struct {
	Path           string
	Name           string
	Ext            string
	cachedContents []byte
}

func (i *InputFile) DetectType(d TypeDetector, opts DetectOptions) (Loader, error) {
	return d.DetectFile(i, opts)
}

func (i *InputFile) Children() []*InputPath {
	return nil
}

func (i *InputFile) IsDir() bool {
	return false
}

func (i *InputFile) Walk(w func(i *InputPath) error) error {
	return nil
}

func (i *InputFile) GetPath() string {
	return i.Path
}

func (i *InputFile) ReadContents() ([]byte, error) {
	if i.cachedContents != nil {
		return i.cachedContents, nil
	}

	if i.Name == StdIn {
		contents, err := io.ReadAll(os.Stdin)
		if err != nil {
			i.cachedContents = []byte{}
			return nil, err
		}
		i.cachedContents = contents
		return contents, nil
	} else {
		contents, err := os.ReadFile(i.Path)
		if err != nil {
			i.cachedContents = []byte{}
			return nil, err
		}
		i.cachedContents = contents
		return contents, nil
	}
}

func NewInputFile(path string, name string) *InputFile {
	ext := filepath.Ext(path)
	return &InputFile{
		Path: path,
		Name: name,
		Ext:  ext,
	}
}
