# Fish Status Registry v0.1.0 Draft

## Status

This document is a draft Fish protocol specification.

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

This registry defines protocol-level status conventions for projecting graph-native C4 status objects into compact Fish responses.

Fish statuses do not replace C4 graph-native semantics.

Protocol/control vocabulary, including status enum graph-objects, uses the `fish:proto:` namespace path.

A Fish status identifies, references, or projects a graph-native status object associated with a C4 graph-object such as:

- a graph-delta object;
- a materialization-result object;
- a validation diagnostic object;
- a protocol response object;
- a profile-defined result object.

The canonical Fish status model is not an HTTP-style decimal code table.

The canonical model is:

```text
graph-native status object
  -> structured status word / status bit-vector
  -> named status enum
  -> optional numeric/textual protocol projection
```

Numeric HTTP-like codes MAY be provided as compatibility projections, but they are not the canonical semantic representation of Fish status.

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

C4 Core does not define numeric status codes, protocol envelopes, transport-level response formats, or default materialization-result schemas.

Fish MAY project C4 graph-native statuses into structured status words, named status enums, numeric status codes, or textual status labels.

A Fish status projection is therefore a protocol identifier for graph-defined status. It is not the status itself.

---

## 2. Status-Only Default

Fish MAY define a status-only response as the default minimal response form for materialization, validation, graph-delta production, or protocol requests.

A status-only response contains only enough protocol graph structure to communicate the status projection of a graph-native result.

The canonical graph-native status-only response form is:

```fish
<request-fish>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

A status-only response does not exhaust the C4 graph-object semantics of the underlying result.

For materialization:

$$
\mathbf{m}_{\mathfrak{F}}(\xi_\Delta)=\xi_\mu
$$

Fish MAY return only a status projection of:

$$
\xi_\mu\in\Xi_\mu
$$

unless the client negotiates a richer result schema.

---

## 3. Negotiated Result Schemas

Fish clients and materializers MAY negotiate richer result schemas.

Negotiated result schemas MAY include:

- `fish:proto:statusOnly`;
- `fish:proto:diagnosticGraph`;
- `fish:proto:patchGraph`;
- `fish:proto:graphDeltaGraph`;
- `fish:proto:materializationResultGraph`;
- `fish:proto:validationResultGraph`;
- `fish:proto:protocolEnvelope`;
- profile-defined result schema.

If no richer schema is negotiated, a Fish implementation MAY return a status-only response, provided the status projection maps to a graph-native status object.

Negotiation syntax is not fully defined in this draft.

---

## 4. Status Word Model

A Fish status word is a compact structured projection of a graph-native status object.

A status word MAY be represented as:

- a bit-vector;
- a boolean-field record;
- a compact binary word;
- a named enum expansion;
- a profile-defined status graph projection.

The exact wire representation is not fixed by this draft.

The purpose of the status word is to represent multiple status dimensions without forcing all outcomes into a single flat decimal registry.

A status word SHOULD be interpretable only in the context of:

- active Fish protocol version;
- active C4 profile;
- active materialization, validation, or graph-delta profile;
- negotiated result schema, if any;
- profile-defined status-word layout, if any.

---

## 5. Recommended Status Dimensions

A Fish status word SHOULD be able to project, when relevant, dimensions such as:

- protocol severity;
- request parse/shape validity;
- authentication state;
- permission/authorization state;
- result-schema negotiation state;
- active profile compatibility;
- C4 validation state;
- graph-delta production state;
- materialization state;
- mutation state;
- result projection state;
- diagnostic availability/disclosure state;
- final/provisional state;
- profile-defined state.

This draft does not require all status words to include all dimensions.

A profile MAY define a smaller or larger status-word layout.

---

## 6. Suggested Boolean / Bit Fields

The following fields are suggested for early Fish status-word profiles.

They are provisional and not yet a mandatory wire layout.

### Request Fields

- `request_present`
- `request_parsed`
- `request_malformed`
- `request_wellformed`

### Authentication and Permission Fields

- `auth_required`
- `auth_accepted`
- `auth_failed`
- `permission_granted`
- `permission_denied`

### Schema Negotiation Fields

- `schema_requested`
- `schema_accepted`
- `schema_malformed`
- `schema_unsupported`
- `fallback_schema_used`

### Profile and Validation Fields

- `profile_accepted`
- `profile_unsupported`
- `c4_valid`
- `c4_invalid`
- `validation_unresolved`

### Delta and Materialization Fields

- `delta_produced`
- `delta_failed`
- `materialization_not_attempted`
- `materialization_rejected`
- `materialization_succeeded`
- `materialization_failed`
- `mutation_applied`
- `no_mutation`
- `partial_materialization`

### Result Projection and Diagnostic Fields

- `projection_succeeded`
- `projection_failed`
- `diagnostics_available`
- `diagnostics_requested`
- `diagnostics_withheld`
- `diagnostics_unavailable`
- `result_truncated`

### Finality Fields

- `provisional`
- `final`

---

## 7. Named Status Enums

A Fish status enum is a stable symbolic projection of a status word or graph-native status object.

Status enum graph-objects SHOULD live under `fish:proto:`.

Examples of named status enums include:

```text
fish:proto:PERMISSION_DENIED
fish:proto:AUTHENTICATION_REQUIRED
fish:proto:UNSUPPORTED_RESULT_SCHEMA
fish:proto:MALFORMED_RESULT_SCHEMA
fish:proto:MATERIALIZED_MUTATION_APPLIED
fish:proto:MATERIALIZED_NO_MUTATION
fish:proto:GRAPH_DELTA_PRODUCED
fish:proto:VALIDATION_FAILED
fish:proto:UNRESOLVED_COMPARISON
fish:proto:INTERNAL_MATERIALIZER_FAILURE
```

Named enums SHOULD be defined by their status-word semantics, not by decimal number alone.

For example:

```text
fish:proto:PERMISSION_DENIED =
  request_wellformed
  auth_accepted
  permission_denied
  materialization_not_attempted
  final
