# Purple Herring HTTP Binding v0.1.0 Draft

## Status

This document is a draft host binding for Purple Herring graph services over HTTP.

It defines how HTTP origins, discovery documents, request targets, operation endpoints, media types, Fish payloads, and response representations map onto Purple Herring graph-service behavior.

Normative keywords such as MUST, SHOULD, and MAY are used in their ordinary specification sense.

---

## 1. Purpose

A Purple Herring HTTP binding maps HTTP requests onto graph resources and Fish payload evaluation.

The binding defines:

- graph-service discovery;
- graph-root advertisement;
- Fish media types;
- Fish Resource Identifier resolution;
- request-root binding for Fish bodies;
- simple resource retrieval;
- Fish-body operation endpoints;
- query, addition, mutation, and deletion behavior;
- atomicity boundaries;
- response representation conventions.

---

## 2. Core Terms

### Purple Herring Graph Service

A Purple Herring graph service exposes one or more graph roots over an HTTP origin.

Each graph root maps a request-target space to graph resources addressable by Fish Resource Identifiers.

### Fish

Fish is the C4 surface syntax, query/update expression language, and graph interchange representation used by Purple Herring graph services.

### C4 Relationship

The HTTP binding transports Fish source and Fish response projections. The graph semantics belong to C4 and the active Purple Herring/Fish profile.

HTTP request targets, operation endpoints, request bodies, and response bodies are host-binding carriers for C4/Fish graph structures. They do not redefine the underlying C4 semantics.


### School

A School is a Fish graph resource or payload consisting of one or more Fish statements interpreted together.

### Fish Resource Identifier / FRI / fry

A Fish Resource Identifier, abbreviated FRI and pronounced “fry,” is a resource-identifying expression used by Purple Herring graph services.

A FRI may denote a graph resource, graph region, statement-like resource, query pattern, or profile-defined graph-service resource.

### Request Root

The request root is the graph node corresponding to the FRI resolved from the HTTP request target or declared operation endpoint root.

Inside Fish request and response bodies, `#` denotes the request root.

---

## 3. Discovery

A Purple Herring-aware HTTP origin SHOULD expose a discovery document at:

```http
GET /.well-known/purple-herring
```

The discovery document describes graph-service capabilities for that HTTP origin.

The primary discovery representation is JSON:

```http
Content-Type: application/json
```

The discovery document MAY also be available in Fish or other representations through HTTP content negotiation.

---

## 4. Discovery Document Shape

The JSON discovery document SHOULD include:

- service identity;
- discovery document version;
- supported Fish media types;
- graph roots;
- operation endpoints for each graph root;
- supported query/update languages;
- supported profiles, where applicable;
- authentication and authorization metadata, where applicable.

Example:

```json
{
  "service": "purple-herring",
  "version": "0.1",
  "mediaTypes": [
    "application/vnd.purple-herring.fish"
  ],
  "queryLanguages": [
    {
      "id": "fish",
      "media_types": [
        "application/vnd.purple-herring.fish"
      ]
    }
  ],
  "graphRoots": [
    {
      "root_path": "/fish-srv/characters/",
      "description": "Character graph resources",
      "endpoints": {
        "query": "/fish-srv/characters/.query",
        "add": "/fish-srv/characters/.add",
        "mutate": "/fish-srv/characters/.mutate",
        "delete": "/fish-srv/characters/.delete"
      }
    },
    {
      "root_path": "/fish-srv/ontologies/",
      "description": "Ontology and vocabulary resources",
      "endpoints": {
        "query": "/fish-srv/ontologies/.query",
        "add": "/fish-srv/ontologies/.add",
        "mutate": "/fish-srv/ontologies/.mutate",
        "delete": "/fish-srv/ontologies/.delete"
      }
    }
  ]
}
```

Graph-root entries are JSON objects. Clients SHOULD NOT infer operation endpoint paths that are not declared by discovery or other host metadata.

---

## 5. Media Type

The canonical Purple Herring Fish media type is:

```http
application/vnd.purple-herring.fish
```

Fish bodies using this media type are UTF-8 Fish source unless an active profile explicitly defines another encoding.

Requests containing Fish bodies use:

```http
Content-Type: application/vnd.purple-herring.fish
```

Clients request Fish responses with:

```http
Accept: application/vnd.purple-herring.fish
```

---

## 6. HTTP Request Targets and FRIs

For ordinary graph-resource retrieval, the HTTP request target resolves to a FRI.

Example:

```http
GET /fish-srv/characters/Diane
Accept: application/vnd.purple-herring.fish
```

The service resolves `/fish-srv/characters/Diane` as a FRI and returns a representation or projection of the corresponding graph resource.

Bare retrieval FRIs use ordinary HTTP request-target syntax.

Expressive Fish syntax is carried in request bodies.

---

## 7. Request-Root Sigil

The `#` sigil is a Fish body-local request-root reference.

