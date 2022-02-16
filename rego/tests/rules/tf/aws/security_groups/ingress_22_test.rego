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
package rules.tf_aws_security_groups_ingress_22

import data.tests.rules.tf.aws.security_groups.inputs

import data.fugue.check_report
import data.fugue

report = fugue.report_v0("", policy)

test_invalid_security_group_all_open {
    r = report with input as inputs.invalidSecurityGroupAllOpen_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_invalid_security_group_multiple_ingress {
    r = report with input as inputs.invalid_security_group_multiple_ingress_22_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_invalid_ingress_22_ticket_opa_147 {
    r = report with input as inputs.invalidIngress22TicketOpa147_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}
