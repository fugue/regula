# Writing Rules

Custom rule development generally has four parts:

- Writing the IaC to be used as [test input](test-inputs.md)
- Writing the rule (as documented on this page!)
- Writing the [rule tests](writing-tests.md)
- [Testing](testing-rules.md) the rules

## Types of rules

!!! tip
    For a tutorial on writing a simple custom rule, see [Example: Writing a Simple Rule](../examples/writing-a-rule.md).

Regula rules are written in [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) and use the same format as [Fugue Custom Rules](https://docs.fugue.co/rules.html). This means there are (currently) two kinds of rules: simple rules and advanced rules.

## Simple rules

Simple rules are useful when the policy applies to a single resource type only,
and you want to make simple yes/no decision.

```ruby
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

### Custom error messages and attributes (simple rules)

If you want to return more information to the user, you can also define a
custom error message in a simple rule.
This is done by writing a `deny[msg]` style rule.

```ruby
package rules.simple_rule_custom_message
resource_type = "aws_ebs_volume"

deny[msg] {
  not input.encrypted
  msg = "EBS volumes should be encrypted"
}
```

## Advanced rules

Advanced rules are harder to write, but more powerful. They allow you to
observe different kinds of resource types and decide which specific resources
are valid or invalid.

```ruby
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

The `fugue` API consists of these functions for advanced rules:

-   `fugue.resources(resource_type)` returns an object with all resources of
    the requested type.
-   `fugue.allow_resource(resource)` marks a resource as valid.
-   `fugue.deny_resource(resource)` marks a resource as invalid.
-   `fugue.deny_resource_with_message(resource, msg)` marks a resource as invalid and displays a custom `rule_message` in the report.
-   `fugue.missing_resource(resource_type)` marks a resource as **missing**. This is useful if you for example _require_ a log group to be present.
-   `fugue.missing_resource_with_message(resource_type, msg)` marks a resource as **missing** and displays a custom `rule_message` in the report.

### Custom error messages (advanced rules)

As stated above, the functions `fugue.deny_resource_with_message(resource, msg)` and `fugue.missing_resource_with_message(resource_type, msg)` allow Regula to display a custom `rule_message` in its report. This rule demonstrates both functions:

```ruby hl_lines="17 21"
package rules.account_password_policy

import data.fugue

resource_type = "MULTIPLE"

password_policies = fugue.resources("aws_iam_account_password_policy")

policy[r] {
  password_policy = password_policies[_]
  password_policy.minimum_password_length >= 16
  r = fugue.allow_resource(password_policy)
} {
  password_policy = password_policies[_]
  not password_policy.minimum_password_length >= 16
  msg = "Password policy is too short. It must be at least 16 characters."
  r = fugue.deny_resource_with_message(password_policy, msg)
} {
  count(password_policies) == 0
  msg = "No password policy exists."
  r = fugue.missing_resource_with_message("aws_iam_account_password_policy", msg)
}
```

Here's an example rule result demonstrating a missing resource message:

```json hl_lines="12"
    {
      "controls": [
        "CORPORATE-POLICY_1.1"
      ],
      "filepath": "main.tf",
      "input_type": "tf",
      "provider": "",
      "resource_id": "",
      "resource_type": "aws_iam_account_password_policy",
      "rule_description": "Per company policy, an AWS account must have a password policy, and it must require a minimum of 16 characters",
      "rule_id": "CUSTOM_0001",
      "rule_message": "No password policy exists.",
      "rule_name": "account_password_policy",
      "rule_raw_result": false,
      "rule_result": "FAIL",
      "rule_severity": "Medium",
      "rule_summary": "An AWS account must have a password policy requiring a minimum of 16 characters"
    },
```

## Adding rule metadata

You can add metadata to a rule to enhance Regula's [report](../report.md):

```ruby
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
    "severity": "Low",
    "rule_remediation_doc": "https://example.com"
  }
}
```

Regula supports the following metadata properties:

- `id`: Rule ID
- `title`: Short summary of the rule
- `description`: Longer description of the rule
- `controls`: An object where the key is the compliance family name and the value is an array of controls
- `severity`: One of `Critical`, `High`, `Medium`, `Low`, `Informational`
- `rule_remediation_doc`: A URL with instructions for remediating the rule

Here's an example rule result to show how this metadata looks in the report:

```json
    {
      "controls": [
        "CORPORATE-POLICY_1.1"
      ],
      "filepath": "../regula-ci-example/infra_tf/",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
      "rule_id": "CUSTOM_0001",
      "rule_message": "",
      "rule_name": "long_description",
      "rule_raw_result": false,
      "rule_remediation_doc": "https://example.com",
      "rule_result": "FAIL",
      "rule_severity": "Low",
      "rule_summary": "IAM policies must have a description of at least 25 characters",
      "source_location": [
        {
          "path": "../regula-ci-example/infra_tf/",
          "line": 6,
          "column": 1
        }
      ]
    }
```

## CloudFormation vs. Terraform vs. Kubernetes vs. ARM rules

CloudFormation rules are written the same way Terraform rules are, but require the line `input_type := "cfn"`, as shown in the simple rule below:

```ruby hl_lines="3"
package rules.cfn_ebs_volume_encryption

input_type := "cfn"

resource_type := "AWS::EC2::Volume"

default allow = false

allow {
  input.Encrypted == true
}
```

Kubernetes rules require the line `input_type := "k8s"`, as shown in the simple rule below:

```ruby hl_lines="9"
package rules.k8s_job_check

__rego__metadoc__ := {
	"id": "K8S_TEST_0123",
	"custom": {"severity": "Low"},
	"title": "Job containers should not be named `test`",
}

input_type := "k8s"

resource_type := "Job"

default deny = false

deny {
    input.spec.template.spec.containers[_].name == "test"
}
```

ARM rules (_in preview_) require the line `input_type := "arm"`, as shown in the simple rule below:

```ruby hl_lines="9"
package rules.arm_postgresql_tags

__rego__metadoc__ := {
	"id": "ARM_POSTGRESQL_001",
	"custom": {"severity": "Low"},
	"title": "Azure PostgreSQL servers should be tagged 'application:db'",
}

input_type := "arm"

resource_type = "Microsoft.DBforPostgreSQL/servers"

default allow = false

allow {
    input.tags.application == "db"
}
```

Terraform rules do not require `input_type` to be explicitly set.

Additionally, the `resource_type` is specified differently depending on the input type:

- [CloudFormation resource types](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html) (e.g., `AWS::EC2::Instance`)
- Terraform [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs), [Google Cloud](https://registry.terraform.io/providers/hashicorp/google/latest/docs) resource types (e.g., `aws_instance`)
- [Kubernetes resource types](https://kubernetes.io/docs/reference/kubectl/overview/#resource-types) (see the `KIND` column) (e.g., `Job`)
- [ARM templates](https://docs.microsoft.com/en-us/azure/templates/) (_in preview_) (e.g., `Microsoft.Network/virtualNetworks`)