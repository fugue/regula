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
package fugue.resource_view

import data.tests.lib.inputs.resource_view_07_infra_json

# Tests tags
test_resource_view_07 {
  bucket := resource_view_07_infra_json.mock_resources[_]
  bucket._type == "aws_s3_bucket"
  bucket._tags.Stage == "Prod"

  asg := resource_view_07_infra_json.mock_resources[_]
  asg._type == "aws_autoscaling_group"
  asg._tags.Stage == "Dev"

  google_storage_bucket := resource_view_07_infra_json.mock_resources[_]
  google_storage_bucket._type == "google_storage_bucket"
  google_storage_bucket._tags.Stage == "Prod"

  google_compute_instance := resource_view_07_infra_json.mock_resources[_]
  google_compute_instance._type == "google_compute_instance"
  google_compute_instance._tags.foo == null
  google_compute_instance._tags.bar == null
}
