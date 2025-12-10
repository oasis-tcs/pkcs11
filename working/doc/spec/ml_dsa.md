## ML-DSA

ML-DSA and HashML-DSA are mechanisms for signatures and verification, following
the digital signature algorithm defined in [FIPS 204].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_ML_DSA_KEY_PAIR_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ML_DSA                           |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ML_DSA_EXTERNAL_MU_GEN           |     |     |      |  ✓  |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ML_DSA_EXTERNAL_MU               |     | ✓^2^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA                      |     | ✓^2^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA224               |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA256               |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA384               |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA512               |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA3_224             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA3_256             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA3_384             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHA3_512             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHAKE128             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HASH_ML_DSA_SHAKE256             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: ML-DSA Mechanisms vs. Functions

^1^ Verification is only for single part verifications or multipart
verifications when the **C_VerifySignatureInit** interface is used

^2^ Single-part operations only

### Definitions

This section defines the key type **CKK_ML_DSA** for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of all ML-DSA key objects.

Mechanisms:

- CKM_ML_DSA_KEY_PAIR_GEN
- CKM_ML_DSA
- CKM_HASH_ML_DSA
- CKM_HASH_ML_DSA_SHA224
- CKM_HASH_ML_DSA_SHA256
- CKM_HASH_ML_DSA_SHA384
- CKM_HASH_ML_DSA_SHA512
- CKM_HASH_ML_DSA_SHA3_224
- CKM_HASH_ML_DSA_SHA3_256
- CKM_HASH_ML_DSA_SHA3_384
- CKM_HASH_ML_DSA_SHA3_512
- CKM_HASH_ML_DSA_SHAKE128
- CKM_HASH_ML_DSA_SHAKE256
- CKM_ML_DSA_EXTERNAL_MU_GEN
- CKM_ML_DSA_EXTERNAL_MU

**CK_ML_DSA_PARAMETER_SET_TYPE** is used to indicate which ML-DSA parameter set
the keys belong to.

~~~{.c}
typedef CK_ULONG CK_ML_DSA_PARAMETER_SET_TYPE;
~~~

Parameter set types:

- CKP_ML_DSA_44
- CKP_ML_DSA_65
- CKP_ML_DSA_87

**CK_HEDGE_TYPE** is used to indicate how hedge or deterministic signature
variants are handled.

~~~{.c}
typedef CK_ULONG CK_HEDGE_TYPE;
~~~

Hedge types:

- CKH_HEDGE_PREFERRED
- CKH_HEDGE_REQUIRED
- CKH_DETERMINISTIC_REQUIRED

**CK_SIGN_ADDITIONAL_CONTEXT** is used in the mechanism parameters to supply a
NIST defined context string in signature scheme.

~~~{.c}
typedef struct CK_SIGN_ADDITIONAL_CONTEXT {
  CK_HEDGE_TYPE  hedgeVariant;
  CK_BYTE_PTR    pContext;
  CK_ULONG       ulContextLen;
} CK_SIGN_ADDITIONAL_CONTEXT;
~~~

**CK_HASH_SIGN_ADDITIONAL_CONTEXT** is used in the mechanism parameters to
supply a NIST defined context string in signature scheme and the hash algorithm.

~~~{.c}
typedef struct CK_HASH_SIGN_ADDITIONAL_CONTEXT {
  CK_HEDGE_TYPE      hedgeVariant;
  CK_BYTE_PTR        pContext;
  CK_ULONG           ulContextLen;
  CK_MECHANISM_TYPE  hash;
} CK_HASH_SIGN_ADDITIONAL_CONTEXT;
~~~

**CK_MU_GEN_PARAMS** is used in the mechanisum parameters to supply a key handle 
or pre computed TR and a context for the generation of an External Mu for pure ML-DSA

~~~{.c}
typedef struct CK_MU_GEN_PARAMS {
  CK_OBJECT_HANDLE hKey, //public or private.
  CK_BYTE_PTR         pTR; //pre computed TR from public key 
  CK_ULONG            ulTRLen;
  CK_BYTE_PTR         pctx;
  CK_ULONG            ulctxLen;
} CK_Mu_GEN_PARAMS;
~~~

