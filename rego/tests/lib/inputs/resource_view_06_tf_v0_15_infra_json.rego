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
package tests.lib.inputs.resource_view_06_tf_v0_15_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "configuration": {
    "provider_config": {
      "aws": {
        "expressions": {
          "region": {
            "constant_value": "us-east-2"
          }
        },
        "name": "aws"
      }
    },
    "root_module": {
      "module_calls": {
        "child1": {
          "module": {
            "module_calls": {
              "grandchild1": {
                "module": {
                  "outputs": {
                    "grandchild_vpc": {
                      "expression": {
                        "references": [
                          "aws_vpc.grandchild"
                        ]
                      }
                    }
                  },
                  "resources": [
                    {
                      "address": "aws_security_group.grandchild",
                      "expressions": {
                        "vpc_id": {
                          "references": [
                            "aws_vpc.grandchild"
                          ]
                        }
                      },
                      "mode": "managed",
                      "name": "grandchild",
                      "provider_config_key": "grandchild1:aws",
                      "schema_version": 1,
                      "type": "aws_security_group"
                    },
                    {
                      "address": "aws_vpc.grandchild",
                      "expressions": {
                        "cidr_block": {
                          "constant_value": "10.0.0.0/16"
                        }
                      },
                      "mode": "managed",
                      "name": "grandchild",
                      "provider_config_key": "grandchild1:aws",
                      "schema_version": 1,
                      "type": "aws_vpc"
                    }
                  ]
                },
                "source": "./grandchild1"
              }
            },
            "outputs": {
              "grandchild_vpc": {
                "expression": {
                  "references": [
                    "module.grandchild1.grandchild_vpc"
                  ]
                }
              }
            },
            "resources": [
              {
                "address": "aws_vpc.child",
                "expressions": {
                  "cidr_block": {
                    "constant_value": "10.0.0.0/16"
                  }
                },
                "mode": "managed",
                "name": "child",
                "provider_config_key": "child1:aws",
                "schema_version": 1,
                "type": "aws_vpc"
              }
            ]
          },
          "source": "./child1"
        },
        "child2": {
          "expressions": {
            "child_vpc_id": {
              "references": [
                "module.child1.grandchild_vpc"
              ]
            }
          },
          "module": {
            "resources": [
              {
                "address": "aws_security_group.child",
                "expressions": {
                  "vpc_id": {
                    "references": [
                      "var.child_vpc_id"
                    ]
                  }
                },
                "mode": "managed",
                "name": "child",
                "provider_config_key": "child2:aws",
                "schema_version": 1,
                "type": "aws_security_group"
              },
              {
                "address": "aws_vpc.child",
                "expressions": {
                  "cidr_block": {
                    "constant_value": "10.0.0.0/16"
                  }
                },
                "mode": "managed",
                "name": "child",
                "provider_config_key": "child2:aws",
                "schema_version": 1,
                "type": "aws_vpc"
              }
            ],
            "variables": {
              "child_vpc_id": {}
            }
          },
          "source": "./child2"
        }
      },
      "outputs": {
        "parent_vpc": {
          "expression": {
            "references": [
              "aws_vpc.parent"
            ]
          }
        }
      },
      "resources": [
        {
          "address": "aws_security_group.parent",
          "expressions": {
            "vpc_id": {
              "references": [
                "module.child1.grandchild_vpc"
              ]
            }
          },
          "mode": "managed",
          "name": "parent",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_security_group"
        },
        {
          "address": "aws_vpc.parent",
          "expressions": {
            "cidr_block": {
              "constant_value": "10.0.0.0/16"
            }
          },
          "mode": "managed",
          "name": "parent",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_vpc"
        }
      ]
    }
  },
  "format_version": "0.1",
  "output_changes": {
    "parent_vpc": {
      "actions": [
        "create"
      ],
      "after_sensitive": false,
      "after_unknown": true,
      "before": null,
      "before_sensitive": false
    }
  },
  "planned_values": {
    "outputs": {
      "parent_vpc": {
        "sensitive": false
      }
    },
    "root_module": {
      "child_modules": [
        {
          "address": "module.child1",
          "child_modules": [
            {
              "address": "module.child1.module.grandchild1",
              "resources": [
                {
                  "address": "module.child1.module.grandchild1.aws_security_group.grandchild",
                  "mode": "managed",
                  "name": "grandchild",
                  "provider_name": "registry.terraform.io/hashicorp/aws",
                  "schema_version": 1,
                  "type": "aws_security_group",
                  "values": {
                    "description": "Managed by Terraform",
                    "revoke_rules_on_delete": false,
                    "tags": null,
                    "timeouts": null
                  }
                },
                {
                  "address": "module.child1.module.grandchild1.aws_vpc.grandchild",
                  "mode": "managed",
                  "name": "grandchild",
                  "provider_name": "registry.terraform.io/hashicorp/aws",
                  "schema_version": 1,
                  "type": "aws_vpc",
                  "values": {
                    "assign_generated_ipv6_cidr_block": false,
                    "cidr_block": "10.0.0.0/16",
                    "enable_dns_support": true,
                    "instance_tenancy": "default",
                    "tags": null
                  }
                }
              ]
            }
          ],
          "resources": [
            {
              "address": "module.child1.aws_vpc.child",
              "mode": "managed",
              "name": "child",
              "provider_name": "registry.terraform.io/hashicorp/aws",
              "schema_version": 1,
              "type": "aws_vpc",
              "values": {
                "assign_generated_ipv6_cidr_block": false,
                "cidr_block": "10.0.0.0/16",
                "enable_dns_support": true,
                "instance_tenancy": "default",
                "tags": null
              }
            }
          ]
        },
        {
          "address": "module.child2",
          "resources": [
            {
              "address": "module.child2.aws_security_group.child",
              "mode": "managed",
              "name": "child",
              "provider_name": "registry.terraform.io/hashicorp/aws",
              "schema_version": 1,
              "type": "aws_security_group",
              "values": {
                "description": "Managed by Terraform",
                "revoke_rules_on_delete": false,
                "tags": null,
                "timeouts": null
              }
            },
            {
              "address": "module.child2.aws_vpc.child",
              "mode": "managed",
              "name": "child",
              "provider_name": "registry.terraform.io/hashicorp/aws",
              "schema_version": 1,
              "type": "aws_vpc",
              "values": {
                "assign_generated_ipv6_cidr_block": false,
                "cidr_block": "10.0.0.0/16",
                "enable_dns_support": true,
                "instance_tenancy": "default",
                "tags": null
              }
            }
          ]
        }
      ],
      "resources": [
        {
          "address": "aws_security_group.parent",
          "mode": "managed",
          "name": "parent",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_security_group",
          "values": {
            "description": "Managed by Terraform",
            "revoke_rules_on_delete": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_vpc.parent",
          "mode": "managed",
          "name": "parent",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_vpc",
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_security_group.parent",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Managed by Terraform",
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_sensitive": {
          "egress": [],
          "ingress": [],
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": true,
          "name": true,
          "name_prefix": true,
          "owner_id": true,
          "tags_all": true,
          "vpc_id": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "parent",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_security_group"
    },
    {
      "address": "aws_vpc.parent",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
        },
        "after_sensitive": {
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true,
          "tags_all": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "parent",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_vpc"
    },
    {
      "address": "module.child1.aws_vpc.child",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
        },
        "after_sensitive": {
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true,
          "tags_all": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "module_address": "module.child1",
      "name": "child",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_vpc"
    },
    {
      "address": "module.child1.module.grandchild1.aws_security_group.grandchild",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Managed by Terraform",
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_sensitive": {
          "egress": [],
          "ingress": [],
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": true,
          "name": true,
          "name_prefix": true,
          "owner_id": true,
          "tags_all": true,
          "vpc_id": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "module_address": "module.child1.module.grandchild1",
      "name": "grandchild",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_security_group"
    },
    {
      "address": "module.child1.module.grandchild1.aws_vpc.grandchild",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
        },
        "after_sensitive": {
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true,
          "tags_all": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "module_address": "module.child1.module.grandchild1",
      "name": "grandchild",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_vpc"
    },
    {
      "address": "module.child2.aws_security_group.child",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Managed by Terraform",
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_sensitive": {
          "egress": [],
          "ingress": [],
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": true,
          "name": true,
          "name_prefix": true,
          "owner_id": true,
          "tags_all": true,
          "vpc_id": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "module_address": "module.child2",
      "name": "child",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_security_group"
    },
    {
      "address": "module.child2.aws_vpc.child",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
        },
        "after_sensitive": {
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true,
          "tags_all": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "module_address": "module.child2",
      "name": "child",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_vpc"
    }
  ],
  "terraform_version": "0.15.3"
}

