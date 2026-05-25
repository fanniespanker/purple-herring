# C4 Mathematical Core v0.1.6 Draft

## Status

This document defines a preliminary mathematical core for C4 v0.1.6.

It stabilizes the abstract C4 model independently of any particular surface syntax.

Fish remains the canonical Purple Herring surface language, but C4 Core terminology should avoid Fish-specific terminology except when explicitly describing the Fish mapping.

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

C4 Core does not require Fish terminology for its abstract definitions.

---

## 2. Integral Named Graphs

Let `Gset` be the class of integral named graphs.

An integral named graph is a graph with a stable name and distinguished root, treated by C4 as a coherent identity-bearing unit for resolution, traversal, persistence, and addressability.

Integral does not mean internally structureless. An integral graph may contain arbitrary internal graph structure. It is integral only in the sense that C4 treats the graph as a named whole unless a traversal expression selects a subresource.

An integral named graph may be represented as:

```text
G = (n, V, E, r, lab)
```

where `n` is the graph name, `V` is the node set, `E` is the edge / relation / traversal structure, `r in V` is the distinguished root node, and `lab` is a labelling function.

The exact internal structure of `E` is profile-defined. In graph-native C4 implementations, `E` should be understood as relation-mediated graph structure rather than only untyped binary edges.

---

## 3. Resource Universe

Let `U` be the universe of C4 resources.

A C4 resource is a stable addressable semantic unit.

In the core graph model, a resource is represented as a rooted subgraph selected from an integral named graph.

Let `T_G` be the traversal-step domain available in graph `G`.

A traversal chain over `G` is `gamma in Seq(T_G)`.

A resource selected from `G` by traversal chain `gamma` is written:

```text
G[gamma]
```

The root resource of `G` is:

```text
G[epsilon]
```

where `epsilon` is the empty traversal chain.

The primary resource universe is:

```text
U = { G[gamma] | G in Gset, gamma in Seq(T_G), and G[gamma] is defined }
```

Profiles may define virtual, projected, or constructed resources, provided they canonicalize to stable resource identities.

---

## 4. Expression Domain

Let `Eexpr` be the domain of C4 expressions.

A C4 expression is a structured form that may denote, bind, construct, query, project, or resolve to a resource.

Expressions are broader than resolved resources.

A preliminary decomposition is:

```text
Eexpr = E_trav union E_lit union E_bind union E_list union E_block union E_stmt union E_proj union ...
```

where:

- `E_trav` contains traversal expressions;
- `E_lit` contains literal expressions;
- `E_bind` contains anonymous, scoped, and query binding expressions;
- `E_list` contains list expressions;
- `E_block` contains block expressions;
- `E_stmt` contains statement-reference expressions;
- `E_proj` contains projection / mapping expressions.

This decomposition is provisional and should be refined when the exact canonical AST schema is defined.

---

## 5. Traversal and Resolution

Let `T` be the traversal-step domain.

A traversal step is written `eta in T`.

A traversal chain is written:

```text
gamma = <eta_1, ..., eta_n>
```

A traversal expression is a root resource together with a traversal chain:

```text
E_trav = U x Seq(T)
```

Let `Gamma` be the active resolution environment.

Let `rho` be the resolution operator.

General expression resolution is partial:

```text
rho_Gamma : Eexpr ->? U
```

Traversal-chain resolution is also partial:

```text
rho^Gamma_gamma : U ->? U
```

For `gamma = <eta_1, ..., eta_n>`:

```text
rho^Gamma_gamma(u_0) = eta_n^Gamma(... eta_2^Gamma(eta_1^Gamma(u_0)) ...)
```

when every traversal step is defined.

Traversal expression resolution is the special case:

```text
rho_Gamma((u_0, gamma)) = rho^Gamma_gamma(u_0)
```

when the right-hand side is defined.

---

## 6. Statement Domain

A C4 statement is a complete directed relation expression.

Let `E_rel subset Eexpr` be the subset of expressions admissible in relation position by grammar.

Profile-relative relation validity is separate from syntactic relation-position admissibility.

