# C4 Endpoint-Consumption Policy Minimal Schema Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It defines a deliberately small graph-native minimal schema for endpoint-consumption policy objects.

The schema is intentionally sparse. Most endpoint-view definitions, argument-shape constraints, recursive traversal behavior, diagnostic layout, and optimization normal forms are profile-, implementation-, validator-, or compiler-defined.

This addendum assumes the graph-native endpoint-consumption model from `c4_graph_native_relator_consumption_addendum.md` and the consolidated notation in `c4_mathematical_core.md`:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

where:

$$
\xi_\pi\in\Xi
$$

and:

$$
p\in\{source,target\}
$$

The body of this addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: Endpoint Consumption Policies -->

## Endpoint-Consumption Policy Minimal Schema

<!-- FOLLOWING SECTION: Endpoint Consumption Compilation -->

An endpoint-consumption policy object is a graph-object whose internal graph structure describes how an endpoint expression may be consumed for a relator endpoint position.

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

C4 Core does not require endpoint-consumption policy objects to use one fixed physical layout. A policy profile MAY choose any graph layout that preserves the minimal C4 endpoint-consumption semantics.

A minimally conforming endpoint-consumption policy SHOULD expose the following as graph structure:

1. a policy root;
2. an endpoint-view description;
3. an acceptance constraint over the consumed form;
4. failure or unresolved-consumption behavior.

These roles are graph-defined. They are not enum primitives, non-graph fields, external lists, or protocol status codes.

Everything beyond this minimal shape is profile-defined unless another C4 specification explicitly standardizes it.

---

<!-- PRECEDING SECTION: Endpoint-Consumption Policy Minimal Schema -->

## Endpoint Policy Root

<!-- FOLLOWING SECTION: Endpoint View Description -->

An endpoint-consumption policy object:

$$
\xi_\pi\in\Xi
$$

is the root of an endpoint-policy graph region.

The endpoint-policy root SHOULD provide an entry point to the policy's endpoint-view description, acceptance constraint, failure behavior, and profile-defined optimization metadata.

The endpoint-policy root MAY itself be the view-bearing graph-object for the policy.

C4 Core does not require a separate non-root view object. If a profile uses separate view objects, they remain ordinary graph-objects connected to the endpoint-policy root by graph structure.

---

<!-- PRECEDING SECTION: Endpoint Policy Root -->

## Endpoint View Description

<!-- FOLLOWING SECTION: Acceptance Constraint -->

An endpoint view describes how an endpoint expression is exposed to endpoint consumption.

Endpoint views are graph-defined policy semantics, not primitive tuple members.

A profile MAY define endpoint views corresponding to common behavior such as:

- whole endpoint consumption;
- first-level member exposure;
- recursive leaf exposure;
- role-frame exposure;
- projection-based exposure;
- filter-based exposure;
- profile-defined endpoint exposure.

C4 Core does not require the endpoint view to return a flat sequence. The viewed endpoint may be represented as any consumed endpoint form permitted by the active profile.

Earlier explanatory forms such as:

$$
(V,A,W)
$$

or:

$$
(V,\beta)
$$

MAY be used as implementation-oriented normal forms compiled from $\xi_\pi$, but they are not the source of truth for graph-native C4 endpoint-consumption semantics.

Order, tree structure, list structure, frame structure, and nested argument structure SHOULD be represented by graph structure in the consumed form or by graph-defined policy constraints, not by primitive endpoint-consumption tuple axes.

---

<!-- PRECEDING SECTION: Endpoint View Description -->

## Acceptance Constraint

<!-- FOLLOWING SECTION: Failure and Unresolved-Consumption Behavior -->

An endpoint-consumption policy SHOULD define, or point to, an acceptance constraint over the consumed endpoint form.

Acceptance constraints are graph-defined.

A profile MAY define acceptance constraints corresponding to behavior such as:

- exactly one top-level argument unit;
- between $m$ and $n$ top-level argument units;
- at least one top-level argument unit;
- sequence-like consumed form;
- set-like consumed form;
- tree-like consumed form;
- frame-like consumed form;
- profile-defined structural constraint;
- profile-defined semantic constraint.

C4 Core does not require scalar arity, orderedness, or argument shape to be primitive endpoint-consumption axes.

A scalar bound such as `between(m,n)` is a possible graph-described constraint, not a primitive C4 Core field.

The consumed endpoint form's internal structure belongs to the consumed graph structure itself unless the policy explicitly projects, filters, expands, flattens, or otherwise transforms it.

---

<!-- PRECEDING SECTION: Acceptance Constraint -->

## Failure and Unresolved-Consumption Behavior

<!-- FOLLOWING SECTION: Endpoint Policy Compilation -->

An endpoint-consumption policy SHOULD define what happens when an endpoint expression cannot be consumed under the policy.

Failure or unresolved-consumption behavior is graph-defined and profile-relative.

Possible behaviors include:

