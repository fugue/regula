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
package rules.tf_aws_s3_encryption

import data.fugue
import data.aws.s3.s3_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_2.1.1"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_2.1.1"
      ]
    },
    "severity": "High"
  },
  "description": "S3 bucket server-side encryption should be enabled. Enabling server-side encryption (SSE) on S3 buckets at the object level protects data at rest and helps prevent the breach of sensitive information assets. Objects can be encrypted with S3 Managed Keys (SSE-S3), KMS Managed Keys (SSE-KMS), or Customer Provided Keys (SSE-C).",
  "id": "FG_R00099",
  "title": "S3 bucket server-side encryption should be enabled"
}

resource_type := "MULTIPLE"

buckets := fugue.resources("aws_s3_bucket")
encryption_configs := { id: config |
  # This is a design-time only resource type, so make sure it exists
  fugue.input_resource_types["aws_s3_bucket_server_side_encryption_configuration"]
  config := fugue.resources("aws_s3_bucket_server_side_encryption_configuration")[id]
}

is_encrypted(bucket) {
  _ = bucket.server_side_encryption_configuration[_].rule[_][_][_].sse_algorithm
}

is_encrypted(bucket) {
  ec := encryption_configs[_]
  lib.matches_bucket_or_id(ec.bucket, bucket)
}

policy[j] {
  bucket := buckets[_]
  is_encrypted(bucket)
  j := fugue.allow_resource(bucket)
}

policy[j] {
  bucket := buckets[_]
  not is_encrypted(bucket)
  j := fugue.deny_resource(bucket)
}
