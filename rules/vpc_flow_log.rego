package rules.vpc_flow_log

import data.fugue

resource_type = "MULTIPLE"
controls = {"CIS_2-9", "REGULA_R00003"}

# VPC flow logging should be enabled when VPCs are created. AWS VPC Flow Logs provide visibility into network traffic that traverses the AWS VPC. Users can use the flow logs to detect anomalous traffic or insight during security workflows.

# every flow log in the template
flow_logs = fugue.resources("aws_flow_log")
# every VPC in the template
vpcs = fugue.resources("aws_vpc")

# VPC is valid if there is an associated flow log
is_valid_vpc(vpc) {
    vpc.id == flow_logs[_].vpc_id
}

policy[p] {
  resource = vpcs[_]
  not is_valid_vpc(resource)
  p = fugue.deny_resource(resource)
} {
  resource = vpcs[_]
  is_valid_vpc(resource)
  p = fugue.allow_resource(resource)
}
