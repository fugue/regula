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
package tests.rules.tf.aws.vpc.inputs.flow_log_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_cloudwatch_log_group.example": {
      "_filepath": "tests/rules/tf/aws/vpc/inputs/flow_log_infra.tf",
      "_provider": "aws",
      "_type": "aws_cloudwatch_log_group",
      "id": "aws_cloudwatch_log_group.example",
      "name": "example"
    },
    "aws_flow_log.valid_vpc_flow_log": {
      "_filepath": "tests/rules/tf/aws/vpc/inputs/flow_log_infra.tf",
      "_provider": "aws",
      "_type": "aws_flow_log",
      "iam_role_arn": "aws_iam_role.example",
      "id": "aws_flow_log.valid_vpc_flow_log",
      "log_destination": "aws_cloudwatch_log_group.example",
      "traffic_type": "ALL",
      "vpc_id": "aws_vpc.valid_vpc"
    },
    "aws_iam_role.example": {
      "_filepath": "tests/rules/tf/aws/vpc/inputs/flow_log_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_role",
      "assume_role_policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n",
      "id": "aws_iam_role.example",
      "name": "example"
    },
    "aws_iam_role_policy.example": {
      "_filepath": "tests/rules/tf/aws/vpc/inputs/flow_log_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_role_policy",
      "id": "aws_iam_role_policy.example",
      "name": "example",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
      "role": "aws_iam_role.example"
    },
    "aws_vpc.invalid_vpc": {
      "_filepath": "tests/rules/tf/aws/vpc/inputs/flow_log_infra.tf",
      "_provider": "aws",
      "_type": "aws_vpc",
      "cidr_block": "10.0.0.0/16",
      "id": "aws_vpc.invalid_vpc"
    },
    "aws_vpc.valid_vpc": {
      "_filepath": "tests/rules/tf/aws/vpc/inputs/flow_log_infra.tf",
      "_provider": "aws",
      "_type": "aws_vpc",
      "cidr_block": "10.0.0.0/16",
      "id": "aws_vpc.valid_vpc"
    }
  }
}

