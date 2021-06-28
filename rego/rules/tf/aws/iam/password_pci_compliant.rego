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
package rules.aws_iam_password_pci_compliant

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "IAM password policies should have a minimum length of 7 and include both alphabetic and numeric characters. IAM password policies are used to enforce password complexity requirements and increase account resiliency against brute force login attempts. Password policies should require passwords to be at least 7 characters long and include both alphabetic and numeric characters.",
  "id": "FG_R00086",
  "title": "IAM password policies should have a minimum length of 7 and include both alphabetic and numeric characters"
}

password_policy_type = "aws_iam_account_password_policy"

password_policies = fugue.resources(password_policy_type)
exists_password_policy {
  _ = password_policies[_]
}

# Core logic: check if the password policy is PCI compliant.
pci_compliant(pol) {
    pol.require_numbers
    pol.require_lowercase_characters
    pol.minimum_password_length >= 7
}

# Placeholder for missing a password policy from the input.
resource_type = "MULTIPLE"

policy[j] {
  fugue.input_type == "tf_runtime"
  not exists_password_policy
  j = fugue.missing_resource_with_message(password_policy_type, "No IAM password policy was found.")
} {
  pol = password_policies[_]
  pci_compliant(pol)
  j = fugue.allow_resource(pol)
} {
  pol = password_policies[_]
  not pci_compliant(pol)
  j = fugue.deny_resource(pol)
}

