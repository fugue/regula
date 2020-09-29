# Copyright 2020 Fugue, Inc.
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

# This package was automatically generated from:
#
#     tests/rules/azure/inputs/storage_account_microsoft_services_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.storage_account_microsoft_services
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
          "address": "azurerm_storage_account.invalidstorageaccount1",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "invalidstorageaccount1",
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
            "name": "invalidstorageaccount1",
            "network_rules": [
              {
                "default_action": "Allow"
              }
            ],
            "resource_group_name": "example-resources"
          }
        },
        {
          "address": "azurerm_storage_account.invalidstorageaccount2",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "invalidstorageaccount2",
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
            "name": "invalidstorageaccount2",
            "network_rules": [
              {
                "bypass": [
                  "Logging",
                  "Metrics"
                ],
                "default_action": "Deny"
              }
            ],
            "resource_group_name": "example-resources"
          }
        },
        {
          "address": "azurerm_storage_account.validstorageaccount1",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "validstorageaccount1",
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
            "enable_https_traffic_only": true,
            "is_hns_enabled": false,
            "location": "westeurope",
            "name": "validstorageaccount1",
            "network_rules": [
              {
                "bypass": [
                  "AzureServices"
                ],
                "default_action": "Deny",
                "ip_rules": [
                  "100.0.0.1"
                ]
              }
            ],
            "resource_group_name": "example-resources"
          }
        },
        {
          "address": "azurerm_storage_account.validstorageaccount2",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "validstorageaccount2",
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
            "enable_https_traffic_only": true,
            "is_hns_enabled": false,
            "location": "westeurope",
            "name": "validstorageaccount2",
            "network_rules": [
              {
                "bypass": [
                  "AzureServices",
                  "Logging",
                  "Metrics"
                ],
                "default_action": "Deny"
              }
            ],
            "resource_group_name": "example-resources"
          }
        },
        {
          "address": "azurerm_subnet.example",
          "mode": "managed",
          "type": "azurerm_subnet",
          "name": "example",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "address_prefix": "10.0.2.0/24",
            "delegation": [],
            "enforce_private_link_endpoint_network_policies": false,
            "enforce_private_link_service_network_policies": false,
            "name": "subnetname",
            "network_security_group_id": null,
            "resource_group_name": "example-resources",
            "route_table_id": null,
            "service_endpoints": [
              "Microsoft.Sql",
              "Microsoft.Storage"
            ],
            "virtual_network_name": "virtnetname"
          }
        },
        {
          "address": "azurerm_virtual_network.example",
          "mode": "managed",
          "type": "azurerm_virtual_network",
          "name": "example",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "address_space": [
              "10.0.0.0/16"
            ],
            "ddos_protection_plan": [],
            "dns_servers": null,
            "location": "westeurope",
            "name": "virtnetname",
            "resource_group_name": "example-resources"
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
      "address": "azurerm_storage_account.invalidstorageaccount1",
      "mode": "managed",
      "type": "azurerm_storage_account",
      "name": "invalidstorageaccount1",
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
          "name": "invalidstorageaccount1",
          "network_rules": [
            {
              "default_action": "Allow"
            }
          ],
          "resource_group_name": "example-resources"
        },
        "after_unknown": {
          "access_tier": true,
          "account_type": true,
          "blob_properties": true,
          "custom_domain": [],
          "enable_advanced_threat_protection": true,
          "id": true,
          "identity": true,
          "network_rules": [
            {
              "bypass": true,
              "ip_rules": true,
              "virtual_network_subnet_ids": true
            }
          ],
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
          "tags": true
        }
      }
    },
    {
      "address": "azurerm_storage_account.invalidstorageaccount2",
      "mode": "managed",
      "type": "azurerm_storage_account",
      "name": "invalidstorageaccount2",
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
          "name": "invalidstorageaccount2",
          "network_rules": [
            {
              "bypass": [
                "Logging",
                "Metrics"
              ],
              "default_action": "Deny"
            }
          ],
          "resource_group_name": "example-resources"
        },
        "after_unknown": {
          "access_tier": true,
          "account_type": true,
          "blob_properties": true,
          "custom_domain": [],
          "enable_advanced_threat_protection": true,
          "id": true,
          "identity": true,
          "network_rules": [
            {
              "bypass": [
                false,
                false
              ],
              "ip_rules": true,
              "virtual_network_subnet_ids": true
            }
          ],
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
          "tags": true
        }
      }
    },
    {
      "address": "azurerm_storage_account.validstorageaccount1",
      "mode": "managed",
      "type": "azurerm_storage_account",
      "name": "validstorageaccount1",
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
          "enable_https_traffic_only": true,
          "is_hns_enabled": false,
          "location": "westeurope",
          "name": "validstorageaccount1",
          "network_rules": [
            {
              "bypass": [
                "AzureServices"
              ],
              "default_action": "Deny",
              "ip_rules": [
                "100.0.0.1"
              ]
            }
          ],
          "resource_group_name": "example-resources"
        },
        "after_unknown": {
          "access_tier": true,
          "account_type": true,
          "blob_properties": true,
          "custom_domain": [],
          "enable_advanced_threat_protection": true,
          "id": true,
          "identity": true,
          "network_rules": [
            {
              "bypass": [
                false
              ],
              "ip_rules": [
                false
              ],
              "virtual_network_subnet_ids": true
            }
          ],
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
          "tags": true
        }
      }
    },
    {
      "address": "azurerm_storage_account.validstorageaccount2",
      "mode": "managed",
      "type": "azurerm_storage_account",
      "name": "validstorageaccount2",
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
          "enable_https_traffic_only": true,
          "is_hns_enabled": false,
          "location": "westeurope",
          "name": "validstorageaccount2",
          "network_rules": [
            {
              "bypass": [
                "AzureServices",
                "Logging",
                "Metrics"
              ],
              "default_action": "Deny"
            }
          ],
          "resource_group_name": "example-resources"
        },
        "after_unknown": {
          "access_tier": true,
          "account_type": true,
          "blob_properties": true,
          "custom_domain": [],
          "enable_advanced_threat_protection": true,
          "id": true,
          "identity": true,
          "network_rules": [
            {
              "bypass": [
                false,
                false,
                false
              ],
              "ip_rules": true,
              "virtual_network_subnet_ids": true
            }
          ],
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
          "tags": true
        }
      }
    },
    {
      "address": "azurerm_subnet.example",
      "mode": "managed",
      "type": "azurerm_subnet",
      "name": "example",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "address_prefix": "10.0.2.0/24",
          "delegation": [],
          "enforce_private_link_endpoint_network_policies": false,
          "enforce_private_link_service_network_policies": false,
          "name": "subnetname",
          "network_security_group_id": null,
          "resource_group_name": "example-resources",
          "route_table_id": null,
          "service_endpoints": [
            "Microsoft.Sql",
            "Microsoft.Storage"
          ],
          "virtual_network_name": "virtnetname"
        },
        "after_unknown": {
          "delegation": [],
          "id": true,
          "ip_configurations": true,
          "service_endpoints": [
            false,
            false
          ]
        }
      }
    },
    {
      "address": "azurerm_virtual_network.example",
      "mode": "managed",
      "type": "azurerm_virtual_network",
      "name": "example",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "address_space": [
            "10.0.0.0/16"
          ],
          "ddos_protection_plan": [],
          "dns_servers": null,
          "location": "westeurope",
          "name": "virtnetname",
          "resource_group_name": "example-resources"
        },
        "after_unknown": {
          "address_space": [
            false
          ],
          "ddos_protection_plan": [],
          "id": true,
          "subnet": true,
          "tags": true
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
          "address": "azurerm_storage_account.invalidstorageaccount1",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "invalidstorageaccount1",
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
              "constant_value": "invalidstorageaccount1"
            },
            "network_rules": [
              {
                "default_action": {
                  "constant_value": "Allow"
                }
              }
            ],
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            }
          },
          "schema_version": 2
        },
        {
          "address": "azurerm_storage_account.invalidstorageaccount2",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "invalidstorageaccount2",
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
              "constant_value": "invalidstorageaccount2"
            },
            "network_rules": [
              {
                "bypass": {
                  "constant_value": [
                    "Logging",
                    "Metrics"
                  ]
                },
                "default_action": {
                  "constant_value": "Deny"
                }
              }
            ],
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            }
          },
          "schema_version": 2
        },
        {
          "address": "azurerm_storage_account.validstorageaccount1",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "validstorageaccount1",
          "provider_config_key": "azurerm",
          "expressions": {
            "account_replication_type": {
              "constant_value": "LRS"
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
            "network_rules": [
              {
                "bypass": {
                  "constant_value": [
                    "AzureServices"
                  ]
                },
                "default_action": {
                  "constant_value": "Deny"
                },
                "ip_rules": {
                  "constant_value": [
                    "100.0.0.1"
                  ]
                },
                "virtual_network_subnet_ids": {
                  "references": [
                    "azurerm_subnet.example"
                  ]
                }
              }
            ],
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            }
          },
          "schema_version": 2
        },
        {
          "address": "azurerm_storage_account.validstorageaccount2",
          "mode": "managed",
          "type": "azurerm_storage_account",
          "name": "validstorageaccount2",
          "provider_config_key": "azurerm",
          "expressions": {
            "account_replication_type": {
              "constant_value": "LRS"
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
              "constant_value": "validstorageaccount2"
            },
            "network_rules": [
              {
                "bypass": {
                  "constant_value": [
                    "Logging",
                    "Metrics",
                    "AzureServices"
                  ]
                },
                "default_action": {
                  "constant_value": "Deny"
                }
              }
            ],
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            }
          },
          "schema_version": 2
        },
        {
          "address": "azurerm_subnet.example",
          "mode": "managed",
          "type": "azurerm_subnet",
          "name": "example",
          "provider_config_key": "azurerm",
          "expressions": {
            "address_prefix": {
              "constant_value": "10.0.2.0/24"
            },
            "name": {
              "constant_value": "subnetname"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "service_endpoints": {
              "constant_value": [
                "Microsoft.Sql",
                "Microsoft.Storage"
              ]
            },
            "virtual_network_name": {
              "references": [
                "azurerm_virtual_network.example"
              ]
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_virtual_network.example",
          "mode": "managed",
          "type": "azurerm_virtual_network",
          "name": "example",
          "provider_config_key": "azurerm",
          "expressions": {
            "address_space": {
              "constant_value": [
                "10.0.0.0/16"
              ]
            },
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "virtnetname"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
