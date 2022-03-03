# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_aws_ec2_instance_profile

__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "EC2 instances should use IAM roles and instance profiles instead of IAM access keys to perform requests. By passing role information to an EC2 instance at launch, you can limit the risk of access key exposure and help prevent a malicious user from compromising the instance.",
  "id": "FG_R00253",
  "title": "EC2 instances should use IAM roles and instance profiles instead of IAM access keys to perform requests"
}

resource_type := "aws_instance"

default allow = false

allow {
  profile = input.iam_instance_profile
  profile != null
}
