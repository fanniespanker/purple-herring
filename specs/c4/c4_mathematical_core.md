# C4 Mathematical Core v0.1.6 Draft

## Status

This document defines a preliminary mathematical core for C4 v0.1.6.

It stabilizes the abstract C4 model independently of any particular surface syntax.

C4 Core terminology SHOULD avoid surface-language-specific terminology except when explicitly describing a serialization mapping.

Future drafts SHOULD either incorporate this material into the C4 Core Specification or preserve it as the normative mathematical appendix for the C4 v0.1.x series.

---

## 1. Terminology Layers

C4 Core uses serialization-neutral terminology.

| C4 Core | Surface-language analogue |
|---|---|
| statement | serialized relation statement |
| block | serialized statement block |
| source | left/source endpoint |
| target | right/target endpoint |
| relation-state | surface statement-state marker |
| object | resolved addressable resource |

C4 Core MUST NOT require surface-language terminology for its abstract definitions.

---

## 2. Integral Named Graphs

Let:

$$
\mathcal{G}
$$

be the class of integral named graphs.

An **integral named graph** is a graph with a stable name and distinguished root, treated by C4 as a coherent identity-bearing unit for resolution, traversal, persistence, and addressability.

“Integral” does not mean internally structureless. An integral graph MAY contain arbitrary internal graph structure. It is integral only in the sense that C4 treats the graph as a named whole unless a traversal expression selects a subresource.

An arbitrary specific integral named graph is written:

$$
G_j \in \mathcal{G}
$$

When describing graph-to-graph mapping, projection, migration, or alignment, source and target graphs MAY be written:

$$
G_s,G_t \in \mathcal{G}
$$

An integral named graph may be represented as:

$$
G_j = (n,V,E,r,\ell)
$$

where:

- $n$ is the graph name;
- $V$ is the node set;
- $E$ is the edge / relation / traversal structure;
- $r \in V$ is the distinguished root node;
- $\ell$ is a labelling function.

The exact internal structure of $E$ is profile-defined. In C4 graph-native implementations, $E$ SHOULD be understood as relation-mediated graph structure rather than as only untyped binary edges.

---

## 3. Graph Names

Let:

$$
\mathcal{N}
$$

be the universe of names.

Let:

$$
\mathcal{D}(X)
$$

denote the set of naming domains associated with objects of kind $X$.

Let:

$$
\mathcal{N}(D)
$$

denote the set of names drawn from naming domains $D$.

The graph-name domain is:

$$
\mathcal{N}_G := \mathcal{N}(\mathcal{D}(\mathcal{G}))
$$

where $\mathcal{G}$ is the class of integral named graphs.

A graph name is therefore:

$$
g \in \mathcal{N}_G
$$

For a specific graph $G_j$, the graph-specific name domain MAY be written:

$$
\mathcal{N}_{G_j} := \mathcal{N}(\mathcal{D}(G_j))
$$

For source and target graphs, graph-specific name domains MAY be written:

$$
\mathcal{N}_{G_s},\mathcal{N}_{G_t}
$$

Graph-name resolution is environment-relative:

$$
\chi_\Gamma : \mathcal{N}_G \rightharpoonup \mathcal{G}
$$

If:

$$
\chi_\Gamma(g)=G_j
$$

then $G_j$ is the integral named graph resolved from graph name $g$ under environment $\Gamma$.

C4 Core does not define URI schemes, network protocols, domain names, filesystem paths, `/`, or `//` as primitive mathematical operators. Such forms are surface serializations or profile-defined locator syntaxes.

Profiles MAY map URI-like, IRI-like, filesystem-like, package-like, registry-like, or domain-like locator systems into graph names, but those locator systems are not part of C4 Core graph identity unless a profile explicitly makes them so.

---

## 4. Object Universe

Let:

$$
\mathcal{O}
$$

be the universe of C4 objects.

A **C4 object** is any resolved addressable resource, including ordinary resources, relation resources, statement resources, block resources, graph roots, rooted subgraphs, profile-defined virtual resources, and profile-defined projected resources.

In the core graph model, an object may be represented as a rooted subgraph selected from an integral named graph.

Let:

$$
\mathcal{T}_{G_j}
$$

be the traversal-step domain available in graph $G_j$.

A traversal chain over $G_j$ is:

$$
\gamma \in \mathrm{Seq}(\mathcal{T}_{G_j})
$$

