# Mechanisms

## RSA

+--------------------------------+---------------------------------------------------+
|                                |Functions                                          |
|                                +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                      | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_RSA_PKCS_KEY_PAIR_GEN      |     |     |      |     |   ✓   |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_X9_31_KEY_PAIR_GEN     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_PKCS                   | ✓^1^| ✓^1^|  ✓   |     |       |  ✓  |     |  ✓   |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_PKCS_OAEP              | ✓^1^|     |      |     |       |  ✓  |     |  ✓   |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_PKCS_PSS               |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_9796                   |     | ✓^1^|  ✓   |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_X_509                  | ✓^1^| ✓^1^|  ✓   |     |       |  ✓  |     |  ✓   |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_X9_31                  |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA1_RSA_PKCS              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA224_RSA_PKCS            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA256_RSA_PKCS            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA384_RSA_PKCS            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_RSA_PKCS            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA1_RSA_PKCS_PSS          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA224_RSA_PKCS_PSS        |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA256_RSA_PKCS_PSS        |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA384_RSA_PKCS_PSS        |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA512_RSA_PKCS_PSS        |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA1_RSA_X9_31             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_PKCS_TPM_1_1           | ✓^1^|     |      |     |       |  ✓  |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_RSA_PKCS_OAEP_TPM_1_1      | ✓^1^|     |      |     |       |  ✓  |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_224_RSA_PKCS          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_256_RSA_PKCS          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_384_RSA_PKCS          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_512_RSA_PKCS          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_224_RSA_PKCS_PSS      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_256_RSA_PKCS_PSS      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_384_RSA_PKCS_PSS      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHA3_512_RSA_PKCS_PSS      |     |  ✓  |      |     |       |     |     |      |
+--------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Mechanisms vs. Functions

^1^ Single-part operations only

### Definitions

This section defines the RSA key type “**CKK_RSA**” for type CK_KEY_TYPE as used
in the **CKA_KEY_TYPE** attribute of RSA key objects.

Mechanisms:

- CKM_RSA_PKCS_KEY_PAIR_GEN
- CKM_RSA_PKCS
- CKM_RSA_9796
- CKM_RSA_X_509
- CKM_MD2_RSA_PKCS
- CKM_MD5_RSA_PKCS
- CKM_SHA1_RSA_PKCS
- CKM_SHA224_RSA_PKCS
- CKM_SHA256_RSA_PKCS
- CKM_SHA384_RSA_PKCS
- CKM_SHA512_RSA_PKCS
- CKM_RIPEMD128_RSA_PKCS
- CKM_RIPEMD160_RSA_PKCS
- CKM_RSA_PKCS_OAEP
- CKM_RSA_X9_31_KEY_PAIR_GEN
- CKM_RSA_X9_31
- CKM_SHA1_RSA_X9_31
- CKM_RSA_PKCS_PSS
- CKM_SHA1_RSA_PKCS_PSS
- CKM_SHA224_RSA_PKCS_PSS
- CKM_SHA256_RSA_PKCS_PSS
- CKM_SHA512_RSA_PKCS_PSS
- CKM_SHA384_RSA_PKCS_PSS
- CKM_RSA_PKCS_TPM_1_1
- CKM_RSA_PKCS_OAEP_TPM_1_1 
- CKM_RSA_AES_KEY_WRAP
- CKM_SHA3_224_RSA_PKCS
- CKM_SHA3_256_RSA_PKCS
- CKM_SHA3_384_RSA_PKCS
- CKM_SHA3_512_RSA_PKCS
- CKM_SHA3_224_RSA_PKCS_PSS
- CKM_SHA3_256_RSA_PKCS_PSS
- CKM_SHA3_384_RSA_PKCS_PSS
- CKM_SHA3_512_RSA_PKCS_PSS


### RSA public key objects

RSA public key objects (object class **CKO_PUBLIC_KEY**, key type **CKK_RSA**)
hold RSA public keys. The following table defines the RSA public key object
attributes, in addition to the common attributes defined for this object class:

| Attribute               | Data type   | Meaning                        |
|-------------------------|-------------|--------------------------------|
| CKA_MODULUS ^1,4^       | Big integer | Modulus n                      |
| CKA_MODULUS_BITS ^2,3^  | CK_ULONG    | Length in bits of modulus n    |
| CKA_PUBLIC_EXPONENT ^1^ | Big integer | Public exponent e              |
| CKA_PUBLIC_CRC64_VALUE ^1,4,13^ | Byte array | The CRC-64-ECMA calculated over the CKA_MODULUS attribute |
table: RSA Public Key Object Attributes

- Refer to Table 13 for footnotes

Depending on the token, there may be limits on the length of key components. See
[PKCS #1] for more information on RSA keys.  The following is a sample template
for creating an RSA public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_RSA;
CK_UTF8CHAR label[] = “An RSA public key object”;
CK_BYTE modulus[] = {...};
CK_BYTE exponent[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_WRAP, &true, sizeof(true)},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_MODULUS, modulus, sizeof(modulus)},
  {CKA_PUBLIC_EXPONENT, exponent, sizeof(exponent)}
};
~~~

### RSA private key objects

RSA private key objects (object class **CKO_PRIVATE_KEY**, key type **CKK_RSA**)
hold RSA private keys. The following table defines the RSA private key object
attributes, in addition to the common attributes defined for this object class:

| Attribute               | Data type   | Meaning                        |
|-------------------------|-------------|--------------------------------|
| CKA_MODULUS ^1,4,6^     | Big integer | Modulus n                      |
| CKA_PUBLIC_EXPONENT ^1,4,6^ | Big integer | Public exponent e          |
| CKA_PRIVATE_EXPONENT ^1,4,6,7^ | Big integer | Private exponent d      |
| CKA_PRIME_1 ^4,6,7^     | Big integer | Prime p                        |
| CKA_PRIME_2 ^4,6,7^     | Big integer | Prime q                        |
| CKA_EXPONENT_1 ^4,6,7^  | Big integer | Private exponent d modulo p-1  |
| CKA_EXPONENT_2 ^4,6,7^  | Big integer | Private exponent d modulo q-1  |
| CKA_COEFFICIENT ^4,6,7^ | Big integer | CRT coefficient q-1 mod p      |
| CKA_PUBLIC_CRC64_VALUE ^1,4,13^ | Byte array | The CRC-64-ECMA calculated over the CKA_MODULUS attribute |
table: RSA Private Key Object Attributes

