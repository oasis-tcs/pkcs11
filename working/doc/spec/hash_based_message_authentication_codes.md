## Hash-Based Message Authentication Codes (HMAC)

HMAC mechanisms are mechanisms for signatures and verification, and for generation of HMAC keys.
Refer to [RFC 2104] and [FIPS 198] for HMAC algorithm description. The HMAC secret key shall correspond to the PKCS #11 generic secret key type or the mechanism specific key types (see mechanism definition). Such keys for use with HMAC operations can be created using **C_CreateObject**, **C_GenerateKey**, or **C_UnwrapKey**.
The RFC also specifies test vectors for the various hash function based HMAC mechanisms described in the respective hash mechanism descriptions. The RFC should be consulted to obtain these test vectors.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SHA_1_HMAC                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA_1_HMAC_GENERAL               |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA_1_KEY_GEN                    |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA224_HMAC                      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA224_HMAC_GENERAL              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA224_KEY_GEN                   |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA256_HMAC                      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA256_HMAC_GENERAL              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA256_KEY_GEN                   |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA384_HMAC                      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA384_HMAC_GENERAL              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA384_KEY_GEN                   |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_HMAC                      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_HMAC_GENERAL              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_KEY_GEN                   |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_224_HMAC                  |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_224_HMAC_GENERAL          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_224_KEY_GEN               |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_256_HMAC                  |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_256_HMAC_GENERAL          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_256_KEY_GEN               |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_HMAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_HMAC_GENERAL            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_T_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_224_HMAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_224_HMAC_GENERAL            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_224_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_256_HMAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_256_HMAC_GENERAL            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_256_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_384_HMAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_384_HMAC_GENERAL            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_384_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_512_HMAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_512_HMAC_GENERAL            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_512_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_160_HMAC                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_160_HMAC_GENERAL         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_160_KEY_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_256_HMAC                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_256_HMAC_GENERAL         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_256_KEY_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_384_HMAC                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_384_HMAC_GENERAL         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_384_KEY_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_HMAC                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_HMAC_GENERAL         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512_KEY_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table 143: HMAC Mechanisms vs. Functions

### Definitions

This section defines the key types for type CK_KEY_TYPE as used
in the **CKA_KEY_TYPE** attribute of key objects.

- CKK_SHA_1_HMAC
- CKK_SHA224_HMAC
- CKK_SHA256_HMAC
- CKK_SHA384_HMAC
- CKK_SHA512_HMAC
- CKK_SHA512_224_HMAC
- CKK_SHA512_256_HMAC
- CKK_SHA512_T_HMAC
- CKK_SHA3_224_HMAC
- CKK_SHA3_256_HMAC
- CKK_SHA3_384_HMAC
- CKK_SHA3_512_HMAC
- CKK_BLAKE2B_160_HMAC
- CKK_BLAKE2B_256_HMAC
- CKK_BLAKE2B_384_HMAC
- CKK_BLAKE2B_512_HMAC

Mechanisms:

- CKM_SHA_1_HMAC
- CKM_SHA_1_HMAC_GENERAL
- CKM_SHA_1_KEY_GEN
- CKM_SHA224_HMAC
- CKM_SHA224_HMAC_GENERAL
- CKM_SHA224_KEY_GEN
- CKM_SHA256_HMAC
- CKM_SHA256_HMAC_GENERAL
- CKM_SHA256_KEY_GEN
- CKM_SHA384_HMAC
- CKM_SHA384_HMAC_GENERAL
- CKM_SHA384_KEY_GEN
- CKM_SHA512_HMAC
- CKM_SHA512_HMAC_GENERAL
- CKM_SHA512_KEY_GEN
- CKM_SHA512_224_HMAC
- CKM_SHA512_224_HMAC_GENERAL
- CKM_SHA512_224_KEY_GEN
- CKM_SHA512_256_HMAC
- CKM_SHA512_256_HMAC_GENERAL
- CKM_SHA512_256_KEY_GEN
- CKM_SHA512_T_HMAC
- CKM_SHA512_T_HMAC_GENERAL
- CKM_SHA512_T_KEY_GEN
- CKM_SHA3_224_HMAC
- CKM_SHA3_224_HMAC_GENERAL
- CKM_SHA3_224_KEY_GEN
- CKM_SHA3_256_HMAC
- CKM_SHA3_256_HMAC_GENERAL
- CKM_SHA3_256_KEY_GEN
- CKM_SHA3_384_HMAC
- CKM_SHA3_384_HMAC_GENERAL
- CKM_SHA3_384_KEY_GEN
- CKM_SHA3_512_HMAC
- CKM_SHA3_512_HMAC_GENERAL
- CKM_SHA3_512_KEY_GEN
- CKM_BLAKE2B_160_HMAC
- CKM_BLAKE2B_160_HMAC_GENERAL
- CKM_BLAKE2B_160_KEY_GEN
- CKM_BLAKE2B_256_HMAC
- CKM_BLAKE2B_256_HMAC_GENERAL
- CKM_BLAKE2B_256_KEY_GEN
- CKM_BLAKE2B_384_HMAC
- CKM_BLAKE2B_384_HMAC_GENERAL
- CKM_BLAKE2B_384_KEY_GEN
- CKM_BLAKE2B_512_HMAC
- CKM_BLAKE2B_512_HMAC_GENERAL
- CKM_BLAKE2B_512_KEY_GEN

