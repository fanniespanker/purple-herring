#!/usr/bin/env bash
set -euo pipefail

file="specs/librarium/cnml_specification.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/cnml-slash-address-ebnf-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path

p = Path("specs/librarium/cnml_specification.md")
text = p.read_text(encoding="utf-8")

old = """```ebnf
address = segment, { ".", segment } ;
```

Whitespace MAY appear literally in `n` values and in CNML address expressions.
"""
new = """```ebnf
address          = "#" | "#", subresource-path ;
subresource-path = "/", segment, { "/", segment } ;
segment          = non-empty-cnml-address-segment ;
```

Whitespace MAY appear literally in `n` values and in canonical CNML subresource paths.
"""

if old in text:
    text = text.replace(old, new, 1)
else:
    print("warning: stale dot-path EBNF block not found; trying targeted fallback replacements")
    text = text.replace(
        'address = segment, { ".", segment } ;',
        'address          = "#" | "#", subresource-path ;\nsubresource-path = "/", segment, { "/", segment } ;\nsegment          = non-empty-cnml-address-segment ;',
        1,
    )
    text = text.replace(
        "Whitespace MAY appear literally in `n` values and in CNML address expressions.",
        "Whitespace MAY appear literally in `n` values and in canonical CNML subresource paths.",
        1,
    )

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Slash-path EBNF:"
grep -nE 'address[[:space:]]*=|subresource-path|non-empty-cnml-address-segment|Whitespace MAY appear literally' "$file" || true

echo
echo "Potential stale dot-path grammar:"
grep -nE 'address = segment|\\{ \"\\.\"|CNML address expressions\\.' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
