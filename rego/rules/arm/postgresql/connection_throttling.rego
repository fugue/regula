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

package rules.arm_postgresql_connection_throttling

import data.fugue
import data.arm.postgresql_configuration_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_4.17"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_4.3.6"
      ]
    },
    "severity": "Medium"
  },
  "description": "Enabling connection_throttling helps the PostgreSQL Database to Set the verbosity of logged messages which in turn generates query and error logs with respect to concurrent connections, that could lead to a successful Denial of Service (DoS) attack by exhausting connection resources.",
  "id": "FG_R00335",
  "title": "PostgreSQL Database configuration 'connection_throttling' should be on"
}

input_type := "arm"

resource_type := "MULTIPLE"

is_valid(server) {
    lower(lib.configuration_value(server, "connection_throttling")) == "on"
}

policy[p] {
	server = lib.servers[_]
	is_valid(server)
	p = fugue.allow_resource(server)
}

policy[p] {
	server = lib.servers[_]
	not is_valid(server)
	p = fugue.deny_resource(server)
}
