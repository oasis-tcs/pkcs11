## HKDF Mechanisms

Details for HKDF key derivation mechanisms can be found in [RFC 5869]. 

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_HKDF_DERIVE                      |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HKDF_DATA                        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HKDF_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: HKDF Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_HKDF_DERIVE
- CKM_HKDF_DATA
- CKM_HKDF_KEY_GEN

Key Types:
- CKK_HKDF

### HKDF mechanism parameters

#### CK_HKDF_PARAMS
\  

**CK_HKDF_PARAMS** is a structure that provides the parameters to the
**CKM_HKDF_DERIVE** and **CKM_HKDF_DATA** mechanisms. It is defined as follows:

~~~{.c}
typedef struct CK_HKDF_PARAMS {
    CK_BBOOL bExtract;
    CK_BBOOL bExpand;
    CK_MECHANISM_TYPE prfHashMechanism;
    CK_ULONG ulSaltType;
    CK_BYTE_PTR pSalt;
    CK_ULONG ulSaltLen;
    CK_OBJECT_HANDLE hSaltKey;
    CK_BYTE_PTR pInfo;
    CK_ULONG ulInfoLen;
} CK_HKDF_PARAMS;
~~~

The fields of the structure have the following meanings:

_bExtract_
: execute the extract portion of HKDF.

_bExpand_
: execute the expand portion of HKDF.

_prfHashMechanism_
: base hash used for the HMAC in the underlying HKDF operation.

_ulSaltType_
: specifies how the salt for the extract portion of the KDF is supplied. 
: **CKF_HKDF_SALT_NULL** no salt is supplied.
: **CKF_HKDF_SALT_DATA** salt is supplied as a data in pSalt with length
  ulSaltLen.
:  **CKF_HKDF_SALT_KEY** salt is supplied as a key in hSaltKey.

_pSalt_
: pointer to the salt.

_ulSaltLen_
: length of the salt pointed to in pSalt.

_hSaltKey_
: object handle to the salt key.

_pInfo_
: info string for the expand stage.

_ulInfoLen_
: length of the info string for the expand stage.

**CK_HKDF_PARAMS_PTR** is a pointer to a **CK_HKDF_PARAMS**.

### HKDF derive

HKDF derivation implements the HKDF as specified in [RFC 5869]. The two booleans
bExtract and bExpand control whether the extract section of the HKDF or the
expand section of the HKDF is in use. 

It has a parameter, a **CK_HKDF_PARAMS** structure, which allows for the passing
of the salt and or the expansion info. The structure contains the bools bExtract
and bExpand which control whether the extract or expand portions of the HKDF is
to be used. This structure is defined in section 6.62.2.

The input key must be of type **CKK_HKDF** or **CKK_GENERIC_SECRET** and the
length must be the size of the underlying hash function specified in
prfHashMechanism. The exception is a data object which has the same size as the
underlying hash function, and which may be supplied as an input key. In this
case bExtract should be true and non-null salt should be supplied.

Either bExtract or bExpand must be set to true. If they are both set to true,
input key is first extracted then expanded. The salt is used in the extraction
stage. If bExtract is set to true and no salt is given, a ‘zero’ salt (salt
whose length is the same as the underlying hash and values all set to zero) is
used as specified by the RFC. If bExpand is set to true, **CKA_VALUE_LEN**
should be set to the desired key length. If it is false **CKA_VALUE_LEN** may be
set to the length of the hash, but that is not necessary as the mechanism will
supply this value. The salt should be ignored if bExtract is false. The pInfo
should be ignored if bExpand is set to false.

The mechanism also contributes the **CKA_CLASS**, and **CKA_VALUE** attributes
to the new key. Other attributes may be specified in the template, or else are
assigned default values.

The template sent along with this mechanism during a **C_DeriveKey** call may
indicate that the object class is **CKO_SECRET_KEY**. However, since these facts
are all implicit in the mechanism, there is no need to specify any of them.

This mechanism has the following rules about key sensitivity and extractability:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

### HKDF Data

HKDF Data derive mechanism, denoted **CKM_HKDF_DATA**, is identical to HKDF
Derive except the output is a **CKO_DATA** object whose value is the result to
the derive operation. Some tokens may restrict what data may be successfully
derived based on the pInfo portion of the **CK_HKDF_PARAMS**. Tokens may reject
requests based on the pInfo values. Allowed pInfo values are specified in the
profile document and applications could then query the appropriate profile
before depending on the mechanism.

### HKDF Key gen

HKDF key gen, denoted **CKM_HKDF_KEY_GEN** generates a new random HKDF key.
**CKA_VALUE_LEN** must be set in the template.
