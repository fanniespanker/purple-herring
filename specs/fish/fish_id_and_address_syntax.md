# Fish ID and Address Syntax v0.1.0 Draft

## Status

This document is a draft Fish protocol and syntax specification.

It defines canonical Fish opaque identifier tokens, structured Fish address tuples, and deterministic hash-derived Fish IDs.

Fish IDs are intended for request fish addresses, response references, generated graph-object names, transport-level correlation, and profile-defined opaque addressing.

Protocol/control vocabulary uses the `fish:proto:` namespace path. Opaque generated IDs use `fish:id:` and SHOULD NOT be moved under `fish:proto:`.

Protocol relation, schema, operation, marker, and policy names use snake_case. Status enum constants use SCREAMING_SNAKE_CASE.

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

The `fish:id:` prefix distinguishes opaque generated IDs from ordinary names, Fish vocabulary resources, status enums, profile names, structured addresses, and future path syntax.

The raw 22-character token is the encoded ID payload. The prefixed form is the canonical opaque Fish ID address expression.

`fish:id:<FishID128>` is opaque to consumers. Its generation method may be random, deterministic, hash-derived, or profile-defined unless the active profile states otherwise.

---

## 3. Structured Fish Address Form

A structured Fish address is a graph-addressable provenance/correlation tuple.

Canonical abstract form:

```fish
fish:addr:(<agent_string>,<domain_string>,<session_id>,<school_sequence>,<fish_sequence>)
```

Example:

```fish
fish:addr:("natalie","purple-herring.fanniespanker.com",A,A,F)
```

Fields:

```text
agent_string      quoted canonical UTF-8 string for the agent/system minting the address
domain_string     quoted canonical UTF-8 string for the authority/scope/domain
session_id        session-local sequence or identifier
school_sequence   school/graph sequence within the session or domain
fish_sequence     fish/request/object sequence within the school/session
```

`agent_string` and `domain_string` are quoted strings in the canonical surface form.

This avoids prematurely forcing agents/domains to be Fish graph paths, avoids namespace ambiguity, and allows DNS-style domains to be written naturally.

`fish:addr:(...)` is structured and may disclose provenance, ordering, session, or domain information.

`fish:id:<FishID128>` is opaque and compact.

Structured Fish addresses are useful for protocol traces, deterministic local addressing, debugging, replay, and auditability.

Opaque Fish IDs are useful for compact references, public export, privacy-preserving references, and global portability.

---

## 4. Agent and Domain String Canonicalization

`agent_string` and `domain_string` are case-sensitive after canonicalization.

Profiles MAY define aliases, display labels, or case-folding lookup behavior, but such behavior MUST occur before canonical address serialization.

Canonical address bytes MUST be strict and deterministic.

Recommended conventions:

```text
agent_string:  lowercase snake_case for human-authored agent names
domain_string: lowercase DNS-style domain name when DNS-based
```

DNS-style domain strings SHOULD be written in normal DNS order:

```text
sub.domain.tld
```

not reverse-DNS order:

```text
tld.domain.sub
```

Examples:

```fish
fish:addr:("natalie","purple-herring.fanniespanker.com",A,A,F)
fish:addr:("sardine","repo.purple-herring.fanniespanker.com",A,B,C)
```

The following are distinct unless a profile canonicalizes them before serialization:

```fish
fish:addr:("Natalie","purple-herring.fanniespanker.com",A,A,F)
fish:addr:("natalie","purple-herring.fanniespanker.com",A,A,F)
```

---

## 5. Base64URL Varints for Structured Address Numeric Fields

`session_id`, `school_sequence`, and `fish_sequence` SHOULD be encoded as canonical variable-length unsigned integers projected as unpadded Base64URL tokens, unless the active profile defines another canonical integer form.

Canonical requirements:

```text
integer domain: non-negative integers
encoding: profile-defined canonical unsigned varint bytes
surface projection: unpadded Base64URL
padding: prohibited
leading zero / non-minimal forms: prohibited
```

The exact varint byte layout is deferred to a future Fish integer/varint specification.

A profile defining `fish:addr` interoperability MUST specify the varint byte layout before deterministic hash-derived IDs can be interoperable across implementations.

---

## 6. Hash-Derived Fish IDs

A `fish:id:<FishID128>` MAY be derived deterministically from a canonical structured Fish address.

Recommended derivation:

```text
FishID128 = base64url(first_128_bits(SHA-256("fish:id:v1\0" || canonical_fish_addr_bytes)))
```

Then:

```fish
fish:id:<FishID128>
```

is the opaque public/protocol address corresponding to the structured address.

The string `"fish:id:v1\0"` is a domain-separation prefix. Future derivation profiles MUST use distinct domain-separation prefixes.

The hash input MUST use canonical bytes, not arbitrary source text.

Canonicalization MUST define:

- canonical byte form for `agent_string`;
- canonical byte form for `domain_string`;
- canonical varint byte form for `session_id`;
- canonical varint byte form for `school_sequence`;
- canonical varint byte form for `fish_sequence`;
- field order;
- field separators or length-prefixing;
- version/domain-separation prefix;
- Unicode normalization for quoted strings.

Without a shared canonicalization profile, hash-derived IDs are implementation-local and MUST NOT be assumed interoperable.

---

## 7. Random and Deterministic IDs

`fish:id:<FishID128>` may be generated by different strategies.

Allowed strategies include:

- cryptographically random 128-bit generation;
- deterministic hash-derived generation from `fish:addr:(...)`;
- profile-defined deterministic generation;
- UUID-compatible generation;
- implementation-defined generation when interoperability is not required.

