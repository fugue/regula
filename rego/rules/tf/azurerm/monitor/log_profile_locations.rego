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
package rules.tf_azurerm_monitor_log_profile_locations

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_5.1.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "Monitor log profile should have activity logs for global services and all regions. Configure the log profile to export activities from all Azure supported regions/locations including global. This rule is evaluated against all resource locations that Fugue has permission to scan.",
  "id": "FG_R00342",
  "title": "Monitor log profile should have activity logs for global services and all regions"
}

used_locations = {lower(location) |
  fugue.input_resource_types[ty]
  resources = fugue.resources(ty)
  location = resources[_].location
}

invalid(log_profile) = msg {
  required_locations = used_locations | {"global"}
  present_locations = {lower(l) | l = log_profile.locations[_]}
  missing_locations = required_locations - present_locations
  count(missing_locations) > 0
  msg = sprintf(
    "The log profile is missing the following locations: %s",
    [concat(", ", missing_locations)]
  )
}

log_profiles = fugue.resources("azurerm_monitor_log_profile")

resource_type := "MULTIPLE"

policy[p] {
  fugue.input_type == "tf_runtime"
  count(log_profiles) == 0
  p = fugue.missing_resource("azurerm_monitor_log_profile")
} {
  log_profile = log_profiles[_]
  msg = invalid(log_profile)
  p = fugue.deny_resource_with_message(log_profile, msg)
} {
  log_profile = log_profiles[_]
  not invalid(log_profile)
  p = fugue.allow_resource(log_profile)
}
