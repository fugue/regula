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
package rules.azurerm_network_flow_log_90days

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_6.4"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_6.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "Virtual Network security group flow log retention period should be set to 90 days or greater. Flow logs enable capturing information about IP traffic flowing in and out of network security groups. Logs can be used to check for anomalies and give insight into suspected breaches.",
  "id": "FG_R00286",
  "title": "Virtual Network security group flow log retention period should be set to 90 days or greater"
}

security_groups = fugue.resources("azurerm_network_security_group")
flow_logs = fugue.resources("azurerm_network_watcher_flow_log")

watched_security_group_ids[security_group_id] {
  flow_log = flow_logs[_]
  flow_log.retention_policy[_].enabled
  flow_log.retention_policy[_].days >= 90
  security_group_id = lower(flow_log.network_security_group_id)
}

resource_type = "MULTIPLE"

policy[p] {
  sg = security_groups[_]
  watched_security_group_ids[lower(sg.id)]
  p = fugue.allow_resource(sg)
} {
  sg = security_groups[_]
  not watched_security_group_ids[lower(sg.id)]
  p = fugue.deny_resource(sg)
}

