# Welcome to the Regula Docs!

**Current version: {{ version }}**

[Regula](https://github.com/fugue/regula) is a tool that evaluates infrastructure as code files for potential AWS, Azure, Google Cloud, and Kubernetes security and compliance violations prior to deployment.

Regula supports the following file types:

- CloudFormation JSON/YAML templates
- Terraform source code (.tf or .tf.json format)
- Terraform JSON plans
- Kubernetes YAML manifests
- Azure Resource Manager (ARM) JSON templates _(in preview)_

Regula includes a library of rules written in Rego, the policy language used by the [Open Policy Agent](https://www.openpolicyagent.org/) (OPA) project. Regula works with your favorite CI/CD tools such as Jenkins, Circle CI, and AWS CodePipeline; we’ve included a [GitHub Actions example](https://github.com/fugue/regula-action) so you can get started quickly. Where relevant, we’ve mapped Regula policies to the CIS AWS, Azure, Google Cloud, and Kubernetes Foundations Benchmarks so you can assess compliance posture. Regula is maintained by engineers at [Fugue](https://fugue.co).

Regula is also available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

## How does Regula work?

The Regula CLI is built using Go, which means it is installed as a single self-contained binary. It reads in infrastructure as code files and uses OPA to evaluate them against Regula's [library of rules](https://github.com/fugue/regula/tree/master/rego/rules), generating a [report](report.md). Regula also supports [custom rules](development/writing-rules.md) written in Rego. For usage details, see [Usage](usage.md).

## Get Started

[Let's go!](getting-started.md)