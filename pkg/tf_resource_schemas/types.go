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
