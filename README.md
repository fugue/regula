# Regula

-   [Introduction](#introduction)
-   [How does Regula work?](#how-does-regula-work)
-   [Running Regula locally](#running-regula-locally)
-   [Regula rules](#regula-rules)
    -   [Simple rules](#simple-rules)
    -   [Advanced rules](#advanced-rules)
    -   [Rule library](#rule-library)
-   [Compliance controls](#compliance-controls)
-   [Regula as a GitHub Action](#regula-as-a-github-action)
-   [Development](#development)
    -   [Directory structure](#directory-structure)
    -   [Adding a test](#adding-a-test)
    -   [Debugging a rule with fregot](#debugging-a-rule-with-fregot)
    -   [Locally producing a report](#locally-producing-a-report)

## Introduction

Regula is a tool that evaluates Terraform infrastructure-as-code for potential security misconfigurations and compliance violations prior to deployment.

Regula includes a library of rules written in Rego, the policy language used by the Open Policy Agent ([opa]) project. Regula works with your favorite CI/CD tools such as Jenkins, Circle CI, and AWS CodePipeline; we’ve included a GitHub Actions example so you can get started quickly. Where relevant, we’ve mapped Regula policies to the CIS AWS Foundations Benchmark so you can assess your compliance posture.

## How does Regula work?

There are two parts to Regula. The first is a [shell script](/bin/regula)
that generates a [terraform] plan in JSON format, ready for consumption by
[opa].

The second part is a Rego framework that:

-   Merges resource info from `planned_values` and `configuration` in the
    terrraform plan into a more conveniently accessible format.
-   It looks for [rules](#regula-rules) and executes them.
-   It creates a report with the results of all rules and a
    [control mapping](#control-mapping) in the output.

## Running Regula locally

    ./bin/regula [TERRAFORM_PATH] [REGO_PATHS...]

`TERRAFORM_PATH` is the directory where your terraform configuration files are
located.

`REGO_PATHS` are the directories that need to be searched for Rego code.  This
should at least include `lib/`.

Some examples:

-   `./bin/regula ../my-tf-infra .`: conveniently check `../my-tf-infra` against
    all rules in this main repository.
-   `./bin/regula ../my-tf-infra lib rules/t2_only.rego`: run Regula using only
    the specified rule.
-   `./bin/regula ../my-tf-infra lib ../custom-rules`: run Regula using a
    directory of custom rules.

It is also possible to set the name of the `terraform` executable; which is
useful if you have several versions installed:

    env TERRAFORM=terraform-v0.12.18 ./bin/regula ../regula-action-example/ lib

## Regula rules

Regula rules are written in standard [Rego] and use a similar format to
[Fugue Custom Rules].  This means there are (currently) two kinds of rules:
simple rules and advanced rules.

### Simple rules

Simple rules are useful when the policy applies to a single resource type only,
and you want to make simple yes/no decision.

```ruby
# Rules mules always be located right below the `rules` package.
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

### Advanced rules

Advanced rules are harder to write, but more powerful.  They allow you to
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

The `fugue` API consists of four functions:

-   `fugue.resources(resource_type)` returns an object with all resources of
    the requested type.
-   `fugue.allow_resource(resource)` marks a resource as valid.
-   `fugue.deny_resource(resource)` marks a resource as invalid.
-   `fugue.missing_resource(resource_type)` marks a resource as **missing**.
    This is useful if you for example _require_ a log group to be present.

### Rule library

| Provider | Service    | Rule Name                              | Rule Summary                                                                                               |
|----------|------------|----------------------------------------|------------------------------------------------------------------------------------------------------------|
| AWS      | IAM        | iam\_user\_attached_policy              | IAM policies should not be attached directly to users                                                      |
| AWS      | IAM        | iam\_admin\_policy                       | IAM policies should not have full "*:*" administrative privileges                                          |
| AWS      | VPC        | vpc\_flow\_logging_enabled               | VPC flow logging should be enabled                                                                         |
| AWS      | VPC        | security\_group\_no\_ingress_22           | VPC security group rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH)                       |
| AWS      | VPC        | security\_group\_no\_ingress\_3389         | VPC security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol) |
| AWS      | VPC        | security\_group\_ingress\_only\_80\_443     | VPC security group rules should not permit ingress from '0.0.0.0/0' except to ports 80 and 443             |
| AWS      | CloudTrail | cloudtrail\_log\_file\_validation\_enabled | CloudTrail log file validation should be enabled                                                           |
| AWS      | KMS        | kms\_rotate                             | KMS CMK rotation should be enabled                                                                         |
| AWS      | EBS        | ebs\_volume\_encrypted                   | EBS volume encryption should be enabled

### Rule examples

Whereas the rules included in the Regula rules library are generally applicable, we've built a rule examples that look at tags, region restrictions, and EC2 instance usage that should be modified to fit user/organization policies.

| Provider | Service | Rule Name             | Rule Description                                                 |
|----------|---------|-----------------------|------------------------------------------------------------------|
| AWS      | Tags    | tag\_all\_resources   | Checks whether resources that are taggable have at least one tag |
| AWS      | Regions | region\_useast1\_only | Restricts resources to a given AWS region                        |
| AWS      | EC2     | ec2\_t2\_only | Restricts instances to a whitelist of instance types             |

## Compliance controls

```ruby
In Regula, _rules_ provide the lower-level implementation details, and
_controls_ are compliance controls (e.g., CIS AWS Foundations Benchmark 4-1) that map to sets of rules.  Controls can
be specified within the rules: just add `controls` set.

# Rules mules always be located right below the `rules` package.
package rules.my_simple_rule

# Simple rules must specify the resource type they will police.
resource_type = "aws_ebs_volume"

# Controls.
controls = {"CIS_1-16"}

# Rule logic
...
```

Regula's JSON output will then contain a controls section to show which
rules passed and failed:

```json
"controls": {
  "CIS_1-16": {
    "rules": [
      "user_attached_policy"
    ],
    "valid": true
  },
  ...
}
```

## Invoking your own rules

TODO

## Regula as a GitHub Action

See <https://github.com/jaspervdj-luminal/regula-action>.

## Development

### Directory structure

 -  `bin/`: the main Regula script that calls `terraform` & `opa`.
 -  `lib/`: the OPA library code to evaluate rules and mangle input.
 -  `rules/`: a collection of rules.  We may split this up further as the number
    of rules increases.
 -  `examples/`: a collection of example rules that you can use as inspiration
     for your own rules.
 -  `scripts/`: scripts for development; currently only a script to generate
    test input.
 -  `tests/`:
      *  `tests/lib`: internal tests for the library.
      *  `tests/rules/`: tests for the various rules.
      *  `tests/rules/input`: terraform files that can be used to generate Rego
         files.
      *  `tests/examples/`: tests for the example rules.
      *  `tests/rules/input`: input files for the example rules.

### Adding a test

If you would like to add a rule, we recommend starting with a test.
Put your terraform code in a file in `tests/rules/inputs`; for example
[t2_only.tf](/tests/rules/inputs/t2_only.tf). From this, you can generate a mock
input by running:

    bash scripts/generate-test-inputs.sh

The mock input will then be placed in a `.rego` file with the same name, in our
case [t2_only.rego](/tests/rules/inputs/t2_only.rego). It is then customary to
add the actual tests in a name with the same file, but outside of the `inputs/`
subdirectory. In this case, that would be [here](/tests/rules/t2_only.rego).

### Debugging a rule with fregot

Once you have generated the mock input, it is easy to debug a rule with
[fregot].  Fire up `fregot` with the right directories and set a breakpoint on
the rule you are trying to debug:

    $ fregot repl lib rules tests
    F u g u e   R E G O   T o o l k i t
    fregot v0.7.2 repl - use :help for usage info
    repl% :break data.rules.t2_only.allow

Now, we can just evaluate the entire report with the mock input.  If your rule
is triggered, that will drop you into a debug prompt:

    repl% data.fugue.regula.report with input as data.tests.rules.t2_only.mock_input
    19|   valid_instance_types[input.instance_type]
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From here, you can evaluate anything in context; such as `input` to look at the
resource, or any other auxiliary rules such as `valid_instance_types` in this
example.

### Locally producing a report

In some cases, you may want to produce the steps that Regula performs manually.
If that is something you want to step through, this section is for you.

We first need to obtain a JSON-formatted terraform plan.  In order to do get
that, you can use:

    terraform init
    terraform plan -refresh=false -out=plan.tfplan
    terraform show -json plan.tfplan >input.json

This gives you `input.json`.  Now you can test this input against the rules by
evaluating `data.fugue.regula.report` with OPA.  In order to do that, point OPA
to the input file, and the regula project directory.

    opa eval -d /path/to/regula --input input.json 'data.fugue.regula.report'

Or using `fregot`:

    fregot eval --input input.json 'data.fugue.regula.report' . | jq

If all goes well, you should now see the results for each rule.

[opa]: https://www.openpolicyagent.org/
[fregot]: https://github.com/fugue/fregot
[terraform]: https://www.terraform.io/
[Rego]: https://www.openpolicyagent.org/docs/latest/policy-language/
[Fugue Custom Rules]: https://docs.fugue.co/rules.html
