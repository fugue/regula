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

# This provides a fairly complex test of the resources view, based on this
# Terraform configuration:
# <https://github.com/jaspervdj-luminal/example-terraform-modules>.
package fugue.resource_view_modules

import data.fugue.resource_view

test_mock_resource_view {
  expected_resource_view == mock_resource_view
}

mock_resource_view = ret {
  ret = resource_view.resource_view with input as mock_plan_input
}

mock_plan_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "variables": {
    "cidr": {
      "value": "10.0.0.0/16"
    }
  },
  "planned_values": {
    "outputs": {
      "parent_vpc": {
        "sensitive": false
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_security_group.parent",
          "mode": "managed",
          "type": "aws_security_group",
          "name": "parent",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "description": "Managed by Terraform",
            "name_prefix": null,
            "revoke_rules_on_delete": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_vpc.parent",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "parent",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": null
          }
        }
      ],
      "child_modules": [
        {
          "resources": [
            {
              "address": "module.child1.aws_vpc.child",
              "mode": "managed",
              "type": "aws_vpc",
              "name": "child",
              "provider_name": "aws",
              "schema_version": 1,
              "values": {
                "assign_generated_ipv6_cidr_block": false,
                "cidr_block": "10.0.0.0/16",
                "enable_dns_support": true,
                "instance_tenancy": "default",
                "tags": null
              }
            }
          ],
          "address": "module.child1",
          "child_modules": [
            {
              "resources": [
                {
                  "address": "module.child1.module.grandchild1.aws_security_group.grandchild",
                  "mode": "managed",
                  "type": "aws_security_group",
                  "name": "grandchild",
                  "provider_name": "aws",
                  "schema_version": 1,
                  "values": {
                    "description": "Managed by Terraform",
                    "name_prefix": null,
                    "revoke_rules_on_delete": false,
                    "tags": null,
                    "timeouts": null
                  }
                },
                {
                  "address": "module.child1.module.grandchild1.aws_vpc.grandchild",
                  "mode": "managed",
                  "type": "aws_vpc",
                  "name": "grandchild",
                  "provider_name": "aws",
                  "schema_version": 1,
                  "values": {
                    "assign_generated_ipv6_cidr_block": false,
                    "cidr_block": "10.0.0.0/16",
                    "enable_dns_support": true,
                    "instance_tenancy": "default",
                    "tags": null
                  }
                }
              ],
              "address": "module.child1.module.grandchild1"
            }
          ]
        },
        {
          "resources": [
            {
              "address": "module.child2.aws_security_group.child",
              "mode": "managed",
              "type": "aws_security_group",
              "name": "child",
              "provider_name": "aws",
              "schema_version": 1,
              "values": {
                "description": "Managed by Terraform",
                "name_prefix": null,
                "revoke_rules_on_delete": false,
                "tags": null,
                "timeouts": null
              }
            },
            {
              "address": "module.child2.aws_vpc.child",
              "mode": "managed",
              "type": "aws_vpc",
              "name": "child",
              "provider_name": "aws",
              "schema_version": 1,
              "values": {
                "assign_generated_ipv6_cidr_block": false,
                "cidr_block": "10.0.0.0/16",
                "enable_dns_support": true,
                "instance_tenancy": "default",
                "tags": null
              }
            }
          ],
          "address": "module.child2"
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_security_group.parent",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "parent",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": true,
          "name": true,
          "owner_id": true,
          "vpc_id": true
        }
      }
    },
    {
      "address": "aws_vpc.parent",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "parent",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
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
          "owner_id": true
        }
      }
    },
    {
      "address": "module.child1.aws_vpc.child",
      "module_address": "module.child1",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "child",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
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
          "owner_id": true
        }
      }
    },
    {
      "address": "module.child1.module.grandchild1.aws_security_group.grandchild",
      "module_address": "module.child1.module.grandchild1",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "grandchild",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": true,
          "name": true,
          "owner_id": true,
          "vpc_id": true
        }
      }
    },
    {
      "address": "module.child1.module.grandchild1.aws_vpc.grandchild",
      "module_address": "module.child1.module.grandchild1",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "grandchild",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
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
          "owner_id": true
        }
      }
    },
    {
      "address": "module.child2.aws_security_group.child",
      "module_address": "module.child2",
      "mode": "managed",
      "type": "aws_security_group",
      "name": "child",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": "Managed by Terraform",
          "name_prefix": null,
          "revoke_rules_on_delete": false,
          "tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "arn": true,
          "egress": true,
          "id": true,
          "ingress": true,
          "name": true,
          "owner_id": true,
          "vpc_id": true
        }
      }
    },
    {
      "address": "module.child2.aws_vpc.child",
      "module_address": "module.child2",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "child",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
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
          "owner_id": true
        }
      }
    }
  ],
  "output_changes": {
    "parent_vpc": {
      "actions": [
        "create"
      ],
      "before": null,
      "after_unknown": true
    }
  },
  "configuration": {
    "provider_config": {
      "aws": {
        "name": "aws",
        "expressions": {
          "region": {
            "constant_value": "us-east-2"
          }
        }
      }
    },
    "root_module": {
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
          "mode": "managed",
          "type": "aws_security_group",
          "name": "parent",
          "provider_config_key": "aws",
          "expressions": {
            "vpc_id": {
              "references": [
                "module.child1.grandchild_vpc"
              ]
            }
          },
          "schema_version": 1
        },
        {
          "address": "aws_vpc.parent",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "parent",
          "provider_config_key": "aws",
          "expressions": {
            "cidr_block": {
              "references": [
                "var.cidr"
              ]
            }
          },
          "schema_version": 1
        }
      ],
      "module_calls": {
        "child1": {
          "source": "./child1",
          "module": {
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
                "mode": "managed",
                "type": "aws_vpc",
                "name": "child",
                "provider_config_key": "child1:aws",
                "expressions": {
                  "cidr_block": {
                    "constant_value": "10.0.0.0/16"
                  }
                },
                "schema_version": 1
              }
            ],
            "module_calls": {
              "grandchild1": {
                "source": "./grandchild1",
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
                      "mode": "managed",
                      "type": "aws_security_group",
                      "name": "grandchild",
                      "provider_config_key": "grandchild1:aws",
                      "expressions": {
                        "vpc_id": {
                          "references": [
                            "aws_vpc.grandchild"
                          ]
                        }
                      },
                      "schema_version": 1
                    },
                    {
                      "address": "aws_vpc.grandchild",
                      "mode": "managed",
                      "type": "aws_vpc",
                      "name": "grandchild",
                      "provider_config_key": "grandchild1:aws",
                      "expressions": {
                        "cidr_block": {
                          "constant_value": "10.0.0.0/16"
                        }
                      },
                      "schema_version": 1
                    }
                  ]
                }
              }
            }
          }
        },
        "child2": {
          "source": "./child2",
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
                "mode": "managed",
                "type": "aws_security_group",
                "name": "child",
                "provider_config_key": "child2:aws",
                "expressions": {
                  "vpc_id": {
                    "references": [
                      "var.child_vpc_id"
                    ]
                  }
                },
                "schema_version": 1
              },
              {
                "address": "aws_vpc.child",
                "mode": "managed",
                "type": "aws_vpc",
                "name": "child",
                "provider_config_key": "child2:aws",
                "expressions": {
                  "cidr_block": {
                    "constant_value": "10.0.0.0/16"
                  }
                },
                "schema_version": 1
              }
            ],
            "variables": {
              "child_vpc_id": {}
            }
          }
        }
      },
      "variables": {
        "cidr": {
          "default": "10.0.0.0/16"
        }
      }
    }
  }
}

