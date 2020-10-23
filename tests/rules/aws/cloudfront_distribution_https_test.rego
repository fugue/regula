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
package tests.rules.cloudfront_distribution_https

import data.fugue.regula
import data.tests.rules.aws.inputs.cloudfront_distribution_https_infra.mock_plan_input

test_cloudfront_distribution_https {
  report := regula.report with input as mock_plan_input
  resources := report.rules.cloudfront_distribution_https.resources

  resources["aws_cloudfront_distribution.allow_all"].valid == false
  resources["aws_cloudfront_distribution.redirect_to_https"].valid == true
  resources["aws_cloudfront_distribution.https_only"].valid == true
}
