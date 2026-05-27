# C4 Graph-Native Relator Consumption Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It refactors endpoint consumption and relator denotation toward graph-native policy objects rather than primitive tuple axes.

This addendum SHOULD be treated as a design successor to the tuple-oriented endpoint-consumption model in `c4_endpoint_consumption_compilation.md`.

The body of this addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: 11. Endpoint Consumption Policies -->

## 12. Graph-Native Endpoint Consumption Policies

<!-- FOLLOWING SECTION: 13. Endpoint Consumption Compilation -->

C4 endpoint-consumption policy is graph-native.

A relator endpoint policy resolves to a C4 object describing the accepted consumption structure for one endpoint position.

For a resolved relator object:

$$
o_r\in\mathcal{O}
$$

and endpoint position:

$$
p\in\{source,target\}
$$

the endpoint-consumption policy object is written:

$$
o_{\pi}=\Pi_\Gamma(o_r,p)
$$

where:

$$
o_{\pi}\in\mathcal{O}
$$

The policy object $o_{\pi}$ is a graph object. It MAY describe:

- the endpoint view or projection to apply;
- the top-level argument units exposed by that view;
- count constraints such as exactly one, at least one, or between $m$ and $n$;
- whether the consumed endpoint form is sequence-like, set-like, tree-like, frame-like, or profile-defined;
- structural constraints over consumed argument objects;
- recursive or non-recursive treatment of nested list expressions;
- profile-defined validation rules;
- provenance and diagnostic preservation rules.

C4 Core does not treat arity, orderedness, decomposition, list structure, tree structure, frame structure, or bounds as primitive endpoint-consumption axes.

Those concepts are graph structure or graph-described constraints inside $o_{\pi}$.

Earlier explanatory tuples such as:

$$
(V,A,W)
$$

or:

$$
(V,\beta)
$$

MAY be used as implementation-oriented normal forms, but they are not the source of truth for graph-native C4 endpoint-consumption semantics.

### 12.1 Endpoint Views as Policy-Object Semantics

An endpoint view is the policy-defined operation that selects or projects an endpoint expression into a consumed endpoint form.

C4 Core MAY define standard endpoint-policy objects corresponding to common views, including:

$$
\mathrm{Whole}
$$

which consumes the endpoint expression as one argument unit, and:

$$
\mathrm{Members}_1
$$

which consumes one structural level of a list expression.

These names identify standard policy-object semantics. They do not require endpoint views to be primitive tuple members.

For example, a policy object corresponding to `Whole exactly one` may be represented graph-natively as an object whose relations describe:

- view: whole endpoint;
- count constraint: exactly one top-level argument unit.

A policy object corresponding to `first-level members, one or more` may be represented graph-natively as an object whose relations describe:

- view: first-level list members;
- count constraint: between one and unbounded top-level argument units.

### 12.2 Count Constraints as Graph Structure

Scalar arity is not intrinsic to an endpoint expression.

The relevant count is the number of top-level argument units exposed by the endpoint-consumption policy object.

A count constraint such as:

$$
\mathrm{between}(m,n)
$$

is a graph-described constraint inside $o_{\pi}$, not a primitive endpoint-consumption axis.

Special cases collapse into `between`-style constraints:

$$
\mathrm{exactly}(k) := \mathrm{between}(k,k)
$$

$$
\mathrm{atLeast}(k) := \mathrm{between}(k,\infty)
$$

For sequence-like accepted forms, the sequence structure itself is graph structure, such as directed successor relations among argument objects. Orderedness is not a primitive scalar flag.

### 12.3 Nested Structure Belongs to Argument Objects

Nested list, tree, sequence, tuple, set, frame, and other structured forms are graph objects or graph-described expression structures.

Endpoint-consumption policy constrains the consumed endpoint form. It does not flatten, reinterpret, or erase internal argument structure unless the policy object explicitly describes such behavior.

