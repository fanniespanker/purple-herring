# C4 Materialization Minimal Model Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It defines a deliberately small graph-native materialization model.

The addendum introduces materialization-result graph-objects while avoiding a fixed materialization-result schema. Result layout, protocol envelopes, status codes, patch formats, diagnostics, and response framing are profile-, materializer-, validator-, implementation-, or Fish-defined.

This addendum assumes the graph-delta model from `c4_graph_delta_objects_addendum.md`:

$$
\Xi_\alpha\subseteq\Xi
$$

$$
\Xi_\Delta\subseteq\Xi
$$

$$
\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta
$$

and the graph-delta minimal schema from `c4_graph_delta_minimal_schema_addendum.md`.

The body of this addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: Graph-Delta Objects -->

## Materialization Minimal Model

<!-- FOLLOWING SECTION: Blocks -->

Materialization is the graph-native interpretation, processing, realization, projection, or application of a graph-delta object under an active field.

Materialization is not identical to mutation.

Mutation of persistent graph state is one possible materialization behavior. Other possible materialization behaviors include validation, diagnostics, indexing, projection, export, query-result construction, protocol response construction, no-op confirmation, or profile-defined processing.

C4 Core does not require every graph-delta to be materialized.

C4 Core does not require materialization to mutate graph state.

---

<!-- PRECEDING SECTION: Materialization Minimal Model -->

## Materialization-Result Graph-Objects

<!-- FOLLOWING SECTION: Materialization Operator -->

Let:

$$
\Xi_\mu\subseteq\Xi
$$

be the materialization-result graph-object subdomain.

A materialization-result graph-object is written:

$$
\xi_\mu\in\Xi_\mu
$$

Because:

$$
\Xi_\mu\subseteq\Xi
$$

every materialization result is a C4 graph-object.

C4 Core does not define a fixed schema for materialization-result graph-objects.

A materialization-result graph-object may represent:

- a materialization record;
- a graph patch or patch-like graph structure;
- a realized or updated graph-object;
- a query-result graph-object;
- a diagnostic graph-object;
- an index update result;
- a projection or export result;
- a protocol response object;
- a no-op result;
- a rejection or failure result;
- a profile-defined materialization result.

The role subdomain $\Xi_\mu$ identifies materialization-result graph-objects. It does not impose an internal layout.

---

<!-- PRECEDING SECTION: Materialization-Result Graph-Objects -->

## Materialization Operator

<!-- FOLLOWING SECTION: Materializers -->

Materialization is written:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu
$$

where:

- $\mathfrak{F}$ is the active C4 field;
- $\Xi_\Delta$ is the graph-delta graph-object subdomain;
- $\Xi_\mu$ is the materialization-result graph-object subdomain.

For:

$$
\xi_\Delta\in\Xi_\Delta
$$

materialization is written:

$$
\mathbf{m}_{\mathfrak{F}}(\xi_\Delta)=\xi_\mu
$$

where:

$$
\xi_\mu\in\Xi_\mu
$$

The operator $\mathbf{m}_{\mathfrak{F}}$ is partial. It is undefined when the graph-delta is not admissible for materialization under $\mathfrak{F}$, when the active materializer cannot interpret the graph-delta, when required policy is unavailable, or when profile-relative materialization validation fails.

A profile MAY define total materializers by returning failure, rejection, unresolved, or diagnostic materialization-result graph-objects instead of leaving $\mathbf{m}_{\mathfrak{F}}$ undefined.

---

<!-- PRECEDING SECTION: Materialization Operator -->

## Materializers

<!-- FOLLOWING SECTION: Materialization and Mutation -->

A materializer is a graph-delta interpreter or processor.

A materializer consumes graph-delta graph-objects and produces materialization-result graph-objects.

Materializers may be:

- mutating materializers;
- read-only materializers;
- diagnostic materializers;
- indexing materializers;
- projection or export materializers;
- query-result materializers;
- protocol-response materializers;
- no-op materializers;
- profile-defined materializers.

C4 Core does not require a single universal materializer.

The active field $\mathfrak{F}$ determines which materializer, materialization profile, materialization policy, or materialization registry is available.

