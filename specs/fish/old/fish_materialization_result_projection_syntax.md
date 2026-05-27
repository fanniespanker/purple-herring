# Fish Materialization-Result Projection Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines the initial Fish projection syntax for returning materialization-result graph projections and materialization-result summaries.

Materialization-result projection syntax does not replace C4 graph-native materialization-result semantics.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Relationship to C4 Core

C4 Core defines materialization-result graph-objects as graph-native objects.

Fish may project materialization-result graph-objects into protocol responses when the client requests a materialization-result schema.

A Fish materialization-result projection is a response projection of a graph-native result. It MUST NOT be interpreted as replacing the underlying C4 materialization-result object.

---

## 2. Graph vs Summary Result Schemas

Graph result schemas SHOULD return graph roots, graph regions, or projected graph structures.

Summary result schemas MAY return compressed facts, counts, flags, or other compact summary projections.

Therefore:

```fish
fish:proto:materialization_result_graph
```

returns graph roots/regions, while:

```fish
fish:proto:materialization_result_summary
```

is reserved for compact summary projection.

Boolean fields such as `mutation_applied` or `partial_materialization` SHOULD NOT be part of the default `materialization_result_graph` schema unless they are graph-native fields of the projected materialization-result object or explicitly requested by a summary/schema profile.

If a client wants booleans, counts, or compressed facts, it SHOULD request `fish:proto:materialization_result_summary` or another explicit summary schema.

Status-only responses SHOULD use status enums, not synthetic materialization-result booleans.

---

## 3. Requesting a Materialization-Result Graph Projection

A request fish may request a materialization-result graph using:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:materialization_result_graph;
```

Example:

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:materialization_result_graph;
```

If materialization succeeds, a status response may include:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

or:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_MUTATION_APPLIED);
```

---

## 4. Requesting a Materialization-Result Summary

A request fish may request a compact materialization-result summary using:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:materialization_result_summary;
```

Example abstract summary response:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_MUTATION_APPLIED);
fish:id:REQ&fish:proto:result@fish:id:SUMMARY;

fish:id:SUMMARY&fish:proto:result_type@fish:proto:materialization_result_summary;
fish:id:SUMMARY&fish:proto:mutation_count@fish:proto:1;
fish:id:SUMMARY&fish:proto:diagnostic_count@fish:proto:0;
```

Summary fields are provisional and belong to summary schemas, not to `materialization_result_graph`.

---

## 5. Generic Result Relation

Fish response graphs SHOULD use a single generic result relation from request fish to returned result graph roots:

```fish
<request-fish>&fish:proto:result@<result-root>;
```

Materialization-result-specific typing SHOULD be expressed inside the returned result graph:

```fish
<result-root>&fish:proto:result_type@fish:proto:materialization_result_graph;
```

Fish SHOULD NOT define a separate outer response relation such as `fish:proto:materialization_result` for materialization-result outputs.

The outer response shape remains uniform:

```text
request -> status
request -> result
```

Result-specific semantics live inside the result graph.

---

## 6. Minimal Materialization-Result Response Shape

A minimal materialization-result graph response may use:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
fish:id:REQ&fish:proto:result@fish:id:MU;

fish:id:MU&fish:proto:result_type@fish:proto:materialization_result_graph;
```

If the response includes projected materialization regions, the materialization-result root may relate to region roots:

```fish
fish:id:MU&fish:proto:input_delta@fish:id:DELTA;
fish:id:MU&fish:proto:output@fish:id:OUTPUT;
fish:id:MU&fish:proto:mutation@fish:id:MUTATION;
fish:id:MU&fish:proto:diagnostic@fish:id:DIAGNOSTIC;
```

The region roots are graph roots/subgraph roots. They may themselves contain arbitrary graph-native projected structure.

---

## 7. Minimal Materialization Region Vocabulary

The initial Fish materialization-result projection vocabulary includes:

```fish
fish:proto:input_delta
fish:proto:output
fish:proto:mutation
fish:proto:diagnostic
```

These are projection relations from the materialization-result root to projected region roots.

They are not booleans, not enums, and not a substitute for C4 graph-native materialization-result semantics.

---

## 8. Input Delta

`fish:proto:input_delta` identifies the graph-delta object or projected graph-delta root consumed by the materializer.

Example:

```fish
fish:id:MU&fish:proto:input_delta@fish:id:DELTA;
```

