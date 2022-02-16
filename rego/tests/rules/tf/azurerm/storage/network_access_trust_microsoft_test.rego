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
package rules.tf_azurerm_storage_network_access_trust_microsoft

import data.tests.rules.tf.azurerm.storage.inputs

import data.fugue

test_network_access_trust_microsoft {
  # Includes rules added automatically.
  fugue.input_type == "tf_runtime"
  pol = policy with input as inputs.network_access_trust_microsoft_tf.mock_input
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == true]
  ) == 3
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == false]
  ) == 2

  # Azure automatically has this rule for storage accounts.
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == true]
  ) == 5
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == false]
  ) == 0
} else {
  fugue.input_type != "tf_runtime"
  pol = policy with input as inputs.network_access_trust_microsoft_tf.mock_input
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == true]
  ) == 2
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == false]
  ) == 2
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == true]
  ) == 2
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == false]
  ) == 3
}
