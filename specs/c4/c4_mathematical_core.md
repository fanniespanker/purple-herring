# C4 Mathematical Core v0.2.0 Draft

## Status

This document defines the consolidated mathematical core for C4.

It supersedes the earlier v0.1.6 draft structure and incorporates the stable portions of the notation, graph-native endpoint-policy, relator metadata, graph-delta, and materialization addenda.

C4 Core is serialization-neutral. Surface syntax, protocol exchange, status projections, result-schema negotiation, compact identifiers, and transport behavior belong to Fish or another protocol/profile layer.

C4 Core uses graph-native semantics throughout. Where an object is meaningful to C4 evaluation, it is represented as a graph-object or graph structure.

---

## 1. Core Design Principles

C4 is the Contextual Compositional Concept Calculus.

C4 Core defines a graph-native semantic calculus over expressions, graph-objects, statements, relators, relation states, graph-delta production, and materialization.

C4 Core is governed by the following principles.

1. **Graph-native representation**: meaningful C4 structures are graph-objects or graph structure.
2. **No primitive identity**: C4 does not assume metaphysical or primitive object identity. It uses addressability, correspondence, equivalence, and substitutability under an active field or profile.
3. **No hidden ranking**: relation states preserve unresolved or superposed structure without requiring ranking, weighting, probability, or forced collapse.
4. **Policy as graph structure**: endpoint consumption, relator behavior, materialization expectations, and validation are graph-described and profile-relative.
5. **Protocol separation**: Fish may serialize, project, negotiate, status-code, and transport C4 graph-objects, but Fish protocol artifacts are not primitive C4 semantics.

---

## 2. Terminology Layers

C4 Core uses serialization-neutral terminology.

| C4 Core | Surface/protocol analogue |
|---|---|
| statement | serialized relation statement |
| block | serialized statement block |
| source | left/source endpoint |
| relator | relation-position connector/template/operator |
| target | right/target endpoint |
| relation-state | surface statement-state marker |
| graph-object | resolved addressable graph-native object |
| field | active resolution/evaluation field |
| graph-delta | produced graph-object describing denoted contribution/effect/result possibility |
| materialization | interpretation/processing of a graph-delta |

A **relator** is an expression occupying relation position in a C4 statement. It determines the semantic relation, connector, template, or relational operation applied between a source expression and a target expression under a relation-state.

---

## 3. Stabilized Notation

### 3.1 Core universes and subdomains

| Symbol | Meaning |
|---|---|
| $\mathfrak{F}$ | active C4 field: resolution/evaluation context, including profile, graph environment, policy, and materializer availability |
| $\mathbb{N}$ | universe of C4 names |
| $\mathbb{D}$ | universe of C4 naming domains |
| $\mathbb{G}$ | universe/class of integral named graph containers |
| $G_j\in\mathbb{G}$ | a specific named graph container |
| $\Xi$ | universe of resolved C4 graph-objects |
| $\Xi_\nu\subseteq\Xi$ | node graph-object subdomain |
| $\Xi_\eta\subseteq\Xi$ | edge/traversal graph-object subdomain |
| $\Xi_\alpha\subseteq\Xi$ | delta-source graph-object subdomain |
| $\Xi_\Delta\subseteq\Xi$ | graph-delta graph-object subdomain |
| $\Xi_\mu\subseteq\Xi$ | materialization-result graph-object subdomain |
| $\mathcal{E}$ | expression domain |
| $\Psi$ | relation-state domain |

All $\Xi$-subdomains are graph-object subdomains. They do not introduce non-graph semantic domains.

In this specification, $\mathbb{N}$ denotes the universe of C4 names. Natural-number counts SHOULD be written as $\mathbb{Z}_{\ge 0}$ or with explicit numeric constraints.

### 3.2 Graph-object variables

| Symbol | Meaning |
|---|---|
| $\xi\in\Xi$ | resolved graph-object |
| $\xi_\nu\in\Xi_\nu$ | node graph-object |
| $\xi_\eta\in\Xi_\eta$ | edge/traversal graph-object |
| $\xi_\alpha\in\Xi_\alpha$ | delta-source graph-object |
| $\xi_\Delta\in\Xi_\Delta$ | graph-delta graph-object |
| $\xi_\mu\in\Xi_\mu$ | materialization-result graph-object |
| $\xi_r\in\Xi$ | resolved relator graph-object |
| $\xi_\pi\in\Xi$ | endpoint-consumption policy graph-object |
| $\xi_{cmp}\in\Xi_\alpha$ | graph-comparison delta-source graph-object |

