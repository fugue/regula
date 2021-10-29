package regulatf

import (
	"encoding/json"
	"io/ioutil"
	"path/filepath"

	"github.com/sirupsen/logrus"
)

////////////////////////////////////////////////////////////////////////////////
// `terraform init` downloads modules and writes a helpful file
// `.terraform/modules/modules.json` that tells us where to find modules
// {"Modules":[{"Key":"","Source":"","Dir":"."},{"Key":"acm","Source":"terraform-aws-modules/acm/aws","Version":"3.0.0","Dir":".terraform/modules/acm"}]}

type TerraformModuleRegister struct {
	data terraformModuleRegisterFile
	dir  string
}

type terraformModuleRegisterFile struct {
	Modules []terraformModuleRegisterEntry `json:"Modules"`
}

type terraformModuleRegisterEntry struct {
	Source string `json:"Source"`
	Dir    string `json:"Dir"`
}

func NewTerraformRegister(dir string) *TerraformModuleRegister {
	registry := TerraformModuleRegister{
		data: terraformModuleRegisterFile{
			[]terraformModuleRegisterEntry{},
		},
		dir: dir,
	}
	path := filepath.Join(dir, ".terraform/modules/modules.json")
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		return &registry
	}
	json.Unmarshal(bytes, &registry.data)
	logrus.Debugf("Loaded module register at %s", path)
	for _, entry := range registry.data.Modules {
		logrus.Debugf("Module register entry: %s -> %s", entry.Source, entry.Dir)
	}
	return &registry
}

func (r *TerraformModuleRegister) GetDir(source string) *string {
	for _, entry := range r.data.Modules {
		if entry.Source == source {
			joined := TfFilePathJoin(r.dir, entry.Dir)
			return &joined
		}
	}
	return nil
}
