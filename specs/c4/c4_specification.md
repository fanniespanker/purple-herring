# C4 v0.1.6 Technical Specification

## 0. Status

C4 v0.1.6 is the current technical specification for the C4 abstract relation model used by the Purple Herring stack.

C4 expands to:

```text
Contextual Compositional Concept Calculus
```

C3TCalc is the former development name of C4 and remains only a historical term in supersession lists, migration notes, and design history.

Version delta:

```text
previous: v0.1.5
current:  v0.1.6
delta:    +0.0.1
```

This version supersedes the following C3TCalc / C4 drafts for technical purposes:

- C3TCalc v0.1 Standalone Specification (Draft)
- C3TCalc v0.1.1 Specification
- C3TCalc v0.1.2 Technical Specification
- C3TCalc v0.1.3 Merged Technical Specification

The synchronized lay-facing companion is:

```text
C4 for Non-Pescatarians v0.1
```

Former title:

```text
C3TCalc for Non-Pisces v0.1.4
```

Version policy:

```text
Intentional content patch to the C4 technical specification: +0.0.1
Pure typo / formatting correction with no interpretive effect: no version bump required
C4 for Non-Pescatarians uses only major/minor versions and tracks the corresponding C4 language line. For example, C4 for Non-Pescatarians v0.1 explains the C4 v0.1.x technical series.
```

This version preserves the current fish surface-language decisions for authoring C4 expressions:

- a complete fish is itself a first-class resource;
- ordinary fish use `&` as the tail marker;
- unresolved and negative relation states are tail-mode modifiers: `&?`, `&!`, `&?!`;
- `_` is anonymous resource binding;
- `*X` is named scoped binding introduction;
- `$X` is query / return binding;
- relations are positional templates, e.g. `is_[owner]_of`;
- canonical lists are comma-separated `ListExpr` values;
- schools / fish blocks use `{ ... }`;
- `fuse` and `aggregate` are ordinary relation templates, not primitive operators;
- old bracketed parameter lists are removed from canonical syntax;
- relation-chain syntax is reserved future-valid syntax but unimplemented in v0.1.6.

This version includes implementation and ontology scaffolding migrated from earlier drafts:

- Unicode identifier rules;
- literal and percent-escape rules;
- Base64 typed literal codecs;
- reverse-oriented fish surface syntax;
- strict mode vs diagnostic mode;
- inverse relation semantics;
- parser core vs ontology/template library separation;
- relation template metadata;
- local declarations and gradual formalization;
- ontology definition profile;
- storage and indexing notes;
- implementation locks and CLI shape;
- historical notes from C3TCalc v0.1 to C4 v0.1.6.

---

## 1. Purpose

C4 defines the abstract graph-native relation model for deterministic semantic relations, graph patterns, scoped bindings, query bindings, context grounding, typed declarations, local relation definitions, ontology-defined relation templates, and canonical graph-expression serialization.

Fish is the canonical machine-parseable and human-readable surface language for authoring, exchanging, parsing, and displaying C4 expressions.

A fish document, fish block, or fish statement encodes C4 relations, but C4 itself is not identical to fish syntax.

C4 is independently useful as a standalone semantic model. Fish is independently useful as a readable C4 expression language.

Other C4 serializations MAY exist, including JSON, XML, binary, RDF/graph-native, or implementation-internal encodings. Fish remains the canonical Purple Herring surface language for C4 expressions unless an active profile declares otherwise.

It may be used as:

- an abstract semantic graph/relation model;
- a semantic graph expression model;
- a fish-authored relation language;
- a CNML embedded fish relation language;
- a graph-pattern notation;
- an ontology-bridging notation;
- a deterministic graph-patch source language;
- a query / annotation / metadata syntax;
- a relation-template and ontology-definition notation;
- a source language for graph patch IR;
- a human-readable meaning-map notation.

---

## 2. Design Principles

C4 is graph-anatomical rather than algebraic.

Relations have tails and heads.

A complete fish surface expression encodes one complete C4 relation expression.

A complete fish is itself a **resource**.

Bindings may be referential, anonymous, existential, declarative, or returned.

Context is explicit.

Fusion and aggregation are relation kinds rather than primitive arithmetic-looking operators.

Relation meaning belongs to relation templates / ontologies, not to the parser core.

C4 should support both:

- formal ontology definition where precision matters;
- local declarations where expression matters.

---

## 3. Core Concepts

### 3.1 Resource

A resource is any addressable semantic thing in C4.

Resources may include:

- people;
- characters;
- scenes;
- books;
- concepts;
- roles;
- locations;
- relation templates;
- relation-template instances;
- complete fish;
- fish blocks / schools;
- anonymous resources;
- query-bound resources;
- scoped declared resources.

Resource paths use `/` traversal:

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
roles/femme_fatale
politics/movements/antifascism
```

Prefixed names use `:`:

```text
hw:locations/Santa_Virginia
geo:US/CA/San_Diego
mdo:Movements/antifascism
```

---

### 3.2 Fish

A **fish** is a complete surface expression that encodes a C4 relation.

Canonical anatomy:

```text
tail&relation@head
```

Teaching/display anatomy:

```text
tail
  & relation
  @ head
