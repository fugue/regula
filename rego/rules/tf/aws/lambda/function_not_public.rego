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
package rules.aws_lambda_function_not_public

import data.fugue
import data.fugue.utils

# Lambda function policies should not allow global access
#
# aws_lambda_permission
# aws_lambda_function


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "High"
  },
  "description": "Lambda function policies should not allow global access. Publicly accessible lambda functions may be runnable by anyone and could drive up your costs, disrupt your services, or leak your data.",
  "id": "FG_R00276",
  "title": "Lambda function policies should not allow global access"
}

resource_type = "MULTIPLE"

message = "Lambda function policies should not allow global access"

permissions = fugue.resources("aws_lambda_permission")
functions = fugue.resources("aws_lambda_function")

function_key(func) = ret {
    ret = sprintf("%s/%s", [utils.provider(func), func.function_name])
}

permission_key(perm) = ret {
    ret = sprintf("%s/%s", [utils.provider(perm), perm.function_name])
}

# Obviously functions names are unique so we shouldn't have multiple functions
# that share a name.  However, this can be the case if e.g. regula doesn't pick
# up names correctly, so we want to err on the side of caution.
funcs_by_key = {k: rs |
  k = function_key(functions[_])
  rs = [r | r = functions[_]; function_key(r) = k]
}
perm_by_key = {k: rs |
  k = permission_key(permissions[_])
  rs = [r | r = permissions[_]; permission_key(r) = k]
}

valid_permission(permission) {
    is_string(permission.principal)
    permission.principal != "*"
}

policy[j] {
  func = funcs_by_key[k][_]
  not perm_by_key[k]
  j = fugue.allow_resource(func)
} {
  permission = permissions[_]
  valid_permission(permission)
  k = permission_key(permission)
  f = funcs_by_key[k][_]
  j = fugue.allow_resource(f)
} {
  permission = permissions[_]
  not valid_permission(permission)
  k = permission_key(permission)
  f = funcs_by_key[k][_]
  j = fugue.deny_resource_with_message(f, message)
}

