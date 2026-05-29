# Fish Specification v0.3.0 Draft

## Status

This document is a draft primary specification for Fish, the C4 surface syntax, query/update expression language, and graph interchange representation used by Purple Herring graph services.

This draft supersedes earlier protocol-centered Fish drafts as the current language-centered integration draft.

Normative keywords such as MUST, SHOULD, and MAY are used in their ordinary specification sense.

---

## 1. Purpose

Fish provides a compact, graph-native surface for expressing C4 graph structures, graph assertions, query patterns, graph-change payloads, and interchangeable Schools.

Fish is used to represent:

- graph statements;
- graph resources;
- relation expressions;
- Schools of related statements;
- query patterns;
- binding requests;
- assertion-state requests;
- graph-change payloads;
- graph-service response bodies;
- graph interchange artifacts.

---

## 2. Relationship to C4

C4, the Contextual Compositional Concept Calculus, defines the abstract graph-semantic structures used by Purple Herring.

Fish is the concrete source, query, update, and interchange surface for expressing those C4 structures.

Fish syntax MUST NOT be treated as the semantic authority where it conflicts with the active C4 model. Fish provides a parseable and canonicalizable surface for C4 graph objects, relation expressions, assertion states, graph regions, and resource references.

The general relationship is:

```text
C4
  abstract graph calculus and semantic model

Fish
  concrete surface notation and interchange form for C4 structures

Sashimi Bōchō / sashimi_bouchou
  parser and canonicalizer from Fish source into C4/Fish logical graph objects

Fish Tank
  runtime/backend abstraction for storing, querying, materializing, and projecting C4/Fish graph structures
```

Initial mapping:

| Fish surface | C4 structure |
|---|---|
| Fish statement | C4 assertion / relation expression |
| tail | C4 source expression |
| relator phrase | C4 relator expression |
| head | C4 target expression |
| assertion operator | C4 assertion-state operator |
| assertion polarity | C4 assertion polarity |
| assertion resolution | C4 assertion resolution |
| embedded Fish component | embedded C4 subgraph, resource expression, or statement set |
| School | bounded C4 graph region or statement set |
| Fish package | ordered C4/Fish interchange package under one package root |
| FRI | C4 resource reference / graph address |
| AUID | canonical projection equivalence identifier for a C4/Fish graph region |

This mapping is intentionally structural. It does not require every C4 structure to have exactly one Fish surface form, nor every Fish authoring shorthand to survive canonicalization.

---

## 3. Core Terms

### Fish

Fish is the concrete C4 surface used for graph statements, queries, graph-change payloads, and graph interchange.

### Fish Statement

A Fish statement is a graph expression that relates a tail expression to a head expression through a relator phrase.

Canonical abstract shape:

```fish
<tail><relation-state-operator><relator-phrase>@<head>;
```

Common positive assertion shape:

```fish
<tail> &+ <relator-phrase> @ <head>;
```

### Relator Phrase

A relator phrase is the relation expression between a relation-state operator and the head marker `@`.

Relator phrases may contain word components, namespace-qualified resources, embedded Fish components, query variables, or profile-defined relator components.

### School

A School is a Fish graph resource or payload consisting of one or more Fish statements interpreted together.

A School may be carried inline, stored as a resource, embedded in another format, or exchanged as a standalone document.

### Fish Package

A Fish package is an ordered fish sequence consisting of a package root FRI followed by School payload fish.

The package root FRI is `fish[0]`.

Payload fish are `fish[1..n]`.

### C4 Graph Object

A C4 graph object is an abstract graph-native semantic object represented, projected, queried, or materialized through Fish.

### Fish Resource Identifier / FRI / fry

A Fish Resource Identifier, abbreviated FRI and pronounced “fry,” is a resource-identifying Fish expression.

A FRI may identify a graph resource, graph region, statement-like resource, query pattern, School, or profile-defined graph-service resource.

### Aquatically Unique Identifier / AUID

An Aquatically Unique Identifier, abbreviated AUID, is a deterministic recursive hash over the canonical local payload of a Fish/C4 resource tree, subtree, School, or bounded graph region plus the AUIDs of its immediate descendants in canonical order.

