# CiNnaMoN (Cognitive-Narrative Musical Notation)

CiNnaMoN is a structured, human-readable temporal annotation language for expressive or performative text segments.

Music elements may appear as semantic content inside any CNML container.

CiNnaMoN is not a programmatic execution system. It expresses **temporal intent and structural constraints**, not explicit computation.

---

# 1. Semantic Foundations

## 1.1 Semantic Duality Principle

CiNnaMoN operates under a dual semantic regime:

---

## 1.1.1 Authorial (Normative) Semantics

All temporal attributes (`time`, `beat`, `duration`) serve a **normative compositional function**:

- guide authors in producing musically coherent notation
- constrain structural plausibility of rhythmic expression
- establish local consistency of temporal intent

In this mode:

- values are treated as **intent descriptors**
- authors are NOT expected to perform arithmetic reasoning
- symbolic forms (including fractions, symbols, or irrational expressions) are expressive, not computational

Importantly:

> authoring does not require a unified numeric domain

Temporal values MAY be symbolic, rational, irrational, or abstract at the source level.

---

## 1.1.2 Operational (Renderer) Semantics

Temporal attributes are secondarily interpreted by renderers as **operational constraints**:

- validate structural consistency
- resolve timing relationships for playback, layout, or simulation
- detect under- or over-specified structures

In this mode:

- interpretation is implementation-defined
- renderers MAY normalize into any internal representation:
  - rational arithmetic
  - floating-point systems
  - fixed-point systems
  - symbolic constraint solvers
  - hybrid timing engines
- results MUST NOT be re-encoded back into CiNnaMoN source syntax

Renderers MAY reject inputs they cannot operationally resolve.

---

## 1.2 Non-Reification Constraint

Operational interpretation MUST NOT be treated as part of CiNnaMoN source semantics.

That is:

- computed timing is **derivative**
- evaluation does not modify authorial meaning
- CiNnaMoN text remains invariant under rendering

---

## 1.3 Structural Validation Hierarchy

Renderers MAY apply validation at two distinct layers:

### (1) Structural Plausibility Checks
- measure grouping consistency
- required attribute presence
- event continuity constraints
- inheritance consistency within a bar

### (2) Temporal Resolution
- mapping symbolic durations to internal time
- scheduling events in playback or rendering space
- resolving timing conflicts

These layers are distinct and MUST NOT be conflated.

---

## 1.4 Temporal Value Domain Rule

Temporal values are interpreted as **symbolic expressions at the authorial layer**.

They are not required to conform to a unified numeric system during authoring.

Renderers MAY map values into any internal domain, including:

- rational numbers
- floating-point representations
- fixed-point arithmetic
- constraint-based timing systems
- symbolic evaluators

No canonical numeric representation is mandated by CiNnaMoN.

---

# 2. Rendering Invariant Kernel (RIK)

CiNnaMoN defines a **non-canonical interpretation model**.

All valid renderings MUST satisfy the following invariants.

---

## 2.1 Event Existence Invariant

Every syntactic event MUST map to at least one rendered event:

$$
\forall e \in C,\ \exists r(e) \in R(C)
$$

Where:
- \(C\) = CiNnaMoN source
- \(R(C)\) = rendering space
- \(r(e)\) = realized event mapping

---

## 2.2 Event Identity Preservation

Event types MUST remain distinguishable:

- note
- rest
- speech (`X`)
- caesura (`//`)
- tie/slur (`~`)

These MAY be transformed in implementation, but MUST remain structurally separable.

---

## 2.3 Temporal Order Invariance

Event order within a bar (`|`) MUST be preserved:

If:
$$
e_1 \prec e_2
$$

Then:
$$
r(e_1) \prec r(e_2)
$$

Allowed:
- expressive timing variation
- rubato, swing, temporal deformation
- local compression/stretching

Not allowed:
- reordering events within a bar

---

## 2.4 Bar Boundary Invariance

Bar delimiters (`|`) define hard segmentation boundaries.

All renderings MUST preserve:
- grouping within bars
- separation between bars

---

## 2.5 Duration Ratio Preservation

Relative durations MUST remain invariant up to global scaling:

$$
\frac{d_1}{d_2}
$$

MUST be preserved structurally under rendering.

Absolute time MAY vary.

---

## 2.6 Pitch Identity Constraint

Explicit pitch definitions MUST remain traceable in rendering unless explicitly transformed by renderer policy.

---

