# Regula

## Running Regula as a GitHub Action

See <https://github.com/jaspervdj-luminal/regula-action>.

## Locally producing a report

We first need to obtain a JSON-formatted terraform plan.  In order to do get
that, you can use:

    terraform init
    terraform plan -refresh=false -out=plan.tfplan
    terraform show -json plant.tfplan >input.json

This gives you `input.json`.  Now you can test this input against the rules by
evaluating `data.fugue.regula.report` with OPA.  In order to do that, point OPA
to the input file, and the regula project directory.

    opa eval -d /path/to/regula --input input.json 'data.fugue.regula.report'

If all goes well, you should now see the results for each rule.
