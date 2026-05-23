# C4 Applications in Plain Terms

C4 is a way to write down meaningful relationships so that both people and software can understand them.

The basic idea is simple:

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

C4 gives those relationships a source format. That means they can be written, reviewed, searched, validated, version-controlled, and transformed without hiding the meaning inside a database, diagram, spreadsheet, or custom script.

Purple Herring is the public ecosystem around C4: the language, tooling, reusable scaffolds, validation rules, execution semantics, and related specifications.

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

People already track this kind of information, but often in fragile ways:

- prose notes that are hard to validate;
- diagrams that are hard to diff;
- spreadsheets that become inconsistent;
- database schemas that are too rigid;
- code comments that drift away from reality;
- hidden glue logic inside scripts;
- knowledge graphs that require specialized tools before anyone can contribute.

C4 is meant to make relationship structure easier to write down directly.

## The practical pitch

C4 tries to make semantic structure:

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

That does not mean every meaning becomes simple or final. It means the relationships become explicit enough to inspect, discuss, validate, and transform.

## Knowledge graphs people can actually write

Knowledge graphs are useful, but many graph tools are hard to author by hand. They may require a database, a visual editor, or a large ontology before ordinary contributors can do useful work.

C4 can act as a Git-friendly source language for knowledge graphs.

A team could use C4 to maintain:

- research knowledge bases;
- institutional memory;
- policy graphs;
- legal knowledge maps;
- medical guideline maps;
- literary and cultural metadata;
- software architecture knowledge graphs.

The advantage is that relationships can be reviewed in pull requests, compared across versions, canonicalized by tools, and exported into other systems.

## Mapping between systems

Different teams often describe the same world in different ways.

One database has one schema. Another system has another schema. One archive uses one vocabulary. Another archive uses a different one. Two standards may overlap without matching exactly.

C4 can describe those relationships explicitly:

- this field maps to that field;
- this concept roughly corresponds to that concept;
- this category is narrower than that category;
- this term conflicts with that term in this context;
- this transformation preserves one meaning but loses another.

This could help with:

- metadata crosswalks;
- library and archive systems;
- museum collection metadata;
- healthcare terminology mapping;
- enterprise data integration;
- scientific vocabulary alignment.

The important part is that mappings stop being hidden inside ETL scripts or informal documentation. They become reviewable semantic artifacts.

## AI and retrieval systems

Many AI retrieval systems store chunks of text and embeddings. That can be useful, but it often loses clear structure around claims, sources, contradictions, and context.

C4 could help represent:

- where a claim came from;
- what supports it;
- what contradicts it;
- what context it belongs to;
- which entity has which role;
- which answer was derived from which source.

This could support:

- retrieval-augmented generation;
- agent memory inspection;
- source attribution;
- claim graphs;
- fact-checking pipelines;
- semantic audit trails.

The simple version:

```text
do not only store chunks; store inspectable relationships
```

## Legal, policy, and compliance work

Legal and compliance work is full of relationships, exceptions, definitions, roles, scopes, and contexts.

C4 could help encode:

- contract obligations;
- policy requirements;
- exceptions;
- definitions;
- party roles;
- jurisdictional scope;
- controls and evidence;
- license compatibility notes.

This does not mean replacing lawyers or compliance experts. It means giving people and tools a clearer way to inspect and maintain structured relationships.

## Software architecture

Software architecture documentation often becomes stale because it lives in prose, diagrams, or scattered comments.

C4 could help describe:

- which service depends on which service;
- which module owns which resource;
- which API implements which capability;
- which component violates which boundary;
- which migration transforms one schema into another;
- which decision supersedes an older decision.

Because C4 is text, these relationships can be reviewed, changed, and tracked like other source files.

## Data lineage and semantic data contracts

Data pipelines often track where data moves, but not always what the data means.

C4 could describe:

- which dataset derives from which dataset;
- which field maps to which field;
- which transformation preserves meaning;
- which transformation loses meaning;
- what a column means in a specific context.

This could help with:

- data catalogs;
- warehouse lineage;
- analytics governance;
- semantic data contracts;
- schema migration documentation;
- pipeline validation.

## Archives, publishing, and humanities work

Libraries, archives, and scholarly projects often need rich relationships that do not fit cleanly into one table or one metadata standard.

C4 could help represent:

- works, editions, adaptations, and citations;
- character relationships;
- themes and motifs;
- publication relationships;
- parody, support, opposition, or influence;
- annotations and interpretive claims.

This makes it useful for digital humanities, scholarly editions, archive metadata, literary analysis, media databases, and annotated corpora.

## Games and narrative systems

Games, especially narrative games and role-playing games, contain many structured relationships:

- characters belong to factions;
- quests depend on earlier choices;
- locations contain objects;
- dialogue depends on world state;
- lore facts support or contradict other facts;
- player choices change future conditions.

C4 could help build inspectable world-state and lore graphs.

Possible uses include:

- RPG lore databases;
- quest logic inspection;
- interactive fiction engines;
- dialogue condition graphs;
- procedural narrative constraints;
- worldbuilding tools.

## Education and curriculum design

Curricula are relationship graphs:

- this concept is a prerequisite for that concept;
- this lesson teaches this skill;
- this exercise assesses this objective;
- this misconception conflicts with this idea;
- this standard maps to this activity.

C4 could help teachers, curriculum designers, and learning systems keep those relationships explicit and inspectable.

## Scientific research and hypothesis tracking

Research depends on relationships among claims, evidence, models, methods, and contexts.

C4 could help represent:

- which study supports which claim;
- which result contradicts which hypothesis;
- which method measures which variable;
- which model predicts which outcome;
- which concept is operationalized by which measurement.

This could support literature reviews, lab notebooks, hypothesis graphs, systematic reviews, and model comparison.

## Security and threat modeling

Security work is full of structured relationships:

- assets are exposed to threats;
- vulnerabilities affect components;
- controls mitigate risks;
- attacker capabilities enable attack paths;
- requirements map to controls.

C4 could make threat models easier to diff, reuse, validate, and inspect.

## Product and requirements traceability

Product work also depends on relationships:

- a customer need motivates a feature;
- a requirement is implemented by a module;
- a test validates a requirement;
- a bug violates an invariant;
- a decision supersedes an older decision.

C4 could provide lightweight traceability without requiring a heavy proprietary requirements system.

## Where Herring Bones fit

C4 provides the language for writing relationships.

Herring Bones provide reusable scaffolds for common kinds of relationships.

A Herring Bone might define the structure for:

- a contract obligation;
- a bibliographic work;
- a software dependency;
- a threat model;
- a curriculum unit;
- a claim-and-evidence pattern;
- an ontology mapping.

This matters because adoption does not have to start from a blank page. People can reuse structural patterns that already fit common problems.

## The short version

C4 is useful anywhere people need structured meaning that is:

- readable by humans;
- usable by tools;
- explicit enough to inspect;
- flexible across different systems;
- stable enough to version-control;
- reusable across projects.

Purple Herring makes that structure part of a broader public ecosystem.

The project is intentionally strange on the surface, but the practical goal is straightforward:

```text
make meaningful relationships easier to write, review, reuse, and trust
```
