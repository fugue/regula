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

package rules.arm_sql_auditing_retention

import data.fugue

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

input_type := "arm"

resource_type := "MULTIPLE"

servers = fugue.resources("Microsoft.Sql/servers")
auditing_settings = fugue.resources("Microsoft.Sql/servers/auditingSettings")

valid_server_ids[id] {
	settings := auditing_settings[_]
	settings.properties.retentionDays >= 90
	id := settings._parent_id
}

policy[p] {
	server := servers[_]
	not valid_server_ids[server.id]
	p := fugue.deny_resource(server)
}

policy[p] {
	server := servers[_]
	valid_server_ids[server.id]
	p := fugue.allow_resource(server)
}
