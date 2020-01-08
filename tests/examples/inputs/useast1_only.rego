# This package was automatically generated from:
#
#     tests/rules/inputs/useast1_only.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.useast1_only
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {}
  },
  "configuration": {
    "provider_config": {
      "aws": {
        "name": "aws",
        "expressions": {
          "region": {
            "constant_value": "us-east-1"
          }
        }
      }
    },
    "root_module": {}
  }
}