For example, under a first-level-member policy, the expression:

$$
(\mathbf{A},(\mathbf{B},\mathbf{C}),\mathbf{D})
$$

exposes three top-level argument units:

$$
\mathbf{A},\quad (\mathbf{B},\mathbf{C}),\quad \mathbf{D}
$$

The nested expression:

$$
(\mathbf{B},\mathbf{C})
$$

remains an argument object with its own internal structure.

Recursive flattening, leaf views, frame expansion, role projection, or other structural transformations require explicit policy-object semantics.

---

<!-- PRECEDING SECTION: 12. Graph-Native Endpoint Consumption Policies -->

## 13. Endpoint Consumption Compilation from Policy Objects

<!-- FOLLOWING SECTION: 14. Graph-Native Relator Denotation -->

Endpoint-consumption policy objects MAY be compiled into endpoint-consumption closures.

For endpoint policy object:

$$
o_{\pi}=\Pi_\Gamma(o_r,p)
$$

the compiled closure is written:

$$
C_{\Gamma,o_r,p}=\mathrm{compile}_\Gamma(o_{\pi})
$$

where:

$$
C_{\Gamma,o_r,p}:\mathcal{E}\rightharpoonup\mathcal{C}
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

provided those forms remain derived projections of the policy object $o_{\pi}$.

Implementations MAY cache, fuse, specialize, lazily evaluate, or prevalidate compiled endpoint-consumption closures, provided canonical behavior is preserved.

Useful cache keys include:

$$
(\Gamma,o_r,p)
$$

and:

$$
(\Gamma,o_{\pi})
$$

---

<!-- PRECEDING SECTION: 13. Endpoint Consumption Compilation from Policy Objects -->

## 14. Graph-Native Relator Denotation

<!-- FOLLOWING SECTION: 15. Relation-State Application Notation -->

A relator denotation consumes endpoint forms and yields a C4 object describing the denoted graph contribution, graph update, graph selection, graph check, or profile-defined graph effect.

For a resolved relator object:

$$
o_r\in\mathcal{O}
$$

relator denotation is written:

$$
\mathrm{den}_{\Gamma,o_r}:\mathcal{C}\times\mathcal{C}\times\Psi\rightharpoonup\mathcal{O}
$$

For statement:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

where:

$$
\Gamma(\mathbf{r})=o_r
$$

and consumed endpoint forms are:

$$
C_s=C_{\Gamma,o_r,source}(\mathbf{s})
$$

$$
C_t=C_{\Gamma,o_r,target}(\mathbf{t})
$$

statement denotation is:

$$
\mathrm{Den}_\Gamma(P)=\mathrm{den}_{\Gamma,o_r}(C_s,C_t,\psi_k)=o_\Delta
$$

where:

$$
o_\Delta\in\mathcal{O}
$$

The object $o_\Delta$ is a graph-delta / graph-denotation object.

It describes what the relator application denotes: what would change, what has changed, what is selected, what is checked, what is constructed, or what profile-defined graph effect is represented.

The graph-delta object is reified C4 graph data. It need not imply immediate mutation of persistent graph state.

### 14.1 Relator Denotation Policy as Graph Metadata

Relator denotation behavior SHOULD be described by graph metadata on the relator object and related policy objects.

C4 Core does not require primitive relator-kind axes such as node-effect, edge-effect, return value, graph effect kind, or yield kind.

Edges, nodes, statements, blocks, relators, graph roots, graph deltas, and profile-defined structures are all C4 objects.

Therefore graph update or selection semantics SHOULD be represented by the yielded graph-delta object $o_\Delta$ and its graph structure, not by a primitive relator-effect tuple.

### 14.2 Member Interpretation as Compiled Relator Semantics

Relator member interpretation may still be compiled for efficient evaluation.

Common member-interpretation modes include:

