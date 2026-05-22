# PÂTE (Positional Affine Text Encoding) (FINALIZED)

## 1. Overview

PÂTE is a deterministic spatial constraint language for CNML.

It compiles span declarations into a deterministic affine constraint system whose dependency topology forms a directed graph.

PÂTE is:

- declarative
- graph-based
- deterministic
- non-optimizing

PÂTE defines layout purely as deterministic affine relationships between span geometries.

---

## 2. Role in and Relationship to CNML

PÂTE is currently distributed and instantiated as part of the CNML toolchain, where it functions as a projection layer within the CNML rendering pipeline:

```text
CNML → PÂTE projection → affine constraint system → renderer
```

PÂTE is currently integrated with CNML for practical deployment and bootstrapping.

It is not semantically dependent on CNML. CNML presently serves as an upstream structural serialization substrate.

Future versions of PÂTE are intended to operate independently of CNML as a standalone representation and compilation target.

---

## 3. Core Model

Formally, a PÂTE program compiles into:

$$
G = (V, E)
$$

Where:

$$
\begin{aligned}
V &= V_s \cup V_a \\
V_s &= \{ s \mid s \text{ is a span} \} \\
V_a &= \{ a \mid a \text{ is an anchor basis element} \} \\
\text{Span} &:= V_s \\
\text{AnchorBasis} &:= V_a \\
E &\subseteq \mathcal{S} \\
\mathcal{S} &= \left(Span \times AnchorBasis\right)^2 \times \mathbb{Q}^2
\end{aligned}
$$

This can be interpreted as:

$$
(A,a,B,b,\delta) \in E
$$

Where:

- \(A,B \in \text{Span}\)
- \(a,b \in \{<, |, >\}\)
- \(\delta \in \mathbb{Q}\)

---

## 4. Span Geometry Model

A span is a contiguous textual unit with renderer-resolved geometry.

Each span defines exactly three anchor basis positions:

- leading
- center
- trailing

These basis positions are immutable geometric projections within the affine resolution system.

### 4.1 Geometry Resolution Semantics

Span geometry is determined during affine spatial resolution prior to final rendering.

Resolved geometry MAY depend on:

- font metrics
- glyph shaping
- ligatures
- renderer configuration
- typographic environment
- text shaping systems

Final rendering occurs only after:

1. affine spatial resolution
2. optional metric shaping

---

## 5. Identifier System (PÂTE Scope Only)

All PÂTE identifiers are defined as non-empty sequences of Unicode scalar values whose Unicode General Category belongs to the permitted set defined below.

### 5.1 Permitted Unicode Categories

The permitted Unicode General Categories are:

- Letter (L)
- Mark (M)
- Number (N)
- Connector Punctuation (Pc)
- Private Use (Co)
- Modifier Symbol (Sk)
- Other Symbol (So)
- Currency Symbol (Sc)
- Format (Cf)

### 5.2 Identifier Grammar

```ebnf
ID := NON_NUMERIC_PERMITTED_CODEPOINT PERMITTED_CODEPOINT*
```

Where:

- `PERMITTED_CODEPOINT` is any Unicode scalar value whose General Category belongs to the permitted set above.
- `NON_NUMERIC_PERMITTED_CODEPOINT` is any permitted codepoint not belonging to the Number category.

### 5.3 Identifier Equality

Identifier equality is strict sequence equality over Unicode scalar values.

$$
ID_A = ID_B
\iff
\text{sequence}(ID_A)=\text{sequence}(ID_B)
$$

No normalization, canonical equivalence, grapheme equivalence, or visual equivalence is implied.

### 5.4 Non-Normative Notes

- Order-sensitive
- Length-sensitive
- Visually indistinguishable identifiers MAY be distinct
- Authors are responsible for maintaining reproducible identifiers

---

## 6. Alignment System

### 6.1 Anchor Basis

PÂTE defines a fixed anchor basis:

$$
A = \{<, |, >\}
$$

corresponding to:

- leading
- center
- trailing

### 6.2 Alignment Operators

Alignment operators are syntactic selectors over the anchor basis.

They are:

