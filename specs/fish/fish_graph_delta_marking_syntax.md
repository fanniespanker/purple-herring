# Fish Graph-Delta Marking Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines initial Fish projection syntax for representing graph-delta markings inside returned graph-delta result graphs.

Graph-delta marking syntax does not replace C4 graph-native graph-delta semantics.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Relationship to Graph-Delta Projection Syntax

Fish graph-delta projection syntax defines the outer result graph shape:

```fish
<request-fish>&fish:proto:result@<result-root>;
<result-root>&fish:proto:result_type@fish:proto:graph_delta_graph;
```

and region-root projection relations such as:

```fish
<result-root>&fish:proto:added@<added-region-root>;
<result-root>&fish:proto:removed@<removed-region-root>;
<result-root>&fish:proto:modified@<modified-region-root>;
<result-root>&fish:proto:unchanged@<unchanged-region-root>;
<result-root>&fish:proto:unresolved@<unresolved-region-root>;
```

This document defines how markings may appear inside or alongside those returned regions.

---

## 2. Schema Composition and Marking Traits

Fish graph-delta marking projection is schema-controlled.

`fish:proto:graph_delta_graph` defines the result kind.

Projection traits define how markings are represented.

Initial graph-delta marking traits:

```fish
fish:proto:region_root_marking
fish:proto:direct_marking
```

A request fish MAY compose a result kind with one or more projection traits using a protocol-relative list:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking);
```

or:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:(graph_delta_graph,direct_marking);
```

or both:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking,direct_marking);
```

A composed result-schema list is graph structure. It is not a scalar tuple.

A Fish implementation MUST NOT assume that two composed schema traits are compatible unless the active profile, schema registry, or result-schema graph defines their composition.

---

## 3. Schema-Controlled Marking Forms

Fish supports two initial marking projection forms:

```text
region-root marking
  marked material is organized under region roots

direct marking
  returned nodes, edges, relations, or subgraphs are explicitly marked
