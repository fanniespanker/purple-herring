# C4 Graph-Delta Minimal Schema Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It defines a minimal graph-native schema vocabulary for graph-delta objects without turning graph-deltas into external patch records, fixed diff payloads, or non-graph data structures.

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

C4 Core does not require a graph-delta object to use one fixed physical layout. However, conforming graph-delta profiles SHOULD expose enough graph structure to support inspection, validation, comparison, materialization, and diagnostics.

This section defines a minimal schema vocabulary as graph roles, status objects, and markings.

These roles and markings are graph-defined. They are not enum primitives, non-graph fields, external lists, or protocol status codes.

---

<!-- PRECEDING SECTION: Graph-Delta Minimal Schema -->

## Graph-Delta Root

<!-- FOLLOWING SECTION: Graph-Delta Provenance Roles -->

A graph-delta object:

$$
\xi_\Delta\in\Xi_\Delta
$$

is the root of a graph-delta graph region.

The root graph-object SHOULD provide an entry point to the delta's status, source, target, correspondence, marking, materialization, and diagnostic structure.

A graph-delta root MAY also itself be the status-bearing graph-object for the delta.

C4 Core does not require a separate non-root status object. If a profile uses separate status objects, they remain ordinary graph-objects connected to the graph-delta root by graph structure.

---

<!-- PRECEDING SECTION: Graph-Delta Root -->

## Graph-Delta Provenance Roles

<!-- FOLLOWING SECTION: Source and Target Region Roles -->

A graph-delta SHOULD be able to expose the graph-object or graph-objects from which it was produced.

For statement-derived deltas, the producing source is normally the statement graph-object:

$$
\iota_P(P)\in\Xi_\alpha
$$

For comparison-derived deltas, the producing source is normally a graph-comparison delta-source object:

$$
\xi_{cmp}\in\Xi_\alpha
$$

A graph-delta profile SHOULD define graph relations or graph-role objects corresponding to:

- delta source;
- produced-by field;
- producing relator, when applicable;
- producing statement, when applicable;
- producing comparison request, when applicable;
- production diagnostics.

These relations SHOULD point to graph-objects, not external identifiers.

Possible role names include:

- `deltaSource`;
- `producedUnderField`;
- `producedByRelator`;
- `producedFromStatement`;
- `producedFromComparison`;
- `productionDiagnostic`.

The exact surface names belong to a surface language, profile, or standard library. C4 Core only requires that the roles be representable as graph structure.

---

<!-- PRECEDING SECTION: Graph-Delta Provenance Roles -->

## Source and Target Region Roles

<!-- FOLLOWING SECTION: Graph-Delta Status Roles -->

For comparison-derived graph-deltas, source and target roles form an ordered comparison frame.

A graph-delta profile SHOULD define graph relations or graph-role objects corresponding to:

- source region;
- target region;
- source-side marking;
- target-side marking;
- comparison scope;
- recursive side-marking propagation.

The source role denotes the prior, input, left, before, or source-side comparison region.

The target role denotes the later, output, right, after, or target-side comparison region.

Added and removed markings are interpreted relative to this ordering.

Source and target regions are ordinary graph regions or graph-objects inside or referenced by the graph-delta graph. They are not external fields.

Recursive source/target marking is profile-defined. A profile MUST define the traversal boundary, containment relation, comparison-scope relation, or propagation rule by which recursive side marking propagates. If no recursive propagation policy is supplied or derivable under the active field, source and target roles apply only to explicitly marked graph-objects.

---

<!-- PRECEDING SECTION: Source and Target Region Roles -->

## Graph-Delta Status Roles

<!-- FOLLOWING SECTION: Difference Markings -->

A graph-delta SHOULD expose a status structure.

Status is graph-native. A status is a graph-object, graph relation, or graph-marked region, not a primitive numeric code.

A graph-delta profile MAY define status graph-objects corresponding to broad status families such as:

- equivalent;
- different;
- partial;
- unresolved;
- ambiguous;
- failed;
- profile-defined status.

Numeric status codes, status-code families, response codes, and protocol envelopes belong to Fish or another protocol/profile layer. Numeric codes MAY identify status graph-objects but MUST NOT replace the graph structure of the delta.

A graph-delta MAY contain more than one status marking when different subregions have different comparison outcomes.

---

<!-- PRECEDING SECTION: Graph-Delta Status Roles -->

## Difference Markings

<!-- FOLLOWING SECTION: Correspondence Structures -->

A graph-delta profile SHOULD define graph markings for common difference classes.

Common difference markings include:

- added;
- removed;
- modified;
- equivalent;
- substitutable;
- unresolved;
- ambiguous;
- failed;
- diagnostic;
- profile-defined marking.

These markings are graph structure.

A graph-object, graph region, edge/traversal object, correspondence object, or diagnostic object may be marked by connecting it to a marking graph-object or by using a profile-defined marking relation.

Added, removed, modified, and equivalent regions SHOULD preserve relevant graph structure. They SHOULD NOT be represented only as flat external lists unless a profile explicitly projects the graph-delta into such a representation.

Since edge/traversal objects are graph-objects:

$$
\eta\in\Xi_\eta\subseteq\Xi
$$

