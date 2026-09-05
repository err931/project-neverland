# Immutable persisted designations keyed by event ID

The `/sign` designation (neutral/spammy) is persisted in Postgres keyed by `event_id` and never recomputed on cache hit. The stored row keeps `room_id`, designation, harms, and the policy key `kid` used.

## Considered Options

- Pure in-memory dedup cache vs persisted immutable verdicts.

## Consequences

- Prevents split-brain where two homeservers get different verdicts for the same event after a policy change. Changing a past verdict requires an explicit migration/redaction flow, not a silent re-decide.
