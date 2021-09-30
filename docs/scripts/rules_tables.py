import argparse
from dataclasses import dataclass
import json
import os
from typing import Dict, List, Optional, Tuple
from pytablewriter import MarkdownTableWriter


parser = argparse.ArgumentParser(
    description="Generate Regula Rules Documentation",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)
parser.add_argument(
    "--provider",
    default="k8s",
    help="Rule provider",
)


@dataclass
class RuleMeta:
    """
    Metadata for a single rule
    """

    severity: str
    id: str
    title: str
    provider: str
    resource_types: List[str]
    # controls: Optional[Dict[str, Dict[str, List[str]]]]
    # description: str
    # service: Optional[str]
    # input_type: Optional[str]


def detect_provider(name: str) -> Tuple[Optional[str], Optional[str]]:
    parts = name.split("_", 2)
    if len(parts) < 3:
        return (None, None)
    if parts[0] == "cfn":
        return ("aws", "cloudformation")
    elif parts[0] == "tf":
        return (parts[1], "terraform")
    return (None, None)


def read_metadata(provider: str) -> List[RuleMeta]:
    rules_dir = os.path.join("rego", "rules", provider)
    rule_defs = os.listdir(rules_dir)
    rules: List[RuleMeta] = []
    for rule_filename in rule_defs:
        rule_meta = {}
        with open(os.path.join(rules_dir, rule_filename)) as f:
            rule_lines = f.readlines()
        for line in rule_lines:
            line = line.strip()
            if line.startswith('"id":'):
                rule_meta["id"] = line.split(maxsplit=1)[1].strip('",')
            elif line.startswith('"title":'):
                rule_meta["title"] = line.split(maxsplit=1)[1].strip('",')
            elif line.startswith('"severity":'):
                rule_meta["severity"] = line.split(maxsplit=1)[1].strip('",')
        rules.append(
            RuleMeta(
                severity=rule_meta["severity"],
                id=rule_meta["id"],
                title=rule_meta["title"],
                provider=provider,
                resource_types=[],
            )
        )
    return rules


def group_rules(rules: List[RuleMeta]) -> Dict[str, List[RuleMeta]]:
    by_provider: Dict[str, List[RuleMeta]] = {}
    for rule in rules:
        provider_rules = by_provider.setdefault(rule.provider, [])
        provider_rules.append(rule)
    for provider, provider_rules in by_provider.items():
        provider_rules.sort(key=lambda r: r.id)
    return by_provider


def write_rules_table(header: str, rules: List[RuleMeta]):
    writer = MarkdownTableWriter(
        table_name=header,
        headers=[
            "Summary",
            "Resource Types",
            "Severity",
            "Rule ID",
        ],
        value_matrix=[
            [
                rule.title,
                ", ".join(rule.resource_types) if rule.resource_types else "",
                rule.severity,
                rule.id,
            ]
            for rule in rules
        ],
    )
    writer.write_table()


provider_name_map: Dict[str, str] = {
    "aws": "AWS",
    "google": "Google",
    "azurerm": "Azure",
    "k8s": "Kubernetes",
}


def main():
    args = parser.parse_args()
    rule_metadata = read_metadata(args.provider)
    grouped_rules = group_rules(rule_metadata)

    for provider, provider_rules in grouped_rules.items():
        write_rules_table(provider_name_map[provider], provider_rules)
        print()


if __name__ == "__main__":
    main()