```

A fish has:

- a tail resource/expression;
- a relation resource/template instance;
- a head resource/expression;
- a tail mode;
- optional context.

A fish is itself a first-class resource.

This means a complete fish may be addressed, cited, contextualized, negated, disputed, supported, grouped, queried, transformed, or related to other fish.

---

### 3.3 School / Fish Block

A **school** is a scoped block of fish.

Syntax:

```text
{
  fish;
  fish;
}
```

A school is itself a structured resource.

Example:

```text
Act_2/Chapter_17&establishes@{
  Andrea&is_[owner]_of@Judith;
  Judith&is_[pet]_of@Andrea;
}
```

Meaning:

```text
Act 2, Chapter 17 establishes the school containing those two fish.
```

---

## 4. Core Symbol Summary

```text
&      relation tail marker
&?     unresolved/contextual tail mode
&!     asserted negative tail mode
&?!    unresolved/contextual negative tail mode
@      relation head marker
~      context / scope grounding
_      anonymous resource binding
*X     named scoped binding introducer
$X     query / return binding
X      referential resource use
/      resource / concept / type / scope path traversal
:      prefix separator inside prefixed names
^      mapping / projection
(...)  canonical ListExpr
{...}  school / fish block / binding scope
;      fish / statement separator inside schools
[...]  positional relation-template slot inside relation names
"..."  universal literal surface
%      literal escape inside quoted literals
```

Reserved or currently unassigned:

```text
=      reserved; no canonical parameter-assignment syntax in v0.1.6
+      reserved; not aggregation
.      reserved; not primary traversal
|      reserved
!      reserved outside tail-mode position
< >    reserved
#      reserved
,      active as canonical ListExpr separator
```

Removed from canonical v0.1.6:

```text
relation[param=value]
A?relation@B
bare * as anonymous binding
```

Canonical replacements:

```text
relation-template slots: is_[owner]_of
unresolved mode:        A&?relation@B
anonymous binding:      _
```

---

## 5. Unicode Identifier Rules

C4 identifiers SHOULD use Unicode identifier classes.

```text
identifier_initial   = Unicode XID_Start
identifier_continue  = Unicode XID_Continue, excluding structural delimiters
```

Structural delimiters include all active and reserved syntax characters:

```text
& ? ! @ ~ _ * $ = . , ; ( ) [ ] { } " : + < > / ^ | # %
```

The exact delimiter set MAY be profile-specific, but v0.1.6 parsers MUST reserve all active syntax characters.

The underscore `_` is a standalone anonymous resource binding when it appears as its own expression.

The underscore MAY appear inside ordinary identifiers:

```text
is_sibling_of
unreliable_narrator
post_transfer_sovereignty
```

Initial `_` in longer user-authored identifiers is discouraged in v0.1.6 because `_` is semantically meaningful as anonymous binding and initial `_` may later be reserved for implementation/internal symbols.

Recommended public identifiers SHOULD NOT begin with `_`.

---

## 6. Statement Lists and Schools

Semicolon separates fish/statements.

```text
statement_list ::= statement (";" statement)* ";"?
```

Newlines are whitespace in v0.1.6 unless a future file profile assigns them additional meaning.

Braces define school/block scope:

```text
{
  statement;
  statement;
}
```

Schools introduce binding scope for named scoped bindings, query bindings, declarations, and local relation definitions.

Schools are also structured resources.

---

## 7. Resource / Concept / Scope Paths

The slash `/` denotes traversal within a resource-like address space.

Example:

```text
Politics/movements/feminism/radical_feminism
```

Path traversal may be used for:

- conceptual traversal;
- type-to-subtype traversal;
- scope traversal;
- resource-local addressing;
- ontology-local addressing;
- document-local addressing;
- prefix-expanded IRI-relative addressing.

A path expression is not itself a relation assertion.

It resolves a resource-like path under the current prefix, scope, or resource environment.

Explicit subtype, containment, support, or scope relations must be written as fish.

Examples:

```text
Politics/movements/feminism
Fannie_Spanker/books/Hardboiled_Whore/chapters/12
hw:chapters/12
mdo:Movements/antifascism
```

The dot `.` is reserved in v0.1.6.

It MAY later be assigned member access, local projection, file-extension-aware naming, lexical identification, or another traversal subtype, but it is not the primary traversal operator in v0.1.6.

---

## 8. Mapping / Projection

The marker `^` is reserved for mapping / projection semantics.

Mapping/projection expresses that a source expression, resource, type, scope, or graph structure is being transformed, projected, interpreted, or represented under a target form.

Canonical surface form:

```text
source^target
```

Meaning:

```text
project source into / through / toward target
```

Examples:

```text
CNML^C4
CNML/document^ETS
hw:chapters/12^summary
ontology-a/politics/movement^ontology-b/social/ideology
```

Mapping/projection is not relation-tail syntax.

The relation-tail marker is `&`.

If mapping/projection must be reified as an ordinary fish, it may be expressed using relation syntax:

```text
source&maps_to@target
source&projects_to@target
source&interprets_as@target
```

The `^` form is reserved for compact projection notation and may canonicalize into an ontology-defined or Herring-Bones-defined mapping relation only under an explicit projection profile.

---

## 9. Prefixed Names and IRI Prefixes

The colon `:` is reserved for prefixed names.

Example:

```text
mdo:HardboiledWhore
schema:Person
hw:chapters/12
```

A prefixed name expands according to an active scoped prefix declaration.

Prefix declarations SHOULD be written as C4 declarations using declaration templates.

Canonical v0.1.6 preferred form:

```text
*mdo&declare_[prefix]@"https://fanniespanker.github.io/Media-Description-Ontology/";
```

After this declaration:

```text
mdo:Movements/antifascism
```

resolves under the `mdo` prefix.

Prefix declarations are scoped to the nearest school/block or file scope.

No forward prefix reference is required in v0.1.6. A prefix declaration applies after its declaration point within its scope.

Validation rules for prefix declarations:

- tail SHOULD be a named scoped binding;
- declaration template SHOULD indicate `prefix` kind;
- head MUST parse as an IRI/prefix base under the prefix declaration template;
- binding name MUST be a valid prefix identifier;
- binding name MUST NOT collide in the same scope unless shadowing is explicitly allowed.

Anonymous prefixes are invalid or useless:

```text
_&declare_[prefix]@"https://example.org/"
```

---

## 10. Universal Literal Surface

C4 uses a single delimited literal surface:

```text
"..."
```

Quoted literals do not intrinsically mean string.

A quoted literal is interpreted by expected type, relation template, declaration kind, or ontology context.

Examples:

```text
*name&declare_[string]@"Bob";
*age&declare_[integer]@"45";
*height&declare_[decimal]@"1.75";
*mdo&declare_[prefix]@"https://fanniespanker.github.io/Media-Description-Ontology/";
```

Bare identifiers are symbols, loci, concepts, resources, or paths, not strings.

Thus:

```text
Bob
```

is an identifier/resource/concept, while:

```text
"Bob"
```

is a literal surface.

All nonnumeric and numeric literal values SHOULD be quoted in v0.1.6. Numeric-looking bare tokens are not required by the core grammar and SHOULD NOT be relied on.

---

## 11. Literal Escaping

Quoted literals use percent-encoding for escapes.

The double quote character MUST be encoded as:

```text
%22
```

The percent character MUST be encoded as:

```text
%25
```

unless beginning a valid percent escape.

Control characters MUST be percent-encoded.

Examples:

```text
*quote&declare_[string]@"She said %22hello%22.";
*progress&declare_[string]@"100%25 complete";
*line&declare_[string]@"first%0Asecond";
```

Percent escapes use UTF-8 byte encoding.

Decoded literal content is interpreted by expected ontology/type context.

IRI-like literals are canonicalized by the IRI/prefix type, not by generic string rules.

Canonical percent escapes SHOULD use uppercase hexadecimal.

---

## 12. Base64 Literal Codecs

Base64 MAY be used as a typed literal codec, not as the universal escape mechanism.

Examples:

```text
*data&declare_[json_b64]@"eyJuYW1lIjoiQm9iIiwiYWdlIjo0NX0=";
*blob&declare_[bytes_b64]@"AAECAwQ=";
```

Base64 codec types SHOULD use RFC 4648 standard base64, padding required, no whitespace, canonical alphabet only.

Base64 is appropriate for binary data, machine-generated payloads, compressed payloads, or embedded JSON where readability is not required.

Human-authored small literals SHOULD prefer percent-escaped quoted literals.

---

## 13. Fish Anatomy

C4 relation syntax is fish-anatomical.

The tail marker `&` attaches a source/tail resource to a relation.

The head marker `@` attaches that relation to its target/head resource.

Canonical directed fish form:

```text
A&relation@B
```

Meaning:

```text
A --relation--> B
```

Example:

```text
A&fan_of@B
```

Meaning:

```text
A is a fan of B.
```

---

## 14. Tail Modes

The tail marker is always `&` for ordinary relation fish.

Modes modify the tail marker.

```text
&      asserted / operative / crystallized positive fish
&?     unresolved / contextual / interrogative / non-crystallized positive fish
&!     asserted negative fish
&?!    unresolved / contextual / interrogative negative fish
```

`?` is not probability and does not encode statistical confidence.

It marks unresolvedness, contextuality, inquiry, or incomplete crystallization.

`!` marks negative relation polarity when used as part of a tail-mode marker.

Examples:

```text
A&role@roles/femme_fatale
```

Meaning:

```text
A is asserted to have role femme_fatale.
```

```text
A&?role@(roles/femme_fatale,roles/conspirator,roles/unreliable_narrator)
```

Meaning:

```text
A has an unresolved or contextual role relation whose target is the list of femme_fatale, conspirator, and unreliable_narrator.
```

```text
Judith&!is_[owner]_of@Andrea
```

Meaning:

```text
Judith is not Andrea's owner.
```

```text
Judith&?!is_[owner]_of@Andrea
```

Meaning:

```text
It is unresolved/contextual whether Judith is not Andrea's owner.
```

Canonical mode order:

```text
&
&?
&!
&?!
```

If a parser accepts `&!?`, canonical formatting MUST emit `&?!`.

The old unresolved form:

```text
A?role@B
```

is deprecated and non-canonical.

Canonical v0.1.6 form:

```text
A&?role@B
```

---

## 15. Reverse-Oriented Fish Surface Form

A fish may be written from the target/head side by placing the head marker adjacent to the foregrounded resource and the tail marker adjacent to the other resource.

Reverse-oriented asserted form:

```text
A@relation&B
```

Meaning:

```text
B --relation--> A
```

Example:

```text
A@fan_of&B
```

Meaning:

```text
B is a fan of A.
```

The following expressions are semantically equivalent and canonicalize to the same internal directed fish:

```text
A&fan_of@B
B@fan_of&A
```

Canonical internal form:

```text
tail=A
relation=fan_of
head=B
mode=AssertedPositive
```

Reverse-oriented modes attach to the tail side.

Examples:

```text
B@role&?A
```

normalizes to:

```text
A&?role@B
```

```text
B@role&!A
```

normalizes to:

```text
A&!role@B
```

Surface reversal is not inverse-relation semantics.

---

## 16. Inverse Relations

Ontologies SHOULD explicitly define inverse relations.

Inverse behavior MUST NOT be inferred from reverse surface syntax alone.

The following expressions are the same fish written from opposite surface orientations:

```text
A&parent_of@B
B@parent_of&A
```

But this is a distinct relation kind:

```text
B&child_of@A
```

It is equivalent only if the ontology declares:

```text
parent_of inverse child_of
```

Inverses may behave asymmetrically in inference, validation, query expansion, natural-language rendering, materialization, canonicalization, and diagnostics.

Stored relations SHOULD NOT automatically materialize inverse facts unless the ontology explicitly requests materialization.

---

## 17. Context Grounding

The marker `~` grounds an expression in a context, scope, frame, interpretation, or local condition.

Context-grounded form:

```text
expression~context
```

Examples:

```text
A&role@roles/femme_fatale~Chapter3
```

Meaning:

```text
In context Chapter3, A is asserted to have role femme_fatale.
```

```text
A&?role@(roles/femme_fatale,roles/conspirator)~NarratorUncertain
```

Meaning:

```text
Under NarratorUncertain context, A has unresolved role candidates femme_fatale and conspirator.
```

`~` is semantic/contextual grounding.

`{}` is syntactic/binding scope and school construction.

---

## 18. Resource Use and Binding Taxonomy

C4 distinguishes several resource-use forms.

```text
X      referential resource use
_      anonymous resource binding
*X     named scoped binding introducer
$X     query / return binding
```

### 18.1 Referential Resource Use

Bare resource expressions refer to existing or resolvable resources.

Example:

```text
Andrea&role@roles/protagonist
```

`Andrea` and `roles/protagonist` are referential uses.

### 18.2 Anonymous Resource Binding

The underscore `_` introduces an anonymous resource binding.

Example:

```text
_&fuse@(paranormal/ghost,family/mother)
```

Meaning:

```text
an anonymous resource is the fusion of paranormal/ghost and family/mother
```

Each `_` is fresh unless a future syntax explicitly reuses or scopes it.

### 18.3 Named Scoped Binding

The `*` sigil introduces a named scoped binding.

Example:

```text
*friend
```

A named scoped binding may have existential or declarative interpretation depending on the consuming relation template.

### 18.4 Existential Interpretation

In ordinary relation contexts, `*X` has existential interpretation.

Example:

```text
people/Alex&is_friend_of@*friend
```

Meaning:

```text
There exists a scoped resource friend such that Alex is friends with it.
```

### 18.5 Declarative Interpretation

In declaration contexts, `*X` introduces a declared scoped binding.

Example:

```text
*Person&declare_[type]@ontology/Person;
```

Meaning:

```text
Declare the scoped symbol Person as a type.
```

The distinction between existential and declarative interpretation is determined by the consuming relation template.

Declaration templates are provided by Herring Bones or another loaded template library.

### 18.6 Query / Return Binding

The `$` sigil introduces a returned query binding.

Example:

```text
$person&is_sibling_of@people/Jordan
```

Meaning:

```text
Return every person such that person is a sibling of people/Jordan.
```

`$` MUST NOT be used for ordinary declarations.

---

## 19. Binding Kind Safety

A scoped binding name has exactly one binding kind per scope.

The following is invalid if `*X` is forced to bind as both a relation and a locus in the same scope:

```text
A&*X@B; C&rel@*X
```

unless the grammar or explicit annotation disambiguates the two bindings.

Binding kinds may include:

```text
ScopedLocus
ScopedRelation
ScopedValue
ScopedContext
ScopedPath
DeclaredSymbol
```

C4 v0.1.6 requires at minimum:

```text
ScopedLocus
ScopedRelation
DeclaredSymbol
```

---

## 20. Query / Return Binding

The dollar sigil `$` introduces a returned query binding.

It is distinct from scoped binding introduction.

```text
*X
```

means:

```text
there exists X or X is introduced in scope, but do not return X by default
```

```text
$X
```

means:

```text
bind and return X
```

Examples:

```text
$A&is_sibling_of@B
```

Meaning:

```text
Return all A such that A is sibling of B.
```

```text
A&is_sibling_of@$B
```

Meaning:

```text
Return all B such that A is sibling of B.
```

```text
A&$rel@B
```

Meaning:

```text
Return relation(s) from A to B.
```

```text
$A&$rel@$B
```

Meaning:

```text
Return all directed triples A --rel--> B.
```

For v0.1.6, query bindings may be parsed and canonicalized without requiring full query execution.

---

## 21. Existential Relation Queries

The expression:

```text
$A&*@B
```

is deprecated because bare `*` is no longer the canonical anonymous relation binding.

Canonical v0.1.6 should use a named scoped relation binding or a future anonymous relation placeholder if standardized.

Current canonical form:

```text
$A&*r@B
```

Meaning:

```text
Return all A such that there exists some scoped relation r from A to B.
```

To return the relation as well:

```text
$A&$r@B
```

Meaning:

```text
Return all pairs (A, r) such that A --r--> B.
```

To return only the relation:

```text
A&$r@B
```

Meaning:

```text
Return all relations from A to B.
```

Reverse-oriented forms follow the same fish-anatomical rule:

```text
$A@fan_of&B
```

Meaning:

```text
Return all A whom B is a fan of.
```

```text
A@$r&B
```

Meaning:

```text
Return relation(s) from B to A.
```

Open question:

```text
Should `_` be permitted in relation position as an anonymous relation binding?
```

Until resolved, prefer `*r` for existential relation binding and `$r` for returned relation binding.

---

## 22. List Expressions

Parentheses define canonical list expressions.

Canonical list syntax uses commas:

```text
(A,B,C)
```

A list is:

- not an instantiated graph by default;
- not a set by default;
- not a tuple by default;
- not a school;
- not multiple heads;
- not automatically expanded into multiple relations.

Example:

```text
A&rel@(B,C)
```

Means:

```text
tail = A
relation = rel
head = ListExpr(B,C)
```

It does NOT automatically mean:

```text
A&rel@B;
A&rel@C;
```

A relation template may define how to consume a list expression.

Possible list interpretations by relation template:

- candidate list;
- ordered argument list;
- unordered participant list;
- constructor input list;
- co-present role list;
- query result shape.

Whitespace-separated list input is not canonical in v0.1.6.

Optional S-expression export may exist later, but is not default and not canonical.

---

## 23. Relation Endpoints and Lists

C4 v0.1.6 relation anatomy is binary at the graph-expression level:

```text
tail & relation @ head
```

The tail is one expression.

The relation is one relation expression/template instance.

The head is one expression.

A list expression such as `(A,B,C)` may appear as tail or head only where grammar and the relation template allow it.

A list is not an instantiated graph locus and cannot itself bear relations unless explicitly reified.

Invalid as direct graph-locus usage unless explicitly reified by a future profile:

```text
(A,B,C)&some_relation@D
```

Valid as one relation whose head is a list expression:

```text
A&rel@(B,C)
```

Core v0.1.6 AST:

```text
Fish {
  tail: Expr
  relation: RelationExpr
  head: Expr
  mode: TailMode
  context: Optional<Expr>
}
```

List expression AST:

```text
Expr::List(Vec<Expr>)
```

True multi-head, hyperedge, or role-labeled n-ary relation anatomy is deferred beyond v0.1.6.

Open question:

```text
Should relation templates permit ListExpr in tail position?
```

If so, the list remains a non-instantiated expression consumed by the relation template unless explicitly reified.

---

## 24. Relation Templates

Relations are template instances.

Square brackets inside relation names define positional template slots.

Example:

```text
Andrea&is_[owner]_of@Judith
```

Template shape:

```text
is_[role]_of
```

Slot value:

```text
owner
```

Meaning:

```text
Andrea is Judith's owner.
```

Multi-slot example:

```text
hw:locations/Santa_Virginia&is_[20]_[minutes]_[East]_of@geo:US/CA/San_Diego
```

Template shape:

```text
is_[amount]_[unit]_[direction]_of
```

Slot values:

```text
amount    = 20
unit      = minutes
direction = East
```

Meaning:

```text
Santa Virginia is 20 minutes east of San Diego.
```

Template slot values may be ordinary resources, paths, anonymous resources, scoped bindings, query bindings where query context permits, or complete fish.

Example slot filled by a complete fish:

```text
Shosh&?is_[_&fuse@(paranormal/ghost,family/mother)]_of@Andrea
```

The relation template is:

```text
is_[role]_of
```

The slot value is:

```text
_&fuse@(paranormal/ghost,family/mother)
```

---

## 25. Removed Parameter-List Syntax

C4 v0.1.6 does not use bracketed parameter lists.

There is no canonical syntax of the form:

```text
relation[param=value]
```

Structured relation variation should be represented through positional relation templates or ordinary fish.

The marker `=` is reserved.

Former v0.1 example:

```text
A&parent_of[kind=biological]@B
```

Preferred v0.1.6 options:

```text
A&is_[biological_parent]_of@B
```

or:

```text
A&parent_of@B;
[A&parent_of@B]&kind@relation_kinds/biological;
```

where bracketed fish-resource notation remains provisional.

---

## 26. Declarations

Declarations are ordinary C4 fish using declaration relation templates.

Preferred v0.1.6 declaration form:

```text
*binding&declare_[kind]@target
```

Examples:

```text
*name&declare_[string]@"Bob";
*age&declare_[integer]@"45";
*height&declare_[decimal]@"1.75";
*mdo&declare_[prefix]@"https://fanniespanker.github.io/Media-Description-Ontology/";
*R&declare_[relation]@parent_of;
*Person&declare_[type]@schema:Person;
*expr&declare_[c4_expr]@"A&parent_of@B";
```

The declaration kind determines expected target interpretation and validation.

The parser parses declarations as ordinary fish.

The validator/compiler may recognize `declare_[kind]` as scope-affecting.

Declaration records SHOULD remain inspectable rather than being discarded like preprocessor directives.

Legacy v0.1 declaration syntax:

```text
*binding&declare[kind]@target
```

is deprecated in favor of positional template syntax:

```text
*binding&declare_[kind]@target
```

---

## 27. C4 Expressions as Values

A C4 expression may be stored as a declared expression value.

Example:

```text
*expr&declare_[c4_expr]@"A&parent_of@B";
```

The quoted literal is parsed as C4 under the current prefix/ontology scope and stored as a canonical expression value.

The former `declare_[c3t_expr]` spelling is historical and non-canonical. C4 v0.1.6 uses `declare_[c4_expr]`.

A query expression may also be stored:

```text
*q&declare_[c4_expr]@"$A&is_sibling_of@B";
```

The stored value SHOULD preserve both source literal and canonical expression where practical.

Example:

```text
*expr&declare_[c4_expr]@"B@parent_of&A";
```

may canonicalize internally to:

```text
A&parent_of@B
```

assuming reverse-oriented syntax is accepted by the profile.

---

## 28. Fusion and Aggregation

Fusion and aggregation are ordinary relation templates, not primitive operators.

Canonical fusion form:

```text
A&fuse@(B,C)
```

Meaning:

```text
A is the fusion of B and C.
```

Canonical aggregation form:

```text
A&aggregate@(B,C)
```

Meaning:

```text
A is the aggregation of B and C.
```

The tail is the result.

The head list supplies inputs.

Recommended `fuse` template profile:

```text
fuse:
  relation_kind: constructor_relation
  tail_role: result
  head_role: input_list
  head_expected: ListExpr
  eval_default: lazy
  canonical_default: preserve_relation
  expansion_policy: template_defined
