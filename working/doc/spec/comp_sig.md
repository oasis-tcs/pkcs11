## Composite Signature

Composite Signatures are mechanisms for signatures and verification, following
the digital signature algorithm defined in [COMP_SIG]


+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_COMP_SIG_KEY_PAIR_GEN             |     |    |      |     |   ✓   |     |     |      |
| CKM_COMP_SIG                          |     | ✓  |     |     |        |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Composite Signature Mechanisms vs. Functions


### Definitions

This section defines the key type **CKK_COMP_SIG** for type **CK_KEY_TYPE**, as used in the **CKA_KEY_TYPE** attribute of all Composite key objects.

Mechanisms:

- CKM_COMP_SIG_KEY_PAIR_GEN
- CKM_COMP_SIG


**CK_COMP_SIG_PARAMETER_SET_TYPE** is used to indicate which Composite Signature parameter set the keys belong to.

~~~{.c}
typedef CK_ULONG CK_COMP_SIG_PARAMETER_SET_TYPE;
~~~

Parameter set types:

- CKP_COMP_SIG_MLDSA44_RSA2048_PSS_SHA256
- CKP_COMP_SIG_MLDSA44_RSA2048_PKCS15_SHA256
- CKP_COMP_SIG_MLDSA44_Ed25519_SHA512
- CKP_COMP_SIG_MLDSA44_ECDSA_P256_SHA256
- CKP_COMP_SIG_MLDSA65_RSA3072_PSS_SHA512
- CKP_COMP_SIG_MLDSA65_RSA3072_PKCS15_SHA512
- CKP_COMP_SIG_MLDSA65_RSA4096_PSS_SHA512
- CKP_COMP_SIG_MLDSA65_RSA4096_PKCS15_SHA512
- CKP_COMP_SIG_MLDSA65_ECDSA_P256_SHA512
- CKP_COMP_SIG_MLDSA65_ECDSA_P384_SHA512
- CKP_COMP_SIG_MLDSA65_ECDSA_brainpoolP256r1_SHA512
- CKP_COMP_SIG_MLDSA65_Ed25519_SHA512
- CKP_COMP_SIG_MLDSA87_ECDSA_P384_SHA512
- CKP_COMP_SIG_MLDSA87_ECDSA_brainpoolP384r1_SHA512
- CKP_COMP_SIG_MLDSA87_Ed448_SHAKE256
- CKP_COMP_SIG_MLDSA87_RSA3072_PSS_SHA512
- CKP_COMP_SIG_MLDSA87_RSA4096_PSS_SHA512
- CKP_COMP_SIG_MLDSA87_ECDSA_P521_SHA512


**CK_SIGN_ADDITIONAL_CONTEXT** is used in the mechanism parameters to supply a NIST-defined context string.

~~~{.c}
typedef struct CK_SIGN_ADDITIONAL_CONTEXT {
  CK_BYTE_PTR    pContext;
  CK_ULONG       ulContextLen;
} CK_SIGN_ADDITIONAL_CONTEXT;
~~~


### Composite Signature public key objects

Composite Signature public key objects (object class **CKO_PUBLIC_KEY**, key type **CKK_COMP_SIG**) hold Composite Signature public keys.

The following table defines the Composite Signature public key object attributes, in addition
to the common attributes defined for this object class:

| Attribute               | Data Type                       | Meaning                               |
| ----------------------- | --------------------------------| ------------------------------------- |
| CKA_PARAMETER_SET ^1,3^ | CK_COMP_SIG_PARAMETER_SET_TYPE  | Composite Signature parameter set     |
| CKA_VALUE ^1,4^         | Byte array                      | Public key as defined in [COMP_SIG]   |
table: Composite Signature Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by [COMP_SIG].
The parameter set will select the security level and public key sizes. Tokens may
 support a subset of the defined parameter sets.

The following is a sample template for creating an Composite Signature public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_COMP_SIG;
CK_UTF8CHAR label[] = "A Composite Signature public key object";
CK_COMP_SIG_PARAMETER_SET_TYPE param_set = CKP_COMP_SIG_MLDSA65_ECDSA_P256_SHA512;
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

### Composite Signature private key objects

Composite Signature private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_COMP_SIG**) hold Composite Signature private keys.

The following table defines the Composite Signature private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                | Data Type                      | Meaning                                     |
| ------------------------ | ------------------------------ | ------------------------------------------- |
| CKA_PARAMETER_SET^1,4,6^ | CK_COMP_SIG_PARAMETER_SET_TYPE | Composite Signature parameter set           |
| CKA_VALUE^1,4,6,7^       | Byte array                     | Private key as defined in [COMP_SIG]        |
table: Composite Signature Private Key Object Attributes

- Refer to Table 13 for footnotes

**CKA_VALUE** must be provided during **C_CreateObject**.

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified in [COMP_SIG].  The parameter set will select the composite label, the
component algorithms and any associated parameters for the component algorithms
as well as the pre-hash algorithm.

Note that when generating a Composite Signature private key, the parameter set is not
specified in the key’s template. This is because Composite Signature private keys are
only generated as part of a Composite Signature key pair, and the parameter set for
the pair is specified in the template for the Composite Signature public key.

The following is a sample template for creating a Composite Signature private key object:


~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_COMP_SIG;
CK_UTF8CHAR label[] = "A Composite Signature private key object";
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
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
  {CKA_VALUE, value, sizeof(value)}
};
~~~


## Composite Signature key pair generation

The Composite Signature key pair generation mechanism, denoted ***CKM_COMP_SIG_KEY_PAIR_GEN**,
is a key pair generation mechanism using KeyGen() as defined in section 4.1 of [COMP_SIG]

It takes **CK_COMP_SIG_PARAMETER_SET_TYPE** to denote the composite component algorithms, 
the label and the hash function. 

The mechanism generates Composite Signature public and private key pairs with a parameter set,
as specified in the **CKA_PARAMETER_SET** attribute of the template for the public key.  
These parameter set reference the Object ID’s as defined in [COMP_SIG] which fully specify
the label, component algorithms and the hash function used for pre-hashing.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE** attributes
to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_PARAMETER_SET**, and
**CKA_VALUE** attributes to the new private key; other attributes required by the Composite
Signature public and private key types must be specified in the templates.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the **CK_MECHANISM_INFO**
structure specify the supported range of Composite Signature public key in bytes.


### Composite Signature

The composite signature mechanism, denoted **CKM_COMP_SIG**, is a mechanism for generating
and verifying Composite Signatures as defined in sections 4.2 and 4.3 of [COMP_SIG], 
Algorithm 4.2 Sign and Algorithm 4.3 Verify, using SHA256, SHA512 or SHAKE256 as the hash
function. The data passed in is the message M.

It has an optional parameter **CK_SIGN_ADDITIONAL_CONTEXT**. If no parameter is supplied
ulContextLen will be zero and pContext will be NULL.  Constraints on key types and the
length of the data are summarized in the following table. In the table, k is the length
in bytes of the Composite Signature.


| Function          | Key Type                        | Input Length | Output Length |
| ----------------- | ------------------------------- | ------------ | ------------- |
| C_Sign            | Composite Signature Private Key | any          | k             |
| C_Verify ^1^      | Composite Signature Public Key  | any, k       | N/A           |
| C_VerifySignature | Composite Signature Public Key  | any, k       | N/A           |
table: Composite Signature: Key and Data Length

^1^ Single-part operations only.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Composite Signature
public keys in bytes.