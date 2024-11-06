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

package rules.tf_aws_s3_bucket_access_logging

import data.tests.rules.tf.aws.s3.inputs.bucket_logging_infra_json

test_s3_logging {
	pol = policy with input as bucket_logging_infra_json.mock_input
	by_resource_id = {p.id: p.valid | pol[p]}
	by_resource_id["aws_s3_bucket.allow_inline_logging"] == true
	by_resource_id["aws_s3_bucket.deny_no_logging"] == false
	by_resource_id["aws_s3_bucket.allow_attached_resource_logging"] == true
}
