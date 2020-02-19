# Storage Accounts 'Secure transfer required' should be enabled. 
# The secure transfer option enhances the security of a storage account 
# by only allowing requests to the storage account by a secure connection. 
# This control does not apply for custom domain names since Azure storage does not support HTTPS for custom domain names.

package rules.storage_account_secure_transfer

controls = {"CIS_Azure_1.1.0_3-1", "REGULA_R00015"}
resource_type = "azurerm_storage_account"

default allow = false

allow {
  input.enable_https_traffic_only == true
}