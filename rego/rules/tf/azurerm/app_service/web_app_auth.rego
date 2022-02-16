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
package rules.tf_azurerm_app_service_web_app_auth

import data.fugue

__rego__metadoc__ := {
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
  },
  "description": "App Service web app authentication should be enabled. Azure App Service Authentication is a feature that can prevent anonymous HTTP requests from reaching the API app, or authenticate those that have tokens before they reach the API app. If an anonymous request is received from a browser, App Service will redirect to a logon page. To handle the logon process, a choice from a set of identity providers can be made, or a custom authentication mechanism can be implemented.",
  "id": "FG_R00345",
  "title": "App Service web app authentication should be enabled"
}

app_services = fugue.resources("azurerm_app_service")

no_permissions_msg = "Fugue may not have the necessary permissions to evaluate this rule"

resource_type := "MULTIPLE"

policy[p] {
  app_service = app_services[_]
  app_service.auth_settings
  app_service.auth_settings[_].enabled == false
  p = fugue.deny_resource(app_service)
} {
  app_service = app_services[_]
  app_service.auth_settings
  app_service.auth_settings[_].enabled == true
  p = fugue.allow_resource(app_service)
} {
  app_service = app_services[_]
  not app_service.auth_settings
  p = fugue.deny_resource_with_message(app_service, no_permissions_msg)
}