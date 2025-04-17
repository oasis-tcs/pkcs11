## SHAKE

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHAKE_128_KEY_DERIVATION         |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SHAKE_256_KEY_DERIVATION         |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SHAKE Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_SHAKE_128_KEY_DERIVATION
- CKM_SHAKE_256_KEY_DERIVATION

### SHAKE Key Derivation

SHAKE-128 and SHAKE-256 key derivation, denoted **CKM_SHAKE_128_KEY_DERIVATION**
and **CKM_SHAKE_256_KEY_DERIVATION**, implements the SHAKE expansion function
defined in [FIPS PUB 202] on the input key.

- If no length or key type is provided in the template a
  **CKR_TEMPLATE_INCOMPLETE** error is generated.
- If no key type is provided in the template, but a length is, then the key
  produced by this mechanism shall be a generic secret key of the specified
  length.
- If no length was provided in the template, but a key type is, then that key
  type must have a well-defined length. If it does, then the key produced by
  this mechanism shall be of the type specified in the template. If it doesn’t,
  an error shall be returned.
- If both a key type and a length are provided in the template, the length must
  be compatible with that key type. The key produced by this mechanism shall be
  of the specified type and length.

If a DES, DES2, or CDMF key is derived with this mechanism, the parity bits of
the key shall be set properly.

This mechanism has the following rules about key sensitivity and extractability:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key shall as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key shall, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.
