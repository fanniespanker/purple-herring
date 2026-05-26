# Fish Specifications

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

Fish may define:

- surface serialization for C4 graph structures;
- protocol request/response framing;
- Fish namespace conventions;
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

In Fish/Purple Herring culinary terminology, `fond` is an informal alias for graph-delta projections. This is aesthetic terminology only. The formal C4 term remains graph delta, and protocol names remain `graph_delta_graph` and `graph_delta_summary`.

---

## Naming Convention

Fish protocol/control vocabulary uses the `fish:proto:` namespace path.

Protocol relation, schema, operation, marker, and policy names use snake_case.

Status enum constants use SCREAMING_SNAKE_CASE.

Examples:

```fish
fish:proto:result_schema
fish:proto:fallback_result_schema
fish:proto:materialization_policy
fish:proto:diagnostic_schema
fish:proto:status_word_64
fish:proto:compat_code
fish:proto:result_type
fish:proto:canonical_addr
fish:proto:GRAPH_DELTA_PRODUCED
```

Opaque generated IDs remain under `fish:id:` and SHOULD NOT be moved under `fish:proto:`.

Structured address tuples use `fish:addr:(...)`.

---

## Current Drafts

### 1. Fish Namespace Conventions

File: `fish_namespace_conventions.md`

Defines the initial namespace/path conventions:

```text
fish:id:<FishID128>        opaque generated Fish ID/address
fish:addr:(...)            structured Fish address tuple
fish:proto:<name>          Fish protocol/control vocabulary
fish:proto:(...)           protocol-relative list graph
fish:<name>                general Fish vocabulary resource
```

It also defines the generic result convention:

```fish
<request-fish>&fish:proto:result@<result-root>;
<result-root>&fish:proto:result_type@fish:proto:<result-schema-name>;
```

### 2. Fish ID and Address Syntax

File: `fish_id_and_address_syntax.md`

Defines `FishID128`, the canonical unpadded Base64URL encoding for 128-bit opaque Fish IDs, and the prefixed opaque address form:

```fish
fish:id:<FishID128>
```

Also defines structured address tuples:

```fish
fish:addr:("natalie","purple-herring.fanniespanker.com",A,A,F)
```

and deterministic hash-derived Fish IDs from canonical `fish:addr:(...)` bytes.

Fish IDs and structured addresses provide addressability and correlation, not primitive C4 identity.

### 3. Fish Status Registry

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

### 4. Fish Status Enum Registry

File: `fish_status_enum_registry.md`

Defines the initial named Fish status enums, including success, graph-delta production, materialization, authentication, permission, profile negotiation, schema negotiation, validation, diagnostics, projection, and conflict/ambiguity statuses.

Each enum entry may define:

- symbolic enum name;
- canonical graph name under `fish:proto:`;
- short meaning;
- provisional status-word fields;
- optional numeric compatibility projection;
- valid contexts;
- materialization safety rule, where relevant.

### 5. Fish Status-Only Response Syntax

File: `fish_status_only_response_syntax.md`

Defines canonical graph-native status-only responses.

Default status-only responses are Fish graph statements, not scalar tokens:

```fish
<request-fish>&fish:proto:status@fish:proto:(<status-enum-1>,<status-enum-2>,...);
```

Bare enum tokens and base64 status-word tokens are compact transport projections, not the canonical graph-native response form.

### 6. Fish Result-Schema Negotiation

File: `fish_result_schema_negotiation.md`

Defines how Fish clients request protocol projections of C4 graph-native results.

Key rule:

> Fish SHOULD return status-only by default and SHOULD only return what the client asked for.

A result schema is graph-defined. It describes what subgraphs to return, how to organize them, and what markings to preserve or apply.

Unsupported or malformed result schemas MUST NOT trigger mutating materialization.

### 7. Fish Result-Schema Request Syntax

File: `fish_result_schema_request_syntax.md`

Defines canonical graph-native syntax for requesting result schemas from a request fish:

```fish
<request-fish>&fish:proto:result_schema@fish:proto:<schema>;
```

Initial standard schema names include:

```fish
fish:proto:status_only
fish:proto:diagnostic_graph
fish:proto:graph_delta_graph
fish:proto:graph_delta_summary
fish:proto:materialization_result_graph
fish:proto:materialization_result_summary
fish:proto:protocol_envelope
```

Composable schema traits include:

```fish
fish:proto:region_root_marking
fish:proto:direct_marking
```

### 8. Fish Graph-Delta Projection Syntax

File: `fish_graph_delta_projection_syntax.md`

Defines Fish projection syntax for graph-delta result graphs and graph-delta summaries.

