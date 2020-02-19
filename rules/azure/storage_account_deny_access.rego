# Storage accounts should deny access from all networks. 
# Restricting default network access helps to provide a new layer of security, 
# since storage accounts accept connections from clients on any network.  

package rules.storage_account_deny_access

controls = {"CIS_Azure_1.1.0_3-7", "REGULA_R00017"}
resource_type = "azurerm_storage_account"

default allow = false

# By default, storage accounts allow connections from clients on any network. 

allow {
  input.network_rules[0].default_action == "Deny"
}