### 3.3 Expressions, traversal, statements, and operators

| Symbol | Meaning |
|---|---|
| $\mathbf{x}$ | expression |
| $\mathbf{x}_s$ | source endpoint expression |
| $\mathbf{x}_r$ | relator expression |
| $\mathbf{x}_t$ | target endpoint expression |
| $\nu$ | node, when discussing graph structure informally |
| $\eta$ | edge/traversal object, when discussing graph structure informally |
| $\vec{\eta}$ | traversal chain, an ordered sequence of traversal/edge objects |
| $P$ | C4 statement tuple |
| $P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)$ | canonical statement tuple |
| $\psi_k$ | relation state |
| $\iota_P(P)$ | graph-object reification of statement $P$ |
| $\Pi_{\mathfrak{F}}(\xi_r,p)$ | endpoint-policy lookup |
| $C_{\mathfrak{F},\xi_r,p}$ | compiled endpoint-consumption closure |
| $\boldsymbol{\delta}_{\mathfrak{F}}$ | graph-delta production operator |
| $\mathbf{d}_{\mathfrak{F}}(P)$ | statement-denotation convenience alias |
| $\mathbf{m}_{\mathfrak{F}}$ | materialization operator |

When formal membership matters, prefer $\xi_\nu\in\Xi_\nu$ and $\xi_\eta\in\Xi_\eta$ over bare $\nu$ and $\eta$.

### 3.4 Retired or avoided primitive forms

The consolidated core avoids the following as primitive C4 semantics.

| Avoided form | Replacement / treatment |
|---|---|
| $\mathcal{A}_\Delta$ as non-graph delta-source domain | use $\Xi_\alpha\subseteq\Xi$ |
| $\mathcal{O}$ / generic object universe notation | use $\Xi$ |
| primitive identity | use addressability, correspondence, equivalence, or substitutability under $\mathfrak{F}$ or profile |
| “same object changed” | use profile-defined source/target correspondence plus difference interpretation |
| scalar arity as primitive endpoint axis | use graph-defined acceptance constraints over consumed forms |
| orderedness as primitive endpoint axis | represent order as graph structure or policy constraint |
| node mutation / edge mutation as primitive relator axes | represent graph-delta/materialization behavior as graph metadata or profile semantics |
| return value / return binding / return denotation as separate primitive axes | use graph-delta production and materialization-result graph-objects |

---

## 4. Integral Named Graph Containers

Let:

$$
\mathbb{G}
$$

be the universe/class of integral named graph containers.

An **integral named graph** is a graph container with a stable name and distinguished root, treated by C4 as a coherent addressable unit for resolution, traversal, persistence, and graph-container operations.

“Integral” does not mean internally structureless. An integral graph may contain arbitrary internal graph structure. It is integral only in the sense that C4 treats the graph as a named whole unless a traversal expression selects a subresource or graph-object inside it.

A specific integral named graph is written:

$$
G_j\in\mathbb{G}
$$

When describing graph-to-graph mapping, projection, migration, or alignment, source and target graph containers may be written:

$$
G_s,G_t\in\mathbb{G}
$$

C4 Core does not treat graph containers as primitive identity-bearing metaphysical objects. Graph containers are addressable structures under the active field and profile.

---

## 5. Names and Naming Domains

Let:

$$
\mathbb{N}
$$

be the universe of C4 names.

Let:

$$
\mathbb{D}
$$

be the universe of C4 naming domains.

Let $\mathbb{D}(X)$ denote the naming domains associated with objects or structures of kind $X$.

Let $\mathbb{N}(D)$ denote the names drawn from naming domain or domain-set $D$.

The graph-name domain is:

$$
\mathbb{N}_{\mathbb{G}}:=\mathbb{N}(\mathbb{D}(\mathbb{G}))
$$

A graph name is therefore:

$$
g\in\mathbb{N}_{\mathbb{G}}
$$

