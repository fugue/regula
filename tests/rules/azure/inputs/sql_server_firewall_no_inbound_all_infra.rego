# This package was automatically generated from:
#
#     tests/rules/azure/inputs/sql_server_firewall_no_inbound_all_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.sql_server_firewall_no_inbound_all
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
            "location": "westus",
            "name": "acceptanceTestResourceGroup1"
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule1",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule1",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "end_ip_address": "10.0.17.62",
            "name": "invalidrule1",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "0.0.0.0"
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule2",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule2",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "end_ip_address": "0.0.0.0",
            "name": "invalidrule2",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "0.0.0.0"
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule3",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule3",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "end_ip_address": "255.255.255.255",
            "name": "invalidrule3",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "0.0.0.0"
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule4",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule4",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "end_ip_address": "255.255.255.255",
            "name": "invalidrule4",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "10.0.17.62"
          }
        },
        {
          "address": "azurerm_sql_firewall_rule.validrule1",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "validrule1",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "end_ip_address": "10.0.17.62",
            "name": "validrule1",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "server_name": "mysqlserver",
            "start_ip_address": "10.0.17.62"
          }
        },
        {
          "address": "azurerm_sql_server.example",
          "mode": "managed",
          "type": "azurerm_sql_server",
          "name": "example",
          "provider_name": "azurerm",
          "schema_version": 0,
          "values": {
            "administrator_login": "4dm1n157r470r",
            "administrator_login_password": "4-v3ry-53cr37-p455w0rd",
            "identity": [],
            "location": "westus",
            "name": "mysqlserver",
            "resource_group_name": "acceptanceTestResourceGroup1",
            "version": "12.0"
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
          "location": "westus",
          "name": "acceptanceTestResourceGroup1"
        },
        "after_unknown": {
          "id": true,
          "tags": true
        }
      }
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule1",
      "mode": "managed",
      "type": "azurerm_sql_firewall_rule",
      "name": "invalidrule1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "end_ip_address": "10.0.17.62",
          "name": "invalidrule1",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "0.0.0.0"
        },
        "after_unknown": {
          "id": true
        }
      }
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule2",
      "mode": "managed",
      "type": "azurerm_sql_firewall_rule",
      "name": "invalidrule2",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "end_ip_address": "0.0.0.0",
          "name": "invalidrule2",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "0.0.0.0"
        },
        "after_unknown": {
          "id": true
        }
      }
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule3",
      "mode": "managed",
      "type": "azurerm_sql_firewall_rule",
      "name": "invalidrule3",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "end_ip_address": "255.255.255.255",
          "name": "invalidrule3",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "0.0.0.0"
        },
        "after_unknown": {
          "id": true
        }
      }
    },
    {
      "address": "azurerm_sql_firewall_rule.invalidrule4",
      "mode": "managed",
      "type": "azurerm_sql_firewall_rule",
      "name": "invalidrule4",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "end_ip_address": "255.255.255.255",
          "name": "invalidrule4",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "10.0.17.62"
        },
        "after_unknown": {
          "id": true
        }
      }
    },
    {
      "address": "azurerm_sql_firewall_rule.validrule1",
      "mode": "managed",
      "type": "azurerm_sql_firewall_rule",
      "name": "validrule1",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "end_ip_address": "10.0.17.62",
          "name": "validrule1",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "server_name": "mysqlserver",
          "start_ip_address": "10.0.17.62"
        },
        "after_unknown": {
          "id": true
        }
      }
    },
    {
      "address": "azurerm_sql_server.example",
      "mode": "managed",
      "type": "azurerm_sql_server",
      "name": "example",
      "provider_name": "azurerm",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "administrator_login": "4dm1n157r470r",
          "administrator_login_password": "4-v3ry-53cr37-p455w0rd",
          "identity": [],
          "location": "westus",
          "name": "mysqlserver",
          "resource_group_name": "acceptanceTestResourceGroup1",
          "version": "12.0"
        },
        "after_unknown": {
          "fully_qualified_domain_name": true,
          "id": true,
          "identity": [],
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
              "constant_value": "West US"
            },
            "name": {
              "constant_value": "acceptanceTestResourceGroup1"
            }
          },
          "schema_version": 0
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule1",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule1",
          "provider_config_key": "azurerm",
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
          "schema_version": 0
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule2",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule2",
          "provider_config_key": "azurerm",
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
          "schema_version": 0
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule3",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule3",
          "provider_config_key": "azurerm",
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
          "schema_version": 0
        },
        {
          "address": "azurerm_sql_firewall_rule.invalidrule4",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "invalidrule4",
          "provider_config_key": "azurerm",
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
          "schema_version": 0
        },
        {
          "address": "azurerm_sql_firewall_rule.validrule1",
          "mode": "managed",
          "type": "azurerm_sql_firewall_rule",
          "name": "validrule1",
          "provider_config_key": "azurerm",
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
          "schema_version": 0
        },
        {
          "address": "azurerm_sql_server.example",
          "mode": "managed",
          "type": "azurerm_sql_server",
          "name": "example",
          "provider_config_key": "azurerm",
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
          "schema_version": 0
        }
      ]
    }
  }
}
