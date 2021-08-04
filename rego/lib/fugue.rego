# Copyright 2020 Fugue, Inc.
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
package fugue

import data.fugue.input_type_internal

resource_types = {rt |
  r = input.resources[_]
  rt = r._type
}

resources_by_type = {rt: rs |
  resource_types[rt]
  rs = {ri: r |
    r = input.resources[ri]
    r._type == rt
  }
}

plan = ret {
  ret = input._plan
}

resources(rt) = ret {
  ret = resources_by_type[rt]
} else = {} {
  true
}

allow_resource(resource) = ret {
  ret := allow({"resource": resource})
}

allow(params) = ret {
  ret := {
    "valid": true,
    "id": params.resource.id,
    "type": params.resource._type,
    "message": object.get(params, "message", ""),
    "provider": params.resource._provider,
    "filepath": object.get(params.resource, "_filepath", ""),
  }
}

deny_resource(resource) = ret {
  ret := deny({"resource": resource})
}

deny_resource_with_message(resource, message) = ret {
  ret := deny({"resource": resource, "message": message})
}

deny(params) = ret {
  ret := {
    "valid": false,
    "id": params.resource.id,
    "type": params.resource._type,
    "message": object.get(params, "message", ""),
    "attribute": object.get(params, "attribute", null),
    "provider": params.resource._provider,
    "filepath": object.get(params.resource, "_filepath", ""),
  }
}

missing_resource(resource_type) = ret {
  ret := missing({"resource_type": resource_type})
}

missing_resource_with_message(resource_type, message) = ret {
  ret := missing({"resource_type": resource_type, "message": message})
}

missing(params) = ret {
  ret := {
    "valid": false,
    "id": "",
    "type": params.resource_type,
    "message": object.get(params, "message", "invalid"),
    "provider": object.get(params, "provider", ""),
    "attribute": null,
    "filepath": "",
  }
}

# Provided for backward-compatibility with older Fugue rules only.
report_v0(message, policy) = ret {
  ok := all([p.valid | policy[p]])
  msg := {true: "", false: message}
  ret := {"valid": ok, "message": msg[ok], "resources": policy}
}

# Provided for backward-compatibility with older Fugue rules only.
resource_types_v0 = resource_types

input_type = ret {
  ret := input_type_internal.input_type
}
