# C4 Notation Stabilization Addendum v0.1.6 Draft

## Status

This document stabilizes the mathematical notation to be used when consolidating the C4 Mathematical Core.

It supersedes earlier provisional notation in C4 addenda where inconsistent.

The goal is to make consolidation deterministic: the core spec should use this notation table as the authoritative reference.

---

## 1. Core Universes and Subdomains

| Symbol | Meaning |
|---|---|
| $\mathfrak{F}$ | active C4 field: resolution/evaluation context, including profile, graph environment, policy, and materializer availability |
| $\mathbb{G}$ | universe/class of integral named graph containers |
| $G_j\in\mathbb{G}$ | a specific named graph container |
| $\Xi$ | universe of resolved C4 graph-objects |
| $\Xi_\nu\subseteq\Xi$ | node graph-object subdomain |
| $\Xi_\eta\subseteq\Xi$ | edge/traversal graph-object subdomain |
| $\Xi_\alpha\subseteq\Xi$ | delta-source graph-object subdomain |
| $\Xi_\Delta\subseteq\Xi$ | graph-delta graph-object subdomain |
| $\Xi_\mu\subseteq\Xi$ | materialization-result graph-object subdomain |

All subdomains above are graph-object subdomains. They do not introduce non-graph semantic domains.

---

## 2. Graph-Object Variables

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

---

## 3. Expressions, Nodes, Edges, and Traversal

| Symbol | Meaning |
|---|---|
| $\mathbf{x}$ | expression |
| $\mathbf{x}_s$ | source endpoint expression in a statement |
| $\mathbf{x}_r$ | relator expression in a statement |
| $\mathbf{x}_t$ | target endpoint expression in a statement |
| $\nu$ | node, when discussing graph structure informally |
| $\eta$ | edge/traversal object, when discussing graph structure informally |
| $\vec{\eta}$ | traversal chain, i.e. an ordered sequence of traversal/edge objects |

When formal graph-object membership matters, prefer $\xi_\nu\in\Xi_\nu$ and $\xi_\eta\in\Xi_\eta$ over bare $\nu$ and $\eta$.

---

## 4. Statements and States

| Symbol | Meaning |
|---|---|
| $P$ | C4 statement tuple |
| $P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)$ | canonical statement tuple |
| $\psi_k$ | relation state object/expression in the statement tuple |
| $\iota_P(P)$ | graph-object reification of statement $P$ |

The canonical statement tuple remains:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

---

## 5. Operators and Functions

| Symbol | Meaning |
|---|---|
| $\Pi_{\mathfrak{F}}(\xi_r,p)$ | endpoint-policy lookup for resolved relator $\xi_r$ and endpoint position $p$ |
| $\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)$ | endpoint-consumption policy graph-object selected under $\mathfrak{F}$ |
| $C_{\mathfrak{F},\xi_r,p}=\mathrm{compile}_{\mathfrak{F}}(\xi_\pi)$ | compiled endpoint-consumption closure derived from policy graph-object $\xi_\pi$ |
| $\boldsymbol{\delta}_{\mathfrak{F}}$ | graph-delta production operator |
| $\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta$ | general graph-delta production type |
| $\mathbf{d}_{\mathfrak{F}}(P)$ | statement-denotation convenience alias |
| $\mathbf{d}_{\mathfrak{F}}(P):=\boldsymbol{\delta}_{\mathfrak{F}}(\iota_P(P))$ | statement denotation as graph-delta production |
| $\mathbf{m}_{\mathfrak{F}}$ | materialization operator |
| $\mathbf{m}_{\mathfrak{F}}:\Xi_\Delta\rightharpoonup\Xi_\mu$ | materialization type |

---

## 6. Canonical Pipeline

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

Statement denotation is a specialization:

$$
\mathbf{d}_{\mathfrak{F}}(P):=\boldsymbol{\delta}_{\mathfrak{F}}(\iota_P(P))
$$

---

## 7. Terms to Retire or Avoid

The consolidated core SHOULD avoid or retire the following as primitive C4 Core semantics.

| Retired / avoided form | Replacement / treatment |
|---|---|
| $\mathcal{A}_\Delta$ as non-graph delta-source domain | use $\Xi_\alpha\subseteq\Xi$ |
| $\mathcal{O}$ / $\mathcal{O}$-like object universe notation | use $\Xi$ for graph-object universe |
| primitive identity | use addressability, correspondence, equivalence, or substitutability under $\mathfrak{F}$ or profile |
| “same object changed” | use source/target correspondence plus profile-defined difference marking |
| scalar arity as primitive endpoint-consumption axis | use graph-defined acceptance constraints over consumed forms |
| orderedness as primitive endpoint-consumption axis | represent order as graph structure or policy constraint |
| node mutation / edge mutation as primitive relator axes | represent graph-delta/materialization behavior as graph metadata or profile semantics |
| return value / return binding / return denotation as separate primitive axes | use graph-delta production and materialization-result graph-objects |

---

## 8. Graph-Delta Core Minimality

C4 Core SHOULD define graph-deltas loosely and graph-natively.

A graph-delta is:

- a graph-object;
- produced by $\boldsymbol{\delta}_{\mathfrak{F}}$;
- admissible for materialization or projection when permitted by the active field/profile;
- internally interpreted by field, profile, materializer, or protocol semantics.

C4 Core SHOULD NOT require a fixed graph-delta schema.

Difference markings such as added, removed, modified, unchanged, and unresolved are suitable for a standard comparison/diff profile, but SHOULD NOT be forced as required C4 Core graph-delta structure.

---

## 9. Protocol Boundary

Fish defines syntax, protocol projections, status registries, request/response forms, result-schema negotiation, compact encodings, and transport/interchange behavior.

C4 Core defines graph-native calculus semantics.

Fish protocol artifacts MUST NOT be imported into C4 Core as primitive semantic requirements.
