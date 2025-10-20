## NULL Mechanism

CKM_NULL is a mechanism used to implement the trivial pass-through function. 

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_NULL                             |  ✓  |  ✓  |  ✓   |  ✓  |       |  ✓  |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: CKM_NULL Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_NULL

### CKM_NULL mechanism parameters


**CKM_NULL** does not have a parameter. 

When used for encrypting / decrypting data, the input data is copied unchanged
to the output data.

When used for signing, the input data is copied to the signature. When used for
signature verification, it compares the input data and the signature, and
returns **CKR_OK** (indicating that both are identical) or
**CKR_SIGNATURE_INVALID**.

When used for digesting data, the input data is copied to the message digest.

When used for wrapping a private or secret key object, the wrapped key will be
identical to the key to be wrapped. When used for unwrapping, a new object with
the same value as the wrapped key will be created.

When used for deriving a key, the derived key has the same value as the base
key.

When used for key encapsulation, the encapsulated key will be identical to the
secret key to be encapsulated. When used for key decapsulation, a new object
with the same value as the encapsulated key will be created.
