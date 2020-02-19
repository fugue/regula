package tests.rules.storage_account_deny_access

import data.fugue.regula

test_storage_account_deny_access {
  report := regula.report with input as mock_input
  resources := report.rules.storage_account_deny_access.resources

  resources["azurerm_storage_account.validstorageaccount1"].valid == true
  resources["azurerm_storage_account.validstorageaccount2"].valid == true
  resources["azurerm_storage_account.invalidstorageaccount1"].valid == false
  resources["azurerm_storage_account.invalidstorageaccount2"].valid == false
}