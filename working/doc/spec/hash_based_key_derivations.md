## Hash-based Key Derivation

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SHA1_KEY_DERIVATION              |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA224_KEY_DERIVATION            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA256_KEY_DERIVATION            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA384_KEY_DERIVATION            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_KEY_DERIVATION            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_224_KEY_DERIVATION        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_256_KEY_DERIVATION        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_KEY_DERIVATION          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_224_KEY_DERIVATION          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_256_KEY_DERIVATION          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_384_KEY_DERIVATION          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_512_KEY_DERIVATION          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHAKE_128_KEY_DERIVATION         |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHAKE_256_KEY_DERIVATION         |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_160_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_256_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_384_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table 141: Hash-based key derivation Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_SHA1_KEY_DERIVATION
- CKM_SHA224_KEY_DERIVATION
- CKM_SHA256_KEY_DERIVATION
- CKM_SHA384_KEY_DERIVATION
- CKM_SHA512_KEY_DERIVATION
- CKM_SHA512_224_KEY_DERIVATION
- CKM_SHA512_256_KEY_DERIVATION
- CKM_SHA512_T_KEY_DERIVATION
- CKM_SHA3_224_KEY_DERIVATION
- CKM_SHA3_256_KEY_DERIVATION
- CKM_SHA3_384_KEY_DERIVATION
- CKM_SHA3_512_KEY_DERIVATION
- CKM_SHAKE_128_KEY_DERIVATION
- CKM_SHAKE_256_KEY_DERIVATION
- CKM_BLAKE2B_160_KEY_DERIVE
- CKM_BLAKE2B_256_KEY_DERIVE
- CKM_BLAKE2B_384_KEY_DERIVE
- CKM_BLAKE2B_512_KEY_DERIVE

### Hash-based key derivation

The hash-based key derivation mechanism, denoted **CKM_**\<hash\>**\_KEY_DERIVATION** or **CKM_**\<hash\>**\_KEY_DERIVE** where \<hash\> identifies a hash function or expansion function as per table 142 and as defined in [FIPS PUB 180-4]^1^, [FIPS PUB 202]^2^ or [RFC 7693]^3^ respectively, is a mechanism which provides the capability of deriving a secret key by digesting the value of another secret key with function \<hash\>. 

+-------------------------------+----------------------------+-------------------------+
| Mechanism                     | Hash function              | Digest length in bytes  |
+==============================:+:==========================:+:=======================:+
| CKM_SHA1_KEY_DERIVATION       | SHA-1 ^1^                  | 20                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA224_KEY_DERIVATION     | SHA-224 ^1^                | 28                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA256_KEY_DERIVATION     | SHA-256 ^1^                | 32                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA384_KEY_DERIVATION     | SHA-384 ^1^                | 48                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA512_KEY_DERIVATION     | SHA-512 ^1^                | 64                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA512_224_KEY_DERIVATION | SHA-512/t ^1^              | 28                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA512_256_KEY_DERIVATION | SHA-512/t ^1^              | 32                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA512_T_KEY_DERIVATION   | SHA-512/t ^1^              | ⌈t divided by 8⌉        |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA3_224_KEY_DERIVATION   | SHA3-224 ^2^               | 28                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA3_256_KEY_DERIVATION   | SHA3-256 ^2^               | 32                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA3_384_KEY_DERIVATION   | SHA3-384 ^2^               | 48                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHA3_512_KEY_DERIVATION   | SHA3-512 ^2^               | 64                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHAKE_128_KEY_DERIVATION  | SHAKE ^2^                  | 32                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_SHAKE_256_KEY_DERIVATION  | SHAKE ^2^                  | 64                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_BLAKE2B_160_KEY_DERIVE    | Blake2b ^3^                | 20                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_BLAKE2B_256_KEY_DERIVE    | Blake2b ^3^                | 32                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_BLAKE2B_384_KEY_DERIVE    | Blake2b ^3^                | 48                      |
+-------------------------------+----------------------------+-------------------------+
| CKM_BLAKE2B_512_KEY_DERIVE    | Blake2b ^3^                | 64                      |
+-------------------------------+----------------------------+-------------------------+
table 142: Hash-based key derivation: mechanisms and hash / expansion functions

The value of the base key is digested once, and the result is used to make the value of the derived secret key.

* If no length or key type is provided in the template, then the key produced by this mechanism will be a generic secret key. Its length will be the digest length in bytes as per table 142.
* If no key type is provided in the template, but a length is, then the key produced by this mechanism will be a generic secret key of the specified length.
* If no length was provided in the template, but a key type is, then that key type must have a well-defined length. If it does, then the key produced by this mechanism will be of the type specified in the template. If it doesn’t, an error will be returned.
* If both a key type and a length are provided in the template, the length must be compatible with that key type. The key produced by this mechanism will be of the specified type and length.

If a DES, DES2, or CDMF key is derived with this mechanism, the parity bits of the key will be set properly.
If the requested type of key requires more than the digest length in bytes, an error is generated.

This mechanism has the following rules about key sensitivity and extractability:

* The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for the new key can both be specified to be either CK_TRUE or CK_FALSE. If omitted, these attributes each take on some default value.
* If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE, then the derived key will as well. If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its **CKA_SENSITIVE attribute**.
* Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE, then the derived key will, too. 

If the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its **CKA_EXTRACTABLE** attribute.
