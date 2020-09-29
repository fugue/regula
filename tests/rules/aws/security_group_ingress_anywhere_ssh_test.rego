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
package tests.rules.security_group_ingress_anywhere_ssh

import data.fugue.regula

test_security_group_ingress_anywhere_ssh {
  report := regula.report with input as mock_input
  resources := report.rules.security_group_ingress_anywhere_ssh.resources

  resources["aws_security_group.valid_sg_1"].valid == true
  resources["aws_security_group.valid_sg_2"].valid == true
  resources["aws_security_group.invalid_sg_1"].valid == false
  resources["aws_security_group.invalid_sg_2"].valid == false
}
