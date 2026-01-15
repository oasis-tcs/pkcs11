## Digests

+--------------------------------+---------------------------------------------------------+
|                                | Functions                                               |
|                                +-----+-----+------+-----+-----+-------+-----+-----+------+
| Mechanism                      | ENC | SIG | SIGR |     |     | GENK  | WRP |     | ENCS |
|                                |  &  |  &  |  &   | DIG | XOF |   &   |  &  | DRV |  &   |
|                                | DEC | VER | VERR |     |     | GENKP | UWRP|     | DECS |
+================================+:===:+:===:+:====:+:===:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SHA_1                      |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA224                     |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA256                     |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA384                     |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA512                     |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA512_224                 |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA512_256                 |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA512_T                   |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA3_224                   |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA3_256                   |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA3_384                   |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHA3_512                   |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_BLAKE2B_160                |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_BLAKE2B_256                |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_BLAKE2B_384                |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_BLAKE2B_512                |     |     |      |  ✓  |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHAKE_128                  |     |     |      |     |  ✓  |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_SHAKE_256                  |     |     |      |     |  ✓  |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-----+-------+-----+-----+------+
table: Digest Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_SHA_1
- CKM_SHA224
- CKM_SHA256
- CKM_SHA384
- CKM_SHA512
- CKM_SHA512_224
- CKM_SHA512_256
- CKM_SHA512_T
- CKM_SHA3_224
- CKM_SHA3_256
- CKM_SHA3_384
- CKM_SHA3_512
- CKM_BLAKE2B_160
- CKM_BLAKE2B_256
- CKM_BLAKE2B_384
- CKM_BLAKE2B_512
- CKM_SHAKE_128
- CKM_SHAKE_256

### Digest

The digest mechanism, denoted **CKM_\<hash\>** where \<hash\> identifies a hash
function as per table 137, is a mechanism for message digesting, following the
hash function as per table 137, defined in [FIPS PUB 180-4]^1^, [FIPS PUB
202]^2^ or [RFC 7693]^3^ respectively.

+------------------+----------------------------+-------------------------+-------------------------+
| Mechanism        | Hash function              | Digest length in bits   | Digest length in bytes  |
+=================:+:==========================:+:=======================:+:=======================:+
| CKM_SHA_1        | SHA-1 ^1^                  | 160                     | 20                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA224       | SHA-224 ^1^                | 224                     | 28                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA256       | SHA-256 ^1^                | 256                     | 32                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA384       | SHA-384 ^1^                | 384                     | 48                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA512       | SHA-512 ^1^                | 512                     | 64                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA3_224     | SHA3-224 ^2^               | 224                     | 28                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA3_256     | SHA3-256 ^2^               | 256                     | 32                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA3_384     | SHA3-384 ^2^               | 384                     | 48                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_SHA3_512     | SHA3-512 ^2^               | 512                     | 64                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_BLAKE2B_160  | Blake2b ^3^                | 160                     | 20                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_BLAKE2B_256  | Blake2b ^3^                | 256                     | 32                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_BLAKE2B_384  | Blake2b ^3^                | 384                     | 48                      |
+------------------+----------------------------+-------------------------+-------------------------+
| CKM_BLAKE2B_512  | Blake2b ^3^                | 512                     | 64                      |
+------------------+----------------------------+-------------------------+-------------------------+
table 137: Digest: mechanisms and hash functions

It does not have a parameter.

Constraints on the length of input and output data are summarized in the
following table. For single-part digesting, the data and the digest may begin at
the same location in memory.

| Function | Input length | Digest length                              |
|----------|--------------|--------------------------------------------|
| C_Digest | any          | Digest length in bytes as per table 137    |
table 138: Digest: Data Length

### Truncated Digest

The truncated digest mechanism, denoted **CKM_SHA512_\<t\>**, is a mechanism for
message digesting, following the Secure Hash Algorithm defined in [FIPS PUB
180-4] section 5.3.6. It is based on a 512-bit message digest with a distinct
initial hash value and truncated to \<t\> bits as per table 139.
**CKM_SHA512_\<t\>** is the same as **CKM_SHA512_T** with a parameter value of
\<t\>.

+------------------+-----------------+-------------------------+-------------------------+
| Mechanism        | Hash function   | Truncated digest length | Truncated digest length |
|                  |                 | in bits <t>             | in bytes                |
+=================:+:===============:+:=======================:+:=======================:+
| CKM_SHA512_224   | SHA-512/t       | 224                     | 28                      |
+------------------+-----------------+-------------------------+-------------------------+
| CKM_SHA512_256   | SHA-512/t       | 256                     | 32                      |
+------------------+-----------------+-------------------------+-------------------------+
| CKM_SHA512_T     | SHA-512/t       | t                       | ⌈t divided by 8⌉        |
+------------------+-----------------+-------------------------+-------------------------+
table 139: Truncated digest: mechanisms and hash functions

**CKM_SHA512_224** and **CKM_SHA512_256** do not have a parameter.

**CKM_SHA512_T** has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the
value of t in bits. The length in bytes of the desired output should be in the
range of 0-⌈t/8⌉, where 0 < t < 512, and t <> 384.

Constraints on the length of input and output data are summarized in the
following table. For single-part digesting, the data and the digest may begin at
the same location in memory.

| Function | Input length | Digest length                              |
|----------|--------------|--------------------------------------------|
| C_Digest | any          | Digest length in bytes as per table 139    |
table 140: Truncated digest: Data Length

### Extensible Output Digest

SHAKE-128 and SHAKE-256 hashing, denoted **CKM_SHAKE_128** and
**CKM_SHAKE_256**, are extensible-output hash functions as defined in [FIPS PUB
202]. These mechanisms are used with the Extensible Output Digesting Functions
(**C_DigestXofInit**, **C_DigestXofUpdate**, **C_DigestXofExtract**, and
**C_DigestXofFinal**). The output from these hash functions can be of any
length. These mechanisms do not have any parameters.
