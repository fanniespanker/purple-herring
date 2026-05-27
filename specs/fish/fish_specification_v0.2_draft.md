# Fish Specification v0.2.0 Draft

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

## 2. Core Terms

### Fish

Fish is the concrete C4 surface used for graph statements, queries, graph-change payloads, and graph interchange.

### Fish Statement

A Fish statement is a graph expression that relates a tail expression to a head expression through a relator.

Canonical abstract shape:

```fish
<tail>&<relator>@<head>;
```

### School

A School is a Fish graph resource or payload consisting of one or more Fish statements interpreted together.

A School may be carried inline, stored as a resource, embedded in another format, or exchanged as a standalone document.

### C4 Graph Object

A C4 graph object is an abstract graph-native semantic object represented, projected, queried, or materialized through Fish.

### Fish Resource Identifier / FRI / fry

A Fish Resource Identifier, abbreviated FRI and pronounced “fry,” is a resource-identifying Fish expression.

A FRI may identify a graph resource, graph region, statement-like resource, query pattern, School, or profile-defined graph-service resource.

### Request Root

The request root is the graph node corresponding to the active request-root FRI supplied by a host binding.

Inside Fish bodies, `#` denotes the request root.

### Assertion

An assertion is a graph relation state represented or queried by a Fish statement.

### Query Pattern

A query pattern is a Fish statement or School containing unspecified slots, query variables, relation variables, or other profile-defined queryable positions.

---

## 3. Fish Statements

A Fish statement relates a tail to a head through a relator.

General form:

```fish
<tail>&<relator>@<head>;
```

Examples:

```fish
Diane&modo:owns@Andrea;
Diane&is_[owner]_of@Andrea;
/fish-srv/characters/Diane&modo:owns@/fish-srv/characters/Andrea;
```

The `&` operator introduces an asserted relation from the tail expression.

The `@` operator introduces the head expression consumed by the relator.

The semicolon `;` terminates a Fish statement in Fish source.

A complete Fish statement is itself a graph resource and may be reified, addressed, stored, queried, or used as part of a larger School.

---

## 4. Tail, Relator, and Head

### Tail

The tail is the source-side expression of a Fish statement.

A tail may be a resource reference, FRI, local binding, request-root-relative expression, statement-like expression, or profile-defined graph expression.

### Relator

The relator defines the relation form between tail and head.

A relator may be:

- a named relation resource;
- a namespace-qualified relation resource;
- a template relation containing slots;
- a query relation variable;
- a profile-defined relation expression.

Examples:

```fish
modo:owns
is_[owner]_of
is_[$x]_of
$r
```

### Head

The head is the target-side expression consumed by the relator.

A head may be a resource reference, FRI, local binding, request-root-relative expression, statement-like expression, literal, School reference, or profile-defined graph expression.

---

## 5. Relation Templates and Slots

A relation template is a relator containing one or more slots.

Example:

```fish
is_[owner]_of
```

The slot value `owner` participates in the relator identity or interpretation according to the active profile or ontology.

An empty slot is written:

```fish
[]
```

An empty slot is unspecified. In assertion-state queries, it is existential for pattern evaluation but does not bind or return values.

A query-binding slot may contain a query variable:

```fish
[$x]
```

A query-binding slot requests values for that variable.

---

## 6. Bindings

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
#/Diane&is_[$x]_of@#/Andrea;
#/Diane&$r@#/Andrea;
```

### Existential Binding

An existential binding begins with `*`.

Example:

```fish
*modo&define@/github.com/fannie-spanker/media-oriented-description-ontology;
```

An existential binding introduces or refers to an existential graph resource according to the active Fish/C4 profile.

---

## 7. Schools

A School is a set, block, document, payload, or resource containing one or more Fish statements interpreted together.

Example School:

```fish
*modo&define@/github.com/fannie-spanker/media-oriented-description-ontology;
#/Diane&modo:owns@#/Andrea;
#/Diane&modo:loves@#/Andrea;
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

## 8. Request-Root Sigil

The `#` sigil is a Fish body-local request-root reference.

Inside a Fish body, `#` denotes the graph node corresponding to the request-root FRI supplied by the active host binding.

Examples:

```fish
#;
#/Diane;
#/Diane&modo:owns@#/Andrea;
```

The expression `#/Diane` denotes a resource relative to the request root.

The `#` sigil is used inside Fish bodies and Schools.

Address FRIs used as raw HTTP request targets do not contain raw `#`.

---

## 9. Fish Resource Identifiers / FRIs / fries

A Fish Resource Identifier, or FRI, identifies a graph resource or graph expression.

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

## 10. Namespaces and Qualified Resources

Fish resources may use namespace-like prefixes.

Example:

```fish
modo:owns
ph:ASSERTED_POSITIVE
```

A namespace binding may be introduced by Fish source, host configuration, discovery metadata, active profile, or ontology context.

Example:

