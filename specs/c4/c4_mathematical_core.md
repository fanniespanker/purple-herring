# C4 Mathematical Core v0.1.6 Draft

## Status

This document defines a preliminary mathematical core for C4 v0.1.6.

It stabilizes the abstract C4 model independently of any particular surface syntax.

C4 Core terminology SHOULD avoid surface-language-specific terminology except when explicitly describing a serialization mapping.

This consolidated draft incorporates the graph-object notation, graph-native endpoint-consumption policy, endpoint-consumption compilation, and graph-delta relator-denotation addenda.

---

## 1. Terminology Layers

C4 Core uses serialization-neutral terminology.

| C4 Core | Surface-language analogue |
|---|---|
| statement | serialized relation statement |
| block | serialized statement block |
| source | left/source endpoint |
| relator | relation-position connector/template/operator |
| target | right/target endpoint |
| relation-state | surface statement-state marker |
| graph-object | resolved addressable graph-native object |
| field | active resolution/evaluation field |

C4 Core MUST NOT require surface-language terminology for its abstract definitions.

A **relator** is an expression occupying relation position in a C4 statement. It determines the semantic relation, connector, template, or relational operation applied between a source expression and a target expression under a relation-state.

---

## 2. Core Notation Universes

C4 Core uses the following primary universes and domains.

| Symbol | Meaning |
|---|---|
| $\mathbb{N}$ | universe of C4 names |
| $\mathbb{D}$ | universe of C4 naming domains |
| $\mathbb{G}$ | universe/class of integral named graph containers |
| $\Xi$ | universe of resolved C4 graph-objects |
| $\mathcal{E}$ | expression domain |
| $\Psi$ | relation-state domain |

In this specification, $\mathbb{N}$ denotes the universe of C4 names. Natural-number counts SHOULD be written as $\mathbb{Z}_{\ge 0}$ or with an explicit numeric constraint notation rather than bare $\mathbb{N}$.

---

## 3. Integral Named Graphs

Let:

$$
\mathbb{G}
$$

be the universe/class of integral named graph containers.

An **integral named graph** is a graph container with a stable name and distinguished root, treated by C4 as a coherent identity-bearing unit for resolution, traversal, persistence, and addressability.

“Integral” does not mean internally structureless. An integral graph MAY contain arbitrary internal graph structure. It is integral only in the sense that C4 treats the graph as a named whole unless a traversal expression selects a subresource or graph-object inside it.

An arbitrary specific integral named graph is written:

$$
G_j \in \mathbb{G}
$$

When describing graph-to-graph mapping, projection, migration, or alignment, source and target graphs MAY be written:

$$
G_s,G_t \in \mathbb{G}
$$

An integral named graph may be represented abstractly as:

$$
G_j = (n,V,E,r,\ell)
$$

where:

- $n$ is the graph name;
- $V$ is the node-role object set or vertex-like structure;
- $E$ is the edge / relation / traversal structure;
- $r$ is the distinguished root graph-object;
- $\ell$ is a labelling function.

The exact internal structure of $V$, $E$, and $\ell$ is profile-defined. In C4 graph-native implementations, $E$ SHOULD be understood as relation-mediated graph structure rather than as only untyped binary edges.

---

## 4. Names and Naming Domains

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

Let:

$$
\mathbb{D}(X)
$$

denote the naming domains associated with objects or structures of kind $X$.

Let:

$$
\mathbb{N}(D)
$$

denote the names drawn from naming domain or domain-set $D$.

The graph-name domain is:

$$
\mathbb{N}_{\mathbb{G}} := \mathbb{N}(\mathbb{D}(\mathbb{G}))
$$

where $\mathbb{G}$ is the universe/class of integral named graph containers.

A graph name is therefore:

$$
g \in \mathbb{N}_{\mathbb{G}}
$$

For a specific graph $G_j$, the graph-specific name domain MAY be written:

$$
\mathbb{N}_{G_j} := \mathbb{N}(\mathbb{D}(G_j))
$$

