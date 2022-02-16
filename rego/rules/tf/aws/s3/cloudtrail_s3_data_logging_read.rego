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
package rules.tf_aws_s3_cloudtrail_s3_data_logging_read

import data.fugue

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.11"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_3.11"
      ]
    },
    "severity": "Low"
  },
  "description": "S3 bucket object-level logging for read events should be enabled. Object-level S3 events (GetObject, DeleteObject, and PutObject) are not logged by default, though this is recommended from a security best practices perspective for buckets that contain sensitive data.",
  "id": "FG_R00355",
  "title": "S3 bucket object-level logging for read events should be enabled"
}

resource_type := "MULTIPLE"

trails = fugue.resources("aws_cloudtrail")
buckets = fugue.resources("aws_s3_bucket")

valid_selector_types = {
  "",
  "All",
  "ReadOnly"
}

# This contains ARNs (at runtime) and IDs (at design time).
buckets_from_trail_with_s3_data_logging = { arn |
  trail = trails[_]
  selector = trail.event_selector[_]
  valid_selector_types[selector.read_write_type]
  resource = selector.data_resource[_]
  resource.type == "AWS::S3::Object"
  bucket_arn = resource.values[_]
  arn = trim_right(bucket_arn, "/")
}

# Buckets are valid if at least one CloudTrail Trail is logging data events for that bucket
valid_bucket(bucket) {
  bucket_arn = bucket.arn
  buckets_from_trail_with_s3_data_logging[k]
  startswith(bucket_arn, k)
} {
  buckets_from_trail_with_s3_data_logging[bucket.id]
} {
  buckets_from_trail_with_s3_data_logging["arn:aws:s3:::"]
}

policy[j] {
  bucket = buckets[_]
  valid_bucket(bucket)
  j = fugue.allow_resource(bucket)
} {
  bucket = buckets[_]
  not valid_bucket(bucket)
  j = fugue.deny_resource(bucket)
}
