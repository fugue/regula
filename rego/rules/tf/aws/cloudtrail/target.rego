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
package rules.tf_aws_cloudtrail_target

import data.fugue
import data.aws.s3.s3_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.3"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.3"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_3.3"
      ]
    },
    "severity": "Critical"
  },
  "description": "S3 bucket ACLs should not have public access on S3 buckets that store CloudTrail log files. CloudTrail logs a record of every API call made in your AWS account to S3 buckets. It is recommended that the bucket policy, or access control list (ACL), applied to these S3 buckets should prevent public access. Allowing public access to CloudTrail log data may aid an adversary in identifying weaknesses in the affected account's use or configuration.",
  "id": "FG_R00028",
  "title": "S3 bucket ACLs should not have public access on S3 buckets that store CloudTrail log files"
}

cloudtrails = fugue.resources("aws_cloudtrail")
buckets = fugue.resources("aws_s3_bucket")

cloudtrail_buckets = {bucket_id: bucket |
  buckets[bucket_id] = bucket
  cloudtrails[_] = ct
  lib.bucket_name_or_id(bucket) == ct.s3_bucket_name
}

public_acls := {"public-read", "public-read-write"}

bucket_public_acl(bucket) {
  public_acls[bucket.acl]
} {
  acl := lib.bucket_acls_by_bucket[lib.bucket_name_or_id(bucket)]
  public_acls[acl.acl]
}

resource_type := "MULTIPLE"

policy[j] {
  buck = cloudtrail_buckets[_]
  not bucket_public_acl(buck)
  j = fugue.allow_resource(buck)
} {
  buck = cloudtrail_buckets[_]
  bucket_public_acl(buck)
  j = fugue.deny_resource(buck)
}
