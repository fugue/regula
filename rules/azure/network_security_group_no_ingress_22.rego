# Network security group rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH).
# Removing unfettered connectivity to remote console services, such as SSH, 
# reduces a server's exposure to risk.

package rules.network_security_group_no_ingress_22

import data.fugue
import data.fugue.azure.network_security_group

resource_type = "MULTIPLE"

controls = {"CIS_Azure_1.1.0_6-1", "REGULA_R00019"}

network_security_rules = fugue.resources("azurerm_network_security_rule")
network_security_groups = fugue.resources("azurerm_network_security_group")

bad_port = 22

policy[p] {
  resource = network_security_rules[_]
  network_security_group.is_invalid_rule(resource, bad_port)
  p = fugue.deny_resource(resource)
} {
  resource = network_security_groups[_]
  network_security_group.is_invalid_group(resource, bad_port)
  p = fugue.deny_resource(resource)
} {
  resource = network_security_rules[_]
  not network_security_group.is_invalid_rule(resource, bad_port)
  p = fugue.allow_resource(resource)
} {
  resource = network_security_groups[_]
  not network_security_group.is_invalid_group(resource, bad_port)
  p = fugue.allow_resource(resource)
}