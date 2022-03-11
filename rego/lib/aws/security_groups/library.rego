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
package aws.security_groups.library

import data.fugue
import data.fugue.utils

# Does an ingress block have the zero ("0.0.0.0/0" or "::/0") CIDR?
rule_zero_cidr(rule) {
	zero_cidr(rule.cidr_blocks[_])
}

rule_zero_cidr(rule) {
	zero_cidr(rule.ipv6_cidr_blocks[_])
}

zero_cidr(cidr) {
	cidr == "0.0.0.0/0"
}

zero_cidr(cidr) {
	cidr == "::/0"
}

# Does a security group only allow traffic to itself?  This is a common
# exception to rules.
rule_self_only(rule) {
	rule.self == true
	object.get(rule, "cidr_blocks", []) == []
	object.get(rule, "ipv6_cidr_blocks", []) == []
}

# Does an ingress block allow a given port?
rule_includes_port(rule, port) {
	rule.from_port <= port
	rule.to_port >= port
}

rule_includes_port(rule, port) {
	rule.from_port == 0
	rule.to_port == 0
}

# Does an ingress block allow all ports?
rule_all_ports(rule) {
	rule.from_port <= 0
	rule.to_port >= 65535
}

rule_all_ports(rule) {
	rule.from_port == 0
	rule.to_port == 0
}

# Does an ingress block allow access from the zero CIDR to a given port?
rule_zero_cidr_to_port(ib, port) {
	rule_zero_cidr(ib)
	rule_includes_port(ib, port)
	not rule_self_only(ib)
}

# Does any ingress block satisfy `ingress_zero_cidr_to_port`?
security_group_ingress_zero_cidr_to_port(sg, port) {
	rule_zero_cidr_to_port(sg.ingress[_], port)
}

###############################################################################
# Connectivity library.

security_groups = fugue.resources("aws_security_group")

# Lookup table to find security groups by provider (region) & name.  Names are
# not unique.
security_groups_by_provider_name = {qualified_name: global_ids |
	security_groups[_] = sg1
	qualified_name = sprintf("%s/%s", [utils.provider(sg1), sg1.name])
	global_ids = {global_id |
		security_groups[global_id] = sg2
		qualified_name_2 = sprintf("%s/%s", [utils.provider(sg2), sg2.name])
		qualified_name = qualified_name_2
	}
}

# Lookup table to find security groups by provider (region) & ID.
security_groups_by_provider_id = {qualified_id: global_id |
	security_groups[global_id] = sg
	qualified_id = sprintf("%s/%s", [utils.provider(sg), sg.id])
}

# Grab IDs or names from something that is possible an array.  Remove null
# values.
get_ids(arr) = ret {
	ret := [item | item = utils.as_array(arr)[_]; item != null]
}

# All security groups connecting to a resource.
security_groups_ids_by_resource = {resource_id: sgs |
	resource = all_resources[resource_id]
	sg_attrs = types_with_security_groups[resource._type]
	p = utils.provider(resource)
	all_ids = {the_sg_id |
		sg_attr = sg_attrs[_]
		the_sg_id = resource[sg_attr][_]
	}

	sgs = {gsgid |
		all_ids[sgid]
		gsgid = security_groups_by_provider_id[sprintf("%s/%s", [p, sgid])]
	}

	count(sgs) > 0
}

# All resources by ID.
all_resources = {resource_id: resource |
	fugue.input_resource_types[resource_type]
	types_with_security_groups[resource_type]
	resources = fugue.resources(resource_type)
	resource = resources[resource_id]
}

