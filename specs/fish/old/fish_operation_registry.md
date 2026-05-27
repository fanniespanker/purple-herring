# Fish Operation Registry v0.1.0 Draft

## Status

This document is a draft Fish protocol registry.

Fish operations are protocol-level request intents. They are not C4 Core primitive operations.

C4 Core provides the minimal graph-native theory used by Fish, including graph-objects, statements, relators, endpoint consumption, graph-delta production, materialization, and no primitive identity.

Fish operations define what a request fish asks an implementation to do with those graph-native structures.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Operation names use snake_case.

---

## 1. Operation Relation

A request fish MAY specify its requested operation with:

```fish
<request-fish>&fish:proto:operation@fish:proto:<operation-name>;
```

Example:

```fish
fish:id:REQ&fish:proto:operation@fish:proto:produce_delta;
```

If no operation is specified, the active Fish profile MUST define the default operation or return an operation/schema negotiation failure status.

Fish implementations MUST validate the requested operation before any mutating materialization occurs.

---

## 2. General Operation Safety Rule

Malformed, unsupported, unauthorized, permission-denied, invalid, or unresolved preflight states MUST NOT authorize mutating materialization.

Before any operation performs mutating materialization, the implementation MUST validate at least:

- request fish structure;
- requested operation;
- active Fish profile;
- requested result schema and schema traits;
- authentication/capability context, where relevant;
- permission policy;
- materialization policy;
- operation-specific preconditions.

If preflight validation fails, Fish SHOULD return a status-only graph response unless a diagnostic/result schema was explicitly requested and is permitted.

Example:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(UNSUPPORTED_OPERATION,MATERIALIZATION_NOT_ATTEMPTED);
```

or:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(PERMISSION_DENIED,MATERIALIZATION_NOT_ATTEMPTED);
```

Some operation-specific statuses may be provisional until added to the Fish status enum registry.

---

## 3. Registry Entry Shape

A Fish operation registry entry SHOULD define:

- operation name;
- meaning;
- required request-fish relations;
- optional request-fish relations;
- whether C4 graph-delta production may occur;
- whether materialization may occur;
- whether persistent graph mutation may occur;
- default result schema;
- likely status enums;
- preflight/safety requirements;
- notes.

---

## 4. Operation: `validate`

Canonical operation name:

```fish
fish:proto:validate
```

Meaning: validate a request, payload, expression, statement, graph-object reference, result schema, profile request, or profile-defined structure without performing mutating materialization.

Required request-fish relations: profile-defined.

Optional request-fish relations:

```fish
fish:proto:payload
fish:proto:result_schema
fish:proto:diagnostic_schema
fish:proto:profile
fish:proto:accept_profile
```

Graph-delta production may occur: profile-defined, but SHOULD NOT be required for basic syntactic/protocol validation.

Materialization may occur: only non-mutating validation/projection materialization, if the active profile treats validation output as materialization.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only`.

Likely status enums:

```fish
OK
VALIDATION_FAILED
SEMANTICALLY_INVALID_REQUEST
MALFORMED_REQUEST
MALFORMED_RESULT_SCHEMA
UNSUPPORTED_RESULT_SCHEMA
DIAGNOSTICS_AVAILABLE
DIAGNOSTICS_WITHHELD
DIAGNOSTICS_UNAVAILABLE
```

Safety requirements: validation MUST NOT authorize mutation by itself. If validation is used as a preflight stage for a later mutating operation, the later operation must still validate its own operation-specific requirements.

---

## 5. Operation: `produce_delta`

Canonical operation name:

```fish
fish:proto:produce_delta
```

Meaning: produce a C4 graph-delta graph-object from a delta-source graph-object under the active field/profile.

C4-theoretic reference:

$$
\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta
$$

Required request-fish relations: profile-defined delta-source reference or payload.

Typical request-fish relations:

```fish
fish:proto:payload
fish:proto:delta_source
fish:proto:result_schema
fish:proto:profile
fish:proto:materialization_policy
```

Graph-delta production may occur: yes.

Materialization may occur: no mutating materialization. Non-mutating projection materialization may occur only if needed to project the result schema and permitted by profile.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only`.

Likely status enums:

```fish
GRAPH_DELTA_PRODUCED
GRAPH_DELTA_PRODUCTION_FAILED
MATERIALIZATION_NOT_ATTEMPTED
VALIDATION_FAILED
UNRESOLVED_COMPARISON
CONFLICT_OR_AMBIGUOUS_CORRESPONDENCE
PROJECTION_SUCCEEDED
PROJECTION_FAILED
```

