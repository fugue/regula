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

# Utilities for retrieving tags
package fugue.resource_view.tags

# Get tags object from a resource, ensuring they are not null and contain
# strings
get_from_object(resource, field) = ret {
  tags := object.get(resource, field, {})
  is_object(tags)
  ret := {k: v |
    v := tags[k]
    is_string(k)
    is_tag_value(v)
  }
} else = ret {
  ret := {}
}

# Get tags list from a resource.
get_from_list(resource, field, key_field, value_field) = ret {
  tags := object.get(resource, field, [])
  is_array(tags)
  keys := {k | k := tags[_][key_field]; is_string(k)}
  ret := {k: v |
    keys[k]
    vs := [tag[value_field] |
      tag := tags[_]
      tag[key_field] == k
      is_tag_value(tag[value_field])
    ]
    v := concat(";", vs)
  }
} else = ret {
  ret := {}
}

# Get tags (without values) from a resource.  Values are set to null.
get_from_key_list(resource, field) = ret {
  tags := object.get(resource, field, [])
  ret := {k: null |
    k := tags[_]
    is_string(k)
  }
} else = ret {
  ret := {}
}

# Check that a tag value is valid (string or null)
is_tag_value(x) {
  is_string(x)
} {
  is_null(x)
}
