# Stable and unstable /sign, no /check

We serve both `/_matrix/policy/v1/sign` and `/_matrix/policy/unstable/org.matrix.msc4284/sign` from one handler. Stable refusal is `400 M_FORBIDDEN`; unstable refusal is `200 {}`. The legacy `/check` API is not implemented.

## Considered Options

- Stable-only vs stable+unstable+`/check` fallback as the MSC notes suggest.

## Consequences

- Unstable compat stays a thin transport shim (error mapping plus singular `public_key` acceptance). Future removal is deleting the shim, not the decision pipeline.
