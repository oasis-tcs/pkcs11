## SLH-DSA

SLH-DSA and HashSLH-DSA are mechanisms for signatures and verification,
following the digital signature algorithm defined in [FIPS 205].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SLH_DSA_KEY_PAIR_GEN             |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SLH_DSA                          |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA                     |     | ✓^2^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA224              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA256              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA384              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA512              |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA3_224            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA3_256            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA3_384            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHA3_512            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHAKE128            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_SLH_DSA_SHAKE256            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SLH-DSA Mechanisms vs. Functions

^1^ Verification is only for single part verifications or multipart
verifications when the C_VerifySignatureInit interface is used

^2^ Single-part operations only.

### Definitions

This section defines the key type **CKK_SLH_DSA** for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of all SLH-DSA key objects.

Mechanisms:

- CKM_SLH_DSA_KEY_PAIR_GEN
- CKM_SLH_DSA
- CKM_HASH_SLH_DSA
- CKM_HASH_SLH_DSA_SHA224
- CKM_HASH_SLH_DSA_SHA256
- CKM_HASH_SLH_DSA_SHA384
- CKM_HASH_SLH_DSA_SHA512
- CKM_HASH_SLH_DSA_SHA3_224
- CKM_HASH_SLH_DSA_SHA3_256
- CKM_HASH_SLH_DSA_SHA3_384
- CKM_HASH_SLH_DSA_SHA3_512
- CKM_HASH_SLH_DSA_SHAKE128
- CKM_HASH_SLH_DSA_SHAKE256

**CK_SLH_DSA_PARAMETER_SET_TYPE** is used to indicate which SLH-DSA parameter
set the keys belong to.

~~~{.c}
typedef CK_ULONG CK_SLH_DSA_PARAMETER_SET_TYPE;
~~~

Parameter set types:

- CKP_SLH_DSA_SHA2_128S
- CKP_SLH_DSA_SHAKE_128S
- CKP_SLH_DSA_SHA2_128F
- CKP_SLH_DSA_SHAKE_128F
- CKP_SLH_DSA_SHA2_192S
- CKP_SLH_DSA_SHAKE_192S
- CKP_SLH_DSA_SHA2_192F
- CKP_SLH_DSA_SHAKE_192F
- CKP_SLH_DSA_SHA2_256S
- CKP_SLH_DSA_SHAKE_256S
- CKP_SLH_DSA_SHA2_256F
- CKP_SLH_DSA_SHAKE_256S
            
### SLH-DSA public key objects

SLH-DSA public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_SLH_DSA**) hold SLH-DSA public keys.

The following table defines the SLH-DSA public key object attributes, in
addition to the common attributes defined for this object class:

| Attribute               | Data Type                     | Meaning          |
|-------------------------|-------------------------------|------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_SLH_DSA_PARAMETER_SET_TYPE | SLH-DSA parameter set |
| CKA_VALUE ^1,4^         | Byte array                    | Public key as defined in [FIPS 205] |
table: SLH-DSA Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by NIST. The parameter set will select the security level and public
key sizes. Tokens may support a subset of the defined parameter sets.

The following is a sample template for creating an SLH-DSA public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_SLH_DSA;
CK_UTF8CHAR label[] = “A SLH-DSA public key object”;
CK_SLH_DSA_PARAMETER_SET_TYPE param_set = CKP_SLH_DSA_SHAKE_128S;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PARAMETER_SET, &param_set, sizeof(param_set)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### SLH-DSA private key objects

SLH-DSA private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_SLH_DSA**) hold SLH-DSA private keys.

The following table defines the SLH-DSA private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                 | Data Type                     | Meaning        |
|---------------------------|-------------------------------|----------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_SLH_DSA_PARAMETER_SET_TYPE | SLH-DSA parameter set |
| CKA_VALUE ^1,4,6,7^       | Byte array                    | Private key as defined in [FIPS 205] |
table: SLH-DSA Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by NIST. The parameter set will select the security level and private
key sizes. Tokens may support a subset of the defined parameter sets.

Note that when generating a SLH-DSA private key, the parameter set is not
specified in the key’s template. This is because SLH-DSA private keys are only
generated as part of a SLH-DSA key pair, and the parameter set for the pair is
specified in the template for the SLH-DSA public key.

