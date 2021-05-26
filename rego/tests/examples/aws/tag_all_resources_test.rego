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
package rules.tag_all_resources

import data.tests.examples.aws.inputs.tag_all_resources_infra_json.mock_input

test_tag_all_resources {
  pol = policy with input as mock_input
  by_resource_id = {p.id: {"valid": p.valid, "message": p.message} | pol[p]}

  by_resource_id["aws_vpc.invalid"].valid == false
  re_match("too short", by_resource_id["aws_s3_bucket.invalid"].message)

  by_resource_id["aws_s3_bucket.invalid"].valid == false
  re_match("too short", by_resource_id["aws_s3_bucket.invalid"].message)

  by_resource_id["aws_vpc.untagged"].valid == false
  re_match("No tags", by_resource_id["aws_vpc.untagged"].message)

  by_resource_id["aws_vpc.valid"].valid == true
}
