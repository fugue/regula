package filesystems

import (
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/sirupsen/logrus"
	"github.com/spf13/afero"
)

// BasePathFs is a modification of Afero's BasePathFs. We want the path translation
// functionality, but we do not want to restrict operations to the target directory.
type BasePathFs struct {
	source afero.Fs
	path   string
}

type BasePathFile struct {
	afero.File
	path string
}

func (f *BasePathFile) Name() string {
	sourcename := f.File.Name()
	return strings.TrimPrefix(sourcename, filepath.Clean(f.path))
}

func NewBasePathFs(source afero.Fs, path string) afero.Fs {
	logrus.Infof("New basepathfs initialized with: %v", path)
	return &BasePathFs{source: source, path: filepath.Clean(path)}
}

func (b *BasePathFs) RealPath(name string) string {
	if filepath.IsAbs(name) {
		return name
	}

	return filepath.Clean(filepath.Join(b.path, name))

}

func (b *BasePathFs) Chtimes(name string, atime, mtime time.Time) error {
	return b.source.Chtimes(b.RealPath(name), atime, mtime)
}

func (b *BasePathFs) Chmod(name string, mode os.FileMode) error {
	return b.source.Chmod(b.RealPath(name), mode)
}

func (b *BasePathFs) Chown(name string, uid, gid int) error {
	return b.source.Chown(b.RealPath(name), uid, gid)
}

func (b *BasePathFs) Name() string {
	return "BasePathFs"
}

func (b *BasePathFs) Stat(name string) (fi os.FileInfo, err error) {
	return b.source.Stat(b.RealPath(name))
}

func (b *BasePathFs) Rename(oldname, newname string) error {
	return b.source.Rename(b.RealPath(oldname), b.RealPath(newname))
}

func (b *BasePathFs) RemoveAll(name string) error {
	return b.source.RemoveAll(b.RealPath(name))
}

func (b *BasePathFs) Remove(name string) error {
	return b.source.Remove(b.RealPath(name))
}

func (b *BasePathFs) OpenFile(name string, flag int, mode os.FileMode) (afero.File, error) {
	sourcef, err := b.source.OpenFile(b.RealPath(name), flag, mode)
	if err != nil {
		return nil, err
	}
	return &BasePathFile{sourcef, b.path}, nil
}

func (b *BasePathFs) Open(name string) (afero.File, error) {
	rp := b.RealPath(name)
	logrus.Infof("In basepathfs Open. Got input path %v and translated to real path %v", name, rp)
	sourcef, err := b.source.Open(b.RealPath(name))
	if err != nil {
		return nil, err
	}
	return &BasePathFile{File: sourcef, path: b.path}, nil
}

func (b *BasePathFs) Mkdir(name string, mode os.FileMode) error {
	return b.source.Mkdir(b.RealPath(name), mode)
}

func (b *BasePathFs) MkdirAll(name string, mode os.FileMode) error {
	return b.source.MkdirAll(b.RealPath(name), mode)
}

func (b *BasePathFs) Create(name string) (afero.File, error) {
	sourcef, err := b.source.Create(b.RealPath(name))
	if err != nil {
		return nil, err
	}
	return &BasePathFile{File: sourcef, path: b.path}, nil
}

func (b *BasePathFs) LstatIfPossible(name string) (os.FileInfo, bool, error) {
	name = b.RealPath(name)
	if lstater, ok := b.source.(afero.Lstater); ok {
		return lstater.LstatIfPossible(name)
	}
	fi, err := b.source.Stat(name)
	return fi, false, err
}

func (b *BasePathFs) SymlinkIfPossible(oldname, newname string) error {
	oldname = b.RealPath(oldname)
	newname = b.RealPath(newname)
	if linker, ok := b.source.(afero.Linker); ok {
		return linker.SymlinkIfPossible(oldname, newname)
	}
	return &os.LinkError{Op: "symlink", Old: oldname, New: newname, Err: afero.ErrNoSymlink}
}

func (b *BasePathFs) ReadlinkIfPossible(name string) (string, error) {
	name = b.RealPath(name)
	if reader, ok := b.source.(afero.LinkReader); ok {
		return reader.ReadlinkIfPossible(name)
	}
	return "", &os.PathError{Op: "readlink", Path: name, Err: afero.ErrNoReadlink}
}
