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

# There are some more involved tests for the resource view here.
package fugue.resource_view

# Test that resource_view gives us the right shape.
test_resource_view {
  rv = resource_view with input as {
    "planned_values": {
      "root_module": {
        "resources": [
          {
            "address": "aws_ebs_volume.bad",
            "mode": "managed",
            "type": "aws_ebs_volume",
            "name": "bad",
            "provider_name": "aws",
            "schema_version": 0,
            "values": {
              "availability_zone": "us-west-2a",
              "size": 8,
              "tags": null
            }
          }
        ]
      }
    }
  }
  rv == {
    "aws_ebs_volume.bad": {
      "id": "aws_ebs_volume.bad",
      "_type": "aws_ebs_volume",
      "_provider": "aws",
      "_tags": {},
      "availability_zone": "us-west-2a",
      "size": 8,
      "tags": null
    }
  }
}

# A more involved test, see input below.
test_mock_resource_view {
  rv = mock_resource_view
  rv["aws_cloudwatch_log_group.example"].retention_in_days == 0
  rv["aws_vpc.valid_vpc"].cidr_block == "10.0.0.0/16"
  rv["aws_flow_log.valid_vpc_flow_log"].vpc_id == "aws_vpc.valid_vpc"
  rv["aws_flow_log.valid_vpc_flow_log"].log_destination == "aws_cloudwatch_log_group.example"
}

mock_resource_view = ret {
  ret = resource_view with input as mock_config
}

