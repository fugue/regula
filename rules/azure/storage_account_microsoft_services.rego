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

# Storage accounts 'Trusted Microsoft Services' access should be enabled.
# Some Microsoft services that interact with storage accounts operate
# from networks that can't be granted access through network rules.
# To help this type of service work as intended, allow the set of trusted
# Microsoft services to bypass the network rules.
package rules.storage_account_microsoft_services

controls = {"CIS_Azure_1.1.0_3-8", "REGULA_R00018"}
resource_type = "azurerm_storage_account"

default allow = false

# By default, storage accounts allow connections from clients on any network. 

allow {
  input.network_rules[0].default_action == "Deny"
  bypass_block = input.network_rules[0].bypass[_]
  bypass_block = "AzureServices"
}