An AUID identifies equivalence under its declared canonical projection profile. It does not assert primitive identity.

### Request Root

The request root is the graph node corresponding to the active request-root FRI supplied by a host binding.

Inside Fish bodies, `#` denotes the request root.

### Assertion

An assertion is a graph relation state represented or queried by a Fish statement.

### Query Pattern

A query pattern is a Fish statement or School containing query variables, relation variables, embedded Fish components, or other profile-defined queryable positions.

---

## 4. Lexical Conventions

This section defines core Fish lexical conventions used by Fish itself and by dependent profiles or host formats, including CNML.

### Canonical Space

Canonical Fish space is U+0020 SPACE.

When a Fish grammar rule refers to `" "`, `SPACE`, or canonical space, it means U+0020 SPACE only.

Tabs, line breaks, non-breaking spaces, and other Unicode whitespace characters are not canonical spaces.

Non-canonical whitespace MAY appear in source positions where Fish treats whitespace as incidental, but canonical serializers MUST emit U+0020 SPACE where a canonical separating space is required.

### Fish Identifier Tokens

A `fish-identifier-token` is the basic unquoted token class used by Fish profiles for identifier-like path segments, local names, and other profile-defined symbolic atoms.

The base character class for a `fish-identifier-token` is:

```ebnf
fish-identifier-token = fish-identifier-character, { fish-identifier-character } ;

fish-identifier-character =
    Unicode_Letter
  | Unicode_Mark
  | Unicode_Number
  | profile-permitted-connector ;
```

`Unicode_Letter`, `Unicode_Mark`, and `Unicode_Number` refer to Unicode general-category families for letters, combining/marking characters, and numbers.

`profile-permitted-connector` is a profile-defined extension point. A profile MAY permit connector characters such as `_` only when those characters do not conflict with the active grammar, host binding, or canonicalization profile.

A Fish profile that permits connector characters MUST define their canonicalization, normalization, and escaping behavior.

Fish identifier tokens MUST NOT contain Fish structural delimiters unless a profile explicitly defines an escaped or quoted form.

Fish structural delimiters include, at minimum:

```text
& @ ; { } ( ) [ ] , / # $ * ? + - : = ^ ~ < > " '
```

The active Fish profile MAY classify additional characters as delimiters.

### Token-Run Spacing

When a Fish profile permits human-readable token runs separated by spaces, those spaces MUST use canonical Fish space.

A token-run spacing rule SHOULD take the form:

```ebnf
token-run = fish-identifier-token, { " ", fish-identifier-token } ;
```

Such a token run cannot begin with space, end with space, contain consecutive spaces, or contain non-U+0020 whitespace.

---

## 5. Fish Statements

A Fish statement relates a tail to a head through a relator phrase.

A Fish statement is the Fish surface form of a C4 assertion or relation expression.

General form:

```fish
<tail> <relation-state-operator> <relator-phrase> @ <head>;
```

Examples:

```fish
Diane &+ modo:owns @ Andrea;
Diane &+ is { owner } of @ Andrea;
/fish-srv/characters/Diane &+ modo:owns @ /fish-srv/characters/Andrea;
```

The relation-state operator introduces a relation from the tail expression.

The `@` operator terminates the relator phrase and introduces the head expression consumed by that relator phrase.

The semicolon `;` terminates a Fish statement in Fish source.

A complete Fish statement is itself a graph resource and may be reified, addressed, stored, queried, or used as part of a larger School.

---

## 6. Tail, Relator Phrase, and Head

### Tail

The tail is the source-side expression of a Fish statement.

A tail may be a resource reference, FRI, local binding, request-root-relative expression, statement-like expression, or profile-defined graph expression.

### Relator Phrase

The relator phrase defines the relation form between tail and head.

A relator phrase is the Fish surface form of a C4 relator expression.

A relator phrase begins after the relation-state operator and ends at the head marker `@`.

Whitespace MUST separate relator phrase components.

