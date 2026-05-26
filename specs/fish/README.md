# Fish Specifications

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

Fish may define:

- surface serialization for C4 graph structures;
- protocol request/response framing;
- Fish ID and address syntax;
- status registries and compatibility status-code projections;
- named status enums and status-word / bit-vector projections;
- negotiated result schemas;
- graph-delta and materialization-result projections;
- diagnostic envelopes;
- profile negotiation;
- transport/interchange conventions;
- package, registry, and module addressing conventions.

C4 Core remains the abstract graph calculus and semantic substrate. Fish may serialize, negotiate, project, transport, or status-code C4 graph-objects, but Fish protocol projections do not replace C4 graph-native semantics.

---

## Current Drafts

### 1. Fish ID and Address Syntax

File: `fish_id_and_address_syntax.md`

Defines `FishID128`, the canonical unpadded Base64URL encoding for 128-bit opaque Fish IDs, and the prefixed address form:

```fish
fish:id:<FishID128>
```

Fish IDs provide addressability and correlation, not primitive C4 identity.

### 2. Fish Status Registry

File: `fish_status_registry.md`

Defines the overall Fish status model.

This document is not merely a numeric status-code registry. It defines the canonical status chain:

```text
graph-native status object
  -> structured status word / status bit-vector
  -> named status enum
  -> optional numeric/textual protocol projection
```

HTTP-like numeric codes are treated as optional compatibility projections, not as canonical Fish semantics.

### 3. Fish Status Enum Registry

File: `fish_status_enum_registry.md`

Defines the initial named Fish status enums, including success, graph-delta production, materialization, authentication, permission, schema negotiation, validation, diagnostics, projection, and conflict/ambiguity statuses.

Each enum entry may define:

- symbolic enum name;
- short meaning;
- provisional status-word fields;
- optional numeric compatibility projection;
- valid contexts;
- materialization safety rule, where relevant.

### 4. Fish Status-Only Response Syntax

File: `fish_status_only_response_syntax.md`

Defines canonical graph-native status-only responses.

Default status-only responses are Fish graph statements, not scalar tokens:

```fish
<request-fish>&fish:status@fish:(<status-enum-1>,<status-enum-2>,...);
```

Bare enum tokens and base64 status-word tokens are compact transport projections, not the canonical graph-native response form.

### 5. Fish Result-Schema Negotiation

File: `fish_result_schema_negotiation.md`

Defines how Fish clients request protocol projections of C4 graph-native results.

Key rule:

> Fish SHOULD return status-only by default and SHOULD only return what the client asked for.

A result schema is graph-defined. It describes what subgraphs to return, how to organize them, and what markings to preserve or apply.

Unsupported or malformed result schemas MUST NOT trigger mutating materialization.

### 6. Fish Diagnostic Envelopes

File: `fish_diagnostic_envelopes.md`

Defines diagnostic envelopes as requested or profile-required protocol projections of graph-native diagnostic structures.

Diagnostics are not automatic. If diagnostics are not requested or required, Fish may return status-only.

### 7. Fish Request/Response Envelopes

File: `fish_request_response_envelopes.md`

Defines sparse request and response envelope semantics.

The envelope draft defines pre-materialization validation ordering and the safety rule that malformed, unsupported, unauthorized, or permission-denied requests MUST NOT authorize mutating materialization.

It uses named Fish status enums as primary, with HTTP-like numbers only as optional compatibility projections.

---

## Draft Dependency Order

The current recommended reading order is:

```text
1. README.md
2. fish_id_and_address_syntax.md
3. fish_status_registry.md
4. fish_status_enum_registry.md
5. fish_status_only_response_syntax.md
6. fish_result_schema_negotiation.md
7. fish_diagnostic_envelopes.md
8. fish_request_response_envelopes.md
```

Conceptual dependency order:

```text
Fish ID/address syntax
  -> status model
  -> named enum registry
  -> status-only graph response syntax
  -> result-schema negotiation
  -> diagnostic projection
  -> request/response envelope
```

---

## Boundary with C4 Core

C4 Core defines graph-native objects and operations such as:

```text
graph-delta production
materialization
endpoint-consumption policy
relator metadata
materialization-result graph-objects
```

Fish defines protocol projections and interchange behavior such as:

```text
FishID128 and fish:id:<FishID128> addresses
status-only graph responses
named status enums
status-word/bit-vector projections
optional numeric compatibility codes
request/response envelopes
result-schema negotiation
diagnostic envelopes
protocol-level safety rules
```

Fish projections may summarize, serialize, transport, or negotiate C4 graph-objects. They do not replace the graph-native semantics of those objects.

---

## Current Open Work

Likely next Fish tasks:

- define concrete Fish request-fish syntax;
- define concrete Fish syntax for request/response envelopes;
- define concrete Fish syntax for result-schema requests;
- decide whether status-word fields use a mandatory bit layout or remain profile-defined;
- make the status enum registry machine-readable as Fish graph data;
- define graph-delta projection formats;
- define patch/projection formats;
- define profile negotiation syntax.
