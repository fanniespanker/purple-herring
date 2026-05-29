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

backup_dir=".patch-backups/c4-mapping-notes-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

for f in "${files[@]}"; do
  mkdir -p "$backup_dir/$(dirname "$f")"
  cp "$f" "$backup_dir/$f"
done

echo "Backups written to: $backup_dir"

python3 - <<'PY'
from pathlib import Path

fish_spec = Path("specs/fish/fish_specification_draft.md")
http = Path("specs/fish/purple_herring_http_binding_draft.md")
roadmap = Path("specs/fish/fish_tank_backend_roadmap.md")

def block(lines):
    return "\n".join(lines) + "\n"

# ---------------------------------------------------------------------
# Fish spec: add explicit C4 relationship / mapping section.
# ---------------------------------------------------------------------

text = fish_spec.read_text(encoding="utf-8")

if "## 2. Relationship to C4" not in text:
    anchor = block([
        "---",
        "",
        "## 2. Core Terms",
    ])

    c4_section = block([
        "---",
        "",
        "## 2. Relationship to C4",
        "",
        "C4, the Contextual Compositional Concept Calculus, defines the abstract graph-semantic structures used by Purple Herring.",
        "",
        "Fish is the concrete source, query, update, and interchange surface for expressing those C4 structures.",
        "",
        "Fish syntax MUST NOT be treated as the semantic authority where it conflicts with the active C4 model. Fish provides a parseable and canonicalizable surface for C4 graph objects, relation expressions, assertion states, graph regions, and resource references.",
        "",
        "The general relationship is:",
        "",
        "```text",
        "C4",
        "  abstract graph calculus and semantic model",
        "",
        "Fish",
        "  concrete surface notation and interchange form for C4 structures",
        "",
        "Sashimi Bōchō / sashimi_bouchou",
        "  parser and canonicalizer from Fish source into C4/Fish logical graph objects",
        "",
        "Fish Tank",
        "  runtime/backend abstraction for storing, querying, materializing, and projecting C4/Fish graph structures",
        "```",
        "",
        "Initial mapping:",
        "",
        "| Fish surface | C4 structure |",
        "|---|---|",
        "| Fish statement | C4 assertion / relation expression |",
        "| tail | C4 source expression |",
        "| relator phrase | C4 relator expression |",
        "| head | C4 target expression |",
        "| assertion operator | C4 assertion-state operator |",
        "| assertion polarity | C4 assertion polarity |",
        "| assertion resolution | C4 assertion resolution |",
        "| embedded Fish component | embedded C4 subgraph, resource expression, or statement set |",
        "| School | bounded C4 graph region or statement set |",
        "| Fish package | ordered C4/Fish interchange package under one package root |",
        "| FRI | C4 resource reference / graph address |",
        "| AUID | canonical projection equivalence identifier for a C4/Fish graph region |",
        "",
        "This mapping is intentionally structural. It does not require every C4 structure to have exactly one Fish surface form, nor every Fish authoring shorthand to survive canonicalization.",
        "",
    ])

    if anchor in text:
        text = text.replace(anchor, c4_section + anchor, 1)
    else:
        print("warning: Fish spec core-terms anchor not found; C4 relationship section not inserted")

# Renumber numbered level-2 headings after inserting the new section.
if "## 2. Relationship to C4" in text and "## 2. Core Terms" in text:
    replacements = [
        ("## 2. Core Terms", "## 3. Core Terms"),
        ("## 3. Fish Statements", "## 4. Fish Statements"),
        ("## 4. Tail, Relator Phrase, and Head", "## 5. Tail, Relator Phrase, and Head"),
        ("## 5. Assertion Operators", "## 6. Assertion Operators"),
        ("## 5. Relation-State Operators", "## 6. Relation-State Operators"),
        ("## 6. Bindings", "## 7. Bindings"),
        ("## 7. Schools", "## 8. Schools"),
        ("## 8. Fish Packages", "## 9. Fish Packages"),
        ("## 9. Request-Root Sigil", "## 10. Request-Root Sigil"),
        ("## 10. Fish Resource Identifiers / FRIs / fries", "## 11. Fish Resource Identifiers / FRIs / fries"),
        ("## 11. Aquatically Unique Identifiers / AUIDs", "## 12. Aquatically Unique Identifiers / AUIDs"),
        ("## 12. Namespaces and Qualified Resources", "## 13. Namespaces and Qualified Resources"),
        ("## 13. Query Forms", "## 14. Query Forms"),
        ("## 14. Assertion-State Results", "## 15. Assertion-State Results"),
        ("## 15. Binding Results", "## 16. Binding Results"),
        ("## 16. Projection and Omission", "## 17. Projection and Omission"),
        ("## 17. Graph-Change Payloads", "## 18. Graph-Change Payloads"),
        ("## 18. Materialization Concepts", "## 19. Materialization Concepts"),
        ("## 19. Fish Bodies", "## 20. Fish Bodies"),
        ("## 20. Comments", "## 21. Comments"),
        ("## 21. Whitespace", "## 22. Whitespace"),
        ("## 22. Media Type", "## 23. Media Type"),
        ("## 23. Relationship to Host Bindings", "## 24. Relationship to Host Bindings"),
        ("## 24. Non-Normative Culinary Notes", "## 25. Non-Normative Culinary Notes"),
        ("## 25. Open Questions", "## 26. Open Questions"),
    ]
    for old, new in replacements:
        text = text.replace(old, new)

