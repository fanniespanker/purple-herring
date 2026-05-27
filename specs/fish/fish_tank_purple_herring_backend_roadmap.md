# Fish Tank: Purple Herring Backend Roadmap

## Status

This document is a planning draft for Purple Herring graph persistence, backend abstraction, and possible future Fish-native database work.

It is not an implementation commitment. It records the preferred backend strategy, architectural boundaries, and milestones for moving from ordinary storage substrates toward a possible dedicated Fish-native graph database.

The provisional name for a hypothetical future Fish-native graph database is **Mongres**.

This draft is aligned with the Fish v0.3 language direction:

- Fish statements use relation-state operators such as `&+`, `&-`, `&`, `&+?`, `&-?`, and `&?`;
- relators are relator phrases rather than underscore-bound template names;
- relator phrases may contain embedded Fish components delimited by `{ ... }`;
- Schools and graph regions may have AUIDs derived from layered canonical projections;
- Fish packages use `fish[0]` as the package root FRI / capo al fin;
- full School Fish is carried in bodies/files/payloads, while FRIs remain the restricted address-oriented surface.

---

## 1. Purpose

Purple Herring needs persistent graph infrastructure capable of storing, querying, materializing, and projecting Fish/C4 graph structures.

The backend must eventually support:

- Fish statements as first-class graph resources;
- relator phrases as structured graph objects;
- embedded Fish components inside relator phrases;
- Schools and package-scoped fish sequences;
- FRIs / fries;
- AUIDs and other identifier forms;
- opaque identifiers and content/provenance identifiers;
- resolved positive relations;
- resolved negative relations;
- resolved non-polar / middle relations;
- unresolved positive relations;
- unresolved negative relations;
- unresolved non-polar / middle relations;
- assertion-state queries;
- query variables and binding results;
- graph-change materialization;
- graph-delta / fond projections;
- materialization-result projections;
- diagnostic projections;
- provenance and ingestion traces;
- atomic mutation boundaries;
- authored source preservation;
- canonical graph storage views.

The preferred strategy is to build Fish-native semantics above ordinary storage first, then optimize or replace the storage substrate later if real workloads justify it.

---

## 2. Design Principle

Purple Herring semantics belong to the Purple Herring/Fish/C4 layer.

The storage backend should initially be treated as a persistence and indexing substrate, not as the authority on Fish semantics.

The core rule:

```text
Do not require the database to understand Fish.
Require Purple Herring to compile Fish semantics onto a backend abstraction.
```

This keeps the semantic model portable and prevents early backend choices from freezing the language design.

Storage SHOULD distinguish:

```text
authored source view
  preserves user-written Fish source, formatting, comments, line/column references,
  and other editing/diagnostic information

canonical graph view
  normalized logical representation used for storage, indexing, AUID computation,
  comparison, projection, query planning, and graph-delta production
```

Canonical graph views SHOULD be derived from parsed Fish structure, not raw source text.

Whitespace and comments are source annotations and MUST NOT affect canonical storage identity or AUID computation.

---

## 3. Backend Architecture

The desired long-term architecture is layered:

```text
Fish source / FRI / School / HTTP binding
        ↓
SARDINE parser and canonicalizer
        ↓
Fish Native Logical Graph Engine
        ↓
Materializer / Query Planner / Projection Engine
        ↓
Backend Adapter API
        ↓
Postgres / document DB / graph DB / custom store / Mongres
```

The Fish Native Logical Graph Engine owns:

- statement semantics;
- relation-state semantics;
- relator phrase semantics;
- embedded Fish component interpretation;
- assertion states;
- unresolvedness;
- query binding;
- package-local fish indexing;
- FRI resolution;
- AUID profile evaluation;
- materialization policy;
- projection rules;
- diagnostic/result semantics.

The backend adapter owns:

- persistence;
- indexing;
- transaction execution;
- retrieval;
- backend-specific query compilation;
- migration hooks;
- storage-level integrity checks.

---

## 4. Core Logical Objects

A backend-independent Purple Herring graph model should include at least:

