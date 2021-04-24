# Copyright 2021 Fugue, Inc.
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

# This module detects the input format based on fields set in it.
package fugue.input_type

input_type = "terraform" {
  terraform_input_type
} else = "cloudformation" {
  cloudformation_input_type
}

terraform_input_type {
  _ = input.terraform_version
} {
  _ = input.resource_changes
} {
  _ = input.planned_values
}

cloudformation_input_type {
  _ = input.Resources
} {
  _ = input.AWSTemplateFormatVersion
}

rule_input_type(pkg) = ret {
  # This is a workaround for an issue in fregot, where the next line will fail
  # the typechecker when there isn't a single `input_type` defined, which is
  # possible if you have a folder of terraform rules.
  ret = data["rules"][pkg][k]
  k = "input_type"
} else = ret {
  ret = "terraform"
}
