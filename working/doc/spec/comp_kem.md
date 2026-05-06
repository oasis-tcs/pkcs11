## Composite KEM

Composite KEM is a mechanism for key encapsulation, following the key encapsulation
algorithm defined in [COMP_KEM].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_COMP_KEM_KEY_PAIR_GEN            |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_COMP_KEM                         |     |     |      |     |       |     |     |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Composite KEM Mechanisms vs. Functions

### Definitions

This section defines the key type **CKK_COMP_KEM** for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of all Composite KEM key objects.

Mechanisms:

- CKM_COMP_KEM_KEY_PAIR_GEN
- CKM_COMP_KEM

**CK_COMP_KEM_PARAMETER_SET_TYPE** is used to indicate which Composite KEM parameter set
the keys belong to.

~~~{.c}
typedef CK_ULONG CK_COMP_KEM_PARAMETER_SET_TYPE;
~~~

Parameter set types:

- CKP_COMP_KEM_MLKEM768_RSA2048
- CKP_COMP_KEM_MLKEM768_RSA3072
- CKP_COMP_KEM_MLKEM768_RSA4096
- CKP_COMP_KEM_MLKEM768_X25519
- CKP_COMP_KEM_MLKEM768_ECDH_P256
- CKP_COMP_KEM_MLKEM768_ECDH_P384
- CKP_COMP_KEM_MLKEM768_ECDH_BRAINPOOLP256R1
- CKP_COMP_KEM_MLKEM1024_RSA3072
- CKP_COMP_KEM_MLKEM1024_ECDH_P384
- CKP_COMP_KEM_MLKEM1024_ECDH_BRAINPOOLP384R1
- CKP_COMP_KEM_MLKEM1024_X448
- CKP_COMP_KEM_MLKEM1024_ECDH_P521

            
### Composite KEM public key objects

Composite KEM public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_COMP_KEM**) hold Composite KEM public keys.

The following table defines the Composite KEM public key object attributes, in
addition to the common attributes defined for this object class:

| Attribute               | Data Type                      | Meaning           |
|-------------------------|--------------------------------|-------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_COMP_KEM_PARAMETER_SET_TYPE | Composite KEM parameter set |
| CKA_VALUE ^1,4^         | Byte array                     | Public value i.e. encapsulation key ek as defined in [COMP_KEM] |
table: Composite KEM Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by [COMP_KEM]. The parameter set will select the security level and public
key sizes. Tokens may support a subset of the defined parameter sets.

The following is a sample template for creating a Composite KEM public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_COMP_KEM;
CK_UTF8CHAR label[] = “A Composite KEM public key object”;
CK_COMP_KEM_PARAMETER_SET_TYPE param_set = CKP_COMP_KEM_MLKEM768_ECDH_P256;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_ENCAPSULATE, &true, sizeof(true)},
  {CKA_PARAMETER_SET, &param_set, sizeof(param_set)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Composite KEM private key objects


Composite KEM private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_ML_KEM**) hold Composite KEM private keys.

The following table defines Composite KEM private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                 | Data Type                      | Meaning         |
|---------------------------|--------------------------------|-----------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_COMP_KEM_PARAMETER_SET_TYPE | Composite KEM parameter set |
| CKA_VALUE ^1,4,6,7^       | Byte array                     | Private value i.e. decapsulation key dk as defined in [COMP_KEM] |
table: Composite KEM Private Key Object Attributes

- Refer to Table 13 for footnotes

**CKA_VALUE** must be specified on **C_CreateObject**. 

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by [COMP_KEM]. The parameter set will select the composite label, the
component algorithms and any associated parameters for the component algorithms as 
well as the key derivation function (KDF) used from the KEM combiner.

Note that when generating a Composite KEM private key, the parameter set is not
specified in the key’s template. This is because Composite KEM private keys are only
generated as part of a Composite KEM key pair, and the parameter set for the pair is
specified in the template for the Composite KEM public key.

The following is a sample template for creating a Composite KEM private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_COMP_KEM;
CK_UTF8CHAR label[] = “A Composite KEM private key object”;
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
  {CKA_DECAPSULATE, &true, sizeof(true)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Composite KEM key pair generation

The Composite KEM key pair generation mechanism, denoted **CKM_COMP_KEM_KEY_PAIR_GEN**,
is a key pair generation mechanism defined in section 3.1 of [COMP_KEM].

It takes **CK_COMP_KEM_PARAMETER_SET_TYPE** to denote the composite label, the
component algorithms and any associated parameters for the component algorithms as 
well as the key derivation function (KDF) used from the KEM combiner

The mechanism generates Composite KEM public/private key pairs with a parameter set, as
specified in the **CKA_PARAMETER_SET** attribute of the template for the public
key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PARAMETER_SET** and **CKA_VALUE** attributes to the new
private key; other attributes required by the Composite KEM public and private key
types must be specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Composite KEM public key
in bytes.
            
### Composite KEM Key Agreement

The Composite KEM Key Agreement mechanism, denoted **CKM_COMP_KEM**, is a mechanism for
key encapsulation and decapsulation as defined in section 3.2 and 3.3 of [COMP_KEM]. 

It has no parameters.

When used in **C_EncapsulateKey**, this mechanism generates a secret key and an
encapsulated ciphertext from a Composite KEM public key using section 3.2 of [COMP_KEM].

When used in **C_DecapsulateKey**, this mechanism generates a secret key from an
encapsulated ciphertext and a Composite KEM private key using section 3.3 of [COMP_KEM].  

The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

For these mechanisms, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Composite KEM public
keys in bytes.
