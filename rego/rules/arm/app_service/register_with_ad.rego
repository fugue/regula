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

package rules.arm_app_service_register_with_ad

__rego__metadoc__ := {
	"id": "FG_R00452",
	"title": "App Service web apps should use a system-assigned managed service identity",
	"description": "A system-assigned managed service entity from Azure Active Directory enables the app to connect to other Azure services securely without the need for usernames and passwords. Eliminating credentials from the app is a more secure approach.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_9.5"
      ]
		},
		"severity": "Low"
	}
}

input_type = "arm"

resource_type = "Microsoft.Web/sites"

default allow = false

allow {
  lower(input.identity.type) == "systemassigned"
}
