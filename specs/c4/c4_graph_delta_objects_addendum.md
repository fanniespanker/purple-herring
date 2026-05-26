# C4 Graph-Delta Objects Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It defines graph-delta production in fully graph-native terms: delta sources are graph-objects, graph-deltas are graph-objects, graph comparison is represented by graph-objects, and materialization yields graph-objects.

This addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: 17. Relator Denotation and Graph-Delta Objects -->

## 18. Graph-Delta Objects

<!-- FOLLOWING SECTION: 19. Blocks -->

Graph-deltas are graph-objects.

Let:

$$
\Xi_\Delta\subseteq\Xi
$$

be the graph-delta graph-object subdomain.

A graph-delta object is written:

$$
\xi_\Delta\in\Xi_\Delta
$$

Because:

$$
\Xi_\Delta\subseteq\Xi
$$

every graph-delta is a C4 graph-object.

A graph-delta object represents denoted graph contribution, graph change, graph selection, graph construction, graph check, comparison result, diagnostic structure, materialization possibility, or profile-defined graph effect as graph structure.

A graph-delta is not an external diff payload, patch blob, transaction record, or non-graph data structure in C4 Core. A profile or protocol MAY project a graph-delta object into an external patch, transaction, diagnostic envelope, or status-code representation, but such projections are not primitive C4 Core semantics.

---

<!-- PRECEDING SECTION: 18. Graph-Delta Objects -->

## 19. Delta-Source Graph-Objects

<!-- FOLLOWING SECTION: 20. Graph-Delta Production -->

Delta production is graph-native.

Let:

$$
\Xi_\alpha\subseteq\Xi
$$

be the delta-source graph-object subdomain.

A delta-source graph-object is written:

$$
\xi_\alpha\in\Xi_\alpha
$$

A delta-source graph-object is any graph-object admissible as the source of graph-delta production under an active field.

Examples of delta-source graph-objects include:

- reified statement graph-objects;
- graph-comparison request graph-objects;
- materialization request graph-objects;
- validation/check request graph-objects;
- profile-defined delta-source graph-objects.

C4 Core does not define a separate non-graph domain of delta-source forms. Delta sources are graph-objects.

---

<!-- PRECEDING SECTION: 19. Delta-Source Graph-Objects -->

## 20. Graph-Delta Production

<!-- FOLLOWING SECTION: 21. Statement Denotation as Delta Production -->

The general graph-delta production operator is:

$$
\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta
$$

where:

- $\mathfrak{F}$ is the active C4 field;
- $\Xi_\alpha$ is the delta-source graph-object subdomain;
- $\Xi_\Delta$ is the graph-delta graph-object subdomain.

For:

$$
\xi_\alpha\in\Xi_\alpha
$$

graph-delta production is written:

$$
\boldsymbol{\delta}_{\mathfrak{F}}(\xi_\alpha)=\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi_\Delta
$$

The output graph-delta object $\xi_\Delta$ is a graph-object whose internal graph structure describes the produced delta.

The operator $\boldsymbol{\delta}_{\mathfrak{F}}$ is partial. It is undefined when the delta-source graph-object is not admissible under $\mathfrak{F}$, when required graph structure is unavailable, when required correspondence or comparison policy is unresolved, or when profile-relative delta-production validation fails.

---

<!-- PRECEDING SECTION: 20. Graph-Delta Production -->

## 21. Statement Denotation as Delta Production

<!-- FOLLOWING SECTION: 22. Graph-Comparison Delta Sources -->

Statement denotation is a specialization of graph-delta production.

For statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

its statement graph-object is:

$$
\iota_P(P)\in\Xi
$$

When the statement graph-object is admissible as a delta source:

$$
\iota_P(P)\in\Xi_\alpha
$$

statement denotation may be written as:

$$
\mathbf{d}_{\mathfrak{F}}(P)
:=
\boldsymbol{\delta}_{\mathfrak{F}}(\iota_P(P))
$$

Thus:

$$
\mathbf{d}_{\mathfrak{F}}(P)=\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi_\Delta
$$

The notation $\mathbf{d}_{\mathfrak{F}}$ is a convenience notation for statement denotation. It does not introduce a separate non-graph denotation process outside graph-delta production.

Relator-specific endpoint consumption and relator semantics determine how the statement graph-object produces its graph-delta object under $\boldsymbol{\delta}_{\mathfrak{F}}$.

---

