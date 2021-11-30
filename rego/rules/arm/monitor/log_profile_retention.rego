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

package rules.arm_monitor_log_profile_retention

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00340",
	"title": "Monitor 'Activity Log Retention' should be 365 days or greater",
	"description": "A log profile controls how the activity log is exported and retained. Since the average time to detect a breach is 210 days, the activity log should be retained for 365 days or more in order to have time to respond to any incidents.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_5.1.2"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

resources = fugue.resources("Microsoft.Insights/logprofiles")

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