For source and target graphs, graph-specific name domains MAY be written:

$$
\mathbb{N}_{G_s},\mathbb{N}_{G_t}
$$

C4 Core does not define URI schemes, network protocols, domain names, filesystem paths, `/`, or `//` as primitive mathematical operators. Such forms are surface serializations or profile-defined locator syntaxes.

Profiles MAY map URI-like, IRI-like, filesystem-like, package-like, registry-like, or domain-like locator systems into C4 names, but those locator systems are not part of C4 Core identity unless a profile explicitly makes them so.

---

## 5. Graph-Object Universe

Let:

$$
\Xi
$$

be the universe of resolved C4 graph-objects.

A **C4 graph-object** is any resolved addressable graph-native object in the C4 substrate, including ordinary node-like objects, edge/traversal objects, relator objects, statement objects, block objects, graph roots, rooted subgraphs, graph-delta objects, endpoint-policy objects, virtual/profile-defined objects, and projected objects.

An arbitrary graph-object is written:

$$
\xi\in\Xi
$$

This notation replaces the earlier generic object notation:

$$
\mathcal{O},o
$$

with:

$$
\Xi,\xi
$$

The replacement emphasizes that resolved C4 objects are graph-native and need not be treated as non-graph resources external to the substrate.

Profiles MAY define virtual, projected, or constructed graph-objects, provided they canonicalize to stable graph-object identities.

---

## 6. Node-Role and Edge-Role Graph-Objects

C4 distinguishes graph-object unity from graph-role notation.

All node-role and edge-role objects are graph-objects:

$$
\Xi_\nu\subseteq\Xi
$$

$$
\Xi_\eta\subseteq\Xi
$$

where:

- $\Xi_\nu$ is the node-role graph-object subdomain;
- $\Xi_\eta$ is the edge/traversal-role graph-object subdomain.

A graph-object in node role is written:

$$
\nu\in\Xi_\nu
$$

A graph-object in edge/traversal role is written:

$$
\eta\in\Xi_\eta
$$

The subdomains $\Xi_\nu$ and $\Xi_\eta$ are role subdomains, not necessarily disjoint ontological classes. A profile MAY allow a graph-object to be traversed as an edge in one context and addressed as a node-like object in another context.

Thus:

$$
\nu\in\Xi_\nu\subseteq\Xi
$$

and:

$$
\eta\in\Xi_\eta\subseteq\Xi
$$

while:

$$
\xi\in\Xi
$$

remains the notation for an arbitrary graph-object without specifying node-role or edge-role participation.

---

## 7. Expression Domain

Let:

$$
\mathcal{E}
$$

be the domain of C4 expressions.

A C4 expression is a structured form that may denote, bind, construct, query, project, or resolve to a graph-object.

An arbitrary expression is written:

$$
\mathbf{x}\in\mathcal{E}
$$

Expressions are broader than resolved graph-objects.

Object-denoting traversal expressions are one subdomain of $\mathcal{E}$, not the whole expression domain.

A preliminary decomposition is:

$$
\mathcal{E} =
\mathcal{E}_{trav}
\cup
\mathcal{E}_{lit}
\cup
\mathcal{E}_{bind}
\cup
\mathcal{E}_{list}
\cup
\mathcal{E}_{block}
\cup
\mathcal{E}_{stmt}
\cup
\mathcal{E}_{proj}
\cup
\cdots
$$

where:

- $\mathcal{E}_{trav}$ contains traversal expressions;
- $\mathcal{E}_{lit}$ contains literal expressions;
- $\mathcal{E}_{bind}$ contains anonymous, scoped, and query binding expressions;
- $\mathcal{E}_{list}$ contains list expressions;
- $\mathcal{E}_{block}$ contains block expressions;
- $\mathcal{E}_{stmt}$ contains statement-reference expressions;
- $\mathcal{E}_{proj}$ contains projection / mapping expressions.

This decomposition is provisional and SHOULD be refined when the exact canonical AST schema is defined.

---

## 8. List Expressions

