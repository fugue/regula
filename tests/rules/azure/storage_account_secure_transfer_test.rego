package tests.rules.storage_account_secure_transfer

import data.fugue.regula

test_storage_account_secure_transfer {
  report := regula.report with input as mock_input
  resources := report.rules.storage_account_secure_transfer.resources

  resources["azurerm_storage_account.validstorageaccount1"].valid == true
  resources["azurerm_storage_account.invalidstorageaccount1"].valid == false
  resources["azurerm_storage_account.invalidstorageaccount2"].valid == false
}