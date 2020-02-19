# SQL Server firewall rules should not permit ingress from 0.0.0.0/0 to 
# all ports and protocols. To reduce the potential attack surface for a 
# SQL server, firewall rules should be defined with more granular IP addresses 
# by referencing the range of addresses available from specific data centers.

package rules.sql_server_firewall_no_inbound_all

controls = {"CIS_Azure_1.1.0_6-3", "REGULA_R00021"}
resource_type = "azurerm_sql_firewall_rule"

default deny = false

# An invalid range has start IP set to `0.0.0.0`; or end IP set to `0.0.0.0` or
# `255.255.255.255`
#
# NOTE: The Azure feature 'Allow access to Azure services' can be enabled by
# setting start_ip_address and end_ip_address to 0.0.0.0.  However, the CIS Azure
# Foundations Benchmark recommends disallowing this

deny {
  input.start_ip_address == "0.0.0.0"
} {
  input.end_ip_address == "0.0.0.0"
} {
  input.end_ip_address == "255.255.255.255"
}