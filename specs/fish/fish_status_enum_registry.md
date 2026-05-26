# Fish Status Enum Registry v0.1.0 Draft

## Status

This document is a draft Fish protocol registry.

Fish status enums are stable symbolic projections of graph-native status objects and/or structured Fish status words.

Fish status enums do not replace C4 graph-native semantics.

The canonical status chain is:

```text
graph-native status object
  -> structured status word / status bit-vector
  -> named status enum
  -> optional numeric/textual protocol projection
```

This document defines an initial registry of named Fish status enums.

---

## 1. Registry Entry Shape

A Fish status enum registry entry SHOULD define:

- enum name;
- short meaning;
- status-word fields;
- optional numeric compatibility projection;
- valid contexts;
- materialization safety rule, where relevant;
- notes.

The status-word fields listed in this draft are provisional and may be refined by a future status-word layout specification.

---

## 2. Success and Accepted Statuses

### OK

Meaning: the requested operation completed successfully.

Status-word fields:

```text
request_wellformed
permission_granted
final
```

Optional compatibility projection: `200`.

Valid contexts:

- general protocol request;
- validation;
- graph-delta production;
- materialization;
- result projection.

Notes: `OK` is generic. More specific success statuses SHOULD be preferred when available.

---

### ACCEPTED

Meaning: the request was accepted for processing or accepted as valid input, but the requested operation may not yet be complete.

Status-word fields:

```text
request_wellformed
permission_granted
provisional
```

Optional compatibility projection: `202`.

Valid contexts:

- asynchronous processing;
- streaming negotiation;
- queued materialization;
- profile-defined deferred processing.

Notes: Fish should not imply background completion unless an actual protocol mechanism exists for retrieving later results.

---

### NO_MATERIAL_DIFFERENCE

Meaning: comparison, validation, or materialization found no material difference under the active policy.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
c4_valid
delta_produced
no_mutation
final
```

Optional compatibility projection: `204`.

Valid contexts:

- graph comparison;
- graph-delta production;
- materialization;
- validation.

Notes: This enum does not mean no graph-native result exists. It means the projected outcome has no material difference under the active policy.

---

## 3. Graph-Delta Production Statuses

### GRAPH_DELTA_PRODUCED

Meaning: graph-delta production succeeded and produced a graph-delta graph-object.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
delta_produced
final
```

Optional compatibility projection: `210`.

Valid contexts:

- graph-delta production;
- statement denotation;
- graph comparison.

Notes: This does not imply materialization occurred.

---

### GRAPH_DELTA_PRODUCTION_FAILED

Meaning: graph-delta production failed.

Status-word fields:

```text
request_wellformed
permission_granted
delta_failed
materialization_not_attempted
final
```

Optional compatibility projection: `520`.

Valid contexts:

- graph-delta production;
- statement denotation;
- graph comparison.

Materialization safety: mutating materialization MUST NOT occur after graph-delta production failure.

---

### UNRESOLVED_COMPARISON

Meaning: graph comparison could not resolve correspondence, equivalence, substitutability, or difference classification under the active policy.

Status-word fields:

```text
request_wellformed
permission_granted
validation_unresolved
materialization_not_attempted
final
```

Optional compatibility projection: `409` or profile-defined.

Valid contexts:

- graph comparison;
- graph-delta production;
- validation.

Notes: Richer schemas SHOULD preserve unresolved graph-native structures when requested.

---

## 4. Materialization Statuses

### MATERIALIZATION_NOT_ATTEMPTED

Meaning: materialization did not occur.

Status-word fields:

```text
materialization_not_attempted
final
```

Optional compatibility projection: profile-defined.

Valid contexts:

- request validation failure;
- authentication or permission failure;
- result-schema negotiation failure;
- graph-delta production failure;
- validation failure;
- status-only graph-delta production response;
- profile-defined preflight response.

Materialization safety: mutating materialization MUST NOT occur when this enum is returned as a final status.

Notes: This enum is useful in status traces to distinguish failure before materialization from attempted materialization failure.

---

### MATERIALIZED_NO_MUTATION

Meaning: materialization succeeded and produced a materialization-result graph-object without mutating persistent graph state.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
delta_produced
materialization_succeeded
no_mutation
final
```

Optional compatibility projection: `200` or `204` depending on profile.

Valid contexts:

- materialization;
- read-only materializer;
- diagnostic materializer;
- projection materializer;
- no-op materializer.

---

### MATERIALIZED_MUTATION_APPLIED

Meaning: materialization succeeded and applied mutation to persistent graph state.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
delta_produced
materialization_succeeded
mutation_applied
final
```

Optional compatibility projection: `200` or `201` depending on profile.

Valid contexts:

- mutating materialization.

Materialization safety: this enum MUST NOT be returned unless permission, schema, profile, and materialization policy validation occurred before mutation.

---

### PARTIAL_MATERIALIZATION

