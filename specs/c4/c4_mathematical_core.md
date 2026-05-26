# C4 Mathematical Core v0.1.6 Draft

## Status

This document defines a preliminary mathematical core for C4 v0.1.6.

It stabilizes the abstract C4 model independently of any particular surface syntax.

Fish remains the canonical Purple Herring surface language for C4 expressions, but C4 Core terminology SHOULD avoid Fish-specific terminology except when explicitly describing the Fish mapping.

Future drafts SHOULD either incorporate this material into the C4 Core Specification or preserve it as the normative mathematical appendix for the C4 v0.1.x series.

---

## 1. Terminology Layers

C4 Core uses serialization-neutral terminology.

| C4 Core | Fish Surface Language |
|---|---|
| statement | fish |
| block | school |
| source | tail |
| target | head |
| statement state | tail-mode marker |

A Fish fish is the Fish-language surface form of one C4 statement.

A Fish school is the Fish-language surface form of one C4 block.

C4 Core MUST NOT require Fish terminology for its abstract definitions.

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

The root resource of $G_j$ is:

$$
G_j[\epsilon]
$$

C4 Core does not define URI schemes, network protocols, domain names, filesystem paths, `/`, or `//` as primitive mathematical operators. Such forms are surface serializations or profile-defined locator syntaxes.

Profiles MAY map URI-like, IRI-like, filesystem-like, package-like, registry-like, or domain-like locator systems into graph names, but those locator systems are not part of C4 Core graph identity unless a profile explicitly makes them so.

---

## 4. Resource Universe

Let:

$$
\mathcal{U}
$$

be the universe of C4 resources.

A C4 resource is a stable addressable semantic unit.

In the core graph model, a resource is represented as a rooted subgraph selected from an integral named graph.

Let:

$$
\mathcal{T}_{G_j}
$$

be the traversal-step domain available in graph $G_j$.

A traversal chain over $G_j$ is:

$$
\gamma \in \mathrm{Seq}(\mathcal{T}_{G_j})
$$

A resource selected from $G_j$ by traversal chain $\gamma$ is written:

$$
G_j[\gamma]
$$

The root resource of $G_j$ is:

$$
G_j[\epsilon]
$$

where $\epsilon$ is the empty traversal chain.

The primary resource universe is therefore:

$$
\mathcal{U}
=
\{\,G_j[\gamma] \mid G_j \in \mathcal{G},\ \gamma \in \mathrm{Seq}(\mathcal{T}_{G_j}),\ G_j[\gamma]\ \text{is defined}\,\}
$$

Profiles MAY define virtual, projected, or constructed resources, provided they canonicalize to stable resource identities.

---

## 5. Expression Domain

Let:

$$
\mathcal{E}
$$

be the domain of C4 expressions.

A C4 expression is a structured form that may denote, bind, construct, query, project, or resolve to a resource.

Expressions are broader than resolved resources.

Resource-denoting traversal expressions are one subdomain of $\mathcal{E}$, not the whole expression domain.

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
u_{i-1}\overset{\eta_i}{\rightarrow}u_i
$$

where $u_{i-1},u_i \in \mathcal{U}$ and $\eta_i \in \mathcal{T}$.

When discussing resolved statement endpoints, C4 uses $u_s$ and $u_t$ for the resolved source and target resources:

$$
u_s=\rho_\Gamma(\mathbf{s}), \qquad u_t=\rho_\Gamma(\mathbf{t})
$$

When discussing traversal chains, C4 uses indexed resources $u_0,\ldots,u_n$:

$$
u_{i-1}\overset{\eta_i}{\rightarrow}u_i
$$

This avoids confusing statement source/target notation with traversal-step composition.

A traversal chain determines a resource path when there exist resources $u_0,\ldots,u_n$ such that:

$$
u_0
\overset{\eta_1}{\rightarrow}
u_1
\overset{\eta_2}{\rightarrow}
\cdots
\overset{\eta_n}{\rightarrow}
u_n
$$

In that case:

$$
\rho^\Gamma_\gamma(u_0)=u_n
$$

A traversal expression is a root resource together with a traversal chain:

$$
\mathcal{E}_{trav}
=
\mathcal{U}
\times
\mathrm{Seq}(\mathcal{T})
$$

