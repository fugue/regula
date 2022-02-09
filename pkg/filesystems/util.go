package filesystems

import (
	"os"
	"path/filepath"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/afero"
)

func Abs(f afero.Fs, path string) (string, error) {
	if filepath.IsAbs(path) {
		return path, nil
	}

	if fs, ok := f.(VirtualFs); ok {
		return fs.RealPath(path), nil
	}

	// TODO: I would like to find a better way to determine that the filesystem is a
	// real filesystem.
	if f.Name() == "OsFs" {
		return filepath.Abs(path)
	}

	return path, nil
}

func Expand(f afero.Fs, path string) (string, error) {
	if f.Name() == "OsFs" || f.Name() == "BasePathFs" {
		return homedir.Expand(path)
	}

	// We're not going to expand the path if the filesystem is not a real filesystem.
	return path, nil
}

// AferoOS is intended to fulfill the doublestar.OS interface
type AferoOS struct {
	Fs afero.Fs
}

func (a *AferoOS) Lstat(name string) (os.FileInfo, error) {
	// name = b.RealPath(name)
	if lstater, ok := a.Fs.(afero.Lstater); ok {
		fi, _, err := lstater.LstatIfPossible(name)
		return fi, err
	}
	fi, err := a.Fs.Stat(name)
	return fi, err
}

func (a *AferoOS) Open(name string) (*os.File, error) {
	return a.Fs.Open(name)
}

func (a *AferoOS) PathSeperator() rune {
	return os.PathSeparator
}

func (a *AferoOS) Stat(name string) (os.FileInfo, error) {
	return a.Fs.Stat(name)
}
