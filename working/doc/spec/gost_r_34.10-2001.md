## GOST R 34.10-2001

GOST R 34.10-2001 is a mechanism for single- and multiple-part signatures and
verification, following the digital signature algorithm defined in [GOST R
34.10-2001].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_GOSTR3410_KEY_PAIR_GEN           |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_GOSTR3410                        |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_GOSTR3410_WITH_GOSTR3411         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_GOSTR3410_KEY_WRAP               |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_GOSTR3410_DERIVE                 |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: GOST R34.10-2001 Mechanisms vs. Functions

^1^ Single-part operations only

### Definitions 

This section defines the key type “**CKK_GOSTR3410**” for type **CK_KEY_TYPE**
as used in the **CKA_KEY_TYPE** attribute of key objects and domain parameter
objects.

Mechanisms:

- CKM_GOSTR3410_KEY_PAIR_GEN
- CKM_GOSTR3410
- CKM_GOSTR3410_WITH_GOSTR3411
- CKM_GOSTR3410
- CKM_GOSTR3410_KEY_WRAP
- CKM_GOSTR3410_DERIVE

### GOST R 34.10-2001 public key objects

GOST R 34.10-2001 public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_GOSTR3410**) hold GOST R 34.10-2001 public keys.

The following table defines the GOST R 34.10-2001 public key object attributes,
in addition to the common attributes defined for this object class:

| Attribute                    | Data Type  | Meaning                        |
|------------------------------|------------|--------------------------------|
| CKA_VALUE ^1,4^              | Byte array | 64 bytes for public key; 32 bytes for each coordinates X and Y of Elliptic Curve point P(X, Y) in little endian order |
| CKA_GOSTR3410_PARAMS ^1,3^   | Byte array | DER-encoding of the object identifier indicating the data object type of GOST R 34.10-2001.  |
|                              |            | When key is used the domain parameter object of key type CKK_GOSTR3410 must be specified with the same attribute CKA_OBJECT_ID |
| CKA_GOSTR3411_PARAMS ^1,3,8^ | Byte array | DER-encoding of the object identifier indicating the data object type of GOST R 34.11-94.  |
|                              |            | When key is used the domain parameter object of key type CKK_GOSTR3411 must be specified with the same attribute CKA_OBJECT_ID |
| CKA_GOST28147_PARAMS ^8^     | Byte array | DER-encoding of the object identifier indicating the data object type of GOST 28147‑89. |
|                              |            | When key is used the domain parameter object of key type CKK_GOST28147 must be specified with the same attribute CKA_OBJECT_ID. The attribute value may be omitted |
table: GOST R 34.10-2001 Public Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating an GOST R 34.10-2001 public key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_GOSTR3410;
CK_UTF8CHAR label[] = “A GOST R34.10-2001 public key object”;
CK_BYTE gostR3410params_oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x23, 0x00};
CK_BYTE gostR3411params_oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x1e, 0x00};
CK_BYTE gost28147params_oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x1f, 0x00};
CK_BYTE value[64] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
    {CKA_CLASS, &class, sizeof(class)},
    {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
    {CKA_TOKEN, &true, sizeof(true)},
    {CKA_LABEL, label, sizeof(label)-1},
    {CKA_GOSTR3410_PARAMS, gostR3410params_oid, sizeof(gostR3410params_oid)},
    {CKA_GOSTR3411_PARAMS, gostR3411params_oid, sizeof(gostR3411params_oid)},
    {CKA_GOST28147_PARAMS, gost28147params_oid, sizeof(gost28147params_oid)},
    {CKA_VALUE, value, sizeof(value)}
};
~~~

### GOST R 34.10-2001 private key objects

GOST R 34.10-2001 private key objects (object class **CKO_PRIVATE_KEY**, key
type **CKK_GOSTR3410**) hold GOST R 34.10-2001 private keys.

The following table defines the GOST R 34.10-2001 private key object attributes,
in addition to the common attributes defined for this object class:

| Attribute                      | Data Type  | Meaning                      |
|--------------------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^            | Byte array | 32 bytes for private key in little endian order |
| CKA_GOSTR3410_PARAMS ^1,4,6^   | Byte array | DER-encoding of the object identifier indicating the data object type of GOST R 34.10-2001. |
| When key is used the domain parameter object of key type CKK_GOSTR3410 must be specified with the same attribute CKA_OBJECT_ID  |
| CKA_GOSTR3411_PARAMS ^1,4,6,8^ | Byte array | DER-encoding of the object identifier indicating the data object type of GOST R 34.11-94. |
| When key is used the domain parameter object of key type CKK_GOSTR3411 must be specified with the same attribute CKA_OBJECT_ID |
| CKA_GOST28147_PARAMS ^4,6,8^   | Byte array | DER-encoding of the object identifier indicating the data object type of GOST 28147‑89. |
| When key is used the domain parameter object of key type CKK_GOST28147 must be specified with the same attribute CKA_OBJECT_ID. The attribute value may be omitted |
table: GOST R 34.10-2001 Private Key Object Attributes

