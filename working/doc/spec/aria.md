## ARIA

ARIA is a block cipher with 128-bit block size and 128-, 192-, and 256-bit keys,
similar to AES. ARIA is described in NSRI “Specification of ARIA”.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_ARIA_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_ECB                         |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_CBC                         |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_CBC_PAD                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_MAC_GENERAL                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_MAC                         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_ECB_ENCRYPT_DATA            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ARIA_CBC_ENCRYPT_DATA            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: ARIA Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_ARIA**” for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_ARIA_KEY_GEN
- CKM_ARIA_ECB
- CKM_ARIA_CBC
- CKM_ARIA_MAC
- CKM_ARIA_MAC_GENERAL
- CKM_ARIA_CBC_PAD

### Aria secret key objects

ARIA secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_ARIA**)
hold ARIA keys. The following table defines the ARIA secret key object
attributes, in addition to the common attributes defined for this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (16, 24, or 32 bytes)     |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value        |
table: ARIA Secret Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating an ARIA secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_ARIA;
CK_UTF8CHAR label[] = “An ARIA secret key object”;
CK_BYTE value[] = {
###.};
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

### ARIA key generation

The ARIA key generation mechanism, denoted **CKM_ARIA_KEY_GEN**, is a key
generation mechanism for Aria.

It does not have a parameter.

The mechanism generates ARIA keys with a particular length in bytes, as
specified in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the ARIA key type
(specifically, the flags indicating which functions the key supports) may be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ARIA key sizes,
in bytes.

### ARIA-ECB

ARIA-ECB, denoted **CKM_ARIA_ECB**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on Aria and
electronic codebook mode.

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

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input Length  | Output Length  | Comments     |
|-------------|----------|---------------|----------------|--------------|
| C_Encrypt   | CKK_ARIA | multiple of block size | same as input length | no final part |
| C_Decrypt   | CKK_ARIA | multiple of block size | same as input length | no final part |
| C_WrapKey   | CKK_ARIA | any | input length rounded up to multiple of block size | |
| C_UnwrapKey | CKK_ARIA | multiple of block size | determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: ARIA-ECB: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ARIA key sizes,
in bytes.

### ARIA-CBC

ARIA-CBC, denoted **CKM_ARIA_CBC**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on ARIA and
cipher-block chaining mode.

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

| Function    | Key type | Input Length  | Output Length  | Comments     |
|-------------|----------|---------------|----------------|--------------|
| C_Encrypt   | CKK_ARIA | multiple of block size | same as input length | no final part |
| C_Decrypt   | CKK_ARIA | multiple of block size | same as input length | no final part |
| C_WrapKey   | CKK_ARIA | any | input length rounded up to multiple of the block size | |
| C_UnwrapKey | CKK_ARIA | multiple of block size | determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: ARIA-CBC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Aria key sizes,
in bytes.

### ARIA-CBC with PKCS padding

ARIA-CBC with PKCS padding, denoted **CKM_ARIA_CBC_PAD**, is a mechanism for
single- and multiple-part encryption and decryption; key wrapping; and key
unwrapping, based on ARIA; cipher-block chaining mode; and the block cipher
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

| Function    | Key type | Input Length      | Output Length             |
|-------------|----------|-------------------|---------------------------|
| C_Encrypt   | CKK_ARIA | any | input length rounded up to multiple of the block size |
| C_Decrypt   | CKK_ARIA | multiple of block size | between 1 and block size bytes shorter than input length |
| C_WrapKey   | CKK_ARIA | any | input length rounded up to multiple of the block size |
| C_UnwrapKey | CKK_ARIA | multiple of block size | between 1 and block length bytes shorter than input length |
table: ARIA-CBC with PKCS Padding: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ARIA key sizes,
in bytes.

### General-length ARIA-MAC

General-length ARIA -MAC, denoted **CKM_ARIA_MAC_GENERAL**, is a mechanism for
single- and multiple-part signatures and verification, based on ARIA and data
authentication as defined in [FIPS 113].

It has a parameter, a **CK_MAC_GENERAL_PARAMS** structure, which specifies the
output length desired from the mechanism.

The output bytes from this mechanism are taken from the start of the final ARIA
cipher block produced in the MACing process.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length | Signature length                   |
|----------|----------|-------------|------------------------------------|
| C_Sign   | CKK_ARIA | any | 1-block size, as specified in parameters   |
| C_Verify | CKK_ARIA | any | 1-block size, as specified in parameters   |
table: General-length ARIA-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ARIA key sizes,
in bytes.

### ARIA-MAC

ARIA-MAC, denoted by **CKM_ARIA_MAC**, is a special case of the general-length
ARIA-MAC mechanism. ARIA-MAC always produces and verifies MACs that are half the
block size in length.

It does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length | Signature length |
|----------|----------|-------------|------------------|
| C_Sign   | CKK_ARIA | any   | ½ block size (8 bytes) |
| C_Verify | CKK_ARIA | any   | ½ block size (8 bytes) |
table: ARIA-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ARIA key sizes,
in bytes.
