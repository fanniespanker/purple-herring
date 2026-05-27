# Fish Operation Status Enum Addendum v0.1.0 Draft

## Status

This document is a draft addendum to the Fish Status Enum Registry.

It records operation, profile, and schema-trait negotiation status enums referenced by the Fish Operation Registry.

These entries should eventually be consolidated into `fish_status_enum_registry.md`.

---

## 1. Operation Statuses

Initial operation status enums:

```text
UNSUPPORTED_OPERATION
MALFORMED_OPERATION
OPERATION_NOT_SPECIFIED
OPERATION_NOT_PERMITTED
```

---

## 2. Profile Negotiation Statuses

Initial profile negotiation status enums:

```text
UNSUPPORTED_PROFILE
MALFORMED_PROFILE
PROFILE_NEGOTIATION_FAILED
```

---

## 3. Schema Trait Statuses

Initial schema-trait status enums:

```text
INCOMPATIBLE_SCHEMA_TRAITS
```

---

## 4. Safety Note

These statuses are preflight or negotiation statuses.

They indicate that the requested operation should not proceed as a successful graph-delta or materialization result.

They are subject to the Fish error result boundary.
