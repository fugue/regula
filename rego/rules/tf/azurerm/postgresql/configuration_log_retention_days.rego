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
package rules.tf_azurerm_postgresql_configuration_log_retention_days

import data.azurerm.postgresql.configuration
import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_4.18"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_4.3.7"
      ]
    },
    "severity": "Medium"
  },
  "description": "PostgreSQL Database configuration 'log_retention days' should be greater than 3. Enabling log_retention_days helps PostgreSQL Database to Sets number of days a log file is retained which in turn generates query and error logs. Query and error logs can be used to identify, troubleshoot, and repair configuration errors and sub-optimal performance.",
  "id": "FG_R00337",
  "title": "PostgreSQL Database configuration 'log_retention days' should be greater than 3"
}

postgresql_servers = fugue.resources("azurerm_postgresql_server")

valid_configuration(server) {
  val = configuration.configuration_value(server, "log_retention_days")
  to_number(val) > 3
} {
  # Default is 7 which is valid.
  not configuration.configuration_value(server, "log_retention_days")
}

resource_type := "MULTIPLE"

policy[p] {
  server = postgresql_servers[_]
  valid_configuration(server)
  p = fugue.allow_resource(server)
} {
  server = postgresql_servers[_]
  not valid_configuration(server)
  p = fugue.deny_resource(server)
}