A materialization-result projection MAY omit `input_delta` when the requested schema does not include input provenance, when disclosure policy prohibits it, or when no graph-delta object is available.

---

## 9. Output Region

`fish:proto:output` identifies the projected output region or root produced by materialization.

The output may be a transformed graph, a rendered projection, an index/update projection, a patch-like object, a diagnostic artifact, or a profile-defined graph object.

Example:

```fish
fish:id:MU&fish:proto:output@fish:id:OUTPUT;
```

Omission of `output` from the Fish response MUST NOT be interpreted as absence from the underlying materialization-result graph-object unless the negotiated result schema explicitly defines that interpretation.

---

## 10. Mutation Region

`fish:proto:mutation` identifies a projected mutation region or mutation record root when materialization mutates persistent graph state.

Example:

```fish
fish:id:MU&fish:proto:mutation@fish:id:MUTATION;
```

The presence of a `mutation` region does not by itself replace status enums such as `MATERIALIZED_MUTATION_APPLIED`.

The absence of a `mutation` region does not by itself imply no mutation occurred unless the negotiated result schema explicitly defines that interpretation.

Mutation/no-mutation outcomes SHOULD be represented by status enums in status-only or request-level status projection.

---

## 11. Diagnostic Region

`fish:proto:diagnostic` identifies a projected diagnostic region or diagnostic object associated with the materialization result.

Example:

```fish
fish:id:MU&fish:proto:diagnostic@fish:id:DIAGNOSTIC;
```

Diagnostics are returned only when requested by result schema, required by profile, or required by disclosure/safety policy.

---

## 12. Status Interaction

A materialization-result projection response SHOULD include status unless the negotiated result schema explicitly omits it.

Common status combinations include:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_MUTATION_APPLIED);
```

```fish
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZATION_FAILED,DIAGNOSTICS_AVAILABLE);
```

If materialization fails, Fish SHOULD NOT return a successful `materialization_result_graph` result root unless the active profile defines a failure-result graph projection.

---

## 13. Addressing Result Roots

Materialization-result roots may be addressed by opaque IDs:

```fish
fish:id:MU
```

or structured addresses:

```fish
fish:addr:("natalie","purple-herring.fanniespanker.com",A,B,C)
```

Public/protocol responses SHOULD generally prefer `fish:id:<FishID128>` unless structured address disclosure is desired.

Examples in this draft use short placeholders such as `fish:id:MU`; real `fish:id:` addresses MUST use valid `FishID128` tokens.

---

## 14. Complete Abstract Graph Example

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:materialization_result_graph;

fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_MUTATION_APPLIED);
fish:id:REQ&fish:proto:result@fish:id:MU;

fish:id:MU&fish:proto:result_type@fish:proto:materialization_result_graph;
fish:id:MU&fish:proto:input_delta@fish:id:DELTA;
fish:id:MU&fish:proto:output@fish:id:OUTPUT;
fish:id:MU&fish:proto:mutation@fish:id:MUTATION;
fish:id:MU&fish:proto:diagnostic@fish:id:DIAGNOSTIC;
```

This example is abstract. Placeholder IDs such as `REQ`, `MU`, `DELTA`, and `OUTPUT` are not valid `FishID128` tokens.

---

## 15. Complete Abstract Summary Example

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:materialization_result_summary;

fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_MUTATION_APPLIED);
fish:id:REQ&fish:proto:result@fish:id:SUMMARY;

fish:id:SUMMARY&fish:proto:result_type@fish:proto:materialization_result_summary;
fish:id:SUMMARY&fish:proto:mutation_count@fish:proto:1;
fish:id:SUMMARY&fish:proto:diagnostic_count@fish:proto:0;
```

Summary field vocabulary is provisional.

---

## 16. Open Questions

The following remain open for future formalization:

- exact internal structure of materialization-result graph projections;
- exact standard summary field vocabulary for `materialization_result_summary`;
- whether `input_delta`, `output`, `mutation`, and `diagnostic` should point only to region roots or may also point to marker objects under profile-defined schemas;
- how to represent partial materialization, rollback, transaction boundaries, and recovery information;
- how to represent materializers as graph-addressable processors/interpreters;
- how disclosure policy affects input-delta, output, mutation, and diagnostic regions;
- whether materialization-result roots should include a status relation in addition to the request-level status;
- whether materialization-result projection schemas should be machine-readable Fish graph documents.
