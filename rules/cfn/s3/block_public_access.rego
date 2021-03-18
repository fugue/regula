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
package rules.cfn_s3_block_public_access

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.20"
      ]
    },
    "severity": "High"
  },
  "description": "S3 buckets should have all `block public access` options enabled. AWS's S3 Block Public Access feature has four settings: BlockPublicAcls, IgnorePublicAcls, BlockPublicPolicy, and RestrictPublicBuckets. All four settings should be enabled to help prevent the risk of a data breach.",
  "id": "FG_R00229",
  "title": "S3 buckets should have all `block public access` options enabled"
}

input_type := "cloudformation"
resource_type := "AWS::S3::Bucket"

default allow = false

allow {
  access_block := input.PublicAccessBlockConfiguration
  access_block.BlockPublicAcls == true
  access_block.BlockPublicPolicy == true
  access_block.IgnorePublicAcls == true
  access_block.RestrictPublicBuckets == true
}
