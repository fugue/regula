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

package rules.arm_sql_no_inbound_all

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00221",
	"title": "SQL Server firewall rules should not permit start and end IP addresses to be 0.0.0.0",
	"description": "Adding a rule with range 0.0.0.0 to 0.0.0.0 is the same as enabling the \"Allow access to Azure services\" setting, which allows all connections from Azure, including from other subscriptions. Disabling this setting helps prevent malicious Azure users from connecting to your database and accessing sensitive data.",
	"custom": {
		"controls": {},
		"severity": "High"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

resources = fugue.resources("Microsoft.Sql/servers/firewallRules")

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
