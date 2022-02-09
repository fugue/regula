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

package rules.arm_postgresql_log_retention

import data.fugue
import data.arm.postgresql_configuration_library as lib

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
  "description": "Enabling log_retention_days helps PostgreSQL Database to Sets number of days a log file is retained which in turn generates query and error logs. Query and error logs can be used to identify, troubleshoot, and repair configuration errors and sub-optimal performance.",
  "id": "FG_R00337",
  "title": "PostgreSQL Database configuration 'log_retention days' should be greater than 3"
}

input_type := "arm"

resource_type := "MULTIPLE"

is_valid(server) {
    days = lib.configuration_value(server, "log_retention_days")
    to_number(days) > 3
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