```fish
*modo&define@/github.com/fannie-spanker/media-oriented-description-ontology;
```

The exact namespace-binding semantics are profile-defined until the namespace grammar is finalized.

---

## 11. Query Forms

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
#/Diane&is_[owner]_of@#/Andrea;
```

### Assertion-Pattern Query

An assertion-pattern query contains no query-binding variables but may contain unspecified slots.

```fish
#/Diane&is_[]_of@#/Andrea;
```

The empty slot `[]` is existential for assertion-state evaluation but does not bind or return slot values.

### Binding Query

A binding query contains one or more query variables.

```fish
#/Diane&is_[$x]_of@#/Andrea;
```

This asks for values of `$x`.

### Relation-Variable Query

A relation-variable query binds the relation position.

```fish
#/Diane&$r@#/Andrea;
```

This asks for relation resources or relators `$r` connecting `#/Diane` to `#/Andrea`.

---

## 12. Assertion-State Results

A concrete assertion query or assertion-pattern query may return one or more assertion states.

Initial assertion-state vocabulary:

| State | Meaning |
|---|---|
| `ASSERTED_POSITIVE` | a matching positive assertion exists |
| `ASSERTED_NEGATIVE` | a matching negative assertion exists |
| `UNRESOLVED_POSITIVE` | matching positive unresolved structure exists |
| `UNRESOLVED_NEGATIVE` | matching negative unresolved structure exists |
| `NO_RELATION` | no matching asserted or unresolved relation is known under the active scope/profile |

Multiple states MAY be returned when the graph contains conflict, ambiguity, unresolved material, or mixed assertion states.

`NO_RELATION` applies only when none of the other assertion states apply.

---

## 13. Binding Results

Binding queries return bindings for query variables.

Example query:

```fish
#/Diane&is_[$x]_of@#/Andrea;
```

A binding result answers with values for `$x`.

Example relation-variable query:

```fish
#/Diane&$r@#/Andrea;
```

A binding result answers with matching relation resources or relators for `$r`.

Binding results may be projected as:

- matching Fish statements;
- Fish binding-result graphs;
- JSON binding tables;
- profile-defined result structures.

The canonical Fish binding-result graph syntax is deferred.

---

## 14. Graph-Change Payloads

Fish Schools may be used as graph-change payloads.

A graph-change payload may request addition, mutation, deletion, retraction, deactivation, resolution, transformation, or profile-defined materialization behavior.

The host binding and active graph-service policy determine how a graph-change payload is submitted and what graph changes are permitted.

Graph-change payloads are interpreted as atomic materialization units when submitted through an atomic host operation.

---

## 15. Materialization Concepts

### Materialization

Materialization is the process by which a Fish/C4 graph expression, School, delta, or graph-change payload is interpreted into graph-service state, result structures, projections, or persistent graph changes.

### Persistent Mutation

Persistent mutation is a durable change to graph-service state.

### Atomic Materialization Unit

An atomic materialization unit commits as a whole or not at all at the persistent graph-state boundary.

Responses may report partial validation, diagnostics, ambiguity, unresolved subgraphs, or failed interpretation without committing partial persistent mutation.

---

## 16. Fish Bodies

A Fish body is raw Fish source carried by a host binding, file, message, repository object, or embedded document.

Fish bodies may contain:

- full Fish statement syntax;
- request-root references;
- query variables;
- existential bindings;
- relation template slots;
- quoted literals;
- multiple statements;
- Schools.

Fish bodies are the ordinary authoring form for expressive Fish queries and graph-change payloads.

---

## 17. Media Type

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

## 18. Relationship to Host Bindings

Host bindings define how Fish documents, Schools, FRIs, request roots, query patterns, graph-change payloads, and response bodies are carried through a concrete host environment.

The Purple Herring HTTP Binding defines one such host binding.

Other host bindings may target filesystems, Git repositories, archives, message queues, databases, embedded CNML resources, or other carriers.

---

## 19. Non-Normative Culinary Notes

The following terminology is non-normative:

| Concept | Culinary metaphor |
|---|---|
| Fish statement | fish |
| School | school of fish |
| Fish Resource Identifier / FRI | fry |
| Repository | fishery |
| Registry / exchange | fish market |
| Template library | Herring Bones |
| Authored semantic content | Sashimi |
| Strict validator | shark |

These metaphors are explanatory and aesthetic. They do not define conformance behavior.

---

## 20. Open Questions

The following remain open:

- exact Fish grammar;
- exact FRI grammar;
- exact relationship between full Fish statement syntax and address-safe FRI syntax;
- canonical namespace-binding syntax;
- canonical Fish binding-result graph syntax;
- canonical assertion-state response syntax;
- exact relation-state syntax beyond asserted positive relations;
- canonical literal syntax;
- canonical escaping rules;
- whether compact aliases for `application/vnd.purple-herring.fish` are useful;
- whether operation trace graphs should be specified later under a clearer name than “request fish.”

