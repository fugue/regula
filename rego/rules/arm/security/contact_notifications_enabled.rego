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

package rules.arm_security_contact_notifications_enabled

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_2.14"
      ]
    },
    "severity": "Medium"
  },
  "description": "Security Center email notifications ensure that the appropriate individuals in an organization are notified when issues occur, speeding up time to remediation. If using the Azure CLI or API, notifications are sent for \"high\" or greater severity alerts. If using the Azure Portal, users have the additional option of configuring the severity level.",
  "id": "FG_R00468",
  "title": "Security Center 'Send email notification for high severity alerts' should be enabled"
}

input_type := "arm"

resource_type := "Microsoft.Security/securityContacts"

default allow = false

allow {
	lower(input.properties.alertNotifications) == "on"
}
