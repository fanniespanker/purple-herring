#!/usr/bin/env bash
set -euo pipefail

file="specs/fish/purple_herring_http_binding_draft.md"

if [ ! -f "$file" ]; then
  echo "missing required file: $file" >&2
  exit 1
fi

backup_dir=".patch-backups/http-binding-future-host-bindings-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/$(dirname "$file")"
cp "$file" "$backup_dir/$file"

echo "Backup written to: $backup_dir/$file"

python3 - <<'PY'
from pathlib import Path
import re

p = Path("specs/fish/purple_herring_http_binding_draft.md")
text = p.read_text(encoding="utf-8")

# ---------------------------------------------------------------------
# Clean stale Fish examples and old syntax.
# ---------------------------------------------------------------------

repls = {
    "*modo&define@/github.com/fannie-spanker/media-oriented-description-ontology;": "*modo &+ define @ /github.com/fannie-spanker/media-oriented-description-ontology;",
    "#/Diane&modo:owns@#/Andrea;": "#/Diane &+ modo:owns @ #/Andrea;",
    "#/Diane&modo:loves@#/Andrea;": "#/Diane &+ modo:loves @ #/Andrea;",
    "#/Diane&is_[$x]_of@#/Andrea;": "#/Diane &+ is { $x } of @ #/Andrea;",
    "the relation template `is_[$x]_of` relates": "the relator phrase `is { $x } of` relates",
    "#/Diane &+ is {owner} of @ #/Andrea;": "#/Diane &+ is { owner } of @ #/Andrea;",
    "#/Diane &+ is {$x} of @#/Andrea;": "#/Diane &+ is { $x } of @ #/Andrea;",
    "## 17. Assertion-State Results // UPDATE": "## 17. Assertion-State Results",
    "`ASSERTED_POSITIVE`": "`RESOLVED_POSITIVE`",
    "`ASSERTED_NON_POLAR`": "`RESOLVED_NON_POLAR`",
    "`ASSERTED_NEGATIVE`": "`RESOLVED_NEGATIVE`",
    "a matching positive assertion exists": "a matching resolved positive relation exists",
    "a matching non-polar assertion exists": "a matching resolved non-polar / middle relation exists",
    "a matching negative assertion exists": "a matching resolved negative relation exists",
    "no matching asserted or unresolved relation is known under the active scope/profile": "no matching resolved or unresolved relation is known under the active scope/profile",
}
for old, new in repls.items():
    text = text.replace(old, new)

# Match Fish spec assertion-state ordering if current table still has old order.
text = text.replace(
"""| `RESOLVED_POSITIVE` | a matching resolved positive relation exists |
| `RESOLVED_NON_POLAR` | a matching resolved non-polar / middle relation exists |
| `RESOLVED_NEGATIVE` | a matching resolved negative relation exists |
| `UNRESOLVED_POSITIVE` | a matching positive unresolved structure exists |
| `UNRESOLVED_NON_POLAR` | a matching non-polar unresolved structure exists |
| `UNRESOLVED_NEGATIVE` | a matching negative unresolved structure exists |""",
"""| `RESOLVED_POSITIVE` | a matching resolved positive relation exists |
| `RESOLVED_NEGATIVE` | a matching resolved negative relation exists |
| `RESOLVED_NON_POLAR` | a matching resolved non-polar / middle relation exists |
| `UNRESOLVED_POSITIVE` | matching positive unresolved structure exists |
| `UNRESOLVED_NEGATIVE` | matching negative unresolved structure exists |
| `UNRESOLVED_NON_POLAR` | matching non-polar / middle unresolved structure exists |"""
)

# ---------------------------------------------------------------------
# Add carrier/subresource clarification to HTTP request targets if absent.
# ---------------------------------------------------------------------

anchor = "Expressive Fish syntax is carried in request bodies."
addition = """Expressive Fish syntax is carried in request bodies.

Raw HTTP request targets MUST NOT contain raw `#` for Fish request-root-relative syntax. Within Fish bodies, `#` and `#/...` retain their Fish meanings.

An absolute resource IRI MAY be combined with a carrier-encoded Fish/CNML subresource fragment for reference purposes. In such forms, the URI scheme, authority, and path identify the network resource, while the fragment identifies an internal Fish/CNML subresource under that resource.

Slash characters after `#` in such fragments are Fish/CNML subresource separators. They are not HTTP path separators and MUST NOT affect network request-target resolution.

Carrier encodings, including percent-encoding of spaces or other characters, MUST preserve recovery of the canonical Fish/CNML address structure.
"""
if anchor in text and "Raw HTTP request targets MUST NOT contain raw `#`" not in text:
    text = text.replace(anchor, addition, 1)

