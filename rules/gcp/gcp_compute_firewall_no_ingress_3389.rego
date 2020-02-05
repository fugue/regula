# VPC firewall rules should not permit unrestricted access from the internet
# to port 3389 (RDP). Removing unfettered connectivity to remote console services,
# such as RDP, reduces a server's exposure to risk.

package rules.gcp_compute_firewall_no_ingress_3389

controls = {"CIS_GCP_3-7", "REGULA_R00012"}
resource_type = "google_compute_firewall"

bad_port = 3389

default deny = false

ingress_includes_port(port) {
  is_string(port)
  not contains(port, "-")
  to_number(port) == bad_port
} 
{
  is_string(port)
  contains(port, "-")
  port_range = regex.split("-", port)
  from_port = port_range[0]
  to_port = port_range[1]
  to_number(from_port) <= bad_port
  to_number(to_port) >= bad_port
}

ingress_zero_cidr(cidr) {
  cidr == "0.0.0.0/0"
} {
  cidr == "::/0"
}

check_allow(allow_block) {
  port_block = allow_block.ports[_]
  ingress_includes_port(port_block)
}

deny {
  allow_block = input.allow[_]
  check_allow(allow_block)

  ip_range = input.source_ranges[_]
  ingress_zero_cidr(ip_range)
}