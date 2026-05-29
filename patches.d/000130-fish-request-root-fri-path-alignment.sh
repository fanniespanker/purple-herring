#!/usr/bin/env bash
set -euo pipefail

file="specs/fish/fish_specification_draft.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/fish-request-root-fri-path-alignment-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path

p = Path("specs/fish/fish_specification_draft.md")
text = p.read_text(encoding="utf-8")

old_request_root = """## 11. Request-Root Sigil

The `#` sigil is a Fish body-local request-root reference.

Inside a Fish body, `#` denotes the graph node corresponding to the request-root FRI supplied by the active host binding.

Examples:

```fish
#;
#/Diane;
#/Diane &+ modo:owns @ #/Andrea;
```

The expression `#/Diane` denotes a resource relative to the request root.

The `#` sigil is used inside Fish bodies and Schools.

Address FRIs used as raw HTTP request targets do not contain raw `#`.
"""
new_request_root = """## 11. Request-Root Sigil

The `#` sigil is a Fish body-local request-root reference.

Inside a Fish body, `#` denotes the graph node corresponding to the request-root FRI supplied by the active host binding.

`#` alone denotes the request-root resource.

A request-root-relative resource path appends one or more slash-prefixed path segments after `#`.

Examples:

```fish
#;
#/Diane;
#/Diane &+ modo:owns @ #/Andrea;
```

In `#/Diane`, `#` denotes the request-root resource and `/Diane` is the request-root-relative path under that root.

A request-root-relative path MUST NOT contain empty path segments and MUST NOT end in a trailing slash. Therefore `#/`, `#//Diane`, `#/Diane/`, and `#/Diane//Andrea` are not canonical request-root-relative paths.

Path segments that use human-readable token runs SHOULD follow the Fish token-run spacing rule: `fish-identifier-token, { " ", fish-identifier-token }`.

The `#` sigil is used inside Fish bodies and Schools.

Address FRIs used as raw HTTP request targets do not contain raw `#`. Host bindings that serialize request-root-relative paths into URI fragments MUST define the carrier encoding separately from Fish source syntax.
"""

if old_request_root in text:
    text = text.replace(old_request_root, new_request_root, 1)
else:
    print("warning: exact Request-Root Sigil section body not found; applying targeted inserts")
    if "`#` alone denotes the request-root resource." not in text:
        text = text.replace(
            "Inside a Fish body, `#` denotes the graph node corresponding to the request-root FRI supplied by the active host binding.\n",
            "Inside a Fish body, `#` denotes the graph node corresponding to the request-root FRI supplied by the active host binding.\n\n`#` alone denotes the request-root resource.\n\nA request-root-relative resource path appends one or more slash-prefixed path segments after `#`.\n",
            1,
        )
    text = text.replace(
        "The expression `#/Diane` denotes a resource relative to the request root.",
        "In `#/Diane`, `#` denotes the request-root resource and `/Diane` is the request-root-relative path under that root.\n\nA request-root-relative path MUST NOT contain empty path segments and MUST NOT end in a trailing slash. Therefore `#/`, `#//Diane`, `#/Diane/`, and `#/Diane//Andrea` are not canonical request-root-relative paths.\n\nPath segments that use human-readable token runs SHOULD follow the Fish token-run spacing rule: `fish-identifier-token, { \" \", fish-identifier-token }`.",
        1,
    )
    text = text.replace(
        "Address FRIs used as raw HTTP request targets do not contain raw `#`.",
        "Address FRIs used as raw HTTP request targets do not contain raw `#`. Host bindings that serialize request-root-relative paths into URI fragments MUST define the carrier encoding separately from Fish source syntax.",
        1,
    )

old_fri = """## 12. Fish Resource Identifiers / FRIs / fries

A Fish Resource Identifier, or FRI, identifies a graph resource or graph expression.

A FRI is the Fish surface form of a C4 resource reference or graph address.

FRIs may be path-like:

```fish
/fish-srv/characters/Diane
/github.com/fannie-spanker/media-oriented-description-ontology
```

FRIs may also be Fish expressions when the active context permits statement-like resource identifiers or query-pattern identifiers.

A FRI may denote:

- a graph node;
- a graph resource;
- a School;
- a statement-like graph object;
- a graph region;
- a query pattern;
- a materialization target;
- a profile-defined service resource.

FRI syntax is refined by host bindings and active profiles.
"""
new_fri = """## 12. Fish Resource Identifiers / FRIs / fries

A Fish Resource Identifier, or FRI, identifies a graph resource or graph expression.

A FRI is the Fish surface form of a C4 resource reference or graph address.

FRIs may be path-like:

```fish
/fish-srv/characters/Diane
/github.com/fannie-spanker/media-oriented-description-ontology
```

FRIs may be request-root-relative:

```fish
#
#/Diane
#/Diane/Case File 1
```

In a request-root-relative FRI, `#` denotes the active request root and each slash-prefixed segment denotes a path segment under that root.

A canonical request-root-relative FRI MUST NOT contain empty path segments and MUST NOT end in a trailing slash.

FRIs may also be Fish expressions when the active context permits statement-like resource identifiers or query-pattern identifiers.

A FRI may denote:

- a graph node;
- a graph resource;
- a School;
- a statement-like graph object;
- a graph region;
- a query pattern;
- a materialization target;
- a profile-defined service resource.

FRI syntax is refined by host bindings and active profiles.

Host bindings MAY serialize absolute resources combined with request-root or subresource paths into carrier-specific forms, such as URI fragments. Such carrier forms are encodings of Fish/FRI address structure, not raw HTTP request-target syntax.
"""

if old_fri in text:
    text = text.replace(old_fri, new_fri, 1)
else:
    print("warning: exact FRI section body not found; applying targeted FRI insert")
    if "FRIs may be request-root-relative:" not in text:
        text = text.replace(
            "FRIs may be path-like:\n\n```fish\n/fish-srv/characters/Diane\n/github.com/fannie-spanker/media-oriented-description-ontology\n```\n",
            "FRIs may be path-like:\n\n```fish\n/fish-srv/characters/Diane\n/github.com/fannie-spanker/media-oriented-description-ontology\n```\n\nFRIs may be request-root-relative:\n\n```fish\n#\n#/Diane\n#/Diane/Case File 1\n```\n\nIn a request-root-relative FRI, `#` denotes the active request root and each slash-prefixed segment denotes a path segment under that root.\n\nA canonical request-root-relative FRI MUST NOT contain empty path segments and MUST NOT end in a trailing slash.\n",
            1,
        )
    if "Such carrier forms are encodings of Fish/FRI address structure" not in text:
        text = text.replace(
            "FRI syntax is refined by host bindings and active profiles.",
            "FRI syntax is refined by host bindings and active profiles.\n\nHost bindings MAY serialize absolute resources combined with request-root or subresource paths into carrier-specific forms, such as URI fragments. Such carrier forms are encodings of Fish/FRI address structure, not raw HTTP request-target syntax.",
            1,
        )

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Request-root and FRI alignment:"
grep -nE 'Request-Root Sigil|#` alone|request-root-relative|empty path segments|raw HTTP request targets|FRIs may be request-root-relative|URI fragments' "$file" || true

echo
echo "Potential stale request-root wording:"
grep -nE 'The expression `#/Diane` denotes a resource relative to the request root\\.|Address FRIs used as raw HTTP request targets do not contain raw `#`\\.$' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