- Refer to Table 13 for footnotes

Note that when generating an GOST R 34.10-2001 private key, the
GOST R 34.10-2001 domain parameters are not specified in the key’s template.
This is because GOST R 34.10-2001 private keys are only generated as part of an
GOST R 34.10-2001 key pair, and the GOST R 34.10-2001 domain parameters for the
pair are specified in the template for the GOST R 34.10-2001 public key.

The following is a sample template for creating an GOST R 34.10-2001 private key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_GOSTR3410;
CK_UTF8CHAR label[] = “A GOST R34.10-2001 private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE gostR3410params_oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x23, 0x00};
CK_BYTE gostR3411params_oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x1e, 0x00};
CK_BYTE gost28147params_oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x1f, 0x00};
CK_BYTE value[32] = {...};
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
    {CKA_GOSTR3410_PARAMS, gostR3410params_oid, sizeof(gostR3410params_oid)},
    {CKA_GOSTR3411_PARAMS, gostR3411params_oid, sizeof(gostR3411params_oid)},
    {CKA_GOST28147_PARAMS, gost28147params_oid, sizeof(gost28147params_oid)},
    {CKA_VALUE, value, sizeof(value)}
};
~~~

### GOST R 34.10-2001 domain parameter objects

GOST R 34.10-2001 domain parameter objects (object class
**CKO_DOMAIN_PARAMETERS**, key type **CKK_GOSTR3410**) hold GOST R 34.10‑2001
domain parameters.

The following table defines the GOST R 34.10-2001 domain parameter object
attributes, in addition to the common attributes defined for this object class:

| Attribute         | Data Type  | Meaning                                   |
|-------------------|------------|-------------------------------------------|
| CKA_VALUE ^1^     | Byte array | DER-encoding of the domain parameters as it was introduced in [4] section 8.4 (type GostR3410-2001-ParamSetParameters) |
| CKA_OBJECT_ID ^1^ | Byte array | DER-encoding of the object identifier indicating the domain parameters  |
table: GOST R 34.10-2001 Domain Parameter Object Attributes

- Refer to Table 13 for footnotes

For any particular token, there is no guarantee that a token supports domain
parameters loading up and/or fetching out. Furthermore, applications, that make
direct use of domain parameters objects, should take in account that
**CKA_VALUE** attribute may be inaccessible.

The following is a sample template for creating a GOST R 34.10-2001 domain
parameter object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_DOMAIN_PARAMETERS;
CK_KEY_TYPE keyType = CKK_GOSTR3410;
CK_UTF8CHAR label[] = “A GOST R34.10-2001 cryptographic parameters object”;
CK_BYTE oid[] = 
    {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x23, 0x00};
CK_BYTE value[] = {
    0x30,0x81,0x90,0x02,0x01,0x07,0x02,0x20,0x5f,0xbf,0xf4,0x98,
    0xaa,0x93,0x8c,0xe7,0x39,0xb8,0xe0,0x22,0xfb,0xaf,0xef,0x40,
    0x56,0x3f,0x6e,0x6a,0x34,0x72,0xfc,0x2a,0x51,0x4c,0x0c,0xe9,
    0xda,0xe2,0x3b,0x7e,0x02,0x21,0x00,0x80,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x04,0x31,0x02,0x21,0x00,0x80,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x50,0xfe,
    0x8a,0x18,0x92,0x97,0x61,0x54,0xc5,0x9c,0xfc,0x19,0x3a,0xcc,
    0xf5,0xb3,0x02,0x01,0x02,0x02,0x20,0x08,0xe2,0xa8,0xa0,0xe6,
    0x51,0x47,0xd4,0xbd,0x63,0x16,0x03,0x0e,0x16,0xd1,0x9c,0x85,
    0xc9,0x7f,0x0a,0x9c,0xa2,0x67,0x12,0x2b,0x96,0xab,0xbc,0xea,
    0x7e,0x8f,0xc8
};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
    {CKA_CLASS, &class, sizeof(class)},
    {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
    {CKA_TOKEN, &true, sizeof(true)},
    {CKA_LABEL, label, sizeof(label)-1},
    {CKA_OBJECT_ID, oid, sizeof(oid)},
    {CKA_VALUE, value, sizeof(value)}
};
~~~