A path-like surface expression MAY serialize a rooted traversal chain, but the formal C4 traversal operator is:

$$
u_{i-1}\overset{\eta_i}{\rightarrow}u_i
$$

C4 Core does not require any particular textual path separator.

For a path component $x$, the corresponding path-component traversal operator MAY be written:

$$
\eta_{\mathrm{path}(x)}
$$

Thus a surface path-like form is a compact serialization of a rooted traversal chain, not an assertion of containment, subtype, membership, or network location unless a profile explicitly materializes such statements.

Traversal operators are profile-defined partial resource-resolution operators:

$$
\eta^\Gamma : \mathcal{U} \rightharpoonup \mathcal{U}
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

Traversal operators resolve resources. They do not themselves assert C4 statements.

A profile MAY define materialization rules that emit C4 statements corresponding to traversal behavior, but such materialization is profile-defined and not part of C4 Core traversal semantics.

---

## 7. Resolution

Let:

$$
\Gamma
$$

be the active resolution environment.

The environment $\Gamma$ may contain the active graph, prefix declarations, binding scope, loaded profiles, Herring Bones modules, ontology/template registries, canonicalization policies, and validation mode.

Let:

$$
\rho
$$

be the resolution operator.

General expression resolution is partial:

$$
\rho_{\Gamma} : \mathcal{E} \rightharpoonup \mathcal{U}
$$

Traversal-chain resolution is also partial:

$$
\rho^{\Gamma}_{\gamma} : \mathcal{U} \rightharpoonup \mathcal{U}
$$

For:

$$
\gamma = \langle \eta_1,\ldots,\eta_n \rangle
$$

traversal resolution is:

$$
\rho^{\Gamma}_{\gamma}(u_0) =
\eta_n^{\Gamma}(\cdots\eta_2^{\Gamma}(\eta_1^{\Gamma}(u_0))\cdots)
$$

when every traversal step is defined.

Traversal expression resolution is the special case:

$$
\rho_{\Gamma}((u_0,\gamma)) =
\rho^{\Gamma}_{\gamma}(u_0)
$$

when the right-hand side is defined.

Graph-name resolution is separate from expression resolution:

$$
\chi_\Gamma : \mathcal{N}_G \rightharpoonup \mathcal{G}
$$

If $\chi_\Gamma(g)=G_j$, then traversal from the graph root may be written:

$$
\rho^\Gamma_\gamma(G_j[\epsilon])=G_j[\gamma]
$$

when $G_j[\gamma]$ is defined.

---

## 8. Statement Domain

A C4 statement is a complete directed relation expression with an attached relation-resolution state.

Let:

$$
\Psi
$$

be the domain of C4 relation-resolution states.

C4 relation-resolution states are non-probabilistic. They preserve relation-state resolution, non-resolution, and superposition without requiring ranking, weighting, likelihood assignment, or forced collapse. Profiles MAY define weighted, probabilistic, preferential, or collapse procedures, but such structures are not part of C4 Core.

At minimum, $\Psi$ contains the distinguished states:

$$
\psi_\top,\psi_\bot,\psi_\star \in \Psi
$$

where:

- $\psi_\top$ is the resolved affirmative state;
- $\psi_\bot$ is the resolved negative state;
- $\psi_\star$ is the generic unresolved / uncollapsed / superposed state.

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
- $\psi_k \in \Psi$ is the relation-resolution state.

Relations are expressions. Relation-position validity is not enforced by membership in a separate primitive expression subset. Instead, relation-position admissibility is determined by profile-relative validation predicates such as $\mathrm{RelOk}_\Gamma(\mathbf{r})$.

Source and target are expressions, not necessarily already-resolved resources.

When source and target resolution succeeds, the resolved endpoint resources may be written:

$$
u_s=\rho_\Gamma(\mathbf{s})
$$

$$
u_t=\rho_\Gamma(\mathbf{t})
$$

with $u_s,u_t \in \mathcal{U}$.

---

## 9. Relation-State Application Notation

C4 Core writes relation-state application as:

$$
\psi_k : \mathbf{r}(\mathbf{s},\mathbf{t})
$$

where $\psi_k \in \Psi$ and `:` is the C4 Core relation-state application operator.