### ML-DSA public key objects

ML-DSA public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_ML_DSA**) hold ML-DSA public keys.

The following table defines the ML-DSA public key object attributes, in addition
to the common attributes defined for this object class:

| Attribute               | Data type  | Meaning                         |
|-------------------------|------------|---------------------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_ML_DSA_PARAMETER_SET_TYPE | ML-DSA parameter set |
| CKA_VALUE ^1,4^         | Byte array | Public key as defined in [FIPS 204] |
table: ML-DSA Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by NIST. The parameter set will select the security level and public
key sizes. Tokens may support a subset of the defined parameter sets.

The following is a sample template for creating an ML-DSA public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_ML_DSA;
CK_UTF8CHAR label[] = “A ML-DSA public key object”;
CK_ML_DSA_PARAMETER_SET_TYPE param_set = CKP_ML_DSA_44;
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

### ML-DSA private key objects

ML-DSA private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_ML_DSA**) hold ML-DSA private keys.

The following table defines the ML-DSA private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                 | Data type  | Meaning                      |
|---------------------------|------------|------------------------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_ML_DSA_PARAMETER_SET_TYPE | ML-DSA parameter set |
| CKA_SEED ^4,6,7^          | Byte array | Seed value (𝜉) as defined in ML-DSA.Keygen in [FIPS 204] |
| CKA_VALUE ^1,4,6,7^       | Byte array | Private key (sk) as defined in ML-DSA.Keygen-internal in [FIPS 204] |
table: ML-DSA Private Key Object Attributes

- Refer to Table 13 for footnotes

At least one of **CKA_SEED** and **CKA_VALUE** must be specified on
**C_CreateObject**. Tokens may reject creation requests that only specify one of
these values. For highest compatibility applications should set both.

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by NIST. The parameter set will select the security level and private
key sizes. Tokens may support a subset of the defined parameter sets.

Note that when generating a ML-DSA private key, the parameter set is not
specified in the key’s template. This is because ML-DSA private keys are only
generated as part of a ML-DSA key pair, and the parameter set for the pair is
specified in the template for the ML-DSA public key.

The following is a sample template for creating an ML-DSA private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_ML_DSA;
CK_UTF8CHAR label[] = “A ML-DSA private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_ML_DSA_PARAMETER_SET_TYPE param_set = CKP_ML_DSA_44;
CK_BYTE seed[] = {...};
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
  {CKA_SEED, seed, sizeof(seed)}
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### ML-DSA key pair generation

The ML-DSA key pair generation mechanism, denoted **CKM_ML_DSA_KEY_PAIR_GEN**,
is a key pair generation mechanism using ML-DSA.KeyGen() as defined in section
5.1 of [FIPS 204].

It does not have a parameter.

The mechanism generates ML-DSA public/private key pairs with a parameter set, as
specified in the **CKA_PARAMETER_SET** attribute of the template for the public
key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PARAMETER_SET**, **CKA_SEED** and **CKA_VALUE** attributes to the new
private key; other attributes required by the ML-DSA public and private key
types must be specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-DSA public key
in bytes.

### ML-DSA Signature

The ML-DSA signature mechanism, denoted **CKM_ML_DSA**, is a mechanism for
generating and verifying ML-DSA signatures as defined in sections 5.2 and 5.3 of
[FIPS 204], Algorithm 2 ML-DSA.Sign and Algorithm 3 ML-DSA.Verify, using
SHAKE256 as hash function. The data passed in is the message M.

It has an optional parameter **CK_SIGN_ADDITIONAL_CONTEXT**. If no parameter is
supplied the _hedgeVariant_ will be **CKH_HEDGE_PREFERRED**, _ulContextLen_ will
be zero and _pContext_ will be NULL. On signing, if _hedgeVariant_ is set to
**CKH_HEDGE_PREFERRED**, the token may create either a hedged signature or a
deterministic signature as specified in [FIPS 204]. If _hedgeVariant_ is set to
**CKH_HEDGE_REQUIRED**, the token must produce a hedged signature or fail. If
the _hedgeVariant_ is set to **CKH_DETERMINISTIC_REQUIRED**, the token must
produce a deterministic signature or fail. On verification the _hedgeVariant_
parameter is ignored.

