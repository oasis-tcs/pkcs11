## CAMELLIA

Camellia is a block cipher with 128-bit block size and 128-, 192-, and 256-bit
keys, similar to AES. Camellia is described e.g. in IETF [RFC 3713].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_CAMELLIA_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_ECB                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_CBC                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_CBC_PAD                 |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_MAC_GENERAL             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_MAC                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_ECB_ENCRYPT_DATA        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_CAMELLIA_CBC_ENCRYPT_DATA        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Camellia Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_CAMELLIA**” for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_CAMELLIA_KEY_GEN
- CKM_CAMELLIA_ECB
- CKM_CAMELLIA_CBC
- CKM_CAMELLIA_MAC
- CKM_CAMELLIA_MAC_GENERAL
- CKM_CAMELLIA_CBC_PAD

### Camellia secret key objects

Camellia secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_CAMELLIA**) hold Camellia keys. The following table defines the Camellia
secret key object attributes, in addition to the common attributes defined for
this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (16, 24, or 32 bytes)     |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value        |
table: Camellia Secret Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating a Camellia secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_CAMELLIA;
CK_UTF8CHAR label[] = “A Camellia secret key object”;
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

### Camellia key generation

The Camellia key generation mechanism, denoted **CKM_CAMELLIA_KEY_GEN**, is a
key generation mechanism for Camellia.

It does not have a parameter.

The mechanism generates Camellia keys with a particular length in bytes, as
specified in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the Camellia key type
(specifically, the flags indicating which functions the key supports) may be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Camellia key
sizes, in bytes.

### Camellia-ECB

Camellia-ECB, denoted **CKM_CAMELLIA_ECB**, is a mechanism for single- and
multiple-part encryption and decryption; key wrapping; and key unwrapping, based
on Camellia and electronic codebook mode.

It does not have a parameter.

This mechanism can wrap and unwrap any secret key. Of course, a particular token
may not be able to wrap/unwrap every secret key that it supports. For wrapping,
the mechanism encrypts the value of the **CKA_VALUE** attribute of the key that
is wrapped, padded on the trailing end with up to block size minus one null
bytes so that the resulting length is a multiple of the block size. The output
data is the same length as the padded input data. It does not wrap the key type,
key length, or any other information about the key; the application must convey
these separately.

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

Constraints on key types and the length of data are summarized in the following table:

| Function    | Key type     | Input Length  | Output Length  | Comments |
|-------------|--------------|---------------|----------------|----------|
| C_Encrypt   | CKK_CAMELLIA | multiple of block size | same as input length | no final part |
| C_Decrypt   | CKK_CAMELLIA | multiple of block size | same as input length | no final part |
| C_WrapKey   | CKK_CAMELLIA | any | input length rounded up to multiple of block size | |
| C_UnwrapKey | CKK_CAMELLIA | multiple of block size | determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: Camellia-ECB: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Camellia key
sizes, in bytes.

### Camellia-CBC

Camellia-CBC, denoted **CKM_CAMELLIA_CBC**, is a mechanism for single- and
multiple-part encryption and decryption; key wrapping; and key unwrapping, based
on Camellia and cipher-block chaining mode.

It has a parameter, a 16-byte initialization vector.

This mechanism can wrap and unwrap any secret key. Of course, a particular token
may not be able to wrap/unwrap every secret key that it supports. For wrapping,
the mechanism encrypts the value of the **CKA_VALUE** attribute of the key that
is wrapped, padded on the trailing end with up to block size minus one null
bytes so that the resulting length is a multiple of the block size. The output
data is the same length as the padded input data. It does not wrap the key type,
key length, or any other information about the key; the application must convey
these separately.

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type     | Input Length  | Output Length  | Comments |
|-------------|--------------|---------------|----------------|----------|
| C_Encrypt   | CKK_CAMELLIA | multiple of block size | same as input length | no final part |
| C_Decrypt   | CKK_CAMELLIA | multiple of block size | same as input length | no final part |
| C_WrapKey   | CKK_CAMELLIA | any | input length rounded up to multiple of the block size | |
| C_UnwrapKey | CKK_CAMELLIA | multiple of block size | determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: Camellia-CBC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Camellia key
sizes, in bytes.

### Camellia-CBC with PKCS padding

