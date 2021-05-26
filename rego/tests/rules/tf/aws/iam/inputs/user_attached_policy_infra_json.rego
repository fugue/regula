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
package tests.rules.tf.aws.iam.inputs.user_attached_policy_infra_json

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
            "constant_value": "us-west-2"
          }
        },
        "name": "aws"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_iam_group.valid_group_blank_users",
          "expressions": {
            "name": {
              "constant_value": "valid_group_blank_users"
            }
          },
          "mode": "managed",
          "name": "valid_group_blank_users",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group"
        },
        {
          "address": "aws_iam_group.valid_group_empty_list_users",
          "expressions": {
            "name": {
              "constant_value": "valid_group_empty_list_users"
            }
          },
          "mode": "managed",
          "name": "valid_group_empty_list_users",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group"
        },
        {
          "address": "aws_iam_group.valid_group_missing_users",
          "expressions": {
            "name": {
              "constant_value": "valid_group_missing_users"
            }
          },
          "mode": "managed",
          "name": "valid_group_missing_users",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group"
        },
        {
          "address": "aws_iam_group_membership.valid_group_blank_users_membership",
          "expressions": {
            "group": {
              "references": [
                "aws_iam_group.valid_group_blank_users"
              ]
            },
            "name": {
              "constant_value": "valid_group_blank_users_membership"
            },
            "users": {
              "references": [
                "aws_iam_user.valid_group_blank_user"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_group_blank_users_membership",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group_membership"
        },
        {
          "address": "aws_iam_group_membership.valid_group_empty_list_users_membership",
          "expressions": {
            "group": {
              "references": [
                "aws_iam_group.valid_group_empty_list_users"
              ]
            },
            "name": {
              "constant_value": "valid_group_empty_list_users_membership"
            },
            "users": {
              "references": [
                "aws_iam_user.valid_group_empty_list_user"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_group_empty_list_users_membership",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group_membership"
        },
        {
          "address": "aws_iam_group_membership.valid_group_missing_users_membership",
          "expressions": {
            "group": {
              "references": [
                "aws_iam_group.valid_group_missing_users"
              ]
            },
            "name": {
              "constant_value": "valid_group_missing_users_membership"
            },
            "users": {
              "references": [
                "aws_iam_user.valid_group_missing_user"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_group_missing_users_membership",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group_membership"
        },
        {
          "address": "aws_iam_policy.invalid_normal_policy",
          "expressions": {
            "description": {
              "constant_value": "Invalid normal policy attached to user"
            },
            "name": {
              "constant_value": "invalid_normal_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "invalid_normal_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy.invalid_user_policy_attachment_policy",
          "expressions": {
            "description": {
              "constant_value": "Invalid user policy attachment policy"
            },
            "name": {
              "constant_value": "invalid_user_policy_attachment_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "invalid_user_policy_attachment_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy.valid_group_blank_users_policy",
          "expressions": {
            "description": {
              "constant_value": "Valid group blank users policy"
            },
            "name": {
              "constant_value": "valid_group_blank_users_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "valid_group_blank_users_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy.valid_group_empty_list_users_policy",
          "expressions": {
            "description": {
              "constant_value": "Valid group empty list users policy"
            },
            "name": {
              "constant_value": "valid_group_empty_list_users_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "valid_group_empty_list_users_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy.valid_group_missing_users_policy",
          "expressions": {
            "description": {
              "constant_value": "Valid group missing users policy"
            },
            "name": {
              "constant_value": "valid_group_missing_users_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "valid_group_missing_users_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy.valid_role_policy",
          "expressions": {
            "description": {
              "constant_value": "Valid role policy"
            },
            "name": {
              "constant_value": "valid_role_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "valid_role_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy_attachment.invalid_normal_policy_attachment",
          "expressions": {
            "name": {
              "constant_value": "invalid_normal_policy_attachment"
            },
            "policy_arn": {
              "references": [
                "aws_iam_policy.invalid_normal_policy"
              ]
            },
            "users": {
              "references": [
                "aws_iam_user.invalid_normal_policy_user"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid_normal_policy_attachment",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment"
        },
        {
          "address": "aws_iam_policy_attachment.valid_group_policy_attachment_blank_users",
          "expressions": {
            "groups": {
              "references": [
                "aws_iam_group.valid_group_blank_users"
              ]
            },
            "name": {
              "constant_value": "valid_group_policy_attachment_blank_users"
            },
            "policy_arn": {
              "references": [
                "aws_iam_policy.valid_group_blank_users_policy"
              ]
            },
            "users": {
              "constant_value": [
                ""
              ]
            }
          },
          "mode": "managed",
          "name": "valid_group_policy_attachment_blank_users",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment"
        },
        {
          "address": "aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users",
          "expressions": {
            "groups": {
              "references": [
                "aws_iam_group.valid_group_empty_list_users"
              ]
            },
            "name": {
              "constant_value": "valid_group_policy_attachment_empty_list_users"
            },
            "policy_arn": {
              "references": [
                "aws_iam_policy.valid_group_empty_list_users_policy"
              ]
            },
            "users": {
              "constant_value": []
            }
          },
          "mode": "managed",
          "name": "valid_group_policy_attachment_empty_list_users",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment"
        },
        {
          "address": "aws_iam_policy_attachment.valid_group_policy_attachment_missing_users",
          "expressions": {
            "groups": {
              "references": [
                "aws_iam_group.valid_group_missing_users"
              ]
            },
            "name": {
              "constant_value": "valid_group_policy_attachment_missing_users"
            },
            "policy_arn": {
              "references": [
                "aws_iam_policy.valid_group_missing_users_policy"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_group_policy_attachment_missing_users",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment"
        },
        {
          "address": "aws_iam_policy_attachment.valid_role_policy_attachment",
          "expressions": {
            "name": {
              "constant_value": "valid_role_policy_attachment"
            },
            "policy_arn": {
              "references": [
                "aws_iam_policy.valid_role_policy"
              ]
            },
            "roles": {
              "references": [
                "aws_iam_role.valid_role"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_role_policy_attachment",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment"
        },
        {
          "address": "aws_iam_role.valid_role",
          "expressions": {
            "assume_role_policy": {
              "constant_value": "{\n\"Version\": \"2012-10-17\",\n\"Statement\": [\n  {\n    \"Action\": \"sts:AssumeRole\",\n    \"Principal\": {\n      \"Service\": \"ec2.amazonaws.com\"\n    },\n    \"Effect\": \"Allow\",\n    \"Sid\": \"\"\n  }\n ]\n}\n"
            },
            "name": {
              "constant_value": "valid_role"
            }
          },
          "mode": "managed",
          "name": "valid_role",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_role"
        },
        {
          "address": "aws_iam_user.invalid_normal_policy_user",
          "expressions": {
            "name": {
              "constant_value": "invalid_normal_policy_user"
            }
          },
          "mode": "managed",
          "name": "invalid_normal_policy_user",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user"
        },
        {
          "address": "aws_iam_user.invalid_user_policy_attachment_user",
          "expressions": {
            "name": {
              "constant_value": "invalid_user_policy_attachment_user"
            }
          },
          "mode": "managed",
          "name": "invalid_user_policy_attachment_user",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user"
        },
        {
          "address": "aws_iam_user.invalid_user_policy_user",
          "expressions": {
            "name": {
              "constant_value": "invalid_user_policy_user"
            }
          },
          "mode": "managed",
          "name": "invalid_user_policy_user",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user"
        },
        {
          "address": "aws_iam_user.valid_group_blank_user",
          "expressions": {
            "name": {
              "constant_value": "valid_group_blank_user"
            }
          },
          "mode": "managed",
          "name": "valid_group_blank_user",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user"
        },
        {
          "address": "aws_iam_user.valid_group_empty_list_user",
          "expressions": {
            "name": {
              "constant_value": "valid_group_empty_list_user"
            }
          },
          "mode": "managed",
          "name": "valid_group_empty_list_user",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user"
        },
        {
          "address": "aws_iam_user.valid_group_missing_user",
          "expressions": {
            "name": {
              "constant_value": "valid_group_missing_user"
            }
          },
          "mode": "managed",
          "name": "valid_group_missing_user",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user"
        },
        {
          "address": "aws_iam_user_policy.invalid_user_policy",
          "expressions": {
            "name": {
              "constant_value": "invalid_user_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "user": {
              "references": [
                "aws_iam_user.invalid_user_policy_user"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid_user_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user_policy"
        },
        {
          "address": "aws_iam_user_policy_attachment.invalid_user_policy_attachment",
          "expressions": {
            "policy_arn": {
              "references": [
                "aws_iam_policy.invalid_user_policy_attachment_policy"
              ]
            },
            "user": {
              "references": [
                "aws_iam_user.invalid_user_policy_attachment_user"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid_user_policy_attachment",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user_policy_attachment"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_iam_group.valid_group_blank_users",
          "mode": "managed",
          "name": "valid_group_blank_users",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group",
          "values": {
            "name": "valid_group_blank_users",
            "path": "/"
          }
        },
        {
          "address": "aws_iam_group.valid_group_empty_list_users",
          "mode": "managed",
          "name": "valid_group_empty_list_users",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group",
          "values": {
            "name": "valid_group_empty_list_users",
            "path": "/"
          }
        },
        {
          "address": "aws_iam_group.valid_group_missing_users",
          "mode": "managed",
          "name": "valid_group_missing_users",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group",
          "values": {
            "name": "valid_group_missing_users",
            "path": "/"
          }
        },
        {
          "address": "aws_iam_group_membership.valid_group_blank_users_membership",
          "mode": "managed",
          "name": "valid_group_blank_users_membership",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group_membership",
          "values": {
            "group": "valid_group_blank_users",
            "name": "valid_group_blank_users_membership",
            "users": [
              "valid_group_blank_user"
            ]
          }
        },
        {
          "address": "aws_iam_group_membership.valid_group_empty_list_users_membership",
          "mode": "managed",
          "name": "valid_group_empty_list_users_membership",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group_membership",
          "values": {
            "group": "valid_group_empty_list_users",
            "name": "valid_group_empty_list_users_membership",
            "users": [
              "valid_group_empty_list_user"
            ]
          }
        },
        {
          "address": "aws_iam_group_membership.valid_group_missing_users_membership",
          "mode": "managed",
          "name": "valid_group_missing_users_membership",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group_membership",
          "values": {
            "group": "valid_group_missing_users",
            "name": "valid_group_missing_users_membership",
            "users": [
              "valid_group_missing_user"
            ]
          }
        },
        {
          "address": "aws_iam_policy.invalid_normal_policy",
          "mode": "managed",
          "name": "invalid_normal_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Invalid normal policy attached to user",
            "name": "invalid_normal_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "tags": null
          }
        },
        {
          "address": "aws_iam_policy.invalid_user_policy_attachment_policy",
          "mode": "managed",
          "name": "invalid_user_policy_attachment_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Invalid user policy attachment policy",
            "name": "invalid_user_policy_attachment_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "tags": null
          }
        },
        {
          "address": "aws_iam_policy.valid_group_blank_users_policy",
          "mode": "managed",
          "name": "valid_group_blank_users_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Valid group blank users policy",
            "name": "valid_group_blank_users_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "tags": null
          }
        },
        {
          "address": "aws_iam_policy.valid_group_empty_list_users_policy",
          "mode": "managed",
          "name": "valid_group_empty_list_users_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Valid group empty list users policy",
            "name": "valid_group_empty_list_users_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "tags": null
          }
        },
        {
          "address": "aws_iam_policy.valid_group_missing_users_policy",
          "mode": "managed",
          "name": "valid_group_missing_users_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Valid group missing users policy",
            "name": "valid_group_missing_users_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "tags": null
          }
        },
        {
          "address": "aws_iam_policy.valid_role_policy",
          "mode": "managed",
          "name": "valid_role_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Valid role policy",
            "name": "valid_role_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "tags": null
          }
        },
        {
          "address": "aws_iam_policy_attachment.invalid_normal_policy_attachment",
          "mode": "managed",
          "name": "invalid_normal_policy_attachment",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment",
          "values": {
            "groups": null,
            "name": "invalid_normal_policy_attachment",
            "roles": null,
            "users": [
              "invalid_normal_policy_user"
            ]
          }
        },
        {
          "address": "aws_iam_policy_attachment.valid_group_policy_attachment_blank_users",
          "mode": "managed",
          "name": "valid_group_policy_attachment_blank_users",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment",
          "values": {
            "groups": [
              "valid_group_blank_users"
            ],
            "name": "valid_group_policy_attachment_blank_users",
            "roles": null,
            "users": [
              ""
            ]
          }
        },
        {
          "address": "aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users",
          "mode": "managed",
          "name": "valid_group_policy_attachment_empty_list_users",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment",
          "values": {
            "groups": [
              "valid_group_empty_list_users"
            ],
            "name": "valid_group_policy_attachment_empty_list_users",
            "roles": null,
            "users": null
          }
        },
        {
          "address": "aws_iam_policy_attachment.valid_group_policy_attachment_missing_users",
          "mode": "managed",
          "name": "valid_group_policy_attachment_missing_users",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment",
          "values": {
            "groups": [
              "valid_group_missing_users"
            ],
            "name": "valid_group_policy_attachment_missing_users",
            "roles": null,
            "users": null
          }
        },
        {
          "address": "aws_iam_policy_attachment.valid_role_policy_attachment",
          "mode": "managed",
          "name": "valid_role_policy_attachment",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy_attachment",
          "values": {
            "groups": null,
            "name": "valid_role_policy_attachment",
            "roles": [
              "valid_role"
            ],
            "users": null
          }
        },
        {
          "address": "aws_iam_role.valid_role",
          "mode": "managed",
          "name": "valid_role",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_role",
          "values": {
            "assume_role_policy": "{\n\"Version\": \"2012-10-17\",\n\"Statement\": [\n  {\n    \"Action\": \"sts:AssumeRole\",\n    \"Principal\": {\n      \"Service\": \"ec2.amazonaws.com\"\n    },\n    \"Effect\": \"Allow\",\n    \"Sid\": \"\"\n  }\n ]\n}\n",
            "description": null,
            "force_detach_policies": false,
            "max_session_duration": 3600,
            "name": "valid_role",
            "name_prefix": null,
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user.invalid_normal_policy_user",
          "mode": "managed",
          "name": "invalid_normal_policy_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "invalid_normal_policy_user",
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user.invalid_user_policy_attachment_user",
          "mode": "managed",
          "name": "invalid_user_policy_attachment_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "invalid_user_policy_attachment_user",
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user.invalid_user_policy_user",
          "mode": "managed",
          "name": "invalid_user_policy_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "invalid_user_policy_user",
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user.valid_group_blank_user",
          "mode": "managed",
          "name": "valid_group_blank_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "valid_group_blank_user",
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user.valid_group_empty_list_user",
          "mode": "managed",
          "name": "valid_group_empty_list_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "valid_group_empty_list_user",
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user.valid_group_missing_user",
          "mode": "managed",
          "name": "valid_group_missing_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "valid_group_missing_user",
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_user_policy.invalid_user_policy",
          "mode": "managed",
          "name": "invalid_user_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user_policy",
          "values": {
            "name": "invalid_user_policy",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "user": "invalid_user_policy_user"
          }
        },
        {
          "address": "aws_iam_user_policy_attachment.invalid_user_policy_attachment",
          "mode": "managed",
          "name": "invalid_user_policy_attachment",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user_policy_attachment",
          "values": {
            "user": "invalid_user_policy_attachment_user"
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_iam_group.valid_group_blank_users",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "valid_group_blank_users",
          "path": "/"
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_blank_users",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group"
    },
    {
      "address": "aws_iam_group.valid_group_empty_list_users",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "valid_group_empty_list_users",
          "path": "/"
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_empty_list_users",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group"
    },
    {
      "address": "aws_iam_group.valid_group_missing_users",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "valid_group_missing_users",
          "path": "/"
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_missing_users",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group"
    },
    {
      "address": "aws_iam_group_membership.valid_group_blank_users_membership",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "group": "valid_group_blank_users",
          "name": "valid_group_blank_users_membership",
          "users": [
            "valid_group_blank_user"
          ]
        },
        "after_unknown": {
          "id": true,
          "users": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_blank_users_membership",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group_membership"
    },
    {
      "address": "aws_iam_group_membership.valid_group_empty_list_users_membership",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "group": "valid_group_empty_list_users",
          "name": "valid_group_empty_list_users_membership",
          "users": [
            "valid_group_empty_list_user"
          ]
        },
        "after_unknown": {
          "id": true,
          "users": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_empty_list_users_membership",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group_membership"
    },
    {
      "address": "aws_iam_group_membership.valid_group_missing_users_membership",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "group": "valid_group_missing_users",
          "name": "valid_group_missing_users_membership",
          "users": [
            "valid_group_missing_user"
          ]
        },
        "after_unknown": {
          "id": true,
          "users": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_missing_users_membership",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group_membership"
    },
    {
      "address": "aws_iam_policy.invalid_normal_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Invalid normal policy attached to user",
          "name": "invalid_normal_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "policy_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_normal_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy.invalid_user_policy_attachment_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Invalid user policy attachment policy",
          "name": "invalid_user_policy_attachment_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "policy_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_user_policy_attachment_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy.valid_group_blank_users_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Valid group blank users policy",
          "name": "valid_group_blank_users_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "policy_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_blank_users_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy.valid_group_empty_list_users_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Valid group empty list users policy",
          "name": "valid_group_empty_list_users_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "policy_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_empty_list_users_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy.valid_group_missing_users_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Valid group missing users policy",
          "name": "valid_group_missing_users_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "policy_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_missing_users_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy.valid_role_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Valid role policy",
          "name": "valid_role_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "policy_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_role_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy_attachment.invalid_normal_policy_attachment",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "groups": null,
          "name": "invalid_normal_policy_attachment",
          "roles": null,
          "users": [
            "invalid_normal_policy_user"
          ]
        },
        "after_unknown": {
          "id": true,
          "policy_arn": true,
          "users": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_normal_policy_attachment",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy_attachment"
    },
    {
      "address": "aws_iam_policy_attachment.valid_group_policy_attachment_blank_users",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "groups": [
            "valid_group_blank_users"
          ],
          "name": "valid_group_policy_attachment_blank_users",
          "roles": null,
          "users": [
            ""
          ]
        },
        "after_unknown": {
          "groups": [
            false
          ],
          "id": true,
          "policy_arn": true,
          "users": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_policy_attachment_blank_users",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy_attachment"
    },
    {
      "address": "aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "groups": [
            "valid_group_empty_list_users"
          ],
          "name": "valid_group_policy_attachment_empty_list_users",
          "roles": null,
          "users": null
        },
        "after_unknown": {
          "groups": [
            false
          ],
          "id": true,
          "policy_arn": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_policy_attachment_empty_list_users",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy_attachment"
    },
    {
      "address": "aws_iam_policy_attachment.valid_group_policy_attachment_missing_users",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "groups": [
            "valid_group_missing_users"
          ],
          "name": "valid_group_policy_attachment_missing_users",
          "roles": null,
          "users": null
        },
        "after_unknown": {
          "groups": [
            false
          ],
          "id": true,
          "policy_arn": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_policy_attachment_missing_users",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy_attachment"
    },
    {
      "address": "aws_iam_policy_attachment.valid_role_policy_attachment",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "groups": null,
          "name": "valid_role_policy_attachment",
          "roles": [
            "valid_role"
          ],
          "users": null
        },
        "after_unknown": {
          "id": true,
          "policy_arn": true,
          "roles": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_role_policy_attachment",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy_attachment"
    },
    {
      "address": "aws_iam_role.valid_role",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assume_role_policy": "{\n\"Version\": \"2012-10-17\",\n\"Statement\": [\n  {\n    \"Action\": \"sts:AssumeRole\",\n    \"Principal\": {\n      \"Service\": \"ec2.amazonaws.com\"\n    },\n    \"Effect\": \"Allow\",\n    \"Sid\": \"\"\n  }\n ]\n}\n",
          "description": null,
          "force_detach_policies": false,
          "max_session_duration": 3600,
          "name": "valid_role",
          "name_prefix": null,
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "create_date": true,
          "id": true,
          "inline_policy": true,
          "managed_policy_arns": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_role",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_role"
    },
    {
      "address": "aws_iam_user.invalid_normal_policy_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "invalid_normal_policy_user",
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_normal_policy_user",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user"
    },
    {
      "address": "aws_iam_user.invalid_user_policy_attachment_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "invalid_user_policy_attachment_user",
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_user_policy_attachment_user",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user"
    },
    {
      "address": "aws_iam_user.invalid_user_policy_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "invalid_user_policy_user",
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_user_policy_user",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user"
    },
    {
      "address": "aws_iam_user.valid_group_blank_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "valid_group_blank_user",
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_blank_user",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user"
    },
    {
      "address": "aws_iam_user.valid_group_empty_list_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "valid_group_empty_list_user",
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_empty_list_user",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user"
    },
    {
      "address": "aws_iam_user.valid_group_missing_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "valid_group_missing_user",
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_missing_user",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user"
    },
    {
      "address": "aws_iam_user_policy.invalid_user_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "invalid_user_policy",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "user": "invalid_user_policy_user"
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_user_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user_policy"
    },
    {
      "address": "aws_iam_user_policy_attachment.invalid_user_policy_attachment",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "user": "invalid_user_policy_attachment_user"
        },
        "after_unknown": {
          "id": true,
          "policy_arn": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_user_policy_attachment",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user_policy_attachment"
    }
  ],
  "terraform_version": "0.13.5"
}

