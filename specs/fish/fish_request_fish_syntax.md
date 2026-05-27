# Fish Request Fish Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines the initial graph-native syntax model for request fish: Fish graph objects representing protocol requests.

A request fish is not merely an envelope record. It is a graph-addressable Fish/C4 graph object that may be referenced by responses, diagnostics, graph-delta objects, materialization-result objects, and protocol projections.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Relationship to Fish IDs and Responses

Fish ID and address syntax defines canonical opaque request addresses:

```fish
fish:id:<FishID128>
```

Fish status-only response syntax defines graph-native response statements such as:

```fish
<request-fish>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

Therefore, a request fish SHOULD be addressable by a Fish address, and a response SHOULD refer to the request fish it answers.

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(OK);
```

---

## 2. Request Fish

A request fish is a graph object representing a protocol request.

A request fish MAY describe:

- operation or intent;
- source text;
- payload graph;
- active C4/Fish profile request;
- requested result schema;
- fallback result schemas;
- materialization policy request;
- diagnostic disclosure preference;
- authentication, capability, session, or credential references;
- transaction or safety constraints;
- profile-defined request metadata.

A request fish is graph-native. Its internal structure is represented using Fish/C4 graph relations.

---

## 3. Minimal Request Fish Shape

A minimally useful request fish SHOULD have:

1. an address;
2. an operation or intent;
3. a payload, source, or graph input; or an explicit empty/no-payload operation;
4. optional result-schema request.

Abstract shape:

```fish
<request-fish>&fish:proto:operation@fish:proto:<operation>;
<request-fish>&fish:proto:payload@<payload-graph-or-source>;
<request-fish>&fish:proto:result_schema@fish:proto:<schema>;
```

The exact operation vocabulary and payload syntax are profile-defined until the Fish operation registry is specified.

---

## 4. Request Fish Address

A generated request fish address SHOULD use:

```fish
fish:id:<FishID128>
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA
```

The request fish address is used for correlation.

It does not establish primitive C4 identity.

---

## 5. Operation / Intent

A request fish SHOULD indicate operation or intent using graph structure.

Example abstract forms:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:operation@fish:proto:validate;
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:operation@fish:proto:produce_delta;
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:operation@fish:proto:materialize;
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:operation@fish:proto:project_result;
```

Operation names shown here are provisional.

A future Fish operation registry SHOULD define standard operations.

---

## 6. Payload / Source

A request fish MAY carry or reference payload/source content.

Possible payload forms include:

- source Fish text;
- C4 graph object;
- graph-delta object;
- materialization request object;
- graph-comparison delta-source object;
- result-schema graph object;
- profile-defined payload.

Example abstract form:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:payload@fish:id:a2F0Z3JhcGhwYXlsb2FkMQ;
```

This draft does not define literal source-text embedding syntax.

---

## 7. Result Schema Request

A request fish MAY request a result schema using graph structure.

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:status_only;
```

Another example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result_schema@fish:proto:diagnostic_graph;
```

If no result schema is requested, Fish SHOULD return the default graph-native status-only response.

Unsupported or malformed result schemas MUST NOT trigger mutating materialization.

---

## 8. Materialization Policy Request

A request fish MAY include materialization policy preferences or constraints.

Example abstract forms:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:materialization_policy@fish:proto:read_only;
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:materialization_policy@fish:proto:allow_mutation;
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:materialization_policy@fish:proto:prohibit_mutation;
```

Policy names shown here are provisional.

Materialization policy validation MUST occur before mutating materialization.

---

## 9. Diagnostic Preference

A request fish MAY request diagnostic disclosure or diagnostic schemas.

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:diagnostic_schema@fish:proto:diagnostic_summary;
```

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:diagnostic_schema@fish:proto:diagnostic_graph;
```

Diagnostics are not returned by default unless requested or required by profile.

---

## 10. Response to Request Fish

A response SHOULD reference the request fish it answers.

For status-only response:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

For permission failure:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(PERMISSION_DENIED,MATERIALIZATION_NOT_ATTEMPTED);
```

For malformed result schema:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(MALFORMED_RESULT_SCHEMA,MATERIALIZATION_NOT_ATTEMPTED);
```

For a returned result graph:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:result@fish:id:UkVTVUxUUk9PVAaaaa;
fish:id:UkVTVUxUUk9PVAaaaa&fish:proto:result_type@fish:proto:graph_delta_graph;
```

---

## 11. Safety Rule

A Fish implementation MUST validate the request fish before performing materialization behavior that may mutate persistent graph state.

Validation includes, as applicable:

- request fish structure;
- operation admissibility;
- authentication or capability references;
- permission policy;
- requested result schema;
- fallback result schemas;
- materialization policy;
- active profile compatibility;
- payload validity.

If validation fails, Fish MUST NOT perform mutating materialization.

The response SHOULD be a graph-native status response against the request fish.

---

## 12. Request Fish Is Not Primitive Identity

A request fish address provides protocol correlation and graph addressability.

It does not establish primitive C4 identity.

C4 does not assume primitive identity. Fish request addresses are operational/protocol references.

---

## 13. Open Questions

The following remain open for future formalization:

- exact operation registry;
- exact literal syntax for source Fish text payloads;
- exact syntax for embedding payload graphs inline;
- whether request fish are always explicitly addressed or may be implicitly addressed by transport context;
- whether request fish may contain multiple operations;
- how batch requests are represented;
- how streaming requests are represented;
- how request authentication/capability references are represented graph-natively;
- how transaction boundaries are represented in request fish;
- whether request fish syntax should have a compact shorthand distinct from canonical graph syntax.
