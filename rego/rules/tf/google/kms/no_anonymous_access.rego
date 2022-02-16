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
package rules.tf_google_kms_no_anonymous_access

import data.fugue
import data.google.iam.policy_library as lib_policy
import data.google.kms.kms_policy_library as lib_kms_policy

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_1.9"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_1.9"
      ]
    },
    "severity": "Critical"
  },
  "description": "KMS keys should not be anonymously or publicly accessible. IAM policy on Cloud KMS cryptokeys should restrict anonymous and/or public access. Granting permissions to `allUsers` or `allAuthenticatedUsers` allows anyone to access the dataset, which is not desirable if sensitive data is stored at the location.",
  "id": "FG_R00386",
  "title": "KMS keys should not be anonymously or publicly accessible"
}

resource_type := "MULTIPLE"

kms_crypto_keys = fugue.resources("google_kms_crypto_key")

invalid_members = {"allUsers", "allAuthenticatedUsers"}

access_granted_in_project_iam := true {
  m = invalid_members[_]
  role = lib_policy.project_roles_by_member[m][_]
  startswith(role, "roles/cloudkms")
}

has_anonymous_access(key) {
  access_granted_in_project_iam == true
}

has_anonymous_access(key) {
  members = lib_kms_policy.kms_members_for_key_id(key.id)
  count(members & invalid_members) > 0
}

policy[j] {
  key = kms_crypto_keys[_]
  not has_anonymous_access(key)
  j = fugue.allow_resource(key)
}

policy[j] {
  key = kms_crypto_keys[_]
  has_anonymous_access(key)
  j = fugue.deny_resource(key)
}