Whitespace between relator phrase components is syntactic separation, not semantic payload. Canonical Fish serialization MUST emit deterministic spacing between components.

A relator phrase may contain:

- word components;
- namespace-qualified resource components;
- embedded Fish components;
- query relation variables;
- profile-defined relator components.

Examples:

```fish
modo:owns
is { owner } of
is { $x } of
$r
```

### Embedded Fish Components

A relator phrase MAY contain embedded Fish components delimited by `{` and `}`.

The embedded component MAY contain a resource expression, a Fish statement, or a School, according to the active Fish profile.

Embedded Fish components are embedded C4 graph structure, not raw text interpolation.

A canonicalizer MUST parse embedded Fish components into canonical graph form. Raw whitespace inside the braces is not semantic except inside literals, comment schools, or other whitespace-bearing forms.

When an embedded component contains a School, that School participates in canonicalization and AUID computation through its own AUID.

The outer relation-state operator applies to the enclosing relation. Relation-state operators inside embedded Fish apply only to the embedded graph unless explicitly linked outward by the active profile.

Examples:

```fish
#/Diane &+ is { owner } of @ #/Andrea;
```

```fish
#/Diane &+ is {
  *role &+ ph:label @ "sister";
  *role &- ph:type @ modo:family_relation/sister;
} of @ #/Andrea;
```

This example represents a resolved positive outer relation whose embedded role is labeled `sister` while explicitly not typed as `modo:family_relation/sister`.

### Head

The head is the target-side expression consumed by the relator phrase.

A head may be a resource reference, FRI, local binding, request-root-relative expression, statement-like expression, literal, School reference, or profile-defined graph expression.

---

## 6. Relation-State Operators

Fish relation-state operators encode polarity and resolution state.

The initial relation-state operators are:

| Operator | Polarity | Resolution | Meaning |
|---|---|---|---|
| `&+` | positive | resolved | resolved positive relation |
| `&-` | negative | resolved | resolved negative relation |
| `&` | non-polar / middle | resolved | resolved relation whose polarity is non-polar, middle, or not applicable |
| `&+?` | positive | unresolved | unresolved positive relation |
| `&-?` | negative | unresolved | unresolved negative relation |
| `&?` | non-polar / middle | unresolved | unresolved relation whose polarity is non-polar, middle, or not applicable |

Bare `&` is not syntactic sugar for `&+`.

Bare `&` asserts a resolved relation whose polarity is non-polar, middle, or not applicable under the active relation profile.

A relation profile MAY prohibit non-polar assertion for relators that require positive or negative polarity.

Canonical Fish serialization MUST preserve `&` when the relation state is resolved non-polar.

### Segmented Assertion Operators

Fish assertion state decomposes into two semantic axes:

```text
ASSERTION_POLARITY   = positive | negative | non-polar
ASSERTION_RESOLUTION = resolved | unresolved
```

Compact assertion operators are authoring forms over those axes:

```text id="ldqc2h"
&+   = & { positive } { resolved }
&-   = & { negative } { resolved }
&    = & { non-polar } { resolved }
&+?  = & { positive } { unresolved }
&-?  = & { negative } { unresolved }
&?   = & { non-polar } { unresolved }
```

A segmented assertion operator MAY expose these axes as queryable positions:

```fish id="52tyfx"
&{<assertion-polarity>}{<assertion-resolution>}
```

Each segment MAY contain a literal segment value or a query binding.

Example:

```fish id="sybar7"
#/Diane &{$assertion_polarity}{$assertion_resolution} is { owner } of @ #/Andrea;
```

This query binds the assertion polarity and assertion resolution of matching relations.

The compact and segmented forms are semantically equivalent after canonicalization. Canonical graph form SHOULD represent assertion polarity and assertion resolution as explicit fields rather than preserving only surface punctuation.


Examples:

```fish
#/Diane &+ modo:owns @ #/Andrea;
#/Diane &- modo:owns @ #/Andrea;
#/Diane & modo:co_present_with @ #/Andrea;
#/Diane &+? modo:owns @ #/Andrea;
#/Diane &-? modo:owns @ #/Andrea;
#/Diane &? modo:co_present_with @ #/Andrea;
```

