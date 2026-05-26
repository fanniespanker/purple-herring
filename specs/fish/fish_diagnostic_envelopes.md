# Fish Diagnostic Envelopes v0.1.0 Draft

## Status

This document is a draft Fish protocol specification.

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

This document defines diagnostic envelopes as protocol projections of graph-native diagnostic structures.

Fish diagnostic envelopes do not replace C4 graph-native semantics.

A diagnostic envelope is returned only when requested by a negotiated result schema or required by an active Fish/C4 profile.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Relationship to C4 Core

C4 Core may represent diagnostics as graph-objects or graph structure associated with:

- graph-delta objects;
- materialization-result objects;
- validation results;
- endpoint-consumption failures;
- relator-position failures;
- relation-state incompatibilities;
- malformed or unsupported result schemas;
- profile-defined failures or warnings.

Fish diagnostic envelopes are protocol projections of those graph-native diagnostic structures.

A Fish diagnostic envelope MUST NOT be treated as replacing the underlying C4 graph-object semantics.

---

## 2. Default Diagnostic Behavior

Fish SHOULD return status-only by default when no richer result schema is requested.

A status-only response is graph-native Fish syntax such as:

```fish
<request-fish>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

Fish SHOULD only return diagnostics when:

- the client requests a diagnostic result schema;
- the client requests a result schema that includes diagnostics;
- the active protocol/profile requires diagnostics;
- a profile-defined safety rule requires diagnostic disclosure.

If diagnostics are not requested or required, Fish MAY omit diagnostic details and return only a status-only response.

Omission of diagnostics from a Fish response MUST NOT be interpreted as absence of graph-native diagnostic structure unless the negotiated schema explicitly defines that interpretation.

---

## 3. Diagnostic Envelope as Projection

A Fish diagnostic envelope is a projection of one or more graph-native diagnostic objects.

A diagnostic envelope MAY summarize, serialize, group, or filter diagnostic graph structure according to the negotiated result schema.

A diagnostic envelope MAY include:

- response status;
- diagnostic envelope schema identifier;
- diagnostic entries;
- graph-object references;
- source/result schema references;
- profile references;
- materialization or graph-delta references;
- profile-defined metadata.

The exact envelope syntax is deferred to a future Fish surface/protocol syntax draft.

Protocol diagnostic envelope schema names SHOULD use `fish:proto:<schema_name>` unless another profile namespace is explicitly selected.

---

## 4. Minimal Diagnostic Entry

A Fish diagnostic entry SHOULD be able to project, when available:

- a diagnostic status or enum;
- a severity;
- a short summary;
- a graph-native diagnostic object reference;
- a related graph-object reference;
- a related expression, statement, endpoint, relator, result schema, graph-delta, or materialization-result reference;
- profile or source of the diagnostic.

Not every diagnostic entry must include every field.

A status-only diagnostic response MAY contain only a status-only graph response if the negotiated schema allows it.

---

## 5. Diagnostic Severity

Fish MAY define protocol-level diagnostic severities.

Possible diagnostic severities include:

- `fish:proto:info`;
- `fish:proto:warning`;
- `fish:proto:error`;
- `fish:proto:fatal`;
- profile-defined severity.

Diagnostic severity is a protocol projection of graph-native diagnostic status or diagnostic metadata.

C4 Core does not require a standard diagnostic severity lattice.

Profiles MAY define additional severities or map graph-native diagnostic structures to Fish severity labels.

---

## 6. Diagnostic Codes and Enums

Fish diagnostic codes/enums are protocol identifiers for graph-native diagnostic statuses or diagnostic objects.

A diagnostic code/enum MAY be:

- a Fish protocol status enum;
- a profile-defined diagnostic code;
- a symbolic diagnostic name;
- a graph-object reference;
- a profile-defined code object.

Diagnostic codes/enums MUST NOT replace graph-native diagnostic structure when the negotiated schema requires diagnostic graph objects.

---

## 7. Diagnostic References

Diagnostic entries SHOULD refer to graph-native structures whenever possible.

A diagnostic reference MAY identify:

- a graph-object;
- a statement graph-object;
- a block graph-object;
- a relator graph-object;
- an endpoint-consumption policy object;
- a graph-delta object;
- a materialization-result graph-object;
- a result-schema graph-object;
- a Fish request object;
- a profile-defined object.

String locations, line/column locations, byte offsets, source spans, and path-like locations MAY be included by Fish syntax profiles, but they SHOULD be understood as protocol/source projections of graph-native references when possible.

---

## 8. Diagnostic Envelope Schemas

Diagnostic envelope schemas are result schemas.

A client may request diagnostic output by negotiating a result schema such as:

- `fish:proto:diagnostic_status_only`;
- `fish:proto:diagnostic_summary`;
- `fish:proto:diagnostic_list`;
- `fish:proto:diagnostic_graph`;
- `fish:proto:diagnostic_envelope`;
- profile-defined diagnostic schema.

A diagnostic graph schema returns or projects graph-native diagnostic structure.

A diagnostic summary schema MAY return only compressed summaries, codes, enums, or counts.

Fish SHOULD only return the diagnostic detail level requested by the client or required by the active profile.

---

## 9. Unsupported or Malformed Diagnostic Schemas

If a requested diagnostic schema is unsupported, Fish MUST NOT materialize or project diagnostics using that schema.

Instead, Fish SHOULD return `UNSUPPORTED_RESULT_SCHEMA` or another profile-defined unsupported diagnostic schema status.

If a requested diagnostic schema is malformed, Fish MUST NOT materialize or project diagnostics using that schema.

Instead, Fish SHOULD return `MALFORMED_RESULT_SCHEMA` or another profile-defined malformed diagnostic schema status.

Unsupported-schema and malformed-schema conditions SHOULD map to graph-native status objects and Fish protocol status enums.

---

## 10. Safety and Disclosure

Diagnostics may reveal internal graph structure, profile configuration, implementation details, or sensitive source references.

Fish profiles MAY define diagnostic disclosure policies.

A disclosure policy MAY restrict:

- diagnostic detail level;
- graph-object references;
- source spans;
- profile names;
- implementation names;
- materializer details;
- internal failure traces;
- private graph regions;
- profile-defined sensitive data.

If diagnostic details are withheld, Fish SHOULD return a status or diagnostic marker indicating that diagnostics were omitted, redacted, unavailable, or not authorized when the negotiated schema supports such indication.

Relevant status enums include:

- `DIAGNOSTICS_WITHHELD`;
- `DIAGNOSTICS_UNAVAILABLE`;
- `PERMISSION_DENIED`.

---

## 11. Interaction with Status-Only Responses

A status-only response is not a diagnostic envelope unless a profile defines it as one.

A status-only response MAY indicate diagnostic availability through protocol status enums such as:

```fish
<request-fish>&fish:proto:status@fish:proto:(VALIDATION_FAILED,DIAGNOSTICS_AVAILABLE);
```

but it does not include diagnostic entries by default.

If a client requests diagnostics and the materializer or validator cannot provide them, Fish SHOULD return an appropriate status enum rather than silently returning an empty diagnostic envelope unless the negotiated schema explicitly permits empty diagnostic envelopes.

---

## 12. Open Questions

The following remain open for future formalization:

- concrete Fish syntax for diagnostic envelopes;
- exact standard diagnostic envelope schemas;
- exact standard diagnostic severity names;
- exact Fish status enum mappings for unsupported diagnostic schema, malformed diagnostic schema, diagnostics withheld, and diagnostics unavailable;
- whether diagnostic entries should always include graph-object references when available;
- whether diagnostic summaries should include counts by severity;
- how diagnostic envelopes interact with streaming responses;
- how diagnostic disclosure policies are represented as graph objects;
- whether diagnostic envelope schemas should be machine-readable Fish graph documents.
