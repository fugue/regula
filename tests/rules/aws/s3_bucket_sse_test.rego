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
package tests.rules.s3_bucket_sse

import data.fugue.regula
import data.tests.rules.aws.inputs.s3_bucket_sse_infra.mock_plan_input

test_s3_bucket_sse {
  report := regula.report with input as mock_plan_input
  resources := report.rules.s3_bucket_sse.resources

  resources["aws_s3_bucket.unencrypted"].valid == false
  resources["aws_s3_bucket.aes_encrypted"].valid == true
  resources["aws_s3_bucket.kms_encrypted"].valid == true
}