An object selected from $G_j$ by traversal chain $\gamma$ is written:

$$
G_j[\gamma]
$$

The root object of $G_j$ is:

$$
G_j[\epsilon]
$$

where $\epsilon$ is the empty traversal chain.

The primary object universe is therefore:

$$
\mathcal{O}
=
\{\,G_j[\gamma] \mid G_j \in \mathcal{G},\ \gamma \in \mathrm{Seq}(\mathcal{T}_{G_j}),\ G_j[\gamma]\ \text{is defined}\,\}
$$

Profiles MAY define virtual, projected, or constructed objects, provided they canonicalize to stable object identities.

---

## 5. Expression Domain

Let:

$$
\mathcal{E}
$$

be the domain of C4 expressions.

A C4 expression is a structured form that may denote, bind, construct, query, project, or resolve to an object.

Expressions are broader than resolved objects.

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

## 6. Traversal Expressions

Let:

$$
\mathcal{T}
$$

be the traversal-step domain.

A traversal step is written:

$$
\eta \in \mathcal{T}
$$

A traversal chain is written:

$$
\gamma = \langle \eta_1,\ldots,\eta_n \rangle
$$

A traversal step may be written as a traversal operator:

$$
o_{i-1}\overset{\eta_i}{\rightarrow}o_i
$$

where $o_{i-1},o_i \in \mathcal{O}$ and $\eta_i \in \mathcal{T}$.

When discussing resolved statement endpoints, C4 uses $o_s$ and $o_t$ for the resolved source and target objects.

When discussing traversal chains, C4 uses indexed objects $o_0,\ldots,o_n$:

$$
o_{i-1}\overset{\eta_i}{\rightarrow}o_i
$$

This avoids confusing statement source/target notation with traversal-step composition.

A traversal chain determines an object path when there exist objects $o_0,\ldots,o_n$ such that:

$$
o_0
\overset{\eta_1}{\rightarrow}o_1
\overset{\eta_2}{\rightarrow}
\cdots
\overset{\eta_n}{\rightarrow}o_n
$$

In that case:

$$
\Gamma_\gamma(o_0)=o_n
$$

A traversal expression is a root object together with a traversal chain:

$$
\mathcal{E}_{trav}
=
\mathcal{O}
\times
\mathrm{Seq}(\mathcal{T})
$$

A path-like surface expression MAY serialize a rooted traversal chain, but the formal C4 traversal operator is:

$$
o_{i-1}\overset{\eta_i}{\rightarrow}o_i
$$

C4 Core does not require any particular textual path separator.

For a path component $x$, the corresponding path-component traversal operator MAY be written:

$$
\eta_{\mathrm{path}(x)}
$$

Thus a surface path-like form is a compact serialization of a rooted traversal chain, not an assertion of containment, subtype, membership, or network location unless a profile explicitly materializes such statements.

Traversal operators are profile-defined partial object-resolution operators:

$$
\eta^\Gamma : \mathcal{O} \rightharpoonup \mathcal{O}
$$

The traversal-step domain may be partitioned into profile-defined traversal classes:

$$
\mathcal{T}
=
\mathcal{T}_{sub}
\cup
\mathcal{T}_{rel}
\cup
\mathcal{T}_{path}
\cup
\mathcal{T}_{proj}
\cup
\cdots
$$

where $\mathcal{T}_{sub}$ contains subresource-selection operators, $\mathcal{T}_{rel}$ contains relation-mediated traversal operators, $\mathcal{T}_{path}$ contains path-component traversal operators, and $\mathcal{T}_{proj}$ contains projection / mapping traversal operators.

Traversal operators resolve objects. They do not themselves assert C4 statements.

A profile MAY define materialization rules that emit C4 statements corresponding to traversal behavior, but such materialization is profile-defined and not part of C4 Core traversal semantics.

---

## 7. Resolution

Let:

$$
\Gamma
$$

be the active resolution environment.

For now, $\Gamma$ SHOULD be treated as a single abstract environment object rather than as a fixed tuple of components. This keeps C4 Core from prematurely committing to an implementation layout for bindings, loaded graphs, profiles, registries, canonicalization rules, and validation policy.

The environment $\Gamma$ may provide graph-name resolution, expression resolution, binding scope, loaded profiles, ontology/template registries, canonicalization policies, validation policy, and active graph state.

As an expression-resolution operator, $\Gamma$ is partial:

$$
\Gamma : \mathcal{E} \rightharpoonup \mathcal{O}
$$

Traversal-chain resolution is also partial:

$$
\Gamma_\gamma : \mathcal{O} \rightharpoonup \mathcal{O}
$$

For:

$$
\gamma = \langle \eta_1,\ldots,\eta_n \rangle
$$

traversal resolution is:

$$
\Gamma_\gamma(o_0) =
\eta_n^{\Gamma}(\cdots\eta_2^{\Gamma}(\eta_1^{\Gamma}(o_0))\cdots)
$$

when every traversal step is defined.

Traversal expression resolution is the special case:

$$
\Gamma((o_0,\gamma)) =
\Gamma_\gamma(o_0)
$$

when the right-hand side is defined.

Graph-name resolution is separate from expression resolution:

$$
\chi_\Gamma : \mathcal{N}_G \rightharpoonup \mathcal{G}
$$

If $\chi_\Gamma(g)=G_j$, then traversal from the graph root may be written:

$$
\Gamma_\gamma(G_j[\epsilon])=G_j[\gamma]
$$

when $G_j[\gamma]$ is defined.

---

## 8. Relation-State Domain

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

## 9. Statement Domain

A C4 statement is a complete directed relation expression with an attached relation state.

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
P = (\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

where:

- $\mathbf{s},\mathbf{r},\mathbf{t} \in \mathcal{E}$;
- $\mathbf{s}$ is the source expression;
- $\mathbf{r}$ is the relation-position expression;
- $\mathbf{t}$ is the target expression;
- $\psi_k \in \Psi$ is the relation state.

Relations are expressions. Relation-position validity is not enforced by membership in a separate primitive expression subset. Instead, relation-position admissibility is determined by profile-relative validation predicates such as $\mathrm{RelOk}_\Gamma(\mathbf{r})$.

Source, relation, and target are expressions, not necessarily already-resolved objects.

When source, relation, and target resolution succeed, the resolved objects may be written:

$$
o_s=\Gamma(\mathbf{s})
$$

$$
o_r=\Gamma(\mathbf{r})
$$

$$
o_t=\Gamma(\mathbf{t})
$$

with $o_s,o_r,o_t \in \mathcal{O}$.

---

## 10. Relation-State Application Notation

C4 Core writes relation-state application as:

$$
\psi_k : \mathbf{r}(\mathbf{s},\mathbf{t})
$$

where $\psi_k \in \Psi$.

The operator `:` applies a relation state to the relation application $\mathbf{r}(\mathbf{s},\mathbf{t})$.

The statement tuple:

$$
P = (\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

may therefore be written:

$$
P \equiv \psi_k : \mathbf{r}(\mathbf{s},\mathbf{t})
$$

The resolved affirmative state is abbreviated:

$$
\psi_\top : \mathbf{r}(\mathbf{s},\mathbf{t})
\equiv
\mathbf{r}(\mathbf{s},\mathbf{t})
$$

The resolved negative state is interpreted as:

$$
\psi_\bot : \mathbf{r}(\mathbf{s},\mathbf{t})
\equiv
\neg\mathbf{r}(\mathbf{s},\mathbf{t})
$$

The generic unresolved state:

$$
\psi_\star : \mathbf{r}(\mathbf{s},\mathbf{t})
$$

preserves unresolved non-probabilistic superposition over the relation application.

---

## 11. Resolved Statements

A statement may be resolved under an environment $\Gamma$ when its source, relation, and target expressions resolve to C4 objects.

For:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

if:

$$
\Gamma(\mathbf{s})=o_s
$$

$$
\Gamma(\mathbf{r})=o_r
$$

$$
\Gamma(\mathbf{t})=o_t
$$

then the resolved statement is written:

$$
\widehat{P}_\Gamma=(o_s,o_r,o_t,\psi_k)
$$

where:

$$
o_s,o_r,o_t\in\mathcal{O}
$$

and:

$$
\psi_k\in\Psi
$$

Resolution of $P$ is partial. If any required expression fails to resolve under $\Gamma$, then $\widehat{P}_\Gamma$ is undefined unless a profile defines a partial-resolution or unresolved-object representation.

Resolved statements are not necessarily valid statements. Validation remains profile-relative and may reject a resolved statement whose relation, endpoint types, state, or profile constraints are inadmissible.

---

## 12. Blocks

A C4 block is an ordered sequence of statements:

$$
\mathrm{Block} =
\mathrm{Seq}(\mathrm{Stmt})
$$

An individual block is written:

$$
B = \langle P_1,\ldots,P_n\rangle
$$

Source order is preserved unless an explicit profile defines another ordering or canonicalization policy.

Blocks MAY introduce binding scope, query scope, declaration scope, or local relation-definition scope under the active grammar/profile.

A block MAY itself be treated as an object when canonicalized.

---

## 13. Statement and Block Objects

C4 statements and blocks are reifiable objects.

Let:

$$
\iota_P : \mathrm{Stmt} \to \mathcal{O}
$$

map each canonical statement to its statement-object identity.

Let:

$$
\iota_B : \mathrm{Block} \to \mathcal{O}
$$

map each canonical block to its block-object identity.

If two surface forms canonicalize to the same statement, they MUST have the same statement-object identity.

Formally, for a canonicalization function $\kappa$:

$$
\kappa(a)=\kappa(b)
\implies
\iota_P(\kappa(a))=\iota_P(\kappa(b))
$$

when $\kappa(a),\kappa(b) \in \mathrm{Stmt}$.

Context, provenance, source attribution, modality, temporal validity, and related qualifiers are not primitive slots of $P$. They SHOULD be represented as ordinary C4 statements about the statement object $\iota_P(P)$.

For example, contextualization may be represented as:

$$
P_c=(\iota_P(P),\mathbf{r}_{ctx},\mathbf{c},\psi_\top)
$$

where $\mathbf{r}_{ctx},\mathbf{c}\in\mathcal{E}$.

Exact surface syntax for addressing a statement object or block object is deferred beyond this mathematical core.

---

## 14. Canonicalization

Let:

$$
\kappa
$$

be canonicalization.

For a surface language $L$, parsing and canonicalization are separated:

$$
\mathrm{parse}_{L} : \Sigma_L^* \rightharpoonup AST_L
$$

$$
\kappa_L : AST_L \rightharpoonup \mathrm{Stmt} \cup \mathrm{Block} \cup \mathcal{E}
$$

Canonical equivalence is defined over canonical C4 structures:

$$
a \equiv_{C4} b
\iff
\kappa(a)=\kappa(b)
$$

when both sides are defined.

Surface-language-specific parsing and canonicalization are instances of this general form, not the definition of C4 itself.

---

## 15. Validation

Validation is profile-relative.

Let:

$$
\mathrm{diag}_{\Gamma}
$$

be the validation diagnostic function:

$$
\mathrm{diag}_{\Gamma} : \mathrm{Stmt} \cup \mathrm{Block} \to \mathrm{Seq}(\mathrm{Diagnostic})
$$

A statement or block is valid under $\Gamma$ iff its diagnostic sequence is empty under a strict validation profile:

$$
\mathrm{valid}_{\Gamma}(X)
\iff
\mathrm{diag}_{\Gamma}(X)=\varnothing
$$

For a statement:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

strict validation MAY require:

$$
\mathrm{RelOk}_\Gamma(\mathbf{r})
\land
\mathrm{SrcOk}_\Gamma(\mathbf{s},\mathbf{r})
\land
\mathrm{TgtOk}_\Gamma(\mathbf{t},\mathbf{r})
\land
\mathrm{StateOk}_\Gamma(\psi_k,\mathbf{r})
$$

Validation MAY inspect:

- relation-position admissibility;
- source-position admissibility;
- target-position admissibility;
- relation-state support;
- binding-kind consistency;
- local declaration availability;
- loaded modules;
- ontology/profile constraints;
- canonicalization policy.

Parsing, canonicalization, resolution, and validation are distinct operations.

An unknown relation may parse and canonicalize as a statement while failing validation under a strict profile.

---

## 16. Open Questions

The following remain open for future formalization:

- exact recursive definition of $\mathcal{E}$;
- exact canonical AST schema;
- exact structure of traversal steps $\eta$;
- exact minimal interface required of resolution environment $\Gamma$;
- exact internal structure of the relation-state domain $\Psi$;
- exact relationship between resolved statements and active graph state;
- exact relationship between graph names, locator profiles, and integral named graphs;
- exact relationship between integral named graphs and virtual/projected objects;
- exact surface syntax for statement-object and block-object addressing;
- exact conformance levels for parsers, canonicalizers, validators, emitters, and profile loaders.