```text
Resource
Statement
RelatorPhrase
RelatorPhraseComponent
EmbeddedFishComponent
School
Package
PackageFish
FRI
AUID
Identifier
RelationState
AssertionState
BindingVariable
GraphChange
MaterializationUnit
GraphDeltaProjection
MaterializationResultProjection
Diagnostic
ProvenanceEdge
AuthoredSourceSpan
CanonicalGraphView
```

These are logical objects. A backend may store them as tables, documents, vertices, edges, key-value records, or native Fish objects.

---

## 5. Statement Reification

Fish statements should be stored as first-class objects, not merely as raw graph edges.

Example logical shape:

```text
Statement
  statement_id
  package_eid
  fish_index
  tail
  relation_state
  relator_phrase_id
  head
  canonical_fish
  source_fri
  profile
  provenance
  auid
```

`relation_state` should encode the six initial Fish relation states:

```text
RESOLVED_POSITIVE       &+
RESOLVED_NEGATIVE       &-
RESOLVED_NON_POLAR      &
UNRESOLVED_POSITIVE     &+?
UNRESOLVED_NEGATIVE     &-?
UNRESOLVED_NON_POLAR    &?
```

This allows Purple Herring to represent unresolved, negative, non-polar, ambiguous, and provenance-bearing relations without requiring a COTS graph database to implement Fish-specific edge semantics.

---

## 6. Relator Phrase Storage

Relator phrases are structured graph objects, not raw predicate strings.

Example Fish:

```fish
#/Diane &+ is {
  *role &+ ph:label @ "sister";
  *role &- ph:type @ modo:family_relation/sister;
} of @ #/Andrea;
```

Example logical shape:

```text
RelatorPhrase
  relator_phrase_id
  components[]
  canonical_form
  auid

RelatorPhraseComponent
  component_index
  component_kind
  canonical_payload
  embedded_component_id
  auid

EmbeddedFishComponent
  embedded_id
  kind
  school_id / statement_id / resource_id
  auid
```

Relator phrase components may include:

- word components;
- namespace-qualified resource components;
- embedded Fish components;
- query variables;
- profile-defined components.

Whitespace between relator phrase components is syntactic separation only. Storage SHOULD preserve authored whitespace for editing/diagnostics but MUST use canonical component structure for graph semantics and AUID computation.

Embedded Fish components inside relator phrases participate in canonicalization through their own graph objects and AUIDs.

---

## 7. Package Model

A Fish package is an ordered fish sequence plus a carrier/provenance edge.

Current package model:

```text
fish[0]   = package root FRI
fish[1..] = School payload fish
```

The package root FRI may be informally called the **capo al fin**.

This term is non-normative. The normative term is **package root FRI**.

Package identity candidate:

```text
package_eid = package_AUID || carrier_edge_uuid_128
```

Where `package_AUID` is derived from the canonical package projection and `carrier_edge_uuid_128` identifies the carrier/import/materialization edge.

Package-local fish handles:

```text
fish:eid:<package-token>/fish/0
fish:eid:<package-token>/fish/1
fish:eid:<package-token>/fish/2
```

`fish/0` denotes the package root FRI.

`fish/1` denotes the first payload Fish statement.

Package-local indexes are locators, not standalone content identifiers.

Payload fish MUST NOT change the package root context for following fish.

---

## 8. AUIDs and Canonical Storage

An Aquatically Unique Identifier, or AUID, is a deterministic recursive hash over the canonical local payload of a Fish/C4 resource tree, subtree, School, or bounded graph region plus the AUIDs of its immediate descendants in canonical order.

AUIDs are expected to become important for graph storage, deduplication, incremental canonicalization, fond production, caching, and verification.

AUID computation is layered:

```text
parent_AUID = H(local_payload_hash(parent) || ordered_immediate_child_AUID_records(parent))
```

A parent AUID is derived from the AUIDs of its immediate descendants only.

A parent canonical projection contains:

```text
canonical local payload
canonical immediate branch records containing child AUIDs
```

It does not embed the canonical projections of all descendants.

Deeper descendant structure affects an ancestor only recursively through the AUIDs of immediate children.

This supports incremental canonicalization:

```text
changed child/subregion
  → recompute changed child AUID
  → update parent branch record containing that child AUID
  → recompute parent AUID
  → repeat up ancestor chain
```

