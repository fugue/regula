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
package rules.cfn_cloudtrail_s3_access_logging

import data.fugue
import data.fugue.cfn.s3

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.6"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.6"
      ]
    },
    "severity": "Medium"
  },
  "description": "S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files. It is recommended that users enable bucket access logging on the S3 bucket storing CloudTrail log data. Such logging tracks access requests to this S3 bucket and can be useful in security and incident response workflows.",
  "id": "FG_R00031",
  "title": "S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files"
}

input_type = "cfn"
resource_type = "MULTIPLE"

cloudtrails = fugue.resources("AWS::CloudTrail::Trail")
buckets = fugue.resources("AWS::S3::Bucket")

cts_with_access_logging[ct_id] {
  bucket = buckets[_]
  ct = cloudtrails[ct_id]
  s3.matches_bucket_name_or_id(bucket, ct.S3BucketName)
  count(bucket.LoggingConfiguration) > 0
}

policy[j] {
  ct = cloudtrails[ct_id]
  cts_with_access_logging[ct_id]
  j = fugue.allow_resource(ct)
} {
  ct = cloudtrails[ct_id]
  not cts_with_access_logging[ct_id]
  j = fugue.deny_resource(ct)
}
