package tests.rules.network_security_group_no_inbound_22

import data.fugue.regula

test_network_security_group_no_inbound_22 {
  report := regula.report with input as mock_input
  resources := report.rules.network_security_group_no_inbound_22.resources

  resources["azurerm_network_security_group.validnsg1"].valid == true
  resources["azurerm_network_security_group.invalidnsg1"].valid == false
  resources["azurerm_network_security_group.invalidnsg2"].valid == false
}
