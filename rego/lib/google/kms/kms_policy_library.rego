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
package google.kms.kms_policy_library

import data.fugue
import data.google.iam.policy_library as lib

kms_iam_member_resources := {id: m |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_kms_crypto_key_iam_member"]
  m = fugue.resources("google_kms_crypto_key_iam_member")[id]
}

kms_iam_binding_resources := {id: b |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_kms_crypto_key_iam_binding"]
  b = fugue.resources("google_kms_crypto_key_iam_binding")[id]
}

kms_iam_policies := fugue.resources("google_kms_crypto_key_iam_policy")

kms_members_for_key_id(key_id) = ret {
  ret := {m |
    policy = kms_iam_policies[_]
    policy.crypto_key_id == key_id
    m = lib.policy_data_bindings(policy)[_].members[_]
  } | {m |
    member_resource = kms_iam_member_resources[_]
    member_resource.crypto_key_id == key_id
    m = member_resource.member
  } | {m |
    binding = kms_iam_binding_resources[_]
    binding.crypto_key_id == key_id
    m = binding.members[_]
  }
}

