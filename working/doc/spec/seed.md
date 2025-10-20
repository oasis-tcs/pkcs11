## SEED

SEED is a symmetric block cipher developed by the South Korean Information
Security Agency (KISA). It has a 128-bit key size and a 128-bit block size.

Its specification has been published as Internet [RFC 4269].

RFCs have been published defining the use of SEED in

TLS
: <https://www.rfc-editor.org/rfc/rfc4162.txt>

IPsec
: <https://www.rfc-editor.org/rfc/rfc4196.txt>

CMS
: <https://www.rfc-editor.org/rfc/rfc4010.txt>

TLS cipher suites that use SEED include:

~~~
  CipherSuite TLS_RSA_WITH_SEED_CBC_SHA      = { 0x00, 0x96};
  CipherSuite TLS_DH_DSS_WITH_SEED_CBC_SHA   = { 0x00, 0x97};
  CipherSuite TLS_DH_RSA_WITH_SEED_CBC_SHA   = { 0x00, 0x98};
  CipherSuite TLS_DHE_DSS_WITH_SEED_CBC_SHA  = { 0x00, 0x99};
  CipherSuite TLS_DHE_RSA_WITH_SEED_CBC_SHA  = { 0x00, 0x9A};
  CipherSuite TLS_DH_anon_WITH_SEED_CBC_SHA  = { 0x00, 0x9B};
~~~

As with any block cipher, it can be used in the ECB, CBC, OFB and CFB modes of
operation, as well as in a MAC algorithm such as HMAC.

OIDs have been published for all these uses. A list may be seen at
http://www.alvestrand.no/objectid/1.2.410.200004.1.html

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SEED_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_ECB                         |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_CBC                         |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_CBC_PAD                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_MAC_GENERAL                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_MAC                         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_ECB_ENCRYPT_DATA            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SEED_CBC_ENCRYPT_DATA            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SEED Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_SEED**” for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_SEED_KEY_GEN
- CKM_SEED_ECB
- CKM_SEED_CBC
- CKM_SEED_MAC
- CKM_SEED_MAC_GENERAL
- CKM_SEED_CBC_PAD

For all of these mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** are always 16.

### SEED secret key objects

SEED secret key objects (object class CKO_SECRET_KEY, key type CKK_SEED) hold SEED keys. The following table defines the secret key object attributes, in addition to the common attributes defined for this object class:

| Attribute           | Data type  | Meaning                          |
|---------------------|------------|----------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (always 16 bytes long) |
table: SEED Secret Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating a SEED secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_SEED;
CK_UTF8CHAR label[] = “A SEED secret key object”;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### SEED key generation

The SEED key generation mechanism, denoted **CKM_SEED_KEY_GEN**, is a key
generation mechanism for SEED.

It does not have a parameter.

The mechanism generates SEED keys.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the SEED key type
(specifically, the flags indicating which functions the key supports) may be
specified in the template for the key, or else are assigned default initial
values.

### SEED-ECB

SEED-ECB, denoted **CKM_SEED_ECB**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on SEED and
electronic codebook mode.

It does not have a parameter.

### SEED-CBC

SEED-CBC, denoted **CKM_SEED_CBC**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on SEED and
cipher-block chaining mode.

It has a parameter, a 16-byte initialization vector.

### SEED-CBC with PKCS padding

SEED-CBC with PKCS padding, denoted **CKM_SEED_CBC_PAD**, is a mechanism for
single- and multiple-part encryption and decryption; key wrapping; and key
unwrapping, based on SEED; cipher-block chaining mode; and the block cipher
padding method detailed in [PKCS #7].

It has a parameter, a 16-byte initialization vector.

### General-length SEED-MAC

General-length SEED-MAC, denoted **CKM_SEED_MAC_GENERAL**, is a mechanism for
single- and multiple-part signatures and verification, based on SEED and data
authentication.

It has a parameter, a **CK_MAC_GENERAL_PARAMS** structure, which specifies the
output length desired from the mechanism.

The output bytes from this mechanism are taken from the start of the final
cipher block produced in the MACing process.

### SEED-MAC

SEED-MAC, denoted by **CKM_SEED_MAC**, is a special case of the general-length
SEED-MAC mechanism. SEED-MAC always produces and verifies MACs that are half the
block size in length.

It does not have a parameter.
