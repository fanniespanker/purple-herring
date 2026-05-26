# C4 Endpoint Consumption Compilation Addendum v0.1.6 Draft

## Status

This document is a draft addendum to the C4 Mathematical Core v0.1.6.

It extends the endpoint-consumption policy model defined in `specs/c4/c4_mathematical_core.md` without replacing the core specification text.

The body of this addendum is formatted as whole insertable sections. Each insertable section includes comments naming the intended preceding and following C4 Mathematical Core sections.

---

<!-- PRECEDING SECTION: 11. Endpoint Consumption Policies -->

## 12. Endpoint Consumption Compilation

<!-- FOLLOWING SECTION: 13. Relation-State Application Notation -->

Endpoint-consumption policies MAY be normalized and compiled into endpoint-consumption closures.

This section assumes the C4 Core endpoint-consumption policy form:

$$
\Pi_\Gamma(\mathbf{r},p)=(V,A,W)
$$

where:

- $\mathbf{r}\in\mathcal{E}$ is a relator expression;
- $p\in\{source,target\}$ is the endpoint position;
- $V\in\mathcal{V}_{consume}^{\Gamma}$ is an endpoint view;
- $A\subseteq\mathbb{N}$ is the allowed arity set over that view;
- $W\in\{\mathrm{Ordered},\mathrm{Unordered}\}$ is the order interpretation.

An endpoint view is a partial function:

$$
V:\mathcal{E}\rightharpoonup\mathrm{Seq}(\mathcal{E})
$$

C4 Core defines at least:

$$
\mathrm{Whole}(\mathbf{e})=\langle\mathbf{e}\rangle
$$

and:

$$
\mathrm{Members}_1((\mathbf{e}_1,\ldots,\mathbf{e}_n))=\langle\mathbf{e}_1,\ldots,\mathbf{e}_n\rangle
$$

where $\mathrm{Members}_1$ is defined on list expressions.

### 12.1 Policy Normalization

Let:

$$
\mathcal{P}_{consume}
$$

be the domain of endpoint-consumption policies, and let:

$$
\mathcal{P}_{consume}^{norm}
$$

be the domain of normalized endpoint-consumption policies.

Policy normalization is written:

$$
\omega_\Gamma:\mathcal{P}_{consume}\rightharpoonup\mathcal{P}_{consume}^{norm}
$$

A normalized policy is a canonical policy tuple:

$$
(V,A,W)
$$

where named bundles, aliases, shorthand declarations, and profile-defined abbreviations have been expanded or rejected.

Normalization MAY reject an invalid, unsupported, or incoherent endpoint-consumption policy.

Examples:

$$
\omega_\Gamma(\mathrm{WholeEndpoint})=(\mathrm{Whole},\{1\},\mathrm{Unordered})
$$

$$
\omega_\Gamma(\mathrm{OrderedTriple})=(\mathrm{Members}_1,\{3\},\mathrm{Ordered})
$$

Profiles MAY define additional named bundles and corresponding normalization rules.

### 12.2 Consumed Endpoint Forms

Let:

$$
\mathcal{C}
$$

be the domain of consumed endpoint forms.

A consumed endpoint form is the result of applying an endpoint view, checking arity, resolving selected endpoint expressions as needed, and applying order interpretation.

C4 Core leaves the exact representation of $\mathcal{C}$ abstract.

Implementations MAY distinguish:

- ordered consumed endpoint sequences;
- unordered canonical endpoint collections;
- unresolved or partially resolved endpoint forms;
- profile-defined endpoint forms;
- provenance-preserving endpoint forms;
- diagnostic endpoint forms.

If:

$$
W=\mathrm{Ordered}
$$

then the consumed endpoint form preserves semantic sequence order.

If:

$$
W=\mathrm{Unordered}
$$

then the consumed endpoint form may be canonically reordered, hashed, indexed, or compared without semantic dependence on source order. Source order MAY still be preserved separately for provenance, diagnostics, or round-tripping.

### 12.3 Compiled Endpoint-Consumption Closures

A compiled endpoint-consumption closure is written:

$$
C_{\Gamma,\mathbf{r},p}
=
\mathrm{compile}_\Gamma(\omega_\Gamma(\Pi_\Gamma(\mathbf{r},p)))
$$

where:

$$
C_{\Gamma,\mathbf{r},p}:\mathcal{E}\rightharpoonup\mathcal{C}
$$

