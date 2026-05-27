# Fish Result-Schema Request Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines the initial graph-native syntax for requesting Fish result schemas from a request fish.

A result-schema request is graph structure. It tells Fish what projection of a C4 graph-native result the client wants returned.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Relationship to Result-Schema Negotiation

Fish result-schema negotiation defines the semantics of requesting a projection of a C4 graph-native result.

This document defines the initial canonical graph syntax for making such requests.

Canonical request relation:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:<schema>;
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:status_only;
```

If no result schema is requested, Fish SHOULD return the default graph-native status-only response.

---

## 2. Standard Result-Schema Names

The following protocol result-schema names are reserved as initial standard schema names:

```text
fish:proto:status_only
fish:proto:diagnostic_summary
fish:proto:diagnostic_graph
fish:proto:diagnostic_envelope
fish:proto:patch_graph
fish:proto:graph_delta_graph
fish:proto:graph_delta_summary
fish:proto:materialization_result_graph
fish:proto:materialization_result_summary
fish:proto:validation_result_graph
fish:proto:protocol_envelope
```

The following protocol result-schema trait names are reserved as initial standard composable traits:

```text
fish:proto:region_root_marking
fish:proto:direct_marking
```

Graph schemas SHOULD return graph roots, graph regions, or projected graph structures.

Summary schemas MAY return compressed facts, counts, flags, or other compact summary projections.

Trait names modify or constrain a result schema. They are not complete result schemas by themselves unless an active profile explicitly defines them as such.

These names identify protocol projection schemas and schema traits. They do not replace the underlying C4 graph-native result objects.

---

## 3. Status-Only Request

A status-only result schema request asks Fish to return only the graph-native protocol status relation/subgraph.

Request:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:status_only;
```

Possible response:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

Status-only does not mean scalar-only. The response is still graph structure.

---

## 4. Diagnostic Requests

A diagnostic summary request asks for summarized diagnostic projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:diagnostic_summary;
```

A diagnostic graph request asks for graph-native diagnostic structure or a projection of it:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:diagnostic_graph;
```

A diagnostic envelope request asks for a protocol diagnostic envelope:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:diagnostic_envelope;
```

Diagnostics are not returned by default unless requested or required by profile.

---

## 5. Graph-Delta and Materialization Result Requests

A graph-delta result-schema request asks for the graph-delta graph projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:graph_delta_graph;
```

A graph-delta request may compose the graph-delta graph result kind with marking traits:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking);
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:(graph_delta_graph,direct_marking);
```

A graph-delta summary request asks for a compact graph-delta summary projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:graph_delta_summary;
```

A materialization-result graph request asks for the materialization-result graph projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:materialization_result_graph;
```

A materialization-result summary request asks for a compact materialization-result summary projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:materialization_result_summary;
```

A patch graph request asks for a patch-like projection, if supported:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:patch_graph;
```

Patch projections are protocol/profile projections and MUST NOT be treated as replacing graph-delta or materialization-result graph-object semantics unless the active profile explicitly defines that equivalence.

---

## 6. Protocol Envelope Request

A protocol envelope request asks Fish to return a fuller protocol response envelope.

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:protocol_envelope;
```

A protocol envelope MAY include status, schema used, fallback schema, diagnostics, graph projections, and protocol metadata according to the active profile.

A protocol envelope is still a Fish graph projection.

---

## 7. Composable Result Schemas

A result-schema request MAY compose a result kind with one or more schema traits using a protocol-relative list.

Example:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking,direct_marking);
```

In a composed schema list:

- the result kind identifies the primary result projection;
- traits modify or constrain the projection;
- the list is graph structure, not a scalar tuple;
- trait compatibility is schema/profile-defined.

A Fish implementation MUST validate that all composed schema members are supported and mutually compatible before performing mutating materialization.

If any composed schema member is malformed, unsupported, unauthorized, or incompatible, Fish MUST NOT perform mutating materialization.

---

## 8. Multiple Acceptable Result Schemas

A request fish MAY specify multiple acceptable result schemas using a protocol-relative list only when the active profile interprets the list as alternatives.

Example:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:(diagnostic_graph,status_only);
```

