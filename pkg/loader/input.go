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

	"github.com/fugue/regula/pkg/git"
)

type directory struct {
	path     string
	name     string
	children []InputPath
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

type directoryOptions struct {
	Path          string
	Name          string
	NoGitIgnore   bool
	GitRepoFinder *git.RepoFinder
}

func newDirectory(opts directoryOptions) (InputDirectory, error) {
	contents := []InputPath{}
	entries, err := os.ReadDir(opts.Path)
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
			})
			if err != nil {
				return nil, err
			}

		} else {
			i = newFile(p, n)
		}
		contents = append(contents, i)
	}
	return &directory{
		path:     opts.Path,
		name:     opts.Name,
		children: contents,
	}, nil
}

type file struct {
	path           string
	name           string
	ext            string
	cachedContents []byte
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

	if f.name == stdIn {
		contents, err := io.ReadAll(os.Stdin)
		if err != nil {
			f.cachedContents = []byte{}
			return nil, err
		}
		f.cachedContents = contents
		return contents, nil
	}

	contents, err := os.ReadFile(f.path)
	if err != nil {
		f.cachedContents = []byte{}
		return nil, err
	}
	f.cachedContents = contents
	return contents, nil
}

func newFile(path string, name string) InputFile {
	ext := filepath.Ext(path)
	return &file{
		path: path,
		name: name,
		ext:  ext,
	}
}