Meaning: materialization partially succeeded under the active materializer/profile.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
delta_produced
partial_materialization
final
```

Optional compatibility projection: `206`.

Valid contexts:

- materialization;
- streaming materialization;
- profile-defined partial processing.

Notes: Richer result schemas SHOULD explain what was materialized and what was not.

---

### MATERIALIZATION_PROHIBITED

Meaning: materialization was prohibited by policy.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
materialization_rejected
materialization_not_attempted
final
```

Optional compatibility projection: `403`.

Valid contexts:

- materialization request;
- relator materialization expectation;
- graph-delta materialization policy.

Materialization safety: mutating materialization MUST NOT occur.

---

### MATERIALIZATION_FAILED

Meaning: materialization was attempted but failed.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
delta_produced
materialization_failed
final
```

Optional compatibility projection: `500` or `520` depending on profile.

Valid contexts:

- materialization.

Notes: If mutation may have partially occurred, a richer result schema SHOULD be used to describe state and recovery information.

---

### INTERNAL_MATERIALIZER_FAILURE

Meaning: the active materializer failed due to an internal, implementation-side, or field-side condition.

Status-word fields:

```text
request_wellformed
permission_granted
schema_accepted
delta_produced
materialization_failed
final
```

Optional compatibility projection: `500`.

Valid contexts:

- materialization;
- projection;
- export;
- indexing.

Notes: Profiles MAY distinguish this from user/request-side materialization failure.

---

## 5. Request and Envelope Statuses

### MALFORMED_REQUEST

Meaning: the request envelope or protocol structure is malformed.

Status-word fields:

```text
request_present
request_malformed
materialization_not_attempted
final
```

Optional compatibility projection: `400`.

Valid contexts:

- request parsing;
- request envelope validation.

Materialization safety: mutating materialization MUST NOT occur.

---

### SEMANTICALLY_INVALID_REQUEST

Meaning: the request is well-formed but semantically invalid under the active Fish/C4 profile.

Status-word fields:

```text
request_wellformed
c4_invalid
materialization_not_attempted
final
```

Optional compatibility projection: `422`.

Valid contexts:

- validation;
- endpoint consumption;
- relator validation;
- relation-state validation;
- profile validation.

Materialization safety: mutating materialization MUST NOT occur.

---

### FAILED_DEPENDENCY

Meaning: the requested operation could not proceed because a required dependency failed.

Status-word fields:

```text
request_wellformed
materialization_not_attempted
final
```

Optional compatibility projection: `424`.

Valid contexts:

- profile loading;
- graph resolution;
- schema negotiation;
- materializer dependency resolution;
- field dependency resolution.

Materialization safety: mutating materialization MUST NOT occur unless a profile explicitly defines safe partial behavior and returns a richer result schema.

---

## 6. Authentication and Permission Statuses

### AUTHENTICATION_REQUIRED

Meaning: the requester has not established an acceptable identity, credential, session, capability, or authentication context.

Status-word fields:

```text
request_wellformed
auth_required
materialization_not_attempted
final
```

Optional compatibility projection: `401`.

Valid contexts:

- request envelope validation;
- capability validation;
- materialization request authorization.

Materialization safety: mutating materialization MUST NOT occur.

---

### AUTHENTICATION_FAILED

Meaning: authentication was supplied but rejected.

Status-word fields:

```text
request_wellformed
auth_failed
materialization_not_attempted
final
```

Optional compatibility projection: `401`.

Valid contexts:

- request envelope validation;
- authentication validation.

Materialization safety: mutating materialization MUST NOT occur.

---

### PERMISSION_DENIED

Meaning: the requester is known sufficiently, but policy prohibits the requested operation, projection, materialization, graph access, or diagnostic disclosure.

Status-word fields:

```text
request_wellformed
auth_accepted
permission_denied
materialization_not_attempted
final
```

Optional compatibility projection: `403`.

Valid contexts:

- authorization validation;
- materialization policy validation;
- graph access control;
- diagnostic disclosure control;
- projection control.

Materialization safety: mutating materialization MUST NOT occur.

---

## 7. Schema and Negotiation Statuses

### UNSUPPORTED_RESULT_SCHEMA

Meaning: the requested result schema is well-formed enough to identify but unsupported by the active Fish implementation, profile, materializer, or field.

Status-word fields:

```text
request_wellformed
schema_requested
schema_unsupported
materialization_not_attempted
final
```

Optional compatibility projection: `415`.

Valid contexts:

- result-schema negotiation;
- projection negotiation;
- diagnostic envelope negotiation;
- materialization-result negotiation.

Materialization safety: mutating materialization MUST NOT occur.

---

### MALFORMED_RESULT_SCHEMA

Meaning: the requested result schema is malformed and cannot be used for projection negotiation.

Status-word fields:

```text
request_wellformed
schema_requested
schema_malformed
materialization_not_attempted
final
```

Optional compatibility projection: `400` or profile-defined.

Valid contexts:

- result-schema negotiation;
- projection negotiation;
- diagnostic envelope negotiation.

Materialization safety: mutating materialization MUST NOT occur.

---

### FALLBACK_SCHEMA_USED

Meaning: the requested schema was unavailable or unsuitable, and an acceptable fallback schema was used.

Status-word fields:

```text
request_wellformed
schema_requested
fallback_schema_used
projection_succeeded
final
```

Optional compatibility projection: `300` or `203` depending on profile.

Valid contexts:

- result-schema negotiation;
- projection;
- protocol response.

Notes: The response SHOULD indicate the schema actually used when the active result schema permits such indication.

---

## 8. Resource, Conflict, and Ambiguity Statuses

### REQUESTED_RESOURCE_NOT_FOUND

Meaning: a requested graph, profile, schema, registry entry, or protocol resource could not be found or resolved.

Status-word fields:

```text
request_wellformed
materialization_not_attempted
final
```

Optional compatibility projection: `404`.

Valid contexts:

- graph resolution;
- profile resolution;
- schema resolution;
- registry lookup.

Materialization safety: mutating materialization MUST NOT occur when the missing resource is required before mutation.

---

### CONFLICT_OR_AMBIGUOUS_CORRESPONDENCE

Meaning: the request encountered conflict or ambiguity, such as ambiguous correspondence policy, conflicting graph-delta markings, incompatible profile constraints, or active graph conflict.

Status-word fields:

```text
request_wellformed
validation_unresolved
materialization_not_attempted
final
```

Optional compatibility projection: `409`.

Valid contexts:

- graph comparison;
- validation;
- graph-delta production;
- materialization preflight.

Notes: Richer schemas SHOULD preserve ambiguity in graph-native diagnostic or result structures when requested.

---

## 9. Validation and Diagnostic Statuses

### VALIDATION_FAILED

Meaning: validation failed under the active Fish/C4 profile.

Status-word fields:

```text
request_wellformed
c4_invalid
materialization_not_attempted
final
```

Optional compatibility projection: `422`.

Valid contexts:

- C4 validation;
- Fish envelope validation;
- endpoint-policy validation;
- relator validation;
- materialization preflight.

Materialization safety: mutating materialization MUST NOT occur.

---

### DIAGNOSTICS_AVAILABLE

Meaning: diagnostics are available under the active negotiated result schema or disclosure policy.

Status-word fields:

```text
request_wellformed
diagnostics_available
final
```

Optional compatibility projection: profile-defined.

Valid contexts:

- diagnostic envelope;
- validation;
- materialization failure;
- negotiation failure.

---

### DIAGNOSTICS_WITHHELD

Meaning: diagnostics exist or may exist, but disclosure policy prevents returning them.

Status-word fields:

```text
request_wellformed
diagnostics_requested
diagnostics_withheld
final
```

Optional compatibility projection: `403` or profile-defined.

Valid contexts:

- diagnostic envelope;
- disclosure policy;
- permissions.

---

### DIAGNOSTICS_UNAVAILABLE

Meaning: diagnostics were requested but are unavailable.

Status-word fields:

```text
request_wellformed
diagnostics_requested
diagnostics_unavailable
final
```

Optional compatibility projection: profile-defined.

Valid contexts:

- diagnostic envelope;
- validation;
- materialization;
- projection.

---

## 10. Projection Statuses

### PROJECTION_SUCCEEDED

Meaning: the requested Fish projection succeeded.

Status-word fields:

```text
request_wellformed
schema_accepted
projection_succeeded
final
```

Optional compatibility projection: `200`.

Valid contexts:

- result-schema projection;
- graph-delta projection;
- materialization-result projection;
- diagnostic projection.

---

### PROJECTION_FAILED

Meaning: the requested Fish projection failed.

Status-word fields:

```text
request_wellformed
schema_accepted
projection_failed
final
```

Optional compatibility projection: `500` or profile-defined.

Valid contexts:

- result-schema projection;
- graph-delta projection;
- materialization-result projection;
- diagnostic projection.

---

### RESULT_TRUNCATED

Meaning: the response projection was truncated under the active profile, transport limit, or negotiated schema.

Status-word fields:

```text
request_wellformed
projection_succeeded
result_truncated
final
```

Optional compatibility projection: `206` or profile-defined.

Valid contexts:

- projection;
- streaming;
- transport;
- diagnostic envelope.

---

## 11. Open Questions

The following remain open for future formalization:

- exact mandatory Fish status-word bit layout;
- whether optional compatibility projections should be normative defaults or profile-specific;
- whether numeric compatibility projections should remain HTTP-like;
- exact graph-native status-object references for each enum;
- whether status enum registry should be machine-readable Fish graph data;
- whether status-word fields should be grouped into fixed bit ranges;
- whether success statuses should distinguish graph-delta success from projection success more strictly;
- whether diagnostics-available should be a status enum, a status-word field only, or both;
- how extension profiles should register new enums and fields.
