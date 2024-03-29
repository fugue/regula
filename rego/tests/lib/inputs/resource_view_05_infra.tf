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
locals {
  tag_name = "foo"
  tag_poc  = "bar"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "cloudwatch" {
  description             = "cloudwatch kms key"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = local.tag_name
    POC  = local.tag_poc
  }
}

resource "aws_cloudwatch_log_group" "fargate-logs" {
  name       = "/ecs/fargate-task-definition"
  kms_key_id = aws_kms_key.cloudwatch.key_id

  tags = {
    Name = local.tag_name
    POC  = local.tag_poc
  }
}
