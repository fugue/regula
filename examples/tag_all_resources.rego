# The following multi-resource type validation checks ALL supported taggable
# AWS resources for a tag named Stage with a value Prod. Comment out the
# resources you don't use in any environment.
package rules.tag_all_resources

import data.fugue

resource_type = "MULTIPLE"

taggable_resource_types = {
  #"aws_cloudfront_distribution",
  #"aws_cloudwatch_metric_alarm",
  #"AWS.CloudWatchEvents.Rule",
  #"AWS.CloudWatchLogs.LogGroup",
  # "AWS.Cognito.UserPool",
  # "AWS.Config.Rule",
  # "AWS.DynamoDB.Table",
  # "AWS.EC2.CustomerGateway",
  # "AWS.EC2.DhcpOptions",
  # "AWS.EC2.ElasticIP",
  # "AWS.EC2.Instance",
  # "AWS.EC2.InternetGateway",
  # "AWS.EC2.NetworkACL",
  # "AWS.EC2.NetworkInterface",
  # "AWS.EC2.RouteTable",
  # "AWS.EC2.SecurityGroup",
  # "AWS.EC2.Subnet",
  # "AWS.EC2.Volume",
  # "AWS.EC2.Vpc",
  # "AWS.EC2.VpnConnection",
  # "AWS.EC2.VpnGateway",
  # "AWS.ELB.LoadBalancer",
  # "AWS.ELBv2.LoadBalancer",
  # "AWS.ELBv2.TargetGroup",
  # "AWS.ElastiCache.Cluster",
  # "aws_kms_key"
  # "AWS.Lambda.Function",
  # "AWS.Redshift.Cluster",
  # "AWS.Redshift.ParameterGroup",
  # "AWS.Redshift.SubnetGroup",
  # "AWS.RDS.Instance",
  # "AWS.RDS.ParameterGroup",
  # "AWS.RDS.SubnetGroup",
  # "AWS.RDS.EventSubscription",
  # "AWS.RDS.OptionGroup",
  # "AWS.Route53.HealthCheck",
  # "AWS.Route53.Zone",
   "aws_s3_bucket",
   "aws_vpc"
  # "AWS.SFN.StateMachine"
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