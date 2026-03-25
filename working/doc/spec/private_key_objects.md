## Private key objects

Private key objects (object class **CKO_PRIVATE_KEY**) hold private keys.
The following table defines the attributes common to all private keys, in
addition to the common attributes defined for this object class:

| Attribute             | Data type  | Meaning                           |
|-----------------------|------------|-----------------------------------|
| CKA_SUBJECT ^8^       | Byte array | DER-encoding of certificate subject name (default empty) |
| CKA_SENSITIVE ^8,11^  | CK_BBOOL   | CK_TRUE if key is sensitive^9^    |
| CKA_DECRYPT ^8^       | CK_BBOOL   | CK_TRUE if key supports decryption^9^ |
| CKA_SIGN ^8^          | CK_BBOOL   | CK_TRUE if key supports signatures where the signature is an appendix to the data^9^ |
| CKA_SIGN_RECOVER ^8^  | CK_BBOOL   | CK_TRUE if key supports signatures where the data can be recovered from the signature^9^ |
| CKA_UNWRAP ^8^        | CK_BBOOL   | CK_TRUE if key supports unwrapping (i.e., can be used to unwrap other keys)^9^ |
| CKA_DECAPSULATE ^8^   | CK_BBOOL   | CK_TRUE if key supports decapsulation^9^ |
| CKA_EXTRACTABLE ^8,12^ | CK_BBOOL  | CK_TRUE if key is extractable and can be wrapped^9^ |
| CKA_ALWAYS_SENSITIVE ^2,4,6^ | CK_BBOOL | CK_TRUE if key has always had the CKA_SENSITIVE attribute set to CK_TRUE |
| CKA_NEVER_EXTRACTABLE ^2,4,6^ | CK_BBOOL | CK_TRUE if key has never had the CKA_EXTRACTABLE attribute set to CK_TRUE |
| CKA_WRAP_WITH_TRUSTED ^11^ | CK_BBOOL | CK_TRUE if the key can only be wrapped with a wrapping key that has CKA_TRUSTED set to CK_TRUE. Default is CK_FALSE. |
| CKA_UNWRAP_TEMPLATE | CK_ATTRIBUTE_PTR | For wrapping keys. The attribute template to apply to any keys unwrapped using this wrapping key. Any user supplied template is applied after this template as if the object has already been created. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
| CKA_DECAPSULATE_TEMPLATE | CK_ATTRIBUTE_PTR | For decapsulating keys. The attribute template to apply to any keys decapsulated using this decapsulating key. Any user supplied template is applied after this template as if the object has already been created. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
| CKA_ALWAYS_AUTHENTICATE | CK_BBOOL | If CK_TRUE, the user has to supply the PIN for each use (sign or decrypt) with the key. Default is CK_FALSE. |
| CKA_PUBLIC_KEY_INFO ^8^ | Byte array | DER-encoding of the SubjectPublicKeyInfo for the associated public key (MAY be empty; DEFAULT derived from the underlying private key data; MAY be manually set for specific key types; if set; MUST be consistent with the underlying private key data) |
| CKA_DERIVE_TEMPLATE   | CK_ATTRIBUTE_PTR | For deriving keys. The attribute template to match against any keys derived using this derivation key. Any user supplied template is applied after this template as if the object has already been created. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
| CKA_PUBLIC_CRC64_VALUE ^1,4,13^ | Byte array | The CRC-64-ECMA calculated over the public key object’s CKA_VALUE attribute unless otherwise specified in the mechanism description |
table: Common Private Key Attributes

 * Refer to Table 13 for footnotes

It is intended in the interests of interoperability that the subject name
and key identifier for a private key will be the same as those for the
corresponding certificate and public key. However, this is not enforced by
Cryptoki, and it is not required that the certificate and public key also
be stored on the token.

If the **CKA_SENSITIVE** attribute is CK_TRUE, or if the **CKA_EXTRACTABLE**
attribute is CK_FALSE, then certain attributes of the private key cannot be
revealed in plaintext outside the token. Which attributes these are is
specified for each type of private key in the attribute table in the section
describing that type of key.

The **CKA_ALWAYS_AUTHENTICATE** attribute can be used to force
re-authentication (i.e. force the user to provide a PIN) for each use of a
private key. “Use” in this case means a cryptographic operation such as sign
or decrypt. This attribute may only be set to CK_TRUE when **CKA_PRIVATE**
is also CK_TRUE.

Re-authentication occurs by calling **C_Login** with userType set to
**CKU_CONTEXT_SPECIFIC** immediately after a cryptographic operation using
the key has been initiated (e.g. after **C_SignInit**). In this call, the
actual user type is implicitly given by the usage requirements of the active
key. If **C_Login** returns **CKR_OK** the user was successfully authenticated
and this sets the active key in an authenticated state that lasts until the
cryptographic operation has successfully or unsuccessfully been completed
(e.g. by **C_Sign**, **C_SignFinal**,..). A return value **CKR_PIN_INCORRECT**
from **C_Login** means that the user was denied permission to use the key and
continuing the cryptographic operation will result in a behavior as if
**C_Login** had not been called. In both of these cases the session state will
remain the same, however repeated failed re-authentication attempts may cause
the PIN to be locked. **C_Login** returns in this case **CKR_PIN_LOCKED** and
this also logs the user out from the token. Failing or omitting to
re-authenticate when **CKA_ALWAYS_AUTHENTICATE** is set to CK_TRUE will result
in **CKR_USER_NOT_LOGGED_IN** to be returned from calls using the key.
**C_Login** will return **CKR_OPERATION_NOT_INITIALIZED**, but the active
cryptographic operation will not be affected, if an attempt is made to
re-authenticate when **CKA_ALWAYS_AUTHENTICATE** is set to CK_FALSE.

The **CKA_PUBLIC_KEY_INFO** attribute represents the public key associated
with this private key. The data it represents may either be stored as part of
the private key data, or regenerated as needed from the private key.

If this attribute is supplied as part of a template for **C_CreateObject**,
**C_CopyObject** or **C_SetAttributeValue** for a private key, the token MUST
verify correspondence between the private key data and the public key data as
supplied in **CKA_PUBLIC_KEY_INFO**. This can be done either by deriving a
public key from the private key and comparing the values, or by doing a sign
and verify operation. If there is a mismatch, the command SHALL return
**CKR_ATTRIBUTE_VALUE_INVALID**. A token MAY choose not to support the
**CKA_PUBLIC_KEY_INFO** attribute for commands which create new private keys.
If it does not support the attribute, the command SHALL return
**CKR_ATTRIBUTE_TYPE_INVALID**.

As a general guideline, private keys of any type SHOULD store sufficient
information to retrieve the public key information. In particular, the RSA
private key description has been modified in PKCS #11 V2.40 to add the
**CKA_PUBLIC_EXPONENT** to the list of attributes required for an RSA private
key. All other private key types described in this specification contain
sufficient information to recover the associated public key.
