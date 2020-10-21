# Copyright 2020 Fugue, Inc.
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
package rules.iam_admin_policy

import data.fugue

__rego__metadoc__ := {
  "id": "FG_R00092",
  "title": "IAM policies should not have full \"*:*\" administrative privileges",
  "description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_1-22"
      ]
    },
    "severity": "High"
  }
}

resource_type = "MULTIPLE"

# All policy objects that have a name and a `policy` field containing a JSON
# string.
policies[name] = p {
  iam_policies = fugue.resources("aws_iam_policy")
  p = iam_policies[name]
} {
  group_policies = fugue.resources("aws_iam_group_policy")
  p = group_policies[name]
} {
  role_policies = fugue.resources("aws_iam_role_policy")
  p = role_policies[name]
} {
  user_policies = fugue.resources("aws_iam_user_policy")
  p = user_policies[name]
}

# All wildcard policies.
wildcard_policies[name] = p {
  p = policies[name]
  is_wildcard_policy(p)
}

# Determine if a policy is a "wildcard policy".  A wildcard policy is defined as
# a policy having a statement that has all of:
#
# - Effect: Allow
# - Resource: "*"
# - Action: "*"
is_wildcard_policy(p) {
  json.unmarshal(p.policy, doc)
  statements = as_array(doc.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  resources = as_array(statement.Resource)
  resource = resources[_]
  resource == "*"

  actions = as_array(statement.Action)
  action = actions[_]
  action == "*"
}

# Judge policies and wildcard policies.
policy[p] {
  single_policy = wildcard_policies[name]
  p = fugue.deny_resource(single_policy)
} {
  single_policy = policies[name]
  not wildcard_policies[name]
  p = fugue.allow_resource(single_policy)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}