---

## 8. Bindings

Fish uses binding sigils for variables and existential resources.

### Query Binding

A query binding begins with `$`.

Examples:

```fish
$x
$r
```

A query variable requests binding results when used in a query pattern.

Examples:

```fish
#/Diane &+ is { $x } of @ #/Andrea;
#/Diane &+ $r @ #/Andrea;
```

### Existential Binding

An existential binding begins with `*`.

Example:

```fish
*modo &+ define @ /github.com/fannie-spanker/media-oriented-description-ontology;
```

An existential binding introduces or refers to an existential graph resource according to the active Fish/C4 profile.

---

## 9. Schools

A School is a set, block, document, payload, or resource containing one or more Fish statements interpreted together.

A School is the Fish interchange form of a bounded C4 graph region or statement set.

Example School:

```fish
*modo &+ define @ /github.com/fannie-spanker/media-oriented-description-ontology;
#/Diane &+ modo:owns @ #/Andrea;
#/Diane &+ modo:loves @ #/Andrea;
```

Schools may be used for:

- graph interchange;
- query bodies;
- additive graph payloads;
- mutation payloads;
- deletion/retraction payloads;
- stored graph resources;
- examples and fixtures;
- profile-defined graph packages.

A School may itself be addressable as a graph resource.

---

## 10. Fish Packages

A Fish package is an ordered fish sequence interpreted under one package root FRI.

The initial package model is:

```text
fish[0]   = package root FRI
fish[1..] = School payload fish
```

The package root FRI defines the context for all payload fish in the package.

Payload fish `fish[1..n]` are interpreted relative to `fish[0]`.

Payload fish MUST NOT change the package root context for following fish.

Context-changing FRIs, ambient root shifts, or implicit scope resets inside a package are not part of the initial package model.

A FRI at an index greater than zero is data, a reference, or part of a Fish statement. It does not reset package context.

Package-local indexes are locators. They are not standalone content identifiers.

Example:

```text
fish[0] = /fish-srv/characters/
fish[1] = #/Diane &+ modo:owns @ #/Andrea;
fish[2] = #/Diane &+ modo:loves @ #/Andrea;
```

Package-local handles may address package fish by index:

```fish
fish:eid:<package-token>/fish/0
fish:eid:<package-token>/fish/1
fish:eid:<package-token>/fish/2
```

### Non-Normative: Capo al Fin

Informally, `fish[0]` may be called the **capo al fin**: the head/root fish from which the package School is interpreted through to its end.

This term is non-normative. The normative term is **package root FRI**.

---

## 11. Request-Root Sigil

The `#` sigil is a Fish body-local request-root reference.

Inside a Fish body, `#` denotes the graph node corresponding to the request-root FRI supplied by the active host binding.

Examples:

```fish
#;
#/Diane;
#/Diane &+ modo:owns @ #/Andrea;
```

The expression `#/Diane` denotes a resource relative to the request root.

The `#` sigil is used inside Fish bodies and Schools.

Address FRIs used as raw HTTP request targets do not contain raw `#`.

---

## 12. Fish Resource Identifiers / FRIs / fries

A Fish Resource Identifier, or FRI, identifies a graph resource or graph expression.

A FRI is the Fish surface form of a C4 resource reference or graph address.

FRIs may be path-like:

```fish
/fish-srv/characters/Diane
/github.com/fannie-spanker/media-oriented-description-ontology
```

FRIs may also be Fish expressions when the active context permits statement-like resource identifiers or query-pattern identifiers.

A FRI may denote:

- a graph node;
- a graph resource;
- a School;
- a statement-like graph object;
- a graph region;
- a query pattern;
- a materialization target;
- a profile-defined service resource.

FRI syntax is refined by host bindings and active profiles.

---

## 13. Aquatically Unique Identifiers / AUIDs

An Aquatically Unique Identifier, or AUID, is a deterministic recursive hash over the canonical local payload of a Fish/C4 resource tree, subtree, School, or bounded graph region plus the AUIDs of its immediate descendants in canonical order.