Graph-delta projections are informally called fond projections.

Graph-delta graph projections use the generic result convention:

```fish
<request-fish>&fish:proto:result@<result-root>;
<result-root>&fish:proto:result_type@fish:proto:graph_delta_graph;
```

Graph-delta graph schemas return graph roots/regions. Graph-delta summary schemas return compact summary projections.

### 9. Fish Graph-Delta Marking Syntax

File: `fish_graph_delta_marking_syntax.md`

Defines schema-controlled marking forms for graph-delta graph projections.

The base result kind remains:

```fish
fish:proto:graph_delta_graph
```

and marking behavior is selected with composable traits such as:

```fish
fish:proto:(graph_delta_graph,region_root_marking)
fish:proto:(graph_delta_graph,direct_marking)
```

### 10. Fish Materialization-Result Projection Syntax

File: `fish_materialization_result_projection_syntax.md`

Defines Fish projection syntax for materialization-result graph projections and materialization-result summaries.

Materialization-result graph projections use the generic result convention:

```fish
<request-fish>&fish:proto:result@<result-root>;
<result-root>&fish:proto:result_type@fish:proto:materialization_result_graph;
```

Materialization-result graph schemas return graph roots/regions. Materialization-result summary schemas return compact summary projections.

### 11. Fish Profile Negotiation Syntax

File: `fish_profile_negotiation_syntax.md`

Defines graph-native syntax for requesting, accepting, selecting, and reporting active Fish/C4 profiles.

Profile negotiation controls schema support, schema-trait compatibility, address canonicalization, hash-derived ID generation, status-word layouts, diagnostic disclosure policy, materialization policy, and capability graphs.

### 12. Fish Diagnostic Envelopes

File: `fish_diagnostic_envelopes.md`

Defines diagnostic envelopes as requested or profile-required protocol projections of graph-native diagnostic structures.

Diagnostics are not automatic. If diagnostics are not requested or required, Fish may return status-only.

### 13. Fish Request Fish Syntax

File: `fish_request_fish_syntax.md`

Defines request fish as graph-addressable Fish/C4 graph objects representing protocol requests.

Request fish use `fish:proto:` protocol/control relations and are answered by graph-native status responses.

### 14. Fish Request/Response Envelopes

File: `fish_request_response_envelopes.md`

Defines sparse request and response envelope semantics.

The envelope draft defines pre-materialization validation ordering and the safety rule that malformed, unsupported, unauthorized, or permission-denied requests MUST NOT authorize mutating materialization.

It uses named Fish status enums as primary, with HTTP-like numbers only as optional compatibility projections.

---

## Draft Dependency Order

The current recommended reading order is:

```text
1. README.md
2. fish_namespace_conventions.md
3. fish_id_and_address_syntax.md
4. fish_status_registry.md
5. fish_status_enum_registry.md
6. fish_status_only_response_syntax.md
7. fish_result_schema_negotiation.md
8. fish_result_schema_request_syntax.md
9. fish_graph_delta_projection_syntax.md
10. fish_graph_delta_marking_syntax.md
11. fish_materialization_result_projection_syntax.md
12. fish_profile_negotiation_syntax.md
13. fish_diagnostic_envelopes.md
14. fish_request_fish_syntax.md
15. fish_request_response_envelopes.md
```

Conceptual dependency order:

```text
Fish namespace conventions
  -> Fish ID/address syntax
  -> status model
  -> named enum registry
  -> status-only graph response syntax
  -> result-schema negotiation
  -> result-schema request syntax
  -> graph-delta projection syntax
  -> graph-delta marking syntax
  -> materialization-result projection syntax
  -> profile negotiation syntax
  -> diagnostic projection
  -> request fish syntax
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
Fish namespace conventions
FishID128 and fish:id:<FishID128> addresses
structured fish:addr:(...) address tuples
fish:proto:<name> protocol/control vocabulary
status-only graph responses
named status enums
status-word/bit-vector projections
optional numeric compatibility codes
request fish syntax
request/response envelopes
result-schema negotiation
result-schema request syntax
graph-delta projection syntax
graph-delta marking syntax
materialization-result projection syntax
profile negotiation syntax
diagnostic envelopes
protocol-level safety rules
```

Fish projections may summarize, serialize, transport, or negotiate C4 graph-objects. They do not replace the graph-native semantics of those objects.

---

## Current Open Work

Likely next Fish tasks:

- add profile capability graph syntax;
- decide whether status-word fields use a mandatory bit layout or remain profile-defined;
- make the status enum registry machine-readable as Fish graph data;
- define patch/projection formats.
