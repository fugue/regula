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
package fugue.test_resource_view_issue256

import data.fugue.resource_view.terraform

# See <https://github.com/fugue/regula/issues/256>.
test_resource_view_issue256 {
	# We don't care too much about the exact representation, that is tested
	# elsewhere, we just want to ensure this doesn't crash.
	cms = terraform.configuration_modules with input as problematic_input
	count(cms) == 2
}

problematic_input = {
	"terraform_version": "0.12.1",
	"configuration": {
		"root_module": {
			"module_calls": {
				"resources": {
					"for_each_expression": {
						"references": [
							"var.api_definition_list"
						],
						"resources": {}
					},
					"module": {
						"resources": {}
					}
				}
			}
		}
	}
}