Unchanged sibling regions do not need to be recanonicalized or rehashed.

Storage SHOULD therefore be able to cache:

- local payload hashes;
- immediate child branch records;
- child AUID lists;
- region AUIDs;
- package AUIDs;
- graph-delta/fond comparison indexes.

AUID encoding is carrier-defined. Storage MAY use binary AUID bytes internally even if HTTP/FRI/Fish source uses text encodings.

---

## 9. Candidate Relational Storage Shape

A PostgreSQL-backed MVP might use tables resembling:

```text
resources
  id
  fri
  kind
  canonical_payload
  local_payload_hash
  auid
  authored_source_id
  created_at

packages
  id
  package_eid
  package_auid
  root_fri
  carrier_edge_uuid
  created_at

package_fish
  package_id
  fish_index
  resource_id
  canonical_fish
  kind
  authored_source_span

statements
  id
  package_id
  fish_index
  tail_resource_id
  relation_state
  relator_phrase_id
  head_resource_id
  canonical_fish
  profile
  auid
  created_at

relator_phrases
  id
  canonical_form
  auid
  created_at

relator_phrase_components
  relator_phrase_id
  component_index
  component_kind
  canonical_payload
  embedded_component_id
  component_auid

embedded_fish_components
  id
  kind
  resource_id
  statement_id
  school_id
  auid

auid_branch_records
  parent_resource_id
  branch_index
  relator_auid
  child_auid
  edge_payload_hash
  edge_role
  assertion_state
  branch_record_hash

provenance_edges
  id
  edge_uuid
  source_agent
  target_service
  received_at
  transport_metadata

authored_sources
  id
  package_id
  source_text
  source_media_type
  created_at

diagnostics
  id
  related_resource_id
  related_statement_id
  severity
  code
  detail
  created_at
```

This is illustrative, not final.

---

## 10. Initial Backend Recommendation

The first implementation SHOULD use a boring, reliable backend.

Recommended MVP backend:

```text
PostgreSQL + JSONB + indexes
```

Rationale:

- strong transactions;
- mature persistence;
- ordinary deployment;
- JSONB for statement metadata and profile-specific payloads;
- relational indexes for common query paths;
- enough flexibility to evolve before the Fish model stabilizes.

Alternative early substrates may include:

- a document database;
- a multi-model document/graph database;
- an embedded key-value store with explicit indexes;
- a property graph database used as a persistence substrate.

The backend choice should not leak into Fish semantics.

---

## 11. Query Compilation Strategy

Fish queries should compile into backend queries through the logical graph engine.

Example Fish query:

```fish
#/Diane &+ is { $x } of @ #/Andrea;
```

Logical query conditions:

```text
tail = request_root / Diane
relation_state = RESOLVED_POSITIVE
relator_phrase = phrase("is", embedded_query_variable($x), "of")
head = request_root / Andrea
```

Example relation-variable query:

```fish
#/Diane &+ $r @ #/Andrea;
```

Logical query conditions:

```text
tail = request_root / Diane
relation_state = RESOLVED_POSITIVE
relator_phrase binds to $r
head = request_root / Andrea
```

The backend adapter may compile these conditions into SQL, document queries, graph traversals, custom indexes, or native Fish operations.

---

## 12. Binding-Parameterized Mutation

Purple Herring should support atomic operations that bind variables and use those variables in graph-change templates within the same request.

This is not session state.

Semantic sequence:

```text
1. Evaluate binding patterns against the pre-mutation graph state.
2. Instantiate mutation templates using accepted bindings.
3. Validate permissions, relation states, and materialization policy.
4. Commit the resulting graph change atomically.
```

A mutational operation that depends on bindings from a prior request would require explicit persisted graph state, not hidden session-local variables.

The mutation profile MUST define what happens when a binding pattern returns multiple matches:

```text
exactly_one
all
first_by_canonical_order
ambiguous_fail
profile_defined
```

The initial safe default SHOULD be `ambiguous_fail` unless the operation explicitly requests a multi-binding mode.

---

## 13. Specialized Indexes