The list is graph structure.

The order SHOULD be interpreted as preference order for alternative schemas only when the active profile defines the list as alternatives.

Because protocol-relative lists can also represent schema composition, a profile MUST disambiguate alternative-schema lists from composed-schema lists.

Explicit fallback schemas are preferred when alternatives must be unambiguous.

---

## 9. Explicit Fallback Result Schemas

A request fish MAY distinguish the primary requested result schema from fallback schemas.

Primary request:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:diagnostic_graph;
```

Fallback request:

```fish
<request-fish>&fish:proto:fallback_result_schema@fish:proto:(status_only);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:diagnostic_graph;
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:fallback_result_schema@fish:proto:(status_only);
```

If fallback is used, the response SHOULD indicate fallback when the response schema permits such indication.

---

## 10. Generic Result Relation

Fish response graphs SHOULD use a single generic result relation from request fish to returned result graph roots:

```fish
<request-fish>&fish:proto:result@<result-root>;
```

Result-specific typing SHOULD be expressed inside the result graph, preferably on the result root:

```fish
<result-root>&fish:proto:result_type@fish:proto:<result-schema-name>;
```

Example graph-delta result reference:

```fish
fish:id:REQ&fish:proto:result@fish:id:DELTA;
fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
```

---

## 11. Malformed or Unsupported Schema Requests

If a requested result schema is malformed, Fish MUST NOT perform mutating materialization using that schema.

Recommended status response:

```fish
<request-fish>&fish:proto:status@fish:proto:(MALFORMED_RESULT_SCHEMA,MATERIALIZATION_NOT_ATTEMPTED);
```

If a requested result schema is unsupported, Fish MUST NOT perform mutating materialization using that schema.

Recommended status response:

```fish
<request-fish>&fish:proto:status@fish:proto:(UNSUPPORTED_RESULT_SCHEMA,MATERIALIZATION_NOT_ATTEMPTED);
```

These outcomes are request-side/protocol-side failures, not successful materializations with empty results.

---

## 12. Schema Identity and Profiles

Standard Fish protocol schemas use `fish:proto:<schema>` names.

Profile-defined schemas MAY use profile-defined namespaces or graph addresses.

Examples:

```fish
<request-fish>&fish:proto:result_schema@profile:my_profile:full_trace;
```

```fish
<request-fish>&fish:proto:result_schema@fish:id:VQ6EAOKbQdSnFkRmVUQAAA;
```

A profile-defined schema MUST still resolve to graph-defined schema semantics under the active profile.

---

## 13. Safety Rule

A Fish implementation MUST validate requested result schemas and fallback result schemas before performing materialization behavior that may mutate persistent graph state.

If the requested schema is malformed, unsupported, unauthorized, or incompatible with the requested operation, mutating materialization MUST NOT occur.

Read-only parsing, validation, negotiation, and status production MAY occur in order to report the failure.

---

## 14. Open Questions

The following remain open for future formalization:

- exact grammar for `fish:proto:result_schema` statements;
- how to distinguish composed schema lists from alternative-schema lists in compact syntax;
- whether multiple schemas should be represented by a result-schema list or only by explicit fallback relation;
- whether result-schema lists are always preference-ordered when interpreted as alternatives;
- exact standard semantics of `fish:proto:diagnostic_summary`, `fish:proto:diagnostic_graph`, and `fish:proto:diagnostic_envelope`;
- exact standard semantics of `fish:proto:graph_delta_graph`, `fish:proto:graph_delta_summary`, `fish:proto:materialization_result_graph`, `fish:proto:materialization_result_summary`, and `fish:proto:patch_graph`;
- exact standard semantics and compatibility rules for `fish:proto:region_root_marking` and `fish:proto:direct_marking`;
- whether result schema negotiation should support quality values, capabilities, or constraints;
- how schema requests interact with streaming and batch requests;
- how schema requests interact with authorization/disclosure policy;
- how machine-readable schema graphs are registered and resolved.