```

Surface canonicalization never performs fusion.

Semantic expansion MAY elaborate eager fusion only if an active relation template defines deterministic expansion.

`+` is reserved for optional future syntactic sugar or disallowed in v0.1.6.

`*` is scoped binding introduction only, not fusion.

---

## 29. Complete Fish as Resources

A complete fish is not merely syntax.

It is itself a resource.

Example fish:

```text
Judith&role@roles/femme_fatale
```

This fish contains:

```text
TAIL RESOURCE:
  Judith

RELATION RESOURCE:
  role

HEAD RESOURCE:
  roles/femme_fatale

FISH RESOURCE:
  the complete relation instance Judith&role@roles/femme_fatale
```

Because a fish is a resource, other fish may relate to it.

Fish-resource quoting/addressing syntax is not finalized in v0.1.6.

Working illustrative notation:

```text
[Judith&role@roles/femme_fatale]&grounded_in@Act_2/Chapter_17
```

Meaning:

```text
The fish Judith&role@roles/femme_fatale is grounded in Act 2, Chapter 17.
```

Bracketed fish-resource syntax is provisional unless later standardized.

Potential operations over fish resources include:

- assertion provenance;
- denial;
- contradiction;
- support;
- grounding;
- temporal scoping;
- citation;
- versioning;
- transformation;
- inclusion in a school.

---

## 30. Relation-Chain Continuation

Relation-chain syntax is reserved as future-valid syntax.

It is planned for implementation no later than v1.0.

In v0.1.6, parsers SHOULD recognize chain-like forms and emit a deterministic reserved/unimplemented diagnostic rather than treating them as unrelated malformed syntax.

Example reserved future syntax:

```text
A&parent_of@*X@parent_of&B
```

Intended future desugaring:

```text
{
  A&parent_of@*X;
  B&parent_of@*X;
}
```

Another example:

```text
A&parent_of@*X@parent_of&?B
```

Intended future desugaring:

```text
{
  A&parent_of@*X;
  B&?parent_of@*X;
}
```

v0.1.6 diagnostic:

```text
error: relation-chain continuation is reserved but unimplemented in v0.1.6
note: planned for implementation by v1.0
suggestion: use an explicit school
```

Chain parsing order is planned to be left-to-right by surface traversal.

Relation direction remains determined by fish anatomy, not by surface traversal direction.

Formatters SHOULD be able to expand dense relation chains into canonical multi-line schools if chain syntax is later introduced.

---

## 31. Self-Loops and Relation Diagnostics

C4 permits self-loop relations unless a relation template declares them invalid.

Example:

```text
A&is_grandpa_of@A
```

Meaning:

```text
A is grandpa of A.
```

A relation template MAY mark specific relation kinds as normally acyclic, anti-reflexive, or invalid for self-loops.

In such cases, parsers or validators SHOULD emit diagnostics.

Example diagnostic:

```text
warning: relation `is_grandpa_of` is normally acyclic; self-loop detected
```

Malformed but suggestive expressions may be handled in diagnostic mode.

Example:

```text
A@is_grandpa_of@A
```

Strict mode:

```text
error: relation expression contains two head markers and no tail marker
```

Diagnostic mode:

```text
maybe intended: A&is_grandpa_of@A
meaning: self-loop relation; A is grandpa of A
```

Diagnostic repair suggestions MUST NOT become canonical substrate input unless explicitly accepted and re-parsed in strict mode.

---

## 32. Strict Mode and Diagnostic Mode

C4 implementations SHOULD support at least two parse modes.

Strict mode:

```text
reject malformed expressions
produce deterministic syntax errors
emit no repair interpretation as canonical output
```

Diagnostic mode:

```text
attempt non-canonical repair suggestions
infer likely intended graph shape when safe
explain malformed fish anatomy
show canonical candidate expressions
```

Only strict-mode parsed expressions may become canonical graph input.

Diagnostic suggestions are advisory.

---

## 33. Canonicalization

C4 expressions canonicalize to graph-native structures.

Canonical fish record:

```text
Fish {
  tail: Expr
  relation: RelationExpr
  head: Expr
  mode: TailMode
  context: Optional<Expr>
}
```

Examples:

```text
A&fan_of@B
B@fan_of&A
```

canonicalize to:

```text
tail=A
relation=fan_of
head=B
mode=AssertedPositive
```

```text
A&?role@(roles/femme_fatale,roles/conspirator)~Scene12
```

canonicalizes to a fish with:

```text
tail=A
relation=role
head=ListExpr(roles/femme_fatale,roles/conspirator)
mode=UnresolvedPositive
context=Scene12
```

Canonical formatting SHOULD:

- remove insignificant whitespace;
- preserve required grouping;
- canonicalize lists with commas;
- normalize reverse surface orientation;
- canonicalize tail-mode order;
- preserve ontology-defined ordering where required;
- preserve source order in schools unless a profile defines otherwise;
- normalize literals to NFC where applicable;
- uppercase percent escapes;
- preserve declarations in canonical AST.

---

## 34. Canonical Surface Form

Canonical compact fish form:

```text
tail&relation@head
```

Canonical list form:

```text
(A,B,C)
```

Canonical school form:

```text
{
  A&rel@B;
  C&rel@D;
}
```

Canonical context form:

```text
A&rel@B~Context
```

Canonical negative form:

```text
A&!rel@B
```

Canonical unresolved form:

```text
A&?rel@B
```

Canonical unresolved negative form:

```text
A&?!rel@B
```

Teaching/display forms may use whitespace:

```text
A
  & rel
  @ B
