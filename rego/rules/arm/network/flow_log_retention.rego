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

package rules.arm_network_flow_log_retention

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00286",
	"title": "Virtual Network security group flow log retention period should be set to 90 days or greater",
	"description": "Flow logs enable capturing information about IP traffic flowing in and out of network security groups. Logs can be used to check for anomalies and give insight into suspected breaches.",
	"custom": {
		"controls": {},
		"severity": "Medium",
	},
}

input_type = "arm"

resource_type = "MULTIPLE"

resources = fugue.resources("Microsoft.Network/networkWatchers/flowLogs")

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
