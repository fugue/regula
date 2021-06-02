package main

import (
	"archive/zip"
	"fmt"
	"io"
	"os"
	"path/filepath"
)

// Unzip a zip file to the given destination directory
func unzip(src, dstDir string) error {

	r, err := zip.OpenReader(src)
	if err != nil {
		return fmt.Errorf("failed to open zip file: %s", err)
	}
	defer func() { r.Close() }()

	if err := os.MkdirAll(dstDir, 0755); err != nil {
		return fmt.Errorf("failed to create dst dir: %s", err)
	}

	// Closure to address file descriptors issue with all the deferred Close()
	extractAndWriteFile := func(f *zip.File) error {
		rc, err := f.Open()
		if err != nil {
			return err
		}
		defer func() { rc.Close() }()

		path := filepath.Join(dstDir, f.Name)

		if f.FileInfo().IsDir() {
			os.MkdirAll(path, f.Mode())
		} else {
			os.MkdirAll(filepath.Dir(path), f.Mode())
			f, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
			if err != nil {
				return err
			}
			defer func() { f.Close() }()

			if _, err = io.Copy(f, rc); err != nil {
				return err
			}
		}
		return nil
	}

	for _, f := range r.File {
		if err := extractAndWriteFile(f); err != nil {
			return fmt.Errorf("failed to extract %s: %s", f.Name, err)
		}
	}
	return nil
}
