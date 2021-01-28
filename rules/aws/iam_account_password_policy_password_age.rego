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
package rules.iam_account_password_policy_password_age

__rego__metadoc__ := {
  "id": "FG_R00021",
  "title": "EEnsure IAM password policy expires passwords within 90 days or less",
  "description": "CIS recommends that the password policy expire passwords after 90 days or less.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_1-11"
      ]
    },
    "severity": "Medium"
  }
}

resource_type = "aws_iam_account_password_policy"

default allow = false

allow {
   input.max_password_age > 0
   input.max_password_age <= 90
}