# Add targeted C4 mapping notes if not present.
if "A Fish statement is the Fish surface form of a C4 assertion or relation expression." not in text:
    text = text.replace(
        "A Fish statement relates a tail to a head through a relator phrase.",
        "A Fish statement relates a tail to a head through a relator phrase.\n\nA Fish statement is the Fish surface form of a C4 assertion or relation expression.",
        1,
    )

if "A relator phrase is the Fish surface form of a C4 relator expression." not in text:
    text = text.replace(
        "The relator phrase defines the relation form between tail and head.",
        "The relator phrase defines the relation form between tail and head.\n\nA relator phrase is the Fish surface form of a C4 relator expression.",
        1,
    )

if "Embedded Fish components are embedded C4 graph structure" not in text:
    text = text.replace(
        "Embedded Fish components are graph structure, not raw text interpolation.",
        "Embedded Fish components are embedded C4 graph structure, not raw text interpolation.",
        1,
    )

if "A School is the Fish interchange form of a bounded C4 graph region" not in text:
    text = text.replace(
        "A School is a set, block, document, payload, or resource containing one or more Fish statements interpreted together.",
        "A School is a set, block, document, payload, or resource containing one or more Fish statements interpreted together.\n\nA School is the Fish interchange form of a bounded C4 graph region or statement set.",
        1,
    )

if "A FRI is the Fish surface form of a C4 resource reference" not in text:
    text = text.replace(
        "A Fish Resource Identifier, or FRI, identifies a graph resource or graph expression.",
        "A Fish Resource Identifier, or FRI, identifies a graph resource or graph expression.\n\nA FRI is the Fish surface form of a C4 resource reference or graph address.",
        1,
    )

if "For C4 purposes, an AUID is an equivalence identifier" not in text:
    text = text.replace(
        "An AUID identifies canonical equivalence under a declared AUID profile. It does not assert primitive identity.",
        "An AUID identifies canonical equivalence under a declared AUID profile. It does not assert primitive identity.\n\nFor C4 purposes, an AUID is an equivalence identifier for a canonical projection of a C4/Fish graph region, not an identity primitive.",
        1,
    )

fish_spec.write_text(text, encoding="utf-8")

# ---------------------------------------------------------------------
# HTTP binding: add C4 note without renumbering.
# ---------------------------------------------------------------------

text = http.read_text(encoding="utf-8")

if "### C4 Relationship" not in text:
    marker = "### Fish\n\nFish is the C4 surface syntax, query/update expression language, and graph interchange representation used by Purple Herring graph services."
    replacement = marker + block([
        "",
        "### C4 Relationship",
        "",
        "The HTTP binding transports Fish source and Fish response projections. The graph semantics belong to C4 and the active Purple Herring/Fish profile.",
        "",
        "HTTP request targets, operation endpoints, request bodies, and response bodies are host-binding carriers for C4/Fish graph structures. They do not redefine the underlying C4 semantics.",
    ])
    if marker in text:
        text = text.replace(marker, replacement, 1)
    else:
        print("warning: HTTP Fish core-term marker not found; C4 relationship note not inserted")

http.write_text(text, encoding="utf-8")

# ---------------------------------------------------------------------
# Backend roadmap: make C4 boundary more explicit.
# ---------------------------------------------------------------------

text = roadmap.read_text(encoding="utf-8")

if "C4 defines the abstract graph-semantic model." not in text:
    marker = "Purple Herring semantics belong to the Purple Herring/Fish/C4 layer."
    replacement = block([
        "C4 defines the abstract graph-semantic model.",
        "",
        "Fish is the concrete source/interchange surface for expressing C4 structures.",
        "",
        "Purple Herring semantics belong to the Purple Herring/Fish/C4 layer.",
    ]).rstrip("\n")
    if marker in text:
        text = text.replace(marker, replacement, 1)
    else:
        print("warning: roadmap design-principle marker not found; C4 boundary note not inserted")

if "The Fish Tank Logical Graph Engine owns C4/Fish logical semantics" not in text:
    text = text.replace(
        "The Fish Tank Logical Graph Engine owns:",
        "The Fish Tank Logical Graph Engine owns C4/Fish logical semantics:",
        1,
    )

roadmap.write_text(text, encoding="utf-8")
PY

echo
echo "Review checks:"
echo

echo "C4 mapping references:"
grep -RIn --include='*.md' -E 'Relationship to C4|C4 Mapping|C4 assertion|C4 relator|C4 graph region|C4 resource reference|C4/Fish' specs/fish || true

echo
echo "Diff:"
git diff -- \
  specs/fish/fish_specification_draft.md \
  specs/fish/purple_herring_http_binding_draft.md \
  specs/fish/fish_tank_backend_roadmap.md
