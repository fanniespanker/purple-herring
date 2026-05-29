#!/usr/bin/env bash
set -euo pipefail

file="specs/librarium/cnml_specification.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/cnml-remove-dot-addresses-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path
import re

p = Path("specs/librarium/cnml_specification.md")
text = p.read_text(encoding="utf-8")

# Replace the old milestone-address example immediately following the XML example.
old = """The milestone may be addressed as:

```text
Example Work.Act 1.Chapter 4.ms5
```

`n` is not an XML identifier. It is not required to be document-global.
"""
new = """The milestone may be addressed as:

```text
#/Act 1/Chapter 4/ms5
```

This path is interpreted relative to the current resource root. The enclosing `<work n="Example Work">` identifies the work/resource context; it does not need to be repeated inside a work-root-relative subresource path.

`n` is not an XML identifier. It is not required to be document-global.
"""
if old in text:
    text = text.replace(old, new, 1)
else:
    print("warning: old milestone-address example not found")

# Replace the CNML Address Expressions subsection through the line before the next subsection.
pattern = re.compile(
    r"### CNML Address Expressions\n\n"
    r"A CNML address expression is a path over authored `n` values and/or processor-derived address segments\.\n\n"
    r"The path separator is `\.`\.\n\n"
    r"Each unescaped `\.` separates one path segment from the next\.\n\n"
    r"A path segment resolves against an addressable CNML unit in the current address scope\.",
    re.M,
)

replacement = """### CNML Address Expressions

A CNML address expression is a canonical subresource path over addressable CNML source elements.

The canonical address form is rooted with `#`.

`#` alone denotes the current resource root.

A subresource address appends one or more slash-prefixed address segments after `#`:

```text
#/Act 1/Chapter 4/ms5
```

Each `/segment` resolves against an addressable CNML unit in the current address scope.

The slash `/` is the canonical CNML subresource path separator.

Dot-separated CNML address paths are not canonical and are not part of this draft.

Processors MUST NOT emit dot-separated address expressions as canonical CNML subresource paths.

A carrier or host binding MAY percent-encode, escape, or otherwise serialize canonical CNML subresource paths when required, but such carrier encodings MUST preserve recovery of the canonical `#/...` path."""

text, count = pattern.subn(replacement, text, count=1)
if count == 0:
    print("warning: CNML Address Expressions block not replaced; attempting looser replacement")
    start = text.find("### CNML Address Expressions")
    if start != -1:
        # End at next heading of same/lower subsection if present.
        m = re.search(r"\n### ", text[start + 1:])
        if m:
            end = start + 1 + m.start()
            text = text[:start] + replacement + "\n" + text[end:]
        else:
            print("warning: could not find end of CNML Address Expressions section")
    else:
        print("warning: CNML Address Expressions heading not found")

# Remove stale dot-path wording if any survived.
text = text.replace("The path separator is `.`.\n\n", "")
text = text.replace("Each unescaped `.` separates one path segment from the next.\n\n", "")
text = text.replace("Example Work.Act 1.Chapter 4.ms5", "#/Act 1/Chapter 4/ms5")

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Canonical address wording:"
grep -nE 'CNML Address Expressions|#/Act 1/Chapter 4/ms5|Dot-separated|slash `/`|resource root|dot-separated' "$file" || true

echo
echo "Potential stale dot-address wording:"
grep -nE 'path separator is `\\.`|unescaped `\\.`|Example Work\\.Act|dot-separated address expressions as canonical' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
