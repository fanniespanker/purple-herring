# Fish Graph-Delta Projection Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines the initial Fish projection syntax for returning graph-delta result graphs.

Graph-delta projection syntax does not replace C4 graph-native graph-delta semantics.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Relationship to C4 Core

C4 Core defines graph-delta graph-objects as graph-native objects.

Fish may project graph-delta graph-objects into protocol responses when the client requests a graph-delta result schema.

A Fish graph-delta projection is a response projection of a graph-native result. It MUST NOT be interpreted as replacing the underlying C4 graph-delta object.

---

## 2. Requesting a Graph-Delta Projection

A request fish may request a graph-delta result graph using:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:graph_delta_graph;
```

Example:

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:graph_delta_graph;
```

If graph-delta production succeeds and no materialization is requested or allowed, a status response may include:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZATION_NOT_ATTEMPTED);
```

---

## 3. Generic Result Relation

Fish response graphs SHOULD use a single generic result relation from request fish to returned result graph roots:

```fish
<request-fish>&fish:proto:result@<result-root>;
```

Graph-delta-specific result typing SHOULD be expressed inside the returned result graph:

```fish
<result-root>&fish:proto:result_type@fish:proto:graph_delta_graph;
```

Fish SHOULD NOT define a separate outer response relation such as `fish:proto:graph_delta` for graph-delta results.

The outer response shape remains uniform:

```text
request -> status
request -> result
```

Result-specific semantics live inside the result graph.

---

## 4. Minimal Graph-Delta Response Shape

A minimal graph-delta response may use:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZATION_NOT_ATTEMPTED);
fish:id:REQ&fish:proto:result@fish:id:DELTA;

fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
```

If the response includes projected delta regions, the graph-delta result root may relate to region roots:

```fish
fish:id:DELTA&fish:proto:source@fish:id:SRC;
fish:id:DELTA&fish:proto:target@fish:id:TGT;
fish:id:DELTA&fish:proto:added@fish:id:ADDED;
fish:id:DELTA&fish:proto:removed@fish:id:REMOVED;
fish:id:DELTA&fish:proto:modified@fish:id:MODIFIED;
fish:id:DELTA&fish:proto:unchanged@fish:id:UNCHANGED;
fish:id:DELTA&fish:proto:unresolved@fish:id:UNRESOLVED;
```

The region roots are graph roots/subgraph roots. They may themselves contain arbitrary graph-native projected structure.

---

## 5. Minimal Delta Region Vocabulary

The initial Fish graph-delta projection vocabulary includes:

```fish
fish:proto:source
fish:proto:target
fish:proto:added
fish:proto:removed
fish:proto:modified
fish:proto:unchanged
fish:proto:unresolved
```

These are projection relations from the graph-delta result root to projected region roots.

They are not a substitute for C4 graph-native graph-delta semantics.

---

## 6. Source and Target Regions

`fish:proto:source` identifies the projected source-side region or root associated with the graph-delta result.

`fish:proto:target` identifies the projected target-side region or root associated with the graph-delta result.

Source and target markings may be ordered and recursive under the active C4/Fish profile.

A graph-delta projection MAY include multiple source or target roots if the active profile permits multi-root or recursive source/target marking.

Example:

```fish
fish:id:DELTA&fish:proto:source@fish:id:SRC_ROOT;
fish:id:DELTA&fish:proto:target@fish:id:TGT_ROOT;
```

---

## 7. Modification Regions

The modification-region relations are:

```fish
fish:proto:added
fish:proto:removed
fish:proto:modified
fish:proto:unchanged
fish:proto:unresolved
```

Their intended meanings are:

```text
added       projected region containing additions
removed     projected region containing removals
modified    projected region containing modifications
unchanged   projected region containing unchanged correspondences when requested
unresolved  projected region containing unresolved correspondences, ambiguity, conflicts, or undecidable mapping results
```

These regions MAY be omitted when not requested by the result schema.

Omission from the Fish response MUST NOT be interpreted as semantic absence from the underlying C4 graph-delta object unless the negotiated result schema explicitly defines that interpretation.

---

## 8. Markings Inside Returned Regions

A Fish graph-delta projection MAY represent markings either by:

1. placing content under region roots such as `fish:proto:added` or `fish:proto:removed`; or
2. marking nodes/edges/subgraphs inside a returned region with projection markings; or
3. both, if the active result schema defines both forms.

This draft standardizes only the root-to-region projection relations.

Detailed internal marking syntax is deferred to a future graph-delta marking syntax draft.

---

## 9. Recursive Delta Projection

Graph-delta structure may be recursive.

A projected region may itself contain further graph-delta roots or marked subregions.

A result schema SHOULD define traversal bounds, recursion depth, and whether nested delta regions are included, summarized, or omitted.

If recursive projection is requested but cannot be fully returned, Fish SHOULD indicate truncation or unresolved projection using an appropriate status enum such as `RESULT_TRUNCATED`, `UNRESOLVED_COMPARISON`, or a profile-defined status.

---

## 10. Status Interaction

A graph-delta projection response SHOULD include status unless the negotiated result schema explicitly omits it.

Common status combinations include:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZATION_NOT_ATTEMPTED);
```

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCTION_FAILED,MATERIALIZATION_NOT_ATTEMPTED,DIAGNOSTICS_AVAILABLE);
```

If graph-delta production fails, Fish SHOULD NOT return a successful `graph_delta_graph` result root unless the active profile defines a failure-result graph projection.

---

## 11. Addressing Result Roots

Graph-delta result roots may be addressed by opaque IDs:

```fish
fish:id:DELTA
```

or structured addresses:

```fish
fish:addr:("natalie","purple-herring.fanniespanker.com",A,B,C)
```

Public/protocol responses SHOULD generally prefer `fish:id:<FishID128>` unless structured address disclosure is desired.

Examples in this draft use short placeholders such as `fish:id:DELTA`; real `fish:id:` addresses MUST use valid `FishID128` tokens.

---

## 12. Complete Abstract Example

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:graph_delta_graph;

fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZATION_NOT_ATTEMPTED);
fish:id:REQ&fish:proto:result@fish:id:DELTA;

fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
fish:id:DELTA&fish:proto:source@fish:id:SRC;
fish:id:DELTA&fish:proto:target@fish:id:TGT;
fish:id:DELTA&fish:proto:added@fish:id:ADDED;
fish:id:DELTA&fish:proto:removed@fish:id:REMOVED;
fish:id:DELTA&fish:proto:modified@fish:id:MODIFIED;
fish:id:DELTA&fish:proto:unchanged@fish:id:UNCHANGED;
fish:id:DELTA&fish:proto:unresolved@fish:id:UNRESOLVED;
```

This example is abstract. Placeholder IDs such as `REQ`, `DELTA`, `SRC`, and `ADDED` are not valid `FishID128` tokens.

---

## 13. Open Questions

The following remain open for future formalization:

- exact internal marking syntax for nodes, edges, relations, and subgraphs;
- whether `source` and `target` should always be ordered lists rather than repeated relations;
- whether `added`, `removed`, `modified`, `unchanged`, and `unresolved` should point to region roots, marker objects, or both;
- how to represent per-edge vs per-node vs per-subgraph delta markings;
- how recursive source/target marking should be bounded and serialized;
- how correspondence, ambiguity, and unresolved mapping structures should be projected;
- whether graph-delta result roots should include a status relation in addition to the request-level status;
- whether region roots should use `fish:proto:result_type` or another typing relation;
- whether graph-delta projection schemas should be machine-readable Fish graph documents.
