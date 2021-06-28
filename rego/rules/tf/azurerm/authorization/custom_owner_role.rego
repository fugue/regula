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
package rules.tf_azurerm_authorization_custom_owner_role

import data.fugue


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
  "description": "Active Directory custom subscription owner roles should not be created. Subscription ownership should not include permission to create custom owner roles. The principle of least privilege should be followed and only necessary privileges should be assigned instead of allowing full administrative access.",
  "id": "FG_R00288",
  "title": "Active Directory custom subscription owner roles should not be created"
}

resource_type = "azurerm_role_definition"

is_subscription_scope(scope) {
  scope == "/"
} {
  re_match("^/subscriptions/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/?$", lower(scope))
} {
  # At design time, you can use the azurerm_subscription data resource.
  startswith(scope, "data.azurerm_subscription.")
}

default deny = false

user_defined {
  # All roles can be considered user defined at design time.
  fugue.input_type != "tf_runtime"
} {
  input.role_type == "CustomRole"
}

deny {
  user_defined
  input.permissions[_].actions[_] == "*"
  is_subscription_scope(input.assignable_scopes[_])
}

