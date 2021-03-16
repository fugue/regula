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
package rules.cfn_lambda_function_not_public

import data.fugue
import data.fugue.cfn.lambda_library as lib

__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "Lambda function policies should not allow global access. Publicly accessible lambda functions may be runnable by anyone and could drive up your costs, disrupt your services, or leak your data.",
  "id": "FG_R00276",
  "title": "Lambda function policies should not allow global access"
}

input_type = "cloudformation"
resource_type = "MULTIPLE"

permissions = fugue.resources("AWS::Lambda::Permission")
functions[id] = function {
  function = fugue.resources("AWS::Lambda::Function")[id]
} {
  function = fugue.resources("AWS::Serverless::Function")[id]
}

bad_permissions_by_function_id = {fid: ps |
  f := functions[fid]
  ps = [p |
    p = permissions[pid]
    p.Principal == "*"
    lib.function_name_matches_function(f, p.FunctionName)
  ]
  count(ps) > 0
}

policy[j] {
  function := functions[function_id]
  not bad_permissions_by_function_id[function_id]
  j := fugue.allow_resource(function)
} {
  function := functions[function_id]
  count(bad_permissions_by_function_id[function_id]) == 0
  j := fugue.allow_resource(function)
} {
  function := functions[function_id]
  count(bad_permissions_by_function_id[function_id]) > 0
  j := fugue.deny_resource(function)
}
