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

package rules.arm_app_service_auth_enabled

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00345",
	"title": "App Service web app authentication should be enabled",
	"description": "Azure App Service Authentication is a feature that can prevent anonymous HTTP requests from reaching the API app, or authenticate those that have tokens before they reach the API app. If an anonymous request is received from a browser, App Service will redirect to a logon page. To handle the logon process, a choice from a set of identity providers can be made, or a custom authentication mechanism can be implemented.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_9.1"
			],
			"CIS-Azure_v1.3.0": [
				"CIS-Azure_v1.3.0_9.1"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

sites := fugue.resources("Microsoft.Web/sites")
configs := fugue.resources("Microsoft.Web/sites/config")

is_valid_authsettings(c) {
	c.name == "authsettings"
	c.properties.enabled == true
}

is_valid_authsettings(c) {
	c.name == "authsettingsv2"
	c.properties.platform.enabled == true
}

valid_sites := {id |
	c := configs[_]
	is_valid_authsettings(c)
	id := c._parent_id
	sites[id]
}

policy[p] {
	s := sites[id]
	not valid_sites[id]
	p = fugue.deny_resource(s)
}

policy[p] {
	s := sites[id]
	valid_sites[id]
	p = fugue.allow_resource(s)
}
