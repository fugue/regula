# Regula

## Introduction

Regula is a very light (less than 100 lines of bash; and you don't every really
need to use this) framework around [opa] and [terraform] that allows you to more
easily implement pre-flight policy checks, by providing a rigid structure for
rules.

## How does Regula work?

There are two big parts to Regula. The first is a [shell script](/bin/regula)
that generates a [terraform] plan in JSON format, ready for consumption by
[opa].

The second part is a Rego framework that:

 -  It merges resource info from `planned_values` and `configuration` in the
    terrraform plan into a more conveniently accessible format.
 -  It looks for [rules](#regula-rules) and executes them.
 -  It creates a report with the results of all rules and a
    [control mapping](#control-mapping) in the output.

## Running Regula locally

    ./bin/regula [TERRAFORM_PATH] [REGO_PATHS...]

`TERRAFORM_PATH` is the directory where your terraform configuration files are
located.

`REGO_PATHS` are the directories that need to be searched for Rego code.  This
should at least include `lib/`.

Some examples:

 -  `./bin/regula ../my-tf-infra .` conveniently check `../my-tf-infra` against
    all rules in this main repository.
 -  `./bin/regula ../my-tf-infra lib rules/t2_only.rego` run Regula using only
    the specified rule.
 -  `./bin/regula ../my-tf-infra lib ../custom-rules` run Regula using a
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

## Control mapping

```ruby
In Regula, _rules_ provide the lower-level implementation details, and
_controls_ are policies that map to sets of rules.  Controls can
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

## Running Regula as a GitHub Action

See <https://github.com/jaspervdj-luminal/regula-action>.

## Development

### Directory structure

 -  `bin/`: the main Regula script that calls `terraform` & `opa`.
 -  `lib/`: the OPA library code to evaluate rules and mangle input.
 -  `rules/`: a collection of rules.  We may split this up further as the number
    of rules increases.
 -  `scripts/`: scripts for development; currently only a script to generate
    test input.
 -  `tests/`:
      *  `tests/lib`: internal tests for the library.
      *  `tests/rules/`: tests for the various rules.
      *  `tests/rules/input`: terraform files that can be used to generate Rego
         files.

### Locally producing a report

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
[terraform]: https://www.terraform.io/
[Rego]: https://www.openpolicyagent.org/docs/latest/policy-language/
[Fugue Custom Rules]: https://docs.fugue.co/rules.html
