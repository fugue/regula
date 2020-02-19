# This package was automatically generated from:
#
#     tests/rules/azure/inputs/network_security_group_no_inbound_3389_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.network_security_group_no_inbound_3389
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_network_security_group.invalidnsg1",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "invalidnsg1",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "location": "westus",
            "name": "invalidnsg1",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "security_rule": [
              {
                "access": "Allow",
                "description": "",
                "destination_address_prefix": "*",
                "destination_address_prefixes": [],
                "destination_application_security_group_ids": [],
                "destination_port_range": "",
                "destination_port_ranges": [
                  "235",
                  "30-50"
                ],
                "direction": "Inbound",
                "name": "testrule2",
                "priority": 101,
                "protocol": "Tcp",
                "source_address_prefix": "",
                "source_address_prefixes": [
                  "10.10.10.10"
                ],
                "source_application_security_group_ids": [],
                "source_port_range": "*",
                "source_port_ranges": []
              },
              {
                "access": "Allow",
                "description": "",
                "destination_address_prefix": "*",
                "destination_address_prefixes": [],
                "destination_application_security_group_ids": [],
                "destination_port_range": "*",
                "destination_port_ranges": [],
                "direction": "Inbound",
                "name": "testrule1",
                "priority": 100,
                "protocol": "Tcp",
                "source_address_prefix": "*",
                "source_address_prefixes": [],
                "source_application_security_group_ids": [],
                "source_port_range": "*",
                "source_port_ranges": []
              }
            ],
            "tags": {
              "environment": "Production"
            }
          }
        },
        {
          "address": "azurerm_network_security_group.invalidnsg2",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "invalidnsg2",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "location": "westus",
            "name": "invalidnsg2",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "security_rule": [
              {
                "access": "Allow",
                "description": "",
                "destination_address_prefix": "*",
                "destination_address_prefixes": [],
                "destination_application_security_group_ids": [],
                "destination_port_range": "3389",
                "destination_port_ranges": [],
                "direction": "Inbound",
                "name": "testrule3",
                "priority": 103,
                "protocol": "Tcp",
                "source_address_prefix": "0.0.0.0/0",
                "source_address_prefixes": [],
                "source_application_security_group_ids": [],
                "source_port_range": "*",
                "source_port_ranges": []
              }
            ],
            "tags": {
              "environment": "Production"
            }
          }
        },
        {
          "address": "azurerm_network_security_group.validnsg1",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "validnsg1",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "location": "westus",
            "name": "validnsg1",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "security_rule": [
              {
                "access": "Allow",
                "description": "",
                "destination_address_prefix": "*",
                "destination_address_prefixes": [],
                "destination_application_security_group_ids": [],
                "destination_port_range": "",
                "destination_port_ranges": [
                  "235",
                  "3380-3395"
                ],
                "direction": "Inbound",
                "name": "testrule5",
                "priority": 101,
                "protocol": "Tcp",
                "source_address_prefix": "",
                "source_address_prefixes": [
                  "10.10.10.10"
                ],
                "source_application_security_group_ids": [],
                "source_port_range": "*",
                "source_port_ranges": []
              },
              {
                "access": "Allow",
                "description": "",
                "destination_address_prefix": "*",
                "destination_address_prefixes": [],
                "destination_application_security_group_ids": [],
                "destination_port_range": "20",
                "destination_port_ranges": [],
                "direction": "Inbound",
                "name": "testrule4",
                "priority": 100,
                "protocol": "Tcp",
                "source_address_prefix": "Internet",
                "source_address_prefixes": [],
                "source_application_security_group_ids": [],
                "source_port_range": "*",
                "source_port_ranges": []
              }
            ],
            "tags": {
              "environment": "Production"
            }
          }
        },
        {
          "address": "azurerm_resource_group.example",
          "mode": "managed",
          "type": "azurerm_resource_group",
          "name": "example",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "location": "westus",
            "name": "acceptanceTestResourceGroup1"
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "azurerm_network_security_group.invalidnsg1",
      "mode": "managed",
      "type": "azurerm_network_security_group",
      "name": "invalidnsg1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "location": "westus",
          "name": "invalidnsg1",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "security_rule": [
            {
              "access": "Allow",
              "description": "",
              "destination_address_prefix": "*",
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_range": "",
              "destination_port_ranges": [
                "235",
                "30-50"
              ],
              "direction": "Inbound",
              "name": "testrule2",
              "priority": 101,
              "protocol": "Tcp",
              "source_address_prefix": "",
              "source_address_prefixes": [
                "10.10.10.10"
              ],
              "source_application_security_group_ids": [],
              "source_port_range": "*",
              "source_port_ranges": []
            },
            {
              "access": "Allow",
              "description": "",
              "destination_address_prefix": "*",
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_range": "*",
              "destination_port_ranges": [],
              "direction": "Inbound",
              "name": "testrule1",
              "priority": 100,
              "protocol": "Tcp",
              "source_address_prefix": "*",
              "source_address_prefixes": [],
              "source_application_security_group_ids": [],
              "source_port_range": "*",
              "source_port_ranges": []
            }
          ],
          "tags": {
            "environment": "Production"
          }
        },
        "after_unknown": {
          "id": true,
          "security_rule": [
            {
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_ranges": [
                false,
                false
              ],
              "source_address_prefixes": [
                false
              ],
              "source_application_security_group_ids": [],
              "source_port_ranges": []
            },
            {
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_ranges": [],
              "source_address_prefixes": [],
              "source_application_security_group_ids": [],
              "source_port_ranges": []
            }
          ],
          "tags": {}
        }
      }
    },
    {
      "address": "azurerm_network_security_group.invalidnsg2",
      "mode": "managed",
      "type": "azurerm_network_security_group",
      "name": "invalidnsg2",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "location": "westus",
          "name": "invalidnsg2",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "security_rule": [
            {
              "access": "Allow",
              "description": "",
              "destination_address_prefix": "*",
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_range": "3389",
              "destination_port_ranges": [],
              "direction": "Inbound",
              "name": "testrule3",
              "priority": 103,
              "protocol": "Tcp",
              "source_address_prefix": "0.0.0.0/0",
              "source_address_prefixes": [],
              "source_application_security_group_ids": [],
              "source_port_range": "*",
              "source_port_ranges": []
            }
          ],
          "tags": {
            "environment": "Production"
          }
        },
        "after_unknown": {
          "id": true,
          "security_rule": [
            {
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_ranges": [],
              "source_address_prefixes": [],
              "source_application_security_group_ids": [],
              "source_port_ranges": []
            }
          ],
          "tags": {}
        }
      }
    },
    {
      "address": "azurerm_network_security_group.validnsg1",
      "mode": "managed",
      "type": "azurerm_network_security_group",
      "name": "validnsg1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "location": "westus",
          "name": "validnsg1",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "security_rule": [
            {
              "access": "Allow",
              "description": "",
              "destination_address_prefix": "*",
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_range": "",
              "destination_port_ranges": [
                "235",
                "3380-3395"
              ],
              "direction": "Inbound",
              "name": "testrule5",
              "priority": 101,
              "protocol": "Tcp",
              "source_address_prefix": "",
              "source_address_prefixes": [
                "10.10.10.10"
              ],
              "source_application_security_group_ids": [],
              "source_port_range": "*",
              "source_port_ranges": []
            },
            {
              "access": "Allow",
              "description": "",
              "destination_address_prefix": "*",
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_range": "20",
              "destination_port_ranges": [],
              "direction": "Inbound",
              "name": "testrule4",
              "priority": 100,
              "protocol": "Tcp",
              "source_address_prefix": "Internet",
              "source_address_prefixes": [],
              "source_application_security_group_ids": [],
              "source_port_range": "*",
              "source_port_ranges": []
            }
          ],
          "tags": {
            "environment": "Production"
          }
        },
        "after_unknown": {
          "id": true,
          "security_rule": [
            {
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_ranges": [
                false,
                false
              ],
              "source_address_prefixes": [
                false
              ],
              "source_application_security_group_ids": [],
              "source_port_ranges": []
            },
            {
              "destination_address_prefixes": [],
              "destination_application_security_group_ids": [],
              "destination_port_ranges": [],
              "source_address_prefixes": [],
              "source_application_security_group_ids": [],
              "source_port_ranges": []
            }
          ],
          "tags": {}
        }
      }
    },
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
          "location": "westus",
          "name": "acceptanceTestResourceGroup1"
        },
        "after_unknown": {
          "id": true,
          "tags": true
        }
      }
    }
  ],
  "configuration": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_network_security_group.invalidnsg1",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "invalidnsg1",
          "provider_config_key": "azurerm",
          "expressions": {
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "invalidnsg1"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "tags": {
              "constant_value": {
                "environment": "Production"
              }
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_group.invalidnsg2",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "invalidnsg2",
          "provider_config_key": "azurerm",
          "expressions": {
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "invalidnsg2"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "tags": {
              "constant_value": {
                "environment": "Production"
              }
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_group.validnsg1",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "validnsg1",
          "provider_config_key": "azurerm",
          "expressions": {
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "validnsg1"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "tags": {
              "constant_value": {
                "environment": "Production"
              }
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_resource_group.example",
          "mode": "managed",
          "type": "azurerm_resource_group",
          "name": "example",
          "provider_config_key": "azurerm",
          "expressions": {
            "location": {
              "constant_value": "West US"
            },
            "name": {
              "constant_value": "acceptanceTestResourceGroup1"
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