```

Canonical formatting may remove or standardize whitespace.

---

## 35. Fish-Market Operational Terminology

C4 uses fish-market terminology as an informal but standardized documentation layer over formal parser, canonicalization, validation, and evaluation operations.

These terms are not additional syntax. They are recommended terms for documentation, diagnostics, tutorials, CLI output, and tool UX.

```text
raw fish      = source-level fish as written by an author
caught fish   = fish recognized by the parser
clean fish    = canonicalized and/or validated fish
boned fish    = fish whose relation-template skeleton has been exposed
cooked fish   = evaluated or executed fish under an execution profile
served fish   = rendered, exported, reported, or presented result
eaten fish    = result consumed by another tool, system, or workflow
school        = scoped group/block of fish
fish market   = registry, exchange, or publication space for fish, templates, or libraries
fishmonger    = maintainer, author, validator, or tool that prepares fish for use
```

Operational correspondences:

```text
catching a fish  = parsing / recognizing it from source text
cleaning a fish  = canonicalizing and validating it
boning a fish    = exposing or inspecting its relation-template skeleton
cooking a fish   = evaluating or executing it
serving a fish   = emitting a user- or tool-facing result
eating a fish    = downstream consumption of a served result
```

Evaluation is called **cooking**, not eating, because a fish is a first-class resource. Cooking transforms, evaluates, executes, or enacts a fish under explicit rules; it does not imply that the source fish is destroyed.

A cooked fish may produce one or more cooked artifacts, including:

- deterministic traces;
- patch sequences;
- canonical projections;
- validation reports;
- diagnostics;
- execution results;
- rendered/exported forms.

A served fish is a presentation or export of a fish or cooked artifact.

Eating is reserved for downstream consumption of a served result by another tool, workflow, or implementation-defined consumer.

Example workflow:

```text
write fish
-> catch fish
-> clean fish
-> bone fish, if template inspection is needed
-> cook fish
-> serve result
-> downstream consumer may eat result
```

Tooling MAY use these terms in human-facing output, but machine-facing APIs SHOULD expose the precise formal operation names as well.

---

## 36. Relation Registry and Ontology Separation

C4 core syntax MUST NOT bake in semantic relations such as:

```text
parent_of
role
fuse
aggregate
is_[owner]_of
maps_to
```

The parser recognizes:

- fish anatomy;
- tail modes;
- bindings;
- lists;
- schools;
- literals;
- paths;
- prefixes;
- relation-template surface forms.

The parser does not know whether `is_[owner]_of`, `role`, `fuse`, or `maps_to` are semantically valid unless a template library or validation profile is loaded.

Validation, inverse expansion, slot checking, query expansion, canonicalization beyond syntax, and diagnostics depend on a relation registry, Herring Bones module, or ontology definition profile.

C4 SHOULD ship with a small starter ontology for examples, tests, and demos, but those relations are not language core.

---

## 37. Relation Template Metadata

A relation template may specify:

```text
name
template_shape
slot_count
slot_names
slot_types
slot_order_policy
arity
directionality
inverse
inverse_policy
symmetry
asymmetry
transitivity
reflexivity
acyclicity
tail_types
head_types
canonicalization_rule
materialization_policy
query_expansion_policy
validation_diagnostics
human_readable_gloss
```

Example:

```text
parent_of:
  directionality: directed
  inverse: child_of
  symmetry: asymmetric
  reflexivity: invalid
  acyclicity: expected
  materialization_policy: derived_not_stored
