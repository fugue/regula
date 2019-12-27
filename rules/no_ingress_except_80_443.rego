package rules.no_ingress_except_80_443

import data.fugue

resource_type = "MULTIPLE"

security_groups = fugue.resources("aws_security_group")

valid_ports(sg) {
  sg.ingress[i].from_port == 80
  sg.ingress[i].to_port == 80
} {
  sg.ingress[i].from_port == 443
  sg.ingress[i].to_port == 443
}

policy[p] {
  security_group = security_groups[_]
  security_group.ingress[i].cidr_blocks[_] == "0.0.0.0/0"
  not valid_ports(security_group) 
  p = fugue.deny_resource(security_group)
} {
  security_group = security_groups[_]
  security_group.ingress[i].cidr_blocks[_] == "0.0.0.0/0"
  valid_ports(security_group)
  p = fugue.allow_resource(security_group)
}