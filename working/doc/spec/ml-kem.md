## ML-KEM

ML-KEM is a mechanism for key encapsulation, following the key encapsulation
algorithm defined in [FIPS 203].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_ML_KEM_KEY_PAIR_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ML_KEM                           |     |     |      |     |       |     |     |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: ML-KEM Mechanisms vs. Functions

### Definitions

This section defines the key type **CKK_ML_KEM** for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of all ML-KEM key objects.

Mechanisms:

- CKM_ML_KEM_KEY_PAIR_GEN
- CKM_ML_KEM

**CK_ML_KEM_PARAMETER_SET_TYPE** is used to indicate which ML-KEM parameter set
the keys belong to.

~~~{.c}
typedef CK_ULONG CK_ML_KEM_PARAMETER_SET_TYPE;
~~~

Parameter set types:

- CKP_ML_KEM_512
- CKP_ML_KEM_768
- CKP_ML_KEM_1024
            
### ML-KEM public key objects

ML-KEM public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_ML_KEM**) hold ML-KEM public keys.

The following table defines the ML-KEM public key object attributes, in addition
to the common attributes defined for this object class:

| Attribute               | Data Type                    | Meaning           |
|-------------------------|------------------------------|-------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_ML_KEM_PARAMETER_SET_TYPE | ML-KEM parameter set |
| CKA_VALUE ^1,4^         | Byte array                   | Public value i.e. encapsulation key ek as defined in [FIPS 203] |
table: ML-KEM Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by NIST. The parameter set will select the security level and public
key sizes. Tokens may support a subset of the defined parameter sets.

The following is a sample template for creating an ML-KEM public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_ML_KEM;
CK_UTF8CHAR label[] = “A ML-KEM public key object”;
CK_ML_KEM_PARAMETER_SET_TYPE param_set = CKP_ML_KEM_512;
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

### ML-KEM private key objects


ML-KEM private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_ML_KEM**) hold ML-KEM private keys.

The following table defines the ML-KEM private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                 | Data Type                    | Meaning         |
|---------------------------|------------------------------|-----------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_ML_KEM_PARAMETER_SET_TYPE | ML-KEM parameter set |
| CKA_SEED ^4,6,7^          | Byte array                   | Randomness value (d||z) as defined in ML-KEM.Keygen in [FIPS 203] |
| CKA_VALUE ^1,4,6,7^       | Byte array                   | Private value i.e. decapsulation key dk as defined in [FIPS 203] |
table: ML-KEM Private Key Object Attributes

- Refer to Table 13 for footnotes

At least one of **CKA_SEED** and **CKA_VALUE** must be specified on
**C_CreateObject**. Tokens may reject creation requests that only specify one of
these values. For highest compatibility applications should set both.

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by NIST. The parameter set will select the security level and private
key sizes. Tokens may support a subset of the defined parameter sets.

Note that when generating a ML-KEM private key, the parameter set is not
specified in the key’s template. This is because ML-KEM private keys are only
generated as part of a ML-KEM key pair, and the parameter set for the pair is
specified in the template for the ML-KEM public key.

The following is a sample template for creating an ML-KEM private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_ML_KEM;
CK_UTF8CHAR label[] = “A ML-KEM private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_ML_KEM_PARAMETER_SET_TYPE param_set = CKP_ML_KEM_512;
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
  {CKA_DECAPSULATE, &true, sizeof(true)},
  {CKA_PARAMETER_SET, &param_set, sizeof(param_set)},
  {CKA_SEED, seed, sizeof(seed)}
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### ML-KEM key pair generation

The ML-KEM key pair generation mechanism, denoted **CKM_ML_KEM_KEY_PAIR_GEN**,
is a key pair generation mechanism using Algorithm 19 ML-KEM.KeyGen as defined
in [FIPS 203].

It does not have a parameter.

The mechanism generates ML-KEM public/private key pairs with a parameter set, as
specified in the **CKA_PARAMETER_SET** attribute of the template for the public
key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PARAMETER_SET**, **CKA_SEED** and **CKA_VALUE** attributes to the new
private key; other attributes required by the ML-KEM public and private key
types must be specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-KEM public key
in bytes.
            
### ML-KEM Key Agreement

The ML-KEM Key Agreement mechanism, denoted **CKM_ML_KEM**, is a mechanism for
key encapsulation and decapsulation using Algorithm 20 ML-KEM.Encaps and
Algorithm 21 ML-KEM.Decaps respectively. Both are defined in [FIPS 203].

It has no parameters.

When used in **C_EncapsulateKey**, this mechanism generates a secret key and an
encapsulated ciphertext from a ML-KEM public key using ML-KEM.Encaps.

When used in **C_DecapsulateKey**, this mechanism generates a secret key from an
encapsulated ciphertext and a ML-KEM private key using ML-KEM.Decaps.

The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

For these mechanisms, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ML-KEM public
keys in bytes.
