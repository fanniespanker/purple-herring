# C4 Relator Metadata Minimal Schema Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It defines a deliberately small graph-native minimal schema for relator metadata.

The schema is intentionally sparse. Most relator behavior, member interpretation, state compatibility, endpoint-policy selection, graph-delta production details, validation, and optimization are profile-, implementation-, validator-, compiler-, or standard-library-defined.

This addendum assumes the consolidated notation in `c4_mathematical_core.md`:

$$
\xi_r\in\Xi
$$

for a resolved relator graph-object,

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

for endpoint-consumption policy lookup, and:

$$
\boldsymbol{\delta}_{\mathfrak{F}}:\Xi_\alpha\rightharpoonup\Xi_\Delta
$$

for graph-delta production.

The body of this addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: Statement Domain -->

## Relator Metadata Minimal Schema

<!-- FOLLOWING SECTION: Endpoint Consumption Policies -->

A relator graph-object is a graph-object that is admissible in relator position under an active field.

For a statement:

$$
P=(\mathbf{x}_s,\mathbf{x}_r,\mathbf{x}_t,\psi_k)
$$

if:

$$
\mathfrak{F}(\mathbf{x}_r)=\xi_r
$$

then:

$$
\xi_r\in\Xi
$$

is the resolved relator graph-object.

C4 Core does not require relator graph-objects to use one fixed physical layout. A relator profile MAY choose any graph layout that preserves the minimal C4 relator semantics.

A minimally conforming relator graph-object SHOULD expose the following as graph structure:

1. relator-position admissibility;
2. source endpoint-consumption policy selection;
3. target endpoint-consumption policy selection;
4. relation-state compatibility or state-handling semantics;
5. graph-delta production semantics or a pointer to graph-delta production behavior.

These roles are graph-defined. They are not enum primitives, non-graph fields, external lists, protocol codes, or fixed tuple axes.

Everything beyond this minimal shape is profile-defined unless another C4 specification explicitly standardizes it.

---

<!-- PRECEDING SECTION: Relator Metadata Minimal Schema -->

## Relator-Position Admissibility

<!-- FOLLOWING SECTION: Endpoint Policy Selection -->

A graph-object is not automatically admissible in relator position merely because it belongs to:

$$
\Xi
$$

Relator-position admissibility is field- and profile-relative.

Validators MAY expose a predicate such as:

$$
\mathrm{RelOk}_{\mathfrak{F}}(\mathbf{x}_r)
$$

or:

$$
\mathrm{RelOk}_{\mathfrak{F}}(\xi_r)
$$

but the admissibility basis SHOULD be represented as graph metadata associated with the relator graph-object, active profile, or active field.

C4 Core does not require a separate relator-object subdomain. A profile MAY define one, but the core requirement is only that relator-position admissibility be graph-definable and inspectable under the active field.

---

<!-- PRECEDING SECTION: Relator-Position Admissibility -->

## Endpoint Policy Selection

<!-- FOLLOWING SECTION: Relation-State Compatibility -->

A relator graph-object SHOULD determine, directly or indirectly, endpoint-consumption policies for its source and target endpoint positions.

For endpoint position:

$$
p\in\{source,target\}
$$

endpoint-policy lookup is written:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

where:

$$
\xi_\pi\in\Xi
$$

is an endpoint-consumption policy graph-object.

A relator may select endpoint policies by direct relation, inherited profile policy, default library policy, active field policy, or profile-defined fallback.

C4 Core does not require a relator to store endpoint policies inline. It only requires that endpoint-policy selection be resolvable under the active field when endpoint consumption is required.

If no endpoint policy is resolvable for a required endpoint position, endpoint consumption is undefined unless a profile defines a default fallback policy.

---

<!-- PRECEDING SECTION: Endpoint Policy Selection -->

## Relation-State Compatibility

<!-- FOLLOWING SECTION: Member Interpretation Metadata -->

A relator graph-object SHOULD define, or be associated with, relation-state compatibility and relation-state handling semantics.

Relation-state compatibility is graph-defined and profile-relative.

Validators MAY expose a predicate such as:

$$
\mathrm{StateOk}_{\mathfrak{F}}(\psi_k,\xi_r)
$$

but the accepted states and any state-driven behavior SHOULD be represented as graph metadata associated with the relator graph-object, active profile, or active field.

C4 Core does not require primitive state-coupling tuple axes such as `StateTransparent`, `StateRestricted`, or `StateDriven`.

Those may be useful implementation normal forms, but they remain derived projections of graph-defined relator metadata.

If a relator does not support a relation-state and no profile-defined fallback exists, denotation is undefined or validation fails under the active profile.

---

<!-- PRECEDING SECTION: Relation-State Compatibility -->

## Member Interpretation Metadata

<!-- FOLLOWING SECTION: Graph-Delta Production Semantics -->

Relator member interpretation describes how consumed endpoint forms are interpreted by relator denotation.

Common member-interpretation modes include:

- single participant interpretation;
- distributive interpretation;
- candidate or alternative interpretation;
- conjunctive interpretation;
- collective interpretation;
- tuple-like interpretation;
- frame-like interpretation;
- profile-defined interpretation.

These modes are not endpoint-consumption axes.

Endpoint-consumption policy determines how endpoint expressions are consumed into consumed endpoint forms. Relator member interpretation determines how the relator semantically treats those consumed forms.

