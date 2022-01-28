// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package loader

import (
	"io"
	"os"
	"path/filepath"

	"github.com/fugue/regula/v2/pkg/git"
	"github.com/spf13/afero"
)

type directory struct {
	path     string
	name     string
	children []InputPath
	fs       afero.Fs
}

func (d *directory) DetectType(c ConfigurationDetector, opts DetectOptions) (IACConfiguration, error) {
	return c.DetectDirectory(d, opts)
}

func (d *directory) IsDir() bool {
	return true
}

func (d *directory) Path() string {
	return d.path
}

func (d *directory) Name() string {
	return d.name
}

func (d *directory) Walk(w WalkFunc) error {
	for _, c := range d.children {
		skip, err := w(c)
		if err != nil {
			return err
		}
		if skip {
			continue
		}
		if dir, ok := c.(InputDirectory); ok {
			if err := dir.Walk(w); err != nil {
				return err
			}
		}
	}
	return nil
}

func (d *directory) Children() []InputPath {
	return d.children
}

func (d *directory) Fs() (afero.Fs, error) {
	return d.fs, nil
}

type directoryOptions struct {
	Path          string
	Name          string
	NoGitIgnore   bool
	GitRepoFinder *git.RepoFinder
	Fs            afero.Fs
}

func newDirectory(opts directoryOptions) (InputDirectory, error) {
	contents := []InputPath{}
	entries, err := afero.ReadDir(opts.Fs, opts.Path)
	if err != nil {
		return nil, err
	}
	var repo git.Repo
	if !opts.NoGitIgnore {
		repo = opts.GitRepoFinder.FindRepo(opts.Path)
	}
	for _, e := range entries {
		n := e.Name()
		p := filepath.Join(opts.Path, n)
		if repo != nil {
			if ignored := repo.IsPathIgnored(p, e.IsDir()); ignored {
				continue
			}
		}
		var i InputPath
		if e.IsDir() {
			i, err = newDirectory(directoryOptions{
				Path:          p,
				Name:          n,
				NoGitIgnore:   opts.NoGitIgnore,
				GitRepoFinder: opts.GitRepoFinder,
				Fs:            opts.Fs,
			})
			if err != nil {
				return nil, err
			}

		} else {
			i = newFile(opts.Fs, p, n)
		}
		contents = append(contents, i)
	}
	return &directory{
		path:     opts.Path,
		name:     opts.Name,
		children: contents,
		fs:       opts.Fs,
	}, nil
}

type file struct {
	path           string
	name           string
	ext            string
	cachedContents []byte
	fs             afero.Fs
}

func (f *file) DetectType(d ConfigurationDetector, opts DetectOptions) (IACConfiguration, error) {
	return d.DetectFile(f, opts)
}

func (f *file) IsDir() bool {
	return false
}

func (f *file) Path() string {
	return f.path
}

func (f *file) Name() string {
	return f.name
}

func (f *file) Walk(w func(i InputPath) error) error {
	return nil
}

func (f *file) Ext() string {
	return f.ext
}

func (f *file) Contents() ([]byte, error) {
	if f.cachedContents != nil {
		return f.cachedContents, nil
	}
	contents, err := afero.ReadFile(f.fs, f.path)
	if err != nil {
		f.cachedContents = []byte{}
		return nil, err
	}
	f.cachedContents = contents
	return contents, nil
}

func (f *file) Fs() (afero.Fs, error) {
	return f.fs, nil
}

func newFile(fs afero.Fs, path string, name string) InputFile {
	ext := filepath.Ext(path)
	return &file{
		path: path,
		name: name,
		ext:  ext,
		fs:   fs,
	}
}

type stdInFile struct {
	*file
}

func (f *stdInFile) Contents() ([]byte, error) {
	if f.cachedContents != nil {
		return f.cachedContents, nil
	}
	contents, err := io.ReadAll(os.Stdin)
	if err != nil {
		f.cachedContents = []byte{}
		return nil, err
	}
	f.cachedContents = contents
	return contents, nil
}

func (f *stdInFile) Path() string {
	return stdIn
}

func (f *stdInFile) Name() string {
	return stdIn
}

func (f *stdInFile) Fs() (afero.Fs, error) {
	contents, err := f.Contents()
	if err != nil {
		return nil, err
	}
	inputFs := afero.NewMemMapFs()
	afero.WriteFile(inputFs, f.Path(), contents, 0644)
	return inputFs, nil
}

func newStdInFile() InputFile {
	return &stdInFile{}
}
