package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"time"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/reporter"
)

const (
	maxUploadSize = 25 * 1024 * 1024 // 25 MB
	uploadsDir    = "uploads"
)

func findFiles(dir string) (files []string, err error) {
	err = filepath.Walk(dir,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			files = append(files, path)
			return nil
		})
	return
}

func handler(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	if r.ContentLength > maxUploadSize {
		http.Error(w, "The uploaded file is too big", http.StatusBadRequest)
		return
	}
	// Protect against malicious large uploads
	r.Body = http.MaxBytesReader(w, r.Body, maxUploadSize)

	// Create a temporary directory that will contain our Regula input files
	tmpDir, err := ioutil.TempDir("", "request-")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer os.RemoveAll(tmpDir)

	// Parse upload form
	if err := r.ParseMultipartForm(maxUploadSize); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Get file information from the form
	file, fileHeader, err := r.FormFile("input")
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	defer file.Close()

	// Sanity check the input
	fileExtension := filepath.Ext(fileHeader.Filename)
	if fileExtension != ".zip" {
		http.Error(w, "Expected a zip file", http.StatusBadRequest)
		return
	}

	fmt.Println("File received:", fileHeader.Filename)
	fmt.Println("File size:", fileHeader.Size)
	fmt.Println("File header:", fileHeader.Header)

	// Write the file to the uploads directory
	now := time.Now().UnixNano()
	uploadFilename := fmt.Sprintf("%d%s", now, fileExtension)
	uploadPath := path.Join(uploadsDir, uploadFilename)
	dst, err := os.Create(uploadPath)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer func() {
		dst.Close()
		os.RemoveAll(uploadPath)
		fmt.Println("Cleaned up temporary file:", uploadPath)
	}()

	// Copy the file from the form to the uploads directory
	_, err = io.Copy(dst, file)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	fmt.Println("Wrote temporary file:", uploadPath)

	// Unzip the uploaded archive to the temporary directory
	if err := unzip(uploadPath, tmpDir); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	inputFiles, err := findFiles(tmpDir)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	for _, inputFile := range inputFiles {
		fmt.Println("Input file:", inputFile)
	}

	// Run Regula against the input files and get the resulting report
	report, err := runRules(ctx, inputFiles, loader.Auto, reporter.JSON)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	// Write the Regula report as the HTTP response
	fmt.Fprintf(w, "%s", report)
	fmt.Println("Report sent")
}

func main() {

	// Create an uploads folder if it doesn't already exist
	if err := os.MkdirAll(uploadsDir, 0755); err != nil {
		log.Fatal(err)
	}

	// Run the web server forever
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