Constraints on key types and the length of the data are summarized in the
following table. In the table, k is the length in bytes of the ML-DSA signature.


| Function          | Key type            | Input Length | Output Length |
|-------------------|---------------------|--------------|---------------|
| C_Sign            | ML-DSA Private Key  | any          | k             |
| C_Verify ^1^      | ML-DSA Public Key   | any, k       | N/A           |
| C_VerifySignature | ML-DSA Public Key   | any, k       | N/A           |
table: ML-DSA: Key and Data Length

^1^ Single-part operations only.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-DSA public
keys in bytes.

### HashML-DSA Signature

The HashML-DSA signature mechanism, denoted **CKM_HASH_ML_DSA** is a single part
mechanism for generating and verifying pre-hash ML-DSA signatures as defined in
section [5.4] of [FIPS 204], Algorithm 4 HashML-DSA.Sign and Algorithm 5
HashML-DSA.Verify, using the hash function specified in
**CK_HASH_SIGN_ADDITIONAL_CONTEXT**. The data passed in is an already hashed
message PHM.

It has a parameter **CK_HASH_SIGN_ADDITIONAL_CONTEXT**. On signing, if
hedgeVariant is set to **CKH_HEDGE_PREFERRED**, the token may create either a
hedged signature or a deterministic signature as specified in [FIPS 204]. If
hedgeVariant is set to **CKH_HEDGE_REQUIRED**, the token must produce a hedged
signature or fail. If the hedgeVariant is set to **CKH_DETERMINISTIC_REQUIRED**,
the token must produce a deterministic signature or fail. On verification the
hedgeVariant parameter is ignored.

Constraints on key types and the length of the data are summarized in the
following table. In the table, k is the length in bytes of the ML-DSA signature.

| Function        | Key type            | Input Length   | Output Length |
|-----------------|---------------------|----------------|---------------|
| C_Sign ^1^      | ML-DSA Private Key  | Length of hash | k             |
| C_Verify ^1^    | ML-DSA Public Key   | any, k         | N/A           |
table: HashML-DSA: Key and Data Length

^1^ Single-part operations only.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-DSA public
keys in bytes.

### HashML-DSA Signature with hashing

The HashML-DSA with hashing mechanism, denoted **CKM_HASH_ML_DSA_<hash>** where
<hash> identifies a hash function as per [Table 1], is a mechanism for single-
and multiple-part signatures and verification for pre-hash ML-DSA signatures as
defined in section [5.4] of [FIPS 204], Algorithm 4 HashML-DSA.Sign and
Algorithm 5 HashML-DSA.Verify. This mechanism computes the entire HashML-DSA
specification, including the hashing on token. The data passed in is the message
M.

| Mechanism                | Hash function |
|--------------------------|---------------|
| CKM_HASH_ML_DSA_SHA224   | SHA-224       |
| CKM_HASH_ML_DSA_SHA256   | SHA-256       |
| CKM_HASH_ML_DSA_SHA384   | SHA-384       |
| CKM_HASH_ML_DSA_SHA512   | SHA-512       |
| CKM_HASH_ML_DSA_SHA3_224 | SHA3-224      |
| CKM_HASH_ML_DSA_SHA3_256 | SHA3-256      |
| CKM_HASH_ML_DSA_SHA3_384 | SHA3-384      |
| CKM_HASH_ML_DSA_SHA3_512 | SHA3-512      |
| CKM_HASH_ML_DSA_SHAKE128 | SHAKE128      |
| CKM_HASH_ML_DSA_SHAKE256 | SHAKE256      |
table: HashML-DSA with hashing: mechanisms and hash functions

