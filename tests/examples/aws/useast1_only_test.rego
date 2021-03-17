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
package rules.useast1_only

import data.fugue.resource_view.resource_view_input
import data.tests.examples.aws.inputs.useast1_only_infra.mock_input

test_useast1_only {
  pol = policy with input as mock_input
  # We're only producing a result when provider region != "us-east-1"
  pol == set()
}

test_useast2_only {
  pol = policy with input as mock_useast2_input
  pol[_].valid == false
}

mock_useast2_input = ret {
  ret = resource_view_input with input as {
    "terraform_version": "0.12.18",
    "configuration": {
      "provider_config": {
        "aws": {
          "name": "aws",
          "expressions": {
            "region": {
              "constant_value": "us-east-2"
            }
          }
        }
      }
    }
  }
}