Safety requirements: this operation MUST NOT mutate persistent graph state. If a graph-delta graph or summary is requested, projection is governed by the negotiated result schema.

Notes: `produce_delta` is the standard Fish operation corresponding most directly to C4 graph-delta production. It does not imply materialization.

---

## 6. Operation: `materialize`

Canonical operation name:

```fish
fish:proto:materialize
```

Meaning: materialize a graph-delta graph-object under the active field/profile/materialization policy.

C4-theoretic reference:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu
$$

Required request-fish relations: profile-defined graph-delta reference, delta-source payload, statement/block payload, or operation-specific payload.

Typical request-fish relations:

```fish
fish:proto:payload
fish:proto:delta_source
fish:proto:graph_delta
fish:proto:materialization_policy
fish:proto:result_schema
fish:proto:profile
```

Graph-delta production may occur: yes, if the request provides a delta source rather than an already-produced graph-delta.

Materialization may occur: yes.

Persistent mutation may occur: only if explicitly permitted by the active profile, materialization policy, authorization policy, and operation preflight.

Default result schema: `fish:proto:status_only`.

Likely status enums:

```fish
GRAPH_DELTA_PRODUCED
MATERIALIZED_NO_MUTATION
MATERIALIZED_MUTATION_APPLIED
MATERIALIZATION_NOT_ATTEMPTED
MATERIALIZATION_PROHIBITED
MATERIALIZATION_FAILED
PARTIAL_MATERIALIZATION
INTERNAL_MATERIALIZER_FAILURE
PERMISSION_DENIED
AUTHENTICATION_REQUIRED
AUTHENTICATION_FAILED
```

Safety requirements: mutating materialization MUST NOT occur unless request structure, profile, result schema, authentication/capability, permission policy, materialization policy, and graph-delta admissibility all validate successfully.

Notes: Materialization is not identical to mutation. Read-only, diagnostic, projection, export, indexing, no-op, or validation materializers may be non-mutating.

---

## 7. Operation: `project_result`

Canonical operation name:

```fish
fish:proto:project_result
```

Meaning: project an existing graph-native result, graph-delta, materialization-result, diagnostic graph, or profile-defined graph-object into a negotiated Fish result schema.

Required request-fish relations: profile-defined result reference or payload.

Typical request-fish relations:

```fish
fish:proto:payload
fish:proto:result
fish:proto:result_schema
fish:proto:fallback_result_schema
fish:proto:profile
```

Graph-delta production may occur: no, unless a profile explicitly defines projection from delta source as shorthand.

Materialization may occur: only non-mutating projection materialization, if the implementation models projection as materialization.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only` or profile-defined projection default.

Likely status enums:

```fish
PROJECTION_SUCCEEDED
PROJECTION_FAILED
UNSUPPORTED_RESULT_SCHEMA
MALFORMED_RESULT_SCHEMA
FALLBACK_SCHEMA_USED
RESULT_TRUNCATED
PERMISSION_DENIED
```

Safety requirements: projection MUST respect disclosure and permission policy. Omission from a projection MUST NOT imply semantic absence from the underlying graph-native object unless the negotiated schema explicitly defines that interpretation.

---

## 8. Operation: `compare_graphs`

Canonical operation name:

```fish
fish:proto:compare_graphs
```

Meaning: compare graph regions, graph containers, graph-object references, or projected graph structures by constructing or referencing a comparison-style delta source, then producing a graph-delta under the active field/profile.

C4 boundary: graph comparison is not a separate C4 primitive. Fish `compare_graphs` is a protocol operation that prepares or references an appropriate delta-source graph-object and invokes graph-delta production.

Required request-fish relations: profile-defined source/target graph references or comparison payload.

Typical request-fish relations:

```fish
fish:proto:source
fish:proto:target
fish:proto:comparison_policy
fish:proto:result_schema
fish:proto:profile
```

Graph-delta production may occur: yes.

Materialization may occur: no mutating materialization. Non-mutating projection materialization may occur if required for requested result schemas.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only`.

Likely status enums:

```fish
GRAPH_DELTA_PRODUCED
GRAPH_DELTA_PRODUCTION_FAILED
UNRESOLVED_COMPARISON
CONFLICT_OR_AMBIGUOUS_CORRESPONDENCE
MATERIALIZATION_NOT_ATTEMPTED
PROJECTION_SUCCEEDED
PROJECTION_FAILED
```