For a specific graph $G_j$, the graph-specific name domain may be written:

$$
\mathbb{N}_{G_j}:=\mathbb{N}(\mathbb{D}(G_j))
$$

C4 Core does not define URI schemes, network protocols, domain names, filesystem paths, `/`, or `//` as primitive mathematical operators. Such forms are surface serializations or profile-defined locator syntaxes.

Profiles may map URI-like, IRI-like, filesystem-like, package-like, registry-like, or domain-like locator systems into C4 names, but those locator systems are not part of C4 Core unless a profile explicitly maps them into C4 graph structure.

---

## 6. Graph-Object Universe

Let:

$$
\Xi
$$

be the universe of resolved C4 graph-objects.

A **C4 graph-object** is any resolved addressable graph-native object in or through the C4 substrate.

Examples include:

- node graph-objects;
- edge/traversal graph-objects;
- relator graph-objects;
- endpoint-policy graph-objects;
- statement graph-objects;
- block graph-objects;
- graph roots;
- rooted subgraphs;
- delta-source graph-objects;
- graph-delta graph-objects;
- materialization-result graph-objects;
- virtual/profile-defined graph-objects;
- projected graph-objects.

An arbitrary graph-object is written:

$$
\xi\in\Xi
$$

Profiles may define virtual, projected, or constructed graph-objects, provided their addressability and resolution behavior are defined under the active field/profile.

C4 graph-object addressability is not primitive identity. Addressability is a way to refer to graph structure under a field/profile.

---

## 7. Node and Edge/Traversal Graph-Objects

All node-role and edge/traversal-role objects are graph-objects:

$$
\Xi_\nu\subseteq\Xi
$$

$$
\Xi_\eta\subseteq\Xi
$$

where:

- $\Xi_\nu$ is the node graph-object subdomain;
- $\Xi_\eta$ is the edge/traversal graph-object subdomain.

A node graph-object is written:

$$
\xi_\nu\in\Xi_\nu
$$

An edge/traversal graph-object is written:

$$
\xi_\eta\in\Xi_\eta
$$

These subdomains are role subdomains, not necessarily disjoint ontological classes. A profile may allow a graph-object to be traversed as an edge in one context and addressed as a node-like graph-object in another.

A traversal chain is a finite ordered sequence of edge/traversal graph-objects:

$$
\vec{\eta}=\langle\eta_1,\ldots,\eta_n\rangle
$$

where:

$$
\vec{\eta}\in\mathrm{Seq}(\Xi_\eta)
$$

Traversal is written informally:

$$
\nu_{i-1}\overset{\eta_i}{\longrightarrow}\nu_i
$$

C4 Core does not treat textual path separators, URI syntax, filesystem paths, package locators, or network protocols as primitive traversal operators. Such forms may serialize or denote traversal chains under a profile.

---

## 8. Expression Domain

Let:

$$
\mathcal{E}
$$

be the domain of C4 expressions.

A C4 expression is a structured form that may denote, bind, construct, query, project, or resolve to graph structure under an active field/profile.

An arbitrary expression is written:

$$
\mathbf{x}\in\mathcal{E}
$$

Expressions are broader than resolved graph-objects.

A preliminary decomposition is:

$$
\mathcal{E}=\mathcal{E}_{trav}\cup\mathcal{E}_{lit}\cup\mathcal{E}_{bind}\cup\mathcal{E}_{list}\cup\mathcal{E}_{block}\cup\mathcal{E}_{stmt}\cup\mathcal{E}_{proj}\cup\cdots
$$

This decomposition is provisional and may be refined when canonical AST schemas are defined.

---

## 9. List Expressions

C4 list expressions are recursive structured expressions.

$$
\mathcal{E}_{list}\subseteq\mathcal{E}
$$

For any finite $n\ge 0$ and expressions $\mathbf{x}_1,\ldots,\mathbf{x}_n\in\mathcal{E}$:

$$
(\mathbf{x}_1,\ldots,\mathbf{x}_n)\in\mathcal{E}_{list}
$$

Because each list member is an arbitrary C4 expression, a list member may itself be a list expression.

C4 Core does not flatten nested lists by default.

The following are distinct unless a profile, relator, endpoint-consumption policy, or canonicalization policy explicitly equates them:

$$
(\mathbf{A},\mathbf{B},\mathbf{C})
$$

$$
(\mathbf{A},(\mathbf{B},\mathbf{C}))
$$

$$
((\mathbf{A},\mathbf{B}),\mathbf{C})
$$

Nested list, tree, sequence, tuple, set, frame, and other structured forms are graph objects or graph-described expression structures. Endpoint-consumption policies may expose, preserve, transform, or reject those structures according to graph-defined policy semantics.

---

## 10. Active Field

Let:

$$
\mathfrak{F}
$$

be the active C4 resolution/evaluation field.

The active field includes whatever graph state, bindings, loaded profiles, naming-domain bindings, canonicalization policy, validation policy, endpoint-consumption policy objects, relator metadata, graph-delta production behavior, and materialization policy are available to evaluation.

As an expression-resolution operator, the field is partial:

$$
\mathfrak{F}:\mathcal{E}\rightharpoonup\Xi
$$

Thus:

$$
\xi=\mathfrak{F}(\mathbf{x})
$$

means that expression $\mathbf{x}$ resolves to graph-object $\xi$ under active field $\mathfrak{F}$.

Name resolution under the active field is written:

$$
\mathfrak{N}_{\mathfrak{F}}:\mathbb{N}_{\mathbb{G}}\rightharpoonup\mathbb{G}
$$

If:

$$
\mathfrak{N}_{\mathfrak{F}}(g)=G_j
$$

then graph name $g$ resolves to graph container $G_j$ under active field $\mathfrak{F}$.

---

## 11. Relation-State Domain

Let:

$$
\Psi
$$

be the C4 relation-state domain.

C4 relation states are non-probabilistic. They preserve relation-state resolution, non-resolution, and superposition without requiring ranking, weighting, likelihood assignment, or forced collapse.

C4 Core defines at least the following relation-state subdomains:

$$
\Psi_\top,\Psi_\star,\Psi_\bot\subseteq\Psi
$$

where:

- $\Psi_\top$ is the resolved affirmative relation-state subdomain;
- $\Psi_\star$ is the unresolved / uncollapsed / superposed relation-state subdomain;
- $\Psi_\bot$ is the resolved negative relation-state subdomain.

Distinguished default states are:

$$
\psi_\top:=\psi_{\top,0}
$$

$$
\psi_\star:=\psi_{\star,0}
$$

$$
\psi_\bot:=\psi_{\bot,0}
$$

C4 Core also defines distinguished oriented unresolved states:

$$
\psi_{\star\top}:=\psi_{\star\top,0}\in\Psi_\star
$$

$$
\psi_{\star\bot}:=\psi_{\star\bot,0}\in\Psi_\star
$$

where:

- $\psi_{\star\top}$ is unresolved but affirmative-oriented;
- $\psi_\star$ is generic unresolved / unoriented / uncollapsed;
- $\psi_{\star\bot}$ is unresolved but negative-oriented.

The internal structure of $\Psi$ is profile-defined beyond these distinguished subdomains and states.

---

## 12. Statement Domain

A C4 statement is a complete directed relation expression with an attached relation-state.

The statement domain is:

$$
\mathrm{Stmt}=\mathcal{E}\times\mathcal{E}\times\mathcal{E}\times\Psi
$$

An individual statement is written:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

where:

- $\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t\in\mathcal{E}$;
- $\mathbf{x}_s$ is the source expression;
- $\mathbf{x}_r$ is the relator expression;
- $\mathbf{x}_t$ is the target expression;
- $\psi_k\in\Psi$ is the relation-state.

The relator expression occupies relation position. Relator-position validity is not enforced by membership in a separate primitive expression subset. Relator-position admissibility is field/profile-relative.

Source, relator, and target are expressions, not necessarily already-resolved graph-objects.

When source, relator, and target resolution succeed, the resolved graph-objects may be written:

$$
\xi_s=\mathfrak{F}(\mathbf{x}_s),\quad
\xi_r=\mathfrak{F}(\mathbf{x}_r),\quad
\xi_t=\mathfrak{F}(\mathbf{x}_t)
$$

with:

$$
\xi_s,\xi_r,\xi_t\in\Xi
$$

---

## 13. Relation-State Application Notation