As workloads mature, Purple Herring should add specialized indexes without replacing the backend immediately.

Candidate indexes:

```text
FRI path/trie index
statement tail-state-relator-head index
relation-state index
relator phrase AUID index
relator phrase component index
embedded Fish component index
query-variable binding support index
package_eid + fish_index index
provenance edge index
AUID index
local payload hash index
child AUID branch record index
unresolved relation index
graph-delta / fond region index
materialization-result index
```

Index design should be driven by observed workloads, not speculative completeness.

---

## 14. Backend Adapter Boundary

The backend adapter API should hide storage-specific details.

Candidate capabilities:

```text
resolve_fri(fri)
store_package(package)
store_statement(statement)
store_relator_phrase(relator_phrase)
store_embedded_fish_component(component)
query_statements(pattern)
query_bindings(pattern)
compute_or_fetch_auid(resource_or_region)
fetch_child_branch_records(resource_or_region)
apply_graph_change(change_unit)
begin_materialization_unit()
commit_materialization_unit()
rollback_materialization_unit()
store_projection_result(result)
store_diagnostic(diagnostic)
fetch_package_fish(package_eid, index)
fetch_resource(resource_id)
fetch_authored_source_span(resource_id)
```

Adapters may expose optional backend-specific features, but core Fish semantics should not depend on them.

---

## 15. Forking an Existing Graph Database

Forking an existing graph database may become useful later for targeted optimization, but it is not the preferred initial strategy.

Forking is attractive because an existing graph database may already provide:

- persistence;
- indexing;
- transactions;
- query planning;
- backup/restore;
- clustering;
- operational tooling.

Forking is risky because Purple Herring may need to alter foundational assumptions:

- edges are not always fully resolved;
- statements are resources;
- relator phrases may contain embedded graph structure;
- relation states are first-class;
- AUIDs and canonical projections are first-class;
- graph deltas and materialization units are semantic objects;
- package/provenance identity matters.

A fork should only be considered after the logical graph engine and workload data reveal a specific storage-layer bottleneck.

---

## 16. Database Plugin / Extension Path

Before forking, Purple Herring should consider backend extensions or plugins.

Possible plugin targets:

```text
custom SQL functions
custom PostgreSQL extension
custom index operator class
graph database plugin
query planner extension
stored procedures
materialized views
background indexer
```

Useful plugin goals:

- faster relator phrase matching;
- faster embedded Fish component lookup;
- faster unresolved relation search;
- package-local fish lookup;
- graph-delta / fond projection caching;
- materialization-unit transaction helpers;
- canonical Fish hash computation;
- AUID computation and invalidation;
- FRI path indexing.

A plugin should accelerate Fish-native operations without moving language semantics into an unmaintainable backend fork.

---

## 17. Hypothetical Fish-Native Database: Mongres

**Mongres** is the provisional name for a hypothetical future Fish-native graph persistence engine.

Mongres would be a storage engine designed around Fish/C4 logical objects instead of retrofitting Fish onto an ordinary property graph or relational database.

Mongres might natively support:

- Fish statement resources;
- relator phrase resources;
- embedded Fish components inside relator phrases;
- package fish sequences;
- `fish[0]` package root FRI / capo al fin;
- relation-state indexes;
- unresolved relations;
- relator phrase AUID indexes;
- AUID-based canonical storage;
- incremental AUID invalidation and recomputation;
- FishEID package identity;
- graph-delta / fond projections;
- atomic materialization units;
- diagnostic/result projections;
- provenance-aware query paths;
- authored source preservation;
- canonical Fish source and canonical graph object storage.

Mongres should remain hypothetical until adapter-backed implementations prove which native features are actually needed.

Non-normative tagline:

```text
Mongres: a Fish-native graph store for Purple Herring.
```

---

## 18. Milestones

### Milestone 0 — Backend-Neutral Specs

Goal: keep Fish and HTTP binding specs backend-independent.

Deliverables:

- Fish primary specification;
- Purple Herring HTTP binding;
- AUID notes;
- backend roadmap;
- open questions list.

Exit criteria:

- specs do not assume a specific graph database;
- package, FRI, School, relator phrase, relation-state, AUID, and operation endpoint semantics are defined at the language/binding layer.

