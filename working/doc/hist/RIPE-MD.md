## RIPE-MD

### Definitions

Mechanisms:

- CKM_RIPEMD128
- CKM_RIPEMD128_HMAC
- CKM_RIPEMD128_HMAC_GENERAL
- CKM_RIPEMD160
- CKM_RIPEMD160_HMAC
- CKM_RIPEMD160_HMAC_GENERAL

### RIPE-MD 128 Digest

The RIPE-MD 128 mechanism, denoted **CKM_RIPEMD128**, is a mechanism for message
digesting, following the RIPE-MD 128 message-digest algorithm.

It does not have a parameter.

Constraints on the length of data are summarized in the following table:

| Function | Data length | Digest length |
|----------|-------------|---------------|
| C_Digest | Any         | 16            |
table: RIPE-MD 128: Data Length

### General-length RIPE-MD 128-HMAC

The general-length RIPE-MD 128-HMAC mechanism, denoted
**CKM_RIPEMD128_HMAC_GENERAL**, is a mechanism for signatures and verification.
It uses the HMAC construction, based on the RIPE-MD 128 hash function.  The keys
it uses are generic secret keys.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the length in bytes
of the desired output.  This length should be in the range 0-16 (the output size
of RIPE-MD 128 is 16 bytes).  Signatures (MACs) produced by this mechanism MUST
be taken from the start of the full 16-byte HMAC output.

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | Generic secret | Any         | 0-16, depending on parameters |
| C_Verify | Generic secret | Any         | 0-16, depending on parameters |
table: General-length RIPE-MD 128-HMAC

### RIPE-MD 128-HMAC

The RIPE-MD 128-HMAC mechanism, denoted **CKM_RIPEMD128_HMAC**, is a special
case of the general-length RIPE-MD 128-HMAC mechanism in Section 2.16.3.

It has no parameter, and produces an output of length 16.

### RIPE-MD 160

The RIPE-MD 160 mechanism, denoted **CKM_RIPEMD160**, is a mechanism for message
digesting, following the RIPE-MD 160 message-digest defined in ISO-10118.

It does not have a parameter.

Constraints on the length of data are summarized in the following table:

| Function | Data length | Digest length |
|----------|-------------|---------------|
| C_Digest | Any         | 20            |
table: RIPE-MD 160: Data Length

### General-length RIPE-MD 160-HMAC

The general-length RIPE-MD 160-HMAC mechanism, denoted
**CKM_RIPEMD160_HMAC_GENERAL**, is a mechanism for signatures and verification.
It uses the HMAC construction, based on the RIPE-MD 160 hash function.  The keys
it uses are generic secret keys.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the length in bytes
of the desired output.  This length should be in the range 0-20 (the output size
of RIPE-MD 160 is 20 bytes).  Signatures (MACs) produced by this mechanism MUST
be taken from the start of the full 20-byte HMAC output.

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | Generic secret | Any         | 0-20, depending on parameters |
| C_Verify | Generic secret | Any         | 0-20, depending on parameters |
table: General-length RIPE-MD 160-HMAC: Data and Length

### RIPE-MD 160-HMAC

The RIPE-MD 160-HMAC mechanism, denoted **CKM_RIPEMD160_HMAC**, is a special
case of the general-length RIPE-MD 160HMAC mechanism in Section 2.16.6.

It has no parameter, and produces an output of length 20.
