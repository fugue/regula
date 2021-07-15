# Copyright 2020 Fugue, Inc.
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
package rules.tf_azurerm_storage_account_microsoft_services

__rego__metadoc__ := {
  "id": "FG_R00208",
  "title": "Storage accounts 'Trusted Microsoft Services' access should be enabled",
  "description": "Some Microsoft services that interact with storage accounts operate from networks that can't be granted access through network rules. Enabling \"Trusted Microsoft Services\" allows Azure Backup, Azure Site Recovery, Azure Networking, Azure Monitor, and other Azure services to access your storage account and bypass any firewall rules.",
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_3.8"
      ]
    },
    "severity": "Medium"
  }
}

resource_type = "azurerm_storage_account"

default allow = false

# By default, storage accounts allow connections from clients on any network. 

allow {
  input.network_rules[0].default_action == "Deny"
  bypass_block = input.network_rules[0].bypass[_]
  bypass_block = "AzureServices"
}
