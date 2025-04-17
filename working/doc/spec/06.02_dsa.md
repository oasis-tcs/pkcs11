## DSA

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_DSA_KEY_PAIR_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_PARAMETER_GEN                |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_PROBABILISTIC_PARAMETER_GEN  |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHAWE_TAYLOR_PARAMETER_GEN   |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_FIPS_G_GEN                   |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA                              |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA1                         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA224                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA256                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA384                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA512                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA3_224                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA3_256                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA3_384                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DSA_SHA3_512                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: DSA Mechanisms vs. Functions

^1^ Single-part operations only

### Definitions

This section defines the key type “**CKK_DSA**” for type CK_KEY_TYPE as used in
the **CKA_KEY_TYPE** attribute of DSA key objects.

Mechanisms:

- CKM_DSA_KEY_PAIR_GEN
- CKM_DSA
- CKM_DSA_SHA1
- CKM_DSA_SHA224
- CKM_DSA_SHA256
- CKM_DSA_SHA384
- CKM_DSA_SHA512
- CKM_DSA_SHA3_224
- CKM_DSA_SHA3_256
- CKM_DSA_SHA3_384
- CKM_DSA_SHA3_512 
- CKM_DSA_PARAMETER_GEN
- CKM_DSA_PROBABILISTIC_PARAMETER_GEN
- CKM_DSA_SHAWE_TAYLOR_PARAMETER_GEN
- CKM_DSA_FIPS_G_GEN

#### CK_DSA_PARAMETER_GEN_PARAM
\  

CK_DSA_PARAMETER_GEN_PARAM is a structure which provides and returns parameters
for the [NIST FIPS 186-4] parameter generating algorithms.

CK_DSA_PARAMETER_GEN_PARAM_PTR is a pointer to a CK_DSA_PARAMETER_GEN_PARAM.

~~~{.c}
typedef struct CK_DSA_PARAMETER_GEN_PARAM {
	CK_MECHANISM_TYPE	hash;
	CK_BYTE_PTR	pSeed;
	CK_ULONG	ulSeedLen;
	CK_ULONG	ulIndex;
}	CK_DSA_PARAMETER_GEN_PARAM;
~~~

The fields of the structure have the following meanings:

_hash_
: Mechanism value for the base hash used in PQG generation, Valid values are
  **CKM_SHA_1**, **CKM_SHA224**, **CKM_SHA256**, **CKM_SHA384**,
  **CKM_SHA512**.

_pSeed_
: Seed value used to generate PQ and G. This value is returned by
  **CKM_DSA_PROBABILISTIC_PARAMETER_GEN**,
  **CKM_DSA_SHAWE_TAYLOR_PARAMETER_GEN**, and passed into
  **CKM_DSA_FIPS_G_GEN**.

_ulSeedLen_
: Length of seed value.

_ulIndex_
: Index value for generating G. Input for **CKM_DSA_FIPS_G_GEN**. Ignored by
  **CKM_DSA_PROBABILISTIC_PARAMETER_GEN** and
  **CKM_DSA_SHAWE_TAYLOR_PARAMETER_GEN**.

### DSA public key objects

DSA public key objects (object class **CKO_PUBLIC_KEY**, key type **CKK_DSA**)
hold DSA public keys. The following table defines the DSA public key object
attributes, in addition to the common attributes defined for this object class:

| Attribute          | Data type   | Meaning                             |
|--------------------|-------------|-------------------------------------|
| CKA_PRIME ^1,3^    | Big integer | Prime p (512 to 3072 bits, in steps of 64 bits) |
| CKA_SUBPRIME ^1,3^ | Big integer | Subprime q (160, 224 bits, or 256 bits) |
| CKA_BASE ^1,3^     | Big integer | Base g                              |
| CKA_VALUE ^1,4^    | Big integer | Public value y                      |
table: DSA Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME**, **CKA_SUBPRIME** and **CKA_BASE** attribute values are
collectively the “DSA domain parameters”. See [FIPS PUB 186-4] for more
information on DSA keys.

