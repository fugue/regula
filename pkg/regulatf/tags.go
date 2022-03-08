package regulatf

import (
	"strings"
)

func PopulateTags(resource interface{}) {
	resourceObj := map[string]interface{}{}
	if obj, ok := resource.(map[string]interface{}); ok {
		resourceObj = obj
	}

	tagObj := map[string]interface{}{}

	if typeStr, ok := resourceObj["_type"].(string); ok {
		if typeStr == "aws_autoscaling_group" {
			if arr, ok := resourceObj["tag"].([]interface{}); ok {
				for i := range arr {
					if obj, ok := arr[i].(map[string]interface{}); ok {
						if key, ok := obj["key"].(string); ok {
							if value, ok := obj["value"]; ok {
								tagObj[key] = value
							}
						}
					}
				}
			}
		}
	}

	if providerStr, ok := resourceObj["_provider"].(string); ok {
		if provider := strings.SplitN(providerStr, ".", 2); len(provider) > 0 {
			switch provider[0] {
			case "google":
				if tags, ok := resourceObj["labels"].(map[string]interface{}); ok {
					for k, v := range tags {
						tagObj[k] = v
					}
				}
				if tags, ok := resourceObj["tags"].([]interface{}); ok {
					for _, key := range tags {
						if str, ok := key.(string); ok {
							tagObj[str] = nil
						}
					}
				}
			default:
				if tags, ok := resourceObj["tags"].(map[string]interface{}); ok {
					for k, v := range tags {
						tagObj[k] = v
					}
				}
			}
		}
	}

	// Keep only string and nil tags
	tags := map[string]interface{}{}
	for k, v := range tagObj {
		if str, ok := v.(string); ok {
			tags[k] = str
		} else if v == nil {
			tags[k] = nil
		}
	}

	resourceObj["_tags"] = tags
}
