# Fish ID and Address Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines canonical Fish opaque identifier tokens and their preferred prefixed address form.

Fish IDs are intended for request fish addresses, response references, generated graph-object names, transport-level correlation, and profile-defined opaque addressing.

---

## 1. FishID128 Token

A `FishID128` token is a 128-bit opaque identifier encoded as unpadded Base64URL.

Canonical properties:

```text
bit length: 128 bits
byte length: 16 bytes
encoding: Base64URL
padding: prohibited
encoded length: exactly 22 characters
alphabet: A-Z a-z 0-9 - _
```

A `FishID128` token is the canonical compact encoding of a 128-bit identifier payload.

Example token:

```text
VQ6EAOKbQdSnFkRmVUQAAA
```

The token itself is not the preferred standalone source/protocol address form.

---

## 2. Canonical Fish ID Address Form

The canonical Fish address form for an opaque generated ID is:

```fish
fish:id:<FishID128>
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA
```

The `fish:id:` prefix distinguishes opaque generated IDs from ordinary names, Fish vocabulary resources, status enums, profile names, and future path syntax.

The raw 22-character token is the encoded ID payload. The prefixed form is the canonical Fish address expression.

---

## 3. Prefix Rationale

Fish uses the `fish:` namespace prefix for Fish vocabulary resources such as:

```fish
fish:status
fish:resultSchema
fish:diagnostic
fish:OK
```

Opaque generated IDs therefore use the more specific prefix form:

```fish
fish:id:<FishID128>
```

rather than:

```fish
fish:<FishID128>
```

This preserves `fish:<name>` for named Fish vocabulary resources and avoids collisions between generated IDs and symbolic names.

---

## 4. Request Fish Addresses

A request fish SHOULD be addressable by a Fish address.

A generated request fish address SHOULD use the canonical Fish ID address form:

```fish
fish:id:<FishID128>
```

Example request fish address:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA
```

A status-only response may refer to the request fish by that address:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:status@fish:(OK);
```

---

## 5. Response References

Fish responses SHOULD refer to the request fish they answer when the response is graph-structured.

Canonical status-only response form:

```fish
<request-fish-address>&fish:status@fish:(<status-enum-1>,<status-enum-2>,...);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:status@fish:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

The request fish address provides response correlation without requiring a non-graph protocol envelope field.

---

## 6. UUID Compatibility

A `FishID128` token may encode the same 128-bit payload used by a UUID.

A UUID string such as:

```text
550e8400-e29b-41d4-a716-446655440000
```

and a `FishID128` token may represent the same 128-bit value in different surface encodings.

Fish does not require UUID version or variant bits unless a profile explicitly requires UUID-compatible generation.

Recommended terminology:

```text
FishID128:
  canonical Fish encoding of a 128-bit opaque identifier

UUID-compatible FishID128:
  FishID128 whose 128-bit payload also satisfies UUID version/variant requirements
```

---

## 7. Base64URL Canonicalization

FishID128 uses unpadded Base64URL.

Allowed alphabet:

```text
ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
0123456789
-_
```

Padding character `=` is prohibited.

Ordinary Base64 characters `+` and `/` are prohibited.

A decoder MAY accept noncanonical padded or ordinary Base64 forms as implementation-defined input, but canonical Fish serialization MUST emit unpadded Base64URL.

---

## 8. Generation Requirements

A Fish implementation generating FishID128 values SHOULD use cryptographically strong random generation or another profile-approved uniqueness mechanism.

FishID128 values are opaque. Clients SHOULD NOT infer meaning, time, sequence, authorization, profile, type, or graph location from the token unless a profile explicitly defines such semantics.

If deterministic IDs are used, the active profile MUST define collision resistance, scope, and canonicalization requirements.

---

## 9. Scope and Collision

FishID128 tokens are opaque within a scope.

A Fish profile MUST define the scope in which generated IDs are expected to be unique.

Possible scopes include:

- request scope;
- session scope;
- graph scope;
- repository scope;
- materialization transaction scope;
- globally unique scope;
- profile-defined scope.

If an address is intended to be globally portable, its profile SHOULD require globally unique or collision-resistant generation.

---

## 10. Relationship to Fish Names

`fish:id:<FishID128>` is an opaque generated address form.

It is distinct from named Fish vocabulary resources such as:

```fish
fish:status
fish:OK
fish:PERMISSION_DENIED
```

Named resources may have stable symbolic semantics.

Opaque ID addresses have no intrinsic semantics beyond reference/addressing under the active profile.

---

## 11. Relationship to C4 Graph Objects

A Fish ID address may refer to a C4 graph-object, a request fish, a response fish, a materialization-result graph-object, a graph-delta object, a diagnostic object, or a profile-defined graph object.

The address form is a Fish protocol/syntax projection.

It does not define primitive C4 identity.

C4 does not assume primitive identity. Fish ID addresses provide addressability/correlation, not metaphysical identity.

---

## 12. Open Questions

The following remain open for future formalization:

- exact grammar production for `fish:id:<FishID128>`;
- whether other ID lengths such as FishID64 or FishID256 should be standardized;
- whether UUID version/variant bits should be required for default generated FishID128 values;
- whether request fish addresses should always be FishID128 or may also be named graph addresses;
- how Fish IDs interact with graph/container paths;
- how Fish IDs are represented in machine-readable Fish graph data;
- whether `fish:id:` may be abbreviated under local profile contexts;
- whether deterministic content-addressed Fish IDs should use a distinct prefix.