---

### Milestone 1 — Logical Graph Model Draft

Goal: define backend-independent logical objects.

Deliverables:

- `Resource` model;
- `Statement` model;
- `RelatorPhrase` model;
- `EmbeddedFishComponent` model;
- `School` model;
- `Package` model;
- `RelationState` / `AssertionState` model;
- `AUID` model;
- `GraphChange` and `MaterializationUnit` model;
- `Diagnostic` and `ProjectionResult` model.

Exit criteria:

- Fish statements can be represented without choosing a database;
- unresolved, negative, and non-polar relations have explicit model positions;
- relator phrases can store embedded Fish structure;
- package-local indexing is represented.

---

### Milestone 2 — SARDINE Parse + Canonicalization Prototype

Goal: parse Fish source into logical objects.

Deliverables:

- parser for core Fish statements;
- parser for relation-state operators;
- parser for relator phrases;
- parser for embedded Fish components `{ ... }`;
- parser for Schools;
- parser for `><>` comments and comment schools;
- whitespace-insensitive parsing outside literals/comment schools;
- request-root expression support;
- query variables;
- canonical Fish serialization draft;
- package sequence builder with `fish[0] = root FRI`.

Exit criteria:

- a Fish body can be parsed into canonical package form;
- package-local fish indexes are deterministic under the prototype profile;
- comments/whitespace do not affect canonicalization;
- relator phrases and embedded Fish components survive round-trip canonicalization.

---

### Milestone 3 — AUID Prototype

Goal: compute AUIDs for Fish resources, statements, relator phrases, Schools, and bounded regions.

Deliverables:

- local payload hash function;
- immediate child branch record encoding;
- child collection mode handling;
- canonical unordered branch sorting;
- relation-state encoding;
- relator phrase AUIDs;
- embedded Fish component AUIDs;
- package AUIDs;
- cache invalidation prototype.

Exit criteria:

- AUIDs are computed from local payload + immediate child AUID records;
- unchanged sibling regions do not need recanonicalization after a local update;
- AUID encoding remains carrier-defined.

---

### Milestone 4 — MVP Backend Adapter

Goal: persist Fish logical objects using a boring backend.

Recommended backend:

```text
PostgreSQL + JSONB
```

Deliverables:

- backend adapter interface;
- PostgreSQL schema prototype;
- resource storage;
- package storage;
- statement storage;
- relator phrase storage;
- embedded Fish component storage;
- AUID storage;
- simple FRI lookup;
- package_eid + fish_index lookup.

Exit criteria:

- packages can be ingested, stored, and retrieved;
- individual fish can be located by package-local index;
- simple statements can be stored as reified objects;
- relator phrases are stored as structured objects, not only strings.

---

### Milestone 5 — Query MVP

Goal: evaluate basic Fish queries.

Deliverables:

- resource retrieval;
- concrete assertion query;
- relation-state query;
- relator-component query with `{ $x }`;
- relation-variable query with `$r`;
- assertion-state result vocabulary;
- JSON binding-table projection;
- Fish match projection.

Exit criteria:

- queries like `#/Diane &+ is { $x } of @ #/Andrea;` return bindings;
- queries like `#/Diane &+ $r @ #/Andrea;` return relator phrase bindings;
- relation-state query behavior is independent of backend-specific syntax.

---

### Milestone 6 — HTTP Operation Endpoint MVP

Goal: expose Fish query/add/mutate/delete operations over HTTP binding.

Deliverables:

- `.query` endpoint;
- `.add` endpoint;
- `.mutate` endpoint;
- `.delete` endpoint;
- `/.well-known/purple-herring` JSON discovery;
- media type handling for `application/vnd.purple-herring.fish`;
- request-root binding;
- atomic mutation boundary for mutational endpoints.

Exit criteria:

- raw Fish bodies can be submitted to operation endpoints;
- `.query` is read-only;
- mutational endpoints commit all-or-none for persistent graph state;
- full Fish source is carried in bodies, not encoded into address targets.

---

### Milestone 7 — Binding-Parameterized Mutation MVP

Goal: support one-request bind-and-mutate operations.

