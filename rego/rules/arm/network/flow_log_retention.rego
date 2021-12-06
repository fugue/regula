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

network_security_groups = fugue.resources("Microsoft.Network/networkSecurityGroups")

flow_logs = fugue.resources("Microsoft.Network/networkWatchers/flowLogs")

nsg_id_to_flow_logs := {nsg_id: nsg_flow_logs |
	_ := network_security_groups[nsg_id]
	nsg_flow_logs := [flow_log |
		flow_log := flow_logs[_]
		nsg_id == flow_log.properties.targetResourceId
	]
}

flow_log_has_retention(flow_log) {
	flow_log.properties.retentionPolicy.enabled == true
	flow_log.properties.retentionPolicy.days >= 90
}

bad_nsg(nsg) = msg {
	count(nsg_id_to_flow_logs[nsg.id]) < 1
	msg := "No associated flow logs found"
} else = msg {
	flow_log := nsg_id_to_flow_logs[nsg.id][_]
	not flow_log_has_retention(flow_log)
	msg := "Retention policy needs to be set to 90 days or more"
}

policy[p] {
	nsg := network_security_groups[_]
	msg := bad_nsg(nsg)
	p := fugue.deny({"resource": nsg, "message": msg})
}

policy[p] {
	nsg := network_security_groups[_]
	not bad_nsg(nsg)
	p := fugue.allow({"resource": nsg})
}
