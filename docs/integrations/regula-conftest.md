# Regula + Conftest

[Conftest](https://github.com/open-policy-agent/conftest) is a test runner for configuration files that uses Rego for
policy-as-code.  Conftest supports Terraform, but policies need to be written
directly against the plan file which is often inconvenient and tricky.

Since Regula is just a Rego library; it works works seamlessly with Conftest.
This way you get the advantages of both projects, in particular:

 -  Easy CI integration and policy retrieval from Conftest
 -  Terraform plan parsing & the rule set from Regula

To use Regula with Conftest:

1.  Generate a `plan.json` using the following terraform commands:

        terraform init
        terraform plan -refresh=false -out=plan.tfplan
        terraform show -json plan.tfplan >plan.json

2.  Now, we'll pull the conftest support for Regula and the Regula library in.

        conftest pull -p policy/ 'github.com/fugue/regula//conftest?ref={{ version }}'
        conftest pull -p policy/regula/lib 'github.com/fugue/regula//lib?ref={{ version }}'

    If we want to use the rules that come with regula, we can
    use:

        conftest pull -p policy/regula/rules 'github.com/fugue/regula//rules?ref={{ version }}'

    And of course you can pull in your own Regula rules as well.

3.  At this point, it's simply a matter of running conftest!

        conftest test plan.json