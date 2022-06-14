package regulatf

import (
	"path/filepath"
	"sort"

	"github.com/spf13/afero"
)

func findVarFiles(fs afero.Fs, dir string) ([]string, error) {
	if fs == nil {
		fs = afero.OsFs{}
	}

	// We want to sort files by basename.  The spec is:
	//
	//  -  Environment variables
	//  -  The terraform.tfvars file, if present.
	//  -  The terraform.tfvars.json file, if present.
	//  -  Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical
	//     order of their filenames.
	//  -  -var and -var-file options on the command line, in the order they are
	//     provided. (This includes variables set by Terraform Cloud workspace.)
	//
	// Source: <https://www.terraform.io/language/values/variables#variable-definition-precedence>
	globs := []string{
		filepath.Join(dir, "terraform.tfvars"),
		filepath.Join(dir, "terraform.tfvars.json"),
		filepath.Join(dir, "*.auto.tfvars"),
		filepath.Join(dir, "*.auto.tfvars.json"),
	}
	matches := []string{}
	for _, glob := range globs {
		m, err := afero.Glob(fs, glob)
		if err != nil {
			return matches, err
		}
		matches = append(sort.StringSlice(matches), m...)
	}
	return matches, nil
}
