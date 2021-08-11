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
package rules.tf_google_iam_kms_role_limits

import data.fugue
import data.google.iam.policy_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_1.11"
      ]
    },
    "severity": "Medium"
  },
  "description": "IAM users should not have both KMS admin and any of the KMS encrypter/decrypter roles. No user should have both KMS admin and encrypter/decrypter roles because they could create a key then immediately use it to encrypt/decrypt data. Separation of duties ensures that no one individual has all necessary permissions to complete a malicious action.",
  "id": "FG_R00388",
  "title": "IAM users should not have both KMS admin and any of the KMS encrypter/decrypter roles"
}

resource_type = "MULTIPLE"

kms_admin_role := "roles/cloudkms.admin"
kms_crypto_key_roles := {
  "roles/cloudkms.cryptoKeyEncrypterDecrypter",
  "roles/cloudkms.cryptoKeyEncrypter",
  "roles/cloudkms.cryptoKeyDecrypter",
}
# Using funky syntax for now, pending Fregot issue fix
target_roles := ret {
  ret := { kms_admin_role } | kms_crypto_key_roles
}

invalid_members := {m |
  roles = lib.project_roles_by_member[m]
  roles[kms_admin_role]
  count(roles & kms_crypto_key_roles) > 0
}

invalid_resources :=  ret {
  ret := {id |
    p = lib.project_iam_policies[id]
    binding = lib.policy_data_bindings(p)[_]
    target_roles[binding.role]
    m = binding.members[_]
    invalid_members[m]
  } | { id |
    binding = lib.project_iam_binding_resources[id]
    target_roles[binding.role]
    m = binding.members[_]
    invalid_members[m]
  } | { id |
    member_resource = lib.project_iam_member_resources[id]
    target_roles[member_resource.role]
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

