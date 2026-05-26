# Fish Namespace Conventions v0.1.0 Draft

## Status

This document is a draft Fish syntax and protocol specification.

It defines the initial namespace/path conventions for Fish protocol, identifier, and vocabulary resources.

Fish namespace conventions are surface/protocol conventions. They do not replace C4 graph-native semantics.

---

## 1. Core Namespace Forms

Fish reserves the following initial namespace/path forms:

```text
fish:id:<FishID128>        opaque generated Fish address
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

`fish:id:<FishID128>` provides addressability and correlation. It does not define primitive C4 identity.

---

## 3. Protocol / Control Vocabulary

Fish protocol/control vocabulary uses:

```fish
fish:proto:<name>
```

Examples:

```fish
fish:proto:status
fish:proto:operation
fish:proto:payload
fish:proto:resultSchema
fish:proto:diagnosticSchema
fish:proto:materializationPolicy
fish:proto:statusWord64
fish:proto:compatCode
```

Protocol/control vocabulary includes relations, markers, schema names, operation names, status enum names, and other protocol-facing objects.

---

## 4. Protocol-Relative Lists

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

## 5. Status Response Convention

Canonical status-only responses use:

```fish
<request-fish>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

Example:

```fish
fish:id:VQ6EAOKbQdSnFkRmVUQAAA&fish:proto:status@fish:proto:(GRAPH_DELTA_PRODUCED,MATERIALIZED_NO_MUTATION);
```

---

## 6. General Fish Vocabulary

The form:

```fish
fish:<name>
```

is reserved for general named Fish vocabulary resources.

Examples may include future standard library resources, graph vocabulary, schema vocabulary, or other non-protocol Fish resources.

Protocol/control vocabulary SHOULD use `fish:proto:<name>` rather than `fish:<name>`.

---

## 7. Rationale

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

---

## 8. Open Questions

The following remain open for future formalization:

- exact grammar for namespace/path expressions;
- whether `fish:proto:` should be considered a namespace, path prefix, profile root, or all of these;
- whether other reserved roots such as `fish:schema:`, `fish:profile:`, or `fish:status:` should be standardized;
- whether protocol-relative lists should generalize to other namespace-relative lists;
- how namespace conventions interact with C4/Purple Herring resource traversal syntax;
- whether compact aliases for `fish:proto:` should be allowed in local profile contexts.
