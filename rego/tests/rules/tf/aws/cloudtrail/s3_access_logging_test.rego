# Copyright 2020-2022 Fugue, Inc.
# Copyright 2022 Snyk, Inc.
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

import data.tests.rules.tf.aws.cloudtrail.inputs.issue355_infra_json

# <https://github.com/fugue/regula/issues/355>
test_s3_access_logging_issue355 {
  pol = policy with input as issue355_infra_json.mock_input
  count(pol) == 1
  pol[_].valid == true
}
