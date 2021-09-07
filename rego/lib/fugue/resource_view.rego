# Copyright 2020-2021 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This package produces a resource view that is easier to work with than
# raw plans and templates.  It simply delegates to the appropriate package,
# see `lib/fugue/resource_view/`.
package fugue.resource_view

import data.fugue.input_type_internal
import data.fugue.resource_view.cloudformation
import data.fugue.resource_view.terraform
import data.fugue.resource_view.arm

resource_view = ret {
  # If we are already given a resource view, just pass it through.
  _ = input.hcl_resource_view_version
  ret = input.resources
} else = ret {
  input_type_internal.terraform_input_type
  ret = terraform.resource_view
} else = ret {
  input_type_internal.cloudformation_input_type
  ret = cloudformation.resource_view
} else = ret {
  input_type_internal.arm_input_type
  ret = arm.resource_view
}

resource_view_input = ret {
  _ = input.hcl_resource_view_version
  ret = {"resources": resource_view}
} else = ret {
  input_type_internal.terraform_input_type
  ret = {"resources": resource_view, "_plan": input}
} else = ret {
  input_type_internal.cloudformation_input_type
  ret = {"resources": resource_view, "_template": input}
} else = ret {
  input_type_internal.arm_input_type
  ret = {"resources": resource_view, "_template": input}
}
