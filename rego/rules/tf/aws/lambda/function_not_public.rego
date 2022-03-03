# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_aws_lambda_function_not_public

import data.fugue
import data.aws.lambda.permissions_library as lib

# Lambda function policies should not allow global access
#
# aws_lambda_permission
# aws_lambda_function

__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "Lambda function policies should not allow global access. Publicly accessible lambda functions may be runnable by anyone and could drive up your costs, disrupt your services, or leak your data.",
  "id": "FG_R00276",
  "title": "Lambda function policies should not allow global access"
}

resource_type := "MULTIPLE"

message = "Lambda function policies should not allow global access"

valid_permission(permission) {
    is_string(permission.principal)
    permission.principal != "*"
}

policy[j] {
  func = lib.funcs_by_key[k][_]
  not lib.perm_by_key[k]
  j = fugue.allow_resource(func)
} {
  permission = lib.permissions[_]
  valid_permission(permission)
  k = lib.permission_key(permission)
  f = lib.funcs_by_key[k][_]
  j = fugue.allow_resource(f)
} {
  permission = lib.permissions[_]
  not valid_permission(permission)
  k = lib.permission_key(permission)
  f = lib.funcs_by_key[k][_]
  j = fugue.deny_resource_with_message(f, message)
}
