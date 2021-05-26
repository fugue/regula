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
package tests.rules.tf.azurerm.network.inputs.security_group_no_inbound_3389_infra_json

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
          "address": "azurerm_network_security_group.invalidnsg1",
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
            }
          },
          "mode": "managed",
          "name": "invalidnsg1",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group"
        },
        {
          "address": "azurerm_network_security_group.invalidnsg2",
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
            }
          },
          "mode": "managed",
          "name": "invalidnsg2",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group"
        },
        {
          "address": "azurerm_network_security_group.testnsg",
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
          "mode": "managed",
          "name": "testnsg",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group"
        },
        {
          "address": "azurerm_network_security_group.validnsg1",
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
            }
          },
          "mode": "managed",
          "name": "validnsg1",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group"
        },
        {
          "address": "azurerm_network_security_rule.invalidrule1",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_range": {
              "constant_value": "3350-3400"
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
          "mode": "managed",
          "name": "invalidrule1",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule"
        },
        {
          "address": "azurerm_network_security_rule.invalidrule2",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_ranges": {
              "constant_value": [
                "3389",
                "3567"
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
          "mode": "managed",
          "name": "invalidrule2",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule"
        },
        {
          "address": "azurerm_network_security_rule.invalidrule3",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "0.0.0.0/0"
            },
            "destination_port_ranges": {
              "constant_value": [
                "3350-3400",
                "4300"
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
          "mode": "managed",
          "name": "invalidrule3",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule"
        },
        {
          "address": "azurerm_network_security_rule.validrule1",
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
          "mode": "managed",
          "name": "validrule1",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule"
        },
        {
          "address": "azurerm_network_security_rule.validrule2",
          "expressions": {
            "access": {
              "constant_value": "Allow"
            },
            "destination_address_prefix": {
              "constant_value": "*"
            },
            "destination_port_range": {
              "constant_value": "3389"
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
          "mode": "managed",
          "name": "validrule2",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule"
        },
        {
          "address": "azurerm_resource_group.example",
          "expressions": {
            "location": {
              "constant_value": "West US"
            },
            "name": {
              "constant_value": "acceptanceTestResourceGroup1"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_resource_group"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "azurerm_network_security_group.invalidnsg1",
          "mode": "managed",
          "name": "invalidnsg1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group",
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
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_group.invalidnsg2",
          "mode": "managed",
          "name": "invalidnsg2",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group",
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
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_group.testnsg",
          "mode": "managed",
          "name": "testnsg",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group",
          "values": {
            "location": "westus",
            "name": "testnsg",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_group.validnsg1",
          "mode": "managed",
          "name": "validnsg1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_group",
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
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_network_security_rule.invalidrule1",
          "mode": "managed",
          "name": "invalidrule1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule",
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": "3350-3400",
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
          "name": "invalidrule2",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule",
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": null,
            "destination_port_ranges": [
              "3389",
              "3567"
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
          "name": "invalidrule3",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule",
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "0.0.0.0/0",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": null,
            "destination_port_ranges": [
              "3350-3400",
              "4300"
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
          "name": "validrule1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule",
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
          "name": "validrule2",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_network_security_rule",
          "values": {
            "access": "Allow",
            "description": null,
            "destination_address_prefix": "*",
            "destination_address_prefixes": null,
            "destination_application_security_group_ids": null,
            "destination_port_range": "3389",
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
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_resource_group",
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
      "address": "azurerm_network_security_group.invalidnsg1",
      "change": {
        "actions": [
          "create"
        ],
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
          "tags": null,
          "timeouts": null
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
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidnsg1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_group"
    },
    {
      "address": "azurerm_network_security_group.invalidnsg2",
      "change": {
        "actions": [
          "create"
        ],
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
          "tags": null,
          "timeouts": null
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
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidnsg2",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_group"
    },
    {
      "address": "azurerm_network_security_group.testnsg",
      "change": {
        "actions": [
          "create"
        ],
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
        },
        "before": null
      },
      "mode": "managed",
      "name": "testnsg",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_group"
    },
    {
      "address": "azurerm_network_security_group.validnsg1",
      "change": {
        "actions": [
          "create"
        ],
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
          "tags": null,
          "timeouts": null
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
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "validnsg1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_group"
    },
    {
      "address": "azurerm_network_security_rule.invalidrule1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": "3350-3400",
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
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_rule"
    },
    {
      "address": "azurerm_network_security_rule.invalidrule2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": null,
          "destination_port_ranges": [
            "3389",
            "3567"
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
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule2",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_rule"
    },
    {
      "address": "azurerm_network_security_rule.invalidrule3",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "0.0.0.0/0",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": null,
          "destination_port_ranges": [
            "3350-3400",
            "4300"
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
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule3",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_rule"
    },
    {
      "address": "azurerm_network_security_rule.validrule1",
      "change": {
        "actions": [
          "create"
        ],
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
        },
        "before": null
      },
      "mode": "managed",
      "name": "validrule1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_rule"
    },
    {
      "address": "azurerm_network_security_rule.validrule2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "access": "Allow",
          "description": null,
          "destination_address_prefix": "*",
          "destination_address_prefixes": null,
          "destination_application_security_group_ids": null,
          "destination_port_range": "3389",
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
        },
        "before": null
      },
      "mode": "managed",
      "name": "validrule2",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_network_security_rule"
    },
    {
      "address": "azurerm_resource_group.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "location": "westus",
          "name": "acceptanceTestResourceGroup1",
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
    }
  ],
  "terraform_version": "0.13.5"
}