### GOST R 34.10-2001 mechanism parameters 

#### CK_GOSTR3410_KEY_WRAP_PARAMS
\  

**CK_GOSTR3410_KEY_WRAP_PARAMS** is a structure that provides the parameters to
the **CKM_GOSTR3410_KEY_WRAP** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_GOSTR3410_KEY_WRAP_PARAMS {
    CK_BYTE_PTR      pWrapOID;
    CK_ULONG         ulWrapOIDLen;
    CK_BYTE_PTR      pUKM;
    CK_ULONG         ulUKMLen;
    CK_OBJECT_HANDLE hKey;
} CK_GOSTR3410_KEY_WRAP_PARAMS;
~~~

The fields of the structure have the following meanings:


_pWrapOID_
: pointer to a data with DER-encoding of the object identifier indicating the
  data object type of GOST 28147‑89. If pointer takes NULL_PTR value in
  **C_WrapKey** operation then parameters are specified in object identifier of
  attribute **CKA_GOSTR3411_PARAMS** must be used. For **C_UnwrapKey** operation
  the pointer is not used and must take NULL_PTR value anytime

_ulWrapOIDLen_
: length of data with DER-encoding of the object identifier indicating the data
  object type of GOST 28147‑89

_pUKM_
: pointer to a data with UKM. If pointer takes NULL_PTR value in **C_WrapKey**
  operation, then random value of UKM will be used. If pointer takes
  non-NULL_PTR value in **C_UnwrapKey** operation, then the pointer value will
  be compared with UKM value of wrapped key. If these two values do not match
  the wrapped key will be rejected

_ulUKMLen_
: length of UKM data. If pUKM-pointer is different from NULL_PTR then equal to 8 

_hKey_
: key handle. Key handle of a sender for **C_WrapKey** operation. Key handle of
  a receiver for **C_UnwrapKey** operation. When key handle takes
  **CK_INVALID_HANDLE** value then an ephemeral (one time) key pair of a sender
  will be used

**CK_GOSTR3410_KEY_WRAP_PARAMS_PTR** is a pointer to a
**CK_GOSTR3410_KEY_WRAP_PARAMS**.

#### CK_GOSTR3410_DERIVE_PARAMS
\  

**CK_GOSTR3410_DERIVE_PARAMS** is a structure that provides the parameters to
the **CKM_GOSTR3410_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_GOSTR3410_DERIVE_PARAMS { 
    CK_EC_KDF_TYPE kdf; 
    CK_BYTE_PTR    pPublicData; 
    CK_ULONG       ulPublicDataLen; 
    CK_BYTE_PTR    pUKM; 
    CK_ULONG       ulUKMLen; 
} CK_GOSTR3410_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: additional key diversification algorithm identifier. Possible values are
  **CKD_NULL** and **CKD_CPDIVERSIFY_KDF**. In case of **CKD_NULL**, the result
  of the key derivation function described in [RFC 4357], section 5.2 is used
  directly. In case of **CKD_CPDIVERSIFY_KDF**, the resulting key value is
  additionally processed with algorithm from [RFC 4357], section [6.5].

_pPublicData_ ^1^
: pointer to data with public key of a receiver

_ulPublicDataLen_
: length of data with public key of a receiver (must be 64)

_pUKM_
: pointer to a UKM data 

_ulUKMLen_
: length of UKM data in bytes (must be 8)

^1^ Public key of a receiver is an octet string of 64 bytes long. The public key
octets correspond to the concatenation of X and Y coordinates of a point. Any
one of them is 32 bytes long and represented in little endian order.
CK_GOSTR3410_DERIVE_PARAMS_PTR is a pointer to a CK_GOSTR3410_DERIVE_PARAMS.

### GOST R 34.10-2001 key pair generation

The GOST R 34.10‑2001 key pair generation mechanism, denoted
**CKM_GOSTR3410_KEY_PAIR_GEN**, is a key pair generation mechanism for
GOST R 34.10‑2001.

This mechanism does not have a parameter.

The mechanism generates GOST R 34.10‑2001 public/private key pairs with
particular GOST R 34.10‑2001 domain parameters, as specified in the
**CKA_GOSTR3410_PARAMS**, **CKA_GOSTR3411_PARAMS**, and **CKA_GOST28147_PARAMS**
attributes of the template for the public key. Note that
**CKA_GOST28147_PARAMS** attribute may not be present in the template.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_VALUE**, and **CKA_GOSTR3410_PARAMS**, **CKA_GOSTR3411_PARAMS**,
**CKA_GOST28147_PARAMS** attributes to the new private key.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used.

