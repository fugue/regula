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

package rules.arm_postgresql_log_connections

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00318",
	"title": "PostgreSQL Database configuration 'log_connections' should be on",
	"description": "Enabling log_connections helps PostgreSQL Database to log attempted connection to the server, as well as successful completion of client authentication. Log data can be used to identify, troubleshoot, and repair configuration errors and suboptimal performance.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_4.14"
			],
			"CIS-Azure_v1.3.0": [
				"CIS-Azure_v1.3.0_4.3.4"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

resources = fugue.resources("Microsoft.DBforPostgreSQL/servers/configurations")

is_invalid(resource) {
	resource.TODO == "TODO" # FIXME
}

policy[p] {
	resource = resources[_]
	reason = is_invalid(resource)
	p = fugue.deny_resource(resource)
}

policy[p] {
	resource = resources[_]
	not is_invalid(resource)
	p = fugue.allow_resource(resource)
}