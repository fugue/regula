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
package google.compute.compute_instance_library

import data.fugue

truthy_values = {"true", "1"}
falsey_values = {"false", "0"}

coerce_metadata_value(value) = ret {
  is_string(value)
  truthy_values[lower(value)]
  ret = true
} else = ret {
  is_string(value)
  falsey_values[lower(value)]
  ret = false
} else = ret {
  ret = value
}

compute_metadata_items := {id: m |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["google_compute_project_metadata_item"]
  m = fugue.resources("google_compute_project_metadata_item")[id]
}

get_metadata_with_default(compute_instance, key_name, default_value) = ret {
  compute_instance.metadata[key_name]
  value = compute_instance.metadata[key_name]
  ret = coerce_metadata_value(value)
} else = ret {
  metadata_resources = fugue.resources("google_compute_project_metadata")
  metadata = metadata_resources[_]
  metadata.metadata[key_name]
  value = metadata.metadata[key_name]
  ret = coerce_metadata_value(value)
} else = ret {
  metadata_item = compute_metadata_items[_]
  metadata_item.key == key_name
  ret = coerce_metadata_value(metadata_item.value)
} else = ret {
  ret = default_value
}

is_default_service_account(account) {
  endswith(account.email, "-compute@developer.gserviceaccount.com")
} {
  not account.email
}