Deliverables:

- binding-pattern evaluation;
- mutation-template instantiation;
- cardinality policy;
- atomic validation and commit;
- diagnostic behavior for ambiguous bindings.

Exit criteria:

- variables bound within a mutational request can be used inside the same request;
- no hidden session-local variable state is required;
- ambiguous binding behavior is explicit.

---

### Milestone 8 — Materialization and Diagnostics

Goal: produce graph-change and diagnostic results.

Deliverables:

- graph-change validation;
- permission/materialization policy hooks;
- diagnostic objects;
- diagnostic summary projection;
- diagnostic disclosure policy placeholder;
- materialization-result summary projection.

Exit criteria:

- failed mutations produce structured diagnostics;
- rejected mutations do not partially commit;
- diagnostic disclosure can be restricted by policy.

---

### Milestone 9 — Specialized Index Pass

Goal: optimize the real query paths discovered in MVP use.

Deliverables:

- workload traces;
- query latency measurements;
- relator phrase index;
- embedded component index;
- relation-state index;
- AUID index;
- child branch record index;
- FRI path index;
- package-local lookup index;
- unresolved-relation query index if needed.

Exit criteria:

- common Fish queries have predictable performance;
- index complexity is justified by measured workload.

---

### Milestone 10 — Backend Portability Pass

Goal: prove that Fish semantics are not locked to one backend.

Deliverables:

- second backend adapter prototype, or mock backend with conformance tests;
- backend adapter conformance suite;
- canonical package ingestion tests;
- query result equivalence tests;
- AUID equivalence tests;
- atomicity behavior tests.

Exit criteria:

- the logical graph engine can run against more than one backend adapter;
- Fish semantics remain stable across backends.

---

### Milestone 11 — Plugin/Fork Feasibility Study

Goal: decide whether deeper backend integration is justified.

Deliverables:

- bottleneck report;
- backend extension candidates;
- graph database fork candidates;
- storage-engine requirements;
- cost/risk comparison;
- migration plan from adapter-backed storage.

Exit criteria:

- there is evidence for or against backend forking/plugin work;
- no fork begins without a specific optimization target.

---

### Milestone 12 — Mongres Research Prototype

Goal: experiment with a Fish-native storage engine if justified.

Deliverables:

- native statement storage layout;
- native relator phrase storage layout;
- embedded Fish component storage;
- package sequence storage;
- relation-state index;
- unresolved relation index;
- AUID index and invalidation mechanism;
- materialization-unit transaction prototype;
- graph-delta/fond projection prototype;
- import/export compatibility with Fish packages.

Exit criteria:

- Mongres demonstrates a clear advantage over adapter-backed storage for identified workloads;
- import/export preserves Fish package semantics;
- reliability requirements are understood before production use.

---

## 19. Anti-Milestones

The project should avoid the following premature commitments:

```text
Do not write a database before the logical model stabilizes.
Do not fork a graph database before workload data exists.
Do not encode Fish semantics exclusively in backend-specific queries.
Do not make Postgres, Neo4j, Arango, JanusGraph, or Mongres part of Fish semantics.
Do not make package-local indexes pretend to be global content identity.
Do not make diagnostic/result projection syntax depend on a storage engine.
Do not store relator phrases only as raw strings.
Do not make authored whitespace or comments part of canonical identity.
Do not make AUID text encoding part of storage semantics.
```

---

## 20. Open Questions

The following remain open:

- exact logical object model;
- exact package EID layout;
- exact AUID canonicalization profile;
- exact AUID digest length and hash algorithm;
- whether `fish:eid:` should encode package EIDs, edge EIDs, or both;
- whether package-local fish indexes are zero-based permanently;
- whether `fish[0]` as package root FRI should remain normative permanently;
- whether the capo al fin terminology belongs in the primary spec, backend notes, or culinary glossary;
- initial backend choice;
- adapter API shape;
- first query indexes;
- migration path from MVP storage to future specialized storage;
- whether relator phrase AUIDs should be first-class resources;
- whether embedded Fish components inside relator phrases should always be separately addressable;
- whether Mongres should ever be implemented as a fork, plugin, or from-scratch database.