Safety requirements: comparison MUST NOT claim primitive identity. Correspondence, equivalence, substitutability, or alignment is determined by active field/profile/comparison policy and the comparison delta-source graph.

Notes: Added/removed/modified/unchanged/unresolved markings belong to Fish graph-delta projection schemas or profiles, not C4 Core.

---

## 9. Operation: `negotiate_profile`

Canonical operation name:

```fish
fish:proto:negotiate_profile
```

Meaning: select or report an active Fish profile from requested or acceptable profiles.

Required request-fish relations: one or more profile request/acceptance relations.

Typical request-fish relations:

```fish
fish:proto:profile
fish:proto:accept_profile
fish:proto:result_schema
```

Graph-delta production may occur: no.

Materialization may occur: no mutating materialization.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only`.

Likely status enums:

```fish
OK
UNSUPPORTED_PROFILE
MALFORMED_PROFILE
PROFILE_NEGOTIATION_FAILED
MATERIALIZATION_NOT_ATTEMPTED
```

Safety requirements: failed profile negotiation MUST NOT authorize mutating materialization.

Notes: Some listed status enums may be provisional until added to the status enum registry.

---

## 10. Operation: `negotiate_result_schema`

Canonical operation name:

```fish
fish:proto:negotiate_result_schema
```

Meaning: validate and select a requested Fish result schema and schema traits, optionally selecting fallback schemas.

Required request-fish relations: one or more result-schema request relations.

Typical request-fish relations:

```fish
fish:proto:result_schema
fish:proto:fallback_result_schema
fish:proto:accept_profile
fish:proto:profile
```

Graph-delta production may occur: no.

Materialization may occur: no mutating materialization.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only`.

Likely status enums:

```fish
OK
UNSUPPORTED_RESULT_SCHEMA
MALFORMED_RESULT_SCHEMA
FALLBACK_SCHEMA_USED
INCOMPATIBLE_SCHEMA_TRAITS
MATERIALIZATION_NOT_ATTEMPTED
```

Safety requirements: malformed, unsupported, unauthorized, or incompatible result schemas MUST NOT trigger mutating materialization.

Notes: Some listed status enums may be provisional until added to the status enum registry.

---

## 11. Operation: `explain_status`

Canonical operation name:

```fish
fish:proto:explain_status
```

Meaning: return an explanation, expansion, compatibility projection, status-word interpretation, or diagnostic-oriented description of one or more Fish status enums or status-word projections.

Required request-fish relations: profile-defined status enum, status list, status word, or status response reference.

Typical request-fish relations:

```fish
fish:proto:status
fish:proto:status_word_64
fish:proto:result_schema
fish:proto:diagnostic_schema
fish:proto:profile
```

Graph-delta production may occur: no, unless a profile models explanation as a graph-delta-producing diagnostic operation.

Materialization may occur: only non-mutating explanation/projection materialization.

Persistent mutation may occur: no.

Default result schema: `fish:proto:status_only` or profile-defined status explanation schema.

Likely status enums:

```fish
OK
PROJECTION_SUCCEEDED
PROJECTION_FAILED
DIAGNOSTICS_AVAILABLE
DIAGNOSTICS_WITHHELD
DIAGNOSTICS_UNAVAILABLE
UNSUPPORTED_RESULT_SCHEMA
```

Safety requirements: status explanations MUST respect diagnostic disclosure policy. Explanations may be withheld even when the status enum itself is visible.

---

## 12. Provisional Status Enum Additions

This registry refers to the following status enums that may need to be added to the Fish status enum registry if they are not already present:

```fish
UNSUPPORTED_OPERATION
UNSUPPORTED_PROFILE
MALFORMED_PROFILE
PROFILE_NEGOTIATION_FAILED
INCOMPATIBLE_SCHEMA_TRAITS
```

Until added to the registry, profiles MAY treat them as provisional operation/profile-negotiation statuses.

---

## 13. Open Questions

The following remain open for future formalization:

- whether operation names should be split into request operations and internal processing stages;
- whether `project_result` should be an explicit operation or only an implicit stage of result-schema negotiation;
- whether `compare_graphs` should be standardized or treated as a profile-defined specialization of `produce_delta`;
- exact required request-fish relations for each operation;
- exact capability graph syntax for supported operations;
- exact status enum additions for operation/profile/schema negotiation failures;
- whether operation aliases should be permitted;
- how operation negotiation interacts with transport-level methods;
- whether some operations require a bootstrap profile before profile negotiation itself can occur.