```

Example:

```text
is_[role]_of:
  directionality: directed
  slot_count: 1
  slot_names: [role]
  tail_types: [Agent, Resource]
  head_types: [Agent, Resource]
  human_readable_gloss: "tail is role of head"
```

Example:

```text
fuse:
  directionality: constructor_relation
  tail_role: result
  head_expected: ListExpr
  canonicalization: preserve_relation
  expansion_policy: template_defined
```

---

## 38. Relation Storage and Indexing

A directed fish SHOULD be stored once in canonical form.

It SHOULD be indexable by both tail and head.

Canonical storage:

```text
FishId -> Fish
```

Recommended indexes:

```text
by_tail
by_head
by_relation_template
by_tail_kind
by_head_kind
by_context
by_fish_resource
```

Indexing by head is not the same as storing an inverse relation.

For fish whose head or tail expression is a list, indexing behavior is relation-template-defined.

A template MAY index under every atomic list member while preserving the list structure in the canonical record.

Index result order MUST be deterministic.

Because a complete fish is itself a resource, fish identity/hashing/addressing must be stable under canonicalization.

Exact fish-resource addressing remains open in v0.1.6.

---

## 39. Local Relation Declarations

C4 schools may define local relations outside a formal ontology.

Example:

```text
{
  *haunts&declare_[relation]@"recurring affective presence";
  Memory&haunts@Narrator;
}
```

The local relation `haunts` is valid within the school scope.

A local relation declaration says:

```text
this relation exists in this scope
```

An ontology relation definition says more:

```text
this relation has declared semantics, constraints, inverse behavior, slot schemas, and canonicalization rules
```

Local declarations are lightweight and expressive.

Ontology definitions are formal and reusable.

---

## 40. Ontology Definition Profile

Ontologies may be written in C4 using a restricted Ontology Definition Profile.

This avoids a separate ontology DSL while preventing ontology definitions from becoming arbitrary programs.

C4 core provides:

```text
syntax
AST
fish anatomy
tail modes
bindings
lists
schools
literals
declarations
canonicalization framework
diagnostics framework
```

Ontologies provide:

```text
types
constructors
relation templates
slot schemas
inverse declarations
validation rules
literal interpretations
canonicalization profiles
query expansion policies
```

Ontology constructors and validators MUST be pure, deterministic, inspectable, and canonicalizable.

They MUST NOT:

- call the network;
- use randomness;
- depend on wall-clock time;
- mutate substrate state directly;
- change parser grammar;
- execute arbitrary code.

---

## 41. Ontology-Defined Types and Constructors

Ontologies may define their own types and constructors.

Example declarations:

```text
*integer&declare_[type]@"integer literal type";
*date&declare_[constructor]@"date constructor";
*Person&declare_[type]@schema:Person;
```

Example constructor pattern:

```text
*d&construct_[date]@("2026","5","20");
```

A constructor definition may specify:

```text
constructor_kind
argument_shape
argument_types
canonical_form
validation_rule
diagnostic_rule
```

Constructor execution must be deterministic and must produce canonical typed values or validation errors.

---

## 42. Herring Bones Standard Library

C4 SHOULD ship with a production-grade Herring Bones (HB) standard library of relation templates, declaration templates, type templates, constructor templates, diagnostics, and validation profiles.

Herring Bones is not part of the parser core.

Herring Bones is a maintained ontology/template package intended for real authoring, production use, validation, migration, and interoperability.

It MUST NOT be treated merely as reference examples or demo material.

---

## 43. Ontology-Light Authoring Support

Herring Bones SHOULD explicitly support authors who are developing without an established ontology.

C4 must not require authors to fully formalize an ontology before meaningful expression is possible.

Herring Bones SHOULD provide production-grade defaults for:

```text
local relation declaration
local type declaration
local constructor declaration
lightweight glosses
relation slot schemas
scope-local templates
unknown-relation diagnostics
gradual ontology promotion
migration from local declarations to formal ontology definitions
```

Example:

```text
{
  *haunts&declare_[relation]@"recurring affective presence";
  Memory&haunts@Narrator;
}
```

This is not merely tolerated as informal syntax.

It is a supported authoring mode.

Herring Bones SHOULD allow such locally declared relations to be:

- validated within scope;
- documented with glosses;
- inspected by tooling;
- exported or promoted into ontology files later;
- compared against existing Herring Bones or ontology relation templates;
- migrated without destroying authorial intent;
- preserved as local semantics when formalization is undesirable.

---

## 44. Production Relation Libraries

Production C4 SHOULD ship with robust standard relation libraries while keeping C4 core relation-agnostic.

Potential libraries:

```text
core-relations
local-authoring
social-relations
narrative-relations
bibliographic-relations
argument-relations
ontology-relations
causal-relations
mereology
```

These libraries SHOULD be ontology files or relation-registry packages, not parser hardcoding.

Starter ontologies are for examples, validation, and tests.

Herring Bones is for production use.

These libraries do not define the core language.

---

## 45. Gradual Formalization

C4 tooling SHOULD support gradual formalization.

An author may begin with local declarations and later promote them into formal ontology definitions.

Promotion SHOULD preserve:

- original local relation names;
- authorial glosses;
- original source locations;
- usage examples;
- inferred endpoint patterns;
- slot patterns;
- contexts of use;
- unresolved ambiguities;
- migration diagnostics.

Promotion MUST NOT silently change semantics.

If tooling suggests mapping a local relation to a Herring Bones or ontology relation, the suggestion is advisory unless explicitly accepted.

Example:

```text
*haunts&declare_[relation]@"recurring affective presence"
```

might later be promoted into:

```text
*haunts&declare_[relation]@"recurring affective presence";
haunts&directionality@directed;
haunts&tail_type@MemoryLike;
haunts&head_type@SubjectiveAgent;
haunts&inverse@is_haunted_by;
```

The promoted ontology entry remains traceable to the local authoring origin.

---

## 46. Locked v0.1.6 Implementation Decisions

The following implementation decisions are locked for C4 v0.1.6 unless explicitly superseded:

```text
relation_chain_continuation = reserved_valid_future_syntax_unimplemented_in_v0_1_6_planned_by_v1_0
relation_anatomy = single_tail_single_relation_single_head_expression
list_expression_order = source_preserved_template_interpreted
unknown_relation_parse_policy = allowed
unknown_relation_permissive_check = warning
unknown_relation_strict_check = error_unless_locally_declared_or_loaded
prefix_expansion = simple_concatenation
literal_encoding = UTF-8
literal_unicode_normalization = NFC
literal_percent_escapes = uppercase_canonical
raw_quote_inside_literal = forbidden_use_%22
raw_percent_inside_literal = forbidden_unless_valid_escape_or_%25
declaration_preservation = canonical_ast_always_preserves
relation_declaration_emission = profile_defined
ontology_source_language = C4_Ontology_Definition_Profile
initial_implementation_language = Rust
parameter_lists = removed_from_canonical_syntax
anonymous_binding = underscore
named_scoped_binding = star_name
query_return_binding = dollar_name
```

Relation-chain continuation syntax is reserved in v0.1.6.

The AST MUST still support schools, scoped bindings, lists, declarations, relation-template slots, and the explicit multi-statement form needed for future chain desugaring.

List member order is preserved in source and AST.

Semantic order is determined by relation templates.

Unknown relations are syntactically valid.

Validation mode determines whether unknown relations warn or error.

Prefix expansion is mechanical simple concatenation.

The prefix author is responsible for including any intended trailing `/`, `#`, or other delimiter in the declared prefix base.

