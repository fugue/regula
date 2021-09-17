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
package rules.tf_aws_s3_block_public_access

import data.fugue
import data.aws.s3.s3_library as lib



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.20"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_2.1.5"
      ]
    },
    "severity": "High"
  },
  "description": "S3 buckets should have all `block public access` options enabled. AWS's S3 Block Public Access feature has four settings: BlockPublicAcls, IgnorePublicAcls, BlockPublicPolicy, and RestrictPublicBuckets. All four settings should be enabled to help prevent the risk of a data breach.",
  "id": "FG_R00229",
  "title": "S3 buckets should have all `block public access` options enabled"
}

resource_type = "MULTIPLE"

policy[j] {
  b = buckets[bucket_id]
  bucket_is_blocked(b)
  j = fugue.allow_resource(b)
} {
  b = buckets[bucket_id]
  not bucket_is_blocked(b)
  j = fugue.deny_resource(b)
}

buckets = fugue.resources("aws_s3_bucket")
bucket_access_blocks = fugue.resources("aws_s3_bucket_public_access_block")

# Using the `bucket_access_blocks`, we construct a set of bucket IDs that have
# the public access blocked.
blocked_buckets[bucket_name] {
    block = bucket_access_blocks[_]
    bucket_name = block.bucket
    block.block_public_acls == true
    block.ignore_public_acls == true
    block.block_public_policy == true
    block.restrict_public_buckets == true
}

bucket_is_blocked(bucket) {
  fugue.input_type != "tf_runtime"
  blocked_buckets[bucket.id]
} {
  blocked_buckets[bucket.bucket]
}

