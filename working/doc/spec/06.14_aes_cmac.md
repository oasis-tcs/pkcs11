## AES CMAC

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_AES_CMAC_GENERAL                 |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_CMAC                         |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_AES_CMAC_GENERAL
- CKM_AES_CMAC

### Mechanism parameters

**CKM_AES_CMAC_GENERAL** uses the existing **CK_MAC_GENERAL_PARAMS** structure.
**CKM_AES_CMAC** does not use a mechanism parameter.

### General-length AES-CMAC

General-length AES-CMAC, denoted **CKM_AES_CMAC_GENERAL**, is a mechanism for
single- and multiple-part signatures and verification, based on [NIST SP800-38B]
and [RFC 4493].

It has a parameter, a **CK_MAC_GENERAL_PARAMS** structure, which specifies the
output length desired from the mechanism.

The output bytes from this mechanism are taken from the start of the final AES
cipher block produced in the MACing process.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length	| Signature length                   |
|----------|----------|-------------|------------------------------------|
| C_Sign   | AES | any | 1-block size, as specified in parameters |
| C_Verify | AES | any | 1-block size, as specified in parameters |
table: General-length AES-CMAC: Key And Data Length

[NIST SP800-38B] and [RFC 4493] recommend that the output MAC is not truncated
to less than 64 bits. The MAC length must be specified before the communication
starts, and must not be changed during the lifetime of the key. It is the
caller’s responsibility to follow these rules.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of AES key sizes, in
bytes.

### AES-CMAC

AES-CMAC, denoted **CKM_AES_CMAC**, is a special case of the general-length
AES-CMAC mechanism. AES-MAC always produces and verifies MACs that are a full
block size in length, the default output length specified by [RFC 4493].

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length	| Signature length                   |
|----------|----------|-------------|------------------------------------|
| C_Sign   | AES | any | Block size (16 bytes) |
| C_Verify | AES | any | Block size (16 bytes) |
table: AES-CMAC: Key And Data Length

[NIST SP800-38B] and [RFC 4493] recommend that the output MAC is not truncated
to less than 64 bits. The MAC length must be specified before the communication
starts, and must not be changed during the lifetime of the key. It is the
caller’s responsibility to follow these rules.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of AES key sizes, in
bytes.