```

```text
fish:proto:UNSUPPORTED_RESULT_SCHEMA =
  request_wellformed
  schema_requested
  schema_unsupported
  materialization_not_attempted
  final
```

```text
fish:proto:MATERIALIZED_MUTATION_APPLIED =
  request_wellformed
  permission_granted
  schema_accepted
  delta_produced
  materialization_succeeded
  mutation_applied
  final
```

```text
fish:proto:MATERIALIZED_NO_MUTATION =
  request_wellformed
  permission_granted
  schema_accepted
  delta_produced
  materialization_succeeded
  no_mutation
  final
```

A profile MAY define additional enum names.

---

## 8. Numeric and HTTP-Like Compatibility Projections

Fish MAY define numeric protocol codes as compatibility projections.

Numeric codes MAY resemble HTTP-style families such as `2xx`, `4xx`, or `5xx`, but the canonical Fish status semantics are the graph-native status object and status word.

A numeric code SHOULD map to a named status enum and a status-word definition.

For example, a Fish profile MAY map:

```text
403 -> fish:proto:PERMISSION_DENIED
415 -> fish:proto:UNSUPPORTED_RESULT_SCHEMA
422 -> fish:proto:VALIDATION_FAILED
```

Such mappings are compatibility projections and protocol conveniences.

They MUST NOT replace graph-native status objects or status-word semantics.

---

## 9. Reserved Numeric Projection Families

Fish numeric projection families are optional, compatibility-oriented, and inspired by HTTP-style organization.

Their semantics are Fish/C4-specific.

### 1xx Informational / In-Progress / Partial Metadata

The `1xx` family is reserved for informational, provisional, in-progress, or metadata-only responses.

### 2xx Successful / Materialized / Equivalent / Accepted

The `2xx` family is reserved for successful Fish/C4 protocol outcomes.

### 3xx Correspondence / Projection / Negotiation Redirection

The `3xx` family is reserved for correspondence, projection, negotiation, or alternate-representation outcomes.

### 4xx Request / Input / Validation / Policy Issue

The `4xx` family is reserved for request-side, input-side, validation, profile, permission, or policy issues.

### 5xx Field / Materializer / Evaluator / Server Failure

The `5xx` family is reserved for field-side, materializer-side, evaluator-side, implementation-side, or server-side failures.

### 6xx Reserved for Profile-Defined Extensions

The `6xx` family is reserved for profile-defined or implementation-defined extensions.

### 7xx Reserved for Experimental Extensions

The `7xx` family is reserved for experimental, unstable, or pre-standard Fish extensions.

### 8xx Reserved for Private / Vendor / Local Extensions

The `8xx` family is reserved for private, vendor, local, or implementation-specific status codes.

### 9xx Reserved for Catastrophic / Out-of-Band / Meta-Protocol Conditions

The `9xx` family is reserved for catastrophic, out-of-band, meta-protocol, or implementation-defined emergency conditions.

---

## 10. Minimal Core Marking Correspondence

C4 graph-delta minimal markings are:

- added;
- removed;
- modified;
- unchanged;
- unresolved.

Fish MAY define status enums or status words that project graph-delta roots or subregions bearing these markings.

Exact enum and numeric projection assignment is deferred.

---

## 11. Status Projections Are Not C4 Semantics

A Fish implementation returning a status word, named enum, numeric code, or textual status SHOULD be able to identify the graph-native status object or status relation that the projection represents.

A Fish status projection MUST NOT be treated as replacing:

$$
\xi_\Delta\in\Xi_\Delta
$$

or:

$$
\xi_\mu\in\Xi_\mu
$$

when the corresponding C4 graph-object is required by the negotiated schema.

If a response is status-only, the status projection is a compact protocol projection of a graph-native result whose full graph structure may be omitted from the response.

---

## 12. Registry Requirements

A Fish status registry entry SHOULD define:

- symbolic enum name;
- graph-native status object or status relation projected by the enum;
- status-word fields or bit-vector semantics;
- optional numeric compatibility code;
- optional textual label;
- short description;
- whether the status is final or provisional;
- whether the status is valid for graph-delta production, materialization, validation, negotiation, or protocol transport;
- whether the status permits or requires a richer result schema;
- profile constraints, if any.

Registry entries SHOULD avoid encoding semantics that belong only in C4 graph structure.

---

## 13. Open Questions

The following remain open for future formalization:

- exact Fish syntax for status-only responses;
- exact Fish syntax for result-schema negotiation;
- exact mandatory status-word bit layout, if any;
- whether Fish should define a canonical binary status word or only named enum projections;
- whether HTTP-like numeric projections should be required, optional, or profile-specific;
- exact standard enum definitions for success, no material difference, materialization prohibited, unresolved comparison, validation failure, unsupported schema, malformed schema, permission denied, and internal materializer failure;
- whether graph-delta markings should receive dedicated status enums or only result roots should;
- how Fish status projections should reference graph-native status objects in serialized form;
- how Fish profiles should register extension enums, bit fields, and numeric compatibility projections;
- whether status registries should be machine-readable Fish graph documents.
