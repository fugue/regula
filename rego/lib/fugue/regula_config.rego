# This package declares an empty set of rules and waivers to make sure user
# configuration have to follow these types with incremental definitions.
package fugue.regula.config

waivers[waiver] {
  waiver := {
    "resource_id": "*",
    "resource_type": "*",
    "rule_id": "*",
    "rule_name": "*",
    "filepath": "*",
  }
  false
}

rules[rule] {
  rule := {"rule_id": "*", "rule_name": "*", "status": "ENABLED"}
  false
}