AUID is initially one experimental identifier method, not an identifier family.

An AUID identifies canonical equivalence under a declared AUID profile. It does not assert primitive identity.

For C4 purposes, an AUID is an equivalence identifier for a canonical projection of a C4/Fish graph region, not an identity primitive.

The AUID principle is:

```text
AUID(region, profile) = H(local_payload_hash(region) || ordered_immediate_child_AUID_records(region))
```

The `||` notation means byte concatenation, not bitwise OR.

The AUID profile defines the canonical projection used to determine local payload, immediate descendant membership, immediate descendant ordering, and branch records.

For AUID computation, a graph region's canonical projection is local. It contains the region's canonical local payload and canonical branch records for its immediate included descendants. Those branch records contain the AUIDs of the immediate child/subregion branches, not the canonical projections of those children.

A parent AUID MUST be derived from the AUIDs of its immediate descendants only. It MUST NOT directly hash the canonical projections of deeper descendants. Deeper descendant structure affects the parent only recursively, through the AUIDs of the immediate children.

Canonicalization is therefore recursively applied one parent-child layer at a time. It is not a single canonical serialization of the entire descendant structure embedded into every ancestor.

Two graph regions with the same AUID are equivalent under that profile. They are not thereby asserted to be absolutely identical.

### AUID Profile Requirements

An AUID profile MUST define:

- root or roots;
- included resource kinds;
- included relator/edge kinds;
- local payload canonicalization;
- FRI normalization;
- namespace expansion;
- Unicode normalization;
- literal canonicalization;
- relator phrase canonicalization;
- embedded Fish component canonicalization;
- assertion-state encoding;
- child collection modes;
- immediate child ordering rules;
- duplicate handling;
- boundary policy;
- cycle handling;
- shared-node handling;
- hash algorithm;
- digest length or truncation rule;
- canonical byte payload form;
- profile/version domain separators.

AUID encoding is carrier-defined. The AUID profile defines the canonical bytes and digest semantics; host bindings, storage backends, and exchange protocols define how those bytes are represented.

The initial experimental AUID profile SHOULD use SHA-256 truncated to 128 bits unless replaced by a later canonical profile.

The AUID profile defines the digest bytes. It does not require a universal text encoding. AUIDs MAY be represented as binary, Base64URL, hexadecimal, Unicode-safe text, or another carrier-specific representation according to the active host binding or storage protocol.

### Layered AUID Shape

An AUID is computed from local resource content and immediate child AUID records.

Abstract shape:

```text
local_payload_hash = H(profile_domain || local_resource_payload)

child_branch_record = encode(
  relator_AUID,
  child_AUID,
  edge_payload_hash,
  edge_role,
  assertion_state
)

children_hash = H(profile_domain || canonical_immediate_child_branch_records)

region_AUID = H(profile_domain || local_payload_hash || children_hash)
```

Each `child_AUID` is itself computed by the same AUID algorithm over that child region. This recursion is the only way descendant structure enters an ancestor AUID.

The parent canonical projection depends on sorted immediate branch records containing child AUIDs. It does not contain the child canonical projections themselves.

The exact byte encoding is profile-defined.

### Child Collection Modes

An AUID profile MUST classify each child collection as one of:

```text
role-fixed
indexed
unordered
```

Role-fixed child collections are serialized in their defined role order.

Examples:

```text
Fish statement: tail, relator phrase, head
```

Indexed child collections are serialized in canonical index order.

Examples:

```text
Fish package: fish[0], fish[1], fish[2], ...
```

Unordered graph-region branches are sorted by canonical branch records before hashing.

### Canonical Branch Ordering

For unordered graph-region branches, the default AUID profile sorts canonical branch records by already-canonical identifier material first:

```text
relator_AUID
child_AUID
edge_payload_hash
edge_role
assertion_state
```

Sorting order defines deterministic serialization order before hashing. It does not define semantic priority.

The branch record MUST still include all fields required by the active profile. A field appearing later in the sort key still affects the resulting AUID.

