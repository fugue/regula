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
package rules.iam_account_password_policy_password_reuse_prevention

__rego__metadoc__ := {
  "id": "FG_R00020",
  "title": "Ensure IAM password policy prevents password reuse",
  "description": "This control checks whether the number of passwords to remember is set to 24. The control fails if the value is not 24.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_1-10"
      ]
    },
    "severity": "Low"
  }
}

resource_type = "aws_iam_account_password_policy"

default allow = false

allow {
   input.password_reuse_prevention >= 24
}