C4 Core writes relation-state application as:

$$
\psi_k:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

where $\psi_k\in\Psi$.

The statement tuple:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

may therefore be written:

$$
P\equiv\psi_k:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The resolved affirmative state may be abbreviated:

$$
\psi_\top:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)\equiv\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The resolved negative state may be rendered as:

$$
\psi_\bot:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)\equiv\neg\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The unresolved state preserves unresolved non-probabilistic superposition over the relator application.

---

## 14. Endpoint-Consumption Policies

Endpoint-consumption policy is graph-native.

A structured expression in source or target position remains one expression at the statement level. C4 Core does not automatically expand list expressions into multiple statements.

For a resolved relator graph-object:

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

The policy object $\xi_\pi$ is a graph-object. It may describe:

- endpoint view or projection;
- acceptance constraints over consumed endpoint forms;
- count constraints such as exactly one, at least one, or between $m$ and $n$;
- sequence-like, set-like, tree-like, frame-like, or profile-defined consumed forms;
- structural constraints over consumed argument objects;
- recursive or non-recursive treatment of nested expressions;
- profile-defined validation behavior;
- failure or unresolved-consumption behavior.

C4 Core does not treat arity, orderedness, decomposition, list structure, tree structure, frame structure, or bounds as primitive endpoint-consumption axes. They are graph structure or graph-described constraints inside policy objects.

Earlier explanatory tuples such as $(V,A,W)$ or $(V,\beta)$ may be used as implementation-oriented normal forms, but they are not C4 Core semantics.

---

## 15. Endpoint-Consumption Compilation

Endpoint-consumption policy objects may be compiled into endpoint-consumption closures.

For endpoint policy object:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

the compiled closure is:

$$
C_{\mathfrak{F},\xi_r,p}=\mathrm{compile}_{\mathfrak{F}}(\xi_\pi)
$$

where:

$$
C_{\mathfrak{F},\xi_r,p}:\mathcal{E}\rightharpoonup\mathcal{C}
$$

and $\mathcal{C}$ is the domain of consumed endpoint forms.

Compilation is derived from the graph-native policy object. The policy graph-object remains the source of truth.

Consumed source and target endpoint forms may be written:

$$
C_s=C_{\mathfrak{F},\xi_r,source}(\mathbf{x}_s)
$$

$$
C_t=C_{\mathfrak{F},\xi_r,target}(\mathbf{x}_t)
$$

---

## 16. Relator Metadata

A relator graph-object is a graph-object admissible in relator position under an active field/profile.

For statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

if:

$$
\mathfrak{F}(\mathbf{x}_r)=\xi_r
$$

then $\xi_r\in\Xi$ is the resolved relator graph-object.

A minimally conforming relator metadata profile should represent the following as graph structure:

- relator-position admissibility;
- source endpoint-consumption policy selection;
- target endpoint-consumption policy selection;
- relation-state compatibility or state-handling behavior;
- graph-delta production semantics or reference to graph-delta production behavior;
- materialization expectations, when defined;
- graph-delta extension schema references, when defined.

C4 Core does not require primitive relator-kind axes such as assertion, query, constructor, transform, mapping, node-effect, edge-effect, return value, or yield kind.

Such categories may be graph metadata, profile-defined classes, or implementation normal forms.

Relators do not directly mutate persistent graph state in C4 Core. Relators participate in graph-delta production. Materializers interpret graph-delta objects.

---

## 17. Delta-Source Graph-Objects

Delta production is graph-native.

Let:

$$
\Xi_\alpha\subseteq\Xi
$$

be the delta-source graph-object subdomain.

A delta-source graph-object is written:

$$
\xi_\alpha\in\Xi_\alpha
$$

A delta-source graph-object is any graph-object admissible as the source of graph-delta production under an active field/profile.

Examples include:

- reified statement graph-objects;
- graph-comparison request graph-objects;
- validation/check request graph-objects;
- construction request graph-objects;
- profile-defined delta-source graph-objects.

C4 Core does not define a separate non-graph domain of delta-source forms.

---

## 18. Graph-Delta Production

The general graph-delta production operator is:

$$
\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta
$$

where:

- $\mathfrak{F}$ is the active field;
- $\Xi_\alpha$ is the delta-source graph-object subdomain;
- $\Xi_\Delta$ is the graph-delta graph-object subdomain.

For:

$$
\xi_\alpha\in\Xi_\alpha
$$

graph-delta production is written:

$$
\boldsymbol{\delta}_{\mathfrak{F}}(\xi_\alpha)=\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi_\Delta
$$

The operator is partial. It is undefined when the delta-source graph-object is not admissible, required graph structure is unavailable, or profile-relative delta-production validation fails.

---

## 19. Statement Denotation as Delta Production

Statements are graph-native delta sources when reified.

Let:

$$
\iota_P(P)\in\Xi
$$

be the graph-object reification of statement $P$.

When:

$$
\iota_P(P)\in\Xi_\alpha
$$

statement denotation is defined as:

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

Relator metadata, endpoint-consumption policies, consumed endpoint forms, and relation-state compatibility participate in determining how a statement graph-object produces its graph-delta object.

---

## 20. Graph-Delta Objects

Let:

$$
\Xi_\Delta\subseteq\Xi
$$

be the graph-delta graph-object subdomain.

A graph-delta object is written:

$$
\xi_\Delta\in\Xi_\Delta
$$

A graph-delta is a graph-object produced by graph-delta production and admissible for materialization or projection when permitted by the active field/profile.

A graph-delta may describe:

- graph contribution;
- graph change;
- graph comparison;
- construction;
- selection;
- validation/check outcome;
- projection possibility;
- diagnostic possibility;
- profile-defined graph effect or result possibility.

C4 Core does not require a fixed graph-delta schema.

A graph-delta is not an external patch blob, non-graph transaction record, or protocol envelope in C4 Core. Profiles, materializers, or Fish may project graph-deltas into patches, diagnostics, protocol responses, status codes, or result schemas.

Difference markings such as added, removed, modified, unchanged, and unresolved are appropriate for a standard comparison/diff profile, but they are not required C4 Core graph-delta structure.

C4 graph-delta interpretation is field-, profile-, materializer-, or protocol-defined.

---

## 21. Graph Comparison as Delta Production

Graph comparison is represented by delta-source graph-objects, not by primitive comparison tuples.

A graph-comparison delta-source object is written:

$$
\xi_{cmp}\in\Xi_\alpha
$$

It may contain graph structure representing source-side region, target-side region, comparison scope, correspondence/equivalence/substitution policy, comparison mode, and profile-defined metadata.

Graph comparison is performed by applying graph-delta production:

$$
\boldsymbol{\delta}_{\mathfrak{F}}(\xi_{cmp})=\xi_\Delta
$$

C4 Core does not assume primitive identity between compared graph structures.

Correspondence, equivalence, substitutability, or comparison alignment is determined by the active field and graph metadata encoded in the comparison delta-source object.

If no correspondence, equivalence, or substitution policy is supplied or derivable, a profile may still produce a structural or canonical comparison result, but C4 Core does not claim semantic identity.

---

## 22. Materialization

Let:

$$
\Xi_\mu\subseteq\Xi
$$

be the materialization-result graph-object subdomain.

A materialization-result graph-object is written:

$$
\xi_\mu\in\Xi_\mu
$$

Materialization is written:

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

The canonical graph-native pipeline is:

$$
\xi_\alpha
\overset{\boldsymbol{\delta}_{\mathfrak{F}}}{\longmapsto}
\xi_\Delta
\overset{\mathbf{m}_{\mathfrak{F}}}{\longmapsto}
\xi_\mu
$$

where:

$$
\xi_\alpha\in\Xi_\alpha,
\quad
\xi_\Delta\in\Xi_\Delta,
\quad
\xi_\mu\in\Xi_\mu
$$

C4 Core defines $\Xi_\mu$ as a role/subdomain but does not define a fixed materialization-result schema.

---

## 23. Blocks

A C4 block is an ordered sequence of statements:

$$
\mathrm{Block}=\mathrm{Seq}(\mathrm{Stmt})
$$

An individual block is written:

$$
B=\langle P_1,\ldots,P_n\rangle
$$

Source order is preserved unless an explicit profile defines another ordering or canonicalization policy.

Blocks may introduce binding scope, query scope, declaration scope, or local relator-definition scope under the active grammar/profile.

