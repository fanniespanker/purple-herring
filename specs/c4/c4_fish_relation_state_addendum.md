# C4/Fish Relation-State Addendum v0.1.6-interim

## Status

This interim addendum records the current relation-state consensus for the C4/Fish v0.1.6 draft line.

It is intended to be appended into `specs/c4/c4_specification.md` when that combined C4/Fish document is next reorganized or split into separate C4 Core and Fish Language specifications.

Until then, this addendum supersedes the older `&`, `&?`, `&!`, `&?!` tail-mode interpretation wherever the two conflict.

---

## 1. C4 Relation-State Model

C4 statements are modeled as relation applications with an attached relation-state.

A statement is written:

$$
P=(\mathbf{s},\mathbf{r},\mathbf{t},\psi_k)
$$

where:

- $\mathbf{s}\in\mathcal{E}$ is the source expression;
- $\mathbf{r}\in\mathcal{E}$ is the relation-position expression;
- $\mathbf{t}\in\mathcal{E}$ is the target expression;
- $\psi_k\in\Psi$ is the relation-state.

Relations are expressions. Relation-position admissibility is profile-relative and SHOULD be handled by validation predicates such as:

$$
\mathrm{RelOk}_\Gamma(\mathbf{r})
$$

rather than by a globally fixed primitive relation-expression subset.

Context is not a primitive slot of $P$. Context, provenance, source attribution, modality, temporal validity, and related qualifiers SHOULD be represented as ordinary C4 statements about the statement-resource $\iota_P(P)$.

---

## 2. Relation-State Domain

Let:

$$
\Psi
$$

be the C4 relation-state domain.

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

These states are non-probabilistic. They preserve unresolved relation-state structure without requiring ranking, weighting, likelihood assignment, or forced collapse. Profiles MAY define weighted, probabilistic, preferential, or collapse procedures, but such structures are not part of C4 Core.

---

## 3. Relation-State Application Notation

C4 Core writes relation-state application as:

$$
\psi_k : \mathbf{r}(\mathbf{s},\mathbf{t})
$$

where `:` is the C4 Core relation-state application operator.

The operator `:` applies a relation-state to the relation application $\mathbf{r}(\mathbf{s},\mathbf{t})$. It is not Fish prefix syntax, namespace syntax, type annotation, ratio notation, or ordinary punctuation.

Resolved affirmative state:

$$
\psi_\top : \mathbf{r}(\mathbf{s},\mathbf{t})
\equiv
\mathbf{r}(\mathbf{s},\mathbf{t})
$$

Resolved negative state:

$$
\psi_\bot : \mathbf{r}(\mathbf{s},\mathbf{t})
\equiv
\neg\mathbf{r}(\mathbf{s},\mathbf{t})
$$

Generic unresolved state:

$$
\psi_\star : \mathbf{r}(\mathbf{s},\mathbf{t})
$$

preserves unresolved non-probabilistic superposition over the relation application.

---

## 4. Fish Relation-State Operators

Fish relation-state operators map to C4 relation-states as follows:

| Fish marker | C4 relation-state | Meaning |
|---|---|---|
| `&` | $\psi_\top$ | canonical alias for resolved affirmative |
| `&+` | $\psi_\top$ | explicit resolved affirmative |
| `&?+` | $\psi_{\star\top}$ | unresolved affirmative-oriented |
| `&?` | $\psi_\star$ | generic unresolved / unoriented |
| `&?-` | $\psi_{\star\bot}$ | unresolved negative-oriented |
| `&-` | $\psi_\bot$ | resolved negative |

Bare `&` remains valid Fish surface syntax and canonicalizes as an alias of `&+` unless a future profile explicitly disallows the alias.

The older markers `&!` and `&?!` are superseded by `&-` and `&?-` respectively for the relation-state model described here.

Recommended migration:

```text
A&rel@B    -> A&+rel@B or A&rel@B
A&?rel@B   -> A&?rel@B
A&!rel@B   -> A&-rel@B
A&?!rel@B  -> A&?-rel@B
```

The marker `?` is Fish surface syntax only. It is not a C4 Core mathematical symbol.

---

## 5. Reverse-Oriented Fish Forms

Reverse-oriented Fish forms attach the relation-state marker to the tail side, preserving the same state mapping.

Examples:

```text
B@rel&A
```

normalizes to:

```text
A&rel@B
```

and maps to:

$$
\psi_\top : \mathbf{rel}(A,B)
$$

```text
B@rel&?+A
```

normalizes to:

```text
A&?+rel@B
```

and maps to:

$$
\psi_{\star\top} : \mathbf{rel}(A,B)
$$

```text
B@rel&-A
```

normalizes to:

```text
A&-rel@B
```

and maps to:

$$
\psi_\bot : \mathbf{rel}(A,B)
$$

Surface reversal remains distinct from inverse-relation semantics.

---

## 6. Notes for Future Integration

When this addendum is merged into the combined C4/Fish spec:

- replace the old Tail Modes section with Relation-State Operators;
- update Core Symbol Summary to list `&`, `&+`, `&?+`, `&?`, `&?-`, and `&-`;
- mark `&!` and `&?!` as deprecated legacy spellings;
- update canonical AST examples from `mode: TailMode` to `state: RelationState`;
- update canonical negative form from `A&!rel@B` to `A&-rel@B`;
- update canonical unresolved negative form from `A&?!rel@B` to `A&?-rel@B`;
- preserve bare `&` as an alias for `&+` unless intentionally removed later.
