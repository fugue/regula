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
package fugue.utils

import data.fugue

# Remove a key from an object.
remove(key, old_obj) = new_obj {
  new_obj := {k: v |
    v := old_obj[k]
    k != key
  }
}

# Get the provider for a resource, or an empty string if no provider
# info is found.
provider(resource) = p {
  p = resource._provider
} else = "" {
  true
}

# Obtain multiple resource types as specified by a list.
many_resources(resource_types) = {resource_id: resource |
  resource_type := resource_types[_]
  resources := fugue.resources(resource_type)
  resource := resources[resource_id]
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}

