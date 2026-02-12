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
| CKA_OBJECT_VALIDATION_FLAGS ^4,6,9,12^ | CK_FLAGS | Object was created consistent with the validations appearing in flags. |
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
object creation functions), the **pValue** members of the **CK_ATTRIBUTE**
structures may point to any valid memory. The internal storage representation
of this template is token-specific. However, tokens **MUST NOT** store the
template attribute value as received, as it contain pointers to volatile
application memory that will become invalid on application restart. Tokens
**MUST** process the template attribute content (deep copy) or return
**CKR_TEMPLATE_INCONSISTENT** if unwilling to do so.

Returning a template attribute via **C_GetAttributeValue** is more complex, as
it requires the application to allocate sufficient memory for both the template
structure and the associated data. When **C_GetAttributeValue** is called, the
token **MUST** verify that the application has provided a buffer large enough
to hold the template array and all data referenced by the attributes in the
template, including any padding required for platform-specific alignment.

The token uses the beginning of the provided buffer for the array of
**CK_ATTRIBUTE** structures. It then partitions the remaining memory to store
the values of the individual attributes. The **pValue** member of each
**CK_ATTRIBUTE** in the array is updated to point to the corresponding value
stored in the latter part of the buffer. Finally, the token sets the
**ulValueLen** for the template attribute to the size of the **CK_ATTRIBUTE**
array only, excluding the size of the additional memory used for the attribute
values.

An application may discover how much memory is required by querying the token by
setting **pValue** to NULL_PTR as normally done to discover an attribute size.
However, in this case the token will not return just the size of the
**CK_ATTRIBUTE** array as it does when it fills a valid **pValue**; instead, in
this specific case the token returns the total amount of memory needed to both
return the array and all of the associated data. This may include extra space
required to align pointers in memory.
