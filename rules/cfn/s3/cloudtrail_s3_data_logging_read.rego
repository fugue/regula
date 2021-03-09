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
package rules.cfn_s3_cloudtrail_s3_data_logging_read

import data.fugue
import data.fugue.cfn.cloudtrail

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.11"
      ]
    },
    "severity": "Low"
  },
  "description": "S3 bucket object-level logging for read events should be enabled. Object-level S3 events (GetObject, DeleteObject, and PutObject) are not logged by default, though this is recommended from a security best practices perspective for buckets that contain sensitive data.",
  "id": "FG_R00355",
  "title": "S3 bucket object-level logging for read events should be enabled"
}

input_type = "cloudformation"
resource_type = "MULTIPLE"

trails = fugue.resources("AWS::CloudTrail::Trail")
buckets = fugue.resources("AWS::S3::Bucket")

has_trails {
  count(trails) > 0
}

valid_selector_types = {
  "All",
  "ReadOnly"
}

valid_event_selector(event_selector) {
  rw_type := event_selector.ReadWriteType
  valid_selector_types[rw_type]
} {
  not event_selector.ReadWriteType
}

# Buckets are valid if at least one CloudTrail Trail is logging data events for that bucket
valid_buckets[bucket_id] {
  bucket := buckets[bucket_id]
  trail := trails[_]
  event_selector := trail.EventSelectors[_]
  valid_event_selector(event_selector)
  cloudtrail.event_selector_applies_to_bucket(event_selector, bucket)
}

# TODO: We're skipping these rules when a template does not contain both S3 buckets
# and CloudTrail trails. Another possible approach is to add a new type of "unknown"
# result for resources and use that when the template only contains S3 buckets.
policy[j] {
  has_trails
  bucket := buckets[bucket_id]
  valid_buckets[bucket_id]
  j := fugue.allow_resource(bucket)
} {
  has_trails
  bucket := buckets[bucket_id]
  not valid_buckets[bucket_id]
  j := fugue.deny_resource(bucket)
}