<!-- PRECEDING SECTION: 21. Statement Denotation as Delta Production -->

## 22. Graph-Comparison Delta Sources

<!-- FOLLOWING SECTION: 23. Diff Graph Structure -->

Graph comparison is represented by delta-source graph-objects, not by primitive comparison tuples.

A graph-comparison delta-source object:

$$
\xi_{cmp}\in\Xi_\alpha
$$

is a graph-object whose internal graph structure describes a comparison request or comparison source.

A graph-comparison delta-source object MAY contain:

- source-side graph region or graph-bearing object;
- target-side graph region or graph-bearing object;
- comparison scope;
- correspondence, equivalence, or substitution policy;
- comparison mode;
- validation policy;
- profile-defined comparison metadata.

Graph comparison is performed by applying the general delta-production operator:

$$
\boldsymbol{\delta}_{\mathfrak{F}}(\xi_{cmp})=\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi_\Delta
$$

No primitive C4 operation assumes object identity between compared graph structures. Correspondence, equivalence, substitutability, or comparison alignment is determined by the active field $\mathfrak{F}$ and by graph metadata encoded in the comparison delta-source object.

If no correspondence, equivalence, or substitution policy is supplied or derivable under $\mathfrak{F}$, comparison MAY still produce a structural or canonical diff under the active profile, but it MUST NOT claim semantic identity.

---

<!-- PRECEDING SECTION: 22. Graph-Comparison Delta Sources -->

## 23. Diff Graph Structure

<!-- FOLLOWING SECTION: 24. Ordered and Recursive Source/Target Marking -->

A graph-comparison delta is one graph, rooted at a graph-delta/status graph-object.

The source and target of comparison are ordinary graph regions or graph-objects inside the diff graph, marked by graph structure.

Added, removed, modified, equivalent, unresolved, ambiguous, failed, and profile-defined statuses are graph markings, status graph-objects, or marked subgraphs inside the diff graph. They are not external lists or non-graph fields.

A diff graph MAY contain:

- a root/status graph-object;
- source-marked graph regions;
- target-marked graph regions;
- correspondence graph-objects;
- added-marked subgraphs;
- removed-marked subgraphs;
- modified-marked correspondence structures;
- equivalent or substitutable structures;
- unresolved or ambiguous comparison structures;
- diagnostic graph-objects;
- materialization metadata.

A removed edge or added edge is represented by including the edge graph-object itself in the diff graph and marking it as removed or added under the active comparison policy.

Since edges are graph-objects:

$$
\eta\in\Xi_\eta\subseteq\Xi
$$

edge-level comparison markings are graph-object markings like any other diff marking.

---

<!-- PRECEDING SECTION: 23. Diff Graph Structure -->

## 24. Ordered and Recursive Source/Target Marking

<!-- FOLLOWING SECTION: 25. Difference Markings Without Identity -->

Graph comparison is directional.

The source and target roles form an ordered comparison frame.

The source role denotes the prior, input, left, before, or source-side comparison region.

The target role denotes the later, output, right, after, or target-side comparison region.

Added and removed markings are interpreted relative to this ordering:

- added structure is target-side graph structure with no accepted source-side correspondence under the active comparison policy;
- removed structure is source-side graph structure with no accepted target-side correspondence under the active comparison policy.

Swapping the source and target roles may invert added and removed markings.

Source and target markings MAY apply recursively over graph regions.

A profile MUST define the traversal boundary, containment relation, comparison-scope relation, or propagation rule by which recursive source/target marking propagates.

If no recursive propagation policy is supplied or derivable under $\mathfrak{F}$, source and target markings apply only to the explicitly marked graph-objects.

Recursive marking MUST preserve graph structure unless an explicit policy projects, filters, collapses, or expands the marked region.

---

<!-- PRECEDING SECTION: 24. Ordered and Recursive Source/Target Marking -->

## 25. Difference Markings Without Identity

<!-- FOLLOWING SECTION: 26. Materialization of Graph-Deltas -->

C4 Core does not assume primitive identity.

A graph diff MUST NOT define modification as “the same object changed” unless a profile explicitly supplies an identity-like correspondence policy.

Instead, difference markings are interpreted through graph-defined correspondence, equivalence, or substitutability.

A modified structure is a source-side graph structure and a target-side graph structure placed in correspondence under the active comparison policy, where their recursively compared graph structures differ under that policy.