### GOST R 34.10-2001 without hashing

The GOST R 34.10‑2001 without hashing mechanism, denoted **CKM_GOSTR3410**, is a
mechanism for single-part signatures and verification for GOST R 34.10‑2001.
(This mechanism corresponds only to the part of GOST R 34.10‑2001 that processes
the 32-bytes hash value; it does not compute the hash value.)

This mechanism does not have a parameter.

For the purposes of these mechanisms, a GOST R 34.10‑2001 signature is an octet
string of 64 bytes long. The signature octets correspond to the concatenation of
the GOST R 34.10‑2001 values _s_ and _r’_, both represented as a 32 bytes octet
string in big endian order with the most significant byte first [RFC 4490]
section 3.2, and [RFC 4491] section 2.2.2.

The input for the mechanism is an octet string of 32 bytes long with digest has
computed by means of GOST R 34.11‑94 hash algorithm in the context of signed or
should be signed message.

| Function     | Key type      | Input length | Output length |
|--------------|---------------|--------------|---------------|
| C_Sign ^1^   | CKK_GOSTR3410 | 32 bytes     | 64 bytes      |
| C_Verify ^1^ | CKK_GOSTR3410 | 32 bytes     | 64 bytes      |
table: GOST R 34.10-2001 without hashing: Key and Data Length

^1^ Single-part operations only.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used.

### GOST R 34.10-2001 with GOST R 34.11-94

The GOST R 34.10‑2001 with GOST R 34.11‑94, denoted
**CKM_GOSTR3410_WITH_GOSTR3411**, is a mechanism for signatures and verification
for GOST R 34.10‑2001. This mechanism computes the entire GOST R 34.10‑2001
specification, including the hashing with GOST R 34.11‑94 hash algorithm.

As a parameter this mechanism utilizes a DER-encoding of the object identifier
indicating GOST R 34.11‑94 data object type. A mechanism parameter may be missed
then parameters are specified in object identifier of attribute
**CKA_GOSTR3411_PARAMS** must be used.

For the purposes of these mechanisms, a GOST R 34.10‑2001 signature is an octet
string of 64 bytes long. The signature octets correspond to the concatenation of
the GOST R 34.10‑2001 values _s_ and _r’_, both represented as a 32 bytes octet
string in big endian order with the most significant byte first [RFC 4490]
section 3.2, and [RFC 4491] section 2.2.2.

The input for the mechanism is signed or should be signed message of any length.
Single- and multiple-part signature operations are available.

| Function | Key type      | Input length | Output length |
|----------|---------------|--------------|---------------|
| C_Sign   | CKK_GOSTR3410 | Any          | 64 bytes      |
| C_Verify | CKK_GOSTR3410 | Any          | 64 bytes      |
table: GOST R 34.10-2001 with GOST R 34.11-94: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used.

### GOST 28147-89 keys wrapping/unwrapping with GOST R 34.10-2001

GOST R 34.10-2001 keys as a KEK (key encryption keys) for encryption GOST 28147
keys, denoted by **CKM_GOSTR3410_KEY_WRAP**, is a mechanism for key wrapping;
and key unwrapping, based on GOST R 34.10-2001. Its purpose is to encrypt and
decrypt keys have been generated by key generation mechanism for GOST 28147‑89.
An encryption algorithm from [RFC 4490] (section 5.2) must be used. Encrypted
key is a DER-encoded structure of ASN.1 GostR3410-KeyTransport type [RFC 4490]
section 4.2.

It has a parameter, a **CK_GOSTR3410_KEY_WRAP_PARAMS** structure defined in
section 6.57.5.

For unwrapping (**C_UnwrapKey**), the mechanism decrypts the wrapped key, and
contributes the result as the **CKA_VALUE** attribute of the new key.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure are not used.

### Common key derivation with assistance of GOST R 34.10-2001 keys

Common key derivation, denoted **CKM_GOSTR3410_DERIVE**, is a mechanism for key
derivation with assistance of GOST R 34.10‑2001 private and public keys. The key
of the mechanism must be of object class **CKO_DOMAIN_PARAMETERS** and key type
**CKK_GOSTR3410**. An algorithm for key derivation from [RFC 4357] (section 5.2)
must be used.

The mechanism contributes the result as the **CKA_VALUE** attribute of the new
private key. All other attributes must be specified in a template for creating
private key object.
