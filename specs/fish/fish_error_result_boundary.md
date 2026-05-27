# Fish Error Result Boundary v0.1.0 Draft

## Status

This document is a draft Fish protocol rule.

---

## 1. Error Boundary Rule

On any error status, Fish MUST NOT return the requested operation graph-delta result.

This includes graph-delta graph projections, graph-delta summaries, graph-diff projections, fond graphs, and fond summaries.

Graph-delta and graph-diff projections are successful result projections only.

They MAY be returned only when the requested operation completes successfully enough for the active profile to treat the projected graph-delta as a valid result.

---

## 2. Permitted Error Results

On error, Fish MAY return:

- a status-only graph response;
- a diagnostic graph, if requested or profile-required;
- required protocol envelope metadata;
- a profile-defined error graph.

A diagnostic graph returned for an error is not the requested operation graph-delta.

It is a diagnostic projection explaining why the request did not produce the requested result.

---

## 3. Relationship to Operation Registry

Fish operations that produce graph-delta, graph-diff, fond, or materialization-result projections MUST apply this error boundary before returning result projections.

If an operation fails, the response is an error response, not a graph-diff response.
