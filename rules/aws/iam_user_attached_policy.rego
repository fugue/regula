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
package rules.iam_user_attached_policy

import data.fugue

__rego__metadoc__ := {
  "id": "FG_R00007",
  "title": "IAM policies should not be attached directly to users",
  "description": "IAM policies should not be attached to users. Assigning privileges at the group or role level reduces the complexity of access management as the number of users grow. Reducing access management complexity may reduce opportunity for a principal to inadvertently receive or retain excessive privileges.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_1-16"
      ],
      "NIST": [
        "NIST-800-53_AC-2 (7)(b)"
      ]
    },
    "severity": "Low"
  }
}

resource_type = "MULTIPLE"

user_policies = fugue.resources("aws_iam_user_policy")
user_policy_attachments = fugue.resources("aws_iam_user_policy_attachment")
policy_attachments = fugue.resources("aws_iam_policy_attachment")

all_policy_resources[name] = p {
  p = user_policies[name]
} {
  p = user_policy_attachments[name]
} {
  p = policy_attachments[name]
}

is_invalid(resource) {
  resource = user_policies[name]
} {
  resource = user_policy_attachments[name]
} {
  resource = policy_attachments[name]
  resource.users != null
  resource.users != [""]
}

policy[p] {
  resource = all_policy_resources[name]
  is_invalid(resource)
  p = fugue.deny_resource(resource)
} {
  resource = all_policy_resources[name]
  not is_invalid(resource)
  p = fugue.allow_resource(resource)
}
