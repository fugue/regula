# Copyright 2020-2021 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package tests.rules.tf.azurerm.storage.inputs.account_secure_transfer_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "configuration": {
    "provider_config": {
      "azurerm": {
        "expressions": {
          "features": [
            {}
          ]
        },
        "name": "azurerm"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "azurerm_resource_group.example",
          "expressions": {
            "location": {
              "constant_value": "West Europe"
            },
            "name": {
              "constant_value": "example-resources"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_resource_group"
        },
        {
          "address": "azurerm_storage_account.invalidstorageaccount1",
          "expressions": {
            "account_replication_type": {
              "constant_value": "GRS"
            },
            "account_tier": {
              "constant_value": "Standard"
            },
            "enable_https_traffic_only": {
              "constant_value": false
            },
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "invalidstorageaccount1"
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
          "mode": "managed",
          "name": "invalidstorageaccount1",
          "provider_config_key": "azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account"
        },
        {
          "address": "azurerm_storage_account.invalidstorageaccount2",
          "expressions": {
            "account_replication_type": {
              "constant_value": "GRS"
            },
            "account_tier": {
              "constant_value": "Standard"
            },
            "enable_https_traffic_only": {
              "constant_value": false
            },
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "invalidstorageaccount2"
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
          "mode": "managed",
          "name": "invalidstorageaccount2",
          "provider_config_key": "azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account"
        },
        {
          "address": "azurerm_storage_account.validstorageaccount1",
          "expressions": {
            "account_replication_type": {
              "constant_value": "GRS"
            },
            "account_tier": {
              "constant_value": "Standard"
            },
            "enable_https_traffic_only": {
              "constant_value": true
            },
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "validstorageaccount1"
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
          "mode": "managed",
          "name": "validstorageaccount1",
          "provider_config_key": "azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_resource_group.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_resource_group",
          "values": {
            "location": "westeurope",
            "name": "example-resources",
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_storage_account.invalidstorageaccount1",
          "mode": "managed",
          "name": "invalidstorageaccount1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account",
          "values": {
            "account_kind": "StorageV2",
            "account_replication_type": "GRS",
            "account_tier": "Standard",
            "allow_blob_public_access": false,
            "custom_domain": [],
            "enable_https_traffic_only": false,
            "is_hns_enabled": false,
            "location": "westeurope",
            "min_tls_version": "TLS1_0",
            "name": "invalidstorageaccount1",
            "nfsv3_enabled": false,
            "resource_group_name": "example-resources",
            "static_website": [],
            "tags": {
              "environment": "staging"
            },
            "timeouts": null
          }
        },
        {
          "address": "azurerm_storage_account.invalidstorageaccount2",
          "mode": "managed",
          "name": "invalidstorageaccount2",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account",
          "values": {
            "account_kind": "StorageV2",
            "account_replication_type": "GRS",
            "account_tier": "Standard",
            "allow_blob_public_access": false,
            "custom_domain": [],
            "enable_https_traffic_only": false,
            "is_hns_enabled": false,
            "location": "westeurope",
            "min_tls_version": "TLS1_0",
            "name": "invalidstorageaccount2",
            "nfsv3_enabled": false,
            "resource_group_name": "example-resources",
            "static_website": [],
            "tags": {
              "environment": "staging"
            },
            "timeouts": null
          }
        },
        {
          "address": "azurerm_storage_account.validstorageaccount1",
          "mode": "managed",
          "name": "validstorageaccount1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account",
          "values": {
            "account_kind": "StorageV2",
            "account_replication_type": "GRS",
            "account_tier": "Standard",
            "allow_blob_public_access": false,
            "custom_domain": [],
            "enable_https_traffic_only": true,
            "is_hns_enabled": false,
            "location": "westeurope",
            "min_tls_version": "TLS1_0",
            "name": "validstorageaccount1",
            "nfsv3_enabled": false,
            "resource_group_name": "example-resources",
            "static_website": [],
            "tags": {
              "environment": "staging"
            },
            "timeouts": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "azurerm_resource_group.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "location": "westeurope",
          "name": "example-resources",
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_resource_group"
    },
    {
      "address": "azurerm_storage_account.invalidstorageaccount1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "account_kind": "StorageV2",
          "account_replication_type": "GRS",
          "account_tier": "Standard",
          "allow_blob_public_access": false,
          "custom_domain": [],
          "enable_https_traffic_only": false,
          "is_hns_enabled": false,
          "location": "westeurope",
          "min_tls_version": "TLS1_0",
          "name": "invalidstorageaccount1",
          "nfsv3_enabled": false,
          "resource_group_name": "example-resources",
          "static_website": [],
          "tags": {
            "environment": "staging"
          },
          "timeouts": null
        },
        "after_unknown": {
          "access_tier": true,
          "blob_properties": true,
          "custom_domain": [],
          "id": true,
          "identity": true,
          "large_file_share_enabled": true,
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
          "static_website": [],
          "tags": {}
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidstorageaccount1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_account"
    },
    {
      "address": "azurerm_storage_account.invalidstorageaccount2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "account_kind": "StorageV2",
          "account_replication_type": "GRS",
          "account_tier": "Standard",
          "allow_blob_public_access": false,
          "custom_domain": [],
          "enable_https_traffic_only": false,
          "is_hns_enabled": false,
          "location": "westeurope",
          "min_tls_version": "TLS1_0",
          "name": "invalidstorageaccount2",
          "nfsv3_enabled": false,
          "resource_group_name": "example-resources",
          "static_website": [],
          "tags": {
            "environment": "staging"
          },
          "timeouts": null
        },
        "after_unknown": {
          "access_tier": true,
          "blob_properties": true,
          "custom_domain": [],
          "id": true,
          "identity": true,
          "large_file_share_enabled": true,
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
          "static_website": [],
          "tags": {}
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidstorageaccount2",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_account"
    },
    {
      "address": "azurerm_storage_account.validstorageaccount1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "account_kind": "StorageV2",
          "account_replication_type": "GRS",
          "account_tier": "Standard",
          "allow_blob_public_access": false,
          "custom_domain": [],
          "enable_https_traffic_only": true,
          "is_hns_enabled": false,
          "location": "westeurope",
          "min_tls_version": "TLS1_0",
          "name": "validstorageaccount1",
          "nfsv3_enabled": false,
          "resource_group_name": "example-resources",
          "static_website": [],
          "tags": {
            "environment": "staging"
          },
          "timeouts": null
        },
        "after_unknown": {
          "access_tier": true,
          "blob_properties": true,
          "custom_domain": [],
          "id": true,
          "identity": true,
          "large_file_share_enabled": true,
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
          "static_website": [],
          "tags": {}
        },
        "before": null
      },
      "mode": "managed",
      "name": "validstorageaccount1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_account"
    }
  ],
  "terraform_version": "0.13.5"
}

