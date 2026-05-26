# Fish Profile Negotiation Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines initial graph-native syntax for requesting, accepting, selecting, and reporting active Fish/C4 profiles.

Profile negotiation does not replace C4 graph-native semantics.

Protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

---

## 1. Purpose

Fish profiles define protocol and projection behavior that is intentionally not fixed by C4 Core.

A Fish profile may define:

- supported result schemas;
- compatible schema traits;
- graph-delta marking projection behavior;
- materialization-result projection behavior;
- request/response envelope requirements;
- Fish address canonicalization rules;
- `fish:addr:(...)` canonical byte serialization;
- varint encoding rules;
- status-word layout;
- compact status projection rules;
- diagnostic disclosure policy;
- materialization policy;
- authentication/capability requirements;
- transport constraints;
- profile-defined vocabulary.

A request fish may therefore need to state which profile it requests or which profiles it can accept.

---

## 2. Profile References

A profile reference SHOULD be a graph-addressable resource.

Possible profile references include:

```fish
fish:proto:<profile-name>
profile:<profile-name>
fish:id:<FishID128>
fish:addr:("agent","domain",A,A,F)
```

Standard Fish protocol profiles, if defined, SHOULD use `fish:proto:<profile-name>`.

External or implementation-defined profiles SHOULD use their own namespace or graph address.

Profile names SHOULD use snake_case when symbolic.

---

## 3. Requested Profile

A request fish MAY request a specific active profile using:

```fish
<request-fish>&fish:proto:profile@<profile>;
```

Example:

```fish
fish:id:REQ&fish:proto:profile@fish:proto:default_profile;
```

A requested profile is a request for the implementation to process the request under that profile.

If the requested profile is unsupported, unauthorized, malformed, or incompatible with the requested operation, Fish MUST NOT perform mutating materialization.

---

## 4. Acceptable Profiles

A request fish MAY list acceptable profiles using:

```fish
<request-fish>&fish:proto:accept_profile@fish:proto:(<profile-1>,<profile-2>,...);
```

Example:

```fish
fish:id:REQ&fish:proto:accept_profile@fish:proto:(default_profile,strict_profile);
```

The list is graph structure.

The order SHOULD be interpreted as preference order unless the active transport/profile negotiation context defines otherwise.

If no acceptable profile can be selected, Fish SHOULD return an appropriate profile-negotiation failure status and MUST NOT perform mutating materialization.

---

## 5. Active Profile Reporting

A Fish response SHOULD report the active profile when:

- the request offered multiple acceptable profiles;
- the active profile affects result-schema interpretation;
- composed schema traits are used;
- status-word projections are used;
- hash-derived IDs depend on profile-defined canonicalization;
- diagnostics or materialization policy depends on the profile;
- the negotiated result schema requests profile metadata.

Recommended response relation:

```fish
<request-fish>&fish:proto:active_profile@<profile>;
```

Example:

```fish
fish:id:REQ&fish:proto:active_profile@fish:proto:default_profile;
```

If the requested result schema is strict status-only, active profile reporting MAY be omitted unless required by the profile or transport.

---

## 6. Profile and Result-Schema Compatibility

Profiles determine which result schemas and schema traits are supported.

A profile SHOULD define support and compatibility for schemas such as:

```fish
fish:proto:status_only
fish:proto:diagnostic_graph
fish:proto:graph_delta_graph
fish:proto:graph_delta_summary
fish:proto:materialization_result_graph
fish:proto:materialization_result_summary
fish:proto:protocol_envelope
```

and traits such as:

```fish
fish:proto:region_root_marking
fish:proto:direct_marking
```

A composed request such as:

```fish
fish:id:REQ&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking,direct_marking);
```

MUST be validated under the selected profile before any mutating materialization occurs.

---

## 7. Profile Capability Graphs

A profile MAY expose a capability graph describing supported schemas, traits, operations, policies, and encodings.

Possible profile capability relations include:

```fish
<profile>&fish:proto:supports_schema@fish:proto:graph_delta_graph;
<profile>&fish:proto:supports_trait@fish:proto:region_root_marking;
<profile>&fish:proto:supports_trait@fish:proto:direct_marking;
<profile>&fish:proto:supports_operation@fish:proto:materialize;
<profile>&fish:proto:supports_policy@fish:proto:read_only;
```

Trait compatibility may be represented by profile-defined capability graph structure.

Example abstract compatibility relation:

```fish
<profile>&fish:proto:compatible_traits@fish:proto:(graph_delta_graph,region_root_marking,direct_marking);
```

The exact machine-readable capability graph grammar is deferred to a future Fish profile/capability registry draft.

---

## 8. Address Canonicalization Profile

Hash-derived Fish IDs depend on canonicalization.

