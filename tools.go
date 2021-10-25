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

// +build tools

package tools

import (
	// These are dependencies for `go generate`, see
	// `pkg/tf_resource_schemas/generate/main.go`.
	_ "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	_ "github.com/hashicorp/terraform-provider-google/google"
	_ "github.com/terraform-providers/terraform-provider-aws/aws"
)
