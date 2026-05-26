# Fish Specifications

Fish is the C4 syntax, protocol, and interchange layer for Purple Herring.

Fish may define:

- surface serialization for C4 graph structures;
- protocol request/response framing;
- status-code registries;
- negotiated result schemas;
- graph-delta and materialization-result projections;
- diagnostic envelopes;
- profile negotiation;
- transport/interchange conventions;
- package, registry, and module addressing conventions.

C4 Core remains the abstract graph calculus and semantic substrate. Fish may serialize, negotiate, project, transport, or status-code C4 graph-objects, but Fish protocol projections do not replace C4 graph-native semantics.

## Current Draft Areas

- Fish protocol/status-code registry
- Fish materialization-result schema negotiation
- Fish graph-delta projection formats
- Fish diagnostic envelopes
- Fish canonical serialization

