## SHA-1

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SHA_1                            |     |     |      |  ✓  |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA_1_HMAC_GENERAL               |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA_1_HMAC                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA1_KEY_DERIVATION              |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA_1_KEY_GEN                    |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SHA-1 Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_SHA_1_HMAC**” for type CK_KEY_TYPE as
used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_SHA_1
- CKM_SHA_1_HMAC
- CKM_SHA_1_HMAC_GENERAL
- CKM_SHA1_KEY_DERIVATION
- CKM_SHA_1_KEY_GEN


### SHA-1 digest

The SHA-1 mechanism, denoted **CKM_SHA_1**, is a mechanism for message
digesting, following the Secure Hash Algorithm with a 160-bit message digest
defined in [FIPS PUB 180-4].

It does not have a parameter.

Constraints on the length of input and output data are summarized in the
following table. For single-part digesting, the data and the digest may begin at
the same location in memory.

| Function | Input length | Digest length |
|----------|--------------|---------------|
| C_Digest | any          | 20            |
table: SHA-1: Data Length

### General-length SHA-1-HMAC

The general-length SHA-1-HMAC mechanism, denoted **CKM_SHA_1_HMAC_GENERAL**, is
a mechanism for signatures and verification. It uses the HMAC construction,
based on the SHA-1 hash function. The keys it uses are generic secret keys and
**CKK_SHA_1_HMAC**.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the length in bytes
of the desired output. This length should be in the range 1-20 (the output size
of SHA-1 is 20 bytes). Signatures (MACs) produced by this mechanism will be
taken from the start of the full 20-byte HMAC output.

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | generic secret CKK_SHA_1_HMAC | any | 1-20, depending on parameters |
| C_Verify | generic secret CKK_SHA_1_HMAC | any | 1-20, depending on parameters |
table: General-length SHA-1-HMAC: Key And Data Length

### SHA-1-HMAC

The SHA-1-HMAC mechanism, denoted **CKM_SHA_1_HMAC**, is a special case of the
general-length SHA-1-HMAC mechanism in section [6.19.3].

It has no parameter, and always produces an output of length 20.

### SHA-1 key derivation

SHA-1 key derivation, denoted **CKM_SHA1_KEY_DERIVATION**, is a mechanism which
provides the capability of deriving a secret key by digesting the value of
another secret key with SHA-1. 

The value of the base key is digested once, and the result is used to make the
value of derived secret key.

* If no length or key type is provided in the template, then the key produced by
  this mechanism will be a generic secret key. Its length will be 20 bytes (the
  output size of SHA-1).
* If no key type is provided in the template, but a length is, then the key
  produced by this mechanism will be a generic secret key of the specified
  length.
* If no length was provided in the template, but a key type is, then that key
  type must have a well-defined length. If it does, then the key produced by
  this mechanism will be of the type specified in the template. If it doesn’t,
  an error will be returned.
* If both a key type and a length are provided in the template, the length must
  be compatible with that key type. The key produced by this mechanism will be
  of the specified type and length.

If a DES, DES2, or CDMF key is derived with this mechanism, the parity bits of
the key will be set properly.

If the requested type of key requires more than 20 bytes, such as DES3, an error
is generated.

This mechanism has the following rules about key sensitivity and extractability:

* The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
* If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
* Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

### SHA-1 HMAC key generation

The SHA-1-HMAC key generation mechanism, denoted **CKM_SHA_1_KEY_GEN**, is a key
generation mechanism for NIST’s SHA-1-HMAC.

It does not have a parameter.

The mechanism generates SHA-1-HMAC keys with a particular length in bytes, as
specified in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the SHA-1-HMAC key type
(specifically, the flags indicating which functions the key supports) may be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of
**CKM_SHA_1_HMAC** key sizes, in bytes.