C4 Core does not require a fixed member-interpretation enumeration.

A compiler or evaluator MAY derive implementation-oriented projections such as:

$$
Q_{\mathfrak{F}}(\xi_r)
$$

but such projections are derived from graph-defined relator metadata, not primitive C4 Core tuple fields.

---

<!-- PRECEDING SECTION: Member Interpretation Metadata -->

## Graph-Delta Production Semantics

<!-- FOLLOWING SECTION: Relator Denotation and Graph-Delta Objects -->

A relator graph-object SHOULD define, or be associated with, graph-delta production semantics.

For statement-derived graph-delta production:

$$
\mathbf{d}_{\mathfrak{F}}(P)
:=
\boldsymbol{\delta}_{\mathfrak{F}}(\iota_P(P))
$$

where:

$$
\iota_P(P)\in\Xi_\alpha
$$

is the statement graph-object treated as a delta-source graph-object.

The resolved relator graph-object:

$$
\xi_r=\mathfrak{F}(\mathbf{x}_r)
$$

participates in determining how the statement graph-object produces a graph-delta object.

Relator metadata MAY define or reference:

- endpoint-consumption behavior;
- consumed endpoint interpretation;
- relation-state handling;
- graph-delta construction behavior;
- validation behavior;
- materialization expectations;
- profile-defined semantics.

C4 Core does not require primitive relator-kind axes such as assertion, constructor, query, transform, mapping, node-effect, edge-effect, return value, or yield kind.

Such categories may be represented as graph metadata, graph-delta object structure, profile-defined relator classes, or implementation normal forms.

---

<!-- PRECEDING SECTION: Graph-Delta Production Semantics -->

## Profile-Defined Relator Metadata Schema

<!-- FOLLOWING SECTION: Minimal Schema Summary -->

Most relator metadata schema details are profile-defined.

Profile-defined details include, but are not limited to:

- exact relation names for relator metadata roles;
- exact graph-object names for standard relator classes;
- whether a relator-specific subdomain of $\Xi$ is defined;
- how endpoint policies are selected, inherited, defaulted, or overridden;
- how relation-state compatibility is represented;
- how member interpretation is represented;
- how relator behavior participates in graph-delta production;
- whether relator metadata is stored on the relator object, profile object, library object, or active field;
- how validators expose relator admissibility and state compatibility;
- how compilers cache relator metadata and endpoint-policy lookup.

A profile MAY define additional relator metadata roles, but additional roles MUST NOT contradict the C4 Core distinction among relator graph-objects, endpoint-consumption policy objects, consumed endpoint forms, graph-delta production, and materialization.

---

<!-- PRECEDING SECTION: Profile-Defined Relator Metadata Schema -->

## Minimal Schema Summary

<!-- FOLLOWING SECTION: Integration Notes for Relator Metadata Minimal Schema -->

A minimally conforming C4 relator metadata profile SHOULD represent the following as graph structure:

- relator-position admissibility;
- source endpoint-consumption policy selection;
- target endpoint-consumption policy selection;
- relation-state compatibility or state-handling behavior;
- graph-delta production semantics or a reference to graph-delta production behavior.

C4 Core does not require every relator graph-object to contain every possible behavior, constraint, diagnostic, materialization, or optimization structure.

However, when a profile claims C4 relator metadata minimal-schema conformance, the relator-position admissibility, endpoint policy selection, state handling, and graph-delta production behavior it emits SHOULD be represented as graph structure using the semantics defined above.

---

<!-- PRECEDING SECTION: Minimal Schema Summary -->

## Integration Notes for Relator Metadata Minimal Schema

<!-- FOLLOWING SECTION: Open Questions for Relator Metadata Minimal Schema -->

When this addendum is incorporated into the C4 Mathematical Core or a standard C4 relator profile, the following integration edits SHOULD be applied.

The Statement Domain section SHOULD continue to define $\mathbf{x}_r$ as the relator expression and $\xi_r=\mathfrak{F}(\mathbf{x}_r)$ as the resolved relator graph-object.

The Endpoint Consumption Policies section SHOULD state that endpoint-policy lookup is relator- and endpoint-position-relative:

$$
\xi_\pi=\Pi_{\mathfrak{F}}(\xi_r,p)
$$

The validation section SHOULD distinguish relator-position admissibility, endpoint-policy selection, endpoint-consumption closure execution, relation-state compatibility, consumed endpoint form validation, graph-delta production, and materialization.

The graph-delta production section SHOULD state that statement-derived delta production is controlled partly by graph-defined relator metadata.

The core spec SHOULD avoid defining primitive relator-kind tuple axes unless a future profile explicitly introduces them as implementation normal forms.

---

<!-- PRECEDING SECTION: Integration Notes for Relator Metadata Minimal Schema -->

## Open Questions for Relator Metadata Minimal Schema

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- exact standard relation names for relator metadata roles;
- whether C4 Core should define a relator-role subdomain such as $\Xi_r$ or leave relator-position admissibility entirely predicate/profile-defined;
- whether source and target endpoint-policy selection should have standard graph-object names;
- whether relation-state compatibility should have standard graph-object names;
- whether common member interpretations should be standardized in a C4 profile;
- whether graph-delta production behavior should be represented as a policy object, relator class, callable graph object, or profile-defined evaluator hook;
- how Fish should serialize relator metadata, relator validation failures, and relator-state incompatibility.