edges can be marked as added, removed, modified, equivalent, unresolved, or failed like any other graph-object.

---

<!-- PRECEDING SECTION: Difference Markings -->

## Correspondence Structures

<!-- FOLLOWING SECTION: Diagnostic Structures -->

C4 Core does not assume primitive identity.

A graph-delta that compares graph structures SHOULD represent correspondence, equivalence, or substitutability as graph structure.

A correspondence structure may be represented by a reified correspondence graph-object connected to:

- source-side structure;
- target-side structure;
- correspondence policy;
- comparison status;
- difference marking;
- diagnostics.

A modified structure SHOULD be represented as a correspondence structure whose source-side and target-side regions are accepted as corresponding under the active comparison policy but whose recursively compared structure differs under that policy.

An equivalent or substitutable structure SHOULD be represented as a correspondence structure whose source-side and target-side regions are accepted as equivalent or substitutable under the active comparison policy.

An unresolved or ambiguous structure SHOULD preserve the unresolved or conflicting correspondence structure rather than forcing a resolved classification.

---

<!-- PRECEDING SECTION: Correspondence Structures -->

## Diagnostic Structures

<!-- FOLLOWING SECTION: Materialization Metadata -->

A graph-delta MAY contain diagnostic graph-objects.

Diagnostics may describe:

- invalid delta-source graph structure;
- unresolved endpoint consumption;
- unresolved correspondence;
- ambiguous correspondence;
- failed comparison;
- failed materialization;
- profile mismatch;
- unsupported policy;
- canonicalization conflict;
- protocol projection warning;
- profile-defined diagnostic.

Diagnostic structures are graph-objects. They MAY later be projected by Fish or another protocol/profile layer into numeric codes, messages, envelopes, or other transport representations.

C4 Core does not require diagnostic text strings, but a profile MAY attach literal expressions or localized diagnostic message objects.

---

<!-- PRECEDING SECTION: Diagnostic Structures -->

## Materialization Metadata

<!-- FOLLOWING SECTION: Minimal Schema Summary -->

A graph-delta MAY contain materialization metadata.

Materialization metadata may describe:

- whether materialization is allowed, required, prohibited, already applied, failed, partial, or profile-defined;
- what materializer or active field produced a materialization result;
- what graph-object resulted from materialization;
- what graph regions were affected by materialization;
- what diagnostics were produced by materialization.

Materialization metadata is graph structure. It is not a primitive external transaction record.

Materialization remains:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi
$$

For:

$$
\mathbf{m}_{\mathfrak{F}}(\xi_\Delta)=\xi_\mu
$$

both $\xi_\Delta$ and $\xi_\mu$ are graph-objects.

---

<!-- PRECEDING SECTION: Materialization Metadata -->

## Minimal Schema Summary

<!-- FOLLOWING SECTION: Integration Notes for Graph-Delta Minimal Schema -->

A minimally inspectable graph-delta profile SHOULD be able to represent the following as graph structure:

- a graph-delta root;
- delta-source provenance;
- source and target regions for comparison-derived deltas;
- ordered source/target comparison roles;
- recursive source/target marking policy or explicit non-recursive behavior;
- status graph-objects or status markings;
- difference markings;
- correspondence structures;
- diagnostic structures;
- materialization metadata.

C4 Core does not require every graph-delta object to contain all of these structures. A statement-derived assertion delta, a failed comparison delta, a materialization diagnostic delta, and a profile-defined construction delta may expose different subsets.

However, any profile claiming graph-delta conformance SHOULD document which minimal-schema roles it supports and how those roles are represented as graph structure.

---

<!-- PRECEDING SECTION: Minimal Schema Summary -->

## Integration Notes for Graph-Delta Minimal Schema

<!-- FOLLOWING SECTION: Open Questions for Graph-Delta Minimal Schema -->

When this addendum is incorporated into the C4 Mathematical Core or a standard C4 graph-delta profile, the following integration edits SHOULD be applied.

The Graph-Delta Objects section SHOULD state that $\xi_\Delta$ is the root of a graph-delta graph region.

The graph-delta production section SHOULD state that $\boldsymbol{\delta}_{\mathfrak{F}}$ yields graph-delta graph-objects whose internal graph structure may expose the minimal schema roles defined here.

The graph-comparison section SHOULD use source-region and target-region terminology rather than source/target fields.

The materialization section SHOULD state that materialization metadata is represented as graph structure and may be projected into protocol representations outside C4 Core.

Fish or another protocol layer SHOULD define numeric status codes and protocol envelopes separately from the C4 graph-delta minimal schema.

---

<!-- PRECEDING SECTION: Integration Notes for Graph-Delta Minimal Schema -->

## Open Questions for Graph-Delta Minimal Schema

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- exact standard relation names for graph-delta roles;
- exact standard graph-object names for common statuses and markings;
- whether graph-delta root and status object should usually be the same graph-object;
- whether a standard correspondence graph-object schema should be specified in C4 Core or left to profiles;
- whether materialization results should have a dedicated subdomain such as $\Xi_\mu$;
- how recursive source/target marking should interact with projection, filtering, and bounded comparison scopes;
- how diagnostic severity should be represented graph-natively;
- how Fish numeric status-code registries should reference C4 status graph-objects.
