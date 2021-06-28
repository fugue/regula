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
package rules.tf_aws_iam_password_reuse_4

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_4.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "IAM password policies should prevent reuse of the four previously used passwords. IAM password policies should prevent users from reusing any of their previous 4 passwords. Preventing password reuse increases account resiliency against brute force login attempts.",
  "id": "FG_R00088",
  "title": "IAM password policies should prevent reuse of the four previously used passwords"
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
  pol.password_reuse_prevention >= 4
  j = fugue.allow_resource(pol)
} {
  pol = password_policies[_]
  pol.password_reuse_prevention < 4
  j = fugue.deny_resource(pol)
} {
  pol = password_policies[_]
  not pol.password_reuse_prevention
  j = fugue.deny_resource(pol)
}

