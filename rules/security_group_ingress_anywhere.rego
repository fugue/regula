package rules.security_group_ingress_anywhere

import data.fugue.regula.aws.security_group as sglib

resource_type = "aws_security_group"

whitelisted_ports = {80, 443}

whitelisted_ingress_block(block) {
  block.from_port == block.to_port
  whitelisted_ports[block.from_port]
}

bad_ingress_block(block) {
  sglib.ingress_zero_cidr(block)
  not sglib.ingress_self_only(block)
  not whitelisted_ingress_block(block)
}

default deny = false

deny {
  block = input.ingress[_]
  bad_ingress_block(block)
}
