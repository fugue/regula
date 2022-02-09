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
package rules.tf_azurerm_storage_network_access_deny

import data.tests.rules.tf.azurerm.storage.inputs

import data.fugue

test_network_access_deny {
  # The tests do not match what is in the TF file since Azure will create
  # some rules by default.
  fugue.input_type == "tf_runtime"
  pol := policy with input as inputs.network_access_deny_tf.mock_input
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == false
  ]) == 3
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == true
  ]) == 0
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == false
  ]) == 2
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == true
  ]) == 1
} else {
  # Simply derived from the TF.
  fugue.input_type != "tf_runtime"
  pol := policy with input as inputs.network_access_deny_tf.mock_input
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == false
  ]) == 0
  count([p |
    pol[p]; p.type == "azurerm_storage_account"; p.valid == true
  ]) == 3
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == false
  ]) == 1
  count([p |
    pol[p]; p.type == "azurerm_storage_account_network_rules"; p.valid == true
  ]) == 1
}