- the compiled endpoint-consumption closure is undefined;
- an unresolved consumed endpoint form is produced;
- a validation diagnostic is produced;
- a graph-delta diagnostic is produced;
- a profile-defined fallback view is attempted;
- a profile-defined repair or normalization is attempted;
- endpoint consumption fails strictly.

C4 Core does not require one universal failure behavior.

However, a compiled endpoint-consumption closure MUST NOT silently reinterpret an endpoint expression in a way not licensed by the endpoint-consumption policy object or active profile.

---

<!-- PRECEDING SECTION: Failure and Unresolved-Consumption Behavior -->

## Endpoint Policy Compilation

<!-- FOLLOWING SECTION: Profile-Defined Endpoint Policy Schema -->

Endpoint-consumption policy objects MAY be compiled into endpoint-consumption closures.

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

Compilation MAY derive optimized implementation normal forms from the policy graph, including tuple-like forms, cached closures, specialized validators, lazy evaluators, or profile-defined fast paths.

Any such normal form remains a derived projection of $\xi_\pi$.

The endpoint-policy graph-object remains the graph-native source of truth.

---

<!-- PRECEDING SECTION: Endpoint Policy Compilation -->

## Profile-Defined Endpoint Policy Schema

<!-- FOLLOWING SECTION: Minimal Schema Summary -->

Most endpoint-consumption policy schema details are profile-defined.

Profile-defined details include, but are not limited to:

- exact relation names for endpoint-policy roles;
- exact graph-object names for standard views;
- exact graph-object names for standard constraints;
- whether consumed endpoint forms are always graph-objects or may remain operational forms;
- whether recursive views are allowed;
- how recursive traversal boundaries are defined;
- how list, sequence, tree, frame, tuple, set, and role structures are represented;
- whether scalar bounds are represented directly or through named constraint objects;
- whether ordering is represented by sequence graph structure, successor edges, role labels, or another graph-native form;
- whether diagnostics are attached to policy objects, consumed forms, graph-delta objects, or validator outputs;
- how endpoint-policy compilation is cached or specialized.

A profile MAY define additional endpoint-policy roles, but additional roles MUST NOT contradict the C4 Core distinction among endpoint-policy graph-objects, compiled endpoint-consumption closures, consumed endpoint forms, and relator denotation.

---

<!-- PRECEDING SECTION: Profile-Defined Endpoint Policy Schema -->

## Minimal Schema Summary

<!-- FOLLOWING SECTION: Integration Notes for Endpoint-Consumption Policy Minimal Schema -->

A minimally conforming C4 endpoint-consumption policy SHOULD represent the following as graph structure:

- an endpoint-policy root;
- an endpoint-view description;
- an acceptance constraint over the consumed endpoint form;
- failure or unresolved-consumption behavior.

C4 Core does not require every endpoint-consumption policy object to contain every possible view, constraint, diagnostic, or optimization structure.

However, when a profile claims C4 endpoint-policy minimal-schema conformance, the endpoint view, acceptance constraint, and failure behavior it emits SHOULD be represented as graph structure using the semantics defined above.

---

<!-- PRECEDING SECTION: Minimal Schema Summary -->

## Integration Notes for Endpoint-Consumption Policy Minimal Schema

<!-- FOLLOWING SECTION: Open Questions for Endpoint-Consumption Policy Minimal Schema -->

When this addendum is incorporated into the C4 Mathematical Core or a standard C4 endpoint-policy profile, the following integration edits SHOULD be applied.

The Endpoint Consumption Policies section SHOULD state that $\xi_\pi$ is the root of an endpoint-policy graph region.

The endpoint-consumption compilation section SHOULD state that $\mathrm{compile}_{\mathfrak{F}}(\xi_\pi)$ compiles the graph-native policy object into an operational closure.

The list-expression section SHOULD continue to state that nested list structure is not flattened by default.

The endpoint-policy section SHOULD avoid presenting $(V,A,W)$ or $(V,\beta)$ as normative C4 Core semantics. Such tuples MAY be presented only as explanatory or implementation normal forms.

The validation section SHOULD distinguish endpoint-policy validation, endpoint-consumption closure execution, consumed endpoint form validation, and relator denotation.

---

<!-- PRECEDING SECTION: Integration Notes for Endpoint-Consumption Policy Minimal Schema -->

## Open Questions for Endpoint-Consumption Policy Minimal Schema

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- exact standard relation names for endpoint-policy roles;
- exact standard graph-object names for whole-endpoint and first-level-member policy objects;
- whether consumed endpoint forms $\mathcal{C}$ should always be graph-objects or may remain operational forms;
- whether C4 Core should define standard constraint objects such as exactly-one, between, and at-least-one;
- how endpoint-policy diagnostics should relate to graph-delta diagnostics;
- how recursive endpoint views should interact with graph traversal boundaries;
- whether endpoint policy objects should be reusable across relators, endpoint positions, and profiles;
- how Fish should serialize endpoint-policy objects and endpoint-consumption failures.
