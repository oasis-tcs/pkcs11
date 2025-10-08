## AES XTS

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_AES_XTS                          |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_XTS_KEY_GEN                  |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_AES_XTS**” for type CK_KEY_TYPE as used
in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_AES_XTS
- CKM_AES_XTS_KEY_GEN

### AES-XTS secret key objects

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (32 or 64 bytes)          |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value        |
table: AES-XTS Secret Key Object Attributes

- Refer to Table 13 for footnotes

### AES-XTS key generation

The double-length AES-XTS key generation mechanism, denoted
**CKM_AES_XTS_KEY_GEN**, is a key generation mechanism for double-length AES-XTS
keys.

The mechanism generates AES-XTS keys with a particular length in bytes as
specified in the **CKA_VALUE_LEN** attributes of the template for the key.

This mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and
**CKA_VALUE** attributes to the new key. Other attributes supported by the
double-length AES-XTS key type (specifically, the flags indicating which
functions the key supports) may be specified in the template for the key, or
else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of AES-XTS key
sizes, in bytes.

### AES-XTS

AES-XTS (XEX-based Tweaked CodeBook mode with Ciphertext Stealing), denoted
**CKM_AES_XTS**, isa mechanism for single- and multiple-part encryption and
decryption. It is specified in NIST SP800-38E.

Its single parameter is a Data Unit Sequence Number 16 bytes long. Supported key
lengths are 32 and 64 bytes. Keys are internally split into half-length sub-keys
of 16 and 32 bytes respectively. Constraintson key types and the length of data
are summarized in the following table:

| Function  | Key type    | Input length | Output length  | Comments     |
|-----------|-------------|--------------|----------------|--------------|
| C_Encrypt | CKK_AES_XTS | Any, ≥ block size (16 bytes) | Same as input length | No final part |
| C_Decrypt | CKK_AES_XTS | Any, ≥ block size (16 bytes) | Same as input length | No final part |
table: AES-XTS: Key And Data Length
