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
package rules.tf_azurerm_app_service_web_app_https_only

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_9.2"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_9.2"
      ]
    },
    "severity": "High"
  },
  "description": "App Service web apps should have 'HTTPS only' enabled. Azure Web Apps allows sites to run under both HTTP and HTTPS by default. Web apps can be accessed by anyone using non-secure HTTP links by default. Non-secure HTTP requests can be restricted and all HTTP requests redirected to the secure HTTPS port. It is recommended to enforce HTTPS-only traffic.",
  "id": "FG_R00346",
  "title": "App Service web apps should have 'HTTPS only' enabled"
}

resource_type := "azurerm_app_service"

default allow = false

allow {
  input.https_only == true
}