# Resource types with security group attributes
types_with_security_groups = {
	"aws_alb": ["security_groups"],
	"aws_apigatewayv2_vpc_link": ["security_group_ids"],
	"aws_cloudhsm_v2_cluster": ["security_group_id"],
	"aws_dax_cluster": ["security_group_ids"],
	"aws_db_instance": ["security_group_names", "vpc_security_group_ids"],
	"aws_default_vpc": ["default_security_group_id"],
	"aws_directory_service_directory": ["security_group_id"],
	"aws_dms_replication_instance": ["vpc_security_group_ids"],
	"aws_docdb_cluster": ["vpc_security_group_ids"],
	"aws_ec2_client_vpn_network_association": ["security_groups"],
	"aws_efs_mount_target": ["security_groups"],
	"aws_elasticache_cluster": ["security_group_ids", "security_group_names"],
	"aws_elasticache_replication_group": ["security_group_ids", "security_group_names"],
	"aws_elasticache_security_group": ["security_group_names"],
	"aws_elb": ["security_groups", "source_security_group", "source_security_group_id"],
	"aws_fsx_lustre_file_system": ["security_group_ids"],
	"aws_fsx_windows_file_system": ["security_group_ids"],
	"aws_instance": ["security_groups", "vpc_security_group_ids"],
	"aws_launch_configuration": ["security_groups", "vpc_classic_link_security_groups"],
	"aws_launch_template": ["security_group_names", "vpc_security_group_ids"],
	"aws_lb": ["security_groups"],
	"aws_mq_broker": ["security_groups"],
	"aws_neptune_cluster": ["vpc_security_group_ids"],
	"aws_network_interface": ["security_groups"],
	"aws_network_interface_sg_attachment": ["security_group_id"],
	"aws_rds_cluster": ["vpc_security_group_ids"],
	"aws_redshift_cluster": ["cluster_security_groups", "vpc_security_group_ids"],
	"aws_route53_resolver_endpoint": ["security_group_ids"],
	"aws_sagemaker_notebook_instance": ["security_groups"],
	"aws_security_group_rule": ["security_group_id", "source_security_group_id"],
	"aws_spot_instance_request": ["security_groups", "vpc_security_group_ids"],
	"aws_vpc_endpoint": ["security_group_ids"],
	"aws_workspaces_directory": ["workspace_security_group_id"],
}

# Is a resource a load balancer?
resource_is_load_balancer(resource) {
	resource._type == "aws_elb"
}

resource_is_load_balancer(resource) {
	resource._type == "aws_lb"
}

resource_is_load_balancer(resource) {
	resource._type == "aws_alb"
}

# Is a resource allowed in a public security group?
resource_allowed_public(resource) {
	resource_is_load_balancer(resource)
}

resource_allowed_public(resource) {
	resource._type == "aws_network_interface"
}

# Create a global mapping of security group IDs to resources connected to
# that security group.  A resource can be connected to multiple security
# groups.
resources_by_security_group = {global_sg_id: sg_resources |
	security_groups[global_sg_id] = security_group
	sg_resources = {resource_id: resource |
		security_groups_ids_by_resource[resource_id][global_sg_id]
		resource = all_resources[resource_id]
	}
}

# Security groups that have at least one load balancer.
load_balancer_security_groups = {global_sg_id: sg |
	sg = security_groups[global_sg_id]
	resource_is_load_balancer(resources_by_security_group[global_sg_id][_])
}

# Deny a security group with a message if it allows traffic from from 0.0.0.0/0
# to port N.  An exception is made for security groups that are connected only
# to resources that are safe to be public (e.g. load balancers).
deny_security_group_ingress_zero_cidr_to_port_lb(global_sg_id, sg, port) = msg {
	security_group_ingress_zero_cidr_to_port(sg, port)
	load_balancer_security_groups[global_sg_id]
	other_resources = [other_resource |
		other_resource = resources_by_security_group[global_sg_id][_]
		not resource_allowed_public(other_resource)
	]

	count(other_resources) > 0
	msg = sprintf(
		"This security group allows from traffic from 0.0.0.0/0 to port %d and is connected to a non-LB resource %s",
		[port, other_resources[0].id],
	)
} else = msg {
	security_group_ingress_zero_cidr_to_port(sg, port)
	not load_balancer_security_groups[global_sg_id]
	msg = sprintf(
		"This security group allows traffic from 0.0.0.0/0 to port %d",
		[port],
	)
}

instances = fugue.resources("aws_instance")

db_instances = fugue.resources("aws_db_instance")

# Security groups connected to EC2 instances.
ec2_connected_security_groups := ret {
	# Scan EC2 instances for names and IDs.
	ids := {id |
		id := utils.as_array(instances[_].security_groups)[_]
	} | {id |
		id := utils.as_array(instances[_].vpc_security_group_ids)[_]
	}

	names := {name |
		name := utils.as_array(instances[_].security_groups)[_]
	}

	# Construct the IDs first.
	global_ids := {global_sg_id |
		sg := security_groups[global_sg_id]
		names[sg.name]
	} | {global_sg_id |
		sg := security_groups[global_sg_id]
		ids[sg.id]
	}

	# Now do the mapping.
	ret := {global_sg_id: sg |
		sg := security_groups[global_sg_id]
		global_ids[global_sg_id]
	}
}

# Security groups connected to RDS instances.
rds_connected_security_groups = {global_sg_id: sg |
	security_groups[global_sg_id] = sg
	sg_ids = utils.as_array(db_instances[_].vpc_security_group_ids)
	sg_ids[_] == sg.id
}
