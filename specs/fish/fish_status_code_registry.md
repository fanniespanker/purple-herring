# Fish Status-Code Registry v0.1.0 Draft

## Status

This document is a draft Fish protocol specification.

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

This registry defines protocol-level status-code conventions for projecting graph-native C4 status objects into compact Fish responses.

Fish status codes do not replace C4 graph-native semantics.

A Fish status code identifies, references, or projects a graph-native status object associated with a C4 graph-object such as:

- a graph-delta object;
- a materialization-result object;
- a validation diagnostic object;
- a protocol response object;
- a profile-defined result object.

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

Fish MAY project C4 graph-native statuses into numeric status codes.

A Fish status code is therefore a protocol identifier for a graph-defined status. It is not the status itself.

---

## 2. Status-Only Default

Fish MAY define a status-only response as the default minimal response form for materialization, validation, graph-delta production, or protocol requests.

A status-only response contains only enough protocol information to communicate the status-code projection of a graph-native result.

A status-only response does not exhaust the C4 graph-object semantics of the underlying result.

For materialization:

$$
\mathbf{m}_{\mathfrak{F}}(\xi_\Delta)=\xi_\mu
$$

Fish MAY return only a status code projecting the status of:

$$
\xi_\mu\in\Xi_\mu
$$

unless the client negotiates a richer result schema.

---

## 3. Negotiated Result Schemas

Fish clients and materializers MAY negotiate richer result schemas.

Negotiated result schemas MAY include:

- status-only;
- diagnostic graph;
- patch graph;
- graph-delta graph;
- materialization-result graph;
- validation-result graph;
- protocol envelope;
- profile-defined result schema.

If no richer schema is negotiated, a Fish implementation MAY return a status-only response, provided the status code maps to a graph-native status object.

Negotiation syntax is not defined in this draft.

---

## 4. Code Structure

Fish status codes are numeric protocol identifiers.

This draft reserves broad status-code families but does not yet define the complete code registry.

Exact codes within each family are provisional until the Fish protocol syntax and negotiation model are stabilized.

A Fish status code SHOULD be interpreted only in the context of:

- active Fish protocol version;
- active C4 profile;
- active materialization, validation, or graph-delta profile;
- negotiated result schema, if any.

---

## 5. Reserved Status-Code Families

Fish status-code families are inspired by HTTP-style numeric organization, but their semantics are Fish/C4-specific.

### 1xx Informational / In-Progress / Partial Metadata

The `1xx` family is reserved for informational, provisional, in-progress, or metadata-only responses.

Possible meanings include:

- request accepted but not fully processed;
- partial status available;
- negotiation information returned;
- continuation or streaming response metadata;
- profile-defined informational response.

### 2xx Successful / Materialized / Equivalent / Accepted

The `2xx` family is reserved for successful Fish/C4 protocol outcomes.

Possible meanings include:

- graph-delta production succeeded;
- materialization succeeded;
- validation succeeded;
- no material difference found;
- graph structures accepted as unchanged/equivalent under active policy;
- status-only response succeeded;
- profile-defined success.

### 3xx Correspondence / Projection / Negotiation Redirection

The `3xx` family is reserved for correspondence, projection, negotiation, or alternate-representation outcomes.

Possible meanings include:

- result available under another negotiated schema;
- projection used;
- correspondence established under a non-default policy;
- resource, profile, or schema relocated;
- client should renegotiate result schema;
- profile-defined redirection or projection response.

### 4xx Request / Input / Validation / Policy Issue

The `4xx` family is reserved for request-side, input-side, validation, profile, or policy issues.

Possible meanings include:

- invalid Fish syntax;
- invalid C4 structure;
- unsupported profile requested;
- endpoint consumption failed;
- relator-position validation failed;
- relation-state incompatibility;
- unresolved or ambiguous comparison policy;
- materialization prohibited by policy;
- schema negotiation failed due to client request;
- profile-defined client/input failure.

### 5xx Field / Materializer / Evaluator / Server Failure

The `5xx` family is reserved for field-side, materializer-side, evaluator-side, implementation-side, or server-side failures.

Possible meanings include:

- active field unavailable;
- materializer failure;
- graph-delta production failure;
- internal evaluator failure;
- registry failure;
- storage failure;
- implementation limit exceeded;
- profile-defined server/materializer failure.

### 6xx Reserved for Profile-Defined Extensions

The `6xx` family is reserved for profile-defined or implementation-defined extensions.

Profiles using `6xx` codes MUST define how those codes map to graph-native status objects.

### 7xx Reserved for Experimental Extensions

The `7xx` family is reserved for experimental, unstable, or pre-standard Fish extensions.

Experimental codes MUST NOT be treated as portable without an explicit profile declaration.

### 8xx Reserved for Private / Vendor / Local Extensions

The `8xx` family is reserved for private, vendor, local, or implementation-specific status codes.

Private codes MUST NOT be assumed portable across Fish implementations.

### 9xx Reserved for Catastrophic / Out-of-Band / Meta-Protocol Conditions

The `9xx` family is reserved for catastrophic, out-of-band, meta-protocol, or implementation-defined emergency conditions.

Use of `9xx` codes SHOULD be rare and SHOULD be specified by protocol profiles.

---

## 6. Minimal Core Marking Correspondence

C4 graph-delta minimal markings are:

- added;
- removed;
- modified;
- unchanged;
- unresolved.

Fish MAY define status codes that project graph-delta roots or subregions bearing these markings.

The following conceptual mappings are reserved but not yet assigned exact codes:

| C4 marking / result | Fish family tendency |
|---|---|
| unchanged | `2xx` |
| added | `2xx` or `3xx` depending on context |
| removed | `2xx` or `3xx` depending on context |
| modified | `2xx`, `3xx`, or `4xx` depending on policy and request context |
| unresolved | `4xx` or `1xx` depending on whether the response is final |

Exact code assignment is deferred.

---

## 7. Status Codes Are Projections

A Fish implementation returning a numeric status code SHOULD be able to identify the graph-native status object or status relation that the code projects.

A Fish status code MUST NOT be treated as replacing:

$$
\xi_\Delta\in\Xi_\Delta
$$

or:

$$
\xi_\mu\in\Xi_\mu
$$

when the corresponding C4 graph-object is required by the negotiated schema.

If a response is status-only, the status code is a compact protocol projection of a graph-native result whose full graph structure may be omitted from the response.

---

## 8. Registry Requirements

A Fish status-code registry entry SHOULD define:

- numeric code;
- symbolic name;
- family;
- short description;
- graph-native status object or status relation projected by the code;
- whether the code is final or provisional;
- whether the code is valid for graph-delta production, materialization, validation, negotiation, or protocol transport;
- whether the code permits or requires a richer result schema;
- profile constraints, if any.

Registry entries SHOULD avoid encoding semantics that belong in C4 graph structure.

---

## 9. Open Questions

The following remain open for future formalization:

- exact Fish syntax for status-only responses;
- exact Fish syntax for result-schema negotiation;
- whether Fish should use three-digit numeric codes exclusively;
- whether `0xx` should be reserved for local/null/uncomputed statuses or avoided entirely;
- exact standard codes for success, no material difference, materialization prohibited, unresolved comparison, validation failure, and internal materializer failure;
- whether graph-delta markings should receive dedicated codes or only result roots should;
- how Fish status codes should reference graph-native status objects in serialized form;
- how Fish profiles should register extension codes;
- whether status-code registries should be machine-readable Fish graph documents.