Let `Phi = { empty, neg }` be the polarity domain.

Let `Sigma = { empty, unresolved }` be the resolution-state domain.

Then:

```text
Stmt = Eexpr x E_rel x Eexpr x Phi x Sigma x Option(Eexpr)
```

An individual statement is written:

```text
P = (s, r, t, phi, sigma, c)
```

where `s` and `t` are source and target expressions, `r` is the relation-position expression, `phi` is polarity, `sigma` is resolution state, and `c` is optional context.

Source and target are expressions, not necessarily already-resolved resources.

When resolution succeeds:

```text
rho_Gamma(s), rho_Gamma(t) in U
```

---

## 7. Statement Mode Notation

C4 Core represents relation application as:

```text
r^phi_sigma(s, t)
```

The default positive resolved case is abbreviated:

```text
r^empty_empty(s, t) == r(s, t)
```

Mode interpretations are:

```text
r^empty_empty(s, t) == r(s, t)
r^empty_unresolved(s, t) == Unres(r(s, t))
r^neg_empty(s, t) == neg r(s, t)
r^neg_unresolved(s, t) == Unres(neg r(s, t))
```

The unresolved negative case is explicitly not equivalent to negating an unresolved positive case:

```text
r^neg_unresolved(s, t) != neg Unres(r(s, t))
```

The unresolved marker does not encode probability or statistical confidence. It denotes unresolvedness, contextuality, inquiry, or incomplete crystallization.

---

## 8. Blocks

A C4 block is an ordered sequence of statements:

```text
Block = Seq(Stmt)
```

An individual block is written:

```text
B = <P_1, ..., P_n>
```

Source order is preserved unless an explicit profile defines another ordering or canonicalization policy.

Blocks may introduce binding scope, query scope, declaration scope, or local relation-definition scope under the active grammar/profile.

A block may itself be treated as a resource when canonicalized.

---

## 9. Statement and Block Resources

C4 statements and blocks are reifiable resources.

Let:

```text
iota_P : Stmt -> U
iota_B : Block -> U
```

map each canonical statement or block to its resource identity.

If two surface forms canonicalize to the same statement, they must have the same statement-resource identity.

Exact surface syntax for addressing a statement-resource or block-resource is deferred beyond this mathematical core.

---

## 10. Canonicalization and Validation

Let `kappa` be canonicalization.

For a surface language `L`, parsing and canonicalization are separated:

```text
parse_L : Sigma_L* ->? AST_L
kappa_L : AST_L ->? Stmt union Block union Eexpr
```

Canonical equivalence is defined over canonical C4 structures:

```text
a ==_C4 b iff kappa(a) = kappa(b)
```

when both sides are defined.

Validation is profile-relative.

Let `nu_Gamma` be the validation diagnostic function:

```text
nu_Gamma : Stmt union Block -> Seq(Diagnostic)
```

A statement or block is valid under `Gamma` iff its diagnostic sequence is empty under a strict validation profile:

```text
valid_Gamma(X) iff nu_Gamma(X) = empty
```

Parsing, canonicalization, and validation are distinct operations.

---

## 11. Fish Mapping

Fish maps its surface markers onto C4 Core statement notation as follows:

```text
s&r@t   -> r^empty_empty(s, t)
s&?r@t  -> r^empty_unresolved(s, t)
s&!r@t  -> r^neg_empty(s, t)
s&?!r@t -> r^neg_unresolved(s, t)
```

Fish source/target terminology may use tail/head as surface-language mnemonic terminology.

C4 Core terminology should use source/target.

---

## 12. Open Questions

The following remain open for future formalization:

- exact recursive definition of `Eexpr`;
- exact canonical AST schema;
- exact grammar-defined definition of `E_rel`;
- exact structure of traversal steps `eta`;
- exact contents of resolution environment `Gamma`;
- exact relationship between integral named graphs and virtual/projected resources;
- exact surface syntax for statement-resource and block-resource addressing;
- exact conformance levels for parsers, canonicalizers, validators, emitters, and profile loaders.
