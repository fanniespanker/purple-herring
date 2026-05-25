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
| statement mode | tail-mode marker |

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

An integral named graph may be represented as:

$$
G = (n,V,E,r,\ell)
$$

where:

- $n$ is the graph name;
- $V$ is the node set;
- $E$ is the edge / relation / traversal structure;
- $r \in V$ is the distinguished root node;
- $\ell$ is a labelling function.

The exact internal structure of $E$ is profile-defined. In C4 graph-native implementations, $E$ SHOULD be understood as relation-mediated graph structure rather than as only untyped binary edges.

---

## 3. Resource Universe

Let:

$$
\mathcal{U}
$$

be the universe of C4 resources.

A C4 resource is a stable addressable semantic unit.

In the core graph model, a resource is represented as a rooted subgraph selected from an integral named graph.

Let:

$$
\mathcal{T}_G
$$

be the traversal-step domain available in graph $G$.

A traversal chain over $G$ is:

$$
\gamma \in \operatorname{Seq}(\mathcal{T}_G)
$$

A resource selected from $G$ by traversal chain $\gamma$ is written:

$$
G[\gamma]
$$

The root resource of $G$ is:

$$
G[\epsilon]
$$

where $\epsilon$ is the empty traversal chain.

The primary resource universe is therefore:

$$
\mathcal{U}
=
\{\,G[\gamma] \mid G \in \mathcal{G},\ \gamma \in \operatorname{Seq}(\mathcal{T}_G),\ G[\gamma]\ \text{is defined}\,\}
$$

Profiles MAY define virtual, projected, or constructed resources, provided they canonicalize to stable resource identities.

---

## 4. Expression Domain

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
\mathcal{E}
=
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

## 5. Traversal Expressions

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

A traversal expression is a root resource together with a traversal chain:

$$
\mathcal{E}_{trav}
=
\mathcal{U}
\times
\operatorname{Seq}(\mathcal{T})
$$

A path-like surface expression such as:

```text
Politics/movements/feminism/radical_feminism
```

is a surface serialization of a rooted traversal expression, not a primitive string.

Traversal steps are profile-defined. They MAY represent subresource selection, relation-mediated traversal, path-component traversal, prefix-expanded IRI-relative addressing, or other deterministic graph-addressing operations.

---

## 6. Resolution

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
\rho^{\Gamma}_{\gamma}(u_0)
=
\eta_n^{\Gamma}(\cdots\eta_2^{\Gamma}(\eta_1^{\Gamma}(u_0))\cdots)
$$

when every traversal step is defined.

Traversal expression resolution is the special case:

$$
\rho_{\Gamma}((u_0,\gamma))
=
\rho^{\Gamma}_{\gamma}(u_0)
$$

when the right-hand side is defined.

---

## 7. Statement Domain

A C4 statement is a complete directed relation expression.

Let:

$$
\mathcal{E}_{rel} \subseteq \mathcal{E}
$$

be the subset of expressions admissible in relation position by grammar.

Profile-relative relation validity is separate from syntactic relation-position admissibility.

Let:

$$
\Phi = \{\varnothing,\neg\}
$$

be the polarity domain, and:

$$
\Sigma = \{\varnothing,?\}
$$

be the resolution-state domain.

Then:

$$
\mathrm{Stmt}
=
\mathcal{E}
\times
\mathcal{E}_{rel}
\times
\mathcal{E}
\times
\Phi
\times
\Sigma
\times
\operatorname{Option}(\mathcal{E})
$$

An individual statement is written:

$$
P = (\mathbf{s},\mathbf{r},\mathbf{t},\phi,\sigma,c)
$$

where:

- $\mathbf{s},\mathbf{t} \in \mathcal{E}$ are source and target expressions;
- $\mathbf{r} \in \mathcal{E}_{rel}$ is the relation-position expression;
- $\phi \in \Phi$ is polarity;
- $\sigma \in \Sigma$ is resolution state;
- $c \in \operatorname{Option}(\mathcal{E})$ is optional context.

Source and target are expressions, not necessarily already-resolved resources.

When resolution succeeds:

$$
\rho_{\Gamma}(\mathbf{s}),\rho_{\Gamma}(\mathbf{t}) \in \mathcal{U}
$$

---

## 8. Statement Mode Notation

C4 Core represents relation application as:

$$
\mathbf{r}^{\phi}_{\sigma}(\mathbf{s},\mathbf{t})
$$

The default positive resolved case is abbreviated:

$$
\mathbf{r}^{\varnothing}_{\varnothing}(\mathbf{s},\mathbf{t})
\equiv
\mathbf{r}(\mathbf{s},\mathbf{t})
$$

Mode interpretations are:

$$
\begin{aligned}
\mathbf{r}^{\varnothing}_{\varnothing}(\mathbf{s},\mathbf{t})
&\equiv
\mathbf{r}(\mathbf{s},\mathbf{t}) \\
\mathbf{r}^{\varnothing}_{?}(\mathbf{s},\mathbf{t})
&\equiv
\mathsf{Unres}(\mathbf{r}(\mathbf{s},\mathbf{t})) \\
\mathbf{r}^{\neg}_{\varnothing}(\mathbf{s},\mathbf{t})
&\equiv
\neg \mathbf{r}(\mathbf{s},\mathbf{t}) \\
\mathbf{r}^{\neg}_{?}(\mathbf{s},\mathbf{t})
&\equiv
\mathsf{Unres}(\neg \mathbf{r}(\mathbf{s},\mathbf{t}))
\end{aligned}
$$

The unresolved negative case is explicitly not equivalent to negating an unresolved positive case:

$$
\mathbf{r}^{\neg}_{?}(\mathbf{s},\mathbf{t})
\not\equiv
\neg \mathsf{Unres}(\mathbf{r}(\mathbf{s},\mathbf{t}))
$$

The symbol $?$ does not encode probability or statistical confidence. It denotes unresolvedness, contextuality, inquiry, or incomplete crystallization.

