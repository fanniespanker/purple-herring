# C4 Specifications

C4 is the Contextual Compositional Concept Calculus.

C4 Core is the minimum graph-native theory needed to explain Fish graph syntax, request fish, status fish, graph-delta/fond projections, and materialization-result projections.

C4 is not a Fish dialect, protocol profile, status registry, diff format, transport format, or implementation schema.

Fish and Fish profiles define concrete syntax, request/response graphs, result-schema negotiation, compact encodings, status projections, diagnostics, and protocol behavior.

---

## Authoritative Core

### C4 Mathematical Core

File: `c4_mathematical_core.md`

This is the authoritative C4 Core draft.

It defines:

- graph containers, names, and graph-objects;
- expressions and active fields;
- relation states;
- statements and relators;
- endpoint consumption at the minimum theoretical level;
- statement/block reification;
- graph-delta production;
- statement denotation as graph-delta production;
- materialization;
- canonicalization and validation boundaries;
- no primitive identity;
- the C4/Fish protocol boundary.

The current C4 Core deliberately leaves concrete schemas, protocol behavior, status projections, result schemas, and compact encodings to Fish or implementation/profile layers.

---

## Superseded / Design-History Addenda

The following addenda predate the minimized `c4_mathematical_core.md` v0.2.1 consolidation.

Their stable C4 Core portions have been absorbed into `c4_mathematical_core.md` where appropriate. They remain useful as design history, rationale, or possible source material for Fish/profile/implementation documents, but they are not independently authoritative C4 Core specifications unless a later document explicitly references them.

- `c4_notation_stabilization_addendum.md`
- `c4_graph_delta_objects_addendum.md`
- `c4_graph_delta_minimal_schema_addendum.md`
- `c4_endpoint_policy_minimal_schema_addendum.md`
- `c4_relator_metadata_minimal_schema_addendum.md`
- `c4_materialization_minimal_model_addendum.md`

### Important supersession notes

`c4_graph_delta_minimal_schema_addendum.md` contains concrete diff/comparison markings such as added, removed, modified, unchanged, and unresolved. Those markings are no longer C4 Core requirements. They may be reused by Fish or a profile, but C4 Core now keeps graph-delta schema loose.

`c4_endpoint_policy_minimal_schema_addendum.md` contains endpoint-policy schema and compilation details. C4 Core now keeps endpoint policy as minimal theory and treats compilation as implementation behavior.

`c4_relator_metadata_minimal_schema_addendum.md` contains more relator metadata structure than C4 Core currently requires. The authoritative core retains only the minimum relator theory needed by Fish.

`c4_materialization_minimal_model_addendum.md` contains useful materialization rationale. The authoritative core retains only the abstract operator:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu
$$

and leaves materialization-result schema to Fish, materializers, or profiles.

---

## Boundary with Fish

C4 defines the minimum graph-native theory.

Fish defines:

- concrete graph syntax;
- Fish namespace conventions;
- Fish IDs and addresses;
- request fish;
- response graphs;
- status-only graph responses;
- status enums and status words;
- result-schema negotiation;
- graph-delta/fond projections;
- materialization-result projections;
- diagnostic envelopes;
- profile negotiation;
- transport/interchange behavior.

Fish projections may summarize, serialize, transport, negotiate, or compactly encode C4 graph-objects. They do not replace C4 graph-native semantics.

---

## Current C4 Open Work

Likely remaining C4 work:

- audit `c4_mathematical_core.md` for any remaining profile/protocol/implementation overreach;
- decide whether the superseded addenda should eventually receive explicit banners at the top of each file;
- keep C4 Core minimal unless Fish requires additional theory.
