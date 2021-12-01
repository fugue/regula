# Copyright 2021 Fugue, Inc.
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
package fugue.resource_view.arm

# Returns a list of all parent resources of the resource at the given path,
# ending with the resource itself.
parent_resources(top_level_resource, path) = ret {
  indices := numbers.range(1, floor(count(path) / 2))
  ret := array.concat([top_level_resource], [resource |
    i := indices[_] * 2
    parent_path := array.slice(path, 0, i)
    resource := json.patch(top_level_resource,
      [{"op": "move", "path": [], "from": parent_path}]
    )
  ])
}

# Construct a full name from the type name and names, e.g.:
#
#     Microsoft.Network/virtualNetworks + VNet1 =
#     -> Microsoft.Network/virtualNetworks/VNet1
#
#     Microsoft.Network/virtualNetworks/subnets + VNet1/Subnet1 =
#     -> Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet1
make_typed_name(type, name) = ret {
  # Azure supports up to 5 levels of nesting which we need to write out
  # fully, unfortunately.
  [service, t0] = split(type, "/")
  [n0] = split(name, "/")
  ret = concat("/", [service, t0, n0])
} else = ret {
  [service, t0, t1] = split(type, "/")
  [n0, n1] = split(name, "/")
  ret = concat("/", [service, t0, n0, t1, n1])
} else = ret {
  [service, t0, t1, t2] = split(type, "/")
  [n0, n1, n2] = split(name, "/")
  ret = concat("/", [service, t0, n0, t1, n1, t2, n2])
} else = ret {
  [service, t0, t1, t2, t3] = split(type, "/")
  [n0, n1, n2, n3] = split(name, "/")
  ret = concat("/", [service, t0, n0, t1, n1, t2, n2, t3, n3])
} else = ret {
  [service, t0, t1, t2, t3, t4] = split(type, "/")
  [n0, n1, n2, n3, n4] = split(name, "/")
  ret = concat("/", [service, t0, n0, t1, n1, t2, n2, t3, n3, t4, n4])
} else = ret {
  [service, t0, t1, t2, t3, t4, t5] = split(type, "/")
  [n0, n1, n2, n3, n4, n5] = split(name, "/")
  ret = concat("/", [service, t0, n0, t1, n1, t2, n2, t3, n3, t4, n4, t5, n5])
}

# Retrieve the parent name of a typed name, or null.
# E.g.
#
#     Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet1
#     -> Microsoft.Network/virtualNetworks/VNet1
parent_typed_name(typed_name) = ret {
    parts := split(typed_name, "/")
    count(parts) > 3
    ret := concat("/", array.slice(parts, 0, count(parts) - 2))
} else = ret {
    ret := null
}

# Extract all children resources (including the parent itself) from a resource.
extract_resources(top_level_resource) = ret {
  ret := {id: resource |
    # Walk over a top level resource to retrieve all children.
    # The path will be of the shape ["resources", 0, "resources", 2].
    [path, value] = walk(top_level_resource)
    count(path) % 2 == 0
    all([ok | k = path[i]; i % 2 == 0; ok := (k == "resources")])

    parents := parent_resources(top_level_resource, path)
    name := concat("/", [r.name | r := parents[_]])
    type := concat("/", [r.type | r := parents[_]])
    typed_name := make_typed_name(type, name)

    id := typed_name
    resource := json.patch(value, [
      {"op": "add", "path": ["id"], "value": typed_name},
      {"op": "add", "path": ["_type"], "value": type},
      {"op": "add", "path": ["_provider"], "value": "arm"},
      {"op": "add", "path": ["_parent_id"], "value": parent_typed_name(typed_name)},
    ])
  }
}

resource_view := {id: resource |
  top_level_resource := input.resources[_]
  resource := extract_resources(top_level_resource)[id]
}