expected_resource_view = {
  "aws_vpc.parent": {
    "id": "aws_vpc.parent",
    "tags": null,
    "assign_generated_ipv6_cidr_block": false,
    "cidr_block": "10.0.0.0/16",
    "instance_tenancy": "default",
    "enable_dns_support": true,
    "_type": "aws_vpc"
  },
  "module.child1.module.grandchild1.aws_vpc.grandchild": {
    "id": "module.child1.module.grandchild1.aws_vpc.grandchild",
    "tags": null,
    "assign_generated_ipv6_cidr_block": false,
    "cidr_block": "10.0.0.0/16",
    "instance_tenancy": "default",
    "enable_dns_support": true,
    "_type": "aws_vpc"
  },
  "module.child2.aws_vpc.child": {
    "id": "module.child2.aws_vpc.child",
    "tags": null,
    "assign_generated_ipv6_cidr_block": false,
    "cidr_block": "10.0.0.0/16",
    "instance_tenancy": "default",
    "enable_dns_support": true,
    "_type": "aws_vpc"
  },
  "module.child2.aws_security_group.child": {
    "id": "module.child2.aws_security_group.child",
    "description": "Managed by Terraform",
    "tags": null,
    "revoke_rules_on_delete": false,
    "vpc_id": "module.child1.module.grandchild1.aws_vpc.grandchild",
    "timeouts": null,
    "_type": "aws_security_group",
    "name_prefix": null
  },
  "aws_security_group.parent": {
    "id": "aws_security_group.parent",
    "description": "Managed by Terraform",
    "tags": null,
    "revoke_rules_on_delete": false,
    "vpc_id": "module.child1.module.grandchild1.aws_vpc.grandchild",
    "timeouts": null,
    "_type": "aws_security_group",
    "name_prefix": null
  },
  "module.child1.aws_vpc.child": {
    "id": "module.child1.aws_vpc.child",
    "tags": null,
    "assign_generated_ipv6_cidr_block": false,
    "cidr_block": "10.0.0.0/16",
    "instance_tenancy": "default",
    "enable_dns_support": true,
    "_type": "aws_vpc"
  },
  "module.child1.module.grandchild1.aws_security_group.grandchild": {
    "id": "module.child1.module.grandchild1.aws_security_group.grandchild",
    "description": "Managed by Terraform",
    "tags": null,
    "revoke_rules_on_delete": false,
    "vpc_id": "module.child1.module.grandchild1.aws_vpc.grandchild",
    "timeouts": null,
    "_type": "aws_security_group",
    "name_prefix": null
  }
}
