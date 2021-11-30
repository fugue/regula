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

package rules.arm_app_service_client_certs

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00348",
	"title": "App Service web apps should have 'Incoming client certificates' enabled",
	"description": "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_9.4"
			],
			"CIS-Azure_v1.3.0": [
				"CIS-Azure_v1.3.0_9.4"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

resources = fugue.resources("Microsoft.Web/sites")

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
