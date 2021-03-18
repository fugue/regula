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
package rules.cfn_s3_encryption

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_2.1.1"
      ]
    },
    "severity": "High"
  },
  "description": "S3 bucket server side encryption should be enabled. Enabling server-side encryption (SSE) on S3 buckets at the object level protects data at rest and helps prevent the breach of sensitive information assets. Objects can be encrypted with S3-Managed Keys (SSE-S3), KMS-Managed Keys (SSE-KMS), or Customer-Provided Keys (SSE-C).",
  "id": "FG_R00099",
  "title": "S3 bucket server side encryption should be enabled"
}

input_type := "cloudformation"
resource_type := "AWS::S3::Bucket"

default allow = false

allow {
  algorithms := [algorithm |
    algorithm := input.BucketEncryption.ServerSideEncryptionConfiguration[_].ServerSideEncryptionByDefault.SSEAlgorithm
  ]
  count(algorithms) > 0
}
