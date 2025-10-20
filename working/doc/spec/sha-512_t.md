## SHA-512/t

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SHA512_T                         |     |     |      |  ✓  |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_HMAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_HMAC_GENERAL            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_KEY_DERIVATION          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SHA-512 / t Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_SHA512_T_HMAC**” for type CK_KEY_TYPE
as used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_SHA512_T
- CKM_SHA512_T_HMAC
- CKM_SHA512_T_HMAC_GENERAL
- CKM_SHA512_T_KEY_DERIVATION
- CKM_SHA512_T_KEY_GEN

### SHA-512/t digest

The SHA-512/t mechanism, denoted **CKM_SHA512_T**, is a mechanism for message
digesting, following the Secure Hash Algorithm defined in [FIPS PUB 180-4],
section 5.3.6. It is based on a 512-bit message digest with a distinct initial
hash value and truncated to t bits.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the value of t in
bits. The length in bytes of the desired output should be in the range of 0-⌈
t/8⌉, where 0 < t < 512, and t <> 384.

Constraints on the length of input and output data are summarized in the
following table. For single-part digesting, the data and the digest may begin at
the same location in memory.

| Function | Input length | Digest length |
|----------|--------------|---------------|
| C_Digest | any          | ⌈t/8⌉, where 0 < t < 512, and t <> 384 |
table: SHA-512/t: Data Length

### General-length SHA-512/t-HMAC

The general-length SHA-512/t-HMAC mechanism, denoted
**CKM_SHA512_T_HMAC_GENERAL**, is the same as the general-length SHA-1-HMAC
mechanism in section 6.19.3, except that it uses the HMAC construction based on
the SHA-512/t hash function and length of the output should be in the range 0 –
⌈t/8⌉, where 0 < t < 512, and t <> 384.

### SHA-512/t-HMAC

The SHA-512/t-HMAC mechanism, denoted **CKM_SHA512_T_HMAC**, is a special case
of the general-length SHA-512/t-HMAC mechanism.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the value of t in
bits. The length in bytes of the desired output should be in the range of
0-⌈t/8⌉, where 0 < t < 512, and t <> 384.

### SHA-512/t key derivation

The SHA-512/t key derivation, denoted **CKM_SHA512_T_KEY_DERIVATION**, is the
same as the SHA-512 key derivation mechanism in section 6.23.5, except that it
uses the SHA-512/t hash function and the relevant length is ⌈t/8⌉ bytes, where 0
< t < 512, and t <> 384.

### SHA-512/t HMAC key generation

The SHA-512/t-HMAC key generation mechanism, denoted **CKM_SHA512_T_KEY_GEN**,
is a key generation mechanism for NIST’s SHA512/t-HMAC.

It does not have a parameter.

The mechanism generates SHA512/t-HMAC keys with a particular length in bytes, as
specified in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the SHA512/t-HMAC key
type (specifically, the flags indicating which functions the key supports) may
be specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of
**CKM_SHA512_T_HMAC** key sizes, in bytes.
