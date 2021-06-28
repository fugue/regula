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
package rules.google_iam_service_account_no_user_keys

import data.fugue
import data.google.iam.policy_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_1.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "Service accounts should only have Google-managed service account keys. Google-managed service account keys are automatically managed and rotated by Google and cannot be downloaded. For user-managed service account keys, the user must take ownership of management activities including key storage, distribution, revocation, and rotation. And even with key owner precautions, user-managed keys can be easily leaked into source code or left on support blogs. Google-managed service account keys should therefore be used.",
  "id": "FG_R00383",
  "title": "Service accounts should only have Google-managed service account keys"
}

resource_type = "MULTIPLE"

service_account_key = fugue.resources("google_service_account_key")

service_account_has_keys(account) {
  key = service_account_key[_]
  account.id == key.service_account_id
}

policy[j] {
  sa = lib.user_managed_service_accounts[_]
  not service_account_has_keys(sa)
  j = fugue.allow_resource(sa)
}

policy[j] {
  sa = lib.user_managed_service_accounts[_]
  service_account_has_keys(sa)
  j = fugue.deny_resource(sa)
}

