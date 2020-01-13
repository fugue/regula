package rules.security_group_ingress_anywhere

import data.fugue

resource_type = "aws_security_group"

whitelisted_ports = {80, 443}

whitelisted_ingress_block(block) {
  block.from_port == block.to_port
  whitelisted_ports[block.from_port]
}

anywhere_cidr(cidr) {
  cidr == "0.0.0.0/0"
} {
  cidr == "::/0"
}

bad_ingress_block(block) {
  anywhere_cidr(block.cidr_blocks[_])
  not whitelisted_ingress_block(block)
}

default deny = false

deny {
  block = input.ingress[_]
  bad_ingress_block(block)
}
