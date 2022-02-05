package filesystems

import (
	"path/filepath"

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
