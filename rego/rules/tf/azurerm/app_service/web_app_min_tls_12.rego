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
package rules.tf_azurerm_app_service_web_app_min_tls_12

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_9.3"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_9.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "App Service web apps should have 'Minimum TLS Version' set to '1.2'. The TLS (Transport Layer Security) protocol secures transmission of data over the internet using standard encryption technology. Encryption should be set with the latest version of TLS. App service allows TLS 1.2 by default, which is the recommended TLS level by industry standards.",
  "id": "FG_R00347",
  "title": "App Service web apps should have 'Minimum TLS Version' set to '1.2'"
}

resource_type := "azurerm_app_service"

default deny = false

deny {
  not input.site_config
} {
  not all([t | t = input.site_config[_].min_tls_version; t != "1.2"])
}
