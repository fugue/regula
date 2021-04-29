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
	"os"
	"path/filepath"

	git "github.com/libgit2/git2go/v31"
)

type Repo interface {
	IsPathIgnored(path string) bool
}

type repo struct {
	path string
	repo *git.Repository
}

func (r *repo) IsPathIgnored(path string) bool {
	absPath, err := filepath.Abs(path)
	if err != nil {
		return false
	}
	// git2go's IsPathIgnored results differ from git check-ignore if you've got a
	// pattern like we do where the path matches the name of the directory. It's
	// safe to assume that this should always be false.
	if path == r.path {
		return false
	}
	ignored, _ := r.repo.IsPathIgnored(absPath)
	return ignored
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
				r, err := git.OpenRepository(filepath.Join(absPath, e.Name()))
				if err != nil {
					s.cache[absPath] = nil
					return nil
				}
				s.cache[absPath] = &repo{
					repo: r,
				}
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
