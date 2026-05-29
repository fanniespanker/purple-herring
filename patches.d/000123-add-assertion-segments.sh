#!/usr/bin/env bash
set -euo pipefail

files=(
  "specs/fish/fish_specification_draft.md"
  "specs/fish/purple_herring_http_binding_draft.md"
  "specs/fish/fish_tank_backend_roadmap.md"
)

for f in "${files[@]}"; do
  [ -f "$f" ] || { echo "missing: $f" >&2; exit 1; }
done

backup_dir=".patch-backups/assertion-segments-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

for f in "${files[@]}"; do
  mkdir -p "$backup_dir/$(dirname "$f")"
  cp "$f" "$backup_dir/$f"
done

echo "Backups written to: $backup_dir"

python3 - <<'PY'
from pathlib import Path

fish_spec = Path("specs/fish/fish_specification_draft.md")
roadmap = Path("specs/fish/fish_tank_backend_roadmap.md")
http = Path("specs/fish/purple_herring_http_binding_draft.md")

text = fish_spec.read_text(encoding="utf-8")

if "### Segmented Assertion Operators" not in text:
    anchor = "Canonical Fish serialization MUST preserve `&` when the relation state is resolved non-polar."
    addition = """Canonical Fish serialization MUST preserve `&` when the relation state is resolved non-polar.

### Segmented Assertion Operators

Fish assertion state decomposes into two semantic axes:

```text
ASSERTION_POLARITY   = positive | negative | non-polar
ASSERTION_RESOLUTION = resolved | unresolved
```

Compact assertion operators are authoring forms over those axes:

```text id="ldqc2h"
&+   = & { positive } { resolved }
&-   = & { negative } { resolved }
&    = & { non-polar } { resolved }
&+?  = & { positive } { unresolved }
&-?  = & { negative } { unresolved }
&?   = & { non-polar } { unresolved }
```

A segmented assertion operator MAY expose these axes as queryable positions:

```fish id="52tyfx"
&{<assertion-polarity>}{<assertion-resolution>}
```

Each segment MAY contain a literal segment value or a query binding.

Example:

```fish id="sybar7"
#/Diane &{$assertion_polarity}{$assertion_resolution} is { owner } of @ #/Andrea;
```

This query binds the assertion polarity and assertion resolution of matching relations.

The compact and segmented forms are semantically equivalent after canonicalization. Canonical graph form SHOULD represent assertion polarity and assertion resolution as explicit fields rather than preserving only surface punctuation.
"""
    if anchor in text:
        text = text.replace(anchor, addition, 1)
    else:
        print("warning: Fish spec insertion anchor not found; no segmented assertion section inserted")
    fish_spec.write_text(text, encoding="utf-8")
else:
    print("Fish spec already has segmented assertion operators section")

text = roadmap.read_text(encoding="utf-8")

if "assertion_polarity" not in text:
    text = text.replace(
        """Statement
  statement_id
  package_eid
  fish_index
  tail
  assertion_state
  relator_phrase_id""",
        """Statement
  statement_id
  package_eid
  fish_index
  tail
  assertion_state
  assertion_polarity
  assertion_resolution
  relator_phrase_id"""
    )

    text = text.replace(
        """RESOLVED_POSITIVE       &+
RESOLVED_NEGATIVE       &-
RESOLVED_NON_POLAR      &
UNRESOLVED_POSITIVE     &+?
UNRESOLVED_NEGATIVE     &-?
UNRESOLVED_NON_POLAR    &?""",
        """RESOLVED_POSITIVE       &+
RESOLVED_NEGATIVE       &-
RESOLVED_NON_POLAR      &
UNRESOLVED_POSITIVE     &+?
UNRESOLVED_NEGATIVE     &-?
UNRESOLVED_NON_POLAR    &?

Each compact assertion operator decomposes into:

```text id="zdbzc2"
assertion_state = assertion_polarity + assertion_resolution
assertion_polarity = positive | negative | non-polar
assertion_resolution = resolved | unresolved
```"""
    )

    text = text.replace(
        """statements
  id
  package_id
  fish_index
  tail_resource_id
  assertion_state
  relator_phrase_id""",
        """statements
  id
  package_id
  fish_index
  tail_resource_id
  assertion_state
  assertion_polarity
  assertion_resolution
  relator_phrase_id"""
    )

    roadmap.write_text(text, encoding="utf-8")
else:
    print("Backend roadmap already mentions assertion_polarity")

text = http.read_text(encoding="utf-8")

if "&{$assertion_polarity}{$assertion_resolution}" not in text:
    marker = "### Relation-Variable Query"
    note = """### Assertion-State Segment Query

A query MAY bind assertion-state segments:

```fish
#/Diane &{$assertion_polarity}{$assertion_resolution} is { owner } of @ #/Andrea;
```

This asks for matching relations while binding their assertion polarity and assertion resolution.

"""
    if marker in text:
        text = text.replace(marker, note + marker, 1)
    else:
        print("warning: HTTP binding insertion marker not found; appending assertion segment query note")
        text += "\n\n" + note
    http.write_text(text, encoding="utf-8")
else:
    print("HTTP binding already has assertion segment query note")
PY

echo
echo "Review checks:"
echo

echo "Possible stale old Fish syntax:"
grep -RIn --include='*.md' -E 'is_\[|template slot|ASSERTED_POSITIVE|ASSERTED_NEGATIVE|#/[^[:space:]]*&[A-Za-z_$]|&is_|&\$r|&define' specs/fish || true

echo
echo "Assertion segment language:"
grep -RIn --include='*.md' -E 'assertion_polarity|assertion_resolution|&\{\$assertion_polarity\}\{\$assertion_resolution\}' specs/fish || true

echo
echo "Diff:"
git diff -- \
  specs/fish/fish_specification_draft.md \
  specs/fish/purple_herring_http_binding_draft.md \
  specs/fish/fish_tank_backend_roadmap.md
