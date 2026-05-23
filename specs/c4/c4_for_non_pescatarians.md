# C4 for Non-Pescatarians v0.1

## 0. What This Is

This is the lay-facing companion to:

```text
CURRENT - C4 Technical Specification
```

Language version:

```text
C4 v0.1.x
```

C4 expands to:

```text
Contextual Compositional Concept Calculus
```

C3TCalc is the former development name of C4.

The technical spec is authoritative for parser, syntax, validation, and canonicalization rules.

This document explains the C4 v0.1.x language series in plain language.

C4 is a compact language for making **meaning-maps**.

It lets people and software write down relationships between things clearly enough that they can be parsed, searched, compared, transformed, and discussed.

The technical spec says exactly how the language works.

This document explains the idea in plain language.

Version policy:

```text
C4 for Non-Pescatarians uses major/minor versions and tracks the corresponding C4 language series.
For example, C4 for Non-Pescatarians v0.1 explains the C4 v0.1.x technical series.
Intentional content patches that affect interpretation, examples, syntax, semantics, or terminology should update this guide when relevant.
Pure typo / formatting corrections do not require a version change.
```

---

## 1. The Basic Shape

The basic shape of C4 is:

```text
tail & relation @ head
```

Read it as:

```text
tail --relation--> head
```

Or in ordinary English:

```text
this thing has this relationship to that thing
```

A complete relation statement is called a **fish**.

A fish has three main parts:

```text
TAIL RESOURCE
  the thing the relation starts from

RELATION
  the named connection

HEAD RESOURCE
  the thing the relation points to
```

Example teaching form:

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
  & role
  @ roles/femme_fatale
```

Compact form:

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith&role@roles/femme_fatale
```

Plain English:

```text
Judith, a character in Hardboiled Whore by Fannie Spanker, has the role femme fatale.
```

---

## 2. Fish-Market Terminology

C4 uses fish-language as a mnemonic layer over formal graph-calculus operations.

These terms are informal teaching names. The technical specification remains authoritative.

```text
raw fish      = source-level C4 fish as written by an author
caught fish   = fish recognized by the parser
clean fish    = canonicalized / validated fish
boned fish    = fish whose relation-template skeleton has been exposed
cooked fish   = evaluated / executed fish under an execution profile
served fish   = rendered, exported, reported, or presented result
eaten fish    = result consumed by another tool, system, or workflow
school        = grouped block of fish
fish market   = registry, exchange, or publication space for fish / templates / libraries
fishmonger    = maintainer, author, validator, or tool that prepares fish for use
```

The most important distinction is:

```text
catching a fish  = parsing / recognizing it from source text
cleaning a fish  = canonicalizing and validating it
cooking a fish   = evaluating or executing it
```

Evaluation is called **cooking**, not eating, because a fish is a first-class resource. Cooking transforms or enacts the fish under explicit rules; it does not imply that the source fish is destroyed.

A cooked fish may produce a trace, patch sequence, projection, diagnostic, report, or other cooked artifact.

A served fish is what a user or tool sees after cooking or formatting.

Eating is reserved for downstream consumption of a result by another tool or workflow.

Example workflow:

```text
write fish
-> catch fish
-> clean fish
-> cook fish
-> serve result
-> downstream tool may eat result
```

---

## 3. Quick Syntax Reference

The most important pattern is:

```text
TAIL & RELATION @ HEAD
```

Read it as:

```text
TAIL --RELATION--> HEAD
```

Markers:

```text
&      asserted relation
&?     unresolved/contextual relation
&!     negative asserted relation
&?!    unresolved/contextual negative relation
@      relation target / head marker
~      context grounding
_      anonymous resource
*X     named scoped resource
$X     return this in a query
X      ordinary resource reference
/      resource path traversal
:      prefix separator
^      mapping / projection
(...)  list expression
{...}  school / fish block
;      fish separator inside schools
[...]  positional relation-template slot
"..."  literal
%      literal escape
```

Reserved for later:

```text
= + . | ! < > #
```

Examples:

```text
Judith&role@roles/femme_fatale
Judith&?role@(roles/femme_fatale,roles/conspirator)
Judith&!is_[owner]_of@Andrea
roles/ghost_mother&fuse@(paranormal/ghost,family/mother)
Act_2/Chapter_17&establishes@{
  Andrea&is_[owner]_of@Judith;
  Judith&is_[pet]_of@Andrea;
}
```

---

## 4. Reading a Basic Fish

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
  & role
  @ roles/femme_fatale
```

Break it apart like this:

```text
TAIL RESOURCE:
  Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
```

This path identifies the thing being described.

It can be read as:

```text
Fannie_Spanker
  /books
    /Hardboiled_Whore
      /characters
        /Judith
```

So `Judith` is not just a floating label. It means:

```text
the character Judith inside Hardboiled Whore, under Fannie Spanker's books
```

The relation is:

```text
RELATION:
  role
