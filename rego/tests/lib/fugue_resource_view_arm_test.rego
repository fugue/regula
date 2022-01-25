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
package fugue.resource_view

import data.tests.lib.inputs.arm_resource_view_01

test_resource_view_arm {
	arm_resource_view_01.mock_resources == expected
}

expected = {
	"Microsoft.Network/virtualNetworks/VNet1": {
		"_type": "Microsoft.Network/virtualNetworks",
		"apiVersion": "2018-10-01",
		"location": "switzerlandnorth",
		"resources": [{
			"apiVersion": "2018-10-01",
			"dependsOn": ["VNet1"],
			"name": "Subnet1",
			"type": "subnets",
			"properties": {"addressPrefix": "10.0.0.0/24"},
		}],
		"_parent_id": null,
		"name": "VNet1",
		"id": "Microsoft.Network/virtualNetworks/VNet1",
		"type": "Microsoft.Network/virtualNetworks",
		"_provider": "azurerm",
		"properties": {"addressSpace": {"addressPrefixes": ["10.0.0.0/16"]}},
	},
	"Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet2": {
		"_type": "Microsoft.Network/virtualNetworks/subnets",
		"apiVersion": "2018-10-01",
		"_parent_id": "Microsoft.Network/virtualNetworks/VNet1",
		"dependsOn": ["VNet1"],
		"name": "VNet1/Subnet2",
		"id": "Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet2",
		"type": "Microsoft.Network/virtualNetworks/subnets",
		"_provider": "azurerm",
		"properties": {"addressPrefix": "10.0.1.0/24"},
	},
	"Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet1": {
		"_type": "Microsoft.Network/virtualNetworks/subnets",
		"apiVersion": "2018-10-01",
		"_parent_id": "Microsoft.Network/virtualNetworks/VNet1",
		"dependsOn": ["VNet1"],
		"name": "Subnet1",
		"id": "Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet1",
		"type": "subnets",
		"_provider": "azurerm",
		"properties": {"addressPrefix": "10.0.0.0/24"},
	},
}
