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
package rules.tf_aws_iam_password_length

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_1.9"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.8"
      ]
    },
    "severity": "Medium"
  },
  "description": "IAM password policies should require a minimum length of 14. It is recommended that an enterprise's password policy require a password length of at least 14 characters. Setting a password complexity policy increases account resiliency against brute force login attempts.",
  "id": "FG_R00025",
  "title": "IAM password policies should require a minimum length of 14"
}

password_policy_type = "aws_iam_account_password_policy"

password_policies = fugue.resources(password_policy_type)
exists_password_policy {
  _ = password_policies[_]
}

# Placeholder for missing a password policy from the input.
resource_type = "MULTIPLE"

policy[j] {
  fugue.input_type == "tf_runtime"
  not exists_password_policy
  j = fugue.missing_resource_with_message(password_policy_type, "No IAM password policy was found.")
} {
  pol = password_policies[_]
  pol.minimum_password_length >= 14
  j = fugue.allow_resource(pol)
} {
  pol = password_policies[_]
  pol.minimum_password_length < 14
  j = fugue.deny_resource(pol)
}

