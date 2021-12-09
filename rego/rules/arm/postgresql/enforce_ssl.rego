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

package rules.arm_postgresql_enforce_ssl

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00226",
	"title": "PostgreSQL Database server 'enforce SSL connection' should be enabled",
	"description": "Enforcing SSL connections between your database server and your client applications helps protect against \"man in the middle\" attacks by encrypting the data stream between the server and your application.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_4.13"
			],
			"CIS-Azure_v1.3.0": [
				"CIS-Azure_v1.3.0_4.3.1"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "Microsoft.DBforPostgreSQL/servers"

default allow = false
allow {
	lower(input.properties.sslEnforcement) == "enabled"
}
