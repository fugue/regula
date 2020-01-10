# The following multi-resource type validation checks ALL supported taggable
# AWS resources for a tag named Stage with a value Prod. Comment out the
# resources you don't use in any environment.
package rules.tag_all_resources

import data.fugue

resource_type = "MULTIPLE"

taggable_resource_types = {
  "aws_cloudfront_distribution",
  "aws_cloudwatch_metric_alarm",
  "aws_cloudwatch_event_rule",
  "aws_cloudwatch_log_group",
  "aws_cognito_user_pool",
  "aws_config_config_rule",
  "aws_dynamodb_table",
  "aws_customer_gateway",
  "aws_vpc_dhcp_options",
  "aws_eip",
  "aws_instance",
  "aws_internet_gateway",
  "aws_network_acl",
  "aws_network_interface",
  "aws_route_table",
  "aws_security_group",
  "aws_subnet",
  "aws_ebs_volume",
  "aws_vpc",
  "aws_vpn_connection",
  "aws_vpn_gateway",
  "aws_elb",
  "aws_lb",
  "aws_lb_target_group",
  "aws_elasticache_cluster",
  "aws_kms_key",
  "aws_lambda_function",
  "aws_redshift_cluster",
  "aws_redshift_parameter_group",
  "aws_redshift_subnet_group",
  "aws_db_instance",
  "aws_db_parameter_group",
  "aws_db_subnet_group",
  "aws_db_event_subscription",
  "aws_db_option_group",
  "aws_route53_health_check",
  "aws_route53_zone",
   "aws_s3_bucket",
   "aws_vpc",
  "aws_sfn_state_machine"
}

taggable_resources[id] = resource {
  some resource_type
  taggable_resource_types[resource_type]
  resources = fugue.resources(resource_type)
  resource = resources[id]
}

is_improperly_tagged(resource) {
  count(resource.tags[_]) < 6
}

policy[r] {
   resource = taggable_resources[_]
   is_improperly_tagged(resource)
   r = fugue.deny_resource(resource)
} {
   resource = taggable_resources[_]
   not is_improperly_tagged(resource)
   r = fugue.allow_resource(resource)
}