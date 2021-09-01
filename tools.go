// +build tools

package tools

import (
	// These are dependencies for `go generate`, see
	// `pkg/tf_resource_schemas/generate/main.go`.
	_ "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	_ "github.com/hashicorp/terraform-provider-google/google"
	_ "github.com/terraform-providers/terraform-provider-aws/aws"
)