### General-length HMAC

The general-length HMAC mechanism, denoted **CKM_**\<hash>**\_HMAC_GENERAL**, where \<hash\> identifies a hash function or truncated hash function as per table 144 and as defined in [FIPS PUB 180-4]^1^, [FIPS PUB 202]^2^ or [RFC 7693]^3^ respectively, is a mechanism for signatures and verification. It uses the HMAC construction, based on the \<hash\> hash function. The keys it uses are generic secret keys and **CKK_**\<hash>**\_HMAC** keys.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the length in bytes
of the desired output. This length should be in the range 1-n, where len is the output size of the hash function in bytes as per table 144. Signatures (MACs)
produced by this mechanism will be taken from the start of the full len-byte HMAC
output.

+-------------------------------+----------------------------+--------------------------+
| Mechanism                     | Hash function              | Digest length in bytes   |
+==============================:+:==========================:+:========================:+
| CKM_SHA_1_HMAC_GENERAL        | SHA-1 ^1^                  | 20                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA224_HMAC_GENERAL       | SHA-224 ^1^                | 28                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA256_HMAC_GENERAL       | SHA-256 ^1^                | 32                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA384_HMAC_GENERAL       | SHA-384 ^1^                | 48                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA512_HMAC_GENERAL       | SHA-512 ^1^                | 64                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA512_224_HMAC_GENERAL   | SHA-512/t ^1^              | 28                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA512_256_HMAC_GENERAL   | SHA-512/t ^1^              | 32                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA512_T_HMAC_GENERAL     | SHA-512/t ^1^              | ⌈t/8⌉ where 0 < t < 512, |
|                               |                            | and t <> 384             |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA3_224_HMAC_GENERAL     | SHA3-224 ^2^               | 28                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA3_256_HMAC_GENERAL     | SHA3-256 ^2^               | 32                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA3_384_HMAC_GENERAL     | SHA3-384 ^2^               | 48                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_SHA3_512_HMAC_GENERAL     | SHA3-512 ^2^               | 64                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_BLAKE2B_160_HMAC_GENERAL  | Blake2b ^3^                | 20                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_BLAKE2B_256_HMAC_GENERAL  | Blake2b ^3^                | 32                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_BLAKE2B_384_HMAC_GENERAL  | Blake2b ^3^                | 48                       |
+-------------------------------+----------------------------+--------------------------+
| CKM_BLAKE2B_512_HMAC_GENERAL  | Blake2b ^3^                | 64                       |
+-------------------------------+----------------------------+--------------------------+
table 144: HMAC: mechanisms and hash functions


| Function | Key type                            | Data length | Signature length               |
|----------|-------------------------------------|-------------|--------------------------------|
| C_Sign   | generic secret or CKK_\<hash\>_HMAC | Any         | 1-len, depending on parameters |
| C_Verify | generic secret or CKK_\<hash>\_HMAC | Any         | 1-len, depending on parameters |
table 145: General-length HMAC: Key And Data Length

### HMAC

The full-length HMAC mechanism, denoted **CKM_**\<hash\>**\_HMAC**, is a special case of
the respective general-length **CKM_**\<hash\>**\_HMAC_GENERAL** mechanism in section 6.22.2.

It has no parameter, and always produces an output of length as per table 144.

### HMAC key generation

The HMAC key generation mechanism, denoted **CKM_**\<hash\>**\_KEY_GEN**, is a
key generation mechanism for NIST’s \<hash\>-HMAC.

It does not have a parameter.

The mechanism generates HMAC keys of key type **CKK_**\<hash\>**\_HMAC** with a particular length in bytes, as
specified in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the HMAC key
type (specifically, the flags indicating which functions the key supports) may
be specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of
**CKM_**\<hash\>**\_HMAC** key sizes, in bytes.
