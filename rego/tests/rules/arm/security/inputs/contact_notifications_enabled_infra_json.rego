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
package tests.rules.arm.security.inputs.contact_notifications_enabled_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "apiVersion": "2017-08-01-preview",
      "name": "valid",
      "properties": {
        "alertNotifications": "On",
        "alertsToAdmins": "Off",
        "email": "regula.valid@example.com"
      },
      "type": "Microsoft.Security/securityContacts"
    },
    {
      "apiVersion": "2017-08-01-preview",
      "name": "invalid",
      "properties": {
        "alertNotifications": "Off",
        "alertsToAdmins": "Off",
        "email": "regula.invalid@example.com"
      },
      "type": "Microsoft.Security/securityContacts"
    }
  ]
}

