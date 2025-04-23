## XMSS and XMSS^MT^

XMSS and XMSS^MT^ are mechanisms for single-part signatures and verification,
following the digital signature algorithm defined in [RFC 8391].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_XMSS_KEY_PAIR_GEN                |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_XMSS                             |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_XMSSMT_KEY_PAIR_GEN              |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_XMSSMT                           |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: XMSS and XMSS^MT^ Mechanisms vs. Functions

^1^ Single-part operations only

### Definitions

This section defines the key type **CKK_XMSS** and **CKK_XMSSMT** for type
**CK_KEY_TYPE** as used in the **CKA_KEY_TYPE** attribute of key objects and
domain parameter objects.

Mechanisms:

- CKM_XMSS_KEY_PAIR_GEN
- CKM_XMSS
- CKM_XMSSMT_KEY_PAIR_GEN
- CKM_XMSSMT
            
### XMSS public key objects

XMSS public key objects (object class **CKO_PUBLIC_KEY**, key type **CKK_XMSS**)
hold XMSS public keys.

The following table defines the XMSS public key object attributes, in addition
to the common attributes defined for this object class:

| Attribute               | Data Type                  | Meaning             |
|-------------------------|----------------------------|---------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_XMSS_PARAMETER_SET_TYPE | XMSS parameter set as defined below. |
| CKA_VALUE ^1,4^         | Byte array                 | 4+2\*N bytes; a 4 byte integer in big-endian order encoding an _algorithm OID_, an N byte string (the Merkle tree root hash value), an N byte string (the public SEED). |
table: XMSS Public Key Object Attributes

- Refer to Table 13 for footnotes

~~~{.c}
typedef CK_ULONG CK_XMSS_PARAMETER_SET_TYPE;
~~~

where **CK_XMSS_PARAMETER_SET_TYPE** is the numeric identifier of the XMSS
parameter set defined in [NIST SP800-208].

The following is a sample template for creating an XMSS public key object:

~~~{.c}
CK_OBJECT_CLASS keyClass = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_XMSS;
CK_UTF8CHAR label[] = “An XMSS public key object”;
CK_XMSS_PARAMETER_SET_TYPE xmss_param = 0x01;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_BBOOL false = CK_FALSE;

CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &false, sizeof(false)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PARAMETER_SET, &xmss_param, sizeof(xmss_param)},
  {CKA_VALUE, value, sizeof(value)},
  {CKA_VERIFY, &true, sizeof(true)}
};
~~~

### XMSS^MT^ public key objects

XMSS^MT^ public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_XMSSMT**) hold XMSS^MT^ public keys.

The following table defines the XMSS^MT^ public key object attributes, in
addition to the common attributes defined for this object class:

| Attribute               | Data Type                    | Meaning           |
|-------------------------|------------------------------|-------------------|
| CKA_PARAMETER_SET ^1,3^ | CK_XMSSMT_PARAMETER_SET_TYPE | XMSS^MT^ parameter set as defined below. |
| CKA_VALUE ^1,4^         | Byte array | 4+2\*N bytes; a 4 byte integer in big-endian order encoding an _algorithm OID_, an N byte string (the Merkle tree root hash value), an N byte string (the public SEED). |
table: XMSS^MT^ Public Key Object Attributes

- Refer to Table 13 for footnotes

~~~{.c}
typedef CK_ULONG CK_XMSSMT_PARAMETER_SET_TYPE;
~~~

where **CK_XMSSMT_PARAMETER_SET_TYPE** is the numeric identifier of the XMSS^MT^
parameter set defined in [NIST SP800-208].

~~~{.c}
The following is a sample template for creating an XMSS^MT^ public key object:
CK_OBJECT_CLASS keyClass = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_XMSSMT;
CK_UTF8CHAR label[] = “An XMSS^MT^ public key object”;
CK_XMSSMT_PARAMETER_SET_TYPE xmss_mt_param = 0x01;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_BBOOL false = CK_FALSE;

CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &false, sizeof(false)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PARAMETER_SET, &xmss_mt_param, sizeof(xmss_mt_param)},
  {CKA_VALUE, value, sizeof(value)},
  {CKA_VERIFY, &true, sizeof(true)}
};
~~~

### XMSS private key objects

XMSS private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_XMSS**) hold XMSS private keys.

The following table defines the XMSS private key object attributes, in addition
to the common attributes defined for this object class:

| Attribute                 | Data Type                  | Meaning           |
|---------------------------|----------------------------|-------------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_XMSS_PARAMETER_SET_TYPE | Numeric identifier of the XMSS parameter set as defined in section 6.66.2. |
| CKA_VALUE ^1,4,6,7^       | Byte array                 | Vendor defined.   |
|                           |                            | Note that exporting this value is dangerous as it would allow key reuse.
table: XMSS Private Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating an XMSS private key object:

~~~{.c}
CK_OBJECT_CLASS keyClass = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_XMSS;
CK_UTF8CHAR label[] = “An XMSS private key object”;
CK_XMSS_PARAMETER_SET_TYPE xmss_param = 0x01;
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
  {CKA_PARAMETER_SET, &xmss_param, sizeof(xmss_param)},
  {CKA_VALUE, value, sizeof(value)}
  {CKA_SIGN, &true, sizeof(true)}
};
~~~

**CKA_SENSITIVE** MUST be true and **CKA_EXTRACTABLE** MUST be false for this
key.
            
### XMSS^MT^ private key objects

XMSS^MT^ private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_XMSSMT**) hold XMSS^MT^ private keys.

The following table defines the XMSS^MT^ private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute                 | Data Type                    | Meaning         |
|---------------------------|------------------------------|-----------------|
| CKA_PARAMETER_SET ^1,4,6^ | CK_XMSSMT_PARAMETER_SET_TYPE | Numeric identifier of the XMSS^MT^ parameter set as defined in section 6.66.3. |
| CKA_VALUE ^1,4,6,7^       | Byte array                   | Vendor defined. |
|                           |                              | Note that exporting this value is dangerous as it would allow key reuse.
table: XMSS^MT^ Private Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating an XMSS^MT^ private key object:

~~~{.c}
CK_OBJECT_CLASS keyClass = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_XMSS;
CK_UTF8CHAR label[] = “An XMSS^MT^ private key object”;
CK_XMSSMT_PARAMETER_SET_TYPE xmss_mt_param = 0x01;
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
  {CKA_PARAMETER_SET, &xmss_mt_param, sizeof(xmss_mt_param)},
  {CKA_VALUE, value, sizeof(value)}
  {CKA_SIGN, &true, sizeof(true)}
};
~~~

**CKA_SENSITIVE** MUST be true and **CKA_EXTRACTABLE** MUST be false for this
key.
            
### XMSS key pair generation

The XMSS key pair generation mechanism, denoted **CKM_XMSS_KEY_PAIR_GEN**, is a
key pair generation mechanism for XMSS.

This mechanism does not have a parameter.

The mechanism generates XMSS public/private key pairs using an oid, as specified
in the **CKA_PARAMETER_SET** attribute of the template for the public key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_VALUE**, and **CKA_PARAMETER_SET** attributes to the new private key.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used and must be set to 0.
            
### XMSS^MT^ key pair generation


The XMSS^MT^ key pair generation mechanism, denoted **CKM_XMSSMT_KEY_PAIR_GEN**,
is the key pair generation mechanism for XMSS^MT^.

The mechanism generates XMSS^MT^ public/private key pairs using an oid, as
specified in the **CKA_PARAMETER_SET** attribute of the template for the public
key.

All other restrictions detailed in section [6.66.6] apply, using XMSS^MT^ types
where necessary.
            
### XMSS and XMSS^MT^ without hashing

The XMSS and XMSS^MT^ without hashing mechanisms, denoted **CKM_XMSS** and
**CKM_XMSSMT** respectively, are mechanisms for single-part signatures and
verification.

These mechanisms do not have parameters.

For the purposes of these mechanisms, an XMSS or XMSS^MT^ signature is a byte
string with a length depending on the oid provided.

| Function     | Key type           | Input length      | Output length |
|--------------|--------------------|-------------------|---------------|
| C_Sign ^1^   | CKM_XMSS (Private) | any               | 2500-9732^2^  |
| C_Verify ^1^ | CKM_XMSS (Public)  | any, 2500-9732^2^ | N/A           |
table: XMSS without hashing: Key and Data Length

^1^ Single-part operations only.

^2^ Smallest and largest signature sizes from [RFC 8391], including optional
parameter sets.

| Function     | Key type             | Input length        | Output length  |
|--------------|----------------------|---------------------|----------------|
| C_Sign ^1^   | CKM_XMSSMT (Private) | any                 | 4963-104520^2^ |
| C_Verify ^1^ | CKM_XMSSMT (Public)  | any, 4963-104520^2^ | N/A            |
table: XMSS^MT^ without hashing: Key and Data Length

^1^ Single-part operations only.

^2^ Smallest and largest signature sizes from [RFC 8391], including optional
parameter sets.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used and must be set to 0.
