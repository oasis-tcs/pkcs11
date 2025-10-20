## Double and Triple-length DES

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_DES2_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_ECB                         |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_CBC                         |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_CBC_PAD                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_MAC_GENERAL                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_MAC                         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Double and Triple-Length DES Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_DES2**” and “**CKK_DES3**” for type
CK_KEY_TYPE as used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_DES2_KEY_GEN
- CKM_DES3_KEY_GEN
- CKM_DES3_ECB
- CKM_DES3_CBC
- CKM_DES3_MAC
- CKM_DES3_MAC_GENERAL
- CKM_DES3_CBC_PAD

### DES2 secret key objects

DES2 secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_DES2**)
hold double-length DES keys. The following table defines the DES2 secret key
object attributes, in addition to the common attributes defined for this object
class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ |	Byte array | Key value (always 16 bytes long)    |
table: DES2 Secret Key Object Attributes

- Refer to Table 13 for footnotes

DES2 keys must always have their parity bits properly set as described in [FIPS
PUB 46-3] (i.e., each of the DES keys comprising a DES2 key must have its parity
bits properly set). Attempting to create or unwrap a DES2 key with incorrect
parity will return an error.

The following is a sample template for creating a double-length DES secret key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_DES2;
CK_UTF8CHAR label[] = “A DES2 secret key object”;
CK_BYTE value[16] = {...};
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

**CKA_CHECK_VALUE**: The value of this attribute is derived from the key object
by taking the first three bytes of the ECB encryption of a single block of null
(0x00) bytes, using the default cipher associated with the key type of the
secret key object.

### DES3 secret key objects

DES3 secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_DES3**)
hold triple-length DES keys. The following table defines the DES3 secret key
object attributes, in addition to the common attributes defined for this object
class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (always 24 bytes long)    |
table: DES3 Secret Key Object Attributes

- Refer to Table 13 for footnotes

DES3 keys must always have their parity bits properly set as described in [FIPS
PUB 46-3] (i.e., each of the DES keys comprising a DES3 key must have its parity
bits properly set). Attempting to create or unwrap a DES3 key with incorrect
parity will return an error.

The following is a sample template for creating a triple-length DES secret key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_DES3;
CK_UTF8CHAR label[] = “A DES3 secret key object”;
CK_BYTE value[24] = {...};
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

**CKA_CHECK_VALUE**: The value of this attribute is derived from the key object
by taking the first three bytes of the ECB encryption of a single block of null
(0x00) bytes, using the default cipher associated with the key type of the
secret key object.

### Double-length DES key generation

The double-length DES key generation mechanism, denoted **CKM_DES2_KEY_GEN**, is
a key generation mechanism for double-length DES keys. The DES keys making up a
double-length DES key both have their parity bits set properly, as specified in
[FIPS PUB 46-3].

It does not have a parameter.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the double-length DES
key type (specifically, the flags indicating which functions the key supports)
may be specified in the template for the key, or else are assigned default
initial values.

Double-length DES keys can be used with all the same mechanisms as triple-DES
keys: **CKM_DES3_ECB**, **CKM_DES3_CBC**, **CKM_DES3_CBC_PAD**,
**CKM_DES3_MAC_GENERAL**, and **CKM_DES3_MAC**. Triple-DES encryption with a
double-length DES key is equivalent to encryption with a triple-length DES key
with K1=K3 as specified in [FIPS PUB 46-3].

When double-length DES keys are generated, it is token-dependent whether or not
it is possible for either of the component DES keys to be “weak” or “semi-weak”
keys.

### Triple-length DES Order of Operations

Triple-length DES encryptions are carried out as specified in [FIPS PUB 46-3]:
encrypt, decrypt, encrypt. Decryptions are carried out with the opposite three
steps: decrypt, encrypt, decrypt. The mathematical representations of the
encrypt and decrypt operations are as follows:

~~~
DES3-E({K1,K2,K3}, P) = E(K3, D(K2, E(K1, P)))
DES3-D({K1,K2,K3}, C) = D(K1, E(K2, D(K3, P)))
~~~

### Triple-length DES in CBC Mode

Triple-length DES operations in CBC mode, with double or triple-length keys, are
performed using TRIPLE DATA ENCRYPTION ALGORITHM (TDEA) A Cipher Block Chaining
Mode 

of Operation (TCBC) as defined in [FIPS PUB 46-3]. The mathematical
representations of the CBC encrypt and decrypt operations are as follows:

~~~
DES3-CBC-E({K1,K2,K3}, P) = E(K3, D(K2, E(K1, P + I)))
DES3-CBC-D({K1,K2,K3}, C) = D(K1, E(K2, D(K3, P))) + I
~~~

The value I is either an 8-byte initialization vector or the previous block of
ciphertext that is added to the current input block. The addition operation is
used is addition modulo-2 (XOR).

### DES and Triple length DES in OFB Mode

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_DES_OFB64                        |  ✓  |     |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES_OFB8                         |  ✓  |     |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES_CFB64                        |  ✓  |     |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES_CFB8                         |  ✓  |     |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: DES and Triple Length DES in OFB Mode Mechanisms vs. Functions

Cipher DES has a output feedback mode, DES-OFB, denoted **CKM_DES_OFB8** and
**CKM_DES_OFB64**. It is a mechanism for single and multiple-part encryption and
decryption with DES.

It has a parameter, an initialization vector for this mode. The initialization
vector has the same length as the block size.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type    | Input length | Output length  | Comments     |
|-----------|:-----------:|:------------:|:--------------:|:------------:|
| C_Encrypt | CKK_DES, CKK_DES2, CKK_DES3 | any | same as input length | no final part |
| C_Decrypt | CKK_DES, CKK_DES2, CKK_DES3 | any | same as input length | no final part |
table: OFB: Key And Data Length

For this mechanism the **CK_MECHANISM_INFO** structure is as specified for CBC
mode.

### DES and Triple length DES in CFB Mode

Cipher DES has a cipher feedback mode, DES-CFB, denoted **CKM_DES_CFB8** and
**CKM_DES_CFB64**. It is a mechanism for single and multiple-part encryption and
decryption with DES.

It has a parameter, an initialization vector for this mode. The initialization
vector has the same length as the block size.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type    | Input length | Output length  | Comments     |
|-----------|:-----------:|:------------:|:--------------:|:------------:|
| C_Encrypt | CKK_DES, CKK_DES2, CKK_DES3 | any | same as input length | no final part |
| C_Decrypt | CKK_DES, CKK_DES2, CKK_DES3 | any | same as input length | no final part |
table: CFB: Key And Data Length

For this mechanism the **CK_MECHANISM_INFO** structure is as specified for CBC
mode.
