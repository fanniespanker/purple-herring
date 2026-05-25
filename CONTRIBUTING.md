# Contributing

Purple Herring is the public C4 language and tooling ecosystem.

Contributions should preserve the distinction between canonical project vocabulary, public-facing documentation, and operational handles used by tools.

## Repository Scope

This repository is for public Purple Herring materials, including language specifications, tooling specifications, reusable semantic libraries, execution semantics, patch semantics, and related authoring or markup specifications.

Do not add private planning notes, unpublished integration notes, working drafts, internal project files, local scratch files, or process artifacts to this repository.

## Contribution Authorship and License Compatibility

Only contribute material that you wrote yourself or have the right to submit under this repository's licenses.

Do not copy code, documentation, data, examples, generated files, or substantial text from third-party sources unless the source license is compatible with the target file or directory and all attribution requirements are satisfied.

Generated, vendored, bundled, or adapted material must be clearly marked and must preserve required copyright notices, attribution, SPDX identifiers, and license text.

When authorship, provenance, or license compatibility is unclear, do not add the material until it has been reviewed.

## Filename and Encoding Policy

Repository filenames and file contents are UTF-8.

UTF-8 filenames, including diacritics and non-English text, are permitted when they improve clarity, accuracy, or project vocabulary.

ASCII filenames are also permitted and may be preferred when they reduce friction for shell usage, URLs, build tooling, generated artifacts, packaging, or broad contributor interoperability.

Tooling, scripts, tests, documentation generators, and CI configuration should handle UTF-8 paths correctly. ASCII-only naming is a convenience option, not a requirement.

## ASCII Fallback Naming

When an ASCII-only filename is preferred, filenames should be transliterated into plain ASCII.

Recommended fallback rules:

1. Replace accented Latin characters with their nearest ASCII equivalent.
   - `PÂTE` -> `pate`

2. Use lowercase for filenames.
   - `CiNnaMoN` -> `cinnamon`

3. Replace spaces with underscores.
   - `C4 Technical Specification.md` -> `c4_technical_specification.md`
   - `SARDINE Specification.md` -> `sardine_specification.md`
   - `Herring Bones Guide.md` -> `herring_bones_guide.md`

4. Avoid punctuation except underscore `_`, hyphen `-` when semantically useful, and period `.` for extensions.

5. Preserve the full preferred display title inside the document heading.

Examples:

```text
C4 Technical Specification.md      -> c4_technical_specification.md
SARDINE Specification.md           -> sardine_specification.md
Herring Bones Guide.md             -> herring_bones_guide.md
CAThedral Specification.md         -> cathedral_specification.md
GEL Execution Semantics.md         -> gel_execution_semantics.md
CPM Patch Semantics.md             -> cpm_patch_semantics.md
CNML Specification.md              -> cnml_specification.md
PÂTE Specification.md              -> pate_specification.md
CiNnaMoN Specification.md          -> cinnamon_specification.md
```

ASCII fallback filenames are convenience handles only. They do not change the project vocabulary, formal names, document titles, or required UTF-8 support.

## Stable Filenames

Current files should avoid version numbers, dates, status labels, and other lifecycle clutter unless the file is intentionally archival or one of several parallel versions.

Prefer stable semantic filenames whose contents can evolve without requiring renames.

Recommended:

```text
c4_specification.md
c4_for_non_pescatarians.md
sardine_specification.md
herring_bones_guide.md
cathedral_specification.md
gel_execution_semantics.md
cpm_patch_semantics.md
cnml_specification.md
pate_specification.md
cinnamon_specification.md
```

Avoid for current documents:

```text
c4_v0.1.6_specification.md
CURRENT_c4_specification.md
cathedral_specification_v0.2.0.md
2026-05-21_c4_specification.md
```

Put version and status inside the document instead:

```markdown
# C4 v0.1.6 Technical Specification

Status: Current draft
Version: 0.1.6
```

Versioned, dated, or status-prefixed filenames may be used in `archive/`, release snapshots, migration bundles, or when multiple versions intentionally coexist.

## Archive Snapshot Filenames