C4 list expressions are recursive structured expressions.

$$
\mathcal{E}_{list}\subseteq\mathcal{E}
$$

For any finite $n\ge 0$ and expressions $\mathbf{x}_1,\ldots,\mathbf{x}_n\in\mathcal{E}$:

$$
(\mathbf{x}_1,\ldots,\mathbf{x}_n)\in\mathcal{E}_{list}
$$

Because each list member is an arbitrary C4 expression, a list member MAY itself be a list expression. Therefore nested lists are valid C4 expressions:

$$
(\mathbf{A},(\mathbf{B},\mathbf{C}),\mathbf{D})\in\mathcal{E}_{list}
$$

C4 Core does not flatten nested lists by default.

The following expressions are distinct unless a profile, relator, endpoint-consumption policy object, or canonicalization policy explicitly equates them:

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

## 9. Active Field

Let:

$$
\mathfrak{F}
$$

be the active C4 resolution/evaluation field.

The active field includes whatever graph state, bindings, loaded profiles, naming-domain bindings, canonicalization policy, validation policy, endpoint-consumption policy objects, relator semantics, and materialization policy are available to evaluation.

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

then graph name $g$ resolves to integral named graph $G_j$ under active field $\mathfrak{F}$.

The symbol $\mathfrak{F}$ replaces earlier uses of $\Gamma$ as the active environment. The symbol $\mathfrak{N}_{\mathfrak{F}}$ replaces earlier uses of $\chi_\Gamma$ for graph-name resolution.

---

## 10. Traversal Edges and Traversal Chains

A traversal edge is a graph-object in edge/traversal role:

$$
\eta\in\Xi_\eta
$$

A traversal chain is a finite sequence of traversal-edge graph-objects:

$$
\vec{\eta}=\langle\eta_1,\ldots,\eta_n\rangle
$$

where:

$$
\vec{\eta}\in\mathrm{Seq}(\Xi_\eta)
$$

Traversal is written:

$$
\nu_{i-1}\overset{\eta_i}{\longrightarrow}\nu_i
$$

where:

$$
\nu_{i-1},\nu_i\in\Xi_\nu
$$

and:

$$
\eta_i\in\Xi_\eta
$$

A traversal chain determines a path through graph-objects when there exist node-role graph-objects:

$$
\nu_0,\ldots,\nu_n\in\Xi_\nu
$$

such that:

$$
\nu_0
\overset{\eta_1}{\longrightarrow}
\nu_1
\overset{\eta_2}{\longrightarrow}
\cdots
\overset{\eta_n}{\longrightarrow}
\nu_n
$$

Traversal-chain resolution under field $\mathfrak{F}$ is written:

$$
\mathfrak{F}_{\vec{\eta}}(\nu_0)=\nu_n
$$

when every traversal edge is defined and admissible under $\mathfrak{F}$.

C4 Core does not treat textual path separators, IRI separators, URI syntax, filesystem paths, package locators, or network protocols as primitive traversal operators. Such forms MAY serialize or denote traversal chains under a profile, but the formal traversal chain is a sequence of edge/traversal graph-objects.

Indexed notation such as $\nu_i$ is used for the $i$th node-role graph-object in a particular traversal chain. It SHOULD NOT be confused with a graph-object denoted by a name, resource expression, or path-like expression.

For a name or designator $n$, denotation under field $\mathfrak{F}$ SHOULD be written:

$$
\mathfrak{F}(n)=\xi
$$

or, when a compact derived notation is useful:

$$
\xi_{\mathfrak{F}}(n)
$$

The notation $\xi_n$ SHOULD be reserved for indexed graph-objects in an explicitly described sequence, not for arbitrary resource-path denotation.

---

## 11. Relation-State Domain

Let:

$$
\Psi
$$

be the C4 relation-state domain.

C4 relation states are non-probabilistic. They preserve relation-state resolution, non-resolution, and superposition without requiring ranking, weighting, likelihood assignment, or forced collapse. Profiles MAY define weighted, probabilistic, preferential, or collapse procedures, but such structures are not part of C4 Core.