- single participant interpretation;
- distributive interpretation;
- candidate or alternative interpretation;
- conjunctive interpretation;
- collective interpretation;
- tuple-like interpretation;
- frame-like interpretation;
- profile-defined interpretation.

These modes are not primitive endpoint-consumption axes.

They are relator semantics derived from graph-defined relator metadata and compiled as needed.

A compiled member-interpretation mode may be written:

$$
Q_\Gamma(o_r)
$$

where $Q_\Gamma(o_r)$ is an implementation-oriented projection of the graph-defined relator semantics of $o_r$.

### 14.3 State Compatibility and State Semantics

Relation-state compatibility and relation-state interpretation are graph-defined relator semantics.

Validators MAY expose predicates such as:

$$
\mathrm{StateOk}_\Gamma(\psi_k,o_r)
$$

but the accepted states and state-driven denotation behavior SHOULD be described by graph metadata associated with $o_r$ or its profiles.

State behavior is not a primitive relator-denotation tuple axis.

### 14.4 Materialization as Graph-Delta Interpretation

Materialization is the interpretation or application of a graph-delta object.

Materialization is written:

$$
\mathrm{Mat}_\Gamma(o_\Delta)
$$

where:

$$
o_\Delta\in\mathcal{O}
$$

Materialization MAY produce graph patches, derived statements, indexes, projected resources, diagnostics, or no persistent mutation.

Materialization permissions and requirements SHOULD be represented as graph metadata on $o_\Delta$, on its graph-delta type, or in the active profile.

Materialization policy is therefore not a primitive relator-denotation tuple axis.

---

<!-- PRECEDING SECTION: 18. Validation -->

## 19. Integration Notes for Graph-Native Relator Consumption

<!-- FOLLOWING SECTION: 20. Open Questions -->

When this addendum is incorporated into the C4 Mathematical Core, the following integration edits SHOULD be applied.

The current tuple-oriented endpoint-consumption presentation SHOULD be revised so that endpoint-consumption policy is a graph object:

$$
o_\pi=\Pi_\Gamma(o_r,p)
$$

Tuple forms such as:

$$
(V,A,W)
$$

or:

$$
(V,\beta)
$$

SHOULD be described as optional implementation normal forms compiled from $o_\pi$, not as normative source semantics.

The endpoint-consumption compilation section SHOULD compile policy objects rather than primitive tuples:

$$
C_{\Gamma,o_r,p}=\mathrm{compile}_\Gamma(o_\pi)
$$

Relator denotation SHOULD be expressed as a function yielding graph-delta objects:

$$
\mathrm{den}_{\Gamma,o_r}:\mathcal{C}\times\mathcal{C}\times\Psi\rightharpoonup\mathcal{O}
$$

$$
\mathrm{Den}_\Gamma(P)=o_\Delta
$$

The core spec SHOULD preserve the distinction among:

- endpoint-consumption policy objects;
- compiled endpoint-consumption closures;
- consumed endpoint forms;
- graph-defined relator semantics;
- graph-delta denotation objects;
- optional materialization.

The canonical statement tuple MUST remain unchanged:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

---

<!-- PRECEDING SECTION: 19. Integration Notes for Graph-Native Relator Consumption -->

## 20. Open Questions for Graph-Native Relator Consumption

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- exact minimal graph schema for endpoint-consumption policy objects $o_\pi$;
- standard library names for common endpoint-consumption policy objects;
- exact representation of graph-delta objects $o_\Delta$;
- whether graph-delta objects are always persistent, virtual, or profile-dependent;
- whether consumed endpoint forms $\mathcal{C}$ are themselves always C4 objects or may remain operational forms;
- exact relationship between graph-delta objects and materialized graph patches;
- whether member-interpretation modes $Q_\Gamma(o_r)$ should be standardized or remain purely profile-defined;
- whether state compatibility should be represented by standard relator metadata relations;
- how much of this addendum should replace versus supplement the earlier endpoint-consumption compilation addendum.
