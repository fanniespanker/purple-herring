# Fish Status-Only Response Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol syntax specification.

Fish status-only responses are the default minimal response form for Fish protocol exchanges when no richer result schema is requested or required.

A status-only response is a protocol projection of graph-native C4 status structure.

A Fish response is itself graph-structured. Status-only means that the returned graph contains only the requested status relation/subgraph, not that the response is a non-graph scalar token.

---

## 1. Relationship to Fish Status Model

The Fish status model is:

```text
graph-native status object
  -> structured status word / status bit-vector
  -> named status enum
  -> optional numeric/textual protocol projection
```

A status-only response returns a compact graph projection of that status.

The canonical Fish status-only response SHOULD be a Fish graph statement relating the request fish to a status list.

Numeric HTTP-like compatibility codes are not canonical Fish status semantics and SHOULD NOT be returned unless explicitly requested by a negotiated result schema or active profile.

---

## 2. Default Graph-Native Status-Only Body

The default status-only response body is a graph containing a status relation from the request fish to a list of one or more status enum graph-objects.

Abstract form:

```fish
<request-fish>&fish:status@fish:(<status-enum-1>,<status-enum-2>,...);
```

The target list is graph structure. Lists in Fish/C4 are graph-native structures, not scalar tuples.

For a single status, the canonical graph-native status-only response SHOULD still use a list:

```fish
REQUEST&fish:status@fish:(OK);
```

For multiple statuses:

```fish
REQUEST&fish:status@fish:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

A status-only response SHOULD NOT include diagnostics, materialization-result projections, graph-delta projections, patch projections, protocol envelope metadata, or compatibility codes unless explicitly requested or required by profile.

---

## 3. Better Status-Only Examples

Successful graph-delta production without materialization:

```fish
REQUEST&fish:status@fish:(GRAPH_DELTA_PRODUCED,MATERIALIZATION_NOT_ATTEMPTED);
```

Successful read-only materialization:

```fish
REQUEST&fish:status@fish:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

Successful mutating materialization:

```fish
REQUEST&fish:status@fish:(GRAPH_DELTA_PRODUCED,MATERIALIZED_MUTATION_APPLIED);
```

Malformed result schema, no materialization:

```fish
REQUEST&fish:status@fish:(MALFORMED_RESULT_SCHEMA,MATERIALIZATION_NOT_ATTEMPTED);
```

Unsupported result schema, no materialization:

```fish
REQUEST&fish:status@fish:(UNSUPPORTED_RESULT_SCHEMA,MATERIALIZATION_NOT_ATTEMPTED);
```

Permission failure, no materialization:

```fish
REQUEST&fish:status@fish:(PERMISSION_DENIED,MATERIALIZATION_NOT_ATTEMPTED);
```

Graph-delta production failed, materialization not attempted, diagnostics unavailable:

```fish
REQUEST&fish:status@fish:(GRAPH_DELTA_PRODUCTION_FAILED,MATERIALIZATION_NOT_ATTEMPTED,DIAGNOSTICS_UNAVAILABLE);
```

---

## 4. Request Fish Address

`<request-fish>` is the graph address, name, or reference of the request fish to which the response applies.

In examples this document uses:

```fish
REQUEST
```

as a placeholder.

A concrete Fish transport profile SHOULD define how request fish addresses are minted, referenced, scoped, and serialized.

---

## 5. Status List Semantics

The target of `fish:status` is a list graph.

The list MAY contain one or more named Fish status enum graph-objects.

The order of the list MAY be significant when interpreted as a status trace or stage summary.

A profile SHOULD define whether the status list is interpreted as:

- ordered status trace;
- unordered status set;
- prioritized status list;
- profile-defined status collection.

The default recommendation is ordered status trace, because Fish processing stages are directional and may be safety-relevant.

---

## 6. Bare Enum Shorthand

A Fish profile MAY define a bare enum shorthand:

```fish
PERMISSION_DENIED
```

This shorthand is not the canonical graph-native response form.

The bare enum shorthand is a compact transport projection equivalent to a graph-native status response whose request fish is implicit in the active transport context.

For example:

```fish
PERMISSION_DENIED
```

may project:

```fish
REQUEST&fish:status@fish:(PERMISSION_DENIED);
```

Bare enum shorthand SHOULD only be used in contexts where the request fish is unambiguous.

---

## 7. Base64 Status-Word Shorthand

A Fish profile MAY define a base64 status-word shorthand.

In this shorthand, status-word boolean/bit fields are packed into a single integer status word, then encoded using a base64 representation.

Abstract pipeline:

```text
status flags / bits
  -> unsigned integer status word
  -> base64 status token
```

