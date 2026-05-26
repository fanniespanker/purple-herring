# C4 Graph-Delta Minimal Schema Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It defines a deliberately small graph-native minimal schema for graph-delta objects.

The schema is intentionally sparse. Most graph-delta layout, correspondence representation, diagnostic representation, materialization metadata, and protocol projection is profile-, implementation-, materializer-, validator-, or Fish-defined.

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

The body of this addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: Graph-Delta Objects -->

## Graph-Delta Minimal Schema

<!-- FOLLOWING SECTION: Delta-Source Graph-Objects -->

A graph-delta object is a graph-object whose internal graph structure describes a produced delta.

C4 Core does not require a graph-delta object to use one fixed physical layout. A graph-delta profile MAY choose any layout that preserves the minimal C4 graph-delta semantics.

A minimally conforming graph-delta SHOULD expose the following as graph structure:

1. a graph-delta root;
2. a graph-native return/status;
3. ordered source and target region roles when the delta is comparison-derived;
4. graph-native difference markings over source-side and/or target-side graph regions.

The C4 Core minimal difference markings are:

- added;
- removed;
- modified;
- unchanged;
- unresolved.

These roles and markings are graph-defined. They are not enum primitives, non-graph fields, external lists, or protocol status codes.

Everything beyond this minimal shape is profile-defined unless another C4 specification explicitly standardizes it.

---

<!-- PRECEDING SECTION: Graph-Delta Minimal Schema -->

## Graph-Delta Root and Return Status

<!-- FOLLOWING SECTION: Source and Target Region Roles -->

A graph-delta object:

$$
\xi_\Delta\in\Xi_\Delta
$$

is the root of a graph-delta graph region.

The graph-delta root SHOULD provide an entry point to the delta graph.

A graph-delta root SHOULD have, or itself serve as, a graph-native return/status object.

C4 Core does not require a separate non-root status object. If a profile uses separate status objects, they remain ordinary graph-objects connected to the graph-delta root by graph structure.

Numeric status codes, status-code families, response codes, and protocol envelopes are not primitive C4 Core semantics. They belong to Fish or another protocol/profile layer. Numeric codes MAY identify status graph-objects but MUST NOT replace the graph structure of the delta.

---

<!-- PRECEDING SECTION: Graph-Delta Root and Return Status -->

## Source and Target Region Roles

<!-- FOLLOWING SECTION: Minimal Difference Markings -->

For comparison-derived graph-deltas, source and target roles form an ordered comparison frame.

The source role denotes the prior, input, left, before, or source-side comparison region.

The target role denotes the later, output, right, after, or target-side comparison region.

Added and removed markings are interpreted relative to this ordering.

Source and target regions are ordinary graph regions or graph-objects inside or referenced by the graph-delta graph. They are not external fields.

Source and target marking MAY apply recursively over graph regions.

Recursive source/target marking is profile-defined. A profile MUST define the traversal boundary, containment relation, comparison-scope relation, or propagation rule by which recursive side marking propagates. If no recursive propagation policy is supplied or derivable under the active field, source and target roles apply only to explicitly marked graph-objects.

---

<!-- PRECEDING SECTION: Source and Target Region Roles -->

## Minimal Difference Markings

<!-- FOLLOWING SECTION: Difference Markings Without Identity -->

The C4 Core minimal difference markings are:

- added;
- removed;
- modified;
- unchanged;
- unresolved.

These markings are graph structure.

A graph-object, graph region, edge/traversal object, correspondence object, or profile-defined comparison object may be marked by connecting it to a marking graph-object or by using a profile-defined marking relation.

The markings mean:

- **added**: target-side graph structure with no accepted source-side correspondence under the active comparison policy;
- **removed**: source-side graph structure with no accepted target-side correspondence under the active comparison policy;
- **modified**: source-side and target-side graph structures are accepted as corresponding under the active comparison policy, but their recursively compared structures differ under that policy;
- **unchanged**: source-side and target-side graph structures are accepted as corresponding and not materially different under the active comparison policy;
- **unresolved**: comparison, correspondence, substitutability, or difference classification is not resolved under the active field.

Added, removed, modified, unchanged, and unresolved regions SHOULD preserve relevant graph structure. They SHOULD NOT be represented only as flat external lists unless a profile explicitly projects the graph-delta into such a representation.

Since edge/traversal objects are graph-objects:

$$
\eta\in\Xi_\eta\subseteq\Xi
$$

edges can be marked as added, removed, modified, unchanged, or unresolved like any other graph-object.

---

<!-- PRECEDING SECTION: Minimal Difference Markings -->

