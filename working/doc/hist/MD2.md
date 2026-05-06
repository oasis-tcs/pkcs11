## MD2

### Definitions

Mechanisms:

- CKM_MD2
- CKM_MD2_HMAC
- CKM_MD2_HMAC_GENERAL
- CKM_MD2_KEY_DERIVATION

### MD2 digest

The MD2 mechanism, denoted **CKM_MD2**, is a mechanism for message digesting,
following the MD2 message-digest algorithm defined in RFC 6149.

It does not have a parameter.

Constraints on the length of data are summarized in the following table:

| Function | Data length | Digest Length |
|----------|-------------|---------------|
| C_Digest | Any         | 16            |
table: MD2: Data Length

### General-length MD2-HMAC

The general-length MD2-HMAC mechanism, denoted **CKM_MD2_HMAC_GENERAL**, is a
mechanism for signatures and verification.  It uses the HMAC construction, based
on the MD2 hash function.  The keys it uses are generic secret keys.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which holds the length in bytes
of the desired output.  This length should be in the range 0-16 (the output size
of MD2 is 16 bytes).  Signatures (MACs) produced by this mechanism MUST be taken
from the start of the full 16-byte HMAC output.

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | Generic secret | Any         | 0-16, depending on parameters |
| C_Verify | Generic secret | Any         | 0-16, depending on parameters |
table: General-length MD2-HMAC: Key and Data Length

### MD2-HMAC

The MD2-HMAC mechanism, denoted **CKM_MD2_HMAC**, is a special case of the
general-length MD2-HMAC mechanism in Section 2.11.3.  

It has no parameter, and produces an output of length 16.

### MD2 key derivation

MD2 key derivation, denoted **CKM_MD2_KEY_DERIVATION**, is a mechanism which
provides the capability of deriving a secret key by digesting the value of
another secret key with MD2.

The value of the base key is digested once, and the result is used to make the
value of the derived secret key.

- If no length or key type is provided in the template, then the key produced by
  this mechanism MUST be a generic secret key.  Its length MUST be 16 bytes (the
  output size of MD2)..
- If no key type is provided in the template, but a length is, then the key
  produced by this mechanism MUST be a generic secret key of the specified
  length.
- If no length was provided in the template, but a key type is, then that key
  type must have a well-defined length.  If it does, then the key produced by
  this mechanism MUST be of the type specified in the template.  If it doesn’t,
  an error MUST be returned.
- If both a key type and  a length are provided in the template, the length must
  be compatible with that key type.  The key produced by this mechanism MUST be
  of the specified type and length.

If a DES, DES2, or CDMF key is derived with this mechanism, the parity bits of
the key MUST be set properly.

If the requested type of key requires more than 16 bytes, such as DES2, an error
is generated.

This mechanism has the following rules about key sensitivity and extractability:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key MAY both be specified to be either **CK_TRUE** or **CK_FALSE**.
  If omitted, these attributes each take on some default value.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to
  **CK_FALSE**, then the derived key MUST as well.  If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to **CK_TRUE**, then the derived key
  has its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  **CK_FALSE**, then the derived key MUST, too.  If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to **CK_TRUE**, then the derived key
  has its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.