```

The relation says what kind of connection is being asserted.

The head resource is:

```text
HEAD RESOURCE:
  roles/femme_fatale
```

That path makes clear that `femme_fatale` is a role category.

So the fish means:

```text
Judith --role--> femme_fatale
```

---

## 5. Unresolved Fish

Sometimes a relationship should not be treated as fully settled.

C4 marks that with `&?`.

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
  &? role
  @ (roles/femme_fatale,roles/conspirator)
```

Compact form:

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith&?role@(roles/femme_fatale,roles/conspirator)
```

Plain English:

```text
Judith's role is unresolved between femme fatale and conspirator.
```

The tail marker is still `&`, but it has a mode modifier:

```text
&? = unresolved / contextual / interrogative / not fully crystallized
```

The head is a list:

```text
(roles/femme_fatale,roles/conspirator)
```

That list does not automatically create multiple relationships.

It means the `role` relation points to a list expression, and the `role` template decides how to interpret that list.

---

## 6. Negative Fish

C4 can also assert a negative relation with `&!`.

```text
Judith
  &! is_[owner]_of
  @ Andrea
```

Compact form:

```text
Judith&!is_[owner]_of@Andrea
```

Plain English:

```text
Judith is not Andrea's owner.
```

The tail marker is still `&`, but it has a mode modifier:

```text
&! = asserted negative relation
```

This is direct negative content.

It is different from saying that someone denies a positive fish.

For example, this says the relation itself is negative:

```text
Judith&!is_[owner]_of@Andrea
```

But this, using provisional fish-resource notation, says someone denies a positive fish:

```text
[Judith&is_[owner]_of@Andrea]&denied_by@Andrea
```

Those are related ideas, but not the same.

---

## 7. Context-Grounded Fish

The `~` marker grounds a fish in a context.

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
  & role
  @ roles/femme_fatale
  ~ Fannie_Spanker/books/Hardboiled_Whore/chapters/03
```

Compact form:

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith&role@roles/femme_fatale~Fannie_Spanker/books/Hardboiled_Whore/chapters/03
```

Plain English:

```text
In Chapter 3, Judith has the role femme fatale.
```

The context part is:

```text
~Fannie_Spanker/books/Hardboiled_Whore/chapters/03
```

So the expression does not necessarily say Judith is always and globally a femme fatale.

It says this relation is grounded in Chapter 3.

---

## 8. Fusion

Fusion is not a punctuation trick.

It is an ordinary relation.

```text
roles/femme_fatale-conspirator
  & fuse
  @ (roles/femme_fatale,roles/conspirator)
```

Compact form:

```text
roles/femme_fatale-conspirator&fuse@(roles/femme_fatale,roles/conspirator)
```

Plain English:

```text
The role femme_fatale-conspirator is the fusion of femme fatale and conspirator.
```

In this fish:

```text
TAIL RESOURCE:
  roles/femme_fatale-conspirator
```

is the fused result.

```text
RELATION:
  fuse
```

says the tail is a fusion.

```text
HEAD RESOURCE:
  (roles/femme_fatale,roles/conspirator)
```

is the input list.

Then the fused role can be used in another fish:

```text
Fannie_Spanker/books/Hardboiled_Whore/characters/Judith
  & role
  @ roles/femme_fatale-conspirator
```

Plain English:

```text
Judith has the fused role femme_fatale-conspirator.
```

---

## 9. Anonymous Fusion Inside a Relation Slot

Relations can be templates.

That means the relation itself can contain a slot.

Example:

```text
Andrea
  & is_[owner]_of
  @ Judith
```

Plain English:

```text
Andrea is Judith's owner.
```

The relation template is:

```text
is_[role]_of
```

The slot value is:

```text
owner
```

A slot can also be filled by a whole fish.

```text
Shosh
  &? is_[_&fuse@(paranormal/ghost,family/mother)]_of
  @ Andrea
```

Compact form:

```text
Shosh&?is_[_&fuse@(paranormal/ghost,family/mother)]_of@Andrea
```

Plain English:

```text
Shosh has an unresolved/contextual relation to Andrea whose role slot is filled by an anonymous resource that is the fusion of paranormal/ghost and family/mother.
```

The slot value is itself a fish:

```text
_&fuse@(paranormal/ghost,family/mother)
```

That fish means:

```text
an anonymous resource is the fusion of paranormal/ghost and family/mother
```

And because a complete fish is itself a resource, that whole fish can be used inside the relation template slot.

---

## 10. Query Binding

The `$` marker says:

```text
return this as an answer
```

Example:

```text
$person
  & is_sibling_of
  @ people/Jordan
