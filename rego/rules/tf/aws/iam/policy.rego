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
package rules.tf_aws_iam_policy

import data.fugue
import data.aws.iam.policy_document_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_1.16"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.15"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_1.15"
      ]
    },
    "severity": "Low"
  },
  "description": "IAM policies should not be attached to users. Assigning privileges at the group or role level reduces the complexity of access management as the number of users grow. Reducing access management complexity may reduce opportunity for a principal to inadvertently receive or retain excessive privileges.",
  "id": "FG_R00007",
  "title": "IAM policies should not be attached to users"
}

iam_policies = fugue.resources("aws_iam_policy")
iam_users = fugue.resources("aws_iam_user")
iam_user_policies = fugue.resources("aws_iam_user_policy")
iam_user_policy_attachments = fugue.resources("aws_iam_user_policy_attachment")

user_has_policy(user) {
  iam_user_policy_attachments[_].user == user.name
} {
  iam_user_policies[_].user == user.name
}

policy_has_users(pol) {
  iam_user_policy_attachments[_].policy_arn == lib.arn_or_id(pol)
}

# In this rule, we mark only relevant resources: users and policies but not
# attachments.
bad_resources[resource_id] = resource {
  # User policies are always bad, since it means an attached policy is there.
  iam_user_policies[resource_id] = resource
} {
  # Users are bad if they have a policy attached.
  iam_users[resource_id] = resource
  user_has_policy(resource)
} {
  # Policies are bad if they are attached to a user.
  iam_policies[resource_id] = resource
  policy_has_users(resource)
} {
  # Attachments are only marked as relevant for IaC.
  fugue.input_type != "tf_runtime"
  iam_user_policy_attachments[resource_id] = resource
}

# Dual of `bad_resource`.
all_resources[resource_id] = resource {
  iam_user_policies[resource_id] = resource
} {
  iam_users[resource_id] = resource
} {
  iam_policies[resource_id] = resource
} {
  # Attachments are only marked as relevant for IaC.
  fugue.input_type != "tf_runtime"
  iam_user_policy_attachments[resource_id] = resource
}

resource_type := "MULTIPLE"

policy[j] {
  resource = bad_resources[_]
  j = fugue.deny_resource(resource)
} {
  resource = all_resources[resource_id]
  not bad_resources[resource_id]
  j = fugue.allow_resource(resource)
}