- Refer to Table 13 for footnotes

Depending on the token, there may be limits on the length of the key components.
See [PKCS #1] for more information on RSA keys.

Tokens vary in what they actually store for RSA private keys. Some tokens store
all of the above attributes, which can assist in performing rapid RSA
computations. Other tokens might store only the **CKA_MODULUS** and
**CKA_PRIVATE_EXPONENT** values. Effective with version 2.40, tokens MUST also
store **CKA_PUBLIC_EXPONENT**. This permits the retrieval of sufficient data to
reconstitute the associated public key.

Because of this, Cryptoki is flexible in dealing with RSA private key objects.
When a token generates an RSA private key, it stores whichever of the fields in
[Table 36] it keeps track of. Later, if an application asks for the values of
the key’s various attributes, Cryptoki supplies values only for attributes whose
values it can obtain (i.e., if Cryptoki is asked for the value of an attribute
it cannot obtain, the request fails). Note that a Cryptoki implementation may or
may not be able and/or willing to supply various attributes of RSA private keys
which are not actually stored on the token. _E.g._, if a particular token stores
values only for the **CKA_PRIVATE_EXPONENT**, **CKA_PRIME_1**, and
**CKA_PRIME_2** attributes, then Cryptoki is certainly able to report values for
all the attributes above (since they can all be computed efficiently from these
three values). However, a Cryptoki implementation may or may not actually do
this extra computation. The only attributes from [Table 36] for which a Cryptoki
implementation is required to be able to return values are **CKA_MODULUS**,
**CKA_PUBLIC_EXPONENT** and **CKA_PRIVATE_EXPONENT**. A token SHOULD also be
able to return **CKA_PUBLIC_KEY_INFO** for an RSA private key. 

If an RSA private key object is created on a token, and more attributes from
[Table 36] are supplied to the object creation call than are supported by the
token, the extra attributes are likely to be thrown away. If an attempt is made
to create an RSA private key object on a token with insufficient attributes for
that particular token, then the object creation call fails and returns
**CKR_TEMPLATE_INCOMPLETE**.

Note that when generating an RSA private key, there is no **CKA_MODULUS_BITS**
attribute specified. This is because RSA private keys are only generated as part
of an RSA key pair, and the **CKA_MODULUS_BITS** attribute for the pair is
specified in the template for the RSA public key.

The following is a sample template for creating an RSA private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_RSA;
CK_UTF8CHAR label[] = “An RSA private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE modulus[] = {...};
CK_BYTE publicExponent[] = {...};
CK_BYTE privateExponent[] = {...};
CK_BYTE prime1[] = {...};
CK_BYTE prime2[] = {...};
CK_BYTE exponent1[] = {...};
CK_BYTE exponent2[] = {...};
CK_BYTE coefficient[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_SENSITIVE, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)},
  {CKA_SIGN, &true, sizeof(true)},
  {CKA_MODULUS, modulus, sizeof(modulus)},
  {CKA_PUBLIC_EXPONENT, publicExponent, sizeof(publicExponent)},
  {CKA_PRIVATE_EXPONENT, privateExponent, sizeof(privateExponent)},
  {CKA_PRIME_1, prime1, sizeof(prime1)},
  {CKA_PRIME_2, prime2, sizeof(prime2)},
  {CKA_EXPONENT_1, exponent1, sizeof(exponent1)},
  {CKA_EXPONENT_2, exponent2, sizeof(exponent2)},
  {CKA_COEFFICIENT, coefficient, sizeof(coefficient)}
};
~~~

### PKCS #1 RSA key pair generation