---

<!-- PRECEDING SECTION: Materializers -->

## Materialization and Mutation

<!-- FOLLOWING SECTION: Materialization Result Schema -->

Relators do not directly mutate persistent graph state in C4 Core.

Relators participate in graph-delta production.

Graph-delta objects may describe graph contributions, graph changes, graph selections, graph checks, graph constructions, or profile-defined effects.

Materializers interpret graph-delta objects.

Only materialization MAY mutate persistent graph state, and mutation is only one possible materialization behavior.

Thus:

$$
\xi_\alpha
\overset{\boldsymbol{\delta}_{\mathfrak{F}}}{\longmapsto}
\xi_\Delta
\overset{\mathbf{m}_{\mathfrak{F}}}{\longmapsto}
\xi_\mu
$$

where:

$$
\xi_\alpha\in\Xi_\alpha,
\quad
\xi_\Delta\in\Xi_\Delta,
\quad
\xi_\mu\in\Xi_\mu
$$

Graph-delta production is denotational. Materialization is interpretive/processing behavior. Persistent graph mutation, when it occurs, is materializer behavior.

---

<!-- PRECEDING SECTION: Materialization and Mutation -->

## Materialization Result Schema

<!-- FOLLOWING SECTION: Protocol Projection -->

C4 Core defines the materialization-result graph-object subdomain:

$$
\Xi_\mu\subseteq\Xi
$$

but does not define a fixed materialization-result schema.

Profiles, materializers, validators, implementations, or Fish MAY define materialization-result schemas including:

- result roots;
- result statuses;
- patch graphs;
- transaction records;
- mutation records;
- query-result regions;
- diagnostic structures;
- materializer provenance;
- protocol response envelopes;
- numeric status-code mappings;
- profile-defined result structures.

Such schemas MUST remain graph-native if they claim C4 materialization-result conformance.

---

<!-- PRECEDING SECTION: Materialization Result Schema -->

## Protocol Projection

<!-- FOLLOWING SECTION: Integration Notes for Materialization Minimal Model -->

Protocol-level materialization responses are not primitive C4 Core semantics.

Fish or another protocol/profile layer MAY project materialization-result graph-objects into:

- numeric status codes;
- response envelopes;
- diagnostic messages;
- patch payloads;
- transaction payloads;
- serialized result graphs;
- transport-level success or failure responses.

Such protocol projections identify, serialize, transport, or summarize graph-native materialization-result objects. They do not replace the graph-object semantics of $\xi_\mu$.

---

<!-- PRECEDING SECTION: Protocol Projection -->

## Integration Notes for Materialization Minimal Model

<!-- FOLLOWING SECTION: Open Questions for Materialization Minimal Model -->

When this addendum is incorporated into the C4 Mathematical Core or a standard C4 materialization profile, the following integration edits SHOULD be applied.

The Graph-Delta Objects section SHOULD define materialization as:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu
$$

rather than merely:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi
$$

The graph-object universe section SHOULD list materialization-result graph-objects among possible C4 graph-objects.

The relator metadata section SHOULD state that relators participate in graph-delta production but do not directly mutate persistent graph state in C4 Core.

The graph-delta section SHOULD state that graph-deltas may describe potential mutation but mutation occurs only, if at all, through materialization.

Fish or another protocol layer SHOULD define numeric materialization status codes and protocol envelopes separately from C4 Core.

---

<!-- PRECEDING SECTION: Integration Notes for Materialization Minimal Model -->

## Open Questions for Materialization Minimal Model

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- whether $\Xi_\mu$ should be a fixed subdomain or a profile-relative predicate over $\Xi$;
- whether C4 should define standard materialization result statuses or leave all statuses to profiles/Fish;
- whether materializer graph-objects should have their own role subdomain;
- whether materialization should be allowed to return multiple materialization-result graph-objects or a result graph containing multiple result regions;
- how mutating materializers should represent before/after state without assuming primitive identity;
- how materialization provenance should refer to the active field $\mathfrak{F}$;
- how Fish protocol status-code registries should reference materialization-result graph-objects.
