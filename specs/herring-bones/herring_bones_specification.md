# Herring Bones Specification

## Status

This is an early public specification for Herring Bones in the Purple Herring / C4 ecosystem.

## Purpose

Herring Bones are reusable semantic scaffolds for C4 source.

A Herring Bone may define a reusable relation template, relation skeleton, starter ontology snippet, validation profile, relation library, or similar structural material.

Herring Bones are production-grade reusable materials, not merely examples.

## File extension

Herring Bones source files SHOULD use the `.bone` extension.

A `.bone` file defines reusable structure. It is not ordinary `.fish` source.

```text
.fish = authored C4 source containing relation-fish and schools
.bone = reusable Herring Bones source containing bones and skeletons
```

## Fish, bones, skeletons, and sashimi

A `.fish` source artifact may contain both structure and payload.

Informally:

```text
fish     = full authored C4 source artifact
sashimi  = payload or content carried by the fish
bone     = reusable structural scaffold
skeleton = connected set of bones
```

Bones may be cut from fish, generalized from fish, or authored directly as scaffolding.

Bones do not contain sashimi. A Herring Bone should avoid payload-specific authored content except for minimal labels, examples, or documentation necessary to explain the structure.

The metaphor is non-normative. The technical terms are source artifact, payload, scaffold, template, constraint, validation profile, relation skeleton, and reusable semantic library.

## Bones and skeletons

A bone is a reusable structural unit.

A skeleton is a connected set of bones.

Bones do not gather into schools. Fish gather into schools; bones connect into skeletons.

A `.bone` file MAY define one or more bones, one or more skeletons, or a reusable library of related bones.

## Relationship to C4

Herring Bones may shape, validate, scaffold, or generate `.fish` source, but `.bone` files are not themselves ordinary `.fish` source.

A Herring Bones processor may compile or project bones into C4 relation templates, validation profiles, graph constraints, or template expansion rules.

## Informal anatomy vocabulary

The following mnemonic vocabulary may be used in teaching material and explanatory prose:

```text
& = spine          asserted structural relation marker
? = dangling bone  unresolved, contextual, or not-yet-crystallized attachment
@ = gills          head / target interface
$ = hook           query binding, capture, or return handle
```

These names are mnemonic. The C4 technical specification remains authoritative for syntax and semantics.

## License

Unless otherwise marked, Herring Bones materials under the root `herring-bones/` directory are dedicated under CC0 1.0 Universal.

See `../../herring-bones/LICENSE.md` and `../../LICENSE.md` for license policy and conflict resolution.
