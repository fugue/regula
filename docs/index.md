# Welcome to the Regula Docs!

[Regula](https://github.com/fugue/regula) is a tool that evaluates CloudFormation and Terraform infrastructure-as-code for potential AWS, Azure, and Google Cloud security and compliance violations prior to deployment.

Regula includes a library of rules written in Rego, the policy language used by the [Open Policy Agent](https://www.openpolicyagent.org/) (OPA) project. Regula works with your favorite CI/CD tools such as Jenkins, Circle CI, and AWS CodePipeline; we’ve included a [GitHub Actions example](https://github.com/fugue/regula-action) so you can get started quickly. Where relevant, we’ve mapped Regula policies to the CIS AWS, Azure, and Google Cloud Foundations Benchmarks so you can assess compliance posture. Regula is maintained by engineers at [Fugue](https://fugue.co).

Regula is also available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

## How does Regula work?

There are two parts to Regula. The first is a [shell script](https://github.com/fugue/regula/blob/master/bin/regula) that generates a JSON document for [opa](https://www.openpolicyagent.org/) consumption.

The second part is a Rego framework that:

-   Merges resource info from `planned_values` and `configuration` in the Terraform plan into a more conveniently accessible format, and walks through the imported Terraform modules and merges them into a flat format.
-   Looks for [rules](https://github.com/fugue/regula/tree/master/rules) and executes them.
-   Generates a report with the results of all relevant rules and [control mappings](report.md#compliance-controls-vs-rules).

## Get Started

[Let's go!](getting-started.md)