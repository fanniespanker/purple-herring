#!/usr/bin/env bash
set -euo pipefail

file="specs/librarium/cnml_specification.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/cnml-n-values-canonical-paths-fragments-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path

p = Path("specs/librarium/cnml_specification.md")
text = p.read_text(encoding="utf-8")

# ---------------------------------------------------------------------
# 1. Keep CNML Fish examples non-polar unless polarity is the subject.
# ---------------------------------------------------------------------

repls = {
    "# &+ has_genre @ Fiction/noir;": "# & has {genre} @ Fiction/noir;",
    "# &+ intended_audience @ Audience/general;": "# & has {intended_audience} @ Audience/general;",
    "# &+ has {genre} @ Fiction/noir;": "# & has {genre} @ Fiction/noir;",
    "# &+ has {intended_audience} @ Audience/general;": "# & has {intended_audience} @ Audience/general;",

    "#/mainmatter/Act 1/Chapter 1 &+ portrays @ Relationships/dynamics/example_dynamic;": "#/Act 1/Chapter 1 & portrays @ Relationships/dynamics/example_dynamic;",
    "#/mainmatter/Act 2/Chapter 3 &+ explores @ Ideas/example_theme;": "#/Act 2/Chapter 3 & explores @ Ideas/example_theme;",
    "#/mainmatter/Act 1/Chapter 1 & portrays @ Relationships/dynamics/example_dynamic;": "#/Act 1/Chapter 1 & portrays @ Relationships/dynamics/example_dynamic;",
    "#/mainmatter/Act 2/Chapter 3 & explores @ Ideas/example_theme;": "#/Act 2/Chapter 3 & explores @ Ideas/example_theme;",

    "#/act/1/chapter/1 &+ portrays @ Relationships/dynamics/example_dynamic;": "#/Act 1/Chapter 1 & portrays @ Relationships/dynamics/example_dynamic;",
    "#/act/2/chapter/3 &+ explores @ Ideas/example_theme;": "#/Act 2/Chapter 3 & explores @ Ideas/example_theme;",
    "#/Act 1/Chapter 1 &+ portrays @ Relationships/dynamics/example_dynamic;": "#/Act 1/Chapter 1 & portrays @ Relationships/dynamics/example_dynamic;",
    "#/Act 2/Chapter 3 &+ explores @ Ideas/example_theme;": "#/Act 2/Chapter 3 & explores @ Ideas/example_theme;",
    "#/act1/chapter01 &+ portrays @ Relationships/dynamics/example_dynamic;": "#/Act 1/Chapter 1 & portrays @ Relationships/dynamics/example_dynamic;",
    "#/act2/chapter03 &+ explores @ Ideas/example_theme;": "#/Act 2/Chapter 3 & explores @ Ideas/example_theme;",
}
for old, new in repls.items():
    text = text.replace(old, new)

# ---------------------------------------------------------------------
# 2. Add/update Fish-block note: examples may use bare &.
# ---------------------------------------------------------------------

fish_note_anchor = "Authors SHOULD NOT wrap each Fish statement in its own XML element. A single `<fish>` block MAY contain a School of one or more Fish statements."
fish_note = fish_note_anchor + "\n\nFish examples inside CNML MAY use bare `&` for resolved non-polar assertions. Use `&+` or `&-` only when the example specifically needs positive or negative assertion polarity."
if fish_note_anchor in text and "Fish examples inside CNML MAY use bare `&`" not in text:
    text = text.replace(fish_note_anchor, fish_note, 1)

# ---------------------------------------------------------------------
# 3. Add/update n-value and canonical subresource path rules.
# ---------------------------------------------------------------------

old = "The `n` attribute defines an authored local CNML name usable as a segment in CNML address expressions."
new = """The `n` attribute defines an authored local CNML name usable as a segment in CNML address expressions.

`n` is CNML-native addressing metadata, not XML identity. Authors MAY use spaces, capitalization, and human-readable labels in `n` values. Capitalization and ordinary title-like spacing are encouraged when they improve authoring clarity, source readability, or stylistic consistency.

When an element has an authored `n` value, that value is the canonical CNML address segment for that element within its containing addressable context.

Canonical CNML subresource paths are built from addressable CNML source elements in the resolved CNML containment tree. A source element is addressable when it has an authored `n` value, or when the active profile derives a fallback address segment for it.

Unnamed structural or matter containers such as `<frontmatter>`, `<mainmatter>`, and `<backmatter>` do not contribute canonical path segments by default. They MAY contribute path segments only when they have explicit `n` values or when the active profile requires matter-frame addressing.

The `#` token denotes the root of the current CNML/Fish resource context. `#` alone refers to that root resource.

A canonical CNML subresource path begins after `#` as one or more slash-prefixed address segments. In `#/Act 1/Chapter 1`, `#` denotes the resource root and `/Act 1/Chapter 1` is the canonical subresource path under that root.

Canonical CNML subresource paths MUST NOT end in a trailing slash. They MUST NOT contain empty path segments. Therefore `#/`, `#//Act 1`, `#/Act 1/`, and `#/Act 1//Chapter 1` are not canonical CNML subresource paths.

A path segment names an addressable CNML subresource node; that node MAY still contain further addressable descendants.

Examples:

```text
#                                      current resource root
<act n="Act 1">                        #/Act 1
<chapter n="Chapter 1">                #/Act 1/Chapter 1
<scene n="Opening Scene">              #/Act 1/Chapter 1/Opening Scene
<mainmatter><act n="Act 1">...</act>   #/Act 1
```

An absolute external resource IRI MAY be combined with a canonical CNML subresource fragment. In that combined form, the URI scheme, authority, and path identify the external/network resource; `#` denotes the root of that referenced resource; and the slash-prefixed path following `#` identifies a canonical CNML subresource under that resource.

Example:

```text
https://fanniespanker.com/hardboiledwhore/
  external/network resource root

https://fanniespanker.com/hardboiledwhore/#/Act%203/Chapter%2015
  carrier-encoded reference to canonical CNML subresource #/Act 3/Chapter 15
```

Slash characters after `#` are CNML subresource path separators. They MUST NOT be interpreted as network path separators for URI authority/path resolution.

A carrier-safe encoding, slug, lowercase form, percent-encoded form, or machine-oriented address spelling MAY be defined by a profile or host binding. Such forms are transport or projection encodings. They are not replacements for the canonical CNML subresource path derived from authored `n` values."""
if old in text and "Authors MAY use spaces, capitalization, and human-readable labels in `n` values" not in text:
    text = text.replace(old, new, 1)

# If a previous draft of this patch was partially applied, normalize its example paths.
text = text.replace("#/mainmatter/Act 1/Chapter 1", "#/Act 1/Chapter 1")
text = text.replace("#/mainmatter/Act 2/Chapter 3", "#/Act 2/Chapter 3")

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "CNML fish examples and n/path guidance:"
grep -nE 'CNML-native Fish Blocks|# & |#/Act|Authors MAY use spaces|canonical CNML address segment|Unnamed structural|trailing slash|Slash characters after|external/network resource|Fish examples inside CNML|n="Act 1"|n="Chapter' "$file" || true

echo
echo "Potential stale CNML example forms:"
grep -nE '# &\+ has_genre|# &\+ intended_audience|#/mainmatter|#/act/1|#/act1|#&|<ph:ish>|<ph:fish>' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