The base64 status token is a compact transport projection. It is not the canonical graph-native status semantics.

A base64 status-word shorthand MUST be interpretable only under a known Fish status-word layout, Fish protocol version, and active profile.

A profile defining base64 status-word shorthand MUST specify:

- bit ordering;
- field-to-bit mapping;
- integer byte order;
- whether unused bits are permitted;
- whether the encoded integer is fixed-width or variable-width;
- which base64 alphabet is used;
- whether padding is required, optional, or prohibited;
- how the shorthand maps back to graph-native status objects and named enums.

Example abstract form:

```fish
REQUEST&fish:statusWord64@fish:<base64-status-token>;
```

A status-word shorthand MAY be returned instead of the status-list form only when explicitly requested by a result schema or required by the active Fish profile.

---

## 8. Optional Keyed Form

A Fish profile MAY define a keyed status-only form:

```fish
status:PERMISSION_DENIED
```

or equivalent profile-defined syntax.

The keyed form is a transport projection, not the canonical graph-native response form.

The keyed form may be useful in transports or embeddings where a bare enum token is ambiguous but full graph syntax is not desired.

---

## 9. Optional Compatibility-Code Projection

A Fish profile MAY define a status-only-with-compatibility projection when explicitly requested.

Example:

```fish
REQUEST&fish:status@fish:(PERMISSION_DENIED);
REQUEST&fish:compatCode@fish:403;
```

This is not the default status-only response.

A compatibility code is an optional projection of the named status enum. It is not canonical Fish status semantics.

If a client requests strict status-only graph form, Fish SHOULD return only the `fish:status` relation unless the active profile requires another form.

---

## 10. Optional Status-Word Expansion

A Fish profile MAY define a status-word expansion when explicitly requested.

Example abstract graph form:

```fish
REQUEST&fish:status@fish:(PERMISSION_DENIED,MATERIALIZATION_NOT_ATTEMPTED);
REQUEST&fish:statusFlag@fish:request_wellformed;
REQUEST&fish:statusFlag@fish:auth_accepted;
REQUEST&fish:statusFlag@fish:permission_denied;
REQUEST&fish:statusFlag@fish:materialization_not_attempted;
REQUEST&fish:statusFlag@fish:final;
```

This is not the default status-only response.

A status-word expansion is a richer response than a status list, even if it contains no graph-delta or materialization-result payload.

---

## 11. Status-Only Response and Result-Schema Negotiation

If no result schema is requested, Fish SHOULD return the default graph-native status-only response.

If a result schema explicitly requests a status-only response, Fish SHOULD return the default graph-native status-only response unless the requested schema specifies a bare enum shorthand, keyed form, compatibility-code form, status-word expansion, base64 status-word shorthand, or profile-defined status projection.

If a richer result schema is requested and accepted, Fish MAY return graph-delta projections, materialization-result projections, diagnostic envelopes, protocol envelopes, or other requested content according to that schema.

Unsupported or malformed result schemas MUST NOT trigger mutating materialization.

---

## 12. Status-Only Response and Diagnostics

A status-only response does not include diagnostic detail by default.

It MAY include diagnostic availability statuses, such as:

```fish
REQUEST&fish:status@fish:(VALIDATION_FAILED,DIAGNOSTICS_AVAILABLE);
```

or:

```fish
REQUEST&fish:status@fish:(VALIDATION_FAILED,DIAGNOSTICS_WITHHELD);
```

But the diagnostic graph or diagnostic envelope itself is not included unless requested or required.

---

## 13. Status-Only Response and Graph-Native Semantics

A status-only response is a compact Fish graph projection.

It MUST NOT be interpreted as proving that no underlying graph-native result exists.

For example, a response body:

```fish
REQUEST&fish:status@fish:(MATERIALIZED_MUTATION_APPLIED);
```

may project a materialization-result graph-object:

$$
\xi_\mu\in\Xi_\mu
$$

whose graph structure is not included in the response because the client did not request it.

Omission from a status-only response is not semantic absence from the underlying C4 graph.

---

## 14. Open Questions

The following remain open for future formalization:

- exact lexical grammar for status enum tokens;
- whether status enum tokens should be namespace-qualified in canonical syntax;
- exact syntax for request fish addresses;
- whether `fish:status` target lists are always ordered traces or profile-defined collections;
- whether bare enum token responses are allowed in canonical Fish or only compact transport profiles;
- exact base64 alphabet and padding rules for status-word shorthand;
- exact mandatory status-word bit layout, if any;
- how status-only responses are embedded in streaming, batch, or multiplexed Fish transports;
- whether compatibility codes should be requested through result-schema negotiation or transport-level negotiation;
- whether status-only responses should include protocol version when used outside an established Fish session.
