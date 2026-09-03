# Matrix Portable Server Signing Key Bundle Format Specification

### 1. Introduction

The primary goals are:

- Enable safe migration of signing keys between different homeserver implementations.
- Provide a clear distinction between active and revoked keys.
- Enforce a single active signing key in steady state.
- Remain compatible with the Matrix Server-Server API key identifier rules.

### 2. Design Principles

- Based on the JSON Web Key Set (JWKS) structure for broad tooling compatibility.
- Uses only standard JSON data types.
- Strict validation rules are defined so that invalid bundles can be rejected early.
- Private key material (`d`) is present only for the currently active key.
- Algorithm name and key version are kept separate to allow clean derivation of the Matrix key ID.

### 3. Top-Level Structure

A bundle is a JSON object with exactly one required property:

```json
{
  "keys": [/* array of key objects */]
}
```

- `keys` (array, required)\
  Contains one or more key objects.\
  In steady state the array **must** contain exactly one active key.\
  Additional keys, if present, must be revoked keys.

No other top-level properties are permitted.

### 4. Key Objects

Each element of the `keys` array is either an **Active Key** or a **Revoked Key**.

#### 4.1 Common Properties

All keys share the following properties:

| Property | Type   | Required | Description                                                           |
| -------- | ------ | -------- | --------------------------------------------------------------------- |
| `kty`    | string | yes      | Must be `"OKP"`                                                       |
| `crv`    | string | yes      | Must be `"Ed25519"`                                                   |
| `kid`    | string | yes      | Key version component (see section 5)                                 |
| `x`      | string | yes      | Unpadded Base64URL-encoded Ed25519 public key (exactly 43 characters) |

#### 4.2 Active Key

An active key is the key currently used for signing new events and federation requests.

Additional requirements:

- Must contain the private key:
  - `d` (string, required): Unpadded Base64URL-encoded 32-byte Ed25519 private key (exactly 43 characters).
- Must **not** contain a `revoked` property.

#### 4.3 Revoked Key

A revoked key is a former signing key whose private material has been destroyed.

Additional requirements:

- Must contain:
  ```json
  "revoked": {
    "revoked_at": <integer>,   // required, UNIX timestamp in milliseconds
    "reason": "<string>"       // optional
  }
  ```
- Must **not** contain a `d` property.

`revoked_at` indicates the time at which the key was retired (equivalent in meaning to `expired_ts` in the Matrix
`/_matrix/key/v2/server` response).

### 5. Key Identifier (`kid`) Rules

The `kid` field holds only the **version** portion of the Matrix signing key identifier.

According to the Matrix Server-Server API, the version must match the regular expression:

```
[a-zA-Z0-9_]+
```

Therefore the schema enforces:

```
"pattern": "^[a-zA-Z0-9_]+$"
```

#### 5.1 Encoding Conversion for Public Keys

JWK uses unpadded Base64URL encoding (RFC 7517 / RFC 8037), whereas the Matrix Server-Server API uses unpadded Base64
encoding. When exporting public keys to Matrix Federation API payloads (verify_keys or old_verify_keys), implementations
MUST convert the key string from Base64URL to unpadded Base64.

### 6. Deriving the Matrix Key ID

The full Matrix signing key identifier is formed as follows:

```
algorithm = lowercase(crv) // "Ed25519" → "ed25519"
key_id = algorithm + ":" + kid
```

Example:

```
crv = "Ed25519"
kid = "a_x7K9"
→ key_id = "ed25519:a_x7K9"
```

This derivation is deterministic and requires no additional configuration.

### 7. Constraints

1. The `keys` array must contain **exactly one** active key.
2. All other keys in the array (if any) must be revoked keys.
3. All `kid` values within a single bundle must be unique.
4. The public key (`x`) of an active key must correspond to the private key (`d`).
5. No additional properties beyond those defined in this specification are allowed.

### 8. Encoding Rules

- All binary values (`x` and `d`) use **unpadded Base64URL** encoding.
- Timestamps use milliseconds since the UNIX epoch (same unit as `expired_ts` / `valid_until_ts`).
- JSON must be encoded in UTF-8.

### 9. Security Considerations

- The bundle contains private key material when an active key is present. It must be protected with appropriate file
  system permissions, encryption at rest, and access controls.
- After a key is revoked, the corresponding private key (`d`) must be securely erased and must never reappear in any
  subsequent bundle.
- Implementations should refuse to load a bundle that violates the "exactly one active key" rule.

### 10. Example

```json
{
  "keys": [
    {
      "kty": "OKP",
      "crv": "Ed25519",
      "kid": "a_x7K9",
      "x": "11qYAYKxCrfVS_7TyWQHOg7hcvPapiMlrwIaaPcHURo",
      "d": "nWGxne_9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A"
    },
    {
      "kty": "OKP",
      "crv": "Ed25519",
      "kid": "a_old1",
      "x": "2E6V7g2z_8pQj9rT4uYwXvZbNcMdFgHjKlPaRsTuVwX",
      "revoked": {
        "revoked_at": 1723680000000,
        "reason": "superseded"
      }
    }
  ]
}
```

In this example the active key ID is `ed25519:a_x7K9`.
