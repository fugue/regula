# This helper rego code works for Azure "no ingress" rules

package fugue.azure.network_security_group

is_invalid_rule(resource, bad_port) {
    resource.access == "Allow"
    resource.direction == "Inbound"
    is_bad_port(resource, bad_port)
    is_bad_source_address(resource)
}

is_invalid_group(resource, bad_port) {
    rules_block = resource.security_rule[_]
    is_invalid_rule(rules_block, bad_port)
}

is_bad_port(resource, bad_port) {
    resource.destination_port_range == "*"
} {
    resource.destination_port_range == format_int(bad_port, 10)
} {
    is_string(resource.destination_port_range)
    contains(resource.destination_port_range, "-")
    split(resource.destination_port_range, "-", [lo, hi])
    bad_port >= to_number(lo)
    bad_port <= to_number(hi)
} {
    port_block = resource.destination_port_ranges[_]
    is_bad_port_block(port_block, bad_port)
}

is_bad_port_block(port, bad_port) {
    port == "*"
} {
    port == format_int(bad_port, 10)
} {
    is_string(port)
    contains(port, "-")
    split(port, "-", [lo, hi])
    bad_port >= to_number(lo)
    bad_port <= to_number(hi)
}

# https://docs.microsoft.com/en-us/azure/virtual-network/security-overview#security-rules
is_bad_source_address(resource) {
    prefixes = {"*", "0.0.0.0", "0.0.0.0/0", "Internet", "internet", "Any", "any"}
    prefixes[resource.source_address_prefix]
} {
    source_address_block = resource.source_address_prefixes[_]
    is_bad_source_address_block(source_address_block)
}

is_bad_source_address_block(source_address_block) {
    prefixes = {"*", "0.0.0.0", "0.0.0.0/0", "Internet", "internet", "Any", "any"}
    prefixes[source_address_block]
}