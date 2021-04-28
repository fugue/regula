package git

import (
	"os"
	"path/filepath"

	git "github.com/libgit2/git2go/v31"
)

type GitRepoFinder struct {
	cache map[string]*git.Repository
}

func NewGitRepoFinder() *GitRepoFinder {
	return &GitRepoFinder{
		cache: map[string]*git.Repository{},
	}
}

func (s *GitRepoFinder) FindRepo(path string) *git.Repository {
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
				repo, err := git.OpenRepository(filepath.Join(absPath, e.Name()))
				if err != nil {
					s.cache[absPath] = nil
					return nil
				}
				s.cache[absPath] = repo
				return repo
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