C4 Core defines at least the following relation-state subdomains:

$$
\Psi_\top,\Psi_\star,\Psi_\bot \subseteq \Psi
$$

where:

- $\Psi_\top$ is the resolved affirmative relation-state subdomain;
- $\Psi_\bot$ is the resolved negative relation-state subdomain;
- $\Psi_\star$ is the unresolved / uncollapsed / superposed relation-state subdomain.

C4 Core does not require these subdomains to exhaust $\Psi$.

Arbitrary members MAY be written:

$$
\psi_{\top,k}\in\Psi_\top
$$

$$
\psi_{\star,k}\in\Psi_\star
$$

$$
\psi_{\bot,k}\in\Psi_\bot
$$

The canonical/default distinguished states are:

$$
\psi_\top := \psi_{\top,0}
$$

$$
\psi_\star := \psi_{\star,0}
$$

$$
\psi_\bot := \psi_{\bot,0}
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
\mathrm{Stmt}
=
\mathcal{E}
\times
\mathcal{E}
\times
\mathcal{E}
\times
\Psi
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

The relator expression occupies relation position. Relator-position validity is not enforced by membership in a separate primitive expression subset. Instead, relator-position admissibility is determined by profile-relative validation predicates such as $\mathrm{RelOk}_{\mathfrak{F}}(\mathbf{x}_r)$.

Source, relator, and target are expressions, not necessarily already-resolved graph-objects.

When source, relator, and target resolution succeed, the resolved graph-objects may be written:

$$
\xi_s=\mathfrak{F}(\mathbf{x}_s)
$$

$$
\xi_r=\mathfrak{F}(\mathbf{x}_r)
$$

$$
\xi_t=\mathfrak{F}(\mathbf{x}_t)
$$

with:

$$
\xi_s,\xi_r,\xi_t\in\Xi
$$

---

## 13. Endpoint Consumption Policies

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

the endpoint-consumption policy object is written:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

where:

$$
\xi_\pi\in\Xi
$$

The policy object $\xi_\pi$ is a graph-object. It MAY describe:

- the endpoint view or projection to apply;
- the top-level argument units exposed by that view;
- count constraints such as exactly one, at least one, or between $m$ and $n$;
- whether the consumed endpoint form is sequence-like, set-like, tree-like, frame-like, or profile-defined;
- structural constraints over consumed argument objects;
- recursive or non-recursive treatment of nested list expressions;
- profile-defined validation rules;
- provenance and diagnostic preservation rules.

C4 Core does not treat arity, orderedness, decomposition, list structure, tree structure, frame structure, or bounds as primitive endpoint-consumption axes.

Those concepts are graph structure or graph-described constraints inside $\xi_\pi$.

Earlier explanatory tuples such as:

$$
(V,A,W)
$$

or:

$$
(V,\beta)
$$

MAY be used as implementation-oriented normal forms, but they are not the source of truth for graph-native C4 endpoint-consumption semantics.

---

## 14. Endpoint Consumption Compilation

Endpoint-consumption policy objects MAY be compiled into endpoint-consumption closures.

For endpoint policy object:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

the compiled closure is written:

$$
C_{\mathfrak{F},\xi_r,p}=\mathrm{compile}_{\mathfrak{F}}(\xi_\pi)
$$

where:

$$
C_{\mathfrak{F},\xi_r,p}:\mathcal{E}\rightharpoonup\mathcal{C}
$$

and $\mathcal{C}$ is the domain of consumed endpoint forms.

The closure is partial. It is undefined if the endpoint expression cannot be consumed according to the policy object, if required resolution fails, or if profile-relative consumption validation fails.

Compilation MAY derive optimized normal forms from the policy graph, including tuple-like implementation forms such as:

$$
(V,A,W)
$$

or:

$$
(V,\beta)
$$

provided those forms remain derived projections of the policy object $\xi_\pi$.

