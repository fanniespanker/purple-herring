#!/usr/bin/env bash
set -euo pipefail

file="specs/fish/fish_specification_draft.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/fish-lexical-tokens-and-canonical-space-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path

p = Path("specs/fish/fish_specification_draft.md")
text = p.read_text(encoding="utf-8")

# Insert a lexical conventions section after Core Terms if absent.
if "## 4. Lexical Conventions" not in text:
    anchor = "---\n\n## 4. Fish Statements"
    section = """---

## 4. Lexical Conventions

This section defines core Fish lexical conventions used by Fish itself and by dependent profiles or host formats, including CNML.

### Canonical Space

Canonical Fish space is U+0020 SPACE.

When a Fish grammar rule refers to `" "`, `SPACE`, or canonical space, it means U+0020 SPACE only.

Tabs, line breaks, non-breaking spaces, and other Unicode whitespace characters are not canonical spaces.

Non-canonical whitespace MAY appear in source positions where Fish treats whitespace as incidental, but canonical serializers MUST emit U+0020 SPACE where a canonical separating space is required.

### Fish Identifier Tokens

A `fish-identifier-token` is the basic unquoted token class used by Fish profiles for identifier-like path segments, local names, and other profile-defined symbolic atoms.

The base character class for a `fish-identifier-token` is:

```ebnf
fish-identifier-token = fish-identifier-character, { fish-identifier-character } ;

fish-identifier-character =
    Unicode_Letter
  | Unicode_Mark
  | Unicode_Number
  | profile-permitted-connector ;
```

`Unicode_Letter`, `Unicode_Mark`, and `Unicode_Number` refer to Unicode general-category families for letters, combining/marking characters, and numbers.

`profile-permitted-connector` is a profile-defined extension point. A profile MAY permit connector characters such as `_` only when those characters do not conflict with the active grammar, host binding, or canonicalization profile.

A Fish profile that permits connector characters MUST define their canonicalization, normalization, and escaping behavior.

Fish identifier tokens MUST NOT contain Fish structural delimiters unless a profile explicitly defines an escaped or quoted form.

Fish structural delimiters include, at minimum:

```text
& @ ; { } ( ) [ ] , / # $ * ? + - : = ^ ~ < > " '
```

The active Fish profile MAY classify additional characters as delimiters.

### Token-Run Spacing

When a Fish profile permits human-readable token runs separated by spaces, those spaces MUST use canonical Fish space.

A token-run spacing rule SHOULD take the form:

```ebnf
token-run = fish-identifier-token, { " ", fish-identifier-token } ;
```

Such a token run cannot begin with space, end with space, contain consecutive spaces, or contain non-U+0020 whitespace.

"""
    if anchor in text:
        text = text.replace(anchor, section + anchor, 1)
    else:
        print("warning: Fish Statements anchor not found; lexical section not inserted")

# Renumber subsequent numbered level-2 headings if lexical section was inserted.
if "## 4. Lexical Conventions" in text and "## 4. Fish Statements" in text:
    replacements = [
        ("## 4. Fish Statements", "## 5. Fish Statements"),
        ("## 5. Tail, Relator Phrase, and Head", "## 6. Tail, Relator Phrase, and Head"),
        ("## 6. Assertion Operators", "## 7. Assertion Operators"),
        ("## 6. Bindings", "## 8. Bindings"),
        ("## 7. Bindings", "## 8. Bindings"),
        ("## 8. Schools", "## 9. Schools"),
        ("## 9. Fish Packages", "## 10. Fish Packages"),
        ("## 10. Request-Root Sigil", "## 11. Request-Root Sigil"),
        ("## 11. Fish Resource Identifiers / FRIs / fries", "## 12. Fish Resource Identifiers / FRIs / fries"),
        ("## 12. Aquatically Unique Identifiers / AUIDs", "## 13. Aquatically Unique Identifiers / AUIDs"),
        ("## 13. Namespaces and Qualified Resources", "## 14. Namespaces and Qualified Resources"),
        ("## 14. Query Forms", "## 15. Query Forms"),
        ("## 15. Assertion-State Results", "## 16. Assertion-State Results"),
        ("## 16. Binding Results", "## 17. Binding Results"),
        ("## 17. Projection and Omission", "## 18. Projection and Omission"),
        ("## 18. Graph-Change Payloads", "## 19. Graph-Change Payloads"),
        ("## 19. Materialization Concepts", "## 20. Materialization Concepts"),
        ("## 20. Fish Bodies", "## 21. Fish Bodies"),
        ("## 21. Comments", "## 22. Comments"),
        ("## 22. Whitespace", "## 23. Whitespace"),
        ("## 23. Media Type", "## 24. Media Type"),
        ("## 24. Relationship to Host Bindings", "## 25. Relationship to Host Bindings"),
        ("## 25. Non-Normative Culinary Notes", "## 26. Non-Normative Culinary Notes"),
        ("## 26. Open Questions", "## 27. Open Questions"),
    ]
    for old, new in replacements:
        text = text.replace(old, new)

# Tighten whitespace section with reference to canonical space if not already present.
old_ws = """Fish source is whitespace-insensitive outside quoted literals, comment schools, and other explicitly whitespace-bearing literal forms.

Whitespace MAY separate tokens for readability, but it does not affect Fish semantics or AUID computation unless the active profile explicitly defines a whitespace-bearing construct.

Whitespace MUST separate relator phrase components in full School Fish source.

A canonical Fish serializer MUST emit deterministic whitespace.

Incidental whitespace, comments, and comment schools MUST NOT contribute to AUID canonical projections.
"""
new_ws = """Fish source is whitespace-insensitive outside quoted literals, comment schools, canonical token-run spacing, and other explicitly whitespace-bearing literal forms.

Whitespace MAY separate tokens for readability, but it does not affect Fish semantics or AUID computation unless the active profile explicitly defines a whitespace-bearing construct.

Whitespace MUST separate relator phrase components in full School Fish source.

Where canonical Fish source requires a separating space, that space MUST be U+0020 SPACE.

A canonical Fish serializer MUST emit deterministic whitespace and MUST use U+0020 SPACE for canonical separating spaces.

Incidental whitespace, comments, and comment schools MUST NOT contribute to AUID canonical projections.
"""
if old_ws in text:
    text = text.replace(old_ws, new_ws, 1)
elif "Where canonical Fish source requires a separating space" not in text:
    print("warning: exact whitespace block not found; no whitespace section update applied")

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Lexical conventions and canonical space:"
grep -nE 'Lexical Conventions|Canonical Space|fish-identifier-token|Token-Run Spacing|U\+0020|profile-permitted-connector' "$file" || true

echo
echo "Heading numbering check:"
grep -nE '^## [0-9]+\. ' "$file" || true

echo
echo "Potential stale whitespace wording:"
grep -nE 'A canonical Fish serializer MUST emit deterministic whitespace\\.$|Where canonical Fish source requires a separating space' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
