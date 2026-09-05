# Separate federation and policy key bundles

Federation key and policy key live in independent key bundle files (`HW_FEDERATION_KEY_BUNDLE_PATH`, `HW_POLICY_KEY_BUNDLE_PATH`). The policy bundle's active key uses fixed `kid` `policy_server` and is never published on `/_matrix/key/v2/server`.

## Considered Options

- Single bundle with two `kid`s vs two independent bundle files.

## Consequences

- Room policy rotation is done by updating `m.room.policy` content alone, without cooperation from this server. Loader code is shared; only paths and the `policy_server` fixed-`kid` check differ. Base64URL (bundle) to Base64 (federation/`m.room.policy`) conversion happens at the boundary.