Camellia-CBC with PKCS padding, denoted **CKM_CAMELLIA_CBC_PAD**, is a mechanism
for single- and multiple-part encryption and decryption; key wrapping; and key
unwrapping, based on Camellia; cipher-block chaining mode; and the block cipher
padding method detailed in [PKCS #7].

It has a parameter, a 16-byte initialization vector.

The PKCS padding in this mechanism allows the length of the plaintext value to
be recovered from the ciphertext value. Therefore, when unwrapping keys with
this mechanism, no value should be specified for the **CKA_VALUE_LEN**
attribute.

In addition to being able to wrap and unwrap secret keys, this mechanism can
wrap and unwrap RSA, Diffie-Hellman, X9.42 Diffie-Hellman, short Weierstrass EC
and DSA private keys (see section 6.7 for details). The entries in the table
below for data length constraints when wrapping and unwrapping keys do not apply
to wrapping and unwrapping private keys.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type     | Input Length       | Output Length        |
|-------------|--------------|--------------------|----------------------|
| C_Encrypt   | CKK_CAMELLIA | any | input length rounded up to multiple of the block size |
| C_Decrypt   | CKK_CAMELLIA | multiple of block size | between 1 and block size bytes shorter than input length |
| C_WrapKey   | CKK_CAMELLIA | any | input length rounded up to multiple of the block size |
| C_UnwrapKey | CKK_CAMELLIA | multiple of block size | between 1 and block length bytes shorter than input length |
table: Camellia-CBC with PKCS Padding: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Camellia key
sizes, in bytes.

### CAMELLIA with Counter mechanism parameters 

#### CK_CAMELLIA_CTR_PARAMS
\  

**CK_CAMELLIA_CTR_PARAMS** is a structure that provides the parameters to the
**CKM_CAMELLIA_CTR** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_CAMELLIA_CTR_PARAMS {
    CK_ULONG ulCounterBits;
    CK_BYTE cb[16];
} CK_CAMELLIA_CTR_PARAMS;
~~~

_ulCounterBits_ specifies the number of bits in the counter block (cb) that
shall be incremented. This number  shall be such that 0 < _ulCounterBits_ ≤ 128.
For any values outside this range the mechanism shall return
**CKR_MECHANISM_PARAM_INVALID**.

It's up to the caller to initialize all of the bits in the counter block
including the counter bits. The counter bits are the least significant bits of
the counter block (cb). They are a big-endian value usually starting with 1. The
rest of ‘cb’ is for the nonce, and maybe an optional IV.

E.g. as defined in [RFC 3686]:

~~~
    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                            Nonce                              |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                  Initialization Vector (IV)                   |
   |                                                               |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                         Block Counter                         |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

This construction permits each packet to consist of up to 2^32^-1 blocks =
4,294,967,295 blocks = 68,719,476,720 octets.

**CK_CAMELLIA_CTR_PARAMS_PTR** is a pointer to a **CK_CAMELLIA_CTR_PARAMS**.


### General-length Camellia-MAC

General-length Camellia -MAC, denoted **CKM_CAMELLIA_MAC_GENERAL**, is a
mechanism for single- and multiple-part signatures and verification, based on
Camellia  and data authentication as defined in [CAMELLIA]. It has a parameter,
a **CK_MAC_GENERAL_PARAMS** structure, which specifies the output length desired
from the mechanism.

The output bytes from this mechanism are taken from the start of the final
Camellia cipher block produced in the MACing process.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type     | Data length | Signature length                 |
|----------|--------------|-------------|----------------------------------|
| C_Sign   | CKK_CAMELLIA | any	1-block | size, as specified in parameters |
| C_Verify | CKK_CAMELLIA | any	1-block | size, as specified in parameters |
table: General-length Camellia-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Camellia key
sizes, in bytes.

### Camellia-MAC

Camellia-MAC, denoted by **CKM_CAMELLIA_MAC**, is a special case of the
general-length Camellia-MAC mechanism. Camellia-MAC always produces and verifies
MACs that are half the block size in length.  It does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type     | Data length | Signature length               |
|----------|--------------|-------------|--------------------------------|
| C_Sign   | CKK_CAMELLIA | any         | ½ block size (8 bytes)         |
| C_Verify | CKK_CAMELLIA | any         | ½ block size (8 bytes)         |
table: Camellia-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Camellia key
sizes, in bytes.
