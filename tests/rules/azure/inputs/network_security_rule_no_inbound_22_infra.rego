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
#     tests/rules/azure/inputs/network_security_rule_no_inbound_22_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.azure.inputs.network_security_rule_no_inbound_22_infra
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_network_security_group.testnsg",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "testnsg",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "location": "westus",
            "name": "testnsg",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_rule.invalidrule1",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "invalidrule1",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": "20-25",
            "destination_port_ranges": null,
            "direction": "Inbound",
            "name": "invalidrule1",
            "network_security_group_name": "testnsg",
            "priority": 100,
            "protocol": "Tcp",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "source_address_prefix": null,
            "source_address_prefixes": [
              "*",
              "10.10.10.10"
            ],
            "source_application_security_group_ids": null,
            "source_port_range": "*",
            "source_port_ranges": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_rule.invalidrule2",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "invalidrule2",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": null,
            "destination_port_ranges": [
              "22",
              "27"
            ],
            "direction": "Inbound",
            "name": "validrule2",
            "network_security_group_name": "testnsg",
            "priority": 100,
            "protocol": "Tcp",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "source_address_prefix": "Any",
            "source_address_prefixes": null,
            "source_application_security_group_ids": null,
            "source_port_range": "*",
            "source_port_ranges": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_rule.invalidrule3",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "invalidrule3",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "0.0.0.0/0",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": null,
            "destination_port_ranges": [
              "18-30",
              "88"
            ],
            "direction": "Inbound",
            "name": "validrule3",
            "network_security_group_name": "testnsg",
            "priority": 100,
            "protocol": "Tcp",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "source_address_prefix": "Any",
            "source_address_prefixes": null,
            "source_application_security_group_ids": null,
            "source_port_range": "*",
            "source_port_ranges": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_rule.validrule1",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "validrule1",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": "34",
            "destination_port_ranges": null,
            "direction": "Inbound",
            "name": "validrule1",
            "network_security_group_name": "testnsg",
            "priority": 100,
            "protocol": "Tcp",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "source_address_prefix": null,
            "source_address_prefixes": [
              "*",
              "10.10.10.10"
            ],
            "source_application_security_group_ids": null,
            "source_port_range": "*",
            "source_port_ranges": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_rule.validrule2",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "validrule2",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": "22",
            "destination_port_ranges": null,
            "direction": "Inbound",
            "name": "validrule2",
            "network_security_group_name": "testnsg",
            "priority": 100,
            "protocol": "Tcp",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "source_address_prefix": null,
            "source_address_prefixes": [
              "10.10.10.10"
            ],
            "source_application_security_group_ids": null,
            "source_port_range": "*",
            "source_port_ranges": null,
            "timeouts": null
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
            "name": "acceptanceTestResourceGroup1",
            "tags": null,
            "timeouts": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "azurerm_network_security_group.testnsg",
      "mode": "managed",
      "type": "azurerm_network_security_group",
      "name": "testnsg",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "location": "westus",
          "name": "testnsg",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "security_rule": true
        }
      }
    },
    {
      "address": "azurerm_network_security_rule.invalidrule1",
      "mode": "managed",
      "type": "azurerm_network_security_rule",
      "name": "invalidrule1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": "20-25",
          "destination_port_ranges": null,
          "direction": "Inbound",
          "name": "invalidrule1",
          "network_security_group_name": "testnsg",
          "priority": 100,
          "protocol": "Tcp",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "source_address_prefix": null,
          "source_address_prefixes": [
            "*",
            "10.10.10.10"
          ],
          "source_application_security_group_ids": null,
          "source_port_range": "*",
          "source_port_ranges": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "source_address_prefixes": [
            false,
            false
          ]
        }
      }
    },
    {
      "address": "azurerm_network_security_rule.invalidrule2",
      "mode": "managed",
      "type": "azurerm_network_security_rule",
      "name": "invalidrule2",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": null,
          "destination_port_ranges": [
            "22",
            "27"
          ],
          "direction": "Inbound",
          "name": "validrule2",
          "network_security_group_name": "testnsg",
          "priority": 100,
          "protocol": "Tcp",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "source_address_prefix": "Any",
          "source_address_prefixes": null,
          "source_application_security_group_ids": null,
          "source_port_range": "*",
          "source_port_ranges": null,
          "timeouts": null
        },
        "after_unknown": {
          "destination_port_ranges": [
            false,
            false
          ],
          "id": true
        }
      }
    },
    {
      "address": "azurerm_network_security_rule.invalidrule3",
      "mode": "managed",
      "type": "azurerm_network_security_rule",
      "name": "invalidrule3",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "0.0.0.0/0",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": null,
          "destination_port_ranges": [
            "18-30",
            "88"
          ],
          "direction": "Inbound",
          "name": "validrule3",
          "network_security_group_name": "testnsg",
          "priority": 100,
          "protocol": "Tcp",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "source_address_prefix": "Any",
          "source_address_prefixes": null,
          "source_application_security_group_ids": null,
          "source_port_range": "*",
          "source_port_ranges": null,
          "timeouts": null
        },
        "after_unknown": {
          "destination_port_ranges": [
            false,
            false
          ],
          "id": true
        }
      }
    },
    {
      "address": "azurerm_network_security_rule.validrule1",
      "mode": "managed",
      "type": "azurerm_network_security_rule",
      "name": "validrule1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": "34",
          "destination_port_ranges": null,
          "direction": "Inbound",
          "name": "validrule1",
          "network_security_group_name": "testnsg",
          "priority": 100,
          "protocol": "Tcp",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "source_address_prefix": null,
          "source_address_prefixes": [
            "*",
            "10.10.10.10"
          ],
          "source_application_security_group_ids": null,
          "source_port_range": "*",
          "source_port_ranges": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "source_address_prefixes": [
            false,
            false
          ]
        }
      }
    },
    {
      "address": "azurerm_network_security_rule.validrule2",
      "mode": "managed",
      "type": "azurerm_network_security_rule",
      "name": "validrule2",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": "22",
          "destination_port_ranges": null,
          "direction": "Inbound",
          "name": "validrule2",
          "network_security_group_name": "testnsg",
          "priority": 100,
          "protocol": "Tcp",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "source_address_prefix": null,
          "source_address_prefixes": [
            "10.10.10.10"
          ],
          "source_application_security_group_ids": null,
          "source_port_range": "*",
          "source_port_ranges": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "source_address_prefixes": [
            false
          ]
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
          "name": "acceptanceTestResourceGroup1",
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        }
      }
    }
  ],
  "configuration": {
    "provider_config": {
      "azurerm": {
        "name": "azurerm",
        "expressions": {
          "features": [
            {}
          ]
        }
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "azurerm_network_security_group.testnsg",
          "mode": "managed",
          "type": "azurerm_network_security_group",
          "name": "testnsg",
          "provider_config_key": "azurerm",
          "expressions": {
            "location": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "name": {
              "constant_value": "testnsg"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_rule.invalidrule1",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "invalidrule1",
          "provider_config_key": "azurerm",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_range": {
              "constant_value": "20-25"
            },
            "direction": {
              "constant_value": "Inbound"
            },
            "name": {
              "constant_value": "invalidrule1"
            },
            "network_security_group_name": {
              "references": [
                "azurerm_network_security_group.testnsg"
              ]
            },
            "priority": {
              "constant_value": 100
            },
            "protocol": {
              "constant_value": "Tcp"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "source_address_prefixes": {
              "constant_value": [
                "10.10.10.10",
                "*"
              ]
            },
            "source_port_range": {
              "constant_value": "*"
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_rule.invalidrule2",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "invalidrule2",
          "provider_config_key": "azurerm",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_ranges": {
              "constant_value": [
                "22",
                "27"
              ]
            },
            "direction": {
              "constant_value": "Inbound"
            },
            "name": {
              "constant_value": "validrule2"
            },
            "network_security_group_name": {
              "references": [
                "azurerm_network_security_group.testnsg"
              ]
            },
            "priority": {
              "constant_value": 100
            },
            "protocol": {
              "constant_value": "Tcp"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "source_address_prefix": {
              "constant_value": "Any"
            },
            "source_port_range": {
              "constant_value": "*"
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_rule.invalidrule3",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "invalidrule3",
          "provider_config_key": "azurerm",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "0.0.0.0/0"
            },
            "destination_port_ranges": {
              "constant_value": [
                "18-30",
                "88"
              ]
            },
            "direction": {
              "constant_value": "Inbound"
            },
            "name": {
              "constant_value": "validrule3"
            },
            "network_security_group_name": {
              "references": [
                "azurerm_network_security_group.testnsg"
              ]
            },
            "priority": {
              "constant_value": 100
            },
            "protocol": {
              "constant_value": "Tcp"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "source_address_prefix": {
              "constant_value": "Any"
            },
            "source_port_range": {
              "constant_value": "*"
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_rule.validrule1",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "validrule1",
          "provider_config_key": "azurerm",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_range": {
              "constant_value": "34"
            },
            "direction": {
              "constant_value": "Inbound"
            },
            "name": {
              "constant_value": "validrule1"
            },
            "network_security_group_name": {
              "references": [
                "azurerm_network_security_group.testnsg"
              ]
            },
            "priority": {
              "constant_value": 100
            },
            "protocol": {
              "constant_value": "Tcp"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "source_address_prefixes": {
              "constant_value": [
                "10.10.10.10",
                "*"
              ]
            },
            "source_port_range": {
              "constant_value": "*"
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_network_security_rule.validrule2",
          "mode": "managed",
          "type": "azurerm_network_security_rule",
          "name": "validrule2",
          "provider_config_key": "azurerm",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_range": {
              "constant_value": "22"
            },
            "direction": {
              "constant_value": "Inbound"
            },
            "name": {
              "constant_value": "validrule2"
            },
            "network_security_group_name": {
              "references": [
                "azurerm_network_security_group.testnsg"
              ]
            },
            "priority": {
              "constant_value": 100
            },
            "protocol": {
              "constant_value": "Tcp"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "source_address_prefixes": {
              "constant_value": [
                "10.10.10.10"
              ]
            },
            "source_port_range": {
              "constant_value": "*"
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
