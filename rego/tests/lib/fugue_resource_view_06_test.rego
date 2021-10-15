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

import data.tests.lib.inputs.resource_view_06_tf_v0_15_infra_json as v0_15
import data.tests.lib.inputs.resource_view_06_tf_v1_0_infra_json as v1_0

test_resource_view_06 {
	v0_15.mock_resources == {
		"aws_security_group.parent": {
			"_provider": "aws",
			"_type": "aws_security_group",
			"description": "Managed by Terraform",
			"id": "aws_security_group.parent",
			"revoke_rules_on_delete": false,
			"tags": null,
			"timeouts": null,
			"vpc_id": "module.child1.module.grandchild1.aws_vpc.grandchild",
		},
		"aws_vpc.parent": {
			"_provider": "aws",
			"_type": "aws_vpc",
			"assign_generated_ipv6_cidr_block": false,
			"cidr_block": "10.0.0.0/16",
			"enable_dns_support": true,
			"id": "aws_vpc.parent",
			"instance_tenancy": "default",
			"tags": null,
		},
		"module.child1.aws_vpc.child": {
			"_provider": "aws",
			"_type": "aws_vpc",
			"assign_generated_ipv6_cidr_block": false,
			"cidr_block": "10.0.0.0/16",
			"enable_dns_support": true,
			"id": "module.child1.aws_vpc.child",
			"instance_tenancy": "default",
			"tags": null,
		},
		"module.child1.module.grandchild1.aws_security_group.grandchild": {
			"_provider": "aws",
			"_type": "aws_security_group",
			"description": "Managed by Terraform",
			"id": "module.child1.module.grandchild1.aws_security_group.grandchild",
			"revoke_rules_on_delete": false,
			"tags": null,
			"timeouts": null,
			"vpc_id": "module.child1.module.grandchild1.aws_vpc.grandchild",
		},
		"module.child1.module.grandchild1.aws_vpc.grandchild": {
			"_provider": "aws",
			"_type": "aws_vpc",
			"assign_generated_ipv6_cidr_block": false,
			"cidr_block": "10.0.0.0/16",
			"enable_dns_support": true,
			"id": "module.child1.module.grandchild1.aws_vpc.grandchild",
			"instance_tenancy": "default",
			"tags": null,
		},
		"module.child2.aws_security_group.child": {
			"_provider": "aws",
			"_type": "aws_security_group",
			"description": "Managed by Terraform",
			"id": "module.child2.aws_security_group.child",
			"revoke_rules_on_delete": false,
			"tags": null,
			"timeouts": null,
			"vpc_id": "module.child1.module.grandchild1.aws_vpc.grandchild",
		},
		"module.child2.aws_vpc.child": {
			"_provider": "aws",
			"_type": "aws_vpc",
			"assign_generated_ipv6_cidr_block": false,
			"cidr_block": "10.0.0.0/16",
			"enable_dns_support": true,
			"id": "module.child2.aws_vpc.child",
			"instance_tenancy": "default",
			"tags": null,
		},
	}
	v0_15.mock_resources == v1_0.mock_resources
}
