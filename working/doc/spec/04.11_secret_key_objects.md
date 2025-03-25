## Secret key objects

Secret key objects (object class **CKO_SECRET_KEY**) hold secret keys. The
following table defines the attributes common to all secret keys, in
addition to the common attributes defined for this object class:

| Attribute              | Data type  | Meaning                           |
|------------------------|------------|-----------------------------------|
| CKA_SENSITIVE ^8,11^   | CK_BBOOL   | CK_TRUE if object is sensitive (default CK_FALSE) |
| CKA_ENCRYPT ^8^        | CK_BBOOL   | CK_TRUE if key supports encryption^9^ |
| CKA_DECRYPT ^8^        | CK_BBOOL   | CK_TRUE if key supports decryption^9^ |
| CKA_SIGN ^8^           | CK_BBOOL   | CK_TRUE if key supports signatures (i.e., authentication codes) where the signature is an appendix to the data^9^ |
| CKA_VERIFY ^8^         | CK_BBOOL   | CK_TRUE if key supports verification (i.e., of authentication codes) where the signature is an appendix to the data^9^ |
| CKA_WRAP ^8^           | CK_BBOOL   | CK_TRUE if key supports wrapping (i.e., can be used to wrap other keys)^9^ |
| CKA_UNWRAP ^8^         | CK_BBOOL   | CK_TRUE if key supports unwrapping (i.e., can be used to unwrap other keys)^9^ |
| CKA_EXTRACTABLE ^8,12^ | CK_BBOOL   | CK_TRUE if key is extractable and can be wrapped^9^ |
| CKA_ALWAYS_SENSITIVE ^2,4,6^ | CK_BBOOL | CK_TRUE if key has always had the CKA_SENSITIVE attribute set to CK_TRUE |
| CKA_NEVER_EXTRACTABLE ^2,4,6^ | CK_BBOOL | CK_TRUE if key has never had the CKA_EXTRACTABLE attribute set to CK_TRUE |
| CKA_CHECK_VALUE        | Byte array | Key checksum                      |
| CKA_WRAP_WITH_TRUSTED ^11^ | CK_BBOOL | CK_TRUE if the key can only be wrapped with a wrapping key that has CKA_TRUSTED set to CK_TRUE. Default is CK_FALSE. |
| CKA_TRUSTED ^10^       | CK_BBOOL   | The wrapping key can be used to wrap keys with  CKA_WRAP_WITH_TRUSTED set to CK_TRUE. |
| CKA_WRAP_TEMPLATE      | CK_ATTRIBUTE_PTR | For wrapping keys. The attribute template to match against any keys wrapped using this wrapping key. Keys that do not match cannot be wrapped. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE |
| CKA_UNWRAP_TEMPLATE    | CK_ATTRIBUTE_PTR | For wrapping keys. The attribute template to apply to any keys unwrapped using this wrapping key. Any user supplied template is applied after this template as if the object has already been created. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
| CKA_DERIVE_TEMPLATE    | CK_ATTRIBUTE_PTR | For deriving keys. The attribute template to match against any keys derived using this derivation key. Any user supplied template is applied after this template as if the object has already been created. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
table: Common Secret Key Attributes

 * Refer to Table 13 for footnotes

If the **CKA_SENSITIVE** attribute is CK_TRUE, or if the **CKA_EXTRACTABLE**
attribute is CK_FALSE, then certain attributes of the secret key cannot be
revealed in plaintext outside the token. Which attributes these are is
specified for each type of secret key in the attribute table in the section
describing that type of key.

The key check value (KCV) attribute for symmetric key objects to be called
**CKA_CHECK_VALUE**, of type byte array, length 3 bytes, operates like a
fingerprint, or checksum of the key. They are intended to be used to
cross-check symmetric keys against other systems where the same key is
shared, and as a validity check after manual key entry or restore from
backup. Refer to object definitions of specific key types for KCV algorithms.

Properties:
 1. For two keys that are cryptographically identical the value of this
    attribute should be identical.
 2. CKA_CHECK_VALUE should not be usable to obtain any part of the key value.
 3. Non-uniqueness. Two different keys can have the same CKA_CHECK_VALUE.
    This is unlikely (the probability can easily be calculated) but possible.

The attribute is optional, but if supported, regardless of how the key object
is created or derived, the value of the attribute is always supplied. It
SHALL be supplied even if the encryption operation for the key is forbidden
(i.e. when **CKA_ENCRYPT** is set to CK_FALSE).

If a value is supplied in the application template (allowed but never
necessary) then, if supported, it MUST match what the library calculates it
to be or the library returns a **CKR_ATTRIBUTE_VALUE_INVALID**. If the
library does not support the attribute then it should ignore it. Allowing the
attribute in the template this way does no harm and allows the attribute to
be treated like any other attribute for the purposes of key wrap and unwrap
where the attributes are preserved also.

The generation of the KCV may be prevented by the application supplying the
attribute in the template as a no-value (0 length) entry. The application can
query the value at any time like any other attribute using
**C_GetAttributeValue**. **C_SetAttributeValue** may be used to destroy the
attribute, by supplying no-value.

Unless otherwise specified for the object definition, the value of this
attribute is derived from the key object by taking the first three bytes of
an encryption of a single block of null (0x00) bytes, using the default
cipher and mode (e.g. ECB) associated with the key type of the secret key
object.