Archive snapshots should prefer predictable operational filenames over canonical display titles.

Recommended format:

```text
YYYY-MM-DD__ascii_snake_name__version__status.ext
```

Examples:

```text
2026-05-21__c4_specification__v0.1.6__current_snapshot.md
2026-05-21__sardine_specification__unknown_version__current_snapshot.md
2026-05-21__herring_bones_guide__unknown_version__current_snapshot.md
2026-05-21__cathedral_specification__v0.2.0__current_snapshot.md
2026-05-21__c3tcalc_specification__v0.2__deprecated_donor.md
2026-05-21__gel_god_unified_core__unknown_version__deprecated_donor.md
```

Recommended status terms:

```text
current_snapshot
release_snapshot
deprecated
deprecated_donor
superseded
migrated
imported
```

The proper title, canonical spelling, version, status, and snapshot date should also appear inside the file.

## Canonical Names and Operational Handles

The official project name is the canonical display form, including intentional capitalization, punctuation, diacritics, spacing, or other aesthetically significant formatting.

Everything else is an operational handle.

Operational handles include filenames, module names, package names, identifiers, URLs, anchors, slugs, command names, registry keys, and other tool-facing names.

Handles may simplify, transliterate, lowercase, abbreviate, or otherwise regularize the canonical name for practical use. A handle does not rename the concept.

Examples:

```text
Canonical name: C4
Filename:       c4_specification.md
Module handle:  c4
Code type:      C4Graph
CLI handle:     c4
Display label:  C4

Canonical name: SARDINE
Filename:       sardine_specification.md
Module handle:  sardine
Code type:      SardineParser
CLI handle:     sardine
Display label:  SARDINE

Canonical name: Herring Bones
Filename:       herring_bones_guide.md
Module handle:  herring_bones
Code type:      HerringBone
CLI handle:     herring-bones
Display label:  Herring Bones

Canonical name: CAThedral
Filename:       cathedral_specification.md
Module handle:  cathedral
Code type:      CathedralTrace
CLI handle:     cathedral
Display label:  CAThedral

Canonical name: PÂTE
Filename:       pate_specification.md
Module handle:  pate
Code type:      PateLayout
CLI handle:     pate
Display label:  PÂTE
```

Use canonical display forms in prose, headings, UI labels, and user-facing documentation.

Use operational handles where stability, typing ergonomics, tool compatibility, path safety, or language conventions matter.

## Code Identifier Formatting

Project prose may use canonical display names.

Code identifiers should use ASCII unless a language, toolchain, or data format explicitly requires otherwise.

When converting project names into code identifiers:

1. Transliterate accented Latin characters to nearest ASCII.
2. Use the host language's normal identifier convention.
3. Preserve canonical spelling in user-facing strings, documentation headings, comments where helpful, and metadata.

Examples:

```text
Canonical display name: C4
Rust module:            c4
Rust type:              C4Graph
Python module:          c4
JavaScript function:    parseC4Fish
User-facing label:      C4

Canonical display name: SARDINE
Rust module:            sardine
Rust type:              SardineParser
Python module:          sardine
JavaScript function:    cleanFish
User-facing label:      SARDINE

Canonical display name: Herring Bones
Rust module:            herring_bones
Rust type:              HerringBone
Python module:          herring_bones
JavaScript function:    loadHerringBone
User-facing label:      Herring Bones

Canonical display name: CAThedral
Rust module:            cathedral
Rust type:              CathedralTrace
Python module:          cathedral
JavaScript function:    cookFish
User-facing label:      CAThedral

Canonical display name: PÂTE
Rust module:            pate
Rust type:              PateLayout
Python module:          pate
JavaScript function:    parsePateSpan
User-facing label:      PÂTE
```

Code identifiers are operational handles, not canonical names. ASCII code identifiers do not rename the project concept.

## Public-Scope Review

Before adding or publishing material here, check that it belongs to the public Purple Herring ecosystem and does not include private planning notes, unpublished integration notes, working drafts, internal project files, local scratch files, or process artifacts.

When in doubt, leave the material out until it has been reviewed.
