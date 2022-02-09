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
package google.iam.policy_library

import data.fugue

policy_data_resources := {id: p |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["data.google_iam_policy"]
  p = fugue.resources("data.google_iam_policy")[id]
}

project_iam_member_resources := {id: m |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_project_iam_member"]
  m = fugue.resources("google_project_iam_member")[id]
}

project_iam_binding_resources := {id: b |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_project_iam_binding"]
  b = fugue.resources("google_project_iam_binding")[id]
}

project_iam_resources[id] = r {
  r = project_iam_policies[id]
} {
  r = project_iam_member_resources[id]
} {
  r = project_iam_binding_resources[id]
}

project_iam_policies := fugue.resources("google_project_iam_policy")

project_members := ret {
  ret := {m |
    policy = project_iam_policies[_]
    m = policy_data_bindings(policy)[_].members[_]
  } | { m |
    m = project_iam_member_resources[_].member
  } | { m |
    m = project_iam_binding_resources[_].members[_]
  }
}

extract_member_roles_from_policy(member, policy) = ret {
  ret := { role |
    binding = policy_data_bindings(policy)[_]
    role = extract_member_roles_from_binding(member, binding)[_]
  }
}

extract_member_roles_from_member_resource(member, member_resource) = ret {
  ret := { role |
    m = member_resource.member
    m == member
    role = member_resource.role
  }
}

extract_member_roles_from_binding(member, binding) = ret {
  ret := { role |
    m = binding.members[_]
    m == member
    role = binding.role
  }
}

project_roles_for_member(member) = ret {
  ret := { role |
    policy = project_iam_policies[_]
    role = extract_member_roles_from_policy(member, policy)[_]
  } | { role |
    member_resource = project_iam_member_resources[_]
    role = extract_member_roles_from_member_resource(member, member_resource)[_]
  } | { role |
    binding = project_iam_binding_resources[_]
    role = extract_member_roles_from_binding(member, binding)[_]
  }
}

project_roles_by_member := {m: roles |
  m = project_members[_]
  roles = project_roles_for_member(m)
}

get_policy_data(iam_policy) = ret {
  is_string(iam_policy.policy_data)
  startswith(trim_space(iam_policy.policy_data), "{")
  endswith(trim_space(iam_policy.policy_data), "}")
  ret := json.unmarshal(iam_policy.policy_data)
} else = ret {
  ret := policy_data_resources[iam_policy.policy_data]
}

policy_data_bindings(iam_policy) = ret {
  str := iam_policy.policy_data
  json.is_valid(str)
  doc := json.unmarshal(str)
  ret := doc.bindings
} {
  startswith(iam_policy.policy_data, "data.")
  doc := policy_data_resources[iam_policy.policy_data]
  ret := doc.binding
}

is_user_managed_service_account(account) {
  endswith(account.email, ".iam.gserviceaccount.com")
} {
  not account.email
}

user_managed_service_accounts[id] = service_account {
  service_accounts = fugue.resources("google_service_account")
  service_account = service_accounts[id]
  is_user_managed_service_account(service_account)
}

parse_member(member) = ret {
  parts := split(member, ":")
  ret := {"type": parts[0], "name": parts[1]}
} else = ret {
  ret := {"type": member, "name": null}
}

member_is_user_managed_service_account(member) = true {
  parsed = parse_member(member)
  parsed.type == "serviceAccount"
  name := parsed.name
  is_string(name)
  endswith(name, "")
}
