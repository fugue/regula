package rules.dockerfile.user_exists

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_4.1"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_4.1.1"
      ]
    },
    "severity": "Medium"
  },
  "description": "SQL Server auditing should be enabled. The Azure platform allows a SQL server to be created as a service. Enabling auditing at the server level ensures that all existing and newly created databases on the SQL server instance are audited. Auditing policy applied on the SQL database does not override auditing policy and settings applied on the particular SQL server where the database is hosted.",
  "id": "FG_R00282",
  "title": "SQL Server auditing should be enabled"
}

input_type = "dockerfile"

#resource_type = "Dockerfile"

default allow = false

#instr := input.commands[_]
#allow {
#    {
#        instr.type == "USER"
#    }
#} 
