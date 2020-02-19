package tests.rules.network_security_rule_no_ingress_22

import data.fugue.regula

test_network_security_rule_no_ingress_22 {
  report := regula.report with input as mock_input
  resources := report.rules.network_security_rule_no_ingress_22.resources

  resources["azurerm_network_security_rule.validrule1"].valid == true
  resources["azurerm_network_security_rule.validrule2"].valid == true
  resources["azurerm_network_security_rule.invalidrule1"].valid == false
  resources["azurerm_network_security_rule.invalidrule2"].valid == false
  resources["azurerm_network_security_rule.invalidrule3"].valid == false
}
