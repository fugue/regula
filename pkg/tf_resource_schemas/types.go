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

package tf_resource_schemas

type ResourceSchemas map[string]*Schema

type Schema struct {
	Attributes map[string]*Schema `json:"attributes,omitempty"`
	Elem       *Schema            `json:"elem,omitempty"`
	Default    interface{}        `json:"default,omitempty"`
}

func GetAttribute(schema *Schema, key string) *Schema {
	if schema == nil || schema.Attributes == nil {
		return nil
	}

	if attr, ok := schema.Attributes[key]; ok {
		return attr
	}

	return nil
}

func GetElem(schema *Schema) *Schema {
	if schema == nil {
		return nil
	}
	return schema.Elem
}

func SetDefaultAttributes(schema *Schema, properties map[string]interface{}) {
	if schema == nil || schema.Attributes == nil {
		return
	}

	for key, attr := range schema.Attributes {
		if _, ok := properties[key]; !ok {
			if attr.Default != nil {
				properties[key] = attr.Default
			}
		}
	}
}