- not anchors
- not graph nodes
- not runtime objects
- not semantic entities

They exist solely as compile-time selectors.

### 6.3 Cartesian Product Semantics

Alignment operates over:

$$
A \times A
$$

Each alignment expression selects exactly one ordered pair:

$$
(source\_basis,\ target\_basis)
$$

### 6.4 Edge Construction Rule

Given:

```text
A SOURCE_OP TARGET_OP B
```

the compiler constructs:

```text
A[SOURCE_OP] → B[TARGET_OP]
```

producing exactly one affine constraint edge.

### 6.5 Operator Pair Table (Illustrative)

| Source \ Target | `<` | `|` | `>` |
|---|---|---|---|
| `<` | `< → <` | `< → |` | `< → >` |
| `|` | `| → <` | `| → |` | `| → >` |
| `>` | `> → <` | `> → |` | `> → >` |

This table is illustrative only.

### 6.6 Determinism Rule

Every alignment expression MUST resolve to exactly one anchor-basis pair.

No contextual interpretation or ambiguity is permitted.

### 6.7 Compilation Invariant

All alignment expressions compile to:

```text
Edge = (source_span.basis, target_span.basis, δ)
```

Alignment operators do not survive compilation.

---

## 7. Offset System

### 7.1 Grammar

```ebnf
SPAN :=
  "{{"
  SOURCE_SPAN?
  SOURCE_ALIGN_OPERATOR
  TARGET_ALIGN_OPERATOR
  TARGET_HORIZONTAL_SPAN
  H_OFFSET?
  (TARGET_VERTICAL_SPAN V_OFFSET?)?
  ("::" CONTENT)?
  "}}"

SOURCE_SPAN := SPAN_ID

SOURCE_ALIGN_OPERATOR := ALIGN_OPERATOR

TARGET_ALIGN_OPERATOR := ALIGN_OPERATOR

ALIGN_OPERATOR := "<" | "|" | ">"

TARGET_HORIZONTAL_SPAN := SPAN_ID

H_OFFSET := OFFSET+

TARGET_VERTICAL_SPAN := SPAN_ID

V_OFFSET := "," OFFSET+

OFFSET := SIGN OFFSET_BODY

SIGN := "+" | "-"

OFFSET_BODY := SCALE SPAN_ID

SCALE := RATIONAL_NUMBER?

RATIONAL_NUMBER :=
    POSITIVE_INTEGER "/" POSITIVE_INTEGER
  | POSITIVE_INTEGER

POSITIVE_INTEGER :=
  [1-9][0-9]*
```

### 7.2 Content Payload

```ebnf
CONTENT := renderer-defined payload
```

PÂTE does not define CONTENT semantics.

### 7.3 SCALE Semantics

SCALE denotes:

$$
k \in \mathbb{Q}^+
$$

If:

$$
SCALE = \varepsilon
$$

then:

$$
k = 1
$$

---

## 8. Affine Vector Formulation

### 8.1 Span Position Vectors

A span \(S\) possesses:

$$
\vec{p}(S) \in \mathbb{R}^2
$$

### 8.2 Width and Height Semantics

Unless otherwise specified:

$$
w(S)
\quad \text{and} \quad
h(S)
$$

refer to renderer-resolved span extents computed during affine spatial resolution prior to metric shaping.

These MAY depend on:

- font metrics
- shaping systems
- ligatures
- glyph substitution
- renderer configuration
- typographic environment

Metric shaping MUST NOT retroactively alter resolved affine geometry.

### 8.2 Symbolic Affine Semantics

Within PÂTE source semantics, affine displacement coefficients are represented symbolically over:

$$
\mathbb{Q}^2
$$

PÂTE source semantics do not prescribe a concrete numeric realization model.

Renderer evaluation MAY convert symbolic affine quantities into implementation-defined geometric representations, including:

- floating-point
- fixed-point
- arbitrary precision
- renderer-native coordinate systems

Operational numeric realization is not part of PÂTE source semantics.

---

### 8.3 Coordinate System

PÂTE defines:

- positive \(x\) increasing rightward
- positive \(y\) increasing downward

