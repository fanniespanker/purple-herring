# Fish Namespace Conventions v0.1.0 Draft

## Status

This document is a draft Fish syntax and protocol specification.

It defines the initial namespace/path conventions for Fish protocol, identifier, address, and vocabulary resources.

Fish namespace conventions are surface/protocol conventions. They do not replace C4 graph-native semantics.

---

## 1. Core Namespace Forms

Fish reserves the following initial namespace/path forms:

```text
fish:id:<FishID128>        opaque generated Fish ID/address
fish:addr:(...)            structured Fish address tuple
fish:proto:<name>          Fish protocol/control vocabulary
fish:proto:(...)           protocol-relative list graph
fish:<name>                general Fish vocabulary resource
```

---

## 2. Opaque ID Addresses

Opaque generated Fish addresses use:

```fish
fish:id:<FishID128>
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA
```

`fish:id:<FishID128>` provides compact addressability and correlation. It does not define primitive C4 identity.

A `fish:id:<FishID128>` value MAY be random, UUID-compatible, deterministic, hash-derived from a canonical `fish:addr:(...)`, or profile-defined. Consumers SHOULD treat it as opaque unless the active profile states otherwise.

---

## 3. Structured Fish Addresses

Structured Fish addresses use:

```fish
fish:addr:(<agent_string>,<domain_string>,<session_id>,<school_sequence>,<fish_sequence>)
```

Example:

```fish
fish:addr:("natalie","purple-herring.fanniespanker.com",A,A,F)
```

`agent_string` and `domain_string` are quoted canonical UTF-8 strings.

`session_id`, `school_sequence`, and `fish_sequence` are canonical variable-length unsigned integer projections, normally represented as unpadded Base64URL tokens under a profile-defined varint layout.

Structured addresses may disclose provenance, ordering, session, or domain information. They are useful for protocol traces, deterministic local addressing, debugging, replay, and auditability.

Opaque IDs are usually preferred for compact public/protocol references.

---

## 4. Protocol / Control Vocabulary

Fish protocol/control vocabulary uses:

```fish
fish:proto:<name>
```

Protocol/control relation, schema, marker, operation, and policy names SHOULD use snake_case.

Status enum constants SHOULD use SCREAMING_SNAKE_CASE.

Examples:

```fish
fish:proto:status
fish:proto:operation
fish:proto:payload
fish:proto:result_schema
fish:proto:diagnostic_schema
fish:proto:materialization_policy
fish:proto:status_word_64
fish:proto:compat_code
fish:proto:result_type
fish:proto:canonical_addr
fish:proto:GRAPH_DELTA_PRODUCED
```

Protocol/control vocabulary includes relations, markers, schema names, operation names, status enum names, and other protocol-facing objects.

---

## 5. Protocol-Relative Lists

A protocol-relative list uses:

```fish
fish:proto:(...)
```

The members of the list are resolved relative to `fish:proto:`.

Example:

```fish
fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION)
```

is a list graph whose members are interpreted as:

```text
fish:proto:GRAPH_DELTA_PRODUCED
fish:proto:MATERIALIZED_NO_MUTATION
```

Protocol-relative lists are graph structure, not scalar tuples.

---

## 6. Status Response Convention

Canonical status-only responses use:

```fish
<request-fish>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

---

## 7. Generic Result Convention

Fish response graphs SHOULD use a single generic result relation from request fish to returned result graph roots:

```fish
<request-fish>&fish:proto:result@<result-root>;
```

Result-specific typing SHOULD be expressed inside the result graph, preferably on the result root:

```fish
<result-root>&fish:proto:result_type@fish:proto:<result-schema-name>;
```

Example:

```fish
fish:id:REQ&fish:proto:result@fish:id:DELTA;
fish:id:DELTA&fish:proto:result_type@fish:proto:graph_delta_graph;
```

---

## 8. General Fish Vocabulary

The form:

```fish
fish:<name>
```

is reserved for general named Fish vocabulary resources.

Examples may include future standard library resources, graph vocabulary, schema vocabulary, or other non-protocol Fish resources.

Protocol/control vocabulary SHOULD use `fish:proto:<name>` rather than `fish:<name>`.

---

## 9. Rationale

The `fish:proto:` namespace path avoids collisions between protocol/control relations and ordinary Fish or domain vocabulary.

For example:

```fish
fish:proto:status
```

is a protocol status relation, while a future:

```fish
fish:status
```

could remain available for ordinary Fish vocabulary or profile-defined semantics.

`fish:id:` and `fish:addr:` are separated because opaque IDs and structured addresses have different disclosure, privacy, and canonicalization properties.

---

## 10. Open Questions

The following remain open for future formalization:

- exact grammar for namespace/path expressions;
- exact grammar for `fish:addr:(...)`;
- whether `fish:proto:` should be considered a namespace, path prefix, profile root, or all of these;
- whether other reserved roots such as `fish:schema:`, `fish:profile:`, or `fish:status:` should be standardized;
- whether protocol-relative lists should generalize to other namespace-relative lists;
- how namespace conventions interact with C4/Purple Herring resource traversal syntax;
- whether compact aliases for `fish:proto:` should be allowed in local profile contexts.
