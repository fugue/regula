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
package rules.tf_aws_iam_user_group_attachment

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Low"
  },
  "description": "IAM users should be members of at least one group. It is an IAM best practice for permissions to be managed at the group level, and therefore, for policies to be attached to groups - not users. Ensuring that a user belongs to at least one group helps prevent the user's permissions from being managed separately.",
  "id": "FG_R00272",
  "title": "IAM users should be members of at least one group"
}

users = fugue.resources("aws_iam_user")
groups = fugue.resources("aws_iam_group_membership")

# Validate whether the user is attached to at least one group

group_attached(user) {
  groups[_].users[_] == user.name
}

resource_type = "MULTIPLE"

policy[j] {
  user = users[_]
  group_attached(user)
  j = fugue.allow_resource(user)
} {
  user = users[_]
  not group_attached(user)
  j = fugue.deny_resource(user)
}

