# C4 Mathematical Core v0.2.1 Draft

## Status

This document defines the minimized mathematical core for C4.

C4 Core is the minimum theory needed to explain Fish graph syntax, request fish, status fish, graph-delta/fond projections, and materialization-result projections.

C4 Core is not a Fish dialect, protocol profile, status registry, diff format, transport format, or implementation schema.

Fish and Fish profiles define concrete syntax, request/response graphs, result-schema negotiation, compact encodings, status projections, diagnostics, and protocol behavior.

C4 Core defines only the abstract graph-native semantics those Fish forms refer to.

---

## 1. Core Principles

C4 is the Contextual Compositional Concept Calculus.

C4 Core provides a minimal graph-native semantic model for:

- expressions;
- graph-objects;
- statements;
- relators;
- relation states;
- endpoint consumption;
- graph-delta production;
- materialization.

C4 Core is governed by the following principles.

1. Meaningful C4 structures are graph-objects or graph structure.
2. C4 does not assume primitive identity.
3. C4 relation states preserve unresolved/superposed meaning without requiring ranking, weighting, probability, or forced collapse.
4. Endpoint consumption and relator behavior are field/profile-relative graph semantics.
5. Graph-delta objects and materialization-result objects have no fixed C4 Core schema.
6. Fish protocol artifacts are not primitive C4 semantics.

---

## 2. Stabilized Notation

| Symbol | Meaning |
|---|---|
| $\mathfrak{F}$ | active C4 field: resolution/evaluation context |
| $\mathbb{N}$ | universe of C4 names |
| $\mathbb{D}$ | universe of C4 naming domains |
| $\mathbb{G}$ | universe/class of named graph containers |
| $G_j\in\mathbb{G}$ | a specific named graph container |
| $\Xi$ | universe of resolved C4 graph-objects |
| $\Xi_\nu\subseteq\Xi$ | node graph-object subdomain |
| $\Xi_\eta\subseteq\Xi$ | edge/traversal graph-object subdomain |
| $\Xi_\alpha\subseteq\Xi$ | delta-source graph-object subdomain |
| $\Xi_\Delta\subseteq\Xi$ | graph-delta graph-object subdomain |
| $\Xi_\mu\subseteq\Xi$ | materialization-result graph-object subdomain |
| $\mathcal{E}$ | expression domain |
| $\Psi$ | relation-state domain |
| $\xi\in\Xi$ | arbitrary resolved graph-object |
| $\xi_r\in\Xi$ | resolved relator graph-object |
| $\xi_\pi\in\Xi$ | endpoint-consumption policy graph-object |
| $\xi_\alpha\in\Xi_\alpha$ | delta-source graph-object |
| $\xi_\Delta\in\Xi_\Delta$ | graph-delta graph-object |
| $\xi_\mu\in\Xi_\mu$ | materialization-result graph-object |
| $\mathbf{x}$ | expression |
| $\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t$ | source, relator, and target expressions |
| $\psi_k$ | relation state |
| $P$ | statement tuple |
| $\Pi_{\mathfrak{F}}(\xi_r,p)$ | endpoint-policy lookup |
| $\boldsymbol{\delta}_{\mathfrak{F}}$ | graph-delta production operator |
| $\mathbf{m}_{\mathfrak{F}}$ | materialization operator |

C4 Core avoids the following as primitive semantic forms:

| Avoided form | Replacement / treatment |
|---|---|
| $\mathcal{A}_\Delta$ as non-graph delta-source domain | use $\Xi_\alpha\subseteq\Xi$ |
| $\mathcal{O}$ as generic object universe | use $\Xi$ |
| primitive identity | use addressability, correspondence, equivalence, or substitutability under $\mathfrak{F}$ or profile |
| scalar arity/order axes | use graph-defined endpoint-consumption policy |
| fixed graph-delta schema | leave schema to Fish, materializers, or profiles |
| return-value axis | use graph-delta and materialization-result graph-objects |

---

## 3. Graph Containers, Names, and Graph-Objects

Let:

$$
\mathbb{G}
$$

be the universe/class of named graph containers.

A named graph container is an addressable graph container available under an active field/profile.

A specific graph container is written:

$$
G_j\in\mathbb{G}
$$

Let:

$$
\mathbb{N}
$$

be the universe of C4 names, and:

$$
\mathbb{D}
$$

be the universe of naming domains.

C4 Core does not define URI schemes, network protocols, filesystem paths, package locators, or Fish IDs as primitive mathematical identity. Such forms are syntax/protocol/profile projections into C4 names or graph-object references.

Let:

$$
\Xi
$$

be the universe of resolved C4 graph-objects.

A C4 graph-object is any resolved addressable graph-native object in or through the C4 substrate.

Examples include node graph-objects, edge/traversal graph-objects, relator graph-objects, statement graph-objects, graph-delta graph-objects, and materialization-result graph-objects.

C4 graph-object addressability is not primitive identity. Addressability is a way to refer to graph structure under a field/profile.

Node-role and edge/traversal-role graph-objects are written:

$$
\Xi_\nu\subseteq\Xi
$$

$$
\Xi_\eta\subseteq\Xi
$$

These are role subdomains, not necessarily disjoint ontological classes.

A traversal chain is an ordered sequence of traversal/edge graph-objects:

$$
\vec{\eta}\in\mathrm{Seq}(\Xi_\eta)
$$

Textual path separators are not primitive C4 traversal operators. They may serialize traversal chains under Fish or another syntax/profile.

---

## 4. Expressions and Active Field

Let:

$$
\mathcal{E}
$$

be the domain of C4 expressions.

An expression is a structured form that may denote, bind, construct, query, project, or resolve to graph structure under an active field/profile.

An arbitrary expression is written:

$$
\mathbf{x}\in\mathcal{E}
$$

List expressions are recursive structured expressions:

$$
\mathcal{E}_{list}\subseteq\mathcal{E}
$$

For expressions $\mathbf{x}_1,\ldots,\mathbf{x}_n\in\mathcal{E}$:

$$
(\mathbf{x}_1,\ldots,\mathbf{x}_n)\in\mathcal{E}_{list}
$$

C4 Core does not flatten nested lists by default. Lists, nested lists, sequences, trees, sets, tuples, and frames are graph-expressible structure interpreted by relators, endpoint policies, fields, or profiles.

Let:

$$
\mathfrak{F}
$$

be the active C4 field.

The active field is the resolution/evaluation context containing whatever graph state, bindings, loaded profiles, naming-domain bindings, policies, relator metadata, graph-delta behavior, and materializer availability are relevant to evaluation.

As an expression-resolution operator, the field is partial:

$$
\mathfrak{F}:\mathcal{E}\rightharpoonup\Xi
$$

Thus:

$$
\xi=\mathfrak{F}(\mathbf{x})
$$

means that expression $\mathbf{x}$ resolves to graph-object $\xi$ under active field $\mathfrak{F}$.

---

## 5. Relation States

Let:

$$
\Psi
$$

be the C4 relation-state domain.

C4 relation states are non-probabilistic. They preserve resolved, unresolved, negated, and superposed relation-state structure without requiring ranking, weighting, likelihood assignment, or forced collapse.

C4 Core defines at least:

$$
\Psi_\top,\Psi_\star,\Psi_\bot\subseteq\Psi
$$

where:

- $\Psi_\top$ is resolved affirmative;
- $\Psi_\star$ is unresolved / uncollapsed / superposed;
- $\Psi_\bot$ is resolved negative.

Distinguished defaults are:

$$
\psi_\top,
\quad
\psi_\star,
\quad
\psi_\bot
$$

Profiles may define additional relation states, including oriented unresolved states.

---

## 6. Statements and Relators

A C4 statement is a directed relation expression with an attached relation-state.

The statement domain is:

$$
\mathrm{Stmt}=\mathcal{E}\times\mathcal{E}\times\mathcal{E}\times\Psi
$$

An individual statement is:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

where:

