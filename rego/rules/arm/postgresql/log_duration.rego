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

package rules.arm_postgresql_log_duration

import data.fugue
import data.fugue.arm.postgresql_configuration_library as lib

__rego__metadoc__ := {
	"id": "FG_R00333",
	"title": "PostgreSQL Database configuration 'log_duration' should be on",
	"description": "Enabling log_duration helps the PostgreSQL Database to Logs the duration of each completed SQL statement which in turn generates query and error logs. Query and error logs can be used to identify, troubleshoot, and repair configuration errors and sub-optimal performance.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_4.16"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

is_valid(server) {
    lower(lib.configuration_value(server, "log_duration")) == "on"
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
