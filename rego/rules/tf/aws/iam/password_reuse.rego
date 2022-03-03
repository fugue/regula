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
package rules.tf_aws_iam_password_reuse

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_1.10"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.9"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_1.9"
      ]
    },
    "severity": "Medium"
  },
  "description": "IAM password policies should prevent reuse of previously used passwords. IAM password policies can prevent the reuse of a given password by the same user. Preventing password reuse increases account resiliency against brute force login attempts.",
  "id": "FG_R00002",
  "title": "IAM password policies should prevent reuse of previously used passwords"
}

password_policy_type = "aws_iam_account_password_policy"

password_policies = fugue.resources(password_policy_type)
exists_password_policy {
  _ = password_policies[_]
}

# Placeholder for missing a password policy from the input.
resource_type := "MULTIPLE"

policy[j] {
  fugue.input_type == "tf_runtime"
  not exists_password_policy
  j = fugue.missing_resource_with_message(password_policy_type, "No IAM password policy was found.")
} {
  pol = password_policies[_]
  pol.password_reuse_prevention >= 24
  j = fugue.allow_resource(pol)
} {
  pol = password_policies[_]
  pol.password_reuse_prevention < 24
  j = fugue.deny_resource(pol)
} {
  pol = password_policies[_]
  not pol.password_reuse_prevention
  j = fugue.deny_resource(pol)
}
