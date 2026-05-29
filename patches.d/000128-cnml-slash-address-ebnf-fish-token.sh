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

# Replace stale dot-path EBNF if still present.
old_dot = """```ebnf
address = segment, { ".", segment } ;
```

Whitespace MAY appear literally in `n` values and in CNML address expressions.
"""
new_slash = """```ebnf
address             = "#" | "#", subresource-path ;
subresource-path    = "/", subresource-segment, { "/", subresource-segment } ;
subresource-segment = subresource-token, { " ", subresource-token } ;
subresource-token   = fish-identifier-token ;
```

`fish-identifier-token` is the identifier-token character class defined by the Fish specification. CNML does not redefine that character class.

Canonical CNML subresource segments MAY contain U+0020 SPACE only as an internal separator between Fish identifier-token runs.

A canonical segment MUST NOT begin or end with SPACE.

A canonical segment MUST NOT contain consecutive SPACE characters.

A canonical segment MUST NOT contain tabs, line breaks, non-breaking spaces, or other Unicode whitespace characters.

Whitespace MAY appear literally in `n` values only when it can be represented in the canonical CNML subresource path under these segment rules, or when the active profile derives a valid fallback canonical segment.
"""
if old_dot in text:
    text = text.replace(old_dot, new_slash, 1)
else:
    # Replace the looser slash EBNF produced by the earlier 128 patch, if present.
    old_loose = """```ebnf
address          = "#" | "#", subresource-path ;
subresource-path = "/", segment, { "/", segment } ;
segment          = non-empty-cnml-address-segment ;
```

Whitespace MAY appear literally in `n` values and in canonical CNML subresource paths.
"""
    if old_loose in text:
        text = text.replace(old_loose, new_slash, 1)
    else:
        print("warning: known address EBNF block not found; trying targeted fallback replacements")
        text = text.replace(
            'address = segment, { ".", segment } ;',
            'address             = "#" | "#", subresource-path ;\nsubresource-path    = "/", subresource-segment, { "/", subresource-segment } ;\nsubresource-segment = subresource-token, { " ", subresource-token } ;\nsubresource-token   = fish-identifier-token ;',
            1,
        )
        text = text.replace(
            'address          = "#" | "#", subresource-path ;\nsubresource-path = "/", segment, { "/", segment } ;\nsegment          = non-empty-cnml-address-segment ;',
            'address             = "#" | "#", subresource-path ;\nsubresource-path    = "/", subresource-segment, { "/", subresource-segment } ;\nsubresource-segment = subresource-token, { " ", subresource-token } ;\nsubresource-token   = fish-identifier-token ;',
            1,
        )
        text = text.replace(
            "Whitespace MAY appear literally in `n` values and in CNML address expressions.",
            "Whitespace MAY appear literally in `n` values only when it can be represented in the canonical CNML subresource path under these segment rules, or when the active profile derives a valid fallback canonical segment.",
            1,
        )
        text = text.replace(
            "Whitespace MAY appear literally in `n` values and in canonical CNML subresource paths.",
            "Whitespace MAY appear literally in `n` values only when it can be represented in the canonical CNML subresource path under these segment rules, or when the active profile derives a valid fallback canonical segment.",
            1,
        )

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Canonical address EBNF and Fish reference:"
grep -nE 'address[[:space:]]*=|subresource-path|subresource-segment|subresource-token|fish-identifier-token|U\\+0020|consecutive SPACE|Unicode whitespace' "$file" || true

echo
echo "Potential stale dot/loose grammar:"
grep -nE 'address = segment|\\{ \"\\.\"|non-empty-cnml-address-segment|Whitespace MAY appear literally in `n` values and in CNML address expressions|Whitespace MAY appear literally in `n` values and in canonical CNML subresource paths' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
