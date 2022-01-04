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
package tests.rules.arm.sql.inputs.auditing_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "apiVersion": "2014-04-01",
      "location": "[resourceGroup().location]",
      "name": "regulaserver1",
      "properties": {
        "administratorLogin": "sysadmin",
        "administratorLoginPassword": "abcd1234!"
      },
      "resources": [
        {
          "apiVersion": "2021-05-01-preview",
          "dependsOn": [
            "Microsoft.Sql/servers/regulaserver1"
          ],
          "name": "as1",
          "properties": {
            "isAzureMonitorTargetEnabled": true,
            "retentionDays": 90,
            "state": "Enabled"
          },
          "type": "auditingSettings"
        }
      ],
      "type": "Microsoft.Sql/servers"
    },
    {
      "apiVersion": "2014-04-01",
      "location": "[resourceGroup().location]",
      "name": "regulaserver2",
      "properties": {
        "administratorLogin": "sysadmin",
        "administratorLoginPassword": "abcd1234!"
      },
      "type": "Microsoft.Sql/servers"
    },
    {
      "apiVersion": "2014-04-01",
      "location": "[resourceGroup().location]",
      "name": "regulaserver3",
      "properties": {
        "administratorLogin": "sysadmin",
        "administratorLoginPassword": "abcd1234!"
      },
      "resources": [
        {
          "apiVersion": "2021-05-01-preview",
          "dependsOn": [
            "Microsoft.Sql/servers/regulaserver3"
          ],
          "name": "as1",
          "properties": {
            "isAzureMonitorTargetEnabled": true,
            "retentionDays": 3,
            "state": "Enabled"
          },
          "type": "auditingSettings"
        }
      ],
      "type": "Microsoft.Sql/servers"
    }
  ]
}

