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
package rules.tf_azurerm_postgresql_configuration_connection_throttling

import data.azurerm.postgresql.configuration
import data.fugue


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
  "description": "PostgreSQL Database configuration 'connection_throttling' should be on. Enabling connection_throttling helps the PostgreSQL Database to Set the verbosity of logged messages which in turn generates query and error logs with respect to concurrent connections, that could lead to a successful Denial of Service (DoS) attack by exhausting connection resources.",
  "id": "FG_R00335",
  "title": "PostgreSQL Database configuration 'connection_throttling' should be on"
}

postgresql_servers = fugue.resources("azurerm_postgresql_server")

valid_configuration(server) {
  lower(configuration.configuration_value(server, "connection_throttling")) == "on"
} {
  # Default is on.
  not configuration.configuration_value(server, "connection_throttling")
}

resource_type = "MULTIPLE"

policy[p] {
  server = postgresql_servers[_]
  valid_configuration(server)
  p = fugue.allow_resource(server)
} {
  server = postgresql_servers[_]
  not valid_configuration(server)
  p = fugue.deny_resource(server)
}