The PKCS #1 RSA key pair generation mechanism, denoted
**CKM_RSA_PKCS_KEY_PAIR_GEN**, is a key pair generation mechanism based on the
RSA public-key cryptosystem, as defined in [PKCS #1].

It does not have a parameter.

The mechanism generates RSA public/private key pairs with a particular modulus
length in bits and public exponent, as specified in the **CKA_MODULUS_BITS** and
**CKA_PUBLIC_EXPONENT** attributes of the template for the public key. The
**CKA_PUBLIC_EXPONENT** may be omitted in which case the mechanism shall supply
the public exponent attribute using the default value of 0x10001 (65537).
Specific implementations may use a random value or an alternative default if
0x10001 cannot be used by the token.

Note: Implementations strictly compliant with version 2.11 or prior versions may
generate an error if this attribute is omitted from the template. Experience has
shown that many implementations of 2.11 and prior did allow the
**CKA_PUBLIC_EXPONENT** attribute to be omitted from the template, and behaved
as described above. The mechanism contributes the **CKA_CLASS**,
**CKA_KEY_TYPE**, **CKA_MODULUS**, and **CKA_PUBLIC_EXPONENT** attributes to the
new public key. **CKA_PUBLIC_EXPONENT** will be copied from the template if
supplied. CKR_TEMPLATE_INCONSISTENT shall be returned if the implementation
cannot use the supplied exponent value. It contributes the **CKA_CLASS** and
**CKA_KEY_TYPE** attributes to the new private key; it may also contribute some
of the following attributes to the new private key: **CKA_MODULUS**,
**CKA_PUBLIC_EXPONENT**, **CKA_PRIVATE_EXPONENT**, **CKA_PRIME_1**,
**CKA_PRIME_2**, **CKA_EXPONENT_1**, **CKA_EXPONENT_2**, **CKA_COEFFICIENT**.
Other attributes supported by the RSA public and private key types
(specifically, the flags indicating which functions the keys support) may also
be specified in the templates for the keys, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### X9.31 RSA key pair generation

The X9.31 RSA key pair generation mechanism, denoted
**CKM_RSA_X9_31_KEY_PAIR_GEN**, is a key pair generation mechanism based on the
RSA public-key cryptosystem, as defined in X9.31.

It does not have a parameter.

The mechanism generates RSA public/private key pairs with a particular modulus
length in bits and public exponent, as specified in the **CKA_MODULUS_BITS** and
**CKA_PUBLIC_EXPONENT** attributes of the template for the public key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_MODULUS**,
and **CKA_PUBLIC_EXPONENT** attributes to the new public key. It contributes the
**CKA_CLASS** and **CKA_KEY_TYPE** attributes to the new private key; it may
also contribute some of the following attributes to the new private key:
**CKA_MODULUS**, **CKA_PUBLIC_EXPONENT**, **CKA_PRIVATE_EXPONENT**,
**CKA_PRIME_1**, **CKA_PRIME_2**, **CKA_EXPONENT_1**, **CKA_EXPONENT_2**,
**CKA_COEFFICIENT**. Other attributes supported by the RSA public and private
key types (specifically, the flags indicating which functions the keys support)
may also be specified in the templates for the keys, or else are assigned
default initial values. Unlike the **CKM_RSA_PKCS_KEY_PAIR_GEN** mechanism, this
mechanism is guaranteed to generate p and q values, **CKA_PRIME_1** and
**CKA_PRIME_2** respectively, that meet the strong primes requirement of X9.31.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### PKCS #1 v1.5 RSA

The PKCS #1 v1.5 RSA mechanism, denoted **CKM_RSA_PKCS**, is a multi-purpose
mechanism based on the RSA public-key cryptosystem and the block formats
initially defined in PKCS #1 v1.5. It supports single-part encryption and
decryption; single-part signatures and verification with and without message
recovery; key wrapping and key unwrapping; and key encapsulation and key
decapsulation. This mechanism corresponds only to the part of PKCS #1 v1.5 that
involves RSA; it does not compute a message digest or a DigestInfo encoding as
specified for the md2withRSAEncryption and md5withRSAEncryption algorithms in
PKCS #1 v1.5 .

This mechanism does not have a parameter.

This mechanism can wrap and unwrap any secret key of appropriate length. Of
course, a particular token may not be able to wrap/unwrap every
appropriate-length secret key that it supports. For wrapping, the “input” to the
encryption operation is the value of the **CKA_VALUE** attribute of the key that
is wrapped; similarly for unwrapping. The mechanism does not wrap the key type
or any other information about the key, except the key length; the application
must convey these separately. In particular, the mechanism contributes only the
**CKA_CLASS** and **CKA_VALUE** (and **CKA_VALUE_LEN**, if the key has it)
attributes to the recovered key during unwrapping; other attributes must be
specified in the template.

When the mechanism is used in key encapsulation, the secret key is generated in
the C_EncapsulateKey function and then wrapped with RSA PKCS #1 v1.5.
C_DecapsulateKey is exactly equivalent to C_UnwrapKey for RSA PKCS.

Constraints on key types and the length of the data are summarized in the
following table. For encryption, decryption, signatures and signature
verification, the input and output data may begin at the same location in
memory. In the table, k is the length in bytes of the RSA modulus.

+--------------------+-----------------+--------------+---------------+---------------+
| Function           | Key type        | Input length | Output length | Comments      |
+====================+=================+:============:+:=============:+===============+
| C_Encrypt ^1^      | RSA public key  | ≤ k-11       | k             | block type 02 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_Decrypt ^1^      | RSA private key | k            | ≤ k-11        | block type 02 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_Sign ^1^         | RSA private key | ≤ k-11       | k             | block type 01 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_SignRecover ^1^  | RSA private key | ≤ k-11       | k             | block type 01 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_Verify ^1^       | RSA public key  | ≤ k-11, k^2^ | N/A           | block type 01 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_VerifyRecover ^1^| RSA public key  | k            | ≤ k-11        | block type 01 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_WrapKey          | RSA public key  | ≤ k-11       | k             | block type 02 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_UnwrapKey        | RSA private key | k            | ≤ k-11        | block type 02 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_EncapsulateKey   | RSA public key  | none         | ≤ k-11, k     | block type 02 |
+--------------------+-----------------+--------------+---------------+---------------+
| C_DecapsulateKey   | RSA private key | k            | ≤ k-11        | block type 02 |
+--------------------+-----------------+--------------+---------------+---------------+
table: PKCS #1 v1.5 RSA: Key And Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### PKCS #1 RSA OAEP mechanism parameters

#### CK_RSA_PKCS_MGF_TYPE
\  

**CK_RSA_PKCS_MGF_TYPE** is used to indicate the Mask Generation Function (MGF)
applied to a message block when formatting a message block for the PKCS #1 OAEP
encryption scheme or the PKCS #1 PSS signature scheme. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_RSA_PKCS_MGF_TYPE;
~~~

The following MGFs are defined in [PKCS #1]. The following table lists the
defined functions.

| Source Identifier | Value        |
|-------------------|--------------|
| CKG_MGF1_SHA1     | 0x00000001UL |
| CKG_MGF1_SHA224   | 0x00000005UL |
| CKG_MGF1_SHA256   | 0x00000002UL |
| CKG_MGF1_SHA384   | 0x00000003UL | 
| CKG_MGF1_SHA512   | 0x00000004UL |
| CKG_MGF1_SHA3_224 | 0x00000006UL |
| CKG_MGF1_SHA3_256 | 0x00000007UL |
| CKG_MGF1_SHA3_384 | 0x00000008UL |
| CKG_MGF1_SHA3_512 | 0x00000009UL |
table: PKCS #1 Mask Generation Functions

**CK_RSA_PKCS_MGF_TYPE_PTR** is a pointer to a **CK_RSA_PKCS_MGF_TYPE**.

#### CK_RSA_PKCS_OAEP_SOURCE_TYPE
\  

**CK_RSA_PKCS_OAEP_SOURCE_TYPE** is used to indicate the source of the encoding
parameter when formatting a message block for the PKCS #1 OAEP encryption
scheme. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_RSA_PKCS_OAEP_SOURCE_TYPE;
~~~

The following encoding parameter sources are defined in [PKCS #1]. The following
table lists the defined sources along with the corresponding data type for the
pSourceData field in the **CK_RSA_PKCS_OAEP_PARAMS** structure defined below.

| Source Identifier  | Value        |
|--------------------|--------------|
| CKZ_DATA_SPECIFIED | 0x00000001UL |
table: PKCS #1 RSA OAEP: Encoding parameter sources

**CK_RSA_PKCS_OAEP_SOURCE_TYPE_PTR** is a pointer to a **CK_RSA_PKCS_OAEP_SOURCE_TYPE**.

#### CK_RSA_PKCS_OAEP_PARAMS
\  

**CK_RSA_PKCS_OAEP_PARAMS** is a structure that provides the parameters to the
**CKM_RSA_PKCS_OAEP** mechanism. The structure is defined as follows:

~~~{.c}
typedef struct CK_RSA_PKCS_OAEP_PARAMS {
	CK_MECHANISM_TYPE	hashAlg;
	CK_RSA_PKCS_MGF_TYPE	mgf;
	CK_RSA_PKCS_OAEP_SOURCE_TYPE	source;
	CK_VOID_PTR	pSourceData;
	CK_ULONG	ulSourceDataLen;
}	CK_RSA_PKCS_OAEP_PARAMS;
~~~

The fields of the structure have the following meanings:

_hashAlg_
: mechanism ID of the message digest algorithm used to calculate the digest of
  the encoding parameter

_mgf_
: mask generation function to use on the encoded block

_source_
: must be **CKZ_DATA_SPECIFIED**

_pSourceData_
: pointer to the optional label L to be associated with the message; it must be
  NULL_PTR if the caller wants the default label (the empty string) to be used
  (as per [RFC 8017])

_ulSourceDataLen_
: length in bytes of the data pointed to by pSourceData; it must be 0 if the
  caller wants the default label (the empty string) to be used (as per [RFC
  8017])

**CK_RSA_PKCS_OAEP_PARAMS_PTR** is a pointer to a **CK_RSA_PKCS_OAEP_PARAMS**.

### PKCS #1 RSA OAEP

The PKCS #1 RSA OAEP mechanism, denoted **CKM_RSA_PKCS_OAEP**, is a
multi-purpose mechanism based on the RSA public-key cryptosystem and the OAEP
block format defined in [PKCS #1]. It supports single-part encryption and
decryption; key wrapping and key unwrapping; and key encapsulation and key
decapsulation.

It has a parameter, a **CK_RSA_PKCS_OAEP_PARAMS** structure.

This mechanism can wrap and unwrap any secret key of appropriate length. Of
course, a particular token may not be able to wrap/unwrap every
appropriate-length secret key that it supports. For wrapping, the “input” to the
encryption operation is the value of the **CKA_VALUE** attribute of the key that
is wrapped; similarly for unwrapping. The mechanism does not wrap the key type
or any other information about the key, except the key length; the application
must convey these separately. In particular, the mechanism contributes only the
**CKA_CLASS** and **CKA_VALUE** (and **CKA_VALUE_LEN**, if the key has it)
attributes to the recovered key during unwrapping; other attributes must be
specified in the template.

When the mechanism is used in key encapsulation, the secret key is generated in
the **C_EncapsulateKey** function and then wrapped with RSA OAEP.
**C_DecapsulateKey** is exactly equivalent to **C_UnwrapKey** for RSA OAEP.

Constraints on key types and the length of the data are summarized in the
following table. For encryption and decryption, the input and output data may
begin at the same location in memory. In the table, k is the length in bytes of
the RSA modulus, and _hLen_ is the output length of the message digest algorithm
specified by the _hashAlg_ field of the **CK_RSA_PKCS_OAEP_PARAMS** structure.

| Function         | Key type        | Input length | Output length |
|------------------|-----------------|:------------:|:-------------:|
| C_Encrypt ^1^    | RSA public key  | ≤ k-2-2hLen  | k             |
| C_Decrypt ^1^    | RSA private key | k            | ≤ k-2-2hLen   |
| C_WrapKey        | RSA public key  | ≤ k-2-2hLen  | k             |
| C_UnwrapKey      | RSA private key | k            | ≤ k-2-2hLen   |
| C_EncapsulateKey | RSA public key  | none         | ≤ k-2-2hLen,k |
| C_DecapsulateKey | RSA private key | k            | ≤ k-2-2hLen   |
table: PKCS #1 RSA OAEP: Key And Data Length

1 Single-part operations only.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### PKCS #1 RSA PSS mechanism parameters

#### CK_RSA_PKCS_PSS_PARAMS
\  

**CK_RSA_PKCS_PSS_PARAMS** is a structure that provides the parameters to the
**CKM_RSA_PKCS_PSS** mechanism. The structure is defined as follows:

~~~{.c}
typedef struct CK_RSA_PKCS_PSS_PARAMS {
	CK_MECHANISM_TYPE	hashAlg;
	CK_RSA_PKCS_MGF_TYPE	mgf;
	CK_ULONG	sLen;
}	CK_RSA_PKCS_PSS_PARAMS;
~~~

The fields of the structure have the following meanings:

_hashAlg_
: hash algorithm used in the PSS encoding; if the signature mechanism
  does not include message hashing, then this value must be the mechanism used
  by the application to generate the message hash; if the signature mechanism
  includes hashing, then this value must match the hash algorithm indicated by
  the signature mechanism

_mgf_
: mask generation function to use on the encoded block

_sLen_
: length, in bytes, of the salt value used in the PSS encoding; typical
  values are the length of the message hash and zero

**CK_RSA_PKCS_PSS_PARAMS_PTR** is a pointer to a **CK_RSA_PKCS_PSS_PARAMS**.

### PKCS #1 RSA PSS

The PKCS #1 RSA PSS mechanism, denoted **CKM_RSA_PKCS_PSS**, is a mechanism
based on the RSA public-key cryptosystem and the PSS block format defined in
[PKCS #1]. It supports single-part signature generation and verification without
message recovery. This mechanism corresponds only to the part of [PKCS #1] that
involves block formatting and RSA, given a hash value; it does not compute a
hash value on the message to be signed.

It has a parameter, a **CK_RSA_PKCS_PSS_PARAMS** structure. The _sLen_ field
must be less than or equal to _k*-2-hLen_ and _hLen_ is the length of the input
to the **C_Sign** or **C_Verify** function. _k*_ is the length in bytes of the
RSA modulus, except if the length in bits of the RSA modulus is one more than a
multiple of 8, in which case _k*_ is one less than the length in bytes of the
RSA modulus.

Constraints on key types and the length of the data are summarized in the
following table. In the table, _k_ is the length in bytes of the RSA.

| Function     | Key type        | Input length | Output length |
|--------------|-----------------|:------------:|:-------------:|
| C_Sign ^1^   | RSA private key | hLen         | k             |
| C_Verify ^1^ | RSA public key  | hLen, k      | N/A           |
table: PKCS #1 RSA PSS: Key And Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### ISO/IEC 9796 RSA

The ISO/IEC 9796 RSA mechanism, denoted **CKM_RSA_9796**, is a mechanism for
single-part signatures and verification with and without message recovery based
on the RSA public-key cryptosystem and the block formats defined in [ISO/IEC
9796] and its annex A.

This mechanism processes only byte strings, whereas ISO/IEC 9796 operates on bit
strings. Accordingly, the following transformations are performed:

* Data is converted between byte and bit string formats by interpreting the
  most-significant bit of the leading byte of the byte string as the leftmost
bit of the bit string, and the least-significant bit of the trailing byte of the
byte string as the rightmost bit of the bit string (this assumes the length in
bits of the data is a multiple of 8).
* A signature is converted from a bit string to a byte string by padding the bit
  string on the left with 0 to 7 zero bits so that the resulting length in bits
is a multiple of 8, and converting the resulting bit string as above; it is
converted from a byte string to a bit string by converting the byte string as
above, and removing bits from the left so that the resulting length in bits is
the same as that of the RSA modulus.

This mechanism does not have a parameter.

Constraints on key types and the length of input and output data are summarized
in the following table. In the table, _k_ is the length in bytes of the RSA
modulus.

| Function            | Key type        | Input length | Output length |
|---------------------|-----------------|:------------:|:-------------:|
| C_Sign ^1^          | RSA private key | ≤ ⌊k/2⌋      | k             |
| C_SignRecover ^1^   | RSA private key | ≤ ⌊k/2⌋      | k             |
| C_Verify ^1^        | RSA public key  | ≤ ⌊k/2⌋, k2  | N/A           |
| C_VerifyRecover ^1^ | RSA public key  | k            | ≤ ⌊k/2⌋       |
table: ISO/IEC 9796 RSA: Key And Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### X.509 (raw) RSA

The X.509 (raw) RSA mechanism, denoted **CKM_RSA_X_509**, is a multi-purpose
mechanism based on the RSA public-key cryptosystem. It supports single-part
encryption and decryption; single-part signatures and verification with and
without message recovery; key wrapping and key unwrapping; and key encapsulation
and key decapsulation. All these operations are based on so-called “raw” RSA, as
assumed in X.509.

“Raw” RSA as defined here encrypts a byte string by converting it to an integer,
most-significant byte first, applying “raw” RSA exponentiation, and converting
the result to a byte string, most-significant byte first. The input string,
considered as an integer, must be less than the modulus; the output string is
also less than the modulus.

This mechanism does not have a parameter.

This mechanism can wrap and unwrap any secret key of appropriate length. Of
course, a particular token may not be able to wrap/unwrap every
appropriate-length secret key that it supports. For wrapping, the “input” to the
encryption operation is the value of the **CKA_VALUE** attribute of the key that
is wrapped; similarly for unwrapping. The mechanism does not wrap the key type,
key length, or any other information about the key; the application must convey
these separately, and supply them when unwrapping the key.

This mechanism can encapsulate and decapsulate keys according to RSASVE defined
in [FIPS SP 800-56B].

For all operations other than encapsulate, X.509 does not specify how to perform
padding for RSA encryption. For this mechanism, padding should be performed by
prepending plaintext data with 0-valued bytes. In effect, to encrypt the
sequence of plaintext bytes b~1~ b~2~ … b~n~ (n ≤ _k_), Cryptoki forms
P=2^n-1^b~1~+2^n-2^b~2~+…+b~n~. This number must be less than the RSA modulus.
The _k_-byte ciphertext (_k_ is the length in bytes of the RSA modulus) is
produced by raising P to the RSA public exponent modulo the RSA modulus.
Decryption of a _k_-byte ciphertext C is accomplished by raising C to the RSA
private exponent modulo the RSA modulus, and returning the resulting value as a
sequence of exactly _k_ bytes.  If the resulting plaintext is to be used to
produce an unwrapped key, then however many bytes are specified in the template
for the length of the key are taken from the end of this sequence of bytes.

Technically, the above procedures may differ very slightly from certain details
of what is specified in X.509.

Executing cryptographic operations using this mechanism can result in the error
returns **CKR_DATA_INVALID** (if plaintext is supplied which has the same length
as the RSA modulus and is numerically at least as large as the modulus) and
**CKR_ENCRYPTED_DATA_INVALID** (if ciphertext is supplied which has the same
length as the RSA modulus and is numerically at least as large as the modulus).

Constraints on key types and the length of input and output data are summarized
in the following table. In the table, _k_ is the length in bytes of the RSA
modulus.

| Function            | Key type        | Input length | Output length |
|---------------------|-----------------|:------------:|:-------------:|
| C_Encrypt ^1^       | RSA public key  | ≤ _k_        | _k_           |
| C_Decrypt ^1^       | RSA private key | _k_          | _k_           |
| C_Sign ^1^          | RSA private key | ≤ _k_        | _k_           |
| C_SignRecover ^1^   | RSA private key | ≤ _k_        | _k_           |
| C_Verify ^1^        | RSA public key  | ≤ _k, k2_    | N/A           |
| C_VerifyRecover ^1^ | RSA public key  | _k_          | _k_           |
| C_WrapKey           | RSA public key  | ≤ _k_        | _k_           |
| C_UnwrapKey         | RSA private key | _k_          | ≤ _k_ (specified in template) |
| C_EncapsulateKey    | RSA public key  | none         | _k,k_         |
| C_DecapsulateKey    | RSA private key | _k_          | _k_           |
table: X.509 (Raw) RSA: Key And Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.  This mechanism is intended for compatibility with applications
that do not follow the [PKCS #1] or [ISO/IEC 9796] block formats.

### ANSI X9.31 RSA

The ANSI X9.31 RSA mechanism, denoted **CKM_RSA_X9_31**, is a mechanism for
single-part signatures and verification without message recovery based on the
RSA public-key cryptosystem and the block formats defined in [ANSI X9.31].

This mechanism applies the header and padding fields of the hash encapsulation.
The trailer field must be applied by the application.

This mechanism processes only byte strings, whereas [ANSI X9.31] operates on bit
strings. Accordingly, the following transformations are performed:

* Data is converted between byte and bit string formats by interpreting the
  most-significant bit of the leading byte of the byte string as the leftmost
  bit of the bit string, and the least-significant bit of the trailing byte of
  the byte string as the rightmost bit of the bit string (this assumes the
  length in bits of the data is a multiple of 8).
* A signature is converted from a bit string to a byte string by padding the bit
  string on the left with 0 to 7 zero bits so that the resulting length in bits
  is a multiple of 8, and converting the resulting bit string as above; it is
  converted from a byte string to a bit string by converting the byte string as
  above, and removing bits from the left so that the resulting length in bits is
  the same as that of the RSA modulus.

This mechanism does not have a parameter.

Constraints on key types and the length of input and output data are summarized
in the following table. In the table, k is the length in bytes of the RSA
modulus. For all operations, the k value must be at least 128 and a multiple of
32 as specified in [ANSI X9.31].

| Function     | Key type        | Input length | Output length |
|--------------|-----------------|:------------:|:-------------:|
| C_Sign ^1^   | RSA private key | ≤ _k-2_      | _k_           |
| C_Verify ^1^ | RSA public key  | ≤ _k-2, k2_  | N/A           |
table: ANSI X9.31 RSA: Key And Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### PKCS #1 v1.5 RSA signature with hashing

The PKCS #1 v1.5 RSA signature with hashing, denoted **CKM_**\<hash\>**\_RSA_PKCS**
where \<hash\> identifies a hash function as per [Table 45], performs single- and
multiple-part digital signatures and verification operations without message
recovery. The operations performed are as described initially in PKCS #1 v1.5
with the object identifier as per [Table 45], and as in the scheme
RSASSA-PKCS1-v1_5 in the current version of PKCS #1, where the underlying hash
function is the hash function as per [Table 45].

| Mechanism              | Hash function | Hash value length in bytes | Object identifier |
|---------------------------|---------------|--------|------------------------------------|
| CKM_MD2_RSA_PKCS          | MD2           | 16     | md2WithRSAEncryption               |
| CKM_MD5_RSA_PKCS          | MD5           | 16     | md5WithRSAEncryption               |
| CKM_RIPEMD128_RSA_PKCS    | RIPEMD-128    | 16     | ripemd128WithRSAEncryption         |
| CKM_RIPEMD160_RSA_PKCS    | RIPEMD-160    | 20     | ripemd160WithRSAEncryption         |
| CKM_SHA1_RSA_PKCS         | SHA-1         | 20     | sha1WithRSAEncryption              |
| CKM_SHA224_RSA_PKCS       | SHA-224       | 28     | sha224WithRSAEncryption            |
| CKM_SHA256_RSA_PKCS       | SHA-256       | 32     | sha256WithRSAEncryption            |
| CKM_SHA384_RSA_PKCS       | SHA-384       | 48     | sha384WithRSAEncryption            |
| CKM_SHA512_RSA_PKCS       | SHA-512       | 64     | sha512WithRSAEncryption            |
| CKM_SHA3_224_RSA_PKCS     | SHA3-224      | 28     | id-rsassa-pkcs1-v1-5-with-sha3-224 |
| CKM_SHA3_256_RSA_PKCS     | SHA3-256      | 32     | id-rsassa-pkcs1-v1-5-with-sha3-256 |
| CKM_SHA3_384_RSA_PKCS     | SHA3-384      | 48     | id-rsassa-pkcs1-v1-5-with-sha3-384 |
| CKM_SHA3_512_RSA_PKCS     | SHA3-512      | 64     | id-rsassa-pkcs1-v1-5-with-sha3-512 |
table: PKCS #1 v1.5 RSA signature with hashing: mechanisms and hash functions

Note: **CKM_MD2_RSA_PKCS**, **CKM_MD5_RSA_PKCS**, **CKM_RIPEMD128_RSA_PKCS** and
**CKM_RIPEMD160_RSA_PKCS** are deprecated with PKCS #11 3.20. New
implementations shall not use these mechanisms anymore.

None of these mechanisms has a parameter.

Constraints on key types and the length of the data for these mechanisms are
summarized in the following table. In the table, _k_ is the length in bytes of
the RSA modulus. For the PKCS #1 v1.5 RSA signature with hashing mechanisms, _k_
must be at least 11 bytes more than the length of the hash value as indicated in
[Table 45].

| Function | Key type        | Input length | Output length | Comments       |
|----------|-----------------|:------------:|:-------------:|----------------|
| C_Sign   | RSA private key | any          | _k_           | block type 01  |
| C_Verify | RSA public key  | any, _k^2^_  | N/A           | block type 01  |
table: PKCS #1 v1.5 RSA Signatures with Various Hash Functions: Key And Data Length

^2^ Data length, signature length.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### PKCS #1 RSA PSS signature with hashing

The PKCS #1 RSA PSS signature with hashing, denoted
**CKM_**\<hash\>**\_RSA_PKCS_PSS** where \<hash\> identifies a hash function as per
[Table 47], performs single- and multiple-part digital signatures and
verification operations without message recovery. The operations performed are
as described in [PKCS #1] with the object identifier id-RSASSA-PSS, i.e., as in
the scheme RSASSA-PSS in [PKCS #1] where the underlying hash function is the
hash function as per [Table 47].

| Mechanism | Hash function | Hash value length in bytes |
|-----------------------------|------------|-------------|
| CKM_SHA1_RSA_PKCS_PSS       | SHA-1      | 20          |
| CKM_SHA224_RSA_PKCS_PSS     | SHA-224    | 28          |
| CKM_SHA256_RSA_PKCS_PSS     | SHA-256    | 32          |
| CKM_SHA384_RSA_PKCS_PSS     | SHA-384    | 48          |
| CKM_SHA512_RSA_PKCS_PSS     | SHA-512    | 64          |
| CKM_SHA3_224_RSA_PKCS_PSS   | SHA3-224   | 28          |
| CKM_SHA3_256_RSA_PKCS_PSS   | SHA3-256   | 32          |
| CKM_SHA3_384_RSA_PKCS_PSS   | SHA3-384   | 48          |
| CKM_SHA3_512_RSA_PKCS_PSS   | SHA3-512   | 64          |
table: PKCS #1 RSA PSS signature with hashing: mechanisms and hash functions

The mechanisms have a parameter, a **CK_RSA_PKCS_PSS_PARAMS** structure. The
_sLen_ field must be less than or equal to _k\*-2-hLen_ where _hLen_ is the
length in bytes of the hash value as indicated in [Table 47]. _k\*_ is the length
in bytes of the RSA modulus, except if the length in bits of the RSA modulus is
one more than a multiple of 8, in which case _k\*_ is one less than the length in
bytes of the RSA modulus.

Constraints on key types and the length of the data are summarized in the
following table. In the table, _k_ is the length in bytes of the RSA modulus.

| Function | Key type        | Input length | Output length |
|----------|-----------------|:------------:|:-------------:|
| C_Sign   | RSA private key | any          | _k_           |
| C_Verify | RSA public key  | any, _k^2^_  | N/A           |
table: PKCS #1 RSA PSS Signatures with Various Hash Functions: Key And Data Length

^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### ANSI X9.31 RSA signature with SHA-1

The ANSI X9.31 RSA signature with SHA-1 mechanism, denoted
**CKM_SHA1_RSA_X9_31**, performs single- and multiple-part digital signatures
and verification operations without message recovery. The operations performed
are as described in [ANSI X9.31].

This mechanism does not have a parameter.

Constraints on key types and the length of the data for these mechanisms are
summarized in the following table. In the table, _k_ is the length in bytes of
the RSA modulus. For all operations, the _k_ value must be at least 128 and a
multiple of 32 as specified in [ANSI X9.31].

| Function | Key type        | Input length | Output length |
|----------|-----------------|:------------:|:-------------:|
| C_Sign   | RSA private key | any          | _k_           |
| C_Verify | RSA public key  | any, _k^2^_  | N/A           |
table: ANSI X9.31 RSA Signatures with SHA-1: Key And Data Length

^2^ Data length, signature length.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### TPM 1.1b and TPM 1.2 PKCS #1 v1.5 RSA

The TPM 1.1b and TPM 1.2 PKCS #1 v1.5 RSA mechanism, denoted
**CKM_RSA_PKCS_TPM_1_1**, is a multi-use mechanism based on the RSA public-key
cryptosystem and the block formats initially defined in PKCS #1 v1.5, with
additional formatting rules defined in TCPA TPM Specification Version 1.1b.
Additional formatting rules remained the same in TCG TPM Specification 1.2 The
mechanism supports single-part encryption and decryption; key wrapping; and key
unwrapping. 

This mechanism does not have a parameter. It differs from the standard PKCS #1
v1.5 RSA encryption mechanism in that the plaintext is wrapped in a
TCPA_BOUND_DATA (TPM_BOUND_DATA for TPM 1.2) structure before being submitted to
the PKCS #1 v1.5 encryption process. On encryption, the version field of the
TCPA_BOUND_DATA (TPM_BOUND_DATA for TPM 1.2) structure must contain 0x01, 0x01,
0x00, 0x00. On decryption, any structure of the form 0x01, 0x01, 0xXX, 0xYY may
be accepted.

This mechanism can wrap and unwrap any secret key of appropriate length. Of
course, a particular token may not be able to wrap/unwrap every
appropriate-length secret key that it supports. For wrapping, the “input” to the
encryption operation is the value of the **CKA_VALUE** attribute of the key that
is wrapped; similarly for unwrapping. The mechanism does not wrap the key type
or any other information about the key, except the key length; the application
must convey these separately. In particular, the mechanism contributes only the
**CKA_CLASS** and **CKA_VALUE** (and **CKA_VALUE_LEN**, if the key has it)
attributes to the recovered key during unwrapping; other attributes must be
specified in the template.

Constraints on key types and the length of the data are summarized in the
following table. For encryption and decryption, the input and output data may
begin at the same location in memory. In the table, _k_ is the length in bytes
of the RSA modulus.

| Function      | Key type        | Input length | Output length |
|---------------|-----------------|:------------:|:-------------:|
| C_Encrypt ^1^ | RSA public key  | ≤ _k_-11-5   | _k_           |
| C_Decrypt ^1^ | RSA private key | _k_          | ≤ _k_-11-5    |
| C_WrapKey     | RSA public key  | ≤ _k_-11-5   | _k_           |
| C_UnwrapKey   | RSA private key | _k_          | ≤ _k_-11-5    |
table: TPM 1.1b and TPM 1.2 PKCS #1 v1.5 RSA: Key And Data Length

^1^ Single-part operations only.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the CK_MECHANISM_INFO structure specify the supported range of RSA modulus sizes, in bits.

### TPM 1.1b and TPM 1.2 PKCS #1 RSA OAEP

The TPM 1.1b and TPM 1.2 PKCS #1 RSA OAEP mechanism, denoted
**CKM_RSA_PKCS_OAEP_TPM_1_1**, is a multi-purpose mechanism based on the RSA
public-key cryptosystem and the OAEP block format defined in PKCS #1, with
additional formatting defined in TCPA TPM Specification Version 1.1b. Additional
formatting rules remained the same in TCG TPM Specification 1.2. The mechanism
supports single-part encryption and decryption; key wrapping; and key
unwrapping. 

This mechanism does not have a parameter. It differs from the standard PKCS #1
OAEP RSA encryption mechanism in that the plaintext is wrapped in a
TCPA_BOUND_DATA (TPM_BOUND_DATA for TPM 1.2) structure before being submitted to
the encryption process and that all of the values of the parameters that are
passed to a standard **CKM_RSA_PKCS_OAEP** operation are fixed. On encryption,
the version field of the TCPA_BOUND_DATA (TPM_BOUND_DATA for TPM 1.2) structure
must contain 0x01, 0x01, 0x00, 0x00. On decryption, any structure of the form
0x01, 0x01, 0xXX, 0xYY may be accepted.

This mechanism can wrap and unwrap any secret key of appropriate length. Of
course, a particular token may not be able to wrap/unwrap every
appropriate-length secret key that it supports. For wrapping, the “input” to the
encryption operation is the value of the **CKA_VALUE** attribute of the key that
is wrapped; similarly for unwrapping. The mechanism does not wrap the key type
or any other information about the key, except the key length; the application
must convey these separately. In particular, the mechanism contributes only the
**CKA_CLASS** and **CKA_VALUE** (and **CKA_VALUE_LEN**, if the key has it)
attributes to the recovered key during unwrapping; other attributes must be
specified in the template.

Constraints on key types and the length of the data are summarized in the
following table. For encryption and decryption, the input and output data may
begin at the same location in memory. In the table, _k_ is the length in bytes
of the RSA modulus.

| Function      | Key type        | Input length | Output length |
|---------------|-----------------|:------------:|:-------------:|
| C_Encrypt ^1^ | RSA public key  | ≤ _k_-2-40-5 | _k_           |
| C_Decrypt ^1^ | RSA private key | k            | ≤ _k_-2-40-5  |
| C_WrapKey     | RSA public key  | ≤ _k_-2-40-5 | _k_           |
| C_UnwrapKey   | RSA private key | _k_          | ≤ _k_-2-40-5  |
Table 51, TPM 1.1b and TPM 1.2 PKCS #1 RSA OAEP: Key And Data Length

^1^ Single-part operations only.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RSA modulus
sizes, in bits.

### RSA AES KEY WRAP

The RSA AES key wrap mechanism, denoted **CKM_RSA_AES_KEY_WRAP**, is a mechanism
based on the RSA public-key cryptosystem and the AES key wrap mechanism. It
supports single-part key wrapping; and key unwrapping.

It has a parameter, a **CK_RSA_AES_KEY_WRAP_PARAMS** structure. 

The mechanism can wrap and unwrap a target asymmetric key of any length and type
using an RSA key. 

* A temporary AES key is used for wrapping the target key using
  **CKM_AES_KEY_WRAP_KWP** mechanism. 
* The temporary AES key is wrapped with the wrapping RSA key using
  **CKM_RSA_PKCS_OAEP** mechanism.

For wrapping, the mechanism -

* Generates a temporary random AES key of _ulAESKeyBits_ length. This key is
  not accessible to the user - no handle is returned.
* Wraps the AES key with the wrapping RSA key using **CKM_RSA_PKCS_OAEP** with
  parameters of _OAEPParams_.
* Wraps the target key with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key 
* Concatenates two wrapped keys and outputs the concatenated blob. The first is
  the wrapped AES key, and the second is the wrapped target key.

The private target key will be encoded as defined in section [6.7]. 

The use of Attributes in the PrivateKeyInfo structure is OPTIONAL. In case of
conflicts between the object attribute template, and Attributes in the
PrivateKeyInfo structure, an error should be thrown.

For unwrapping, the mechanism - 

* Splits the input into two parts. The first is the wrapped AES key, and the
  second is the wrapped target key. The length of the first part is equal to the
  length of the unwrapping RSA key.
* Un-wraps the temporary AES key from the first part with the private RSA key
  using **CKM_RSA_PKCS_OAEP** with parameters of _OAEPParams_.
* Un-wraps the target key from the second part with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key.
* Returns the handle to the newly unwrapped target key.

+----------------------------+---------------------------------------------------+
|                            |Functions                                          |
|                            +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                  | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                            |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                            | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+============================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_RSA_AES_KEY_WRAP       |     |     |      |     |       |  ✓  |     |      |
+----------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: CKM_RSA_AES_KEY_WRAP Mechanisms vs. Functions

### RSA AES KEY WRAP mechanism parameters

#### CK_RSA_AES_KEY_WRAP_PARAMS
\  

**CK_RSA_AES_KEY_WRAP_PARAMS** is a structure that provides the parameters to
the **CKM_RSA_AES_KEY_WRAP** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_RSA_AES_KEY_WRAP_PARAMS {
	CK_ULONG	ulAESKeyBits;
	CK_RSA_PKCS_OAEP_PARAMS_PTR	pOAEPParams;
}	CK_RSA_AES_KEY_WRAP_PARAMS;
~~~

The fields of the structure have the following meanings:

_ulAESKeyBits_
: length of the temporary AES key in bits. Can be only 128, 192
  or 256.

_pOAEPParams_
: pointer to the parameters of the temporary AES key
  wrapping. See also the description of PKCS #1 RSA OAEP mechanism parameters.

**CK_RSA_AES_KEY_WRAP_PARAMS_PTR** is a pointer to a
**CK_RSA_AES_KEY_WRAP_PARAMS**.

### FIPS 186-4

When *CKM_RSA_PKCS* is operated in FIPS mode, the length of the modulus SHALL
only be 1024, 2048, or 3072 bits.