Implementations MAY cache, fuse, specialize, lazily evaluate, or prevalidate compiled endpoint-consumption closures, provided canonical behavior is preserved.

Useful cache keys include:

$$
(\mathfrak{F},\xi_r,p)
$$

and:

$$
(\mathfrak{F},\xi_\pi)
$$

Consumed source and target endpoint forms are written:

$$
C_s=C_{\mathfrak{F},\xi_r,source}(\mathbf{x}_s)
$$

$$
C_t=C_{\mathfrak{F},\xi_r,target}(\mathbf{x}_t)
$$

---

## 15. Relation-State Application Notation

C4 Core writes relation-state application as:

$$
\psi_k:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

where $\psi_k\in\Psi$.

The operator `:` applies a relation-state to the relator application $\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)$.

The statement tuple:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

may therefore be written:

$$
P\equiv\psi_k:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The resolved affirmative state is abbreviated:

$$
\psi_\top:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
\equiv
\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The resolved negative state is interpreted as:

$$
\psi_\bot:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
\equiv
\neg\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

The generic unresolved state:

$$
\psi_\star:\mathbf{x}_r(\mathbf{x}_s,\mathbf{x}_t)
$$

preserves unresolved non-probabilistic superposition over the relator application.

---

## 16. Resolved Statements

A statement may be resolved under active field $\mathfrak{F}$ when its source, relator, and target expressions resolve to C4 graph-objects.

For:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

if:

$$
\mathfrak{F}(\mathbf{x}_s)=\xi_s
$$

$$
\mathfrak{F}(\mathbf{x}_r)=\xi_r
$$

$$
\mathfrak{F}(\mathbf{x}_t)=\xi_t
$$

then the resolved statement is written:

$$
\widehat{P}_{\mathfrak{F}}=(\xi_s,\xi_r,\xi_t,\psi_k)
$$

where:

$$
\xi_s,\xi_r,\xi_t\in\Xi
$$

and:

$$
\psi_k\in\Psi
$$

Resolution of $P$ is partial. If any required expression fails to resolve under $\mathfrak{F}$, then $\widehat{P}_{\mathfrak{F}}$ is undefined unless a profile defines a partial-resolution or unresolved graph-object representation.

Resolved statements are not necessarily valid statements. Validation remains profile-relative and may reject a resolved statement whose relator, endpoint types, relation-state, endpoint-consumption policy, or profile constraints are inadmissible.

---

## 17. Relator Denotation and Graph-Delta Objects

A relator denotation consumes endpoint forms and yields a C4 graph-object describing the denoted graph contribution, graph update, graph selection, graph check, construction, or profile-defined graph effect.

For resolved relator graph-object:

$$
\xi_r\in\Xi
$$

relator denotation is written:

$$
\mathbf{d}_{\mathfrak{F},\xi_r}:\mathcal{C}\times\mathcal{C}\times\Psi\rightharpoonup\Xi
$$

For statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

where:

$$
\mathfrak{F}(\mathbf{x}_r)=\xi_r
$$

and consumed endpoint forms are:

$$
C_s=C_{\mathfrak{F},\xi_r,source}(\mathbf{x}_s)
$$

$$
C_t=C_{\mathfrak{F},\xi_r,target}(\mathbf{x}_t)
$$

statement denotation is:

$$
\mathbf{d}_{\mathfrak{F}}(P)
=
\mathbf{d}_{\mathfrak{F},\xi_r}(C_s,C_t,\psi_k)
=
\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi
$$

The graph-delta object $\xi_\Delta$ describes what the relator application denotes: what would change, what has changed, what is selected, what is checked, what is constructed, or what profile-defined graph effect is represented.

The graph-delta object is reified C4 graph data. It need not imply immediate mutation of persistent graph state.

Relator denotation behavior SHOULD be described by graph metadata on the relator object and related policy objects. C4 Core does not require primitive relator-kind axes such as node-effect, edge-effect, return value, graph effect kind, or yield kind.

