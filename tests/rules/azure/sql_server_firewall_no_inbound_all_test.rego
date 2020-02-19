package tests.rules.sql_server_firewall_no_inbound_all

import data.fugue.regula

test_sql_server_firewall_no_inbound_all {
  report := regula.report with input as mock_input
  resources := report.rules.sql_server_firewall_no_inbound_all.resources

  resources["azurerm_sql_firewall_rule.validrule1"].valid == true
  resources["azurerm_sql_firewall_rule.invalidrule1"].valid == false
  resources["azurerm_sql_firewall_rule.invalidrule2"].valid == false
  resources["azurerm_sql_firewall_rule.invalidrule3"].valid == false
  resources["azurerm_sql_firewall_rule.invalidrule4"].valid == false
}