These mechanisms have an optional parameter **CK_SIGN_ADDITIONAL_CONTEXT**. If
no parameter is supplied the hedgeVariant will be **CKH_HEDGE_PREFERRED**,
ulContextLen will be zero and pContext will be NULL. On signing, if hedgeVariant
is set to **CKH_HEDGE_PREFERRED**, the token may create either a hedged
signature or a deterministic signature as specified in [FIPS 204]. If
hedgeVariant is set to **CKH_HEDGE_REQUIRED**, the token must produce a hedged
signature or fail. If the hedgeVariant is set to **CKH_DETERMINISTIC_REQUIRED**,
the token must produce a deterministic signature or fail. On verification the
hedgeVariant parameter is ignored.

Constraints on key types and the length of the data are summarized in the
following table. In the table, k is the length in bytes of the ML-DSA signature.

| Function          | Key type            | Input Length | Output Length |
|-------------------|---------------------|--------------|---------------|
| C_Sign            | ML-DSA Private Key  | any          | k             |
| C_Verify          | ML-DSA Public Key   | any, k       | N/A           |
| C_VerifySignature | ML-DSA Public Key   | any, k       | N/A           |
table: HashML-DSA with hashing: Key and Data Length

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-DSA public
keys in bytes.


### ExternalMu-ML-DSA generation

The ExternalMu-ML-DSA generation mechanism, denoted **CKM_ML_DSA_EXTERNAL_MU_GEN**, is a mechanism for the calculation of the ExternalMu that can be consumed by the CKM_ML_DSA_EXTERNAL_MU mechanism only single-part signature and verification for ML-DSA signatures, as defined in sections 5 and 6 of [FIPS-204].  CKM_ML_DSA_EXTERNAL_MU_GEN  mechanism can be used for single-part and multiple-part digest operations.

CKM_ML_DSA_EXTERNAL_MU_GEN  will take a mechanism params  **CK_MU_GEN_PARAMS** the params supplies a key handle or a precomputed TR of the public key. If the key handles is empty then then a TR is expected. An additional context can also be supplied. Constraints on the length of the data are summarized in the following table.

| Function          | Input Length | Output Length |
|-------------------|--------------|---------------|
| C_Digest          | any          | 64            |
table: ML-DSA compute External Mu: Data Length

For these mechanisms, the ulMinKeySize and ulMaxKeySize fields of the CK_MECHANISM_INFO structure specify the supported range of ML-DSA public keys in bytes.

### ExternalMu-ML-DSA Signature

The ExternalMu-ML-DSA mechanism, denoted **CKM_ML_DSA_EXTERNAL_MU**, is a
mechanism for single-part signatures and verification for ML-DSA
signatures, as defined in sections 5 and 6 of [FIPS-204]. The data passed in
is the 64-byte message representative μ, normally computed in step 6 of
algorithm 7 and step 7 of algorithm 8, but here provided by the caller instead
of a message or message hash.
It has an optional parameter CK_SIGN_ADDITIONAL_CONTEXT. If no parameter is
supplied the hedgeVariant will be CKH_HEDGE_PREFERRED. On signing, if
hedgeVariant is set to CKH_HEDGE_PREFERRED, the token may create either a
hedged signature or a deterministic signature as specified in [FIPS 204].
If hedgeVariant is set to CKH_HEDGE_REQUIRED, the token must produce a hedged
signature or fail. If the hedgeVariant is set to CKH_DETERMINISTIC_REQUIRED,
the token must produce a deterministic signature or fail. On verification the
hedgeVariant parameter is ignored. In all cases ulContextLen will be zero and
pContext are ignored. 

Constraints on key types and the length of the data are summarized in the
following table.
In the table, k is the length in bytes of the ML-DSA signature.

| Function             | Key type            | Input Length | Output Length |
|----------------------|---------------------|--------------|---------------|
| C_Sign ^1^           | ML-DSA Private Key  | 64           | k             |
| C_Verify ^1^         | ML-DSA Public Key   | 64, k        | N/A           |
| C_VerifySignature ^1^| ML-DSA Public Key   | 64, k        | N/A           |
table: ExternalMu ML-DSA: Key and Data Length

^1^ Single-part operations only.

For these mechanisms, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-DSA public
keys in bytes.
