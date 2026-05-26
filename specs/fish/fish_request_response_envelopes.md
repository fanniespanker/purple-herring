# Fish Request/Response Envelopes v0.1.0 Draft

## Status

This document is a draft Fish protocol specification.

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

This document defines sparse request and response envelope semantics for Fish protocol exchanges.

Fish envelopes are protocol structures. They may project, request, negotiate, serialize, or transport C4 graph-native structures, but they do not replace C4 graph-native semantics.

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

Fish request envelopes describe what a client asks a Fish/C4 implementation to parse, validate, produce, materialize, project, or return.

Fish response envelopes describe the protocol projection returned to the client.

A Fish response envelope MAY contain only a status code unless a richer result schema is requested or required.

---

## 2. Default Response Rule

Fish SHOULD return status-only by default.

Fish SHOULD only return what the client requested.

If no richer result schema is requested, the default response is:

```text
status: <code>
```

where `<code>` is a Fish status code projecting a graph-native status object.

A status-only response does not exhaust the underlying C4 graph-object semantics.

---

## 3. Request Envelope

A Fish request envelope MAY contain protocol projections of:

- operation or intent;
- source text;
- payload graph;
- active profile request;
- result-schema request;
- fallback result schemas;
- materialization policy request;
- diagnostic disclosure preference;
- authentication, credential, session, or capability information;
- client capabilities;
- transaction or safety constraints;
- profile-defined request metadata.

The exact Fish surface syntax for request envelopes is deferred.

A request envelope is malformed if its required protocol structure cannot be parsed, decoded, or interpreted as a Fish request under the active protocol version.

---

## 4. Response Envelope

A Fish response envelope MAY contain protocol projections of:

- status code;
- status graph-object reference;
- result schema used;
- fallback schema used;
- graph-delta projection;
- materialization-result projection;
- diagnostic envelope;
- patch or transaction projection;
- validation-result projection;
- profile negotiation metadata;
- protocol-defined response metadata.

If the negotiated response schema is status-only, the response envelope SHOULD contain only the status projection and any minimal protocol metadata required by the active Fish profile.

---

## 5. Pre-Materialization Validation Order

Fish implementations MUST validate request and policy conditions before performing materialization behavior that may mutate persistent graph state.

The recommended validation order is:

1. parse the request envelope;
2. validate request-envelope structure;
3. validate authentication, credential, session, or capability information;
4. validate permissions and authorization policy;
5. validate requested result schema and fallback schemas;
6. validate active profile and materialization policy;
7. validate that the requested operation is admissible;
8. perform graph-delta production, materialization, projection, or other requested behavior as allowed.

If any validation step fails before materialization, Fish MUST NOT perform mutating materialization.

Read-only parsing, validation, negotiation, or status production MAY still occur in order to return an appropriate status code.

---

## 6. Authentication and Permission Statuses

Fish status codes are protocol projections of graph-native status objects.

This draft reserves the following conceptual status meanings for future code registry assignment.

### 401 Authentication Required

`401` is reserved for authentication-required or authentication-failed conditions.

Use `401` when the requester has not established an acceptable identity, credential, session, capability, or authentication context.

Examples include:

- missing credential;
- expired session;
- unknown capability token;
- unauthenticated materialization request;
- authentication required before permission can be evaluated.

A `401` response means Fish cannot accept or establish the requester sufficiently to proceed with the requested operation.

### 403 Permission Denied

`403` is reserved for permission-denied or authorization-prohibited conditions.

Use `403` when the request is understood and the requester is known sufficiently, but policy prohibits the requested operation, projection, materialization, graph access, or diagnostic disclosure.

Examples include:

- client may request status-only but not diagnostic graph;
- client may validate but not materialize;
- client may materialize read-only deltas but not mutating deltas;
- client may access one graph region but not another;
- client may request a patch projection but not an internal graph-delta projection;
- materialization is prohibited by active policy.

If permission validation fails, Fish MUST NOT perform mutating materialization.

A `403` response is a request-side/policy-side failure, not a successful materialization with an empty result.

