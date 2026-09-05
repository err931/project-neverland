# Dedicated policy server

We implement MSC4284 as a dedicated server with the minimal federation surface (`/sign`, well-known, key API, auth verification, `/send` stub), not as a homeserver-integrated module.

## Considered Options

- Dedicated host vs Synapse-module/appservice style where Synapse owns auth and signatures.
- Full DAG-tracking homeserver vs minimal policy host.

## Consequences

- Join make/send is deferred; operation assumes an already-joined user satisfies the `via` joined condition. Federation auth and key publication must still be correct from day one.
