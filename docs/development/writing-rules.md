# Writing Rules

!!! tip
    For a tutorial on writing a simple custom rule, see [Example: Writing a Simple Rule](../examples/writing-a-rule.md).

Regula rules are written in [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) and use the same format as [Fugue Custom Rules](https://docs.fugue.co/rules.html). This means there are (currently) two kinds of rules: simple rules and advanced rules.

## Simple rules

Simple rules are useful when the policy applies to a single resource type only,
and you want to make simple yes/no decision.

```rego
# Rules must always be located right below the `rules` package.
package rules.my_simple_rule

# Simple rules must specify the resource type they will police.
resource_type = "aws_ebs_volume"

# Simple rules must specify `allow` or `deny`.  For this example, we use
# an `allow` rule to check that the EBS volume is encrypted.
default allow = false
allow {
  input.encrypted == true
}
```

### Custom error messages and attributes

If you want to return more information to the user, you can also define a
custom error message in a simple rule.
This is done by writing a `deny[msg]` style rule.

```rego
package rules.simple_rule_custom_message
resource_type = "aws_ebs_volume"

deny[msg] {
  not input.encrypted
  msg = "EBS volumes should be encrypted"
}
```

It's also possible to include more metadata than just the error message, such
as the path of the offending attribute.

```rego
package rules.simple_rule_custom_message
resource_type = "aws_ebs_volume"

deny[params] {
  not input.encrypted
  params = {
    "message": "EBS volumes should be encrypted",
    "attribute": ["encrypted"]
  }
}
```

## Advanced rules

Advanced rules are harder to write, but more powerful. They allow you to
observe different kinds of resource types and decide which specific resources
are valid or invalid.

```rego
# Rules still must be located in the `rules` package.
package rules.user_attached_policy

# Advanced rules typically use functions from the `fugue` library.
import data.fugue

# We mark an advanced rule by setting `resource_type` to `MULTIPLE`.
resource_type = "MULTIPLE"

# `fugue.resources` is a function that allows querying for resources of a
# specific type.  In our case, we are just going to ask for the EBS volumes
# again.
ebs_volumes = fugue.resources("aws_ebs_volume")

# Auxiliary function.
is_encrypted(resource) {
  resource.encrypted == true
}

# Regula expects advanced rules to contain a `policy` rule that holds a set
# of _judgements_.
policy[p] {
  resource = ebs_volumes[_]
  is_encrypted(resource)
  p = fugue.allow_resource(resource)
} {
  resource = ebs_volumes[_]
  not is_encrypted(resource)
  p = fugue.deny_resource(resource)
}
```

The `fugue` API consists of four functions:

-   `fugue.resources(resource_type)` returns an object with all resources of
    the requested type.
-   `fugue.allow_resource(resource)` marks a resource as valid.
-   `fugue.deny_resource(resource)` marks a resource as invalid.
-   `fugue.missing_resource(resource_type)` marks a resource as **missing**.
    This is useful if you for example _require_ a log group to be present.

## Adding rule metadata

You can add metadata to a rule to enhance Regula's [report](../report.md):

```
__rego__metadoc__ := {
  "id": "CUSTOM_0001",
  "title": "IAM policies must have a description of at least 25 characters",
  "description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
  "custom": {
    "controls": {
      "CORPORATE-POLICY": [
        "CORPORATE-POLICY_1.1"
      ]
    },
    "severity": "Low"
  }
}
```

Regula supports the following metadata properties:

- `id`: Rule ID
- `title`: Short summary of the rule
- `description`: Longer description of the rule
- `controls`: An object where the key is the compliance family name and the value is an array of controls
- `severity`: One of `Critical`, `High`, `Medium`, `Low`, `Informational`

Here's an example rule result to show how this metadata looks in the report:

```json
    {
      "controls": [
        "CORPORATE-POLICY_1.1"
      ],
      "filepath": "../regula-ci-example/infra_tf/",
      "platform": "terraform",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
      "rule_id": "CUSTOM_0001",
      "rule_message": "",
      "rule_name": "long_description",
      "rule_result": "FAIL",
      "rule_severity": "Low",
      "rule_summary": "IAM policies must have a description of at least 25 characters"
    }
```
