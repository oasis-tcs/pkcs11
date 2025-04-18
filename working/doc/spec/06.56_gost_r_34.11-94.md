## GOST R 34.11-94 

GOST R 34.11-94 is a mechanism for message digesting, following the hash
algorithm with 256-bit message digest defined in [GOST R 34.11-94].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_GOSTR3411                        |     |     |      |  ✓  |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_GOSTR3411_HMAC                   |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: GOST R 34.11-94 Mechanisms vs. Functions

### Definitions 

This section defines the key type “**CKK_GOSTR3411**” for type **CK_KEY_TYPE**
as used in the **CKA_KEY_TYPE** attribute of domain parameter objects.

Mechanisms:

- CKM_GOSTR3411
- CKM_GOSTR3411_HMAC

### GOST R 34.11-94 domain parameter objects

GOST R 34.11-94 domain parameter objects (object class
**CKO_DOMAIN_PARAMETERS**, key type **CKK_GOSTR3411**) hold GOST R 34.11-94
domain parameters. 

The following table defines the GOST R 34.11-94 domain parameter object
attributes, in addition to the common attributes defined for this object class:

| Attribute         | Data Type  | Meaning                                   |
|-------------------|------------|-------------------------------------------|
| CKA_VALUE ^1^     | Byte array | DER-encoding of the domain parameters as it was introduced in [4] section 8.2 (type GostR3411-94-ParamSetParameters) |
| CKA_OBJECT_ID ^1^ | Byte array | DER-encoding of the object identifier indicating the domain parameters  |
table: GOST R 34.11-94 Domain Parameter Object Attributes

- Refer to Table 13 for footnotes

For any particular token, there is no guarantee that a token supports domain
parameters loading up and/or fetching out. Furthermore, applications, that make
direct use of domain parameters objects, should take in account that
**CKA_VALUE** attribute may be inaccessible.

The following is a sample template for creating a GOST R 34.11-94 domain
parameter object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_DOMAIN_PARAMETERS;
CK_KEY_TYPE keyType = CKK_GOSTR3411;
CK_UTF8CHAR label[] = “A GOST R34.11-94 cryptographic parameters object”;
CK_BYTE oid[] = {0x06, 0x07, 0x2a, 0x85, 0x03, 0x02, 0x02, 0x1e, 0x00};
CK_BYTE value[] = {
	0x30,0x64,0x04,0x40,0x4e,0x57,0x64,0xd1,0xab,0x8d,0xcb,0xbf,
	0x94,0x1a,0x7a,0x4d,0x2c,0xd1,0x10,0x10,0xd6,0xa0,0x57,0x35,
	0x8d,0x38,0xf2,0xf7,0x0f,0x49,0xd1,0x5a,0xea,0x2f,0x8d,0x94,
	0x62,0xee,0x43,0x09,0xb3,0xf4,0xa6,0xa2,0x18,0xc6,0x98,0xe3,
	0xc1,0x7c,0xe5,0x7e,0x70,0x6b,0x09,0x66,0xf7,0x02,0x3c,0x8b,
	0x55,0x95,0xbf,0x28,0x39,0xb3,0x2e,0xcc,0x04,0x20,0x00,0x00,
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,0x00,0x00
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

### GOST R 34.11-94 digest

GOST R 34.11-94 digest, denoted **CKM_GOSTR3411**, is a mechanism for message
digesting based on GOST R 34.11-94 hash algorithm [GOST R 34.11-94].

As a parameter this mechanism utilizes a DER-encoding of the object identifier.
A mechanism parameter may be missed then parameters of the object identifier
id-GostR3411-94-CryptoProParamSet [RFC 4357] (section 11.2) must be used.

Constraints on the length of input and output data are summarized in the
following table. For single-part digesting, the data and the digest may begin at
the same location in memory.

| Function | Input length | Digest length |
|----------|--------------|---------------|
| C_Digest | Any          | 32 bytes      |
table: GOST R 34.11-94: Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used.

### GOST R 34.11-94 HMAC

GOST R 34.11-94 HMAC mechanism, denoted **CKM_GOSTR3411_HMAC**, is a mechanism
for signatures and verification. It uses the HMAC construction, based on the
GOST R 34.11-94 hash function [GOST R 34.11-94] and core HMAC algorithm [RFC
2104]. The keys it uses are of generic key type **CKK_GENERIC_SECRET** or
**CKK_GOST28147**.

To be conformed to GOST R 34.11-94 hash algorithm [GOST R 34.11-94] the block
length of core HMAC algorithm is 32 bytes long (see [RFC 2104] section 2, and
[RFC 4357] section 3).

As a parameter this mechanism utilizes a DER-encoding of the object identifier.
A mechanism parameter may be missed then parameters of the object identifier
id-GostR3411-94-CryptoProParamSet [RFC 4357] (section 11.2) must be used.

Signatures (MACs) produced by this mechanism are of 32 bytes long.

Constraints on the length of input and output data are summarized in the
following table:

| Function | Key type                    | Data length | Signature length  |
|----------|-----------------------------|-------------|-------------------|
| C_Sign   | CKK_GENERIC_SECRET or CKK_GOST28147 | Any | 32 bytes          |
| C_Verify | CKK_GENERIC_SECRET or CKK_GOST28147 | Any | 32 bytes          |
table: GOST R 34.11-94 HMAC: Key And Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used.
