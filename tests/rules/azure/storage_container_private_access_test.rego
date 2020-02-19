package tests.rules.storage_container_private_access

import data.fugue.regula

test_storage_container_private_access {
  report := regula.report with input as mock_input
  resources := report.rules.storage_container_private_access.resources

  resources["azurerm_storage_container.validcontainer1"].valid == true
  resources["azurerm_storage_container.validcontainer2"].valid == true
  resources["azurerm_storage_container.invalidcontainer1"].valid == false
}