Inside Fish request and response bodies, `#` denotes the graph node corresponding to the request root.

The `#` sigil appears inside Fish bodies, not in raw HTTP request-target FRIs.

Example:

```http
POST /fish-srv/characters/.add
Content-Type: application/vnd.purple-herring.fish
Accept: application/vnd.purple-herring.fish

*modo&define@/github.com/fannie-spanker/media-oriented-description-ontology;
#/Diane&modo:owns@#/Andrea;
#/Diane&modo:loves@#/Andrea;
```

Here `/fish-srv/characters/.add` is the operation endpoint, and the operation endpoint is rooted at `/fish-srv/characters/` as declared by discovery. Inside the Fish body, `#` denotes the graph node corresponding to that root.

Thus `#/Diane` and `#/Andrea` are FRI-relative references under `/fish-srv/characters/`.

---

## 8. Resource Retrieval

Simple resource retrieval uses `GET` against a resource FRI.

```http
GET /fish-srv/characters/Diane
Accept: application/vnd.purple-herring.fish
```

A `GET` request retrieves, projects, or evaluates the graph resource denoted by the request target according to the active graph-root binding and response negotiation.

`GET` resource retrieval does not perform persistent graph mutation.

---

## 9. Operation Endpoints

A Purple Herring graph root MAY declare operation endpoints for Fish-body requests.

Operation endpoints are submitted with `POST` and interpreted according to their declared endpoint role.

Common endpoint roles are:

| Role | Meaning |
|---|---|
| `query` | read-only Fish query evaluation |
| `add` | atomic additive graph materialization |
| `mutate` | generic atomic graph-change materialization |
| `delete` | atomic graph deletion, retraction, or deactivation |

Operation endpoints are host-binding resources declared through discovery.

---

## 10. Query Endpoint

A `query` endpoint evaluates a Fish body as a read-only graph query rooted at the endpoint's declared graph root.

Example:

```http
POST /fish-srv/characters/.query
Content-Type: application/vnd.purple-herring.fish
Accept: application/vnd.purple-herring.fish

#/Diane&is_[$x]_of@#/Andrea;
```

This asks for values of `$x` such that the relation template `is_[$x]_of` relates `#/Diane` to `#/Andrea` under the `/fish-srv/characters/` graph root.

Query endpoints return query results, projections, bindings, assertion states, diagnostics, or profile-defined result forms according to request negotiation and service policy.

A `query` endpoint does not perform persistent graph mutation.

---

## 11. Add Endpoint

An `add` endpoint applies an additive Fish body as one atomic materialization unit.

Example:

```http
POST /fish-srv/characters/.add
Content-Type: application/vnd.purple-herring.fish
Accept: application/vnd.purple-herring.fish

#/Diane &+ modo:owns @ #/Andrea;
#/Diane &+ modo:loves @ #/Andrea;
```

The submitted School may add new graph material, define relations within newly submitted material, or define relations from newly submitted material outward according to the active graph-service policy.

The `add` role is narrower than `mutate`.

An `add` endpoint applies the submitted addition atomically.

---

## 12. Mutate Endpoint

A `mutate` endpoint applies a Fish body as a generic atomic graph-change request.

Example:

```http
POST /fish-srv/characters/.mutate
Content-Type: application/vnd.purple-herring.fish
Accept: application/vnd.purple-herring.fish

#/Diane &+ modo:owns @ #/Andrea;
```

The active graph-service policy defines which additions, edits, replacements, retractions, resolutions, transformations, or other graph changes are permitted.

A `mutate` endpoint applies the accepted graph change atomically.

---

## 13. Delete Endpoint

A `delete` endpoint applies a Fish body as an atomic deletion, retraction, or deactivation request.

Example:

```http
POST /fish-srv/characters/.delete
Content-Type: application/vnd.purple-herring.fish
Accept: application/vnd.purple-herring.fish

#/Diane &+ modo:owns @ #/Andrea;
```

The active graph-service policy defines whether deletion means physical deletion, graph retraction, tombstoning, archival deactivation, negation, or another profile-defined removal behavior.

A `delete` endpoint applies the accepted removal atomically.

---

## 14. Optional Conventional HTTP Methods

A graph root MAY additionally support conventional HTTP mutational methods.

Suggested conventional meanings:

| Method | Meaning |
|---|---|
| `PUT` | store or replace a complete representation at the addressed FRI |
| `PATCH` | apply a partial update to the addressed FRI |
| `DELETE` | remove, retract, or deactivate the addressed FRI representation |

When supported, these methods observe the same graph-service validation, permission, policy, and atomicity rules as corresponding operation endpoints.

Operation endpoints are the primary Fish-body workflow for expressive Fish source.

---

## 15. Atomic Mutation Boundary

Mutational operation endpoints apply at request granularity.

A successful `add`, `mutate`, or `delete` operation commits the accepted graph change as one materialization unit.

