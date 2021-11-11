# Regula

**Tip: See all of our documentation at [regula.dev](https://regula.dev)!**

- [Introduction](#introduction)
- [Installation](#installation)
  - [Homebrew](#homebrew-macos--linux)
  - [Prebuilt binary (all platforms)](#prebuilt-binary-all-platforms)
  - [Docker (all platforms)](#docker-all-platforms)
- [Usage](#usage)
- [For more information](#for-more-information)

## Introduction

[Regula](https://regula.dev) is a tool that evaluates infrastructure as code files for potential AWS, Azure, Google Cloud, and Kubernetes security and compliance violations prior to deployment.

Regula supports the following file types:

- CloudFormation JSON/YAML templates
- Terraform HCL code
- Terraform JSON plans
- Kubernetes YAML manifests

Regula includes a library of rules written in Rego, the policy language used by the [Open Policy Agent](https://www.openpolicyagent.org/) (OPA) project. Regula works with your favorite CI/CD tools such as Jenkins, Circle CI, and AWS CodePipeline; we’ve included a [GitHub Actions example](https://github.com/fugue/regula-action) so you can get started quickly. Where relevant, we’ve mapped Regula policies to the CIS AWS, Azure, and Google Cloud Foundations Benchmarks so you can assess compliance posture. Regula is maintained by engineers at [Fugue](https://fugue.co).

Regula is also available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

More information is available at [regula.dev](https://regula.dev).

## Installation

### Homebrew (macOS & Linux)

To install Regula via [Homebrew](https://brew.sh/):

```
brew tap fugue/regula
brew install regula
```

To upgrade Regula:

```
brew upgrade regula
```

### Prebuilt binary (all platforms)

1. Download the Regula archive for your platform from the [Releases](https://github.com/fugue/regula/releases) page.
2. Extract the downloaded archive.
3. Move the extracted `regula` binary to somewhere in your PATH:

    macOS:

    ```
    mv regula /usr/local/bin
    ```

    Linux:

    ```
    sudo mv regula /usr/local/bin
    ```

    Windows (cmd):

    ```
    md C:\regula\bin
    move regula.exe C:\regula\bin
    setx PATH "%PATH%;C:\regula\bin"
    ```

    Windows (PowerShell):

    ```
    md C:\regula\bin
    move regula.exe C:\regula\bin
    $env:Path += ";C:\regula\bin"
    # You can add '$env:Path += ";C:\regula\bin"' to your profile.ps1 file to
    # persist that change across shell sessions.
    ```

4. _Windows users only:_ Close cmd and re-open it so the changes take effect.
5. You can now run `regula`.

### Docker (all platforms)

Regula is available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

For usage, see [Running Regula with Docker](https://regula.dev/usage.html#running-regula-with-docker).

## Usage

**For a tutorial on using Regula with example IaC, see [Getting Started](https://regula.dev/getting-started.html#tutorial-run-regula-locally-on-terraform-iac).**

```
Regula

Usage:
  regula [command]

Available Commands:
  completion        generate the autocompletion script for the specified shell
  help              Help about any command
  init              Create a new Regula configuration file in the current working directory.
  repl              Start an interactive session for testing rules with Regula
  run               Evaluate rules against infrastructure as code with Regula.
  show              Show debug information.
  test              Run OPA test with Regula.
  version           Print version information.
  write-test-inputs Persist dynamically-generated test inputs for use with other Rego interpreters

Flags:
  -h, --help      help for regula
  -v, --verbose   verbose output

Use "regula [command] --help" for more information about a command.
```

For details about each command, including examples, see [Usage](https://regula.dev/usage.html).

## For more information

Visit [regula.dev](https://regula.dev) for more information about Regula, including:

- [Regula's report output](https://regula.dev/report.html)
- [Integrations](https://regula.dev/integrations/conftest.html)
- [Writing](https://regula.dev/development/writing-rules.html) and [testing](https://regula.dev/development/testing-rules.html) custom rules
- [Configuring waivers and disabling rules](https://regula.dev/configuration.html)
- and more!


[opa]: https://www.openpolicyagent.org/
[fregot]: https://github.com/fugue/fregot
[CloudFormation]: https://docs.aws.amazon.com/cloudformation/
[Terraform]: https://www.terraform.io/
[Rego]: https://www.openpolicyagent.org/docs/latest/policy-language/
[Fugue Custom Rules]: https://docs.fugue.co/rules.html
[Conftest]: https://github.com/open-policy-agent/conftest