---

## 7. Schema and Profile Validation Statuses

This draft reserves the following conceptual status meanings for future code registry assignment.

### 400 Malformed Request

`400` is reserved for malformed Fish request envelopes or malformed protocol structures.

Use `400` when the request cannot be parsed or decoded as a valid Fish request under the active protocol version.

### 404 Requested Graph/Profile/Schema Not Found

`404` is reserved for requested graph, profile, schema, registry entry, or protocol resource not found.

Use `404` when a referenced object cannot be found or resolved under the active Fish/C4 field and the condition is not better represented as unsupported or unauthorized.

### 415 Unsupported Result Schema or Projection

`415` is reserved for unsupported requested result schemas, projection schemas, envelope schemas, or protocol representation schemas.

Use `415` when the requested schema is well-formed enough to identify but is not supported by the active Fish implementation, profile, materializer, or field.

If a requested result schema is unsupported, Fish MUST NOT perform mutating materialization.

### 422 Semantically Invalid Request

`422` is reserved for well-formed Fish requests that are semantically invalid under the active C4/Fish profile.

Examples include:

- valid request envelope but invalid C4 statement structure;
- relation-state incompatible with relator;
- endpoint-consumption failure;
- requested schema valid in general but invalid for this operation;
- profile constraints violated.

### 424 Failed Dependency

`424` is reserved for dependency failures.

Use `424` when a requested operation cannot proceed because a required prior validation, profile load, schema negotiation, graph resolution, materializer dependency, or field dependency failed.

---

## 8. Conflict and Ambiguity Statuses

This draft reserves the following conceptual status meanings for future code registry assignment.

### 409 Conflict or Ambiguous Correspondence

`409` is reserved for conflict or ambiguity conditions.

Examples include:

- ambiguous correspondence policy;
- conflicting graph-delta markings;
- incompatible profile constraints;
- requested operation conflicts with active graph state;
- profile-defined conflict.

A `409` response SHOULD preserve ambiguity in graph-native diagnostic or result structures when a richer schema is requested.

---

## 9. Envelope Safety Rule

A Fish implementation MUST NOT use a malformed, unsupported, unauthorized, or permission-denied request envelope as authorization to perform mutating materialization.

If the request envelope, requested schema, profile, credentials, permissions, or materialization policy fail validation, the implementation MUST return an appropriate status projection and stop before mutating materialization.

Status production, read-only diagnostics, and negotiation failure responses MAY still be returned according to active disclosure policy.

---

## 10. Result-Schema Interaction

Fish result-schema negotiation determines what the response envelope may include.

If the requested result schema is unsupported or malformed, Fish MUST NOT materialize using that schema.

Instead, Fish SHOULD return an unsupported-schema or malformed-schema status code.

If no result schema is requested, Fish SHOULD return status-only.

If a fallback schema is used, the response SHOULD indicate that fallback occurred when the active schema permits such indication.

---

## 11. Diagnostic Interaction

Diagnostic envelopes are returned only when requested, negotiated, required by profile, or required by a safety/disclosure policy.

If diagnostics are not requested or required, Fish MAY return only status.

If diagnostics are requested but not permitted, Fish SHOULD return `403` or another profile-defined permission/disclosure status.

If diagnostics are requested but unavailable, Fish SHOULD return an appropriate unavailable or failed status from the registry.

---

## 12. Open Questions

The following remain open for future formalization:

- concrete Fish syntax for request envelopes;
- concrete Fish syntax for response envelopes;
- whether Fish envelopes are themselves serialized graph objects, protocol records, or both;
- exact standard operation/intent names;
- exact status code names in the registry for 400, 401, 403, 404, 409, 415, 422, and 424;
- whether 406 should be reserved for unacceptable schema negotiation distinct from 415 unsupported schema;
- how Fish envelope validation interacts with streaming requests and responses;
- how transaction boundaries are represented;
- how permission policy is represented as graph-native structure;
- how authentication/capability information is represented without forcing it into C4 Core.
