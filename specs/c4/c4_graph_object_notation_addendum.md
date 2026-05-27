# C4 Graph-Object Notation Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It proposes a graph-native notation refactor for resolved C4 graph-objects, node-role objects, edge/traversal-role objects, traversal chains, expressions, and active resolution fields.

This addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: 3. Graph Names -->

## 4. Graph-Object Universe

<!-- FOLLOWING SECTION: 5. Expression Domain -->

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

The replacement is intended to emphasize that resolved C4 objects are graph-native and need not be treated as non-graph resources external to the substrate.

---

<!-- PRECEDING SECTION: 4. Graph-Object Universe -->

## 5. Node-Role and Edge-Role Graph-Objects

<!-- FOLLOWING SECTION: 6. Expression Domain -->

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

<!-- PRECEDING SECTION: 5. Node-Role and Edge-Role Graph-Objects -->

## 6. Expression Variables and Resolution

<!-- FOLLOWING SECTION: 7. List Expressions -->

Let:

$$
\mathcal{E}
$$

be the domain of C4 expressions.

An arbitrary expression is written:

$$
\mathbf{x}\in\mathcal{E}
$$

For a C4 statement, the source, relator, and target expressions are written:

$$
\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t\in\mathcal{E}
$$

where:

- $\mathbf{x}_s$ is the source expression;
- $\mathbf{x}_r$ is the relator expression;
- $\mathbf{x}_t$ is the target expression.

This notation replaces the earlier role-variable notation:

$$
\mathbf{s},\mathbf{r},\mathbf{t}
$$

when the variables are being emphasized as expressions.

The statement tuple becomes:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

where $\psi_k\in\Psi$ is the relation-state.

---

<!-- PRECEDING SECTION: 6. Expression Variables and Resolution -->

## 7. Active Field

<!-- FOLLOWING SECTION: 8. Traversal Expressions -->

Let:

$$
\mathcal{F}
$$

be the active C4 resolution/evaluation field.

The active field includes whatever graph state, bindings, loaded profiles, naming-domain bindings, canonicalization policy, validation policy, endpoint-consumption policy objects, relator semantics, and materialization policy are available to evaluation.

As an expression-resolution operator, the field is partial:

$$
\mathcal{F}:\mathcal{E}\rightharpoonup\Xi
$$

Thus:

$$
\xi=\mathcal{F}(\mathbf{x})
$$

means that expression $\mathbf{x}$ resolves to graph-object $\xi$ under active field $\mathcal{F}$.

For statement-role expressions:

$$
\xi_s=\mathcal{F}(\mathbf{x}_s)
$$

$$
\xi_r=\mathcal{F}(\mathbf{x}_r)
$$

$$
\xi_t=\mathcal{F}(\mathbf{x}_t)
$$

when source, relator, and target resolution succeed.

The resolved statement is written:

$$
\widehat{P}_{\mathcal{F}}=(\xi_s,\xi_r,\xi_t,\psi_k)
$$

Graph-name resolution under the active field is written:

$$
\chi_{\mathcal{F}}:\mathcal{N}_G\rightharpoonup\mathcal{G}
$$

This notation replaces earlier uses of $\Gamma$ as the active environment.

The symbol $\mathcal{F}$ is used to emphasize that C4 resolution occurs within an active field of graph state, profiles, bindings, and evaluation policy, not merely a passive environment.

---

<!-- PRECEDING SECTION: 7. Active Field -->

## 8. Traversal Edges and Traversal Chains

<!-- FOLLOWING SECTION: 9. Resolution -->

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

Traversal-chain resolution under field $\mathcal{F}$ is written:

$$
\mathcal{F}_{\vec{\eta}}(\nu_0)=\nu_n
$$

when every traversal edge is defined and admissible under $\mathcal{F}$.

C4 Core does not treat textual path separators, IRI separators, URI syntax, filesystem paths, package locators, or network protocols as primitive traversal operators. Such forms MAY serialize or denote traversal chains under a profile, but the formal traversal chain is a sequence of edge/traversal graph-objects.

### 8.1 Indexed Traversal Objects vs Denoted Objects

Indexed notation such as:

$$
\nu_i
$$

is used for the $i$th node-role graph-object in a particular traversal chain.

It should not be confused with a graph-object denoted by a name, resource expression, or path-like expression.

For a name or designator $n$, denotation under field $\mathcal{F}$ SHOULD be written:

$$
\mathcal{F}(n)=\xi
$$

or, when a compact derived notation is useful:

$$
\xi_{\mathcal{F}}(n)
$$

The notation $\xi_n$ SHOULD be reserved for indexed graph-objects in an explicitly described sequence, not for arbitrary resource-path denotation.

---

<!-- PRECEDING SECTION: 12. Endpoint Consumption Policies -->

## 13. Graph-Native Endpoint Policy Notation

<!-- FOLLOWING SECTION: 14. Endpoint Consumption Compilation -->

