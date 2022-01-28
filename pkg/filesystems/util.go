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

	return filepath.Abs(path)
}
