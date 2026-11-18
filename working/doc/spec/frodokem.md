## FrodoKEM

FrodoKEM is a mechanism for key encapsulation, following the key encapsulation
algorithm defined in [ISO/IEC 18033-2:2006/Amd 2:2026].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_FRODOKEM_KEY_PAIR_GEN            |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_FRODOKEM                         |     |     |      |     |       |     |     |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: FrodoKEM Mechanisms vs. Functions

### Definitions

This section defines the key type **CKK_FRODOKEM** for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of all FrodoKEM key objects.

Mechanisms:

- CKM_FRODOKEM_KEY_PAIR_GEN
- CKM_FRODOKEM

**CK_FRODOKEM_PARAMETER_SET_TYPE** is used to indicate which FrodoKEM parameter set
the keys belong to.

~~~{.c}
typedef CK_ULONG CK_FRODOKEM_PARAMETER_SET_TYPE;
~~~

Parameter set types:

- CKP_FRODOKEM_640_AES
- CKP_FRODOKEM_640_SHAKE
- CKP_FRODOKEM_976_AES
- CKP_FRODOKEM_976_SHAKE
- CKP_FRODOKEM_1344_AES
- CKP_FRODOKEM_1344_SHAKE
- CKP_EFRODOKEM_640_AES
- CKP_EFRODOKEM_640_SHAKE
- CKP_EFRODOKEM_976_AES
- CKP_EFRODOKEM_976_SHAKE
- CKP_EFRODOKEM_1344_AES
- CKP_EFRODOKEM_1344_SHAKE

### FrodoKEM public key objects

FrodoKEM public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_FRODOKEM**) hold FrodoKEM public keys.

The following table defines the FrodoKEM public key object attributes, in addition
to the common attributes defined for this object class:

| Attribute               | Data Type                      | Meaning                |
|-------------------------|--------------------------------|------------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_FRODOKEM_PARAMETER_SET_TYPE | FrodoKEM parameter set |
| CKA_VALUE ^1,4^         | Byte array                     | Public value i.e. encapsulation key pk as defined in [ISO/IEC 18033-2:2006/Amd 2:2026] |
table: FrodoKEM Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by ISO. The parameter set will select the security level and public
key sizes. Tokens may support a subset of the defined parameter sets.

The following is a sample template for creating an FrodoKEM public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_FRODOKEM;
CK_UTF8CHAR label[] = "A FrodoKEM public key object";
CK_FRODOKEM_PARAMETER_SET_TYPE param_set = CKP_FRODOKEM_640_SHAKE;
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

### FrodoKEM private key objects


FrodoKEM private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_FRODOKEM**) hold FrodoKEM private keys.

The following table defines the FrodoKEM private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                 | Data Type                      | Meaning         |
|---------------------------|--------------------------------|-----------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_FRODOKEM_PARAMETER_SET_TYPE | FrodoKEM parameter set |
| CKA_SEED ^4,6,7^          | Byte array                     | Randomness value (s||seed_SE||z) as defined in FrodoKEM.Keygen in [ISO/IEC 18033-2:2006/Amd 2:2026] |
| CKA_VALUE ^4,6,7^         | Byte array                     | Private value i.e. decapsulation key sk as defined in [ISO/IEC 18033-2:2006/Amd 2:2026] |
table: FrodoKEM Private Key Object Attributes

- Refer to Table 13 for footnotes

At least one of **CKA_SEED** and **CKA_VALUE** must be specified on
**C_CreateObject**. Tokens may reject creation requests that only specify one of
these values. For highest compatibility applications should set both.

The **CKA_PARAMETER_SET** attribute value selects a predefined set of parameters
specified by ISO. The parameter set will select the security level and private
key sizes. Tokens may support a subset of the defined parameter sets.

Note that when generating a FrodoKEM private key, the parameter set is not
specified in the key’s template. This is because FrodoKEM private keys are only
generated as part of a FrodoKEM key pair, and the parameter set for the pair is
specified in the template for the FrodoKEM public key.

The following is a sample template for creating a FrodoKEM private key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_FRODOKEM;
CK_UTF8CHAR label[] = "A FrodoKEM private key object";
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_FRODOKEM_PARAMETER_SET_TYPE param_set = CKP_FRODOKEM_640_SHAKE;
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
  {CKA_SEED, seed, sizeof(seed)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### FrodoKEM key pair generation

The FrodoKEM key pair generation mechanism, denoted **CKM_FRODOKEM_KEY_PAIR_GEN**,
is a key pair generation mechanism described in Section 14.6 of
[ISO/IEC 18033-2:2006/Amd 2:2026].

It does not have a parameter.

The mechanism generates FrodoKEM public/private key pairs with a parameter set, as
specified in the **CKA_PARAMETER_SET** attribute of the template for the public
key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PARAMETER_SET**, **CKA_SEED** and **CKA_VALUE** attributes to the new
private key; other attributes required by the FrodoKEM public and private key
types must be specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of FrodoKEM public key
in bytes.

### FrodoKEM Key Agreement

The FrodoKEM Key Agreement mechanism, denoted **CKM_FRODOKEM**, is a mechanism for
key encapsulation and decapsulation as described in section 14.7 and section 14.8
respectively of [ISO/IEC 18033-2:2006/Amd 2:2026].

It has no parameters.

When used in **C_EncapsulateKey**, this mechanism generates a secret key and an
encapsulated ciphertext from a FrodoKEM public key using FrodoKEM.Encaps.

When used in **C_DecapsulateKey**, this mechanism generates a secret key from an
encapsulated ciphertext and a FrodoKEM private key using FrodoKEM.Decaps.

The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

For these mechanisms, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of FrodoKEM public
keys in bytes.
