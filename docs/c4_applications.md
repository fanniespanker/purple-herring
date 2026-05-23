# C4 Applications in Plain Terms

C4 is a way to write down meaningful relationships so that both people and software can inspect them.

The basic pattern is simple:

```text
this thing has this relationship to that thing
```

For example:

```text
this document cites that source
this field maps to that field
this rule applies in that context
this character belongs to that faction
this software component depends on that service
```

C4 gives those relationships a source format. That means they can be written, reviewed, searched, validated, version-controlled, and transformed as explicit semantic structure rather than remaining only in prose, diagrams, spreadsheets, database fields, or custom scripts.

Purple Herring is the public ecosystem around C4: the language, tooling, reusable scaffolds, validation rules, execution semantics, and related specifications.

## Status

This document is a plain-language overview of applications that can reasonably be projected from the current C4 specification and its public ecosystem direction.

The central capability described here is grounded in the C4 language model: C4 represents resources, relations, heads, tails, context grounding, bindings, query bindings, lists, schools, relation templates, and complete fish as first-class resources.

The application areas below are illustrative. They are not claims that complete domain-specific tooling already exists.

## The problem C4 is trying to solve

Many projects need to track meaning, not just data.

They need to know how things relate:

- which claim came from which source;
- which concept maps to which concept;
- which policy applies to which situation;
- which field in one system corresponds to a field in another system;
- which software component depends on another component;
- which requirement is tested by which test;
- which story event changes which later possibility.

People already track this kind of information, but often in formats that are difficult to parse, validate, compare, or reuse consistently.

C4 is meant to make relationship structure easier to write down directly.

## The practical pitch

C4 is intended to make semantic structure:

- human-authorable;
- machine-parseable;
- inspectable;
- reusable;
- version-controllable;
- flexible across different schemas and vocabularies.

In plain terms:

```text
C4 lets people write meaning like source code.
```

That does not mean every meaning becomes simple or final. It means relationships can become explicit enough to inspect, discuss, validate, and transform.

## Why not just use prose, code, diagrams, or a database?

C4 is not trying to replace those things.

It exists because many relationships are too important to leave only in prose, too semantic to hide inside code, too structured for ordinary notes, and too cross-domain for one local database schema.

C4 gives those relationships a source form.

That source form can be reviewed by people, parsed by tools, checked by validators, reused through Herring Bones, and transformed into other representations.

C4 is most useful when knowledge needs to be portable between systems and disciplines — when relationships need to cross contexts, schemas, tools, teams, or interpretations without losing their structure.

## A small example

A mapping might begin life as an informal note:

```text
customer_id in System A is basically client.id in System B, except for legacy accounts
```

That sentence may be understandable to a person, but it is difficult for tools to validate, search, transform, or compare consistently.

C4 aims to make that kind of relationship explicit, contextual, and inspectable:

```text
system_a/customer_id&maps_to@system_b/client/id~contexts/non_legacy_accounts
```

The exact relation vocabulary belongs to C4 templates, Herring Bones, and project-specific vocabularies. The point is that the relationship becomes something tools can inspect rather than a sentence they might ignore.

## A semantic lingua franca

C4 is designed to act as a small semantic lingua franca between people and software.

Natural language is expressive, but difficult for tools to validate consistently. Ordinary code is precise, but often hides meaning inside implementation details. Database schemas are structured, but usually local to one system.

C4 sits between those layers.

It gives people a way to write relationships in a form that is readable enough to review and structured enough for tools to parse, validate, transform, and exchange.

The goal is not to replace natural language, programming languages, databases, or ontologies. The goal is to provide a shared relationship layer that can connect them.

In the project vocabulary, this means humans and machines should be able to prepare, inspect, cook, serve, and consume fish together without either side losing the structure that makes the fish meaningful.

## Knowledge graphs and semantic source files

C4 can be used as a text source format for graph-like semantic relationships.

That makes it relevant to projects that maintain structured knowledge, such as:

- research notes;
- institutional memory;
- policy maps;
- legal knowledge maps;
- literary and cultural metadata;
- software architecture knowledge maps.

The reasonable projection is not that C4 replaces graph databases. Rather, C4 can provide an authorable source layer that may be parsed, canonicalized, validated, and exported into other representations.

## Mapping between systems

The C4 specification includes mapping / projection syntax and relation syntax for describing relationships between resources, concepts, scopes, and structures.

That makes C4 a natural fit for describing how one system relates to another.

Examples include:

- this field maps to that field;
- this concept corresponds to that concept;
- this category is narrower than that category;
- this term conflicts with that term in this context;
- this transformation preserves one distinction but loses another.

Potential areas include:

- metadata crosswalks;
- archive and library vocabularies;
- schema mapping;
- terminology alignment;
- data integration notes.

The key point is that mappings can become explicit semantic artifacts rather than only implementation details.

## Provenance, claims, and context

C4 supports complete fish as first-class resources. This means a relationship can itself be addressed, cited, contextualized, supported, disputed, transformed, or grouped.

That makes C4 relevant to provenance and claim-tracking work.

Possible structures include:

- this source supports this claim;
- this claim contradicts that claim;
- this statement is grounded in this context;
- this interpretation depends on this scope;
- this answer was derived from this source.

This is relevant to research notes, source attribution, fact-checking workflows, audit trails, and retrieval systems that need inspectable relationships in addition to raw text.

## Legal, policy, and compliance structure

Legal, policy, and compliance work often involves relationships among rules, definitions, obligations, exceptions, parties, controls, and contexts.

C4 could be used to author and inspect relationship structures such as:

- a contract clause creates an obligation;
- a policy applies to a situation;
- an exception modifies a rule;
- a control satisfies a requirement;
- evidence supports a compliance claim.

This does not imply automated legal judgment. It means C4 may be useful for representing structured relationships that experts still need to review.

## Software architecture and requirements

Software projects contain many relationships that are often scattered across diagrams, comments, tickets, and documentation.

C4 could describe structures such as:

- a service depends on another service;
- a module owns a resource;
- an API implements a capability;
- a migration transforms one schema into another;
- a requirement is implemented by a feature;
- a test validates a requirement;
- a decision supersedes an older decision.

Because C4 is text, these structures can be reviewed and versioned alongside other project files.

## Data lineage and semantic data contracts

Data systems need to know not only where data moves, but what it means.

C4 could represent:

- a dataset derives from another dataset;
- a field maps to another field;
- a transformation preserves a meaning;
- a transformation loses or changes a meaning;
- a column has a particular meaning in a particular context.

This makes C4 relevant to data catalogs, lineage notes, schema migration documentation, and semantic data contracts.

## Archives, publishing, and humanities work

C4 can describe relationships among works, editions, citations, interpretations, characters, themes, publication contexts, and annotations.

This makes it relevant to:

- archive metadata;
- scholarly editions;
- literary analysis;
- media databases;
- annotated corpora;
- publication relationship tracking.

The current specification already supports the underlying relationship model. Domain-specific usefulness would depend on appropriate Herring Bones, vocabularies, and examples.

## Games and narrative systems

Narrative systems contain structured relationships among characters, places, factions, events, conditions, and consequences.

C4 could describe:

- a character belongs to a faction;
- a quest depends on an earlier choice;
- a location contains an object;
- a dialogue option depends on world state;
- a lore fact supports or contradicts another lore fact.

This is a reasonable projection from C4's support for scoped relations, context grounding, schools, and complete fish as resources.

## Education and curriculum design

Curricula can be described as relationship structures:

- one concept is a prerequisite for another;
- a lesson teaches a skill;
- an exercise assesses an objective;
- a misconception conflicts with an idea;
- a standard maps to an activity.

C4 may be useful where those relationships need to be explicit, reviewable, and reusable.

## Scientific research and hypothesis tracking

Research workflows often involve relationships among claims, evidence, models, methods, variables, and contexts.

C4 could describe:

- a study supports a claim;
- a result contradicts a hypothesis;
- a method measures a variable;
- a model predicts an outcome;
- a measurement operationalizes a concept.

These uses follow from C4's general relation model, context grounding, and ability to reify complete fish as resources.

## Security and threat modeling

Threat models are also relationship structures:

- an asset is exposed to a threat;
- a vulnerability affects a component;
- a control mitigates a risk;
- an attacker capability enables an attack path;
- a requirement maps to a control.

C4 could serve as an authorable source format for such structures if suitable vocabularies and validation profiles are defined.

## Where Herring Bones fit

C4 provides the language for writing relationships.

Herring Bones provide reusable scaffolds for common relationship structures.

A Herring Bone might define the structure for:

- a contract obligation;
- a bibliographic work;
- a software dependency;
- a threat model;
- a curriculum unit;
- a claim-and-evidence pattern;
- an ontology mapping.

Those examples are projected use cases. Their practical support depends on actual `.bone` files, validation rules, and tooling.

## The short version

C4 is relevant anywhere people need structured meaning that is:

- readable by humans;
- usable by tools;
- explicit enough to inspect;
- flexible across different systems;
- stable enough to version-control;
- reusable across projects.

Purple Herring makes that structure part of a broader public ecosystem.

The practical goal is straightforward:

```text
make meaningful relationships easier to write, review, reuse, and trust
```