Consumers SHOULD treat all `fish:id:<FishID128>` addresses as opaque regardless of generation method.

A producer MAY disclose the structured address used to derive an opaque ID, but is not required to do so.

---

## 8. Optional Disclosure of Canonical Structured Address

If a Fish response discloses the structured address associated with an opaque ID, it SHOULD do so with a protocol relation such as:

```fish
fish:id:<FishID128>&fish:proto:canonical_addr@fish:addr:(<agent_string>,<domain_string>,<session_id>,<school_sequence>,<fish_sequence>);
```

Example abstract form:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:canonical_addr@fish:addr:("natalie","purple-herring.fanniespanker.com",A,A,F);
```

Disclosure is optional because structured addresses may reveal agent, domain, session, ordering, or other sensitive trace information.

A profile MAY prohibit, require, redact, or transform canonical address disclosure.

---

## 9. Prefix Rationale

Fish reserves separate namespace/path forms for generated IDs, structured addresses, and protocol/control vocabulary:

```text
fish:id:<FishID128>        opaque generated Fish ID/address
fish:addr:(...)            structured Fish address tuple
fish:proto:<name>          Fish protocol/control vocabulary
fish:proto:(...)           protocol-relative list graph
fish:<name>                general Fish vocabulary resource
```

Opaque generated IDs therefore use:

```fish
fish:id:<FishID128>
```

rather than:

```fish
fish:<FishID128>
```

or:

```fish
fish:proto:id:<FishID128>
```

Structured addresses use:

```fish
fish:addr:(...)
```

rather than overloading `fish:id:`.

This preserves `fish:<name>` for named Fish vocabulary resources, preserves `fish:proto:<name>` for protocol/control vocabulary, distinguishes opaque IDs from structured addresses, and avoids collisions between generated IDs and symbolic names.

---

## 10. Request Fish Addresses

A request fish SHOULD be addressable by a Fish address.

A request fish MAY use either:

```fish
fish:id:<FishID128>
```

or:

```fish
fish:addr:(<agent_string>,<domain_string>,<session_id>,<school_sequence>,<fish_sequence>)
```

The preferred public/protocol form is usually `fish:id:<FishID128>`.

The structured address form is useful when provenance, order, session, or deterministic reconstruction should be visible.

Example request fish address:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA
```

A status-only response may refer to the request fish by that address:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(OK);
```

---

## 11. Response References

Fish responses SHOULD refer to the request fish they answer when the response is graph-structured.

Canonical status-only response form:

```fish
<request-fish-address>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

The request fish address provides response correlation without requiring a non-graph protocol envelope field.

---

## 12. UUID Compatibility

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

Hash-derived FishID128:
  FishID128 deterministically derived from canonical structured Fish address bytes
```

---

## 13. Base64URL Canonicalization

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

## 14. Generation Requirements

A Fish implementation generating random FishID128 values SHOULD use cryptographically strong random generation or another profile-approved uniqueness mechanism.

A Fish implementation generating deterministic hash-derived FishID128 values MUST use a profile-defined canonicalization and hash derivation rule.

FishID128 values are opaque. Clients SHOULD NOT infer meaning, time, sequence, authorization, profile, type, graph location, or derivation method from the token unless a profile explicitly defines such semantics.

If deterministic IDs are used, the active profile MUST define collision resistance, scope, and canonicalization requirements.

---

## 15. Scope and Collision

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

Hash-derived FishID128 values are collision-resistant only up to the strength of the chosen hash, truncation length, canonicalization, and domain-separation profile.

---

## 16. Relationship to Fish Names

`fish:id:<FishID128>` is an opaque generated address form.

`fish:addr:(...)` is a structured address tuple.

Both are distinct from named Fish protocol resources such as:

```fish
fish:proto:status
fish:proto:OK
fish:proto:PERMISSION_DENIED
```

and from general Fish vocabulary resources such as:

```fish
fish:<name>
```

Named resources may have stable symbolic semantics.

Opaque ID addresses have no intrinsic semantics beyond reference/addressing under the active profile.

Structured addresses have explicit field semantics but still do not define primitive C4 identity.

---

## 17. Relationship to C4 Graph Objects

A Fish ID address or structured Fish address may refer to a C4 graph-object, a request fish, a response fish, a materialization-result graph-object, a graph-delta object, a diagnostic object, or a profile-defined graph object.

The address form is a Fish protocol/syntax projection.

It does not define primitive C4 identity.

C4 does not assume primitive identity. Fish addresses provide addressability/correlation, not metaphysical identity.

---

## 18. Open Questions

The following remain open for future formalization:

- exact grammar production for `fish:id:<FishID128>`;
- exact grammar production for `fish:addr:(...)`;
- exact canonical varint byte layout for structured address numeric fields;
- exact canonical quoted-string normalization for `agent_string` and `domain_string`;
- whether other ID lengths such as FishID64 or FishID256 should be standardized;
- whether UUID version/variant bits should be required for default generated FishID128 values;
- whether request fish addresses should always prefer FishID128 over structured addresses in public responses;
- how Fish IDs interact with graph/container paths;
- how Fish IDs are represented in machine-readable Fish graph data;
- whether `fish:id:` may be abbreviated under local profile contexts;
- whether deterministic content-addressed graph IDs should use a distinct prefix from structured-address-derived IDs;
- whether canonical address disclosure should use `fish:proto:canonical_addr` or another relation name.
