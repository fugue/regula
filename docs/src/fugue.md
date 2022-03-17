# Regula and Fugue

Regula can be used in conjunction with [Fugue](https://www.fugue.co) to ensure infrastructure as code (IaC) is secure and compliant by enforcing the same policy as code across the entire development lifecycle.

## Setting up a Fugue IaC repository environment

To set up a repository environment, see the [Fugue docs](https://docs.fugue.co/setup-repository.html).

## Syncing rules, families, and waivers from Fugue

!!! note
    Syncing applies any relevant [Fugue waivers](https://docs.fugue.co/waivers.html) enabled for your repository environment. This is a one-way sync; [local waivers](configuration.md#waiving-rule-results) are not applied or synced to Fugue.

Using [`regula run`](usage.md#run) with the `--sync` flag instructs Regula to evaluate your IaC templates using the rules, families, and [waivers](https://docs.fugue.co/waivers.html) enabled for the associated Fugue repository environment. The rules that are applied to your IaC are determined by the compliance families you selected for the environment.

The Fugue repository environment is specified in the `.regula.yaml` configuration file, which is generated when you execute [`regula init --environment-id <environment_id>`](usage.md#init) (see the [Fugue docs](https://docs.fugue.co/setup-repository.html#step-5-kicking-off-a-scan)).

To run Regula locally with synced rules/families/waivers:

```
regula run --sync
```

To run Regula locally with synced rules/families/waivers and _also_ send Regula's results to Fugue:

```
regula run --sync --upload
```

Be aware that `--sync` overrides other flags that would select rules. For instance, if you use `--sync`, you cannot also use the `--only` flag to select only a single rule, and you cannot use `--include` or `--exclude` to include/exclude other directories of rules or local waivers. `--sync` ensures that Regula applies the rules/families/waivers configured in your Fugue repository environment.