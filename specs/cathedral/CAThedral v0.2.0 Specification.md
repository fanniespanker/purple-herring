# CAThedral v0.2.0 Specification

## 0. Status

CAThedral v0.2.0 is the current public specification for the canonical graph-ritual / execution substack of the Purple Herring / C4 ecosystem.

Version delta:

```text
previous: v0.1.0
current:  v0.2.0
delta:    public-safety / C4-facing migration
```

CAThedral is reusable public graph infrastructure within the Purple Herring / C4 ecosystem.

This specification defines only the public CAThedral layer.

---

## 1. Purpose

CAThedral is the canonical graph-ritual substack of the Purple Herring / C4 ecosystem.

It names the reusable cluster through which herring-bone graph-script becomes canonical structure, validation, execution, patching, and inspection.

CAThedral is reusable graph-semantics infrastructure.

Likely CAThedral members:

```text
C4 / Purple Herring
SARDINE
Herring Bones
GEL
CPM
public debug projection tools, if exposed through a public profile
```

Current standalone extraction focuses on:

```text
CPM — Canonical Patch Machine
```

GEL, C4 / Purple Herring, SARDINE, and Herring Bones retain or require their own detailed specifications.

---

## 2. Pronunciation and Aesthetic Note

CAThedral is deliberately pronounced:

```text
[kætˈhiˌdɹʌl]
```

This is a historical/aesthetic joke, not a formal technical requirement.

It preserves the catgirl-priest / ritual-execution architecture pun while allowing GEL to remain the precise formal name for graph execution semantics.

---

## 3. Design Principles

1. **Canonical transformation before hidden execution**
   - Graph state changes must be explicit, inspectable, and replayable.

2. **No direct substrate mutation**
   - Canonical state changes occur through validated patches.

3. **Reusable graph infrastructure**
   - CAThedral is reusable public graph-semantics infrastructure within the Purple Herring / C4 ecosystem.

4. **Ontology-externalized semantics**
   - Relation meaning belongs to templates, libraries, and ontologies, not hidden parser behavior.

5. **Ritual as metaphor, determinism as law**
   - The ritual language is non-normative; deterministic execution is normative.

---

## 4. Canonical Patch Machine (CPM)

### 4.1 Purpose

CPM is the executable mutation law of a canonical graph substrate.

All canonical state changes occur through patches.

No subsystem mutates canonical substrate records directly.

---

### 4.2 Patch Lifecycle

```text
ProposedPatch
-> CanonicalizedPatch
-> ValidatedPatch
-> AppliedPatch
-> LoggedPatch
```

Patches are atomic.

Either the entire patch applies or nothing applies.

---

### 4.3 Patch Requirements

Patches must define:

- operation kind;
- target records;
- preconditions;
- canonical ordering;
- validation rules;
- resulting changes;
- diagnostics;
- replay serialization.

Patch failure behavior is execution-profile defined, but conformance mode should trap deterministically.

---

### 4.4 Relationship to External Patch Requests

External systems, execution profiles, validation profiles, substrate profiles, or implementation-defined mechanisms may request canonical patches.

CPM does not accept hidden mutation.

Every requested state change must become an explicit proposed patch, pass canonical validation, and be logged as an applied patch before it becomes canonical state.

CPM validates, applies, and logs canonical state changes.

---

## 5. Relationship to C4 / Purple Herring

C4 / Purple Herring provides graph-script and fish-language source structures.

CAThedral consumes canonicalized graph-script structures and may execute, validate, patch, or trace them depending on active profiles.

C4 expressions remain language-level structures; CAThedral is the canonical execution / patch / transformation apparatus.

---

## 6. Relationship to SARDINE and Herring Bones

SARDINE provides parsing, canonicalization, and tooling around C4 / Purple Herring source.

Herring Bones provides reusable relation templates, declaration templates, type templates, constructor templates, diagnostics, and validation profiles.

CAThedral may depend on SARDINE and Herring Bones to receive canonical graph structures and relation-template semantics.

---

## 7. Relationship to GEL

GEL is the graph execution semantics layer.

CAThedral includes or coordinates GEL when graph structures are enacted as deterministic execution traces.

GEL defines the execution law; CPM defines canonical mutation/patch law.

The precise boundary between GEL and CPM remains to be formalized.

---

## 8. External Consumers and Producers

External tools may provide C4 graph structures, proposed graph structures, execution requests, patch requests, validation requests, or canonicalization requests to CAThedral.

External tools may consume CAThedral traces, diagnostics, canonical patch logs, validation reports, canonical projections, and rendered or exported results.

CAThedral does not define those external tools.

Proposed-structure handling, where supported by an execution or validation profile, must remain deterministic and inspectable.

CAThedral does not rank proposed structures probabilistically.

---

## 9. Non-Goals

CAThedral is not:

- a replacement for C4 / Purple Herring;
- a replacement for GEL;
- a replacement for Herring Bones;
- a hidden mutation engine;
- a probabilistic candidate selector;
- an application-specific private subsystem.

CAThedral names the reusable canonical graph-ritual / execution apparatus.

---

## 10. Open Questions

- What is the exact boundary between GEL and CPM?
- Which CPM patch kinds are required for the first implementation?
- Should CPM live wholly inside CAThedral or be exportable as its own subcomponent?
- What canonical patch serialization should be used?
- How should C4 fish resources become patch targets?
- How should Herring Bones relation-template semantics become executable GEL transformations?
- Should public debug projection tools remain outside CAThedral or be optionally included through a public debug profile?
- What conformance tests prove patch atomicity and deterministic replay?

