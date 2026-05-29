#!/usr/bin/env bash
set -euo pipefail

file="specs/librarium/cnml_specification.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/cnml-fish-blocks-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path

p = Path("specs/librarium/cnml_specification.md")
text = p.read_text(encoding="utf-8")

# Update old compact Fish examples in the publication metadata block.
repls = {
    "#&has_genre@Fiction/noir;": "# &+ has_genre @ Fiction/noir;",
    "#&intended_audience@Audience/general;": "# &+ intended_audience @ Audience/general;",
    "#Act 1.Chapter 1&portrays@Relationships/dynamics/example_dynamic;": "#/Act 1/Chapter 1 &+ portrays @ Relationships/dynamics/example_dynamic;",
    "#Act 2.Chapter 3&explores@Ideas/example_theme;": "#/Act 2/Chapter 3 &+ explores @ Ideas/example_theme;",
}
for old, new in repls.items():
    text = text.replace(old, new)

# Insert a focused Fish block subsection if absent.
if "### CNML-Native Fish Blocks" not in text:
    anchor = "Relational, ontological, interpretive, subject, genre, audience, adaptation, parody, support/opposition, portrayal, and thematic metadata SHOULD be represented with fish relation statements."
    addition = anchor + """

### CNML-Native Fish Blocks

CNML-native Fish blocks are represented by plain `<fish>` elements.

A `<fish>` element contains Fish source text. That Fish source is the concrete Purple Herring surface for C4 graph structures associated with the containing CNML context.

A `<fish>` block MAY appear wherever block content is permitted by the active CNML profile.

A `<fish>` block SHOULD be interpreted relative to its nearest containing CNML structural, publication, discourse, or evaluator context. When a Fish block uses `#`, that request-root/reference-root is the current CNML context as exposed by the active Purple Herring/C4 profile.

A `<fish>` block is semantic graph data, not visible prose. Ordinary CNML renderers MAY ignore, preserve, warn on, expose, or externally hand off `<fish>` blocks according to their processing profile.

Purple Herring-conformant CNML processors SHOULD pass `<fish>` block contents to Fish/C4 tooling such as Sashimi Bōchō / `sashimi_bouchou` for parsing and canonicalization.

Authors SHOULD NOT wrap each Fish statement in its own XML element. A single `<fish>` block MAY contain a School of one or more Fish statements.

Example:

```xml
<fish>
  # &+ has_genre @ Fiction/noir;
  # &+ intended_audience @ Audience/general;
  #/Act 1/Chapter 1 &+ portrays @ Relationships/dynamics/example_dynamic;
  #/Act 2/Chapter 3 &+ explores @ Ideas/example_theme;
</fish>
```
"""
    if anchor in text:
        text = text.replace(anchor, addition, 1)
    else:
        print("warning: publication fish-relations anchor not found; Fish block subsection not inserted")

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Fish block references:"
grep -nE '<fish>|CNML-Native Fish Blocks|sashimi_bouchou|# &\+|#/Act' "$file" || true

echo
echo "Potential stale Fish-in-CNML syntax:"
grep -nE '#&|&is_|is_\[|template slot|<ph:ish>|<ph:fish>' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
