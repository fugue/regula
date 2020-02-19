# This package was automatically generated from:
#
#     tests/rules/azure/inputs/storage_container_private_access_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.storage_container_private_access
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.20",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_resource_group.example",
          "mode": "managed",
          "type": "azurerm_resource_group",
          "name": "example",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "location": "westeurope",
            "name": "example-resources"
          }
        },
        {
          "address": "azurerm_storage_account.example",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "example",
          "provider_name": "azurerm",
          "schema_version": 2,
          "values": {
            "account_encryption_source": "Microsoft.Storage",
            "account_kind": "Storage",
            "account_replication_type": "LRS",
            "account_tier": "Standard",
            "custom_domain": [],
            "enable_blob_encryption": true,
            "enable_file_encryption": true,
            "enable_https_traffic_only": null,
            "is_hns_enabled": false,
            "location": "westeurope",
            "name": "examplestoraccount",
            "resource_group_name": "example-resources",
            "tags": {
              "environment": "staging"
            }
          }
        },
        {
          "address": "azurerm_storage_container.invalidcontainer1",
          "mode": "managed",
          "type": "azurerm_storage_container",
          "name": "invalidcontainer1",
          "provider_name": "azurerm",
          "schema_version": 1,
          "values": {
            "container_access_type": "container",
            "name": "invalidcontainer1",
            "resource_group_name": "example-resources",
            "storage_account_name": "examplestoraccount"
          }
        },
        {
          "address": "azurerm_storage_container.validcontainer1",
          "mode": "managed",
          "type": "azurerm_storage_container",
          "name": "validcontainer1",
          "provider_name": "azurerm",
          "schema_version": 1,
          "values": {
            "container_access_type": "private",
            "name": "validcontainer1",
            "resource_group_name": "example-resources",
            "storage_account_name": "examplestoraccount"
          }
        },
        {
          "address": "azurerm_storage_container.validcontainer2",
          "mode": "managed",
          "type": "azurerm_storage_container",
          "name": "validcontainer2",
          "provider_name": "azurerm",
          "schema_version": 1,
          "values": {
            "container_access_type": "private",
            "name": "validcontainer2",
            "resource_group_name": "example-resources",
            "storage_account_name": "examplestoraccount"
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "azurerm_resource_group.example",
      "mode": "managed",
      "type": "azurerm_resource_group",
      "name": "example",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "location": "westeurope",
          "name": "example-resources"
        },
        "after_unknown": {
          "id": true,
          "tags": true
        }
      }
    },
    {
      "address": "azurerm_storage_account.example",
      "mode": "managed",
      "type": "azurerm_storage_account",
      "name": "example",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "account_encryption_source": "Microsoft.Storage",
          "account_kind": "Storage",
          "account_replication_type": "LRS",
          "account_tier": "Standard",
          "custom_domain": [],
          "enable_blob_encryption": true,
          "enable_file_encryption": true,
          "enable_https_traffic_only": null,
          "is_hns_enabled": false,
          "location": "westeurope",
          "name": "examplestoraccount",
          "resource_group_name": "example-resources",
          "tags": {
            "environment": "staging"
          }
        },
        "after_unknown": {
          "access_tier": true,
          "account_type": true,
          "blob_properties": true,
          "custom_domain": [],
          "enable_advanced_threat_protection": true,
          "id": true,
          "identity": true,
          "network_rules": true,
          "primary_access_key": true,
          "primary_blob_connection_string": true,
          "primary_blob_endpoint": true,
          "primary_blob_host": true,
          "primary_connection_string": true,
          "primary_dfs_endpoint": true,
          "primary_dfs_host": true,
          "primary_file_endpoint": true,
          "primary_file_host": true,
          "primary_location": true,
          "primary_queue_endpoint": true,
          "primary_queue_host": true,
          "primary_table_endpoint": true,
          "primary_table_host": true,
          "primary_web_endpoint": true,
          "primary_web_host": true,
          "queue_properties": true,
          "secondary_access_key": true,
          "secondary_blob_connection_string": true,
          "secondary_blob_endpoint": true,
          "secondary_blob_host": true,
          "secondary_connection_string": true,
          "secondary_dfs_endpoint": true,
          "secondary_dfs_host": true,
          "secondary_file_endpoint": true,
          "secondary_file_host": true,
          "secondary_location": true,
          "secondary_queue_endpoint": true,
          "secondary_queue_host": true,
          "secondary_table_endpoint": true,
          "secondary_table_host": true,
          "secondary_web_endpoint": true,
          "secondary_web_host": true,
          "tags": {}
        }
      }
    },
    {
      "address": "azurerm_storage_container.invalidcontainer1",
      "mode": "managed",
      "type": "azurerm_storage_container",
      "name": "invalidcontainer1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "container_access_type": "container",
          "name": "invalidcontainer1",
          "resource_group_name": "example-resources",
          "storage_account_name": "examplestoraccount"
        },
        "after_unknown": {
          "has_immutability_policy": true,
          "has_legal_hold": true,
          "id": true,
          "metadata": true,
          "properties": true
        }
      }
    },
    {
      "address": "azurerm_storage_container.validcontainer1",
      "mode": "managed",
      "type": "azurerm_storage_container",
      "name": "validcontainer1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "container_access_type": "private",
          "name": "validcontainer1",
          "resource_group_name": "example-resources",
          "storage_account_name": "examplestoraccount"
        },
        "after_unknown": {
          "has_immutability_policy": true,
          "has_legal_hold": true,
          "id": true,
          "metadata": true,
          "properties": true
        }
      }
    },
    {
      "address": "azurerm_storage_container.validcontainer2",
      "mode": "managed",
      "type": "azurerm_storage_container",
      "name": "validcontainer2",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "container_access_type": "private",
          "name": "validcontainer2",
          "resource_group_name": "example-resources",
          "storage_account_name": "examplestoraccount"
        },
        "after_unknown": {
          "has_immutability_policy": true,
          "has_legal_hold": true,
          "id": true,
          "metadata": true,
          "properties": true
        }
      }
    }
  ],
  "configuration": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_resource_group.example",
          "mode": "managed",
          "type": "azurerm_resource_group",
          "name": "example",
          "provider_config_key": "azurerm",
          "expressions": {
            "location": {
              "constant_value": "West Europe"
            },
            "name": {
              "constant_value": "example-resources"
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_storage_account.example",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "example",
          "provider_config_key": "azurerm",
          "expressions": {
            "account_replication_type": {
              "constant_value": "LRS"
            },
            "account_tier": {
              "constant_value": "Standard"
            },
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "examplestoraccount"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "tags": {
              "constant_value": {
                "environment": "staging"
              }
            }
          },
          "schema_version": 2
        },
        {
          "address": "azurerm_storage_container.invalidcontainer1",
          "mode": "managed",
          "type": "azurerm_storage_container",
          "name": "invalidcontainer1",
          "provider_config_key": "azurerm",
          "expressions": {
            "container_access_type": {
              "constant_value": "container"
            },
            "name": {
              "constant_value": "invalidcontainer1"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "storage_account_name": {
              "references": [
                "azurerm_storage_account.example"
              ]
            }
          },
          "schema_version": 1
        },
        {
          "address": "azurerm_storage_container.validcontainer1",
          "mode": "managed",
          "type": "azurerm_storage_container",
          "name": "validcontainer1",
          "provider_config_key": "azurerm",
          "expressions": {
            "container_access_type": {
              "constant_value": "private"
            },
            "name": {
              "constant_value": "validcontainer1"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "storage_account_name": {
              "references": [
                "azurerm_storage_account.example"
              ]
            }
          },
          "schema_version": 1
        },
        {
          "address": "azurerm_storage_container.validcontainer2",
          "mode": "managed",
          "type": "azurerm_storage_container",
          "name": "validcontainer2",
          "provider_config_key": "azurerm",
          "expressions": {
            "name": {
              "constant_value": "validcontainer2"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "storage_account_name": {
              "references": [
                "azurerm_storage_account.example"
              ]
            }
          },
          "schema_version": 1
        }
      ]
    }
  }
}
