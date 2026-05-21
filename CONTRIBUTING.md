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
   - `CNML Specification.md` -> `cnml_specification.md`
   - `PÂTE Specification.md` -> `pate_specification.md`

4. Avoid punctuation except underscore `_`, hyphen `-` when semantically useful, and period `.` for extensions.

5. Preserve the full preferred display title inside the document heading.

Examples:

```text
PÂTE Specification.md      -> pate_specification.md
CNML Specification.md      -> cnml_specification.md
CiNnaMoN Specification.md  -> cinnamon_specification.md
```

ASCII fallback filenames are convenience handles only. They do not change the project vocabulary, formal names, document titles, or required UTF-8 support.

## Stable Filenames

Current files should avoid version numbers, dates, status labels, and other lifecycle clutter unless the file is intentionally archival or one of several parallel versions.

Prefer stable semantic filenames whose contents can evolve without requiring renames.

Recommended:

```text
c4_technical_specification.md
c4_for_non_pescatarians.md
cathedral_specification.md
cnml_specification.md
pate_specification.md
cinnamon_specification.md
```

Avoid for current documents:

```text
c4_v0.1.6_technical_specification.md
CURRENT_c4_technical_specification.md
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
2026-05-21__c4_technical_specification__v0.1.6__current_snapshot.md
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
Canonical name: PÂTE
Filename:       pate_specification.md
Module handle:  pate
Code type:      PateLayout
CLI handle:     pate
Display label:  PÂTE

Canonical name: CiNnaMoN
Filename:       cinnamon_specification.md
Module handle:  cinnamon
Code type:      CinnamonScore
CLI handle:     cinnamon
Display label:  CiNnaMoN
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
Canonical display name: PÂTE
Rust module:            pate
Rust type:              PateLayout
Python module:          pate
JavaScript function:    parsePateSpan
User-facing label:      PÂTE

Canonical display name: CiNnaMoN
Rust module:            cinnamon
Rust type:              CinnamonScore
JavaScript type:        CinnamonScore
User-facing label:      CiNnaMoN
```

Code identifiers are operational handles, not canonical names. ASCII code identifiers do not rename the project concept.

## Public-Scope Review

Before adding or publishing material here, check that it belongs to the public Purple Herring ecosystem and does not include private planning notes, unpublished integration notes, working drafts, internal project files, local scratch files, or process artifacts.

When in doubt, leave the material out until it has been reviewed.