Edges, nodes, statements, blocks, relators, graph roots, graph deltas, and profile-defined structures are all C4 graph-objects. Therefore graph update or selection semantics SHOULD be represented by the yielded graph-delta object $\xi_\Delta$ and its graph structure, not by a primitive relator-effect tuple.

Materialization is the interpretation or application of a graph-delta object:

$$
\mathbf{m}_{\mathfrak{F}}(\xi_\Delta)
$$

Materialization MAY produce graph patches, derived statements, indexes, projected resources, diagnostics, or no persistent mutation.

Materialization permissions and requirements SHOULD be represented as graph metadata on $\xi_\Delta$, on its graph-delta type, or in the active profile.

---

## 18. Blocks

A C4 block is an ordered sequence of statements:

$$
\mathrm{Block} =
\mathrm{Seq}(\mathrm{Stmt})
$$

An individual block is written:

$$
B=\langle P_1,\ldots,P_n\rangle
$$

Source order is preserved unless an explicit profile defines another ordering or canonicalization policy.

Blocks MAY introduce binding scope, query scope, declaration scope, or local relator-definition scope under the active grammar/profile.

A block MAY itself be treated as a graph-object when canonicalized.

---

## 19. Statement and Block Graph-Objects

C4 statements and blocks are reifiable graph-objects.

Let:

$$
\iota_P:\mathrm{Stmt}\to\Xi
$$

map each canonical statement to its statement-object identity.

Let:

$$
\iota_B:\mathrm{Block}\to\Xi
$$

map each canonical block to its block-object identity.

If two surface forms canonicalize to the same statement, they MUST have the same statement-object identity.

Formally, for a canonicalization function $\kappa$:

$$
\kappa(a)=\kappa(b)
\implies
\iota_P(\kappa(a))=\iota_P(\kappa(b))
$$

when $\kappa(a),\kappa(b)\in\mathrm{Stmt}$.

Context, provenance, source attribution, modality, temporal validity, and related qualifiers are not primitive slots of $P$. They SHOULD be represented as ordinary C4 statements about the statement graph-object $\iota_P(P)$.

For example, contextualization may be represented as:

$$
P_c=(\iota_P(P),\mathbf{x}_{ctx},\mathbf{x}_c,\psi_\top)
$$

where $\mathbf{x}_{ctx},\mathbf{x}_c\in\mathcal{E}$.

Exact surface syntax for addressing a statement object or block object is deferred beyond this mathematical core.

---

## 20. Canonicalization

Let:

$$
\kappa
$$

be canonicalization.

For a surface language $L$, parsing and canonicalization are separated:

$$
\mathrm{parse}_{L}:\Sigma_L^*\rightharpoonup AST_L
$$

$$
\kappa_L:AST_L\rightharpoonup\mathrm{Stmt}\cup\mathrm{Block}\cup\mathcal{E}
$$

Canonical equivalence is defined over canonical C4 structures:

$$
a\equiv_{C4}b
\iff
\kappa(a)=\kappa(b)
$$

when both sides are defined.

Surface-language-specific parsing and canonicalization are instances of this general form, not the definition of C4 itself.

---

## 21. Validation

Validation is profile-relative.

Let:

$$
\mathrm{diag}_{\mathfrak{F}}
$$

be the validation diagnostic function:

$$
\mathrm{diag}_{\mathfrak{F}}:\mathrm{Stmt}\cup\mathrm{Block}\to\mathrm{Seq}(\mathrm{Diagnostic})
$$

A statement or block is valid under $\mathfrak{F}$ iff its diagnostic sequence is empty under a strict validation profile:

$$
\mathrm{valid}_{\mathfrak{F}}(X)
\iff
\mathrm{diag}_{\mathfrak{F}}(X)=\varnothing
$$

For a statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

strict validation MAY require:

$$
\mathrm{RelOk}_{\mathfrak{F}}(\mathbf{x}_r)
\land
\mathrm{SrcOk}_{\mathfrak{F}}(\mathbf{x}_s,\mathbf{x}_r)
\land
\mathrm{TgtOk}_{\mathfrak{F}}(\mathbf{x}_t,\mathbf{x}_r)
\land
\mathrm{StateOk}_{\mathfrak{F}}(\psi_k,\mathbf{x}_r)
\land
\mathrm{ConsumeOk}_{\mathfrak{F}}(\mathbf{x}_r,source,\psi_k,\mathbf{x}_s)
\land
\mathrm{ConsumeOk}_{\mathfrak{F}}(\mathbf{x}_r,target,\psi_k,\mathbf{x}_t)
$$

Validation MAY inspect:

- relator-position admissibility;
- source-position admissibility;
- target-position admissibility;
- relation-state support;
- endpoint-consumption policy objects;
- compiled endpoint-consumption closures;
- relator denotation metadata;
- graph-delta materialization constraints;
- binding-kind consistency;
- local declaration availability;
- loaded modules;
- ontology/profile constraints;
- canonicalization policy.

Parsing, canonicalization, resolution, denotation, materialization, and validation are distinct operations.

An unknown relator may parse and canonicalize as a statement while failing validation under a strict profile.

---

## 22. Notation Migration Summary

This consolidated draft applies the following notation migrations.

| Earlier notation | Consolidated notation |
|---|---|
| $\mathcal{O}$ | $\Xi$ |
| $o$ | $\xi$ |
| $\Gamma$ | $\mathfrak{F}$ |
| $\chi_\Gamma$ | $\mathfrak{N}_{\mathfrak{F}}$ |
| $\mathcal{G}$ | $\mathbb{G}$ |
| $\mathcal{N}$ | $\mathbb{N}$ |
| $\mathcal{D}$ | $\mathbb{D}$ |
| $\mathbf{s},\mathbf{r},\mathbf{t}$ | $\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t$ |
| $o_s,o_r,o_t$ | $\xi_s,\xi_r,\xi_t$ |
| $o_\pi$ | $\xi_\pi$ |
| $o_\Delta$ | $\xi_\Delta$ |
| traversal-step domain $\mathcal{T}$ | edge-role graph-object subdomain $\Xi_\eta$ |
| traversal chain $\gamma$ | traversal chain $\vec{\eta}$ |
| $\mathrm{Den}$ / $\mathrm{den}$ | $\mathbf{d}$ |
| $\mathrm{Mat}$ | $\mathbf{m}$ |

---

## 23. Open Questions

The following remain open for future formalization:

- exact recursive definition of $\mathcal{E}$ beyond the provisional decomposition;
- exact canonical AST schema;
- whether $\Xi_\nu$ and $\Xi_\eta$ should be profile-relative predicates rather than fixed subdomains;
- whether traversal endpoints must always be node-role graph-objects $\nu\in\Xi_\nu$, or whether arbitrary graph-objects $\xi\in\Xi$ may appear as traversal endpoints under some profiles;
- whether $\mathfrak{F}$ fully replaces $\Gamma$ in all auxiliary documents or whether historical notes preserve $\Gamma$;
- exact minimal graph schema for edge/traversal graph-objects $\eta$;
- exact minimal graph schema for endpoint-consumption policy objects $\xi_\pi$;
- standard library names for common endpoint-consumption policy objects;
- exact representation of consumed endpoint forms $\mathcal{C}$;
- whether consumed endpoint forms are themselves always C4 graph-objects or may remain operational forms;
- exact representation of graph-delta objects $\xi_\Delta$;
- whether graph-delta objects are always persistent, virtual, or profile-dependent;
- exact relationship between graph-delta objects and materialized graph patches;
- whether member-interpretation modes should be standardized or remain purely profile-defined;
- whether state compatibility should be represented by standard relator metadata relations;
- exact relationship between graph names, locator profiles, and integral named graphs;
- exact relationship between integral named graphs and virtual/projected graph-objects;
- exact surface syntax for statement-object and block-object addressing;
- exact conformance levels for parsers, canonicalizers, validators, emitters, field loaders, endpoint-policy compilers, and materializers.