Declarations remain inspectable in the canonical AST.

Graph emitters may choose declaration-plane emission, ordinary graph-fact emission, or both.

---

## 47. Recommended v0.1.6 CLI Shape

The initial Rust implementation SHOULD expose a CLI with at least:

```text
c4 parse
c4 fmt
c4 check
c4 canon
c4 explain
c4 emit-json
```

`parse` produces an AST or parse diagnostics.

`fmt` produces canonical surface formatting.

`check` validates against local declarations, loaded Herring Bones modules, and optional ontology files.

`canon` emits canonical C4 text or canonical structural JSON if a JSON profile is selected.

`explain` emits human-readable interpretation and diagnostics.

`emit-json` emits a development/debug AST or IR representation.

Optional future tooling:

```text
c4 emit-sexpr
c4 emit-cbor
c4 emit-archive
```

S-expression export is non-default and non-canonical unless a future profile says otherwise.

---

## 48. Serialization Policy

Canonical identity in v0.1.6 is defined by:

- canonical C4 surface text;
- canonical parser/AST semantics;
- deterministic canonicalization rules.

JSON AST output may be provided for development, tests, snapshots, and tooling.

JSON is not the final canonical binary or structural serialization unless a stricter canonical JSON profile is later defined.

Optional S-expression export may be added later as a non-default, non-canonical tooling/debug format.