## 2.7 Structural Non-Collapse Constraint

Renderers MUST NOT:

- merge distinct event types into indistinguishable outputs
- destroy event ordering
- remove bar structure
- eliminate proportional duration relationships
- collapse pitch identity where explicitly defined

---

## 2.8 Interpretive Freedom Principle

Renderers MAY vary:

- absolute timing
- expressive timing
- speech realization (`X`)
- caesura interpretation (`//`)
- tie/slur rendering behavior
- synthesis backend
- visual notation strategy

---

## 2.9 Optional IR Principle

Renderers MAY construct internal IRs, but:

- IRs are not standardized
- IRs are not part of CiNnaMoN semantics
- IRs MUST preserve all RIK invariants
- IRs MUST NOT be exposed as canonical meaning

---

## 2.10 Semantic Summary

CiNnaMoN defines:

> a constrained space of structurally equivalent but interpretively variable temporal event realizations.

---

## 2.11 Formal Characterization

$$
C \rightarrow \mathcal{P}(R)
$$

Where:
- \(C\) = CiNnaMoN source
- \(R\) = valid rendering space

---

# 3. Grammar

## 3.1 Core Element

```xml
<music time="" beat="" key="" mode="" tempo="" mood="">
```

---

## 3.2 Attributes

- `time`: beats per measure (numeric or symbolic)
- `beat`: beat unit denominator
- `key`: tonal center
- `mode`: modal context
- `tempo`: BPM or descriptive
- `mood`: expressive descriptor

---

## 3.3 Structure

```
content ::= bar ("|" bar)*
bar ::= sequence
sequence ::= element (whitespace element)*
element ::= note | rest | speech | caesura | tie
```

---

## 3.4 Duration

```
duration ::= integer "/" integer
```

Examples:
- `1/4`, `3/16`, `7/5`

Renderers MAY approximate symbolic values.

---

## 3.5 Note Syntax

```
note ::= pitch ":" duration "{" lyric "}"
       | pitch ":" duration
       | pitch "{" lyric "}"
       | pitch
```

---

## 3.6 Pitch Syntax

```
pitch ::= [A-G] accidental? octave?
```

---

## 3.7 Rest Syntax

```
rest ::= "R" (":" duration)?
```

---

## 3.8 Tie / Slur Syntax

```
tie ::= "~"
```

### Tie / Slur Semantics

The operator `~` is interpreted between adjacent notes:

- If pitches are equal → **tie**
  - duration merges
  - no re-articulation

- If pitches differ → **slur**
  - articulation is connected
  - pitch remains distinct

This classification depends only on pitch equality.

---

## 3.9 Caesura Syntax

```
caesura ::= "//"
```

### Semantics

Caesuras are interpretive breaks:

- not comments
- not fixed-duration rests
- not structural requirements

Renderers MAY interpret them as:
- breath marks
- pauses
- fermata-like suspension gestures

But CiNnaMoN does not prescribe timing.

---

## 3.10 Speech Syntax

```
speech ::= "X" (":" duration)? "{" lyric "}"
```

### Speech Semantics

Speech events are pitch-agnostic at source level.

Pitch realization is:

- performer-determined (live systems)
- renderer-determined (audio systems)
- implementation-defined (general systems)

Speech MAY be:
- structured into multiple events
- or expressed as a single interpretive window

---

## 3.11 Inheritance Rules (Measure Scope)

Within a bar:

- first explicit note defines pitch, octave, duration
- subsequent events inherit last explicit values
- inheritance resets at bar boundary (`|`)

Inheritance is:

- local to each bar
- independent of duration or beat count
- not time-aware

---

## 3.12 Measure Validation Responsibility

Authors are responsible for structural correctness:

- time signature coherence
- measure completeness
- duration plausibility

Renderers MAY optionally validate but are not required to enforce strict correctness.

---

# 4. Interpretation Model

CiNnaMoN is not a deterministic compiler language.

It defines:

> a constrained interpretation space over temporally ordered event structures.

Renderers:

- MAY construct IRs
- MAY choose evaluation strategies
- MAY interpret ambiguous constructs
- MUST respect RIK invariants

---

# 5. Summary

CiNnaMoN is:

> a canonical syntactic system defining a structurally constrained but non-canonical space of temporal musical interpretations.

It guarantees:

- structure
- ordering
- proportional relationships
- event identity constraints

It does NOT guarantee:

- canonical output
- deterministic rendering
- single execution semantics