# Regula

## Introduction

Regula is a very light (less than 100 lines of bash; and you don't every really
need to use this) wrapper around [opa] and [terraform] that allows you to more
easily implement pre-flight policy checks, by providing a rigid structure for
rules.

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
