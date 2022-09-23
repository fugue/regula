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
package rules.tf_aws_cloudtrail_s3_access_logging

import data.aws.s3.s3_library as lib
import data.fugue

__rego__metadoc__ := {
	"custom": {
		"controls": {
			"CIS-AWS_v1.2.0": ["CIS-AWS_v1.2.0_2.6"],
			"CIS-AWS_v1.3.0": ["CIS-AWS_v1.3.0_3.6"],
			"CIS-AWS_v1.4.0": ["CIS-AWS_v1.4.0_3.6"],
		},
		"severity": "Medium",
	},
	"description": "S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files. It is recommended that users enable bucket access logging on the S3 bucket storing CloudTrail log data. Such logging tracks access requests to this S3 bucket and can be useful in security and incident response workflows.",
	"id": "FG_R00031",
	"title": "S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files",
}

cloudtrails = fugue.resources("aws_cloudtrail")

buckets = fugue.resources("aws_s3_bucket")

buckets_by_name = {bucket_name: bucket |
	bucket_name = lib.bucket_name_or_id(bucket)
	buckets[_] = bucket
}

target_has_access_logging(ct) {
	bucket_has_logging(buckets_by_name[ct.s3_bucket_name])
}

bucket_has_logging(bucket) {
	_ = bucket.logging[_]
}

bucket_has_logging(bucket) {
	print("bucket, ", bucket)
	_ = lib.bucket_logging_by_bucket[lib.bucket_name_or_id(bucket)]
}

resource_type := "MULTIPLE"

policy[j] {
	ct = cloudtrails[_]
	target_has_access_logging(ct)
	j = fugue.allow_resource(ct)
} {
	ct = cloudtrails[_]
	not target_has_access_logging(ct)
	j = fugue.deny_resource(ct)
}
