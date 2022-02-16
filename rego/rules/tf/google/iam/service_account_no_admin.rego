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
package rules.tf_google_iam_service_account_no_admin

import data.fugue
import data.google.iam.policy_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_1.5"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_1.5"
      ]
    },
    "severity": "High"
  },
  "description": "User-managed service accounts should not have admin privileges. A service account is a special Google account that belongs to an application or a VM instead of to an individual end-user. Service accounts should not have admin privileges as they give full access to an assigned application or a VM, and a service account can perform critical actions like delete, update, etc. without user intervention.",
  "id": "FG_R00384",
  "title": "User-managed service accounts should not have admin privileges"
}

resource_type := "MULTIPLE"

admin_suffix = {"admin", "roles/editor", "roles/owner"}

is_admin_role(role) {
  endswith(lower(role), admin_suffix[_])
}

members_with_admin_role := {m |
  roles = lib.project_roles_by_member[m]
  is_admin_role(roles[_])
}

service_account_has_admin(service_account) {
  members_with_admin_role[service_account.id]
} {
  is_string(service_account.email)
  member_name := concat(":", ["serviceAccount", service_account.email])
  members_with_admin_role[member_name]
}

policy[j] {
  sa = lib.user_managed_service_accounts[_]
  not service_account_has_admin(sa)
  j = fugue.allow_resource(sa)
}

policy[j] {
  sa = lib.user_managed_service_accounts[_]
  service_account_has_admin(sa)
  j = fugue.deny_resource(sa)
}