The operator `:` applies a relation-resolution state to the relation application $\mathbf{r}(\mathbf{s},\mathbf{t})$. It is not Fish prefix syntax, namespace syntax, type annotation, ratio notation, or ordinary punctuation.

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

## 10. Blocks

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

A block MAY itself be treated as a resource when canonicalized.

---

## 11. Statement and Block Resources

C4 statements and blocks are reifiable resources.

Let:

$$
\iota_P : \mathrm{Stmt} \to \mathcal{U}
$$

map each canonical statement to its statement-resource identity.

Let:

$$
\iota_B : \mathrm{Block} \to \mathcal{U}
$$

map each canonical block to its block-resource identity.

If two surface forms canonicalize to the same statement, they MUST have the same statement-resource identity.

Formally, for a canonicalization function $\kappa$:

$$
\kappa(a)=\kappa(b)
\implies
\iota_P(\kappa(a))=\iota_P(\kappa(b))
$$

when $\kappa(a),\kappa(b) \in \mathrm{Stmt}$.

Context, provenance, source attribution, modality, temporal validity, and related qualifiers are not primitive slots of $P$. They SHOULD be represented as ordinary C4 statements about the statement-resource $\iota_P(P)$.

For example, contextualization may be represented as:

$$
P_c=(\iota_P(P),\mathbf{r}_{ctx},\mathbf{c},\psi_\top)
$$

where $\mathbf{r}_{ctx},\mathbf{c}\in\mathcal{E}$.

Exact surface syntax for addressing a statement-resource or block-resource is deferred beyond this mathematical core.

---

## 12. Canonicalization

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

Fish-specific parsing and canonicalization are instances of this general form, not the definition of C4 itself.

---

## 13. Validation

Validation is profile-relative.

Let:

$$
\nu_{\Gamma}
$$

be the validation diagnostic function:

$$
\nu_{\Gamma} : \mathrm{Stmt} \cup \mathrm{Block} \to \mathrm{Seq}(\mathrm{Diagnostic})
$$

A statement or block is valid under $\Gamma$ iff its diagnostic sequence is empty under a strict validation profile:

$$
\mathrm{valid}_{\Gamma}(X)
\iff
\nu_{\Gamma}(X)=\varnothing
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
- loaded Herring Bones modules;
- ontology/profile constraints;
- canonicalization policy.

Parsing, canonicalization, and validation are distinct operations.

An unknown relation may parse and canonicalize as a statement while failing validation under a strict profile.

---

## 14. Fish Mapping

Fish maps its surface markers onto C4 Core relation-state notation as follows:

$$
\begin{aligned}
\mathbf{s}\&\mathbf{r}@\mathbf{t}
&\mapsto
\psi_\top : \mathbf{r}(\mathbf{s},\mathbf{t}) \\
\mathbf{s}\&?\mathbf{r}@\mathbf{t}
&\mapsto
\psi_\star : \mathbf{r}(\mathbf{s},\mathbf{t}) \\
\mathbf{s}\&!\mathbf{r}@\mathbf{t}
&\mapsto
\psi_\bot : \mathbf{r}(\mathbf{s},\mathbf{t})
\end{aligned}
$$

The Fish marker `?` is surface syntax only. It is not a C4 Core mathematical symbol. In the default Fish mapping, it serializes the generic unresolved state $\psi_\star$.

The Fish combined marker `?!` is provisionally reserved for an unresolved negative-oriented relation state, but its exact C4 Core mapping is deferred until the structure of refined unresolved states in $\Psi$ is formalized.

Fish source/target terminology MAY use tail/head as surface-language mnemonic terminology.

C4 Core terminology SHOULD use source/target.

---

## 15. Open Questions

The following remain open for future formalization:

- exact recursive definition of $\mathcal{E}$;
- exact canonical AST schema;
- exact structure of traversal steps $\eta$;
- exact contents of resolution environment $\Gamma$;
- exact internal structure of the relation-state domain $\Psi$;
- exact mapping of Fish `?!` into refined unresolved relation states;
- exact relationship between graph names, locator profiles, and integral named graphs;
- exact relationship between integral named graphs and virtual/projected resources;
- exact surface syntax for statement-resource and block-resource addressing;
- exact conformance levels for parsers, canonicalizers, validators, emitters, and profile loaders.
