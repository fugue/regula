# Copyright 2021 Fugue, Inc.
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

import data.tests.rules.arm.authorization.inputs.custom_owner_role_infra_json as infra

test_is_subscription_scope {
	is_subscription_scope("/")
	is_subscription_scope("/subscriptions/479a226b-4153-48f7-8943-3e8e388a93cb")
	is_subscription_scope("/subscriptions/479a226b-4153-48f7-8943-3e8e388a93cb/")
	is_subscription_scope("[concat('/subscriptions/', subscription().subscriptionId)]")
	is_subscription_scope("[concat('/subscriptions/', '479a226b-4153-48f7-8943-3e8e388a93cb')]")
	is_subscription_scope("[concat('/subscriptions/', parameters('subscriptionId'))]")
	is_subscription_scope("[subscription().id]")

	not is_subscription_scope("/subscriptions/479a226b-4153-48f7-8943-3e8e388a93cb/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635")
	not is_subscription_scope("[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]")
}

test_custom_owner_role {
	deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/invalidTopLevel"]
	deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/invalidActionsArr"]
	deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/invalidHardcodedId"]
	deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/invalidConcat"]
	deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/invalidSubscriptionId"]
	not deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/validAction"]
	not deny with input as infra.mock_resources["Microsoft.Authorization/roleDefinitions/validScope"]
}
