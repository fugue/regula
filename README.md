# Regula

## Introduction

Regula is a very light (less than 100 lines of bash; and you don't every really
need to use this) wrapper around [opa] and [terraform] that allows you to more
easily implement pre-flight policy checks, by providing a rigid structure for
rules.

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
