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
package rules.aws_cloudtrail_s3_access_logging

import data.fugue
import data.aws.s3.s3_library as lib



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.6"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.6"
      ],
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_14.9",
        "CIS-Controls_v7.1_6.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files. It is recommended that users enable bucket access logging on the S3 bucket storing CloudTrail log data. Such logging tracks access requests to this S3 bucket and can be useful in security and incident response workflows.",
  "id": "FG_R00031",
  "title": "S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files"
}

cloudtrails = fugue.resources("aws_cloudtrail")
buckets = fugue.resources("aws_s3_bucket")
buckets_by_name = {bucket_name: bucket |
  bucket_name = lib.bucket_name_or_id(bucket)
  buckets[_] = bucket
}

target_has_access_logging(ct) {
  count(buckets_by_name[ct.s3_bucket_name].logging) > 0
}

resource_type = "MULTIPLE"

policy[j] {
  ct = cloudtrails[_]
  target_has_access_logging(ct)
  j = fugue.allow_resource(ct)
} {
  ct = cloudtrails[_]
  not target_has_access_logging(ct)
  j = fugue.deny_resource(ct)
}

