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
package fugue.input_type_internal

# These are the currently supported input types:
#
#  -  "tf"
#  -  "tf_plan"
#  -  "tf_runtime"
#  -  "cfn"
#  -  "k8s"
#
# To check the current resource type, use `input_type`.
# To check if a rule applies for this input type, use `compatibility`.

input_type = "tf" {
  _ = input.hcl_resource_view_version
} else = "tf_plan" {
  _ = input.terraform_version
} else = "tf_plan" {
  _ = input.resource_changes
} else = "tf_plan" {
  _ = input.planned_values
} else = "cfn" {
  _ = input.Resources
} else = "cfn" {
  _ = input.AWSTemplateFormatVersion
} else = "k8s" {
  _ = input.k8s_resource_view_version
} else = "unknown" {
  true
}

terraform_input_type {
  input_type == "tf"
} {
  input_type == "tf_plan"
}

cloudformation_input_type {
  input_type == "cfn"
}

kubernetes_input_type {
  input_type == "k8s"
}

rule_input_type(pkg) = ret {
  # This is a workaround for an issue in fregot, where the next line will fail
  # the typechecker when there isn't a single `input_type` defined, which is
  # possible if you have a folder of terraform rules.
  ret = data["rules"][pkg][k]
  k = "input_type"
} else = ret {
  ret = "tf"
}

# Which rule input type is applicable for which input types?
compatibility := {
  "tf":             {"tf", "tf_plan", "tf_runtime"},
  "terraform":      {"tf", "tf_plan", "tf_runtime"},  # Backwards-compatibility
  "tf_plan":        {"tf_plan"},
  "tf_runtime":     {"tf_runtime"},
  "cfn":            {"cfn"},
  "cloudformation": {"cfn"},  # Backwards-compatibility
  "k8s":            {"k8s"},
}
