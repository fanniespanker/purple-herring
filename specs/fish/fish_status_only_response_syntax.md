# Fish Status-Only Response Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol syntax specification.

Fish status-only responses are the default minimal response form for Fish protocol exchanges when no richer result schema is requested or required.

A status-only response is a protocol projection of a graph-native C4 status object.

A status-only response does not replace C4 graph-native semantics.

---

## 1. Relationship to Fish Status Model

The Fish status model is:

```text
graph-native status object
  -> structured status word / status bit-vector
  -> named status enum
  -> optional numeric/textual protocol projection
```

A status-only response returns a compact projection of that status.

By default, the returned projection SHOULD be the named Fish status enum.

Numeric HTTP-like compatibility codes are not canonical Fish status semantics and SHOULD NOT be returned unless explicitly requested by a negotiated result schema or active profile.

---

## 2. Default Status-Only Body

The default status-only response body is the canonical named Fish status enum and nothing else.

Example:

```fish
PERMISSION_DENIED
```

Another example:

```fish
MATERIALIZED_NO_MUTATION
```

Another example:

```fish
UNSUPPORTED_RESULT_SCHEMA
```

Fish SHOULD only return what the client requested.

Therefore, a default status-only response SHOULD NOT include:

- numeric compatibility code;
- diagnostic envelope;
- status-word expansion;
- graph-object reference;
- result-schema metadata;
- materialization-result projection;
- graph-delta projection;
- protocol envelope fields.

Those may be returned only when requested by a richer result schema or required by the active Fish profile.

---

## 3. Abstract Status-Only Form

The abstract status-only response form is:

```text
<status-enum>
```

where `<status-enum>` is a named Fish status enum from the active Fish status enum registry.

The status enum SHOULD correspond to a graph-native status object or status relation under the active Fish/C4 profile.

---

## 4. Canonical Compact Fish Form

The canonical compact Fish status-only form is a single status enum token:

```fish
OK
```

```fish
VALIDATION_FAILED
```

```fish
MALFORMED_RESULT_SCHEMA
```

The token MUST be interpreted under the active Fish protocol version and status enum registry.

A status-only response containing only a status enum has no additional response envelope content.

---

## 5. Optional Keyed Form

A Fish profile MAY define a keyed status-only form:

```fish
status:PERMISSION_DENIED
```

or equivalent profile-defined syntax.

The keyed form is still status-only if it contains only the status projection and no additional payload.

The keyed form may be useful in transports or embeddings where a bare enum token is ambiguous.

The exact keyed syntax is profile-defined until Fish surface syntax is stabilized.

---

## 6. Optional Compatibility-Code Projection

A Fish profile MAY define a status-only-with-compatibility projection when explicitly requested.

Example:

```fish
PERMISSION_DENIED 403
```

or keyed form:

```fish
status:PERMISSION_DENIED
code:403
```

This is not the default status-only response.

A compatibility code is an optional projection of the named status enum. It is not canonical Fish status semantics.

If a client requests strict status-only, Fish SHOULD return only the named status enum unless the active profile requires another form.

---

## 7. Optional Status-Word Projection

A Fish profile MAY define a status-word projection when explicitly requested.

Example abstract form:

```text
status: PERMISSION_DENIED
word: request_wellformed auth_accepted permission_denied materialization_not_attempted final
```

This is not the default status-only response.

A status-word projection is a richer response than a bare status enum, even if it contains no graph-delta or materialization-result payload.

---

## 8. Status-Only Response and Result-Schema Negotiation

If no result schema is requested, Fish SHOULD return the default status-only body.

If a result schema explicitly requests a status-only response, Fish SHOULD return the default status-only body unless the requested schema specifies a keyed form, compatibility-code form, status-word form, or profile-defined status projection.

If a richer result schema is requested and accepted, Fish MAY return graph-delta projections, materialization-result projections, diagnostic envelopes, protocol envelopes, or other requested content according to that schema.

Unsupported or malformed result schemas MUST NOT trigger mutating materialization.

---

## 9. Status-Only Response and Diagnostics

A status-only response does not include diagnostics by default.

If diagnostics are requested, the response is no longer the default status-only body unless the requested diagnostic schema explicitly permits a diagnostic status enum alone.

If diagnostics are unavailable, withheld, or unsupported, Fish SHOULD return an appropriate status enum such as:

```fish
DIAGNOSTICS_UNAVAILABLE
```

or:

```fish
DIAGNOSTICS_WITHHELD
```

according to the active profile.

---

## 10. Status-Only Response and Graph-Native Semantics

A status-only response is a compact Fish protocol projection.

It MUST NOT be interpreted as proving that no underlying graph-native result exists.

For example, a response body:

```fish
MATERIALIZED_MUTATION_APPLIED
```

may project a materialization-result graph-object:

$$
\xi_\mu\in\Xi_\mu
$$

whose graph structure is not included in the response because the client did not request it.

Omission from a status-only response is not semantic absence from the underlying C4 graph.

---

## 11. Open Questions

The following remain open for future formalization:

- whether bare enum token responses are always acceptable or only under compact Fish transport profiles;
- exact lexical grammar for status enum tokens;
- whether status enum tokens should be namespace-qualified in canonical syntax;
- whether keyed `status:<enum>` syntax should become canonical instead of optional;
- how status-only responses are embedded in streaming, batch, or multiplexed Fish transports;
- whether compatibility codes should be requested through result-schema negotiation or transport-level negotiation;
- whether status-only responses should include protocol version when used outside an established Fish session.