- $\mathbf{x}_s$ is the source expression;
- $\mathbf{x}_r$ is the relator expression;
- $\mathbf{x}_t$ is the target expression;
- $\psi_k$ is the relation state.

The relator expression occupies relation position. Relator-position admissibility is field/profile-relative.

When resolution succeeds:

$$
\xi_s=\mathfrak{F}(\mathbf{x}_s),
\quad
\xi_r=\mathfrak{F}(\mathbf{x}_r),
\quad
\xi_t=\mathfrak{F}(\mathbf{x}_t)
$$

with:

$$
\xi_s,\xi_r,\xi_t\in\Xi
$$

Relation-state application may be written:

$$
\psi_k:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The statement tuple may therefore be written:

$$
P\equiv\psi_k:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

Relator semantics are graph-defined and profile-relative. C4 Core does not require primitive relator-kind axes such as assertion, query, constructor, transform, mapping, node-effect, edge-effect, return value, or yield kind.

Relators do not directly mutate persistent graph state in C4 Core. Relators participate in graph-delta production. Materializers interpret graph-delta objects.

---

## 7. Endpoint Consumption

Endpoint-consumption policy is graph-native.

A structured expression in source or target position remains one expression at the statement level. C4 Core does not automatically expand list expressions into multiple statements.

For resolved relator graph-object:

$$
\xi_r\in\Xi
$$

and endpoint position:

$$
p\in\{source,target\}
$$

the endpoint-consumption policy object is:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

where:

$$
\xi_\pi\in\Xi
$$

The policy object may describe how an endpoint expression is viewed, accepted, rejected, preserved, transformed, or treated as unresolved.

C4 Core does not treat arity, orderedness, decomposition, list structure, tree structure, frame structure, or bounds as primitive endpoint axes. They are graph structure or graph-described constraints inside endpoint policies.

Implementations may compile endpoint policies into closures or normal forms, but compilation is implementation behavior, not C4 Core semantics.

---

## 8. Statement and Block Reification

Statements and blocks may be reified as graph-objects.

Let:

$$
\iota_P:\mathrm{Stmt}\to\Xi
$$

map a canonical statement to its statement graph-object.

A C4 block is an ordered sequence of statements:

$$
\mathrm{Block}=\mathrm{Seq}(\mathrm{Stmt})
$$

Let:

$$
\iota_B:\mathrm{Block}\to\Xi
$$

map a canonical block to its block graph-object.

Context, provenance, source attribution, modality, temporal validity, and related qualifiers are not primitive slots of $P$. They should be represented as ordinary graph structure about the statement graph-object.

---

## 9. Graph-Delta Production

Delta production is graph-native.

Let:

$$
\Xi_\alpha\subseteq\Xi
$$

be the delta-source graph-object subdomain.

Let:

$$
\Xi_\Delta\subseteq\Xi
$$

be the graph-delta graph-object subdomain.

The graph-delta production operator is:

$$
\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta
$$

For:

$$
\xi_\alpha\in\Xi_\alpha
$$

graph-delta production is:

$$
\boldsymbol{\delta}_{\mathfrak{F}}(\xi_\alpha)=\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi_\Delta
$$

A graph-delta is a graph-object produced by graph-delta production. Its internal schema is not fixed by C4 Core.

A graph-delta may describe, depending on field/profile/materializer/protocol interpretation, graph contribution, graph change, graph comparison, construction, selection, validation/check outcome, projection possibility, diagnostic possibility, or another profile-defined effect/result possibility.

Graph-deltas are not external patch blobs, protocol envelopes, or fixed diff schemas in C4 Core.

---

## 10. Statement Denotation as Delta Production

Statements may serve as delta sources when reified.

When:

$$
\iota_P(P)\in\Xi_\alpha
$$

statement denotation is:

$$
\mathbf{d}_{\mathfrak{F}}(P):=\boldsymbol{\delta}_{\mathfrak{F}}(\iota_P(P))
$$

Thus:

$$
\mathbf{d}_{\mathfrak{F}}(P)=\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi_\Delta
$$