Duplicate branches MUST NOT be silently collapsed unless the active profile explicitly defines set semantics for that child collection.

If duplicate branch records occur under multiset semantics, repeated branch records are serialized repeatedly.

### Edge Role

An edge role is the structural job an attachment edge plays inside the canonical projection.

It answers what position or function a child occupies in the parent structure.

Examples:

```text
tail
relator_phrase
head
embedded_component
parameter
annotation
member
source
target
root_fri
fish_sequence_item
boundary_stub
diagnostic
```

The edge role is distinct from the relator phrase.

For the Fish statement:

```fish
Diane &+ modo:owns @ Andrea;
```

`tail`, `relator_phrase`, and `head` are edge roles.

`modo:owns` is the relator phrase.

### Boundary-Crossing Relations

A regional AUID profile MUST define how relations crossing the selected region boundary are handled.

Supported boundary policies are:

```text
closed
  omit boundary-crossing relations

stubbed
  include boundary-crossing relations as boundary stubs

expanded
  include external endpoints according to traversal rules
```

The default experimental policy is `stubbed`.

A boundary stub records the internal endpoint, direction, relator phrase, assertion state, and a canonical reference or fingerprint for the external endpoint, without recursively including the external endpoint's full region.

### Incremental Canonicalization

Layered AUID computation supports incremental canonicalization.

When a child region changes, unchanged sibling regions do not need to be recanonicalized or rehashed. Their existing AUIDs remain valid inputs to the parent branch records.

Only the changed region and its ancestor chain need new AUIDs, up to the selected regional root, School root, package root, or graph root.

This makes AUIDs suitable for graph storage, graph-delta / fond production, caching, and localized materialization.

AUID implementations SHOULD cache canonical local payload hashes, immediate child branch records, and computed AUIDs where safe to do so.

AUID implementations MUST invalidate cached AUIDs for a region when that region's canonical local payload, immediate child membership, branch record data, or child AUID ordering changes.

### Regional AUIDs

The AUID algorithm MAY be applied to bounded subtrees or graph regions.

A regional AUID identifies a canonical projection of a graph region under an explicit region profile.

Regional AUIDs are computed from the local payload of the selected region and the AUIDs of its immediate included child/subregion branches. Each child branch AUID is computed separately by the same rule. The regional canonical projection therefore depends on immediate child AUIDs, not embedded descendant projections.

Regional AUIDs are useful for:

- deduplication;
- graph-delta / fond production;
- caching;
- partial verification;
- localized materialization;
- change detection;
- projection equivalence testing.

---

## 14. Namespaces and Qualified Resources

Fish resources may use namespace-like prefixes.

Example:

```fish
modo:owns
ph:RESOLVED_POSITIVE
fish:proto:status
fish:id:VQ6EAOKbQdSnFkRmVUQAAA
fish:auid:<encoded-AUID>
```

A namespace binding may be introduced by Fish source, host configuration, discovery metadata, active profile, or ontology context.

Example:

```fish
*modo &+ define @ /github.com/fannie-spanker/media-oriented-description-ontology;
```

The exact namespace-binding semantics are profile-defined until the namespace grammar is finalized.

The following namespace/path forms are reserved for future or profile-defined use:

```text
fish:id:<FishID128>        opaque generated Fish ID/address
fish:auid:<encoded-AUID>   Aquatically Unique Identifier in a carrier-defined textual encoding
fish:eid:<token>           edge-scoped or package-scoped occurrence identifier
fish:addr:(...)            structured Fish address tuple
fish:proto:<name>          Fish protocol/control vocabulary
fish:proto:(...)           protocol-relative list graph
fish:<name>                general Fish vocabulary resource
```

`fish:auid:` is reserved for text-form AUID references in Fish source or FRI contexts. The encoding of `<encoded-AUID>` is defined by the active Fish profile or host binding.

`fish:id:` and `fish:eid:` are separate identifier forms and are not AUIDs unless a future profile explicitly folds them into the AUID system.

---

## 15. Query Forms