A block may itself be treated as a graph-object when canonicalized.

---

## 24. Statement and Block Graph-Objects

C4 statements and blocks are reifiable graph-objects.

Let:

$$
\iota_P:\mathrm{Stmt}\to\Xi
$$

map each canonical statement to its statement graph-object.

Let:

$$
\iota_B:\mathrm{Block}\to\Xi
$$

map each canonical block to its block graph-object.

Context, provenance, source attribution, modality, temporal validity, and related qualifiers are not primitive slots of $P$. They should be represented as ordinary graph structure about the statement graph-object $\iota_P(P)$.

C4 Core does not require primitive identity for statement objects. Statement graph-objects are addressable/reifiable graph structures under canonicalization and active profile.

---

## 25. Canonicalization

Let:

$$
\kappa
$$

be canonicalization.

For a surface language $L$, parsing and canonicalization are separated:

$$
\mathrm{parse}_L:\Sigma_L^*\rightharpoonup AST_L
$$

$$
\kappa_L:AST_L\rightharpoonup\mathrm{Stmt}\cup\mathrm{Block}\cup\mathcal{E}
$$

Canonical equivalence is defined over canonical C4 structures:

$$
a\equiv_{C4}b\iff\kappa(a)=\kappa(b)
$$

when both sides are defined.

Surface-language-specific parsing and canonicalization are instances of this general form, not the definition of C4 itself.

---

## 26. Validation Stages

Validation is profile-relative.

C4 Core names the following validation stages without requiring one universal validator implementation:

- expression-resolution validation;
- relator-position admissibility validation;
- endpoint-policy lookup validation;
- endpoint-consumption validation;
- relation-state compatibility validation;
- consumed endpoint form validation;
- delta-source admissibility validation;
- graph-delta production validation;
- graph-comparison policy validation;
- materialization preflight validation;
- profile-defined validation.

For a statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

strict validation may require:

- source, relator, and target expressions to be resolvable or acceptably unresolved;
- $\mathbf{x}_r$ to be admissible in relator position;
- endpoint policies to be resolvable for source and target positions;
- endpoint consumption to succeed or produce an accepted unresolved form;
- relation-state $\psi_k$ to be compatible with the resolved relator metadata;
- the statement graph-object $\iota_P(P)$ to be admissible as a delta source if denotation is requested.

Validation diagnostics are graph-native or profile-defined. Fish may project them into diagnostic envelopes, but such envelopes are not C4 Core semantics.

---

## 27. No Primitive Identity

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

A modified structure, when such marking exists in a profile, means source-side and target-side structures are accepted as corresponding and differ under the active comparison policy. It does not require primitive identity.

---

## 28. Protocol Boundary: C4 and Fish

C4 Core defines graph-native calculus semantics.

Fish defines syntax, protocol projections, status registries, request/response forms, result-schema negotiation, graph-delta projections, materialization-result projections, compact identifiers, and transport/interchange behavior.

Fish may project C4 graph-objects into:

- source syntax;
- request fish;
- response graphs;
- status-only graph responses;
- status enum projections;
- status-word/bit-vector projections;
- optional numeric compatibility codes;
- diagnostic envelopes;
- graph-delta/fond projections;
- materialization-result projections;
- protocol envelopes.

These projections do not replace C4 graph-native semantics.

C4 Core does not define Fish status codes, Fish response schemas, Fish request envelopes, or compact Fish ID encodings.

---

## 29. Open Questions

The following remain open for future formalization:

- exact canonical AST schema for $\mathcal{E}$;
- exact graph schema for endpoint-consumption policy objects in standard profiles;
- exact standard relator metadata vocabulary;
- whether $\Xi_\alpha$, $\Xi_\Delta$, and $\Xi_\mu$ should be fixed subdomains or profile-relative predicates over $\Xi$;
- exact standard comparison/diff profile, including added/removed/modified/unchanged/unresolved markings;
- exact graph schema for common materialization-result profiles;
- whether materializer graph-objects should have their own subdomain;
- how validation diagnostics should be represented graph-natively in standard profiles;
- how canonicalization interacts with profile-defined virtual/projected graph-objects;
- which Fish specifications should be normative dependencies for particular C4 profiles.
