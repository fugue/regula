package rules.storage_account_nohttps

resource_type = "Microsoft.Storage/storageAccounts"
input_type = "arm"

default allow = false

allow {
    input.properties.supportsHttpsTrafficOnly == "true"
}