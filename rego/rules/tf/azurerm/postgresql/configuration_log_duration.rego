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
package rules.tf_azurerm_postgresql_configuration_log_duration

import data.azurerm.postgresql.configuration
import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_4.16"
      ]
    },
    "severity": "Medium"
  },
  "description": "PostgreSQL Database configuration 'log_duration' should be on. Enabling log_duration helps the PostgreSQL Database to Logs the duration of each completed SQL statement which in turn generates query and error logs. Query and error logs can be used to identify, troubleshoot, and repair configuration errors and sub-optimal performance.",
  "id": "FG_R00333",
  "title": "PostgreSQL Database configuration 'log_duration' should be on"
}

postgresql_servers = fugue.resources("azurerm_postgresql_server")

valid_configuration(server) {
  lower(configuration.configuration_value(server, "log_duration")) == "on"
} {
  # Default is on.
  not configuration.configuration_value(server, "log_duration")
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

