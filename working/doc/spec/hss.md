## HSS

HSS is a mechanism for single-part signatures and verification, following the
digital signature algorithm defined in [RFC 8554] and [NIST SP800-208].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_HSS_KEY_PAIR_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HSS                              |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: HSS Mechanisms vs. Functions

^1^ Single-part operations only

### Definitions 

This section defines the key type **CKK_HSS** for type **CK_KEY_TYPE** as used
in the **CKA_KEY_TYPE** attribute of key objects and domain parameter objects.

Mechanisms:

- CKM_HSS_KEY_PAIR_GEN
- CKM_HSS

### HSS public key objects

HSS public key objects (object class **CKO_PUBLIC_KEY**, key type **CKK_HSS**)
hold HSS public keys.

The following table defines the HSS public key object attributes, in addition to
the common attributes defined for this object class:

| Attribute                | Data Type  | Meaning                            |
|--------------------------|------------|------------------------------------|
| CKA_HSS_LEVELS ^2,4^     | CK_ULONG   | The number of levels in the HSS scheme. |
| CKA_HSS_LMS_TYPE ^2,4^   | CK_ULONG   | The encoding for the Merkle tree heights of the top level LMS tree in the hierarchy. |
| CKA_HSS_LMOTS_TYPE ^2,4^ | CK_ULONG   | The encoding for the Winternitz parameter of the one-time-signature scheme of the top level LMS tree. |
| CKA_VALUE ^1,4^          | Byte array | XDR-encoded public key as defined in [RFC8554].  |
table: HSS Public Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating an HSS public key object:

~~~{.c}
CK_OBJECT_CLASS keyClass = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_HSS;
CK_UTF8CHAR label[] = “An HSS public key object”;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_BBOOL false = CK_FALSE;

CK_ATTRIBUTE template[] = {
    {CKA_CLASS, &keyClass, sizeof(keyClass)},
    {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
    {CKA_TOKEN, &false, sizeof(false)},
    {CKA_LABEL, label, sizeof(label)-1},
    {CKA_VALUE, value, sizeof(value)},
    {CKA_VERIFY, &true, sizeof(true)}
};
~~~

### HSS private key objects

HSS private key objects (object class **CKO_PRIVATE_KEY**, key type **CKK_HSS**)
hold HSS private keys. 

The following table defines the HSS private key object attributes, in addition
to the common attributes defined for this object class:

| Attribute                    | Data Type    | Meaning                      |
|------------------------------|--------------|------------------------------|
| CKA_HSS_LEVELS ^1,3^         | CK_ULONG     | The number of levels in the HSS scheme. |
| CKA_HSS_LMS_TYPES ^1,3^      | CK_ULONG_PTR | A list of encodings for the Merkle tree heights of the LMS trees in the hierarchy from top to bottom. The number of encodings in the array is the ulValueLen component of the attribute divided by the size of CK_ULONG. This number must match the CKA_HSS_LEVELS attribute value. |
| CKA_HSS_LMOTS_TYPES ^1,3^    | CK_ULONG_PTR | A list of encodings for the Winternitz parameter of the one-time-signature scheme of the LMS trees in the hierarchy from top to bottom. The number of encodings in the array is the ulValueLen component of the attribute divided by the size of CK_ULONG. This number must match the CKA_HSS_LEVELS attribute value. |
| CKA_VALUE ^1,4,6,7^          | Byte array   | Vendor defined, must include state information. |
|                              |              | Note that exporting this value is dangerous as it would allow key reuse. |
| CKA_HSS_KEYS_REMAINING ^2,4^ | CK_ULONG     | The minimum of the following two values: 1) The number of one-time private keys remaining; 2) 2^32-1 |
table: HSS Private Key Object Attributes

- Refer to Table 13 for footnotes

The encodings for **CKA_HSS_LMOTS_TYPES** and **CKA_HSS_LMS_TYPES** are defined
in [RFC 8554] and [NIST SP800-208].

The following is a sample template for creating an LMS private key object:

~~~{.c}
CK_OBJECT_CLASS keyClass = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_HSS;
CK_UTF8CHAR label[] = “An HSS private key object”;
CK_ULONG hssLevels = 123;
CK_ULONG lmsTypes[] = {123,...};
CK_ULONG lmotsTypes[] = {123,...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_BBOOL false = CK_FALSE;
CK_ATTRIBUTE template[] = {
    {CKA_CLASS, &keyClass, sizeof(keyClass)},
    {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
    {CKA_TOKEN, &true, sizeof(true)},
    {CKA_LABEL, label, sizeof(label)-1},
    {CKA_SENSITIVE, &true, sizeof(true)},
    {CKA_EXTRACTABLE, &false, sizeof(true)},
    {CKA_HSS_LEVELS, &hssLevels, sizeof(hssLevels)},
    {CKA_HSS_LMS_TYPES, lmsTypes, sizeof(lmsTypes)},
    {CKA_HSS_LMOTS_TYPES, lmotsTypes, sizeof(lmotsTypes)},
    {CKA_VALUE, value, sizeof(value)},
    {CKA_SIGN, &true, sizeof(true)}
};
~~~

**CKA_SENSITIVE** MUST be true, **CKA_EXTRACTABLE** MUST be false, and
**CKA_COPYABLE** MUST be false for this key. 

### HSS key pair generation

The HSS key pair generation mechanism, denoted **CKM_HSS_KEY_PAIR_GEN**, is a
key pair generation mechanism for HSS.

This mechanism does not have a parameter.

The mechanism generates HSS public/private key pairs for the scheme specified by
the **CKA_HSS_LEVELS**, **CKA_HSS_LMS_TYPES**, and **CKA_HSS_LMOTS_TYPES**
attributes of the template for the private key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_HSS_LEVELS**, **CKA_HSS_LMS_TYPE**, **CKA_HSS_LMOTS_TYPE**, and
**CKA_VALUE** attributes to the new public key and the **CKA_CLASS**,
**CKA_KEY_TYPE**, **CKA_VALUE**, and **CKA_HSS_KEYS_REMAINING** attributes to
the new private key.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure are not used and must be set to 0.

### HSS without hashing

The HSS without hashing mechanism, denoted **CKM_HSS**, is a mechanism for
single-part signatures and verification for HSS. (This mechanism corresponds
only to the part of LMS that processes the hash value, which may be of any
length; it does not compute the hash value.)

This mechanism does not have a parameter.

For the purposes of these mechanisms, an HSS signature is a byte string with
length depending on **CKA_HSS_LEVELS**, **CKA_HSS_LMS_TYPES**,
**CKA_HSS_LMOTS_TYPES** as described in the following table.

| Function     | Key type          | Input length       | Output length |
|--------------|-------------------|--------------------|---------------|
| C_Sign ^1^   | CKK_HSS (Private) | any                | 1296-74988^2^ |
| C_Verify ^1^ | CKK_HSS (Public)  | any, 1296-74988^2^ | N/A           |
table: HSS without hashing: Key and Data Length

^1^ Single-part operations only.

^2^ 4+(levels-1)\*56+levels\*(8+(36+32\*_p_)+_h_\*32) where _p_ has values (265,
133, 67, 34) for lmots type (W1, W2, W4, W8) and h is the number of levels in
the LMS Merkle trees.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure are not used and must be set to 0.

If the number of signatures is exhausted, **CKR_KEY_EXHAUSTED** will be
returned.
