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
package tests.rules.tf.aws.iam.inputs.admin_policy_infra_json

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
        "name": "aws",
        "version_constraint": "~> 2.41"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_iam_group.my_group",
          "expressions": {
            "name": {
              "constant_value": "my_group"
            },
            "path": {
              "constant_value": "/users/"
            }
          },
          "mode": "managed",
          "name": "my_group",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group"
        },
        {
          "address": "aws_iam_group_policy.invalid_group_policy",
          "expressions": {
            "group": {
              "references": [
                "aws_iam_group.my_group"
              ]
            },
            "name": {
              "constant_value": "invalid_group_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "invalid_group_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group_policy"
        },
        {
          "address": "aws_iam_group_policy.valid_group_policy",
          "expressions": {
            "group": {
              "references": [
                "aws_iam_group.my_group"
              ]
            },
            "name": {
              "constant_value": "valid_group_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "valid_group_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_group_policy"
        },
        {
          "address": "aws_iam_policy.invalid_policy",
          "expressions": {
            "description": {
              "constant_value": "Invalid policy"
            },
            "name": {
              "constant_value": "test_invalid_policy"
            },
            "path": {
              "constant_value": "/"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "invalid_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_policy.valid_deny_policy",
          "expressions": {
            "description": {
              "constant_value": "Valid deny policy"
            },
            "name": {
              "constant_value": "test_valid_deny_policy"
            },
            "path": {
              "constant_value": "/"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            }
          },
          "mode": "managed",
          "name": "valid_deny_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy"
        },
        {
          "address": "aws_iam_role.my_test_role",
          "expressions": {
            "assume_role_policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}\n"
            },
            "name": {
              "constant_value": "my_test_role"
            }
          },
          "mode": "managed",
          "name": "my_test_role",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_role"
        },
        {
          "address": "aws_iam_role_policy.invalid_role_policy",
          "expressions": {
            "name": {
              "constant_value": "invalid_role_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "role": {
              "references": [
                "aws_iam_role.my_test_role"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid_role_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_role_policy"
        },
        {
          "address": "aws_iam_role_policy.valid_role_policy",
          "expressions": {
            "name": {
              "constant_value": "valid_role_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "role": {
              "references": [
                "aws_iam_role.my_test_role"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_role_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_role_policy"
        },
        {
          "address": "aws_iam_user.my_test_user",
          "expressions": {
            "name": {
              "constant_value": "my_test_user"
            },
            "path": {
              "constant_value": "/system/"
            }
          },
          "mode": "managed",
          "name": "my_test_user",
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
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "user": {
              "references": [
                "aws_iam_user.my_test_user"
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
          "address": "aws_iam_user_policy.valid_user_policy",
          "expressions": {
            "name": {
              "constant_value": "valid_user_policy"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "user": {
              "references": [
                "aws_iam_user.my_test_user"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_user_policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_user_policy"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_iam_group.my_group",
          "mode": "managed",
          "name": "my_group",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group",
          "values": {
            "name": "my_group",
            "path": "/users/"
          }
        },
        {
          "address": "aws_iam_group_policy.invalid_group_policy",
          "mode": "managed",
          "name": "invalid_group_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group_policy",
          "values": {
            "name": "invalid_group_policy",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_iam_group_policy.valid_group_policy",
          "mode": "managed",
          "name": "valid_group_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_group_policy",
          "values": {
            "name": "valid_group_policy",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_iam_policy.invalid_policy",
          "mode": "managed",
          "name": "invalid_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Invalid policy",
            "name": "test_invalid_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_iam_policy.valid_deny_policy",
          "mode": "managed",
          "name": "valid_deny_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy",
          "values": {
            "description": "Valid deny policy",
            "name": "test_valid_deny_policy",
            "name_prefix": null,
            "path": "/",
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_iam_role.my_test_role",
          "mode": "managed",
          "name": "my_test_role",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_role",
          "values": {
            "assume_role_policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}\n",
            "description": null,
            "force_detach_policies": false,
            "max_session_duration": 3600,
            "name": "my_test_role",
            "name_prefix": null,
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_role_policy.invalid_role_policy",
          "mode": "managed",
          "name": "invalid_role_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_role_policy",
          "values": {
            "name": "invalid_role_policy",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_iam_role_policy.valid_role_policy",
          "mode": "managed",
          "name": "valid_role_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_role_policy",
          "values": {
            "name": "valid_role_policy",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_iam_user.my_test_user",
          "mode": "managed",
          "name": "my_test_user",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user",
          "values": {
            "force_destroy": false,
            "name": "my_test_user",
            "path": "/system/",
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
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "user": "my_test_user"
          }
        },
        {
          "address": "aws_iam_user_policy.valid_user_policy",
          "mode": "managed",
          "name": "valid_user_policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_user_policy",
          "values": {
            "name": "valid_user_policy",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
            "user": "my_test_user"
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_iam_group.my_group",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "my_group",
          "path": "/users/"
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "my_group",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group"
    },
    {
      "address": "aws_iam_group_policy.invalid_group_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "invalid_group_policy",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "group": true,
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_group_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group_policy"
    },
    {
      "address": "aws_iam_group_policy.valid_group_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "valid_group_policy",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "group": true,
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_group_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_group_policy"
    },
    {
      "address": "aws_iam_policy.invalid_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Invalid policy",
          "name": "test_invalid_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "arn": true,
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_policy.valid_deny_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "description": "Valid deny policy",
          "name": "test_valid_deny_policy",
          "name_prefix": null,
          "path": "/",
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "arn": true,
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_deny_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy"
    },
    {
      "address": "aws_iam_role.my_test_role",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assume_role_policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}\n",
          "description": null,
          "force_detach_policies": false,
          "max_session_duration": 3600,
          "name": "my_test_role",
          "name_prefix": null,
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "create_date": true,
          "id": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "my_test_role",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_role"
    },
    {
      "address": "aws_iam_role_policy.invalid_role_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "invalid_role_policy",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "id": true,
          "role": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_role_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_role_policy"
    },
    {
      "address": "aws_iam_role_policy.valid_role_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "valid_role_policy",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "id": true,
          "role": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_role_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_role_policy"
    },
    {
      "address": "aws_iam_user.my_test_user",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "force_destroy": false,
          "name": "my_test_user",
          "path": "/system/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "my_test_user",
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
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "user": "my_test_user"
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
      "address": "aws_iam_user_policy.valid_user_policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "valid_user_policy",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
          "user": "my_test_user"
        },
        "after_unknown": {
          "id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_user_policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_user_policy"
    }
  ],
  "terraform_version": "0.13.5"
}

