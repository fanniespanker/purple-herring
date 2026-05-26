# Fish Result-Schema Negotiation v0.1.0 Draft

## Status

This document is a draft Fish protocol specification.

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

This document defines how Fish clients request protocol projections of C4 graph-native results.

Fish result-schema negotiation does not replace C4 graph-native semantics.

A Fish result schema is a graph object or graph-defined schema describing what subgraphs to return, how to organize them, and what markings to preserve or apply in the projected response.

---

## 1. Relationship to C4 Core

C4 Core defines graph-native structures such as:

$$
\Xi_\Delta\subseteq\Xi
$$

for graph-delta graph-objects, and:

$$
\Xi_\mu\subseteq\Xi
$$

for materialization-result graph-objects.

Fish MAY project those graph-native objects into protocol responses.

A negotiated Fish result schema is a protocol projection schema. It determines what portion or projection of a graph-native result is returned to the client.

A Fish result schema MUST NOT be treated as replacing the underlying C4 graph-object semantics.

---

## 2. Default Response Rule

If a Fish request does not explicitly request a richer result schema, Fish SHOULD return status-only.

Fish SHOULD only return what the client requested.

The default Fish response is therefore minimal:

```text
status: <code>
```

where `<code>` is a Fish status code projecting a graph-native status object.

A status-only response does not exhaust the C4 graph-object semantics of the underlying result.

A Fish implementation MAY expose server- or profile-level defaults, but those defaults SHOULD NOT cause richer graph structures to be returned unless the client explicitly requests them or the active protocol profile explicitly requires them.

---

## 3. Result-Schema Graphs

A Fish result schema is graph-defined.

A result-schema graph describes:

- which subgraphs or graph regions to return;
- which result roots to include;
- how returned subgraphs should be organized;
- which markings should be included, omitted, transformed, or added;
- whether source/target regions should be included;
- whether graph-delta, materialization-result, diagnostic, or patch-like regions should be included;
- whether recursive traversal or bounded projection is used;
- whether protocol envelope structure is required;
- profile-defined projection behavior.

A result-schema graph is itself a C4 graph-object or a Fish-serialized graph object referring to C4 graph-native schema semantics.

Result schemas SHOULD be addressable or otherwise identifiable as graph objects.

---

## 4. Negotiated Schema Classes

Fish MAY define standard result-schema classes such as:

- status-only;
- diagnostic graph;
- patch graph;
- graph-delta graph;
- materialization-result graph;
- validation-result graph;
- protocol envelope;
- profile-defined result schema.

These classes are protocol conveniences. The normative result schema is the graph-defined schema object or graph region requested by the client.

---

## 5. Requesting a Result Schema

A Fish client MAY request a richer result schema by including a result-schema graph or a reference to a result-schema graph in the request.

This draft does not yet define concrete Fish surface syntax for result-schema requests.

A future Fish syntax draft SHOULD define how a client expresses:

- requested result schema;
- acceptable fallback schemas;
- whether status-only is acceptable as fallback;
- schema version or profile;
- schema constraints;
- desired markings or subgraph projections.

If no result schema is requested, Fish SHOULD use status-only.

---

## 6. Unsupported or Malformed Result Schemas

If a requested result schema is unsupported, Fish MUST NOT materialize using that schema.

Instead, Fish SHOULD return an unsupported-schema error status code.

If a requested result schema is malformed, Fish MUST NOT materialize using that schema.

Instead, Fish SHOULD return a malformed-schema error status code.

Unsupported-schema and malformed-schema conditions are protocol/status outcomes. They SHOULD map to graph-native status objects and SHOULD be represented by Fish status codes in the `4xx` family unless a profile defines otherwise.

A malformed or unsupported result schema is a request-side/protocol-side failure, not a successful materialization with an empty result.

---

## 7. Materialization Safety Rule

A Fish implementation MUST validate requested result schemas before performing materialization behavior that may mutate persistent graph state.

If the requested result schema is unsupported or malformed, materialization MUST NOT proceed.

Read-only validation, negotiation, or status production MAY still occur in order to return an appropriate error status.

This rule prevents a client from triggering materialization while requesting an invalid or unsupported projection of the result.

---

## 8. Schema Identity

Result schemas SHOULD be graph-identifiable.

A result schema may be identified by:

- a graph object;
- a graph name;
- a Fish profile reference;
- a schema registry entry;
- a serialized schema graph;
- a profile-defined schema reference.

String identifiers MAY be used by Fish syntax, but they SHOULD resolve to graph-defined schema objects under the active Fish/C4 profile.

---

## 9. Projection Rule

Fish result schemas are projection specifications.

They define how C4 graph-native results are projected into a Fish protocol response.

They do not replace:

$$
\xi_\Delta\in\Xi_\Delta
$$

or:

$$
\xi_\mu\in\Xi_\mu
$$

when those graph-objects exist under C4 semantics.

A Fish response MAY omit graph regions not requested by the negotiated schema.

Omission from a Fish response MUST NOT be interpreted as absence from the underlying C4 graph-native result unless the negotiated schema explicitly defines such interpretation.

---

## 10. Marking Projection

A result-schema graph MAY specify which markings to include in a projected response.

For graph-delta projections, C4 Core minimal markings are:

- added;
- removed;
- modified;
- unchanged;
- unresolved.

A result schema MAY request all, some, or none of these markings.

A result schema MAY request profile-defined markings.

A result schema MAY also define how markings should be organized, summarized, grouped, transformed, or recursively projected.

Fish MUST NOT invent omitted markings in a way that contradicts the underlying graph-native result.

---

## 11. Fallback Behavior

A Fish request MAY define acceptable fallback schemas.

If no acceptable requested or fallback schema is supported, Fish SHOULD return an unsupported-schema status.

If a fallback schema is used, the response SHOULD indicate, at least by status or protocol metadata, that a fallback projection was returned.

If no schema is requested and no profile requires richer output, status-only is the fallback/default response.

---

## 12. Interaction with Status Codes

The Fish status-code registry defines protocol status codes.

Result-schema negotiation failures SHOULD use Fish status codes rather than attempting materialization.

This draft reserves the following conceptual error classes for future code assignment:

- unsupported result schema;
- malformed result schema;
- unsupported fallback schema;
- schema negotiation failed;
- result schema/profile mismatch.

Exact numeric code assignment is deferred to the Fish status-code registry.

---

## 13. Open Questions

The following remain open for future formalization:

- concrete Fish syntax for requesting result schemas;
- whether result-schema negotiation is expressed in source syntax, request envelope syntax, graph syntax, or all of these;
- exact standard graph-object names for status-only, diagnostic graph, patch graph, graph-delta graph, materialization-result graph, and protocol envelope schemas;
- exact numeric Fish status codes for unsupported schema and malformed schema;
- whether status-only responses should include a schema identifier;
- whether fallback schema use should be represented as a `3xx` projection/negotiation status or as response metadata;
- whether result-schema graphs should themselves be validatable by C4 endpoint-policy-like mechanisms;
- how Fish schema negotiation interacts with streaming responses;
- how Fish schema negotiation interacts with mutating materializers and transactional safety.
