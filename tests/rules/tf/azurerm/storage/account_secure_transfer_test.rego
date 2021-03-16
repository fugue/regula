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
package rules.tf_azurerm_storage_account_secure_transfer

import data.tests.rules.tf.azurerm.storage.inputs.account_secure_transfer_infra

test_storage_account_secure_transfer {
  resources = account_secure_transfer_infra.mock_resources
  allow with input as resources["azurerm_storage_account.validstorageaccount1"]
  not allow with input as resources["azurerm_storage_account.invalidstorageaccount1"]
  not allow with input as resources["azurerm_storage_account.invalidstorageaccount2"]
}
