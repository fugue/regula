// +build tools

package tools

import (
    // These are dependencies for `go generate`, see
    // `pkg/tf_resource_schemas/generate/main.go`.
	_ "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
    _ "github.com/terraform-providers/terraform-provider-aws/aws"
    _ "github.com/terraform-providers/terraform-provider-google/google"
)
