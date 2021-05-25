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
    "--metadata",
    default="metadata.json",
    help="Rule metadata path",
)


@dataclass
class RuleMeta:
    """
    Metadata for a single rule
    """

    controls: Optional[Dict[str, Dict[str, List[str]]]]
    severity: str
    description: str
    id: str
    title: str
    service: Optional[str]
    resource_types: List[str]
    provider: Optional[str]
    input_type: Optional[str]


def detect_provider(name: str) -> Tuple[Optional[str], Optional[str]]:
    parts = name.split("_", 2)
    if len(parts) < 3:
        return (None, None)
    if parts[0] == "cfn":
        return ("aws", "cloudformation")
    elif parts[0] == "tf":
        return (parts[1], "terraform")
    return (None, None)


def read_metadata(path: str) -> List[RuleMeta]:
    with open(path) as f:
        metadata = json.load(f)
    rules: List[RuleMeta] = []
    for rule_key, rule in metadata.items():
        metadoc = rule["__rego__metadoc__"]
        custom_meta = metadoc.get("custom", {})
        controls = custom_meta.get("controls", {})
        provider, input_type = detect_provider(rule_key)
        controls = [
            control_id
            for control_ids in controls.values()
            for control_id in control_ids
        ]
        resource_type = rule.get("resource_type")
        rules.append(
            RuleMeta(
                controls=sorted(set(controls)),
                severity=custom_meta.get("severity"),
                description=metadoc["description"],
                id=metadoc["id"],
                title=metadoc["title"],
                input_type=metadoc.get("input_type") or input_type,
                resource_types=[resource_type] if resource_type else [],
                service=None,
                provider=provider,
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
}


def main():
    args = parser.parse_args()
    rule_metadata = read_metadata(args.metadata)
    grouped_rules = group_rules(rule_metadata)

    for provider, provider_rules in grouped_rules.items():
        write_rules_table(provider_name_map[provider], provider_rules)
        print()


if __name__ == "__main__":
    main()
