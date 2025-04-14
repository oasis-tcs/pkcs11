## BLAKE2B-512

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_BLAKE2B_512                      |     |     |      |  ✓  |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_HMAC                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_HMAC_GENERAL         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_KEY_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: BLAKE2B-512 Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_BLAKE2B_512
- CKM_BLAKE2B_512_HMAC
- CKM_BLAKE2B_512_HMAC_GENERAL
- CKM_BLAKE2B_512_KEY_DERIVE
- CKM_BLAKE2B_512_KEY_GEN
- CKK_BLAKE2B_512_HMAC

### BLAKE2B-512 digest

The BLAKE2B-512 mechanism, denoted **CKM_BLAKE2B_512**, is a mechanism for
message digesting, following the Blake2b Algorithm with a 512-bit message digest
defined in [RFC 7693].

It does not have a parameter.  Constraints on the length of input and output
data are summarized in the following table. For single-part digesting, the data
and the digest may begin at the same location in memory.

| Function | Input length | Digest length |
|----------|--------------|---------------|
| C_Digest | any          | 64            |
table: BLAKE2B-512: Data Length

### General-length BLAKE2B-512-HMAC

The general-length BLAKE2B-512-HMAC mechanism, denoted
**CKM_BLAKE2B_512_HMAC_GENERAL**, is the keyed variant of the BLAKE2B-512 hash
function and length of the output should be in the range 1-64.The keys it uses
are generic secret keys and **CKK_BLAKE2B_512_HMAC.** 

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the length in bytes
of the desired output. This length should be in the range 1-64 (the output size
of BLAKE2B-512 is 64 bytes). Signatures (MACs) produced by this mechanism shall
be taken from the start of the full 64-byte HMAC output.

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | generic secret CKK_BLAKE2B_512_HMAC | Any | 1-64, depending on parameters |
| C_Verify | generic secret CKK_BLAKE2B_512_HMAC | Any | 1-64, depending on parameters |
table: General-length BLAKE2B-512-HMAC: Key And Data Length


### BLAKE2B-512-HMAC

The BLAKE2B-512-HMAC mechanism, denoted **CKM_BLAKE2B_512_HMAC**, is a special
case of the general-length BLAKE2B-512-HMAC mechanism.

It has no parameter, and always produces an output of length 64.

### BLAKE2B-512 key derivation

BLAKE2B-512 key derivation, denoted **CKM_BLAKE2B_512_KEY_DERIVE**, is the same
as the SHA-1 key derivation mechanism in section [6.20.5], except that it uses
the BLAKE2B-512 hash function and the relevant length is 64 bytes. 

### BLAKE2B-512 HMAC key generation

The BLAKE2B-512-HMAC key generation mechanism, denoted
**CKM_BLAKE2B_512_KEY_GEN**, is a key generation mechanism for NIST’s
BLAKE2B-512-HMAC.

It does not have a parameter.

The mechanism generates BLAKE2B-512-HMAC keys with a particular length in bytes,
as specified in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the BLAKE2B-512-HMAC
key type (specifically, the flags indicating which functions the key supports)
may be specified in the template for the key, or else are assigned default
initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of
**CKM_BLAKE2B_512_HMAC** key sizes, in bytes.

