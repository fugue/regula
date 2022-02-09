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
package rules.cfn_iam_admin_policy

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_1.22"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.16"
      ]
    },
    "severity": "High"
  },
  "description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
  "id": "FG_R00092",
  "title": "IAM policies should not have full \"*:*\" administrative privileges"
}

resource_type := "MULTIPLE"
input_type := "cfn"

policy_resources[resource_id] = ret {
  iam_policy := fugue.resources("AWS::IAM::Policy")[resource_id]
  ret := {"resource": iam_policy, "policies": [iam_policy.PolicyDocument]}
} {
  iam_role := fugue.resources("AWS::IAM::Role")[resource_id]
  ret := {
    "resource": iam_role,
    "policies": [doc | doc := iam_role.Policies[_].PolicyDocument]
  }
} {
  iam_user := fugue.resources("AWS::IAM::User")[resource_id]
  ret := {
    "resource": iam_user,
    "policies": [doc | doc := iam_user.Policies[_].PolicyDocument]
  }
} {
  iam_group := fugue.resources("AWS::IAM::Group")[resource_id]
  ret := {
    "resource": iam_group,
    "policies": [doc | doc := iam_group.Policies[_].PolicyDocument]
  }
}

wildcard_policy_resources[resource_id] = ret {
  ret := policy_resources[resource_id]
  is_wildcard_policy(ret.policies[_])
}

is_wildcard_policy(doc) {
  statement := as_array(doc.Statement)[_]
  statement.Effect == "Allow"

  resource := as_array(statement.Resource)[_]
  resource == "*"

  action := as_array(statement.Action)[_]
  action == "*"
}

policy[j] {
  pr := wildcard_policy_resources[resource_id]
  j := fugue.deny_resource(pr.resource)
} {
  pr := policy_resources[resource_id]
  not wildcard_policy_resources[resource_id]
  j := fugue.allow_resource(pr.resource)
}

as_array(x) = [x] {not is_array(x)} else = x {true}
