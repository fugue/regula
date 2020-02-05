package fugue.gcp.compute_firewall

range_includes_port(range, bad_port) {
  is_string(range)
  not contains(range, "-")
  to_number(range) == bad_port
} {
  is_string(range)
  contains(range, "-")
  port_range = regex.split("-", range)
  from_port = port_range[0]
  to_port = port_range[1]
  to_number(from_port) <= bad_port
  to_number(to_port) >= bad_port
}

is_zero_cidr(cidr) {cidr == "0.0.0.0/0"} {cidr == "::/0"}

includes_zero_cidr_to_port(firewall, bad_port) {
  allow_block = firewall.allow[_]
  port_range = allow_block.ports[_]
  range_includes_port(port_range, bad_port)

  ip_range = firewall.source_ranges[_]
  is_zero_cidr(ip_range)
}
