package rules.no_ingress_except_80_443

import data.fugue

resource_type = "aws_security_group"

whitelisted_ports = {80, 443}

whitelisted_ingress_block(block) {
  block.from_port == block.to_port
  whitelisted_ports[block.from_port]
}

bad_ingress_block(block) {
  block.cidr_blocks[_] == "0.0.0.0/0"
  not whitelisted_ingress_block(block)
}

default deny = false

deny {
  block = input.ingress[_]
  bad_ingress_block(block)
}