Future canonical structural serialization candidates include:

- canonical CBOR with a strict profile;
- custom C4 binary archive format;
- other deterministic binary formats after AST stabilization.

---

## 49. Diagnostics

Recommended diagnostic categories:

```text
MalformedFishAnatomy
ReservedUnimplementedChain
UnknownRelationTemplate
BindingKindConflict
DuplicateScopedBinding
UndeclaredPrefix
InvalidLiteralEscape
InvalidListSyntax
InvalidTemplateSlot
IllegalParameterBracketSyntax
FishResourceSyntaxUnfinalized
NonCanonicalQuestionTailSyntax
IllegalParameterBracketSyntax
NonCanonicalBareStarAnonymousBinding
```

Diagnostic mode may suggest repairs.

Strict mode must not turn suggestions into canonical output unless explicitly accepted and re-parsed.

Example:

```text
A@is_grandpa_of@A
```

Diagnostic:

```text
error: fish contains two head markers and no tail marker
maybe intended: A&is_grandpa_of@A
```

---

## 50. Historical Notes from C3TCalc v0.1 to C4 v0.1.6

### 50.1 Unresolved Tail Syntax

Former v0.1 form:

```text
A?role@B
```

Canonical v0.1.6:

```text
A&?role@B
```

### 50.2 Anonymous Binding

