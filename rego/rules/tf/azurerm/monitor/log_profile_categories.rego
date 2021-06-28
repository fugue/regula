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
package rules.azurerm_monitor_log_profile_categories


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_5.1.3"
      ],
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_6.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "Monitor audit profile should log all activities. The log profile should be configured to export all activities from the control/management plane. A log profile controls how the activity log is exported. Configuring the log profile to collect logs for the categories \"write\", \"delete\" and \"action\" ensures that all the control/management plane activities performed on the subscription are exported.",
  "id": "FG_R00341",
  "title": "Monitor audit profile should log all activities"
}

resource_type = "azurerm_monitor_log_profile"

default allow = false

allow {
  lower(input.categories[_]) == "write"
  lower(input.categories[_]) == "delete"
  lower(input.categories[_]) == "action"
}

