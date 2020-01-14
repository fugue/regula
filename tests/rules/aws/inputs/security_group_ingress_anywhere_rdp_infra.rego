# This package was automatically generated from:
#
#     tests/rules/aws/inputs/security_group_ingress_anywhere_rdp_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.security_group_ingress_anywhere_rdp
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_security_group.invalid_sg_1",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "invalid_sg_1",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "description": "Managed by Terraform",
            "ingress": [
              {
                "cidr_blocks": [
                  "0.0.0.0/0"
                ],
                "description": "",
                "from_port": 3389,
                "ipv6_cidr_blocks": [],
                "prefix_list_ids": [],
                "protocol": "tcp",
                "security_groups": [],
                "self": false,
                "to_port": 3389
              }
            ],
            "name": "invalid_sg_1",
            "name_prefix": null,
            "revoke_rules_on_delete": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_security_group.invalid_sg_2",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "invalid_sg_2",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "description": "Managed by Terraform",
            "ingress": [
              {
                "cidr_blocks": [
                  "0.0.0.0/0"
                ],
                "description": "",
                "from_port": 3380,
                "ipv6_cidr_blocks": [],
                "prefix_list_ids": [],
                "protocol": "tcp",
                "security_groups": [],
                "self": false,
                "to_port": 3390
              }
            ],
            "name": "invalid_sg_2",
            "name_prefix": null,
            "revoke_rules_on_delete": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_security_group.valid_sg_1",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "valid_sg_1",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "description": "Managed by Terraform",
            "ingress": [
              {
                "cidr_blocks": [
                  "0.0.0.0/0"
                ],
                "description": "",
                "from_port": 22,
                "ipv6_cidr_blocks": [],
                "prefix_list_ids": [],
                "protocol": "tcp",
                "security_groups": [],
                "self": false,
                "to_port": 22
              }
            ],
            "name": "valid_sg_1",
            "name_prefix": null,
            "revoke_rules_on_delete": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_security_group.valid_sg_2",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "valid_sg_2",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "description": "Managed by Terraform",
            "ingress": [
              {
                "cidr_blocks": [
                  "10.10.0.0/16"
                ],
                "description": "",
                "from_port": 3389,
                "ipv6_cidr_blocks": [],
                "prefix_list_ids": [],
                "protocol": "tcp",
                "security_groups": [],
                "self": false,
                "to_port": 3389
              }
            ],
            "name": "valid_sg_2",
            "name_prefix": null,
            "revoke_rules_on_delete": false,
            "tags": null,
            "timeouts": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_security_group.invalid_sg_1",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "invalid_sg_1",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "ingress": [
            {
              "cidr_blocks": [
                "0.0.0.0/0"
              ],
              "description": "",
              "from_port": 3389,
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "protocol": "tcp",
              "security_groups": [],
              "self": false,
              "to_port": 3389
            }
          ],
          "name": "invalid_sg_1",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": [
            {
              "cidr_blocks": [
                false
              ],
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "security_groups": []
            }
          ],
          "owner_id": true,
          "vpc_id": true
        }
      }
    },
    {
      "address": "aws_security_group.invalid_sg_2",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "invalid_sg_2",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "ingress": [
            {
              "cidr_blocks": [
                "0.0.0.0/0"
              ],
              "description": "",
              "from_port": 3380,
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "protocol": "tcp",
              "security_groups": [],
              "self": false,
              "to_port": 3390
            }
          ],
          "name": "invalid_sg_2",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": [
            {
              "cidr_blocks": [
                false
              ],
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "security_groups": []
            }
          ],
          "owner_id": true,
          "vpc_id": true
        }
      }
    },
    {
      "address": "aws_security_group.valid_sg_1",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "valid_sg_1",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "ingress": [
            {
              "cidr_blocks": [
                "0.0.0.0/0"
              ],
              "description": "",
              "from_port": 22,
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "protocol": "tcp",
              "security_groups": [],
              "self": false,
              "to_port": 22
            }
          ],
          "name": "valid_sg_1",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": [
            {
              "cidr_blocks": [
                false
              ],
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "security_groups": []
            }
          ],
          "owner_id": true,
          "vpc_id": true
        }
      }
    },
    {
      "address": "aws_security_group.valid_sg_2",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "valid_sg_2",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "ingress": [
            {
              "cidr_blocks": [
                "10.10.0.0/16"
              ],
              "description": "",
              "from_port": 3389,
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "protocol": "tcp",
              "security_groups": [],
              "self": false,
              "to_port": 3389
            }
          ],
          "name": "valid_sg_2",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": [
            {
              "cidr_blocks": [
                false
              ],
              "ipv6_cidr_blocks": [],
              "prefix_list_ids": [],
              "security_groups": []
            }
          ],
          "owner_id": true,
          "vpc_id": true
        }
      }
    }
  ],
  "configuration": {
    "provider_config": {
      "aws": {
        "name": "aws",
        "expressions": {
          "region": {
            "constant_value": "us-east-1"
          }
        }
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_security_group.invalid_sg_1",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "invalid_sg_1",
          "provider_config_key": "aws",
          "expressions": {
            "name": {
              "constant_value": "invalid_sg_1"
            }
          },
          "schema_version": 1
        },
        {
          "address": "aws_security_group.invalid_sg_2",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "invalid_sg_2",
          "provider_config_key": "aws",
          "expressions": {
            "name": {
              "constant_value": "invalid_sg_2"
            }
          },
          "schema_version": 1
        },
        {
          "address": "aws_security_group.valid_sg_1",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "valid_sg_1",
          "provider_config_key": "aws",
          "expressions": {
            "name": {
              "constant_value": "valid_sg_1"
            }
          },
          "schema_version": 1
        },
        {
          "address": "aws_security_group.valid_sg_2",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "valid_sg_2",
          "provider_config_key": "aws",
          "expressions": {
            "name": {
              "constant_value": "valid_sg_2"
            }
          },
          "schema_version": 1
        }
      ]
    }
  }
}
