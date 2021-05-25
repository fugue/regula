# Copyright 2020-2021 Fugue, Inc.
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

# This package was automatically generated from:
#
#     tests/rules/tf/google/kms/inputs/cryptokey_rotate_infra.tf
#
# using 'generate_test_inputs.sh' and should not be modified
# directly.
#
# It provides three inputs for testing:
# - mock_input: The resource view input as passed to advanced rules
# - mock_resources: The resources present as a convenience for tests
# - mock_config: The raw config input as its parsed by regula
package tests.rules.tf.google.kms.inputs.cryptokey_rotate_infra

import data.fugue.regula.tests

mock_config := regula_load_type("cryptokey_rotate_infra.tfplan", "tf-plan")
mock_input := tests.mock_input(mock_config)
mock_resources := mock_input.resources
