package tf_resource_schemas

import (
	_ "embed"
	"encoding/json"
)

//go:embed resource_schemas.json
var resourceSchemasJson []byte

var resourceSchemas ResourceSchemas

func LoadResourceSchemas() ResourceSchemas {
    if resourceSchemas != nil {
        return resourceSchemas
    }

    resourceSchemas := make(ResourceSchemas)
    err := json.Unmarshal(resourceSchemasJson, &resourceSchemas)
    if err != nil {
        panic(err)
    }
	return resourceSchemas
}