Fish queries are Fish statements or Schools interpreted as query patterns.

### Resource Query

A resource query asks for a graph resource representation or projection.

Example FRI:

```fish
/fish-srv/characters/Diane
```

### Concrete Assertion Query

A concrete assertion query asks for the assertion state or matching representation of a fully specified assertion.

```fish
#/Diane &+ is { owner } of @ #/Andrea;
```

### Relator-Component Query

A relator-component query contains a query variable inside an embedded Fish component.

```fish
#/Diane &+ is { $x } of @ #/Andrea;
```

This asks for values of `$x`.

### Relation-Variable Query

A relation-variable query binds the relation position.

```fish
#/Diane &+ $r @ #/Andrea;
```

This asks for relation resources or relator phrases `$r` connecting `#/Diane` to `#/Andrea`.

---

## 16. Assertion-State Results

A concrete assertion query or assertion-pattern query may return one or more assertion states.

Initial assertion-state vocabulary:

| State | Meaning |
|---|---|
| `RESOLVED_POSITIVE` | a matching resolved positive relation exists |
| `RESOLVED_NEGATIVE` | a matching resolved negative relation exists |
| `RESOLVED_NON_POLAR` | a matching resolved non-polar / middle relation exists |
| `UNRESOLVED_POSITIVE` | matching positive unresolved structure exists |
| `UNRESOLVED_NEGATIVE` | matching negative unresolved structure exists |
| `UNRESOLVED_NON_POLAR` | matching non-polar / middle unresolved structure exists |
| `NO_RELATION` | no matching resolved or unresolved relation is known under the active scope/profile |

Multiple states MAY be returned when the graph contains conflict, ambiguity, unresolved material, or mixed assertion states.

`NO_RELATION` applies only when none of the other assertion states apply.

---

## 17. Binding Results

Binding queries return bindings for query variables.

Example query:

```fish
#/Diane &+ is { $x } of @ #/Andrea;
```

A binding result answers with values for `$x`.

Example relation-variable query:

```fish
#/Diane &+ $r @ #/Andrea;
```

A binding result answers with matching relation resources or relator phrases for `$r`.

Binding results may be projected as:

- matching Fish statements;
- Fish binding-result graphs;
- JSON binding tables;
- profile-defined result structures.

The canonical Fish binding-result graph syntax is deferred.

---

## 18. Projection and Omission

Fish response bodies are projections of graph-native structures.

A response projection may omit graph regions not requested by the active result schema, endpoint role, Accept negotiation, profile, disclosure policy, host binding, or AUID projection profile.

Omission from a Fish response MUST NOT be interpreted as absence from the underlying graph unless the active projection schema explicitly defines that interpretation.

Projection schemas may be graph schemas or summary schemas.

Graph schemas return graph roots, graph regions, or projected graph structures.

Summary schemas return compressed facts, counts, flags, bindings, assertion states, diagnostics, or other compact summaries.

---

## 19. Graph-Change Payloads

Fish Schools may be used as graph-change payloads.

A graph-change payload may request addition, mutation, deletion, retraction, deactivation, resolution, transformation, or profile-defined materialization behavior.

The host binding and active graph-service policy determine how a graph-change payload is submitted and what graph changes are permitted.

Graph-change payloads are interpreted as atomic materialization units when submitted through an atomic host operation.

---

## 20. Materialization Concepts

### Materialization

Materialization is the process by which a Fish/C4 graph expression, School, delta, or graph-change payload is interpreted into graph-service state, result structures, projections, or persistent graph changes.

### Persistent Mutation

Persistent mutation is a durable change to graph-service state.

### Atomic Materialization Unit

An atomic materialization unit commits as a whole or not at all at the persistent graph-state boundary.

Responses may report partial validation, diagnostics, ambiguity, unresolved subgraphs, or failed interpretation without committing partial persistent mutation.

---

## 21. Fish Bodies

A Fish body is raw Fish source carried by a host binding, file, message, repository object, or embedded document.

Fish bodies may contain:

- full Fish statement syntax;
- request-root references;
- query variables;
- existential bindings;
- relator phrases;
- embedded Fish components;
- quoted literals;
- multiple statements;
- Schools;
- comments and comment schools.

Fish bodies are the ordinary authoring form for expressive Fish queries and graph-change payloads.

---

## 22. Comments

Fish source MAY contain line comments and comment schools.

A line comment begins with `><>` outside a quoted literal and continues to the end of the line.

```fish
><> Diane owns Andrea.
#/Diane &+ modo:owns @ #/Andrea;  ><> trailing comment
```

A comment school begins with `><>{` outside a quoted literal and continues until its closing `}`.

```fish
><>{
This is a comment school.
It may contain multiple lines.
}
```

Comments are source annotations. They are treated as whitespace by the parser.

Comments are not Fish graph content, do not affect Fish semantics, and MUST NOT affect canonicalization or AUID computation.

Comment schools do not nest in the initial Fish profile.

The exact escaping rules for `}` inside comment schools are deferred.

---

## 23. Whitespace

Fish source is whitespace-insensitive outside quoted literals, comment schools, canonical token-run spacing, and other explicitly whitespace-bearing literal forms.

Whitespace MAY separate tokens for readability, but it does not affect Fish semantics or AUID computation unless the active profile explicitly defines a whitespace-bearing construct.

Whitespace MUST separate relator phrase components in full School Fish source.

Where canonical Fish source requires a separating space, that space MUST be U+0020 SPACE.

A canonical Fish serializer MUST emit deterministic whitespace and MUST use U+0020 SPACE for canonical separating spaces.

Incidental whitespace, comments, and comment schools MUST NOT contribute to AUID canonical projections.

---

## 24. Media Type

The canonical Purple Herring Fish media type is:

```http
application/vnd.purple-herring.fish
```

Fish documents using this media type are UTF-8 Fish source unless an active profile explicitly defines another encoding.

The media type may be used for:

- Fish request bodies;
- Fish response bodies;
- Fish source files;
- School interchange;
- graph-service payloads;
- profile-defined Fish artifacts.

---

## 25. Relationship to Host Bindings

Host bindings define how Fish documents, Schools, FRIs, request roots, query patterns, graph-change payloads, and response bodies are carried through a concrete host environment.

The Purple Herring HTTP Binding defines one such host binding.

Other host bindings may target filesystems, Git repositories, archives, message queues, databases, embedded CNML resources, or other carriers.

---

## 26. Non-Normative Culinary Notes

The following terminology is non-normative:

| Concept | Culinary metaphor |
|---|---|
| Fish statement | fish |
| School | school of fish |
| Fish package root FRI | capo al fin |
| Fish Resource Identifier / FRI | fry |
| Aquatically Unique Identifier / AUID | recursive wet fingerprint |
| Graph-delta projection | fond |
| Repository | fishery |
| Registry / exchange | fish market |
| Template library | Herring Bones |
| Authored semantic content | Sashimi |
| Strict validator | shark |
| Hypothetical Fish-native database | Mongres |

These metaphors are explanatory and aesthetic. They do not define conformance behavior.

---

## 27. Open Questions

The following remain open:

- exact Fish grammar;
- exact FRI grammar;
- canonical relator phrase grammar;
- canonical embedded Fish component grammar;
- exact AUID canonical byte payload form;
- exact AUID canonicalization profile;
- exact AUID hash algorithm and digest/truncation length;
- carrier-specific AUID text encodings for Fish source, FRIs, HTTP, files, and binary transports;
- exact package EID layout;
- whether `fish:eid:` should encode package EIDs, edge EIDs, or both;
- whether `fish[0]` as package root FRI should remain permanently normative;
- canonical namespace-binding syntax;
- canonical Fish binding-result graph syntax;
- canonical assertion-state response syntax;
- canonical literal syntax;
- canonical escaping rules;
- exact comment-school escaping rules;
- whether comment schools should eventually support nesting;
- whether compact aliases for `application/vnd.purple-herring.fish` are useful;
- whether operation trace graphs should be specified later under a clearer name than “request fish.”

