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
package rules.tf_azurerm_sql_auditing_retention_90days

import data.fugue
import data.fugue.utils


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_4.3"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_4.1.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "Audit Logs can be used to check for anomalies and give insight into suspected breaches or misuse of information and access.",
  "id": "FG_R00283",
  "title": "SQL Server auditing retention should be 90 days or greater"
}

servers = fugue.resources("azurerm_sql_server")
databases = fugue.resources("azurerm_sql_database")

server_by_name_or_id(server_name) = ret {
  matching_servers = [server | server = servers[_]; lower(server.name) == lower(server_name)]
  count(matching_servers) > 0
  # SQL server names are globally unique in azure
  ret = matching_servers[0]
} else = ret {
  matching_servers = [server | server = servers[_]; server.id == server_name]
  count(matching_servers) > 0
  ret = matching_servers[0]
}

# Sometimes `retention_in_days` is stored as a string rather than a number.
valid_auditing(resource) {
  retention = resource.extended_auditing_policy[_].retention_in_days
  is_string(retention)
  to_number(retention) >= 90
} {
  retention = resource.extended_auditing_policy[_].retention_in_days
  is_number(retention)
  retention >= 90
}

valid_server(server) {
  valid_auditing(server)
}

valid_database(database) {
  valid_auditing(database)
} {
  server_name = database.server_name
  valid_server(server_by_name_or_id(server_name))
}

resource_type = "MULTIPLE"

policy[p] {
  server = servers[_]
  valid_server(server)
  p = fugue.allow_resource(server)
} {
  server = servers[_]
  not valid_server(server)
  p = fugue.deny_resource(server)
} {
  database = databases[_]
  valid_database(database)
  p = fugue.allow_resource(database)
} {
  database = databases[_]
  not valid_database(database)
  p = fugue.deny_resource(database)
}