```

Compact form:

```text
$person&is_sibling_of@people/Jordan
```

Plain English:

```text
Return every person who is a sibling of Jordan.
```

If the graph contains:

```text
people/Alex&is_sibling_of@people/Jordan
people/Mira&is_sibling_of@people/Jordan
```

then the query returns:

```text
people/Alex
people/Mira
```

Another query:

```text
person/Alex
  & $relation
  @ Fannie_Spanker/books/Hardboiled_Whore
```

Plain English:

```text
Return the relation or relations between Alex and Hardboiled Whore.
```

---

## 11. Existential Scoped Binding

The `*` marker introduces a named scoped binding.

In ordinary relation contexts, it means something exists within this scope.

```text
{
  people/Alex&is_friend_of@*friend;
  *friend&is_sibling_of@people/Jordan;
}
```

Plain English:

```text
There exists some scoped resource friend such that Alex is friends with it, and that same friend is Jordan's sibling.
```

This lets us say:

```text
Alex is friends with one of Jordan's siblings.
```

without knowing or naming exactly which sibling globally.

---

## 12. Anonymous Resource Binding

The `_` marker introduces an anonymous resource.

Use it when the resource exists structurally, but you do not need to name it.

Example:

```text
_&fuse@(paranormal/ghost,family/mother)
```

Plain English:

```text
some anonymous resource is the fusion of paranormal/ghost and family/mother
```

Compare:

```text
*ghost_mother&fuse@(paranormal/ghost,family/mother)
```

This introduces a named scoped binding called `ghost_mother`.

But:

```text
_&fuse@(paranormal/ghost,family/mother)
```

introduces an anonymous resource without naming it.

---

## 13. Lists

Parentheses create a list expression.

Canonical list form uses commas:

```text
(A,B,C)
```

A list is not automatically a graph.

A list is not automatically a set.

A list is not automatically a tuple.

A list is not automatically multiple heads.

Example:

```text
A&rel@(B,C)
```

This means:

```text
tail = A
relation = rel
head = the list (B,C)
```

It does **not** automatically mean:

```text
A&rel@B;
A&rel@C;
```

The relation template decides how to interpret the list.

---

## 14. Schools

Curly braces create a fish block, also called a **school**.

```text
{
  Andrea&is_[owner]_of@Judith;
  Judith&is_[pet]_of@Andrea;
}
```

A school is a structured resource.

A fish can point to a school.

```text
Act_2/Chapter_17&establishes@{
  Andrea&is_[owner]_of@Judith;
  Judith&is_[pet]_of@Andrea;
}
```

Plain English:

```text
Act 2, Chapter 17 establishes these fish: Andrea is Judith's owner; Judith is Andrea's pet.
```

This is where C4 starts to feel different from simple triples.

The chapter is not just related to one resource.

It is related to a structured school of fish.

---

## 15. Mapping Between Systems

The `^` marker expresses mapping or projection between systems.

```text
ontology-a/politics/movement^ontology-b/social/ideology
```

Plain English:

```text
Project or map politics/movement from Ontology A into social/ideology in Ontology B.
```

The same idea can be written as an ordinary fish:

```text
ontology-a/politics/movement
  & maps_to
  @ ontology-b/social/ideology
```

Plain English:

```text
ontology-a/politics/movement maps to ontology-b/social/ideology.
```

---

## 16. The Secret Cream Sauce

The most important idea in C4 is:

```text
A complete fish is itself a resource.
```

That means this fish:

```text
Judith&role@roles/femme_fatale
```

is not just text.

It is also a thing in the graph.

It contains:

```text
TAIL RESOURCE:
  Judith

RELATION:
  role

HEAD RESOURCE:
  roles/femme_fatale

FISH RESOURCE:
  the complete relation instance Judith&role@roles/femme_fatale
```

Because the fish itself is a resource, other fish can talk about it.

For example, using provisional notation:

```text
[Judith&role@roles/femme_fatale]
  & grounded_in
  @ Act_2/Chapter_17
```

Plain English:

```text
The fish Judith has-role femme_fatale is grounded in Act 2, Chapter 17.
```

Other fish could say a fish is:

- supported by something;
- contradicted by something;
- denied by someone;
- established by a chapter;
- cited by an essay;
- transformed into another fish;
- part of a school.

This is the core semantic leverage of C4.

The fish is both statement and thing.

---

## 17. Tiny Cheat Sheet

```text
TAIL & RELATION @ HEAD
```

means:

```text
TAIL --RELATION--> HEAD
```

Markers:

```text
&      asserted relation
&?     unresolved/contextual relation
&!     negative asserted relation
&?!    unresolved/contextual negative relation
@      relation target/head
~      context
_      anonymous resource
*X     named scoped resource
$X     return this in a query
(...)  list
{...}  school / fish block
^      mapping / projection
[...]  relation-template slot
```

Core vocabulary:

```text
fish      complete relation expression
school    block of fish
resource  addressable thing, including complete fish
```

The shortest summary:

```text
C4 is a language for making meaning-maps where relations are fish, fish form schools, and every complete fish is itself a resource.
```

