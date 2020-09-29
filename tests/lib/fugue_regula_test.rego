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
package fugue.regula

# Simple resource used for testing.
testutil_resource = {
  "id": "testutil_resource",
  "_type": "aws_elb_volume"
}

test_judgement_from_allow_denies_01 {
  j = judgement_from_allow_denies(testutil_resource, [true], [])
  j.valid
}

test_judgement_from_allow_denies_02 {
  j = judgement_from_allow_denies(testutil_resource, [false], [])
  not j.valid
}

test_judgement_from_allow_denies_03 {
  j = judgement_from_allow_denies(testutil_resource, [], [false])
  j.valid
}

test_judgement_from_allow_denies_04 {
  j = judgement_from_allow_denies(testutil_resource, [], [true])
  not j.valid
}

test_judgement_from_allow_denies_05 {
  j = judgement_from_allow_denies(testutil_resource, [true], [false])
  j.valid
}

test_judgement_from_allow_denies_06 {
  j = judgement_from_allow_denies(testutil_resource, [true], [true])
  not j.valid
}

test_judgement_from_allow_denies_07 {
  j = judgement_from_allow_denies(testutil_resource, [false], [false])
  not j.valid
}

test_judgement_from_allow_denies_08 {
  j = judgement_from_allow_denies(testutil_resource, [false], [true])
  not j.valid
}

test_judgement_from_deny_messages_01 {
  j = judgement_from_deny_messages(testutil_resource, [])
  j.valid
}

test_judgement_from_deny_messages_02 {
  j = judgement_from_deny_messages(testutil_resource, ["bad"])
  not j.valid
  j.message == "bad"
}