```

A schema MAY use both forms if it defines how they interact.

Fish implementations MUST NOT assume that region-root containment and direct marking are equivalent unless the active result schema explicitly defines that equivalence.

`fish:proto:graph_delta_graph` alone is a generic graph-delta graph projection. If no marking trait is composed, the active profile MUST define the default marking projection form or reject the request as under-specified.

---

## 4. Region-Root Marking

Region-root marking organizes projected graph material under marking-specific region roots.

A request may ask for this form by composing:

```fish
fish:proto:(graph_delta_graph,region_root_marking)
```

Example:

```fish
fish:id:DELTA&fish:proto:added@fish:id:ADDED_REGION;
fish:id:DELTA&fish:proto:removed@fish:id:REMOVED_REGION;
fish:id:DELTA&fish:proto:modified@fish:id:MODIFIED_REGION;
```

Content reachable from `ADDED_REGION` is projected as added under the active schema.

Content reachable from `REMOVED_REGION` is projected as removed under the active schema.

Content reachable from `MODIFIED_REGION` is projected as modified under the active schema.

The exact containment/reachability rule is profile-defined until a canonical Fish graph containment syntax is specified.

Region-root marking is compact and useful when clients want grouped graph regions.

---

## 5. Direct Marking

Direct marking marks returned graph objects explicitly.

A request may ask for this form by composing:

```fish
fish:proto:(graph_delta_graph,direct_marking)
```

Initial direct marking relation:

```fish
<marked-object>&fish:proto:delta_mark@fish:proto:<mark>;
```

Allowed initial marks:

```fish
fish:proto:added
fish:proto:removed
fish:proto:modified
fish:proto:unchanged
fish:proto:unresolved
```

Example:

```fish
fish:id:NODE_A&fish:proto:delta_mark@fish:proto:added;
fish:id:NODE_B&fish:proto:delta_mark@fish:proto:modified;
fish:id:EDGE_C&fish:proto:delta_mark@fish:proto:unresolved;
```

Direct marking is useful when returned graph structure is interleaved, overlapping, recursive, or when multiple marks may need to be attached to individual graph objects.

---

## 6. Mark Target Kinds

Direct markings MAY target projected graph objects such as:

- nodes;
- edges;
- relations;
- statements;
- subgraph roots;
- region roots;
- correspondence objects;
- profile-defined graph objects.

A schema MUST define which target kinds are valid.

A Fish implementation MUST NOT infer that a mark on a region root automatically applies to every reachable object unless the schema defines that propagation rule.

---

## 7. Multiple Marks

A graph object MAY have multiple direct marks only if the active schema permits it.

Example:

```fish
fish:id:X&fish:proto:delta_mark@fish:proto:modified;
fish:id:X&fish:proto:delta_mark@fish:proto:unresolved;
```

Multiple marks may represent overlap, ambiguity, conflict, or profile-defined layered marking.

If a schema does not permit multiple marks, multiple marks SHOULD be treated as unresolved, invalid, or profile-defined conflict.

---

## 8. Ordered Source/Target Marking

Source and target marking may be ordered under some profiles.

A schema MAY represent ordered source/target marking with ordered region lists or profile-defined ordered graph structures.

Abstract example:

```fish
fish:id:DELTA&fish:proto:source@fish:proto:(SRC_A,SRC_B);
fish:id:DELTA&fish:proto:target@fish:proto:(TGT_A,TGT_B);
```

This draft does not define a canonical ordered-region-list grammar beyond protocol-relative list syntax.

A schema that depends on source/target ordering MUST define list semantics and correspondence rules.

---

## 9. Recursive Marking

Graph-delta markings may be recursive.

A marked region may contain nested marked regions or directly marked graph objects.

A result schema SHOULD define:

- traversal bounds;
- recursion depth;
- whether nested marks override, refine, or coexist with outer marks;
- whether unmarked descendants inherit a mark from a marked ancestor;
- how unresolved nested correspondences are represented;
- whether repeated/recursive marks are allowed.

Inheritance MUST NOT be assumed unless specified by the active schema.

---

## 10. Unchanged and Unresolved Marking

`fish:proto:unchanged` is used only when unchanged material is requested by the result schema.

Fish SHOULD NOT return unchanged graph material by default unless explicitly requested or profile-required.

`fish:proto:unresolved` represents unresolved correspondence, ambiguity, conflict, undecidable mapping, or profile-defined unresolved comparison conditions.

Unresolved markings SHOULD preserve ambiguity rather than forcing a false added/removed/modified classification.

---

## 11. Interaction with Summary Schemas

Summary schemas such as:

```fish
fish:proto:graph_delta_summary
```

may return counts, flags, or compressed facts about markings.

Summary fields are not graph-delta graph markings.

Graph markings belong to graph result schemas such as:

```fish
fish:proto:graph_delta_graph
```

composed with marking traits such as:

```fish
fish:proto:region_root_marking
fish:proto:direct_marking
```

or a profile-defined marked graph schema.

---

## 12. Example: Region-Root Projection

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking);
fish:id:REQ&fish:proto:result@fish:id:DELTA;

fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
fish:id:DELTA&fish:proto:added@fish:id:ADDED_REGION;
fish:id:DELTA&fish:proto:removed@fish:id:REMOVED_REGION;
fish:id:DELTA&fish:proto:modified@fish:id:MODIFIED_REGION;
fish:id:DELTA&fish:proto:unresolved@fish:id:UNRESOLVED_REGION;
```

This example uses region-root marking only.

---

## 13. Example: Direct Marking Projection

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:(graph_delta_graph,direct_marking);
fish:id:REQ&fish:proto:result@fish:id:DELTA;

fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
fish:id:NODE_A&fish:proto:delta_mark@fish:proto:added;
fish:id:NODE_B&fish:proto:delta_mark@fish:proto:modified;
fish:id:EDGE_C&fish:proto:delta_mark@fish:proto:unresolved;
```

This example uses direct marking only.

A real response would also include graph structure linking `NODE_A`, `NODE_B`, and `EDGE_C` into the returned result graph.

---

## 14. Example: Combined Projection

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking,direct_marking);
fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
fish:id:DELTA&fish:proto:added@fish:id:ADDED_REGION;
fish:id:NODE_A&fish:proto:delta_mark@fish:proto:added;
```

A schema using both region-root and direct marking MUST define whether `NODE_A` is directly marked for redundancy, disambiguation, inheritance override, or some other profile-defined reason.

---

## 15. Open Questions

The following remain open for future formalization:

- exact graph containment/reachability syntax for region-root marking;
- whether `fish:proto:delta_mark` should be the canonical direct-mark relation or profile-defined;
- whether direct marks should target relation-fish as first-class objects;
- exact representation of edge-level and relation-level markings;
- whether multiple marks are allowed by default or only by profile;
- exact ordered source/target region-list syntax;
- whether `added`, `removed`, `modified`, `unchanged`, and `unresolved` should be relation names, mark objects, or both;
- how recursive mark inheritance and override should work;
- how graph-delta marking traits should be registered as machine-readable Fish graph data;
- how composed schema traits should be validated, ordered, and rejected when incompatible.
