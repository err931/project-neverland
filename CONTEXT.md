# Honeywagon

Policy server dedicated to MSC4284 room moderation. Rooms opt in via state; homeservers ask for a signature before delivering events.

## Language

### Policy Server

A dedicated server implementing the `/sign` API to mark events as neutral or spammy.
_Avoid_: homeserver, moderation bot, policyserv (the reference implementation)

### Room Policy

The `m.room.policy` state event with empty state key that selects the policy server for a room.
_Avoid_: policy event, room config

### Via

The server name in room policy content that provides room policy.
_Avoid_: server_name, policy server domain

### Public Keys

The `public_keys.ed25519` value in room policy content and well-known, used to verify policy signatures.
_Avoid_: public_key (singular; only for unstable compat), verify key

### Designation

The policy server's verdict on an event: neutral or spammy.
_Avoid_: recommendation, judgement, classification, ContentClass

### Neutral

A designation meaning the event may pass; the server returns a signature.
_Avoid_: ok, allowed, clean

### Spammy

A designation meaning the event must not pass; the server refuses to sign.
_Avoid_: spam, prohibited, harmful, refused (refused is the transport outcome)

### Policy Signature

The `ed25519:policy_server` signature added by the policy server to neutral events.
_Avoid_: event signature, server signature

### Key Bundle

A JWKS-based file holding the active signing key (`d` present) and revoked keys (`revoked` present).
_Avoid_: signing key, key file, JWK set

### Federation Key

The key used for federation traffic, published on `/_matrix/key/v2/server`.
_Avoid_: homeserver key, server key

### Policy Key

The key with fixed version `policy_server` used only for `/sign`, never published on the key API.
_Avoid_: event signing key, policy server key (without qualifier)
