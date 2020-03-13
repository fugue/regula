# Conftest integration package for Regula.
package main

import data.fugue.regula

deny[msg] {
  # Our information comes from the report.  We select all invalid resources
  # and will generate a deny message for each of them.
  resource = regula.report.rules[rule_name].resources[resource_name]
  resource.valid == false

  # Generate a message for each invalid resource.
  #
  # Since we have more information available in the report; we should look
  # into whether or not we can use conftests's structured output.
  msg = concat(": ", [
    "regula",
    regula.report_rule_message(rule_name, resource_name, resource.message)
  ])
}