The following is a sample template for creating a DSA public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_DSA;
CK_UTF8CHAR label[] = “A DSA public key object”;
CK_BYTE prime[] = {...};
CK_BYTE subprime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_SUBPRIME, subprime, sizeof(subprime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### DSA Key Restrictions

[FIPS PUB 186-4] specifies permitted combinations of prime and sub-prime
lengths. They are:

* Prime: 1024 bits, Subprime: 160
* Prime: 2048 bits, Subprime: 224
* Prime: 2048 bits, Subprime: 256
* Prime: 3072 bits, Subprime: 256

Earlier versions of FIPS PUB 186 permitted smaller prime lengths, and those are
included here for backwards compatibility. An implementation that is compliant
to [FIPS PUB 186-4] does not permit the use of primes of any length less than
1024 bits.

### DSA private key objects

DSA private key objects (object class **CKO_PRIVATE_KEY**, key type **CKK_DSA**)
hold DSA private keys. The following table defines the DSA private key object
attributes, in addition to the common attributes defined for this object class:

| Attribute            | Data type   | Meaning                           |
|----------------------|-------------|-----------------------------------|
| CKA_PRIME ^1,4,6^    | Big integer | Prime p (512 to 1024 bits, in steps of 64 bits) |
| CKA_SUBPRIME ^1,4,6^ | Big integer |Subprime q (160 bits, 224 bits, or 256 bits) |
| CKA_BASE ^1,4,6^     | Big integer | Base g                            |
| CKA_VALUE ^1,4,6,7^  | Big integer | Private value x                   |
table: DSA Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME**, **CKA_SUBPRIME** and **CKA_BASE** attribute values are
collectively the “DSA domain parameters”. See [FIPS PUB 186-4] for more
information on DSA keys.

Note that when generating a DSA private key, the DSA domain parameters are not
specified in the key’s template. This is because DSA private keys are only
generated as part of a DSA key pair, and the DSA domain parameters for the pair
are specified in the template for the DSA public key.

The following is a sample template for creating a DSA private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_DSA;
CK_UTF8CHAR label[] = “A DSA private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE prime[] = {...};
CK_BYTE subprime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_SENSITIVE, &true, sizeof(true)},
  {CKA_SIGN, &true, sizeof(true)},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_SUBPRIME, subprime, sizeof(subprime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### DSA domain parameter objects

DSA domain parameter objects (object class **CKO_DOMAIN_PARAMETERS**, key type
**CKK_DSA**) hold DSA domain parameters. The following table defines the DSA
domain parameter object attributes, in addition to the common attributes defined
for this object class:

| Attribute            | Data type   | Meaning                           |
|----------------------|-------------|-----------------------------------|
| CKA_PRIME ^1,4^      | Big integer | Prime p (512 to 1024 bits, in steps of 64 bits) |
| CKA_SUBPRIME ^1,4^   | Big integer | Subprime q (160 bits, 224 bits, or 256 bits) |
| CKA_BASE ^1,4^       | Big integer | Base g                            |
| CKA_PRIME_BITS ^2,3^ | CK_ULONG    | Length of the prime value.        |
table: DSA Domain Parameter Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME**, **CKA_SUBPRIME** and **CKA_BASE** attribute values are
collectively the “DSA domain parameters”. See [FIPS PUB 186-4] for more
information on DSA domain parameters.

To ensure backwards compatibility, if **CKA_SUBPRIME_BITS** is not specified for
a call to C_GenerateKey, it takes on a default based on the value of
**CKA_PRIME_BITS** as follows: 

* If **CKA_PRIME_BITS** is less than or equal to 1024 then **CKA_SUBPRIME_BITS**
  shall be 160 bits
* If **CKA_PRIME_BITS** equals 2048 then **CKA_SUBPRIME_BITS** shall be 224 bits
* If **CKA_PRIME_BITS** equals 3072 then **CKA_SUBPRIME_BITS** shall be 256 bits

The following is a sample template for creating a DSA domain parameter object:

~~~{.C}
CK_OBJECT_CLASS class = CKO_DOMAIN_PARAMETERS;
CK_KEY_TYPE keyType = CKK_DSA;
CK_UTF8CHAR label[] = “A DSA domain parameter object”;
CK_BYTE prime[] = {...};
CK_BYTE subprime[] = {...};
CK_BYTE base[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_SUBPRIME, subprime, sizeof(subprime)},
  {CKA_BASE, base, sizeof(base)},
};
~~~

### DSA key pair generation

The DSA key pair generation mechanism, denoted **CKM_DSA_KEY_PAIR_GEN**, is a
key pair generation mechanism based on the Digital Signature Algorithm defined
in FIPS PUB 186-2.

This mechanism does not have a parameter.

The mechanism generates DSA public/private key pairs with a particular prime,
subprime and base, as specified in the **CKA_PRIME**, **CKA_SUBPRIME**, and
**CKA_BASE** attributes of the template for the public key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PRIME**, **CKA_SUBPRIME**, **CKA_BASE**, and **CKA_VALUE** attributes to
the new private key. Other attributes supported by the DSA public and private
key types (specifically, the flags indicating which functions the keys support)
may also be specified in the templates for the keys, or else are assigned
default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### DSA domain parameter generation

The DSA domain parameter generation mechanism, denoted
**CKM_DSA_PARAMETER_GEN**, is a domain parameter generation mechanism based on
the Digital Signature Algorithm defined in FIPS PUB 186-2.

This mechanism does not have a parameter.

The mechanism generates DSA domain parameters with a particular prime length in
bits, as specified in the **CKA_PRIME_BITS** attribute of the template.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_PRIME**,
**CKA_SUBPRIME**, **CKA_BASE** and **CKA_PRIME_BITS** attributes to the new
object. Other attributes supported by the DSA domain parameter types may also be
specified in the template, or else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### DSA probabilistic domain parameter generation

The DSA probabilistic domain parameter generation mechanism, denoted
**CKM_DSA_PROBABILISTIC_PARAMETER_GEN**, is a domain parameter generation
mechanism based on the Digital Signature Algorithm defined in [FIPS PUB 186-4],
section Appendix A.1.1 Generation and Validation of Probable Primes..

