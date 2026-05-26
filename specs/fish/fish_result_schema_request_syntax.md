# Fish Result-Schema Request Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines the initial graph-native syntax for requesting Fish result schemas from a request fish.

A result-schema request is graph structure. It tells Fish what projection of a C4 graph-native result the client wants returned.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

---

## 1. Relationship to Result-Schema Negotiation

Fish result-schema negotiation defines the semantics of requesting a projection of a C4 graph-native result.

This document defines the initial canonical graph syntax for making such requests.

Canonical request relation:

```fish
<request-fish>&fish:proto:resultSchema@fish:proto:<schema>;
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:statusOnly;
```

If no result schema is requested, Fish SHOULD return the default graph-native status-only response.

---

## 2. Standard Result-Schema Names

The following protocol result-schema names are reserved as initial standard schema names:

```text
fish:proto:statusOnly
fish:proto:diagnosticSummary
fish:proto:diagnosticGraph
fish:proto:diagnosticEnvelope
fish:proto:patchGraph
fish:proto:graphDeltaGraph
fish:proto:materializationResultGraph
fish:proto:validationResultGraph
fish:proto:protocolEnvelope
```

These names identify protocol projection schemas. They do not replace the underlying C4 graph-native result objects.

---

## 3. Status-Only Request

A status-only result schema request asks Fish to return only the graph-native protocol status relation/subgraph.

Request:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:statusOnly;
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
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:diagnosticSummary;
```

A diagnostic graph request asks for graph-native diagnostic structure or a projection of it:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:diagnosticGraph;
```

A diagnostic envelope request asks for a protocol diagnostic envelope:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:diagnosticEnvelope;
```

Diagnostics are not returned by default unless requested or required by profile.

---

## 5. Graph-Delta and Materialization Result Requests

A graph-delta result-schema request asks for the graph-delta projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:graphDeltaGraph;
```

A materialization-result graph request asks for the materialization-result graph projection:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:materializationResultGraph;
```

A patch graph request asks for a patch-like projection, if supported:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:patchGraph;
```

Patch projections are protocol/profile projections and MUST NOT be treated as replacing graph-delta or materialization-result graph-object semantics unless the active profile explicitly defines that equivalence.

---

## 6. Protocol Envelope Request

A protocol envelope request asks Fish to return a fuller protocol response envelope.

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:protocolEnvelope;
```

A protocol envelope MAY include status, schema used, fallback schema, diagnostics, graph projections, and protocol metadata according to the active profile.

A protocol envelope is still a Fish graph projection.

---

## 7. Multiple Acceptable Result Schemas

A request fish MAY specify multiple acceptable result schemas using a protocol-relative list:

```fish
<request-fish>&fish:proto:resultSchema@fish:proto:(diagnosticGraph,statusOnly);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:(diagnosticGraph,statusOnly);
```

The list is graph structure.

The order SHOULD be interpreted as preference order unless the active profile defines otherwise.

In the example above, Fish should try `fish:proto:diagnosticGraph` first and may fall back to `fish:proto:statusOnly` if diagnostic graph projection is unavailable and fallback is permitted.

---

## 8. Explicit Fallback Result Schemas

A request fish MAY distinguish the primary requested result schema from fallback schemas.

Primary request:

```fish
<request-fish>&fish:proto:resultSchema@fish:proto:diagnosticGraph;
```

Fallback request:

```fish
<request-fish>&fish:proto:fallbackResultSchema@fish:proto:(statusOnly);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:resultSchema@fish:proto:diagnosticGraph;
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:fallbackResultSchema@fish:proto:(statusOnly);
```

If fallback is used, the response SHOULD indicate fallback when the response schema permits such indication.

---

## 9. Malformed or Unsupported Schema Requests

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

## 10. Schema Identity and Profiles

Standard Fish protocol schemas use `fish:proto:<schema>` names.

Profile-defined schemas MAY use profile-defined namespaces or graph addresses.

Examples:

```fish
<request-fish>&fish:proto:resultSchema@profile:myProfile:fullTrace;
```

```fish
<request-fish>&fish:proto:resultSchema@fish:id:VQ6EAOKbQdSnFkRmVUQAAA;
```

A profile-defined schema MUST still resolve to graph-defined schema semantics under the active profile.

---

## 11. Safety Rule

A Fish implementation MUST validate requested result schemas and fallback result schemas before performing materialization behavior that may mutate persistent graph state.

If the requested schema is malformed, unsupported, unauthorized, or incompatible with the requested operation, mutating materialization MUST NOT occur.

Read-only parsing, validation, negotiation, and status production MAY occur in order to report the failure.

---

## 12. Open Questions

The following remain open for future formalization:

- exact grammar for `fish:proto:resultSchema` statements;
- whether multiple schemas should be represented by a result-schema list or only by explicit fallback relation;
- whether result-schema lists are always preference-ordered;
- exact standard semantics of `fish:proto:diagnosticSummary`, `fish:proto:diagnosticGraph`, and `fish:proto:diagnosticEnvelope`;
- exact standard semantics of `fish:proto:graphDeltaGraph`, `fish:proto:materializationResultGraph`, and `fish:proto:patchGraph`;
- whether result schema negotiation should support quality values, capabilities, or constraints;
- how schema requests interact with streaming and batch requests;
- how schema requests interact with authorization/disclosure policy;
- how machine-readable schema graphs are registered and resolved.