The following is a sample template for creating an SLH-DSA private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_SLH_DSA;
CK_UTF8CHAR label[] = “A SLH-DSA private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_SLH_DSA_PARAMETER_SET_TYPE param_set = CKP_SLH_DSA_SHAKE_128S;
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
  {CKA_PARAMETER_SET, &param_set, sizeof(param_set)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### SLH-DSA key pair generation

The SLH-DSA key pair generation mechanism, denoted **CKM_SLH_DSA_KEY_PAIR_GEN**,
is a key pair generation mechanism as defined in Algorithm 21 of [FIPS 205].

It does not have a parameter.

The mechanism generates SLH-DSA public/private key pairs with a parameter set,
as specified in the **CKA_PARAMETER_SET** attribute of the template for the
public key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PARAMETER_SET**, and **CKA_VALUE** attributes to the new private key;
other attributes required by the SLH-DSA public and private key types must be
specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of SLH-DSA public
key in bytes.
            
### SLH-DSA Signature

The SLH-DSA signature mechanism, denoted **CKM_SLH_DSA**, is a mechanism for
generating and verifying SLH-DSA signatures as defined in Algorithm 22 slh_sign
and Algorithm 24 slh_verify of [FIPS 205], using the hash function determined
from **CK_SLH_DSA_PARAMETER_SET_TYPE** and section 11 of [FIPS 205]. The data
passed in is the message M. Verification is only for single part verifications
or multipart verifications when the **C_VerifySignatureInit** interface is used.

It has an optional parameter **CK_SIGN_ADDITIONAL_CONTEXT** (see section
6.67.1). If no parameter is supplied ulContextLen will be zero and pContext will
be NULL. On signing, if hedgeVariant is set to **CKH_HEDGE_PREFERRED**, the
token may create either a hedged signature or a deterministic signature as
specified in [FIPS 205]. If hedgeVariant is set to **CKH_HEDGE_REQUIRED**, the
token must produce a hedged signature or fail. If the hedgeVariant is set to
**CKH_DETERMINISTIC_REQUIRED**, the token must produce a deterministic signature
or fail. On verification the hedgeVariant parameter is ignored.

Constraints on key types and the length of the data are summarized in the
following table. In the table, _k_ is the length in bytes of the SLH-DSA
signature.

| Function          | Key type            | Input length | Output length |
|-------------------|---------------------|--------------|---------------|
| C_Sign            | SLH-DSA Private Key | any          | k             |
| C_Verify ^1^      | SLH-DSA Public Key  | any, k       | N/A           |
| C_VerifySignature | SLH-DSA Public Key  | any, k       | N/A           |
table: SLH-DSA: Key and Data Length

^1^ Single-part operations only.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of SLH-DSA public
keys in bytes.
            
### HashSLH-DSA Signature

The HashSLH-DSA signature mechanism, denoted **CKM_HASH_SLH_DSA**, is a single
part mechanism for generating and verifying pre-hash SLH-DSA signatures defined
in Algorithm 23 hash_slh_sign of [FIPS 205], using the hash function specified
in **CK_HASH_SIGN_ADDITIONAL_CONTEXT**. The data passed in is an already hashed
message PHM.

It has a parameter **CK_HASH_SIGN_ADDITIONAL_CONTEXT** (see section [6.67.1]).
On signing, if hedgeVariant is set to **CKH_HEDGE_PREFERRED**, the token may
create either a hedged signature or a deterministic signature as specified in
[FIPS 205]. If hedgeVariant is set to **CKH_HEDGE_REQUIRED**, the token must
produce a hedged signature or fail. If the hedgeVariant is set to
**CKH_DETERMINISTIC_REQUIRED**, the token must produce a deterministic signature
or fail. On verification the hedgeVariant parameter is ignored.

Constraints on key types and the length of the data are summarized in the
following table. In the table, _k_ is the length in bytes of the SLH-DSA
signature.

| Function     | Key type            | Input length   | Output length |
|--------------|---------------------|----------------|---------------|
| C_Sign ^1^   | SLH-DSA Private Key | Length of hash | k             |
| C_Verify ^1^ | SLH-DSA Public Key  | any, k         | N/A           |
table: HashSLH-DSA: Key and Data Length

^1^ Single-part operations only.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of SLH-DSA public
keys in bytes.
            
### HashSLH-DSA Signature with hashing

The HashSLH-DSA with hashing mechanism, denoted **CKM_HASH_SLH_DSA_{hash}**
where {hash} identifies a hash function as per Table 1, is a mechanism for
single- and multiple-part signatures and verification for HashSLH-DSA. This
mechanism computes the entire HashSLH-DSA specification, including the hashing
on token. The data passed in is the message M.

| Mechanism                 | Hash function |
|---------------------------|---------------|
| CKM_HASH_SLH_DSA_SHA224   | SHA-224       |
| CKM_HASH_SLH_DSA_SHA256   | SHA-256       |
| CKM_HASH_SLH_DSA_SHA384   | SHA-384       |
| CKM_HASH_SLH_DSA_SHA512   | SHA-512       |
| CKM_HASH_SLH_DSA_SHA3_224 | SHA3-224      |
| CKM_HASH_SLH_DSA_SHA3_256 | SHA3-256      |
| CKM_HASH_SLH_DSA_SHA3_384 | SHA3-384      |
| CKM_HASH_SLH_DSA_SHA3_512 | SHA3-512      |
| CKM_HASH_SLH_DSA_SHAKE128 | SHAKE128      |
| CKM_HASH_SLH_DSA_SHAKE256 | SHAKE256      |
Table 1, HashSLH-DSA with hashing: mechanisms and hash functions

These mechanisms have an optional parameter **CK_SIGN_ADDITIONAL_CONTEXT**. If
no parameter is supplied the hedgeVariant will be **CKH_HEDGE_PREFERRED**,
ulContextLen will be zero and pContext will be NULL. On signing, if hedgeVariant
is set to **CKH_HEDGE_PREFERRED**, the token may create either a hedged
signature or a deterministic signature as specified in [FIPS 205]. If
hedgeVariant is set to **CKH_HEDGE_REQUIRED**, the token must produce a hedged
signature or fail. If the hedgeVariant is set to **CKH_DETERMINISTIC_REQUIRED**,
the token must produce a deterministic signature or fail. On verification the
hedgeVariant parameter is ignored.

Constraints on key types and the length of the data are summarized in the
following table. In the table, k is the length in bytes of the SLH-DSA
signature.

| Function          | Key type            | Input length | Output length |
|-------------------|---------------------|--------------|---------------|
| C_Sign            | SLH-DSA Private Key | any          | k             |
| C_Verify          | SLH-DSA Public Key  | any, k       | N/A           |
| C_VerifySignature | SLH-DSA Public Key  | any, k       | N/A           |
table: Hash SLH-DSA with hashing: Key and Data Length

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of SLH-DSA public
keys in bytes.
