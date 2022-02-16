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
package rules.tf_google_iam_no_service_account_roles

import data.fugue
import data.google.iam.policy_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_1.6"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_1.6"
      ]
    },
    "severity": "High"
  },
  "description": "IAM users should not have project-level 'Service Account User' or 'Service Account Token Creator' roles. Assigning IAM users with project-level 'Service Account User' or 'Service Account Token Creator' roles means that they can potentially access resources across an entire project. To follow least privileges best practice, IAM users should be assigned to a specific service account with more scoped access.",
  "id": "FG_R00385",
  "title": "IAM users should not have project-level 'Service Account User' or 'Service Account Token Creator' roles"
}

resource_type := "MULTIPLE"

invalid_roles = {"roles/iam.serviceAccountUser", "roles/iam.serviceAccountTokenCreator"}

invalid_members := {m |
  roles = lib.project_roles_by_member[m]
  count(roles & invalid_roles) > 0
}

invalid_resources := ret {
  ret := {id |
    p = lib.project_iam_policies[id]
    binding = lib.policy_data_bindings(p)[_]
    invalid_roles[binding.role]
    m = binding.members[_]
    invalid_members[m]
  } | {id |
    binding = lib.project_iam_binding_resources[id]
    invalid_roles[binding.role]
    m = binding.members[_]
    invalid_members[m]
  } | {id |
    member_resource = lib.project_iam_member_resources[id]
    invalid_roles[member_resource.role]
    invalid_members[member_resource.member]
  }
}

policy[j] {
  r = lib.project_iam_resources[id]
  invalid_resources[id]
  j = fugue.deny_resource(r)
}

policy[j] {
  r = lib.project_iam_resources[id]
  not invalid_resources[id]
  j = fugue.allow_resource(r)
}
