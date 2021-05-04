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

package git

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/go-git/go-billy/v5/osfs"
	"github.com/go-git/go-git/v5/plumbing/format/gitignore"
)

var defaultGitIgnorePatterns = []gitignore.Pattern{
	gitignore.ParsePattern("..", []string{}),
	gitignore.ParsePattern(".git", []string{}),
}

type Repo interface {
	IsPathIgnored(path string, isDir bool) bool
}

type repo struct {
	path          string
	ignoreMatcher gitignore.Matcher
}

func NewRepo(path string) (Repo, error) {
	fsys := osfs.New(path)
	patterns, err := gitignore.ReadPatterns(fsys, nil)
	if err != nil {
		return nil, err
	}
	patterns = append(patterns, defaultGitIgnorePatterns...)
	return &repo{
		path:          path,
		ignoreMatcher: gitignore.NewMatcher(patterns),
	}, nil
}

func (r *repo) IsPathIgnored(path string, isDir bool) bool {
	fmt.Println("Got path", path)
	absPath, err := filepath.Abs(path)
	if err != nil {
		return false
	}
	relPath, err := filepath.Rel(r.path, absPath)
	if err != nil {
		return false
	}
	splitPath := strings.Split(relPath, string(os.PathSeparator))
	return r.ignoreMatcher.Match(splitPath, isDir)
}

// RepoFinder finds the git repository for a given directory.
type RepoFinder struct {
	cache map[string]Repo
}

// NewRepoFinder returns a new RepoFinder instance
func NewRepoFinder() *RepoFinder {
	return &RepoFinder{
		cache: map[string]Repo{},
	}
}

// FindRepo takes a directory path and finds the git repository for it if one exists.
// It works by searching within the given directory, followed by searching in parent
// directories until it either reaches the top-level directory or encounters an error.
func (s *RepoFinder) FindRepo(path string) Repo {
	fmt.Println("In find repo", path)
	absPath, err := filepath.Abs(path)
	if err != nil {
		return nil
	}
	lastPath := ""
	traversedPaths := []string{}
	for absPath != lastPath {
		if foundRepo, ok := s.cache[absPath]; ok {
			return foundRepo
		}
		entries, err := os.ReadDir(absPath)
		if err != nil {
			// Store nil so that we don't retry this operation when child dirs are
			// passed in.
			s.cache[absPath] = nil
			return nil
		}
		for _, e := range entries {
			if e.Name() == ".git" {
				fmt.Println("Found repo", absPath)
				r, err := NewRepo(absPath)
				if err != nil {
					s.cache[absPath] = nil
					return nil
				}
				s.cache[absPath] = r
				return s.cache[absPath]
			}
		}
		traversedPaths = append(traversedPaths, absPath)
		lastPath = absPath
		absPath = filepath.Dir(absPath)
	}
	// At this point we've traversed to the top of the tree and haven't found
	// anything. We'll cache all traversed paths so that we don't repeat the
	// list operations for child dirs.
	for _, p := range traversedPaths {
		s.cache[p] = nil
	}
	return nil
}
