# Licensing

This repository uses multiple licenses by file category.

The licensing structure is intended to keep the official core implementation open, keep specifications and normative documents share-alike, preserve official design history without modified redistribution, allow unrestricted reuse of Herring Bones, and keep external blobs, APIs, user data, private ontologies, generated outputs, and proprietary graph stores outside the repository license boundary.

---

## 1. Core Implementation

Core implementation code is licensed under the GNU Affero General Public License v3.0 or later:

```text
SPDX-License-Identifier: AGPL-3.0-or-later
```

This applies to official core implementation code, including but not limited to:

* `src/`
* `crates/`
* `tools/`
* core C4 implementation code
* core SARDINE parser / canonicalizer / validator / formatter code
* core CAThedral / CPM / GEL implementation code
* official command-line tools built from the core implementation

The AGPL license is used to protect the openness of the official core toolchain, including modified versions provided over a network.

No private commercial relicensing path is planned for the official core implementation.

Organizations that cannot use AGPL-covered code may still adopt the C4 specifications, use CC0 Herring Bones materials, use permissively licensed API/client glue where provided, or create independent compatible implementations without incorporating AGPL-covered implementation code.

---

## 2. Specifications, Normative Documentation, and General Docs

Specifications, normative documentation, technical documentation, diagrams, and general explanatory materials are licensed under Creative Commons Attribution-ShareAlike 4.0 International:

```text
SPDX-License-Identifier: CC-BY-SA-4.0
```

This applies to materials such as:

* `specs/`
* `docs/`
* normative diagrams
* technical explanations
* tutorials and guides unless otherwise marked

The share-alike license is used so that modified versions of the specifications and core documentation remain open under the same terms.

---

## 3. Design History and Official Lineage Records

This category is included for official lineage/history materials that may be added to this repository if and when they are intentionally published. Materials that remain private should stay outside the public repository.

Design-history documents, official lineage records, origin notes, naming-history documents, and aesthetic/conceptual history documents are licensed under Creative Commons Attribution-NoDerivatives 4.0 International:

```text
SPDX-License-Identifier: CC-BY-ND-4.0
```

This applies to current or future materials such as:

* `design-history/`
* official historical lineage notes
* origin and naming-history records
* non-normative aesthetic/conceptual history supplements
* official donor-draft tombstones
* official naming-history records
* published boundary-history records, if intentionally added

These documents may be copied and redistributed with attribution, but modified versions may not be distributed.

Commentary, criticism, quotation, independent summaries, and separate historical analyses are welcome, but they should not be represented as modified versions of the official history documents.

This license is used to prevent altered copies from being redistributed as fake or misleading official history.

---

## 4. Herring Bones

Herring Bones templates, relation skeletons, starter ontologies, reusable relation libraries, reusable validation profiles, and similar reusable semantic materials are dedicated under CC0 1.0 Universal:

```text
SPDX-License-Identifier: CC0-1.0
```

This applies to materials such as:

* `herring-bones/`
* reusable relation templates
* relation skeletons
* starter ontology snippets
* reusable template libraries
* reusable test relation sets where marked

These materials are intended to be freely copied, changed, embedded, forked, reused, redistributed, and incorporated into other projects without restriction.

---

## 5. API, SDK, Adapter, and Integration Glue

This category is included now as a planned future integration surface, even if the repository does not yet contain API clients, SDKs, adapters, or integration glue.

API clients, SDK glue, protocol adapters, blob adapters, and integration examples may be licensed under a permissive software license where marked:

```text
SPDX-License-Identifier: Apache-2.0
```

or:

```text
SPDX-License-Identifier: MIT
```

This may apply to current or future materials such as:

* `api/`
* `sdk/`
* `adapters/`
* client libraries
* protocol bindings
* blob/API integration examples
* examples intended for easy third-party adoption
* public reference clients
* import/export adapters
* editor integrations
* language-server integration glue

Unless a file or directory is explicitly marked otherwise, official core implementation code remains AGPL-3.0-or-later.

---

## 6. External Data, Blobs, APIs, and Outputs

Use of C4, SARDINE, CAThedral, Herring Bones, or related tools to process, validate, transmit, store, query, transform, render, generate, or serve external materials does not by itself impose this repository's licenses on those external materials.

External materials include but are not limited to:

* blobs;
* API payloads;
* private ontologies;
* proprietary graph stores;
* private datasets;
* user data;
* generated outputs;
* documents processed by the toolchain;
* media files processed by the toolchain;
* third-party services accessed through adapters;
* independent compatible implementations.

The repository licenses apply to the repository materials themselves, not automatically to data merely processed with them.

---

## 7. Independent Implementations

The C4 specifications and related protocol/API descriptions are intended to support independent compatible implementations.

Independent implementations may be licensed however their authors choose, including proprietary licenses, provided they do not incorporate AGPL-covered implementation code or otherwise violate the applicable licenses for copied materials.

The official core implementation remains AGPL-3.0-or-later.

The specification is open for use and implementation under its documentation license.

Herring Bones materials are CC0 and may be reused without restriction.

---

## 8. File-Level License Notices

Where practical, files should include SPDX license identifiers.

Examples:

Core implementation code:

```rust
// SPDX-License-Identifier: AGPL-3.0-or-later
```

Specification or documentation Markdown:

```markdown
<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
```

Design-history Markdown:

```markdown
<!-- SPDX-License-Identifier: CC-BY-ND-4.0 -->
```

Herring Bones materials:

```text
# SPDX-License-Identifier: CC0-1.0
```

API / SDK / adapter glue:

```rust
// SPDX-License-Identifier: Apache-2.0
```

or:

```rust
// SPDX-License-Identifier: MIT
```

---

## 9. Recommended Repository License Files

The `LICENSES/` directory may include license texts for both currently used categories and planned future public categories. Keeping future license texts present is intentional: it records expected licensing boundaries before all public components exist. It does not imply that private materials belong in this repository.

A complete checkout should include the full license texts under `LICENSES/`:

```text
LICENSES/
  AGPL-3.0-or-later.txt
  CC-BY-SA-4.0.txt
  CC-BY-ND-4.0.txt
  CC0-1.0.txt
  Apache-2.0.txt
  MIT.txt
```

Major directories may also include local `LICENSE.md` files restating the license for that directory.

Recommended directory-level defaults:

```text
src/              AGPL-3.0-or-later
crates/           AGPL-3.0-or-later
tools/            AGPL-3.0-or-later
specs/            CC-BY-SA-4.0
docs/             CC-BY-SA-4.0
design-history/   CC-BY-ND-4.0
herring-bones/    CC0-1.0
api/              Apache-2.0 or MIT where marked; planned/future if absent
sdk/              Apache-2.0 or MIT where marked; planned/future if absent
adapters/         Apache-2.0 or MIT where marked; planned/future if absent
examples/         file- or directory-specific
```

---

## 10. Conflict Resolution

License resolution proceeds as follows:

```text
case all applicable license markers agree:
    the most specific marker controls
    file-level > directory-level > repository-level

case no file-level or directory-level marker exists:
    top-level LICENSE.md and repository layout control

case any applicable license markers conflict:
    treat as an error
    do not rely on any conflicting marker
    ask the repository maintainers before copying, redistributing, incorporating, or modifying the affected material

default:
    license is ambiguous
    ask before reuse
```

In summary, all applicable levels of licensing must agree before any specific license marker may be relied upon.

Applicable license markers include file-level SPDX identifiers, file-level license notices, directory-level `LICENSE.md` files, the top-level `LICENSE.md`, and the repository license layout.