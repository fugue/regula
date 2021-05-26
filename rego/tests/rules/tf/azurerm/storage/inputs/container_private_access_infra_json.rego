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
package tests.rules.tf.azurerm.storage.inputs.container_private_access_infra_json

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
          "address": "azurerm_storage_account.example",
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
          "mode": "managed",
          "name": "example",
          "provider_config_key": "azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account"
        },
        {
          "address": "azurerm_storage_container.invalidcontainer1",
          "expressions": {
            "container_access_type": {
              "constant_value": "container"
            },
            "name": {
              "constant_value": "invalidcontainer1"
            },
            "storage_account_name": {
              "references": [
                "azurerm_storage_account.example"
              ]
            }
          },
          "mode": "managed",
          "name": "invalidcontainer1",
          "provider_config_key": "azurerm",
          "schema_version": 1,
          "type": "azurerm_storage_container"
        },
        {
          "address": "azurerm_storage_container.validcontainer1",
          "expressions": {
            "container_access_type": {
              "constant_value": "private"
            },
            "name": {
              "constant_value": "validcontainer1"
            },
            "storage_account_name": {
              "references": [
                "azurerm_storage_account.example"
              ]
            }
          },
          "mode": "managed",
          "name": "validcontainer1",
          "provider_config_key": "azurerm",
          "schema_version": 1,
          "type": "azurerm_storage_container"
        },
        {
          "address": "azurerm_storage_container.validcontainer2",
          "expressions": {
            "name": {
              "constant_value": "validcontainer2"
            },
            "storage_account_name": {
              "references": [
                "azurerm_storage_account.example"
              ]
            }
          },
          "mode": "managed",
          "name": "validcontainer2",
          "provider_config_key": "azurerm",
          "schema_version": 1,
          "type": "azurerm_storage_container"
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
          "address": "azurerm_storage_account.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 2,
          "type": "azurerm_storage_account",
          "values": {
            "account_kind": "StorageV2",
            "account_replication_type": "LRS",
            "account_tier": "Standard",
            "allow_blob_public_access": false,
            "custom_domain": [],
            "enable_https_traffic_only": true,
            "is_hns_enabled": false,
            "location": "westeurope",
            "min_tls_version": "TLS1_0",
            "name": "examplestoraccount",
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
          "address": "azurerm_storage_container.invalidcontainer1",
          "mode": "managed",
          "name": "invalidcontainer1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 1,
          "type": "azurerm_storage_container",
          "values": {
            "container_access_type": "container",
            "name": "invalidcontainer1",
            "storage_account_name": "examplestoraccount",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_storage_container.validcontainer1",
          "mode": "managed",
          "name": "validcontainer1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 1,
          "type": "azurerm_storage_container",
          "values": {
            "container_access_type": "private",
            "name": "validcontainer1",
            "storage_account_name": "examplestoraccount",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_storage_container.validcontainer2",
          "mode": "managed",
          "name": "validcontainer2",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 1,
          "type": "azurerm_storage_container",
          "values": {
            "container_access_type": "private",
            "name": "validcontainer2",
            "storage_account_name": "examplestoraccount",
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
      "address": "azurerm_storage_account.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "account_kind": "StorageV2",
          "account_replication_type": "LRS",
          "account_tier": "Standard",
          "allow_blob_public_access": false,
          "custom_domain": [],
          "enable_https_traffic_only": true,
          "is_hns_enabled": false,
          "location": "westeurope",
          "min_tls_version": "TLS1_0",
          "name": "examplestoraccount",
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
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_account"
    },
    {
      "address": "azurerm_storage_container.invalidcontainer1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "container_access_type": "container",
          "name": "invalidcontainer1",
          "storage_account_name": "examplestoraccount",
          "timeouts": null
        },
        "after_unknown": {
          "has_immutability_policy": true,
          "has_legal_hold": true,
          "id": true,
          "metadata": true,
          "resource_manager_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidcontainer1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_container"
    },
    {
      "address": "azurerm_storage_container.validcontainer1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "container_access_type": "private",
          "name": "validcontainer1",
          "storage_account_name": "examplestoraccount",
          "timeouts": null
        },
        "after_unknown": {
          "has_immutability_policy": true,
          "has_legal_hold": true,
          "id": true,
          "metadata": true,
          "resource_manager_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "validcontainer1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_container"
    },
    {
      "address": "azurerm_storage_container.validcontainer2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "container_access_type": "private",
          "name": "validcontainer2",
          "storage_account_name": "examplestoraccount",
          "timeouts": null
        },
        "after_unknown": {
          "has_immutability_policy": true,
          "has_legal_hold": true,
          "id": true,
          "metadata": true,
          "resource_manager_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "validcontainer2",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_storage_container"
    }
  ],
  "terraform_version": "0.13.5"
}

