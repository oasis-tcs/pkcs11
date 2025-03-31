## AES CBC with CipherText Stealing CTS

Ref [NIST AES CTS]

This mode allows unpadded data that has length that is not a multiple of the
block size to be encrypted to the same length of ciphertext.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_AES_CTS                          |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: AES CBC with CipherText Stealing CTS Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_AES_CTS 

### AES CTS mechanism parameters

It has a parameter, a 16-byte initialization vector.

| Function  | Key type | Input length | Output length  | Comments       |
|-----------|-----|--------------|---------------------|----------------|
| C_Encrypt | AES | Any, ≥ block size (16 bytes) | same as input length | no final part |
| C_Decrypt | AES | any, ≥ block size (16 bytes) | same as input length | no final part |
table: AES-CTS: Key And Data Length
