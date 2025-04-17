## Blowfish

Blowfish, a secret-key block cipher. It is a Feistel network, iterating a simple
encryption function 16 times. The block size is 64 bits, and the key can be any
length up to 448 bits. Although there is a complex initialization phase required
before any encryption can take place, the actual encryption of data is very
efficient on large microprocessors. See [BLOWFISH] for details.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_BLOWFISH_KEY_GEN                 |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLOWFISH_CBC                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_BLOWFISH_CBC_PAD                 |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Blowfish Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_BLOWFISH**” for type **CK_KEY_TYPE** as
used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_BLOWFISH_KEY_GEN
- CKM_BLOWFISH_CBC
- CKM_BLOWFISH_CBC_PAD

### BLOWFISH secret key objects

Blowfish secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_BLOWFISH**) hold Blowfish keys. The following table defines the Blowfish
secret key object attributes, in addition to the common attributes defined for
this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value the key can be any length up to 448 bits. Bit length restricted to a byte array. |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value        |
table: BLOWFISH Secret Key Object

- Refer to Table 13 for footnotes

The following is a sample template for creating an Blowfish secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_BLOWFISH;
CK_UTF8CHAR label[] = “A blowfish secret key object”;
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

### Blowfish key generation

The Blowfish key generation mechanism, denoted **CKM_BLOWFISH_KEY_GEN**, is a
key generation mechanism Blowfish.

It does not have a parameter.

The mechanism generates Blowfish keys with a particular length, as specified in
the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the key type
(specifically, the flags indicating which functions the key supports) may be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of key sizes in
bytes.

### Blowfish-CBC

Blowfish-CBC, denoted **CKM_BLOWFISH_CBC**, is a mechanism for single- and
multiple-part encryption and decryption; key wrapping; and key unwrapping.

It has a parameter, a 8-byte initialization vector.

This mechanism can wrap and unwrap any secret key. For wrapping, the mechanism
encrypts the value of the **CKA_VALUE** attribute of the key that is wrapped,
padded on the trailing end with up to block size minus one null bytes so that
the resulting length is a multiple of the block size. The output data is the
same length as the padded input data. It does not wrap the key type, key length,
or any other information about the key; the application must convey these
separately. 

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template. 

Constraints on key types and the length of data are summarized in the following
table: 

| Function    | Key type | Input Length           | Output Length        |
|-------------|----------|------------------------|----------------------|
| C_Encrypt   | BLOWFISH | Multiple of block size | Same as input length |
| C_Decrypt   | BLOWFISH | Multiple of block size | Same as input length |
| C_WrapKey   | BLOWFISH | Any                    | Input length rounded up to multiple of the block size |
| C_UnwrapKey | BLOWFISH | Multiple of block size | Determined by type of key being unwrapped or CKA_VALUE_LEN |
table: BLOWFISH-CBC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of BLOWFISH key
sizes, in bytes. 

### Blowfish-CBC with PKCS padding

Blowfish-CBC-PAD, denoted **CKM_BLOWFISH_CBC_PAD**, is a mechanism for single-
and multiple-part encryption and decryption, key wrapping and key unwrapping,
cipher-block chaining mode and the block cipher padding method detailed in
[PKCS #7].

It has a parameter, a 8-byte initialization vector.

The PKCS padding in this mechanism allows the length of the plaintext value to
be recovered from the ciphertext value. Therefore, when unwrapping keys with
this mechanism, no value should be specified for the **CKA_VALUE_LEN**
attribute.

The entries in the table below for data length constraints when wrapping and
unwrapping keys do not apply to wrapping and unwrapping private keys. 

Constraints on key types and the length of data are summarized in the following
table: 

| Function    | Key type | Input Length           | Output Length        |
|-------------|----------|------------------------|----------------------|
| C_Encrypt   | BLOWFISH | Any                    | Input length rounded up to multiple of the block size |
| C_Decrypt   | BLOWFISH | Multiple of block size | Between 1 and block length block size bytes shorter than input length |
| C_WrapKey   | BLOWFISH | Any                    | Input length rounded up to multiple of the block size |
| C_UnwrapKey | BLOWFISH | Multiple of block size | Between 1 and block length block size bytes shorter than input length |
table: BLOWFISH-CBC with PKCS Padding: Key and Data Length
