# Copyright 2020 Fugue, Inc.
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
package tests.rules.tag_all_resources

import data.fugue.regula
import data.tests.examples.aws.inputs.tag_all_resources_infra.mock_plan_input

test_tag_all_resources {
  report := regula.report with input as mock_plan_input
  resources := report.rules.tag_all_resources.resources

  resources["aws_vpc.invalid"].valid == false
  re_match("too short", resources["aws_s3_bucket.invalid"].message)

  resources["aws_s3_bucket.invalid"].valid == false
  re_match("too short", resources["aws_s3_bucket.invalid"].message)

  resources["aws_vpc.untagged"].valid == false
  re_match("No tags", resources["aws_vpc.untagged"].message)

  resources["aws_vpc.valid"].valid == true
}
