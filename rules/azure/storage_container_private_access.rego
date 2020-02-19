# Storage containers should have access set to 'private'.
# Anonymous, public read access to a container and its blobs can be 
# enabled in Azure Blob storage. This is only recommended if absolutely necessary.

package rules.storage_container_private_access

controls = {"CIS_Azure_1.1.0_3-6", "REGULA_R00016"}
resource_type = "azurerm_storage_container"

default allow = false

allow {
  input.container_access_type == "private"
}