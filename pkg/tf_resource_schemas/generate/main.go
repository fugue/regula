// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Generates a minimal version of terraform's resource schemas that has just
// the info we need and that we can embed easily.  Note that these schemas
// focus on how the resource types will be represented in JSON.
package main

import (
	"encoding/json"
	"os"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	provider_google "github.com/hashicorp/terraform-provider-google/google"
	provider_aws "github.com/terraform-providers/terraform-provider-aws/aws"

	"github.com/fugue/regula/pkg/tf_resource_schemas"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func ExtractResourceSchema(r *schema.Resource) *tf_resource_schemas.Schema {
	objectSchema := new(tf_resource_schemas.Schema)
	objectSchema.Attributes = make(map[string]*tf_resource_schemas.Schema)
	for key, attr := range r.Schema {
		attrSchema := ExtractSchema(attr)
		if attrSchema != nil {
			objectSchema.Attributes[key] = attrSchema
		}
	}

	if len(objectSchema.Attributes) > 0 {
		return objectSchema
	} else {
		return nil
	}
}

func ExtractSchema(s *schema.Schema) *tf_resource_schemas.Schema {
	switch elem := s.Elem.(type) {
	case *schema.Resource:
		elemSchema := ExtractResourceSchema(elem)
		if elemSchema != nil {
			return &tf_resource_schemas.Schema{Elem: elemSchema}
		} else {
			return nil
		}
	}

	if s.Default != nil {
		return &tf_resource_schemas.Schema{Default: s.Default}
	}

	if s.DefaultFunc != nil {
		def, err := s.DefaultFunc()
		if err == nil {
			return &tf_resource_schemas.Schema{Default: def}
		}
	}

	return nil
}

func main() {
	f, err := os.Create("pkg/tf_resource_schemas/resource_schemas.json")
	check(err)
	defer f.Close()

	resourceSchemas := make(tf_resource_schemas.ResourceSchemas)

	providers := []*schema.Provider{
		provider_aws.Provider(),
		provider_google.Provider(),
	}

	for _, provider := range providers {
		for resourceType, resource := range provider.ResourcesMap {
			resourceSchema := ExtractResourceSchema(resource)
			if resourceSchema != nil {
				resourceSchemas[resourceType] = resourceSchema
			}
		}
	}

	bytes, err := json.Marshal(resourceSchemas)
	check(err)
	f.Write(bytes)
}