Former v0.1 form:

```text
*
```

Canonical v0.1.6:

```text
_
```

### 50.3 Parameter Lists

Former v0.1 form:

```text
A&parent_of[kind=biological]@B
```

Canonical v0.1.6 alternatives:

```text
A&is_[biological_parent]_of@B
```

or fish-resource annotation:

```text
[A&parent_of@B]&kind@relation_kinds/biological
```

where `[fish]` remains provisional.

### 50.4 Grouping to Lists

Former v0.1 language described comma groups as grouped co-presence and permitted endpoint groups.

C4 v0.1.6 uses `ListExpr`:

```text
(A,B,C)
```

A list is a single expression consumed by relation templates.

It is not automatically a graph, set, tuple, multi-head relation, or expanded fish group.

### 50.5 Standard Template Library Rename

Former v0.1 used `STL`.

C4 v0.1.6 uses:

```text
Herring Bones (HB)
```

Herring Bones is the standard relation/template library.

---

## 51. Repository Naming

Recommended public project identity:

```text
repo: purple-herring
language: C4
source extension: .fish
toolchain: SARDINE
standard library: Herring Bones
```

Release channels:

```text
Surströmming / surstromming = alpha / unstable
pickled = beta
smoked = release candidate
herring / stable = stable release
```

Machine-safe channel names should avoid Unicode:

```text
surstromming
pickled
smoked
stable
```

Human-facing docs may use:

```text
Surströmming
```

---

## 52. Development Log: Relation Fish

During early C3TCalc syntax development, before the rename to C4, the relation-tail marker was reconsidered after `&` was found to work naturally with `@` as a head marker while `^` remained available for mapping/projection and `.` remained reserved.

The candidate relation form:

```text
A&fan_of@B
```

was observed to resemble a fish.

This produced the informal relation-fish motif, preserved through the C3TCalc → C4 rename:

```text
&C4@
```

Interpretation:

```text
&        tail fin / relation-tail attachment
C4       relation body
@        head / target attachment
```

Mnemonic:

```text
A&rel@B
```

means the relation-fish swims from `A` to `B`.

This note is historically informative and terminologically normative: a complete relation expression is called a fish.

---

## 53. Open Questions

- What exact syntax should address or quote a complete fish as a resource?
- Should bracketed fish-resource syntax `[fish]` become canonical?
- Should `_` always be fresh per occurrence, or can anonymous resources be scoped structurally?
- Should `_` be allowed in relation position as anonymous relation binding?
- Should declaration templates remain `declare_[kind]` or use another positional form?
- What should the default validation profile do with unknown relation templates?
- Should `.fish` be the only source extension?
- What canonical binary format should be evaluated after AST stabilization?
- What is the exact v0.1.6 EBNF grammar?
- What is the exact canonical AST schema for all expression kinds?
- What conformance levels should be standardized?

---

## 54. Foundational Claim

C4 is not just a prettier triple syntax.

A fish is a first-class resource.

That means relations can point not only to ordinary resources, but also to complete relation instances, schools of fish, anonymous fused resources, contextualized statements, local declarations, and mappings between systems.

The fish is both statement and thing.

That is the core semantic leverage of C4.

C4 is an ontology priesthood machine with a layperson parish interface.

Formal ontologies may define cathedrals of relation templates, inverses, constructors, constraints, and canonicalization rules.

Local C4 schools may still declare expressive scoped relations without requiring every utterance to be admitted into a formal ontology first.

The core language remains compact, graph-native, deterministic, ontology-extensible, and independently implementable.