The notation $\mathbf{d}_{\mathfrak{F}}$ is a convenience alias. It does not introduce a separate non-graph denotation process outside graph-delta production.

---

## 11. Materialization

Let:

$$
\Xi_\mu\subseteq\Xi
$$

be the materialization-result graph-object subdomain.

Materialization is:

$$
\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu
$$

For:

$$
\xi_\Delta\in\Xi_\Delta
$$

materialization is:

$$
\mathbf{m}_{\mathfrak{F}}(\xi_\Delta)=\xi_\mu
$$

where:

$$
\xi_\mu\in\Xi_\mu
$$

A materializer is a graph-delta interpreter or processor.

Materialization is not identical to mutation. Mutation of persistent graph state is one possible materialization behavior. Other behaviors include validation, diagnostics, indexing, projection, export, query-result construction, protocol response construction, no-op confirmation, or profile-defined processing.

Only materialization may mutate persistent graph state, and mutation is only one possible materialization behavior.

C4 Core defines $\Xi_\mu$ as a role/subdomain but does not define a fixed materialization-result schema.

The canonical graph-native pipeline is:

$$
\xi_\alpha
\overset{\boldsymbol{\delta}_{\mathfrak{F}}}{\longmapsto}
\xi_\Delta
\overset{\mathbf{m}_{\mathfrak{F}}}{\longmapsto}
\xi_\mu
$$

---

## 12. Canonicalization and Validation

Let:

$$
\kappa
$$

be canonicalization.

For a surface language $L$:

$$
\mathrm{parse}_L:\Sigma_L^*\rightharpoonup AST_L
$$

$$
\kappa_L:AST_L\rightharpoonup\mathrm{Stmt}\cup\mathrm{Block}\cup\mathcal{E}
$$

Surface-language parsing and canonicalization are not the definition of C4 itself.

Validation is field/profile-relative.

C4 Core names only broad validation concerns:

- expression resolution;
- relator-position admissibility;
- endpoint-policy lookup;
- endpoint consumption;
- relation-state compatibility;
- delta-source admissibility;
- graph-delta production admissibility;
- materialization preflight.

Validation diagnostics are graph-native or profile-defined. Fish may project them into diagnostic envelopes, but those envelopes are not C4 Core semantics.

---

## 13. No Primitive Identity

C4 Core does not define primitive identity.

Terms such as “same object,” “object identity,” or “changed object” should be avoided as primitive semantic claims.

C4 may use:

- addressability;
- canonical equivalence;
- correspondence;
- substitutability;
- profile-defined equivalence;
- field-relative resolution;
- graph-defined mapping;
- materializer-defined before/after relation.

A graph diff or graph comparison does not say that one identical object changed unless a profile explicitly supplies an identity-like correspondence policy.

---

## 14. Protocol Boundary: C4 and Fish

C4 Core defines the minimal graph-native theory Fish needs in order to be meaningful.

Fish defines syntax, request fish, response graphs, status-only graph responses, status enums, status words, compact identifiers, result-schema negotiation, graph-delta/fond projections, materialization-result projections, diagnostic envelopes, profile negotiation, and transport/interchange behavior.

Fish projections may summarize, serialize, transport, negotiate, or compactly encode C4 graph-objects.

Fish projections do not replace C4 graph-native semantics.

C4 Core does not define Fish status codes, Fish request/response syntax, Fish ID encodings, Fish result schemas, graph-delta projection schemas, materialization-result schemas, or diagnostic envelope schemas.

---

## 15. Open Questions

The following remain open for future formalization:

- exact canonical AST schema for $\mathcal{E}$;
- whether $\Xi_\alpha$, $\Xi_\Delta$, and $\Xi_\mu$ are fixed subdomains or profile-relative predicates over $\Xi$;
- exact minimum relation-state set required by Fish;
- exact minimum endpoint-consumption theory Fish requires;
- how much relator metadata theory Fish needs before it becomes a Fish/profile concern;
- whether any materializer theory beyond $\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu$ belongs in C4 Core.
