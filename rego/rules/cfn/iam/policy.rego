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
package rules.cfn_iam_policy

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_1.16"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.15"
      ]
    },
    "severity": "Low"
  },
  "description": "IAM policies should not be attached to users. Assigning privileges at the group or role level reduces the complexity of access management as the number of users grow. Reducing access management complexity may reduce opportunity for a principal to inadvertently receive or retain excessive privileges.",
  "id": "FG_R00007",
  "title": "IAM policies should not be attached to users"
}

input_type := "cfn"
resource_type := "MULTIPLE"

iam_policies := fugue.resources("AWS::IAM::Policy")
iam_users := fugue.resources("AWS::IAM::User")

iam_policy_has_users(iam_policy) {
  _ = iam_policy.Users[_]
}

iam_user_has_policies(iam_user) {
  _ = iam_user.Policies[_]
}

policy[p] {
  iam_policy := iam_policies[_]
  iam_policy_has_users(iam_policy)
  p := fugue.deny_resource(iam_policy)
} {
  iam_policy := iam_policies[_]
  not iam_policy_has_users(iam_policy)
  p := fugue.allow_resource(iam_policy)
} {
  iam_user := iam_users[_]
  iam_user_has_policies(iam_user)
  p := fugue.deny_resource(iam_user)
} {
  iam_user := iam_users[_]
  not iam_user_has_policies(iam_user)
  p := fugue.allow_resource(iam_user)
}
