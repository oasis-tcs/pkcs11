## Key objects

### Definitions

There is no **CKO_** definition for the base key object class, only for the
key types derived from it.

This section defines the object class **CKO_PUBLIC_KEY**, **CKO_PRIVATE_KEY**
and **CKO_SECRET_KEY** for type CK_OBJECT_CLASS as used in the **CKA_CLASS**
attribute of objects.

### Overview

Key objects hold encryption or authentication keys, which can be public keys,
private keys, or secret keys. The following common footnotes apply to all the
tables describing attributes of keys:

The following table defines the attributes common to public key, private key
and secret key classes, in addition to the common attributes defined for this
object class:

| Attribute            | Data Type   | Meaning                           |
|----------------------|-------------|-----------------------------------|
| CKA_KEY_TYPE ^1,5^   | CK_KEY_TYPE | Type of key                       |
| CKA_ID ^8^           | Byte array  | Key identifier for key (default empty) |
| CKA_START_DATE ^8^   | CK_DATE     | Start date for the key (default empty) |
| CKA_END_DATE ^8^     | CK_DATE     | End date for the key (default empty) |
| CKA_DERIVE ^8^       | CK_BBOOL    | CK_TRUE if key supports key derivation (i.e., if other keys can be derived from this one (default CK_FALSE) |
| CKA_LOCAL ^2,4,6^    | CK_BBOOL    | CK_TRUE only if key was either    |
|                      |             | • generated locally (i.e., on the token) with a C_GenerateKey or C_GenerateKeyPair call |
|                      |             | • created with a C_CopyObject call as a copy of a key which had its CKA_LOCAL attribute set to CK_TRUE |
| CKA_KEY_GEN_MECHANISM ^2,4,6^ | CK_MECHANISM_TYPE | Identifier of the mechanism used to generate the key material. |
| CKA_ALLOWED_MECHANISMS | CK_MECHANISM_TYPE_PTR, pointer to a CK_MECHANISM_TYPE array | A list of mechanisms allowed to be used with this key. The number of mechanisms in the array is the ulValueLen component of the attribute divided by the size of CK_MECHANISM_TYPE. |
| CKA_OBJECT_VALIDATION_FLAGS ^4,6,9^ | CK_FLAGS | Object was created consistent with the validations appearing in flags. |
table: Common Key Attributes

 * Refer to Table 13 for footnotes

The **CKA_ID** field is intended to distinguish among multiple keys. In the
case of public and private keys, this field assists in handling multiple
keys held by the same subject; the key identifier for a public key and its
corresponding private key should be the same. The key identifier should
also be the same as for the corresponding certificate, if one exists.
Cryptoki does not enforce these associations, however. (See the [Certificate
objects] section for further commentary.)

In the case of secret keys, the meaning of the **CKA_ID** attribute is up to
the application.

Note that the **CKA_START_DATE** and **CKA_END_DATE** attributes are for
reference only; Cryptoki does not attach any special meaning to them. In
particular, it does not restrict usage of a key according to the dates; doing
this is up to the application.

The **CKA_DERIVE** attribute has the value CK_TRUE if and only if it is
possible to derive other keys from the key.

The **CKA_LOCAL** attribute has the value CK_TRUE if and only if the value of
the key was originally generated on the token by a C_GenerateKey or
C_GenerateKeyPair call.

The **CKA_KEY_GEN_MECHANISM** attribute identifies the key generation
mechanism used to generate the key material. It contains a valid value only
if the **CKA_LOCAL** attribute has the value CK_TRUE. If **CKA_LOCAL** has
the value CK_FALSE, the value of the attribute is CK_UNAVAILABLE_INFORMATION.

### Template Attributes

Template attributes are attributes that embed a template that is stored on a key
object (**CKA_DERIVE_TEMPLATE**, **CKA_WRAP_TEMPLATE**, **CKA_UNWRAP_TEMPLATE**,
**CKA_ENCAPSULATE_TEMPLATE**, **CKA_DECAPSULATE_TEMPLATE**).

When a template attribute is received via **C_SetAttributeValue** (or other
object creation functions), the _pValue_ member of the **CK_ATTRIBUTE**
structure points to an array of **CK_ATTRIBUTE** structures, and the
_ulValueLen_ member specifies the length in bytes of the array. The internal
storage representation of this template is token-specific. However, tokens
**MUST NOT** store the template attribute value as received, as it contains
pointers to volatile application memory that will become invalid on application
restart. Tokens **MUST** process the template attribute content (e.g., by
creating a deep copy) or return **CKR_TEMPLATE_INCONSISTENT** if unwilling or
unable to do so.

Returning a template attribute via **C_GetAttributeValue** may require multiple
successuive calls, as the application needs to discover what fields are contained
in the tempate and then allocate sufficient memory for both the template
structure array and the associated data. When a template attribute request is
received via **C_GetAttributeValue**, the received template **MUST** be
validated when the _pValue_ and _ulValueLen_ fields are not NULL_PTR and 0
respectively.

The application **MUST** provide a valid array in the buffer. Specifically, the
application must ensure that for each attribute in the inner template, the
_pValue_ field is either set to NULL_PTR or contains a valid pointer to a
location in memory that can receive at least _ulValueLen_ bytes.

If the application does not know ahead of time exactly which attributes the
template attribute contains, it **MUST** set the type of all attributes in that
template attribute to **CK_UNAVAILABLE_INFORMATION**, all _pValue_ fields to
NULL_PTR, and all _ulValueLen_ fields to 0.

If either *all* or *none* of the attribute type fields are set to
**CK_UNAVAILABLE_INFORMATION** (i.e., all contain a valid attribute type that is
available on the internal object's attribute template representation) and the
array size matches the number of elements present in the internal
representation, the template is considered valid; otherwise,
**CKR_TEMPLATE_INCONSISTENT** **MUST** be returned.

When receiving a template attribute with all attribute types set to
**CK_UNAVAILABLE_INFORMATION**, the template attribute is modified to contain
the correct type for each attribute as well as the attribute's data
_ulValueLen_ length, while _pValue_ will be left pointing to NULL_PTR.

On receiving a request with a valid template attribute with all matching
attribute types correctly set, the same rules specified in the [Object
management functions] section, **C_GetAttributeValue** function, for filling in
the top level template in the **C_GetAttributeValue** function will be applied.

The application will perform as many subsequent calls as necessary to
**C_GetAttributeValue** to provide the necessary allocations.

Implementations can limit permitted recursion (i.e., the ability to embed
template attributes in the template attributes) and deny any recursion,
returning **CKR_TEMPLATE_INCONSISTENT** if the template can't be accepted for
reading or writing to the object. If an application is unwilling to retrieve a
template attribute value recursively embedded within a template attribute while
still retrieving the other attributes, it is permitted to simply exclude the
attribute from the template attribute array by adequately reducing the array
size. Implementations should support returning partial templates this way as
long as all the remaining attributes in the template are present in the inner
representation. Any mismatch **SHOULD** cause the implementation to return
**CKR_TEMPLATE_INCONSISTENT**.
