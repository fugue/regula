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

package rules.arm_authorization_custom_owner_role

import data.fugue
import data.fugue.utils

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_1.23"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_1.21"
      ]
    },
    "severity": "Medium"
  },
  "description": "Subscription ownership should not include permission to create custom owner roles. The principle of least privilege should be followed and only necessary privileges should be assigned instead of allowing full administrative access.",
  "id": "FG_R00288",
  "title": "Active Directory custom subscription owner roles should not be created"
}

input_type := "arm"

resource_type := "Microsoft.Authorization/roledefinitions"

is_subscription_scope(scope) {
	scope == "/"
}

# Examples:
# * "/subscriptions/479a226b-4153-48f7-8943-3e8e388a93cb"
# * "/subscriptions/479a226b-4153-48f7-8943-3e8e388a93cb/"
is_subscription_scope(scope) {
	re_match(`^/subscriptions/[^/]+/?$`, lower(scope))
}

# Examples:
# * "[concat('/subscriptions/', subscription().subscriptionId)]"
# * "[concat('/subscriptions/', '479a226b-4153-48f7-8943-3e8e388a93cb')]"
# * "[concat('/subscriptions/', parameters('subscriptionId'))]"
is_subscription_scope(scope) {
	re_match(`^\[concat\('/subscriptions/',[^,]+\]$`, replace(lower(scope), " ", ""))
}

is_subscription_scope(scope) {
	replace(lower(scope), " ", "") == "[subscription().id]"
}

default deny = false

deny {
	actions := utils.as_array(input.properties.permissions[_].actions)
	actions[_] == "*"
	is_subscription_scope(input.properties.assignableScopes[_])
}
