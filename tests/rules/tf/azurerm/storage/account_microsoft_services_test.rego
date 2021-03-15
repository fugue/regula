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
package tests.rules.tf_azurerm_storage_account_microsoft_services

import data.fugue.regula
import data.tests.rules.tf.azurerm.storage.inputs.account_microsoft_services_infra.mock_plan_input

test_storage_account_microsoft_services {
  report := regula.report with input as mock_plan_input
  resources := report.rules.tf_azurerm_storage_account_microsoft_services.resources

  resources["azurerm_storage_account.validstorageaccount1"].valid == true
  resources["azurerm_storage_account.validstorageaccount2"].valid == true
  resources["azurerm_storage_account.invalidstorageaccount1"].valid == false
  resources["azurerm_storage_account.invalidstorageaccount2"].valid == false
}