The closure applies the normalized policy to an endpoint expression.

Abstractly, for policy:

$$
(V,A,W)
$$

and endpoint expression:

$$
\mathbf{e}\in\mathcal{E}
$$

it performs:

1. endpoint view selection:

$$
V(\mathbf{e})=\langle\mathbf{e}_1,\ldots,\mathbf{e}_n\rangle
$$

2. arity checking:

$$
n\in A
$$

3. endpoint resolution or preservation according to the active profile and relator semantics;

4. order interpretation according to $W$.

The closure is partial. It is undefined if the view is undefined, the arity check fails, required expression resolution fails, or profile-relative endpoint-consumption validation fails.

### 12.4 Optimization Permissions

Implementations MAY cache, fuse, specialize, lazily evaluate, or prevalidate compiled endpoint-consumption closures, provided canonical behavior is preserved.

Useful cache keys include:

$$
(\Gamma,o_r,p)
$$

for a resolved relator object $o_r$, and:

$$
(\Gamma,\Pi_\Gamma(\mathbf{r},p))
$$

for reusable policy-level compilation.

Implementations MAY also cache endpoint-view results, such as:

$$
\mathrm{Members}_1(\mathbf{l})
$$

for canonical list expressions $\mathbf{l}\in\mathcal{E}_{list}$.

Arity checks SHOULD be performed before expensive expression resolution when the endpoint view permits it.

For example, under:

$$
(\mathrm{Members}_1,\{3\},\mathrm{Ordered})
$$

an implementation may check first-level member count before resolving any member expressions.

### 12.5 Relator Application with Compiled Consumption

A relator application MAY be modeled using compiled endpoint-consumption closures:

$$
\psi_k:\mathbf{r}
\left(
C_{\Gamma,\mathbf{r},source}(\mathbf{s}),
C_{\Gamma,\mathbf{r},target}(\mathbf{t})
\right)
$$

This notation describes endpoint-consumption semantics and does not change the canonical statement tuple:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

The canonical statement remains expression-level. Endpoint-consumed forms are derived semantic or operational forms, not replacement syntax for the statement.

### 12.6 Denotation and Materialization Separation

Endpoint consumption is distinct from materialization.

Materialization of derived statements is a separate profile-relative process.

A profile MAY materialize derived statements from a consumed relator application, but endpoint consumption itself does not require materialization.

Thus a relator may consume a decomposed endpoint, denote a structured relation application, and still avoid emitting derived statements unless a materialization profile, query engine, indexer, exporter, or execution profile requires them.

---

<!-- PRECEDING SECTION: 18. Validation -->

## 19. Integration Notes for Endpoint Consumption Compilation

<!-- FOLLOWING SECTION: 20. Open Questions -->

When this addendum is incorporated into the C4 Mathematical Core, the following integration edits SHOULD be applied.

The section currently titled `Relation-State Application Notation` SHOULD be renumbered after `Endpoint Consumption Compilation`.

Validation SHOULD mention endpoint-consumption closure compilation where relevant, while preserving the distinction among:

- endpoint consumption;
- relator semantics;
- relation-state semantics;
- denotation;
- materialization.

Conformance notes SHOULD permit implementations to normalize, cache, fuse, specialize, lazily evaluate, or prevalidate endpoint-consumption closures, provided canonical behavior is preserved.

The canonical statement tuple MUST remain unchanged:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

Endpoint-consumed forms are derived semantic or operational forms; they are not replacement syntax for statements.

---

<!-- PRECEDING SECTION: 19. Integration Notes for Endpoint Consumption Compilation -->

## 20. Open Questions for Endpoint Consumption Compilation

<!-- FOLLOWING SECTION: End of addendum / C4 Mathematical Core open questions -->

The following remain open for future formalization:

- whether $\mathcal{C}$ should be subdivided into ordered, unordered, unresolved, partially resolved, and profile-defined consumed endpoint forms;
- whether closure compilation should be described only as an implementation permission or as a normative semantic phase;
- whether profile-defined endpoint views require a separate conformance level;
- whether materialization should be formalized as a function from denotations to derived statements, graph patches, indexes, or all of these;
- whether consumed endpoint forms should be reifiable as C4 objects;
- whether endpoint-consumption closures should be cacheable across resolution environments or only within a fixed $\Gamma$.
