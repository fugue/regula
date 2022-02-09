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
package rules.tf_aws_security_groups_ingress_3389

import data.tests.rules.tf.aws.security_groups.inputs

import data.fugue.check_report
import data.fugue

report = fugue.report_v0("", policy)

test_invalid_security_group_all_open {
    r = report with input as inputs.invalidSecurityGroupAllOpen_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_valid_security_group_all_open_specific_ip {
    r = report with input as inputs.validSecurityGroupAllOpenSpecificIp_tf.mock_input
    r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_valid_security_group_all_open_lower_port_set {
    r = report with input as inputs.validSecurityGroupAllOpenLowerPortSet_tf.mock_input
    r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_valid_security_group_all_open_higher_port_set {
    r = report with input as inputs.validSecurityGroupAllOpenHigherPortSet_tf.mock_input
    r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_invalid_security_group_all_open_higher_and_lower_port_set {
    r = report with input as inputs.invalidSecurityGroupAllOpenHigherAndLowerPortSet_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_valid_security_group_two_group_test {
    r = report with input as inputs.valid_ingress_3389_tf.mock_input
    r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_invalid_two_security_groups_open {
    r = report with input as inputs.invalidTwoSecurityGroupsOpen_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}

test_invalid_security_group_multiple_ingress {
    r = report with input as inputs.invalid_ingress_3389_tf.mock_input
    not r.valid
    check_report.check_report(r, {"^sg-[a-z0-9]+$"})
}