## Difference Markings Without Identity

<!-- FOLLOWING SECTION: Profile-Defined Graph-Delta Schema -->

C4 Core does not assume primitive identity.

A graph diff MUST NOT define modification as “the same object changed” unless a profile explicitly supplies an identity-like correspondence policy.

Instead, difference markings are interpreted through graph-defined correspondence, equivalence, or substitutability under the active field.

C4 Core does not require a standard correspondence-object schema.

A profile MAY represent correspondence through reified correspondence graph-objects, direct graph relations, shared scope objects, path-correspondence objects, substitution-policy objects, or any other graph-native structure.

The only C4 Core requirement is that modified and unchanged markings MUST be grounded in some field/profile-defined correspondence, equivalence, or substitutability basis. If such a basis is unavailable or ambiguous, the relevant structure SHOULD be marked unresolved rather than forced into modified or unchanged status.

---

<!-- PRECEDING SECTION: Difference Markings Without Identity -->

## Profile-Defined Graph-Delta Schema

<!-- FOLLOWING SECTION: Minimal Schema Summary -->

Most graph-delta schema details are profile-defined.

Profile-defined details include, but are not limited to:

- exact relation names for graph-delta roles;
- exact status object schema;
- exact correspondence object schema;
- diagnostic schema;
- materialization metadata schema;
- recursive propagation rules;
- severity levels;
- numeric status-code mapping;
- patch or transaction projection;
- whether unchanged regions are included or omitted;
- whether added, removed, modified, unchanged, or unresolved subgraphs have separate roots;
- whether modifications are represented by direct markings or reified correspondence structures;
- whether additional markings such as equivalent, substitutable, ambiguous, failed, diagnostic, partial, materialized, or profile-defined markings are supported.

A profile MAY define additional markings, but additional markings MUST NOT contradict the C4 Core meanings of added, removed, modified, unchanged, and unresolved.

---

<!-- PRECEDING SECTION: Profile-Defined Graph-Delta Schema -->

## Minimal Schema Summary

<!-- FOLLOWING SECTION: Integration Notes for Graph-Delta Minimal Schema -->

A minimally conforming C4 graph-delta SHOULD represent the following as graph structure:

- a graph-delta root;
- a graph-native return/status;
- ordered source and target regions for comparison-derived deltas;
- added markings;
- removed markings;
- modified markings;
- unchanged markings;
- unresolved markings;
- no primitive identity assumption.

C4 Core does not require every graph-delta object to contain every marking. For example, a delta may contain only added structure, only removed structure, only unresolved structure, or only a return/status root.

However, when a profile claims C4 graph-delta minimal-schema conformance, any added, removed, modified, unchanged, or unresolved claim it emits SHOULD be represented as graph structure using the semantics defined above.

---

<!-- PRECEDING SECTION: Minimal Schema Summary -->

## Integration Notes for Graph-Delta Minimal Schema

<!-- FOLLOWING SECTION: Open Questions for Graph-Delta Minimal Schema -->

When this addendum is incorporated into the C4 Mathematical Core or a standard C4 graph-delta profile, the following integration edits SHOULD be applied.

The Graph-Delta Objects section SHOULD state that $\xi_\Delta$ is the root of a graph-delta graph region.

The graph-delta production section SHOULD state that $\boldsymbol{\delta}_{\mathfrak{F}}$ yields graph-delta graph-objects whose internal graph structure may expose the minimal schema roles defined here.

The graph-comparison section SHOULD use ordered source-region and target-region terminology rather than source/target fields.

The graph-comparison section SHOULD state that the C4 Core minimal difference markings are added, removed, modified, unchanged, and unresolved.

The materialization section SHOULD remain graph-native but should not require a standard materialization metadata schema in C4 Core.

Fish or another protocol layer SHOULD define numeric status codes and protocol envelopes separately from the C4 graph-delta minimal schema.

---

<!-- PRECEDING SECTION: Integration Notes for Graph-Delta Minimal Schema -->

## Open Questions for Graph-Delta Minimal Schema

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- exact standard relation names for graph-delta roles;
- exact standard graph-object names for the five minimal markings;
- whether graph-delta root and return/status object should usually be the same graph-object;
- whether a standard correspondence graph-object schema should be specified in a C4 profile or left entirely to implementations;
- whether materialization results require a dedicated subdomain such as $\Xi_\mu$;
- how recursive source/target marking should interact with projection, filtering, and bounded comparison scopes;
- how diagnostic severity should be represented graph-natively when a profile chooses to support diagnostics;
- how Fish numeric status-code registries should reference C4 status graph-objects.