# ---------------------------------------------------------------------
# Replace Compatibility Fish-in-Address Forms with carrier encodings.
# ---------------------------------------------------------------------

old_compat = """## 20. Compatibility Fish-in-Address Forms

A host binding MAY provide percent-encoded Fish-in-address forms for compact or advanced clients.

Percent-encoded Fish address forms are compatibility bindings.

The ordinary authoring forms are:

- ordinary HTTP request targets for resource retrieval;
- raw Fish source in request bodies for expressive queries and graph changes.
"""
new_carrier = """## 20. Carrier Encodings and Address Forms

The ordinary HTTP binding uses:

- ordinary HTTP request targets for resource retrieval;
- raw Fish source in request bodies for expressive queries and graph changes.

A host binding MAY define carrier encodings for Fish/FRI address structures when they must be represented inside URI paths, URI fragments, query parameters, headers, JSON discovery documents, or other HTTP-specific carriers.

Carrier encodings are not canonical Fish source. They MUST preserve recovery of the underlying Fish/FRI address structure.

Percent-encoded URI fragments are one possible carrier encoding for external references to Fish/CNML subresources.

Example:

```text
https://fanniespanker.com/hardboiledwhore/#/Act%203/Chapter%2015
```

In this example, `https://fanniespanker.com/hardboiledwhore/` identifies the external network resource. The fragment encodes the internal subresource path `#/Act 3/Chapter 15`.
"""
if old_compat in text:
    text = text.replace(old_compat, new_carrier, 1)
elif "## 20. Carrier Encodings and Address Forms" not in text:
    print("warning: compatibility section not found; carrier section not inserted")

# ---------------------------------------------------------------------
# Insert future host bindings / design probes before culinary notes.
# ---------------------------------------------------------------------

if "## 21. Future Host Bindings and Design Probes" not in text:
    marker = "---\n\n## 21. Non-Normative Culinary Notes"
    section = """---

## 21. Future Host Bindings and Design Probes

HTTP is the first concrete Purple Herring host binding. It is not the transport ontology of Fish, C4, or Fish Tank.

Future host bindings are non-normative design probes, but they impose present constraints on this HTTP binding and on Fish source design:

- Fish semantics MUST NOT depend on HTTP methods, request-target syntax, headers, status codes, or URI fragment behavior.
- Request-root binding MUST be supplied by the active host binding.
- Carrier encoding MUST remain separate from canonical Fish source.
- Response projection MUST remain profile-defined rather than HTTP-status-defined.
- Mutation semantics MUST remain graph-service semantics rather than HTTP-method semantics.
- Subresource paths MUST remain canonical outside URI fragments.
- Transaction, session, and streaming semantics MUST be defined above any concrete transport.

Potential future host bindings include:

| Binding class | Design pressure |
|---|---|
| session/socket binding | distinguishes request root, session root, package root, transaction root, and resource root |
| streaming/fond binding | carries graph deltas, subscriptions, incremental AUID updates, and live materialization events |
| file/git binding | distinguishes semantic resources from repository paths, files, archives, and projection artifacts |
| database/Mongres binding | exposes persistent query, materialization, mutation, transaction, and watch operations |
| editor/LSP-style binding | supports validation, canonicalization, source ranges, diagnostics, and FRI resolution for buffers |
| binary-frame binding | carries compact graph structures, AUID branch records, and large result projections without requiring Fish source text |

These possible bindings do not supersede HTTP. They clarify that HTTP request targets, URI fragments, percent encoding, content negotiation, and status codes are carrier mechanics, not Fish/C4 semantics.

"""
    if marker in text:
        text = text.replace(marker, section + marker, 1)
        # Renumber following headings and open questions if marker had ##21.
        text = text.replace("## 21. Non-Normative Culinary Notes", "## 22. Non-Normative Culinary Notes")
        text = text.replace("## 22. Open Questions", "## 23. Open Questions")
    else:
        print("warning: culinary notes marker not found; future bindings section not inserted")

p.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "Future host bindings / carrier encoding:"
grep -nE 'Carrier Encodings|Future Host Bindings|HTTP is the first concrete|transport ontology|Carrier encoding|URI fragments|Subresource paths|session/socket|streaming/fond|database/Mongres' "$file" || true

echo
echo "Stale syntax/state checks:"
grep -nE 'is_\\[|ASSERTED_|// UPDATE|Fish-in-Address|#/Diane&|\\*modo&|@#/|\\{owner\\}|raw HTTP request-target FRIs\\.$' "$file" || true

echo
echo "Heading numbering:"
grep -nE '^## [0-9]+\\. ' "$file" || true

echo
echo "Diff:"
git diff -- "$file"