If parsing, FRI resolution, profile validation, permission checking, materialization-policy checking, graph-delta construction, or commit fails, the service preserves the pre-request persistent graph state for the affected materialization unit.

A response may report partial validation, partial interpretation, diagnostics, ambiguity, or unresolved subgraphs, but persistent graph mutation is committed atomically.

Auxiliary effects such as logging, caching, indexing, notifications, webhooks, or asynchronous projections are host-policy-defined.

---

## 16. Query Forms

Fish queries are Fish statements or Schools interpreted by a `query` endpoint.

### Resource Query

A resource query asks for a representation or projection of a graph resource.

```http
GET /fish-srv/characters/Diane
Accept: application/vnd.purple-herring.fish
```

### Concrete Assertion Query

A concrete assertion query asks for the assertion state or matching representation of a fully specified assertion.

```fish
#/Diane &+ is {owner} of @ #/Andrea;
```

### Assertion-Pattern Query

An assertion-pattern query contains no query-binding variables but may contain unspecified slots.

```fish
#/Diane &+ is {} of @ #/Andrea;
```

An empty template slot `{}` is existential for assertion-state evaluation but does not bind or return slot values.

### Binding Query

A binding query contains one or more query variables.

```fish
#/Diane &+ is {$x} of @#/Andrea;
```

A query variable requests binding results.

### Assertion-State Segment Query

A query MAY bind assertion-state segments:

```fish
#/Diane &{$assertion_polarity}{$assertion_resolution} is { owner } of @ #/Andrea;
```

This asks for matching relations while binding their assertion polarity and assertion resolution.

### Relation-Variable Query

A relation-variable query binds a relation position.

```fish
#/Diane & $r @ #/Andrea;
```

This asks for relation resources or relators `$r` such that the relation connects `#/Diane` to `#/Andrea`.

---

## 17. Assertion-State Results // UPDATE

An assertion query or assertion-pattern query may return one or more assertion states.

Initial assertion-state vocabulary:

| State | Meaning |
|---|---|
| `ASSERTED_POSITIVE` | a matching positive assertion exists |
| `ASSERTED_NON_POLAR` | a matching non-polar assertion exists |
| `ASSERTED_NEGATIVE` | a matching negative assertion exists |
| `UNRESOLVED_POSITIVE` | a matching positive unresolved structure exists |
| `UNRESOLVED_NON_POLAR` | a matching non-polar unresolved structure exists |
| `UNRESOLVED_NEGATIVE` | a matching negative unresolved structure exists |
| `NO_RELATION` | no matching asserted or unresolved relation is known under the active scope/profile |

Multiple states MAY be returned when the active graph state contains conflict, ambiguity, unresolved material, or mixed assertion states.

`NO_RELATION` applies only when none of the other assertion states apply.

---

## 18. Binding Results

Binding queries return bindings for query variables.

A service MAY project binding results as:

- Fish statements;
- Fish binding-result graphs;
- JSON binding tables;
- profile-defined result forms.

The canonical Fish syntax for binding-result graphs is deferred.

---

## 19. Response Conventions

For HTTP bindings, the HTTP status code is the transport-level outcome of the request.

Fish response bodies provide graph-native representations, summaries, diagnostics, assertion states, binding results, materialization results, or profile-defined result projections.

A response Fish body uses `#` consistently for the request root.

If a response needs to describe the operation itself, it SHOULD use an explicit response, receipt, diagnostic, or trace resource rather than changing the meaning of `#`.

---

## 20. Compatibility Fish-in-Address Forms

A host binding MAY provide percent-encoded Fish-in-address forms for compact or advanced clients.

Percent-encoded Fish address forms are compatibility bindings.

The ordinary authoring forms are:

- ordinary HTTP request targets for resource retrieval;
- raw Fish source in request bodies for expressive queries and graph changes.

---

## 21. Non-Normative Culinary Notes

The following terminology is non-normative:

| HTTP / endpoint behavior | Culinary metaphor |
|---|---|
| `GET` retrieval | spyglass / camera |
| `PUT` representation storage | filleting knife |
| `PATCH` partial update | boning knife / suture needle |
| `POST .query` | sonar ping |
| `POST .add` | stocking the pond |
| `POST .mutate` | industrial chum grinder |
| `POST .delete` | shark |

These metaphors are explanatory and aesthetic. They do not define conformance behavior.

---

## 22. Open Questions

The following remain open:

- canonical Fish binding-result graph syntax;
- exact canonical JSON discovery schema;
- exact profile/version parameter syntax for the Fish media type;
- exact FRI grammar;
- exact relationship between FRI syntax and full Fish statement syntax;
- whether any compact aliases for `application/vnd.purple-herring.fish` are useful;
- whether response summaries should standardize assertion-state Fish syntax;
- whether operation trace graphs should be defined later under a clearer name than “request fish.”