matching SVG coordinate semantics.

### 8.4 Projection Operators

#### Horizontal

$$
\pi_x(\vec{p}(S))
=
x(S)\hat{x}
$$

#### Vertical

$$
\pi_y(\vec{p}(S))
=
y(S)\hat{y}
$$

---

## 9. Alignment Projection Operators

Alignment operators are geometric projections over resolved span geometry.

### 9.1 Leading

$$
\alpha_{<}(S)
=
-\frac{1}{2}w(S)\hat{x}
$$

### 9.2 Center

$$
\alpha_{|}(S)
=
0
$$

### 9.3 Trailing

$$
\alpha_{>}(S)
=
+\frac{1}{2}w(S)\hat{x}
$$

### 9.4 Vertical Semantics

Vertical alignment currently uses center projection semantics.

No independent vertical alignment operator system currently exists.

---

## 10. Offset Vectors

Each offset defines a symbolic affine displacement vector.

### 10.1 General Form

$$
\delta_i
=
\pm k_i \cdot d(S_i)
$$

Where:

- \(k_i \in \mathbb{Q}^+\)
- sign is explicit
- \(d(S_i)\) is a directional span extent vector

### 10.2 Horizontal Offset

$$
\delta_i
=
\pm k_i \cdot w(S_i)\hat{x}
$$

### 10.3 Vertical Offset

$$
\delta_i
=
\pm k_i \cdot h(S_i)\hat{y}
$$

---

## 11. Canonical Affine Equation

Given:

```PÂTE
{{A<>B+1/10B-3/2C,D-7/8E+1/2F}}
```

the resulting affine equation is:

$$
\vec{p}(A)
=
\pi_x(\vec{p}(B))
+
\pi_y(\vec{p}(D))
+
\alpha_{>}(B)
-
\alpha_{<}(A)
+
\sum_i \delta_i
$$

### 11.1 Horizontal Offsets

$$
\delta_1
=
+\frac{1}{10}w(B)\hat{x}
$$

$$
\delta_2
=
-\frac{3}{2}w(C)\hat{x}
$$

### 11.2 Vertical Offsets

$$
\delta_3
=
-\frac{7}{8}h(E)\hat{y}
$$

$$
\delta_4
=
+\frac{1}{2}h(F)\hat{y}
$$

---

## 12. Evaluation Pipeline

PÂTE evaluation proceeds in the following order:

1. Parse source syntax
2. Construct span table
3. Resolve alignment operators
4. Construct affine constraint system
5. Resolve affine geometry
6. Apply optional metric shaping
7. Perform final rendering

---

## 13. Invalidity Conditions

A PÂTE program is ill-formed if:

- affine constraints are contradictory
- affine resolution is impossible
- cyclic metric dependencies exist
- referenced spans are undefined
- alignment expressions are ambiguous

Renderers MAY reject ill-formed programs.

---

## 14. Metric Constraint Layer

Metric constraints operate strictly after affine resolution.

They affect typographic density only.

They MUST NOT:

- modify resolved affine geometry
- alter affine position vectors
- trigger re-resolution
- alter graph topology

### 14.1 Grammar

```ebnf
METRIC_CONSTRAINT :=
  SPAN_ID "~" RATIONAL_NUMBER SPAN_ID
```

### 14.2 Semantics

$$
w(A)
=
k \cdot w(B)
$$

Where:

- \(k \in \mathbb{Q}^+\)
- widths are evaluated post-resolution
- geometry remains fixed

### 14.3 Implementation Examples

Renderers MAY implement metric shaping via:

- interword spacing
- tracking adjustment
- glyph scaling
- typographic justification
- font variation systems

---

### 14.4 Dependency Rule

Given:

$$
A \sim kB
$$

the rendered width of \(B\) MUST be computable prior to application of the metric constraint on \(A\).

Metric dependency cycles are ill-formed.

---

## 15. Interpretation

PÂTE defines a deterministic affine vector constraint system over typographic spans.

Span position is determined by:

- affine projection
- alignment basis selection
- offset vectors
- resolved span geometry

All semantics are deterministic, compositional, and graph-resolvable.