mock_config = {
   "format_version":"0.1",
   "terraform_version":"0.12.18",
   "planned_values":{
      "root_module":{
         "resources":[
            {
               "address":"aws_cloudwatch_log_group.example",
               "mode":"managed",
               "type":"aws_cloudwatch_log_group",
               "name":"example",
               "provider_name":"aws",
               "schema_version":0,
               "values":{
                  "kms_key_id":null,
                  "name":"example",
                  "name_prefix":null,
                  "retention_in_days":0,
                  "tags":null
               }
            },
            {
               "address":"aws_flow_log.valid_vpc_flow_log",
               "mode":"managed",
               "type":"aws_flow_log",
               "name":"valid_vpc_flow_log",
               "provider_name":"aws",
               "schema_version":0,
               "values":{
                  "eni_id":null,
                  "log_destination_type":"cloud-watch-logs",
                  "subnet_id":null,
                  "traffic_type":"ALL"
               }
            },
            {
               "address":"aws_iam_role.example",
               "mode":"managed",
               "type":"aws_iam_role",
               "name":"example",
               "provider_name":"aws",
               "schema_version":0,
               "values":{
                  "assume_role_policy":"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n",
                  "description":null,
                  "force_detach_policies":false,
                  "max_session_duration":3600,
                  "name":"example",
                  "name_prefix":null,
                  "path":"/",
                  "permissions_boundary":null,
                  "tags":null
               }
            },
            {
               "address":"aws_iam_role_policy.example",
               "mode":"managed",
               "type":"aws_iam_role_policy",
               "name":"example",
               "provider_name":"aws",
               "schema_version":0,
               "values":{
                  "name":"example",
                  "name_prefix":null,
                  "policy":"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
               }
            },
            {
               "address":"aws_vpc.valid_vpc",
               "mode":"managed",
               "type":"aws_vpc",
               "name":"valid_vpc",
               "provider_name":"aws",
               "schema_version":1,
               "values":{
                  "assign_generated_ipv6_cidr_block":false,
                  "cidr_block":"10.0.0.0/16",
                  "enable_dns_support":true,
                  "instance_tenancy":"default",
                  "tags":null
               }
            }
         ]
      }
   },
   "resource_changes":[
      {
         "address":"aws_cloudwatch_log_group.example",
         "mode":"managed",
         "type":"aws_cloudwatch_log_group",
         "name":"example",
         "provider_name":"aws",
         "change":{
            "actions":[
               "create"
            ],
            "before":null,
            "after":{
               "kms_key_id":null,
               "name":"example",
               "name_prefix":null,
               "retention_in_days":0,
               "tags":null
            },
            "after_unknown":{
               "arn":true,
               "id":true
            }
         }
      },
      {
         "address":"aws_flow_log.valid_vpc_flow_log",
         "mode":"managed",
         "type":"aws_flow_log",
         "name":"valid_vpc_flow_log",
         "provider_name":"aws",
         "change":{
            "actions":[
               "create"
            ],
            "before":null,
            "after":{
               "eni_id":null,
               "log_destination_type":"cloud-watch-logs",
               "subnet_id":null,
               "traffic_type":"ALL"
            },
            "after_unknown":{
               "iam_role_arn":true,
               "id":true,
               "log_destination":true,
               "log_format":true,
               "log_group_name":true,
               "vpc_id":true
            }
         }
      },
      {
         "address":"aws_iam_role.example",
         "mode":"managed",
         "type":"aws_iam_role",
         "name":"example",
         "provider_name":"aws",
         "change":{
            "actions":[
               "create"
            ],
            "before":null,
            "after":{
               "assume_role_policy":"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n",
               "description":null,
               "force_detach_policies":false,
               "max_session_duration":3600,
               "name":"example",
               "name_prefix":null,
               "path":"/",
               "permissions_boundary":null,
               "tags":null
            },
            "after_unknown":{
               "arn":true,
               "create_date":true,
               "id":true,
               "unique_id":true
            }
         }
      },
      {
         "address":"aws_iam_role_policy.example",
         "mode":"managed",
         "type":"aws_iam_role_policy",
         "name":"example",
         "provider_name":"aws",
         "change":{
            "actions":[
               "create"
            ],
            "before":null,
            "after":{
               "name":"example",
               "name_prefix":null,
               "policy":"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "after_unknown":{
               "id":true,
               "role":true
            }
         }
      },
      {
         "address":"aws_vpc.valid_vpc",
         "mode":"managed",
         "type":"aws_vpc",
         "name":"valid_vpc",
         "provider_name":"aws",
         "change":{
            "actions":[
               "create"
            ],
            "before":null,
            "after":{
               "assign_generated_ipv6_cidr_block":false,
               "cidr_block":"10.0.0.0/16",
               "enable_dns_support":true,
               "instance_tenancy":"default",
               "tags":null
            },
            "after_unknown":{
               "arn":true,
               "default_network_acl_id":true,
               "default_route_table_id":true,
               "default_security_group_id":true,
               "dhcp_options_id":true,
               "enable_classiclink":true,
               "enable_classiclink_dns_support":true,
               "enable_dns_hostnames":true,
               "id":true,
               "ipv6_association_id":true,
               "ipv6_cidr_block":true,
               "main_route_table_id":true,
               "owner_id":true
            }
         }
      }
   ],
   "configuration":{
      "provider_config":{
         "aws":{
            "name":"aws",
            "expressions":{
               "region":{
                  "constant_value":"us-east-1"
               }
            }
         }
      },
      "root_module":{
         "resources":[
            {
               "address":"aws_cloudwatch_log_group.example",
               "mode":"managed",
               "type":"aws_cloudwatch_log_group",
               "name":"example",
               "provider_config_key":"aws",
               "expressions":{
                  "name":{
                     "constant_value":"example"
                  }
               },
               "schema_version":0
            },
            {
               "address":"aws_flow_log.valid_vpc_flow_log",
               "mode":"managed",
               "type":"aws_flow_log",
               "name":"valid_vpc_flow_log",
               "provider_config_key":"aws",
               "expressions":{
                  "iam_role_arn":{
                     "references":[
                        "aws_iam_role.example"
                     ]
                  },
                  "log_destination":{
                     "references":[
                        "aws_cloudwatch_log_group.example"
                     ]
                  },
                  "traffic_type":{
                     "constant_value":"ALL"
                  },
                  "vpc_id":{
                     "references":[
                        "aws_vpc.valid_vpc"
                     ]
                  }
               },
               "schema_version":0
            },
            {
               "address":"aws_iam_role.example",
               "mode":"managed",
               "type":"aws_iam_role",
               "name":"example",
               "provider_config_key":"aws",
               "expressions":{
                  "assume_role_policy":{
                     "constant_value":"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n"
                  },
                  "name":{
                     "constant_value":"example"
                  }
               },
               "schema_version":0
            },
            {
               "address":"aws_iam_role_policy.example",
               "mode":"managed",
               "type":"aws_iam_role_policy",
               "name":"example",
               "provider_config_key":"aws",
               "expressions":{
                  "name":{
                     "constant_value":"example"
                  },
                  "policy":{
                     "constant_value":"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
                  },
                  "role":{
                     "references":[
                        "aws_iam_role.example"
                     ]
                  }
               },
               "schema_version":0
            },
            {
               "address":"aws_vpc.valid_vpc",
               "mode":"managed",
               "type":"aws_vpc",
               "name":"valid_vpc",
               "provider_config_key":"aws",
               "expressions":{
                  "cidr_block":{
                     "constant_value":"10.0.0.0/16"
                  }
               },
               "schema_version":1
            }
         ]
      }
   }
}
