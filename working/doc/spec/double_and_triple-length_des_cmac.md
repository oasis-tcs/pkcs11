## Double and Triple-length DES CMAC

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_DES3_CMAC_GENERAL                |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_CMAC                        |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Double and Triple-length DES CMAC Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_DES3_CMAC_GENERAL
- CKM_DES3_CMAC

### Mechanism parameters

**CKM_DES3_CMAC_GENERAL** uses the existing **CK_MAC_GENERAL_PARAMS** structure.
**CKM_DES3_CMAC** does not use a mechanism parameter.

### General-length DES3-MAC

General-length DES3-CMAC, denoted **CKM_DES3_CMAC_GENERAL**, is a mechanism for
single- and multiple-part signatures and verification with DES3 or DES2 keys,
based on [NIST sp800-38b].

It has a parameter, a **CK_MAC_GENERAL_PARAMS** structure, which specifies the
output length desired from the mechanism.

The output bytes from this mechanism are taken from the start of the final DES3
cipher block produced in the MACing process.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length	| Signature length                   |
|----------|----------|-------------|------------------------------------|
| C_Sign   | CKK_DES3 CKK_DES2 | any | 1-block size, as specified in parameters |
| C_Verify | CKK_DES3 CKK_DES2 | any | 1-block size, as specified in parameters |
table: General-length DES3-CMAC: Key And Data Length

Reference [NIST sp800-38b] recommends that the output MAC is not truncated to
less than 64 bits (which means using the entire block for DES). The MAC length
must be specified before the communication starts, and must not be changed
during the lifetime of the key. It is the caller’s responsibility to follow
these rules.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used 

### DES3-CMAC

DES3-CMAC, denoted **CKM_DES3_CMAC**, is a special case of the general-length
DES3-CMAC mechanism. DES3-MAC always produces and verifies MACs that are a full
block size in length, since the DES3 block length is the minimum output length
recommended by [NIST sp800-38b].

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length	| Signature length                   |
|----------|----------|-------------|------------------------------------|
| C_Sign   | CKK_DES3 CKK_DES2 | any | Block size (8 bytes)              |
| C_Verify | CKK_DES3 CKK_DES2 | any | Block size (8 bytes)              |
table: DES3-CMAC: Key And Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure are not used.
