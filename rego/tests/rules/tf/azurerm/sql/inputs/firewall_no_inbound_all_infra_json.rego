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
package tests.rules.tf.azurerm.sql.inputs.firewall_no_inbound_all_infra_json

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
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule1",
          "expressions": {
            "end_ip_address": {
              "constant_value": "10.0.17.62"
            },
            "name": {
              "constant_value": "invalidrule1"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "server_name": {
              "references": [
                "azurerm_sql_server.example"
              ]
            },
            "start_ip_address": {
              "constant_value": "0.0.0.0"
            }
          },
          "mode": "managed",
          "name": "invalidrule1",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule"
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule2",
          "expressions": {
            "end_ip_address": {
              "constant_value": "0.0.0.0"
            },
            "name": {
              "constant_value": "invalidrule2"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "server_name": {
              "references": [
                "azurerm_sql_server.example"
              ]
            },
            "start_ip_address": {
              "constant_value": "0.0.0.0"
            }
          },
          "mode": "managed",
          "name": "invalidrule2",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule"
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule3",
          "expressions": {
            "end_ip_address": {
              "constant_value": "255.255.255.255"
            },
            "name": {
              "constant_value": "invalidrule3"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "server_name": {
              "references": [
                "azurerm_sql_server.example"
              ]
            },
            "start_ip_address": {
              "constant_value": "0.0.0.0"
            }
          },
          "mode": "managed",
          "name": "invalidrule3",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule"
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule4",
          "expressions": {
            "end_ip_address": {
              "constant_value": "255.255.255.255"
            },
            "name": {
              "constant_value": "invalidrule4"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "server_name": {
              "references": [
                "azurerm_sql_server.example"
              ]
            },
            "start_ip_address": {
              "constant_value": "10.0.17.62"
            }
          },
          "mode": "managed",
          "name": "invalidrule4",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule"
        },
        {
          "address": "azurerm_sql_firewall_rule.validrule1",
          "expressions": {
            "end_ip_address": {
              "constant_value": "10.0.17.62"
            },
            "name": {
              "constant_value": "validrule1"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "server_name": {
              "references": [
                "azurerm_sql_server.example"
              ]
            },
            "start_ip_address": {
              "constant_value": "10.0.17.62"
            }
          },
          "mode": "managed",
          "name": "validrule1",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule"
        },
        {
          "address": "azurerm_sql_server.example",
          "expressions": {
            "administrator_login": {
              "constant_value": "4dm1n157r470r"
            },
            "administrator_login_password": {
              "constant_value": "4-v3ry-53cr37-p455w0rd"
            },
            "location": {
              "constant_value": "West US"
            },
            "name": {
              "constant_value": "mysqlserver"
            },
            "resource_group_name": {
              "references": [
                "azurerm_resource_group.example"
              ]
            },
            "version": {
              "constant_value": "12.0"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_server"
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
            "location": "westus",
            "name": "acceptanceTestResourceGroup1",
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule1",
          "mode": "managed",
          "name": "invalidrule1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule",
          "values": {
            "end_ip_address": "10.0.17.62",
            "name": "invalidrule1",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "0.0.0.0",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule2",
          "mode": "managed",
          "name": "invalidrule2",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule",
          "values": {
            "end_ip_address": "0.0.0.0",
            "name": "invalidrule2",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "0.0.0.0",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule3",
          "mode": "managed",
          "name": "invalidrule3",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule",
          "values": {
            "end_ip_address": "255.255.255.255",
            "name": "invalidrule3",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "0.0.0.0",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule4",
          "mode": "managed",
          "name": "invalidrule4",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule",
          "values": {
            "end_ip_address": "255.255.255.255",
            "name": "invalidrule4",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "10.0.17.62",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.validrule1",
          "mode": "managed",
          "name": "validrule1",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_firewall_rule",
          "values": {
            "end_ip_address": "10.0.17.62",
            "name": "validrule1",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "10.0.17.62",
            "timeouts": null
          }
        },
        {
          "address": "azurerm_sql_server.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/azurerm",
          "schema_version": 0,
          "type": "azurerm_sql_server",
          "values": {
            "administrator_login": "4dm1n157r470r",
            "administrator_login_password": "4-v3ry-53cr37-p455w0rd",
            "connection_policy": "Default",
            "identity": [],
            "location": "westus",
            "name": "mysqlserver",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "tags": null,
            "timeouts": null,
            "version": "12.0"
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
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "end_ip_address": "10.0.17.62",
          "name": "invalidrule1",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "0.0.0.0",
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_sql_firewall_rule"
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "end_ip_address": "0.0.0.0",
          "name": "invalidrule2",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "0.0.0.0",
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule2",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_sql_firewall_rule"
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule3",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "end_ip_address": "255.255.255.255",
          "name": "invalidrule3",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "0.0.0.0",
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule3",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_sql_firewall_rule"
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule4",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "end_ip_address": "255.255.255.255",
          "name": "invalidrule4",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "10.0.17.62",
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalidrule4",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_sql_firewall_rule"
    },
    {
      "address": "azurerm_sql_firewall_rule.validrule1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "end_ip_address": "10.0.17.62",
          "name": "validrule1",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "10.0.17.62",
          "timeouts": null
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "validrule1",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_sql_firewall_rule"
    },
    {
      "address": "azurerm_sql_server.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "administrator_login": "4dm1n157r470r",
          "administrator_login_password": "4-v3ry-53cr37-p455w0rd",
          "connection_policy": "Default",
          "identity": [],
          "location": "westus",
          "name": "mysqlserver",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "tags": null,
          "timeouts": null,
          "version": "12.0"
        },
        "after_unknown": {
          "extended_auditing_policy": true,
          "fully_qualified_domain_name": true,
          "id": true,
          "identity": []
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/azurerm",
      "type": "azurerm_sql_server"
    }
  ],
  "terraform_version": "0.13.5"
}