An equivalent or substitutable structure is a source-side graph structure and a target-side graph structure placed in correspondence under the active comparison policy and accepted as equivalent or substitutable by that policy.

An unresolved structure is a comparison structure for which correspondence, equivalence, substitutability, or difference classification is not resolved under $\mathfrak{F}$.

An ambiguous structure is a comparison structure for which multiple incompatible correspondences or classifications are available under $\mathfrak{F}$.

All such statuses are represented as graph structure in $\xi_\Delta$.

---

<!-- PRECEDING SECTION: 25. Difference Markings Without Identity -->

## 26. Materialization of Graph-Deltas

<!-- FOLLOWING SECTION: 27. Status Codes and Protocol Projection -->

Materialization is graph-native.

Materialization is written:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi
$$

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
\xi_\mu\in\Xi
$$

The materialization result may be a materialization-record graph-object, patch graph-object, realized graph-object, diagnostic graph-object, index graph-object, projection graph-object, or profile-defined result graph-object.

Materialization MAY project a graph-delta into operational structures such as patches, transactions, indexes, derived statements, diagnostics, or protocol messages, but those projections are not primitive C4 Core semantics.

---

<!-- PRECEDING SECTION: 26. Materialization of Graph-Deltas -->

## 27. Status Codes and Protocol Projection

<!-- FOLLOWING SECTION: 28. Integration Notes for Graph-Delta Objects -->

C4 Core MAY define graph-delta status graph-objects or status relations, but numeric status codes are not primitive C4 Core semantics.

Numeric status codes, status-code families, protocol envelopes, request/response framing, diagnostic envelopes, profile negotiation, and transport/interchange conventions belong to Fish or another C4 protocol/profile layer.

A protocol MAY assign numeric codes to graph status objects, diff status objects, materialization results, diagnostics, or comparison outcomes.

Such numeric codes are protocol identifiers for graph-defined statuses, not replacements for the graph structure of $\xi_\Delta$.

---

<!-- PRECEDING SECTION: 27. Status Codes and Protocol Projection -->

## 28. Integration Notes for Graph-Delta Objects

<!-- FOLLOWING SECTION: 29. Open Questions for Graph-Delta Objects -->

When this addendum is incorporated into the C4 Mathematical Core, the following integration edits SHOULD be applied.

The section currently titled `Relator Denotation and Graph-Delta Objects` SHOULD be split or revised so that:

- relator denotation is described as one producer of graph-delta objects;
- graph-delta objects are defined as $\Xi_\Delta\subseteq\Xi$;
- delta-source graph-objects are defined as $\Xi_\alpha\subseteq\Xi$;
- general graph-delta production is defined as $\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta$;
- statement denotation is defined as $\mathbf{d}_{\mathfrak{F}}(P):=\boldsymbol{\delta}_{\mathfrak{F}}(\iota_P(P))$;
- materialization is defined as $\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi$.

The core spec SHOULD preserve the distinction among:

- statement graph-objects;
- delta-source graph-objects;
- graph-delta graph-objects;
- graph-comparison delta-source graph-objects;
- graph-delta materialization results;
- protocol-level status-code projections.

The canonical statement tuple MUST remain unchanged:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

The graph-native rule SHOULD remain explicit:

> Everything meaningful in the graph-delta layer is represented as graph-objects or graph structure.

---

<!-- PRECEDING SECTION: 28. Integration Notes for Graph-Delta Objects -->

## 29. Open Questions for Graph-Delta Objects

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- exact minimal graph schema for graph-delta objects $\xi_\Delta$;
- exact minimal graph schema for delta-source graph-objects $\xi_\alpha$;
- exact minimal graph schema for graph-comparison delta-source objects $\xi_{cmp}$;
- whether $\Xi_\alpha$ and $\Xi_\Delta$ should be profile-relative predicates rather than fixed subdomains;
- whether statement graph-objects are always admissible delta-source graph-objects;
- how source/target recursive marking propagates across different graph containment, traversal, projection, and profile boundaries;
- whether C4 Core should define standard graph status objects such as equivalent, different, partial, unresolved, ambiguous, and failed;
- how graph-delta objects relate to active graph state without assuming primitive identity;
- how correspondence, equivalence, and substitutability policies are represented as graph-objects;
- whether materialization results require a dedicated subdomain such as $\Xi_\mu$;
- whether Fish protocol status codes should be defined in a separate Fish status-code registry document.