A profile that supports deterministic hash-derived IDs from `fish:addr:(...)` MUST define:

- canonical byte form for `agent_string`;
- canonical byte form for `domain_string`;
- quoted-string normalization;
- canonical varint byte layout;
- field order;
- field separator or length-prefixing;
- domain-separation prefix;
- hash function;
- truncation length;
- Base64URL projection rules.

If a request requires deterministic ID interoperability and no shared canonicalization profile is selected, Fish SHOULD return a profile-negotiation or canonicalization failure status rather than pretending the IDs are interoperable.

---

## 9. Status-Word Layout Profile

Base64 status-word shorthand depends on a status-word layout.

A profile that supports status-word shorthand MUST define:

- bit ordering;
- field-to-bit mapping;
- integer byte order;
- fixed-width or variable-width encoding;
- Base64URL alphabet and padding rule;
- mapping from status-word fields to named status enums;
- compatibility between status-word layout and named enum projection.

If a client requests status-word shorthand without a mutually supported status-word layout, Fish SHOULD return a status projection using named status enums or a profile-negotiation failure according to the active profile.

---

## 10. Diagnostic Disclosure Profile

A profile MAY define diagnostic disclosure policy.

Diagnostic disclosure policy may constrain:

- whether diagnostics are returned by default;
- which diagnostic schemas are available;
- whether graph-native diagnostic objects may be exposed;
- whether source spans may be exposed;
- whether internal implementation details may be exposed;
- redaction behavior;
- permission requirements for diagnostic detail.

If a requested diagnostic schema is not permitted under the selected profile, Fish SHOULD return `PERMISSION_DENIED`, `DIAGNOSTICS_WITHHELD`, `UNSUPPORTED_RESULT_SCHEMA`, or another profile-defined status.

---

## 11. Materialization Policy Profile

A profile MAY define materialization policy.

Materialization policy may constrain:

- read-only validation;
- graph-delta production;
- non-mutating materialization;
- mutating materialization;
- transaction boundaries;
- rollback requirements;
- permission requirements;
- materializer capabilities;
- which result schemas are allowed for mutating requests.

A request may still include a request-level materialization policy:

```fish
<request-fish>&fish:proto:materialization_policy@fish:proto:read_only;
```

The selected profile determines how that request-level policy is interpreted and whether it is admissible.

---

## 12. Profile Negotiation Failure

If profile negotiation fails, Fish MUST NOT perform mutating materialization.

Profile negotiation may fail because:

- requested profile is unsupported;
- requested profile is malformed;
- requested profile is unauthorized;
- no acceptable profile is available;
- requested operation is unsupported by the selected profile;
- requested result schema is unsupported by the selected profile;
- requested schema traits are incompatible under the selected profile;
- required canonicalization or status-word layout is unavailable;
- diagnostic or materialization policy conflicts with the profile.

Recommended status response examples:

```fish
fish:id:REQ&fish:proto:status@fish:proto:(UNSUPPORTED_PROFILE,MATERIALIZATION_NOT_ATTEMPTED);
```

```fish
fish:id:REQ&fish:proto:status@fish:proto:(PROFILE_NEGOTIATION_FAILED,MATERIALIZATION_NOT_ATTEMPTED);
```

```fish
fish:id:REQ&fish:proto:status@fish:proto:(INCOMPATIBLE_SCHEMA_TRAITS,MATERIALIZATION_NOT_ATTEMPTED);
```

Some of these status enums may be provisional until added to the Fish status enum registry.

---

## 13. Complete Abstract Example

Request:

```fish
fish:id:REQ&fish:proto:accept_profile@fish:proto:(default_profile,strict_profile);
fish:id:REQ&fish:proto:result_schema@fish:proto:(graph_delta_graph,region_root_marking);
fish:id:REQ&fish:proto:materialization_policy@fish:proto:read_only;
```

Response:

```fish
fish:id:REQ&fish:proto:active_profile@fish:proto:default_profile;
fish:id:REQ&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
fish:id:REQ&fish:proto:result@fish:id:DELTA;
fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
```

---

## 14. Open Questions

The following remain open for future formalization:

- exact standard profile names;
- exact status enum registry additions for unsupported profile, malformed profile, profile negotiation failed, and incompatible schema traits;
- whether `fish:proto:profile` or `fish:proto:requested_profile` should be canonical for single-profile requests;
- whether acceptable profiles should be preference-ordered by default;
- exact capability graph grammar;
- exact compatibility graph grammar for schema traits;
- how profile negotiation interacts with transport-level content negotiation;
- whether profile negotiation may itself require a bootstrap profile;
- how profiles are signed, trusted, versioned, and retrieved;
- how profile negotiation interacts with authorization and private profiles.