This mechanism takes a **CK_DSA_PARAMETER_GEN_PARAM** which supplies the base
hash and returns the seed (pSeed) and the length (ulSeedLen).

The mechanism generates DSA the prime and subprime domain parameters with a
particular prime length in bits, as specified in the **CKA_PRIME_BITS**
attribute of the template and the subprime length as specified in the
**CKA_SUBPRIME_BITS** attribute of the template.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_PRIME**,
**CKA_SUBPRIME**, **CKA_PRIME_BITS**, and **CKA_SUBPRIME_BITS** attributes to
the new object. **CKA_BASE** is not set by this call. Other attributes supported
by the DSA domain parameter types may also be specified in the template, or else
are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### DSA Shawe-Taylor domain parameter generation

The DSA Shawe-Taylor domain parameter generation mechanism, denoted
**CKM_DSA_SHAWE_TAYLOR_PARAMETER_GEN**, is a domain parameter generation
mechanism based on the Digital Signature Algorithm defined in [FIPS PUB 186-4],
section Appendix A.1.2 Construction and Validation of Provable Primes p and q.

This mechanism takes a **CK_DSA_PARAMETER_GEN_PARAM** which supplies the base
hash and returns the seed (pSeed) and the length (ulSeedLen).

The mechanism generates DSA the prime and subprime domain parameters with a
particular prime length in bits, as specified in the **CKA_PRIME_BITS**
attribute of the template and the subprime length as specified in the
**CKA_SUBPRIME_BITS** attribute of the template.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_PRIME**,
**CKA_SUBPRIME**, **CKA_PRIME_BITS**, and **CKA_SUBPRIME_BITS** attributes to
the new object. **CKA_BASE** is not set by this call. Other attributes supported
by the DSA domain parameter types may also be specified in the template, or else
are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### DSA base domain parameter generation

The DSA base domain parameter generation mechanism, denoted
**CKM_DSA_FIPS_G_GEN**, is a base parameter generation mechanism based on the
Digital Signature Algorithm defined in [FIPS PUB 186-4], section Appendix A.2
Generation of Generator G.

This mechanism takes a **CK_DSA_PARAMETER_GEN_PARAM** which supplies the base
hash the seed (pSeed) and the length (ulSeedLen) and the index value.

The mechanism generates the DSA base with the domain parameter specified in the
**CKA_PRIME** and **CKA_SUBPRIME** attributes of the template.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_BASE**
attributes to the new object. Other attributes supported by the DSA domain
parameter types may also be specified in the template, or else are assigned
default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### DSA without hashing

The DSA without hashing mechanism, denoted **CKM_DSA**, is a mechanism for
single-part signatures and verification based on the Digital Signature Algorithm
defined in FIPS PUB 186-2. (This mechanism corresponds only to the part of DSA
that processes the 20-byte hash value; it does not compute the hash value.)

For the purposes of this mechanism, a DSA signature is a 40-byte string,
corresponding to the concatenation of the DSA values r and s, each represented
most-significant byte first.

It does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function     | Key type        | Input length                | Output length |
|--------------|-----------------|-----------------------------|---------------|
| C_Sign ^1^   | DSA private key | 20, 28, 32, 48, or 64 bytes | 2*length of subprime |
| C_Verify ^1^ | DSA public key  | (20, 28, 32, 48, or 64 bytes), (2*length of subprime)^2^ | N/A |
table: DSA: Key And Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### DSA with hashing

The DSA with hashing mechanism, denoted **CKM_DSA_\<hash\>** where \<hash\>
identifies a hash function as per Table 58, is a mechanism for single- and
multiple-part signatures and verification based on the Digital Signature
Algorithm defined in [FIPS PUB 186-4]. This mechanism computes the entire DSA
specification, including the hashing.

| Mechanism        | Hash function |
|------------------|---------------|
| CKM_DSA_SHA1     | SHA-1         |
| CKM_DSA_SHA224   | SHA-224       |
| CKM_DSA_SHA256   | SHA-256       |
| CKM_DSA_SHA384   | SHA-384       |
| CKM_DSA_SHA512   | SHA-512       |
| CKM_DSA_SHA3_224 | SHA3-224      |
| CKM_DSA_SHA3_256 | SHA3-256      |
| CKM_DSA_SHA3_384 | SHA3-384      |
| CKM_DSA_SHA3_512 | SHA3-512      |
table: DSA with hashing: mechanisms and hash functions

For the purposes of this mechanism, a DSA signature is a 40-byte string,
corresponding to the concatenation of the DSA values r and s, each represented
most-significant byte first.

This mechanism does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type        | Input length | Output length        |
|----------|-----------------|--------------|----------------------|
| C_Sign   | DSA private key | any          | 2*length of subprime |
| C_Verify | DSA public key  | any, 2*length of subprime^2^  | N/A |
table: DSA with SHA-1: Key And Data Length

^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.

### FIPS 186-4

When **CKM_DSA** is operated in FIPS mode, only the following bit lengths of p
and q, represented by L and N, SHALL be used:

L = 1024, N = 160  
L = 2048, N = 224  
L = 2048, N = 256  
L = 3072, N = 256  

