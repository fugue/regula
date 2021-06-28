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
package rules.azurerm_app_service_web_app_incoming_client_certs


__rego__metadoc__ := {
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
  },
  "description": "App Service web apps should have 'Incoming client certificates' enabled. Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app.",
  "id": "FG_R00348",
  "title": "App Service web apps should have 'Incoming client certificates' enabled"
}

resource_type = "azurerm_app_service"

default allow = false

allow {
  input.client_cert_enabled == true
}