Endpoint-consumption policy objects are graph-objects.

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
\xi_{\pi}=\Pi_{\mathcal{F}}(\xi_r,p)
$$

where:

$$
\xi_{\pi}\in\Xi
$$

This replaces earlier notation such as:

$$
o_{\pi}=\Pi_\Gamma(o_r,p)
$$

Endpoint-consumption closures compiled from policy objects are written:

$$
C_{\mathcal{F},\xi_r,p}=\mathrm{compile}_{\mathcal{F}}(\xi_{\pi})
$$

where:

$$
C_{\mathcal{F},\xi_r,p}:\mathcal{E}\rightharpoonup\mathcal{C}
$$

and $\mathcal{C}$ is the domain of consumed endpoint forms.

Consumed source and target endpoint forms are written:

$$
C_s=C_{\mathcal{F},\xi_r,source}(\mathbf{x}_s)
$$

$$
C_t=C_{\mathcal{F},\xi_r,target}(\mathbf{x}_t)
$$

---

<!-- PRECEDING SECTION: 14. Graph-Native Relator Denotation -->

## 15. Graph-Delta Denotation Notation

<!-- FOLLOWING SECTION: 16. Relation-State Application Notation -->

Relator denotation yields a graph-delta / graph-denotation object.

For resolved relator graph-object:

$$
\xi_r\in\Xi
$$

relator denotation is written:

$$
\mathrm{den}_{\mathcal{F},\xi_r}:\mathcal{C}\times\mathcal{C}\times\Psi\rightharpoonup\Xi
$$

For statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

statement denotation is:

$$
\mathrm{Den}_{\mathcal{F}}(P)
=
\mathrm{den}_{\mathcal{F},\xi_r}(C_s,C_t,\psi_k)
=
\xi_\Delta
$$

where:

$$
\xi_\Delta\in\Xi
$$

The graph-delta object $\xi_\Delta$ describes what the relator application denotes: what would change, what has changed, what is selected, what is checked, what is constructed, or what profile-defined graph effect is represented.

Materialization is written:

$$
\mathrm{Mat}_{\mathcal{F}}(\xi_\Delta)
$$

and remains separate from denotation.

---

<!-- PRECEDING SECTION: 18. Validation -->

## 19. Integration Notes for Graph-Object Notation

<!-- FOLLOWING SECTION: 20. Open Questions -->

When this addendum is incorporated into the C4 Mathematical Core, the following replacements SHOULD be applied consistently.

| Earlier notation | Proposed notation |
|---|---|
| $\mathcal{O}$ | $\Xi$ |
| $o$ | $\xi$ |
| $\Gamma$ | $\mathcal{F}$ |
| $\mathbf{s},\mathbf{r},\mathbf{t}$ | $\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t$ |
| $o_s,o_r,o_t$ | $\xi_s,\xi_r,\xi_t$ |
| $o_{\pi}$ | $\xi_{\pi}$ |
| $o_\Delta$ | $\xi_\Delta$ |
| traversal-step domain $\mathcal{T}$ | edge-role graph-object subdomain $\Xi_\eta$ |
| traversal chain $\gamma$ | traversal chain $\vec{\eta}$ |

The statement tuple SHOULD become:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

The resolved statement SHOULD become:

$$
\widehat{P}_{\mathcal{F}}=(\xi_s,\xi_r,\xi_t,\psi_k)
$$

Expression resolution SHOULD become:

$$
\mathcal{F}:\mathcal{E}\rightharpoonup\Xi
$$

Statement and block identity maps SHOULD target $\Xi$:

$$
\iota_P:\mathrm{Stmt}\to\Xi
$$

$$
\iota_B:\mathrm{Block}\to\Xi
$$

Validation diagnostics SHOULD be indexed by $\mathcal{F}$ rather than $\Gamma$:

$$
\mathrm{diag}_{\mathcal{F}}
$$

The unified graph-object universe $\Xi$ SHOULD be preserved even when role-specific notation $\nu$ and $\eta$ is used.

---

<!-- PRECEDING SECTION: 19. Integration Notes for Graph-Object Notation -->

## 20. Open Questions for Graph-Object Notation

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- whether $\Xi_\nu$ and $\Xi_\eta$ should be profile-relative predicates rather than fixed subdomains;
- whether traversal endpoints must always be node-role graph-objects $\nu\in\Xi_\nu$, or whether arbitrary graph-objects $\xi\in\Xi$ may appear as traversal endpoints under some profiles;
- whether $\mathcal{F}$ should fully replace $\Gamma$ or coexist with $\Gamma$ as a field/environment distinction;
- whether compact notation $\xi_{\mathcal{F}}(n)$ should be standardized for denoted graph-objects;
- whether edge/traversal graph-objects $\eta$ should have a minimal required graph schema;
- whether role subdomains $\Xi_\nu$ and $\Xi_\eta$ should be allowed to overlap;
- whether statement-level relator objects $\xi_r$ should be required to belong to $\Xi_\eta$, a relator-specific subdomain, or only $\Xi$.
