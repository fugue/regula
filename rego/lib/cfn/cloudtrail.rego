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
package cfn.cloudtrail

import data.cfn.s3

data_resource_value_matches_bucket(value, bucket) {
  s3.matches_bucket_name_or_id(bucket, value)
} {
  is_string(value)
  value == "arn:aws:s3:::"
} {
  is_string(value)
  # Workaround for fregot issue: we get a Subtype error from the concat() call if we
  # just use bucket.BucketName. The type checking seems to work as expected if we
  # pull bucket.BucketName out into its own variable.
  name := bucket.BucketName
  is_string(name)
  pattern := concat("", ["arn:aws:s3:::", name, "(/.*)?$"])
  regex.match(pattern, value)
} {
  is_array(value)
  s3.matches_bucket_name_or_id(bucket, value[_])
}

event_selector_applies_to_bucket(event_selector, bucket) {
  data_resource := event_selector.DataResources[_]
  data_resource.Type == "AWS::S3::Object"
  value := data_resource.Values[_]
  data_resource_value_matches_bucket(value, bucket)
}
