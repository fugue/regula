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
package google.storage.bucket_policy_library

import data.fugue
import data.google.iam.policy_library as lib

bucket_iam_member_resources := {id: m |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_storage_bucket_iam_member"]
  m = fugue.resources("google_storage_bucket_iam_member")[id]
}

bucket_iam_binding_resources := {id: b |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_storage_bucket_iam_binding"]
  b = fugue.resources("google_storage_bucket_iam_binding")[id]
}

bucket_access_control := {id: a |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_storage_bucket_access_control"]
  a = fugue.resources("google_storage_bucket_access_control")[id]
}

bucket_iam_policies := fugue.resources("google_storage_bucket_iam_policy")
bucket_acls := fugue.resources("google_storage_bucket_acl")

extract_acl_entity(role_entity) = entity {
  parts = split(role_entity, ":")
  entity = parts[1]
}

matches_name_or_id(val, bucket) {
  val == bucket.name
} {
  val == bucket.id
} {
  val == concat("/", ["b", bucket.name])
}

members_for_bucket(bucket) = ret {
  ret := {m |
    policy = bucket_iam_policies[_]
    matches_name_or_id(policy.bucket, bucket)
    m = lib.policy_data_bindings(policy)[_].members[_]
  } | {m |
    member_resource = bucket_iam_member_resources[_]
    matches_name_or_id(member_resource.bucket, bucket)
    m = member_resource.member
  } | {m |
    binding = bucket_iam_binding_resources[_]
    matches_name_or_id(binding.bucket, bucket)
    m = binding.members[_]
  } | {m |
    acl = bucket_acls[_]
    matches_name_or_id(acl.bucket, bucket)
    role_entity = acl.role_entity[_]
    m = extract_acl_entity(role_entity)
  } | {m |
    access_control = bucket_access_control[_]
    matches_name_or_id(access_control.bucket, bucket)
    m = access_control.entity
  }
}
