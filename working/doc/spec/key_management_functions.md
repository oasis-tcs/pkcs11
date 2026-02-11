## Key management functions

Cryptoki provides the following functions for key management:

### C_GenerateKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GenerateKey)(
    CK_SESSION_HANDLE hSession
    CK_MECHANISM_PTR pMechanism,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulCount,
    CK_OBJECT_HANDLE_PTR phKey
);
~~~

**C_GenerateKey** generates a secret key or set of domain parameters, creating a
new object. _hSession_ is the session’s handle; _pMechanism_ points to the
generation mechanism; _pTemplate_ points to the template for the new key or set
of domain parameters; _ulCount_ is the number of attributes in the template;
_phKey_ points to the location that receives the handle of the new key or set of
domain parameters.

If the generation mechanism is for domain parameter generation, the
**CKA_CLASS** attribute will have the value **CKO_DOMAIN_PARAMETERS**;
otherwise, it will have the value **CKO_SECRET_KEY**.

Since the type of key or domain parameters to be generated is implicit in the
generation mechanism, the template does not need to supply a key type. If it
does supply a key type which is inconsistent with the generation mechanism,
**C_GenerateKey** fails and returns the error code
**CKR_TEMPLATE_INCONSISTENT**. The CKA_CLASS attribute is treated similarly.

If a call to **C_GenerateKey** cannot support the precise template supplied to
it, it will fail and return without creating an object.

The object created by a successful call to **C_GenerateKey** will have its
**CKA_LOCAL** attribute set to CK_TRUE. In addition, the object created will
have a value for **CKA_UNIQUE_ID** generated and assigned (See Section 4.4.1).

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_MECHANISM_INVALID,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING,
CKR_PIN_EXPIRED, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT,
CKR_TOKEN_WRITE_PROTECTED, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_DES_KEY_GEN, NULL_PTR, 0
};
CK_RV rv;

.
.
rv = C_GenerateKey(hSession, &mechanism, NULL_PTR, 0, &hKey);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_GenerateKeyPair

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GenerateKeyPair)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_ATTRIBUTE_PTR pPublicKeyTemplate,
    CK_ULONG ulPublicKeyAttributeCount,
    CK_ATTRIBUTE_PTR pPrivateKeyTemplate,
    CK_ULONG ulPrivateKeyAttributeCount,
    CK_OBJECT_HANDLE_PTR phPublicKey,
    CK_OBJECT_HANDLE_PTR phPrivateKey
);
~~~

**C_GenerateKeyPair** generates a public/private key pair, creating new key
objects. _hSession_ is the session’s handle; _pMechanism_ points to the key
generation mechanism; _pPublicKeyTemplate_ points to the template for the public
key; _ulPublicKeyAttributeCount_ is the number of attributes in the public-key
template; _pPrivateKeyTemplate_ points to the template for the private key;
_ulPrivateKeyAttributeCount_ is the number of attributes in the private-key
template; _phPublicKey_ points to the location that receives the handle of the
new public key; _phPrivateKey_ points to the location that receives the handle
of the new private key.

Since the types of keys to be generated are implicit in the key pair generation
mechanism, the templates do not need to supply key types. If one of the
templates does supply a key type which is inconsistent with the key generation
mechanism, **C_GenerateKeyPair** fails and returns the error code
**CKR_TEMPLATE_INCONSISTENT**. The **CKA_CLASS** attribute is treated similarly.

If a call to **C_GenerateKeyPair** cannot support the precise templates supplied
to it, it will fail and return without creating any key objects.

A call to **C_GenerateKeyPair** will never create just one key and return. A
call can fail, and create no keys; or it can succeed, and create a matching
public/private key pair.

The key objects created by a successful call to **C_GenerateKeyPair** will have
their **CKA_LOCAL** attributes set to CK_TRUE. In addition, the key objects
created will both have values for **CKA_UNIQUE_ID** generated and assigned (See
Section 4.4.1).

_Note carefully the order of the arguments to **C_GenerateKeyPair**. The last
two arguments do not have the same order as they did in the original Cryptoki
Version 1.0 document. The order of these two arguments has caused some
unfortunate confusion._

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PARAMETER_SET_NOT_SUPPORTED, CKR_PENDING,
CKR_PIN_EXPIRED, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT,
CKR_TOKEN_WRITE_PROTECTED, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hPublicKey, hPrivateKey;
CK_MECHANISM mechanism = {
  CKM_RSA_PKCS_KEY_PAIR_GEN, NULL_PTR, 0
};
CK_ULONG modulusBits = 3072;
CK_BYTE publicExponent[] = { 3 };
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE publicKeyTemplate[] = {
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_VERIFY, &true, sizeof(true)},
  {CKA_WRAP, &true, sizeof(true)},
  {CKA_MODULUS_BITS, &modulusBits, sizeof(modulusBits)},
  {CKA_PUBLIC_EXPONENT, publicExponent, sizeof (publicExponent)}
};
CK_ATTRIBUTE privateKeyTemplate[] = {
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_PRIVATE, &true, sizeof(true)},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_SENSITIVE, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)},
  {CKA_SIGN, &true, sizeof(true)},
  {CKA_UNWRAP, &true, sizeof(true)}
};
CK_RV rv;

rv = C_GenerateKeyPair(
  hSession, &mechanism,
  publicKeyTemplate, 5,
  privateKeyTemplate, 8,
  &hPublicKey, &hPrivateKey);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_WrapKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_WrapKey)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hWrappingKey,
    CK_OBJECT_HANDLE hKey,
    CK_BYTE_PTR pWrappedKey,
    CK_ULONG_PTR pulWrappedKeyLen
);
~~~

**C_WrapKey** wraps (i.e., encrypts) a private or secret key. _hSession_ is the
session’s handle; _pMechanism_ points to the wrapping mechanism; _hWrappingKey_
is the handle of the wrapping key; _hKey_ is the handle of the key to be
wrapped; _pWrappedKey_ points to the location that receives the wrapped key; and
_pulWrappedKeyLen_ points to the location that receives the length of the
wrapped key.

**C_WrapKey** uses the convention described in Section 5.2 on producing output.

The **CKA_WRAP** attribute of the wrapping key, which indicates whether the key
supports wrapping, MUST be CK_TRUE. The **CKA_EXTRACTABLE** attribute of the key
to be wrapped MUST also be CK_TRUE.

If the key to be wrapped cannot be wrapped for some token-specific reason,
despite it having its **CKA_EXTRACTABLE attribute** set to CK_TRUE, then
**C_WrapKey** fails with error code **CKR_KEY_NOT_WRAPPABLE**. If it cannot be
wrapped with the specified wrapping key and mechanism solely because of its
length, then **C_WrapKey** fails with error code **CKR_KEY_SIZE_RANGE**.

**C_WrapKey** can be used in the following situations:

* To wrap any secret key with a public key that supports encryption and
  decryption.
* To wrap any secret key with any other secret key. Consideration MUST be given
  to key size and mechanism strength or the token may not allow the operation.
* To wrap a private key with any secret key.

Of course, tokens vary in which types of keys can actually be wrapped with which
mechanisms.

To partition the wrapping keys so they can only wrap a subset of extractable
keys the attribute **CKA_WRAP_TEMPLATE** can be used on the wrapping key to
specify an attribute set that will be compared against the attributes of the key
to be wrapped. If all attributes match according to the **C_FindObject** rules
of attribute matching then the wrap will proceed. The value of this attribute is
an attribute template and the size is the number of items in the template times
the size of **CK_ATTRIBUTE**. If this attribute is not supplied then any
template is acceptable. If an attribute is not present, it will not be checked.
If any attribute mismatch occurs on an attempt to wrap a key then the function
SHALL return **CKR_KEY_HANDLE_INVALID**.

Return Values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_KEY_HANDLE_INVALID,
CKR_KEY_NOT_WRAPPABLE, CKR_KEY_SIZE_RANGE, CKR_KEY_UNEXTRACTABLE,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_WRAPPING_KEY_HANDLE_INVALID, CKR_WRAPPING_KEY_SIZE_RANGE,
CKR_WRAPPING_KEY_TYPE_INCONSISTENT.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hWrappingKey, hKey;
CK_MECHANISM mechanism = {
  CKM_DES3_ECB, NULL_PTR, 0
};
CK_BYTE wrappedKey[8];
CK_ULONG ulWrappedKeyLen;
CK_RV rv;

.
.
ulWrappedKeyLen = sizeof(wrappedKey);
rv = C_WrapKey(
  hSession, &mechanism,
  hWrappingKey, hKey,
  wrappedKey, &ulWrappedKeyLen);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_UnwrapKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_UnwrapKey)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hUnwrappingKey,
    CK_BYTE_PTR pWrappedKey,
    CK_ULONG ulWrappedKeyLen,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulAttributeCount,
    CK_OBJECT_HANDLE_PTR phKey
);
~~~

**C_UnwrapKey** unwraps (i.e. decrypts) a wrapped key, creating a new private
key or secret key object. _hSession_ is the session’s handle; _pMechanism_
points to the unwrapping mechanism; _hUnwrappingKey_ is the handle of the
unwrapping key; _pWrappedKey_ points to the wrapped key; _ulWrappedKeyLen_ is
the length of the wrapped key; _pTemplate_ points to the template for the new
key; _ulAttributeCount_ is the number of attributes in the template; _phKey_
points to the location that receives the handle of the recovered key.

The **CKA_UNWRAP** attribute of the unwrapping key, which indicates whether the
key supports unwrapping, MUST be CK_TRUE.

The template for the new key SHALL specify **CKA_VALUE_LEN** when neither the
key type of the unwrapped key nor the unwrapping mechanism unambiguously
determine the length of the unwrapped key; otherwise, the function SHALL return
**CKR_TEMPLATE_INCOMPLETE**.

The template for the new key MAY specify **CKA_VALUE_LEN** when the key type of
the unwrapped key or the unwrapping mechanism unambiguously determine the length
of the unwrapped key. If any length conflict occurs between the key type of the
unwrapped key, the output from the unwrapping mechanism, or the specified
**CKA_VALUE_LEN**, then the function SHALL return **CKR_WRAPPED_KEY_LEN_RANGE**.

The new key will have the **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
and the **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE. The
**CKA_EXTRACTABLE** attribute is by default set to CK_TRUE.

Some mechanisms may modify, or attempt to modify. the contents of the
_pMechanism_ structure at the same time that the key is unwrapped.

If a call to **C_UnwrapKey** cannot support the precise template supplied to it,
it will fail and return without creating any key object.

The key object created by a successful call to **C_UnwrapKey** will have its
**CKA_LOCAL** attribute set to CK_FALSE. In addition, the object created will
have a value for **CKA_UNIQUE_ID** generated and assigned (See Section 4.4.1).

To partition the unwrapping keys so they can only unwrap a subset of keys the
attribute **CKA_UNWRAP_TEMPLATE** can be used on the unwrapping key to specify
an attribute set that will be added to attributes of the key to be unwrapped. If
the attributes do not conflict with the user supplied attribute template, in
‘pTemplate’, then the unwrap will proceed. The value of this attribute is an
attribute template and the size is the number of items in the template times the
size of **CK_ATTRIBUTE**. If this attribute is not present on the unwrapping key
then no additional attributes will be added. If any attribute conflict occurs on
an attempt to unwrap a key then the function SHALL return
**CKR_TEMPLATE_INCONSISTENT**.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PARAMETER_SET_NOT_SUPPORTED, CKR_PENDING,
CKR_PIN_EXPIRED, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT,
CKR_TOKEN_WRITE_PROTECTED, CKR_UNWRAPPING_KEY_HANDLE_INVALID,
CKR_UNWRAPPING_KEY_SIZE_RANGE, CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT,
CKR_USER_NOT_LOGGED_IN, CKR_WRAPPED_KEY_INVALID, CKR_WRAPPED_KEY_LEN_RANGE.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hUnwrappingKey, hKey;
CK_MECHANISM mechanism = {
  CKM_DES3_ECB, NULL_PTR, 0
};
CK_BYTE wrappedKey[8] = {...};
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_DES;
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)}
};
CK_RV rv;

.
.
rv = C_UnwrapKey(
  hSession, &mechanism, hUnwrappingKey,
  wrappedKey, sizeof(wrappedKey), template, 4, &hKey);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_DeriveKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DeriveKey)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hBaseKey,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulAttributeCount,
    CK_OBJECT_HANDLE_PTR phKey
);
~~~

**C_DeriveKey** derives a key from a base key, creating a new key object.
_hSession_ is the session’s handle; _pMechanism_ points to a structure that
specifies the key derivation mechanism; _hBaseKey_ is the handle of the base
key; _pTemplate_ points to the template for the new key; _ulAttributeCount_ is
the number of attributes in the template; and _phKey_ points to the location
that receives the handle of the derived key.

The values of the **CKA_SENSITIVE**, **CKA_ALWAYS_SENSITIVE**,
**CKA_EXTRACTABLE**, and **CKA_NEVER_EXTRACTABLE** attributes for the base key
affect the values that these attributes can hold for the newly-derived key. See
the description of each particular key-derivation mechanism in Section 6.42 and
6.43 for any constraints of this type.

If a call to **C_DeriveKey** cannot support the precise template supplied to it,
it will fail and return without creating any key object.

The key object created by a successful call to **C_DeriveKey** will have its
**CKA_LOCAL** attribute set to CK_FALSE. In addition, the object created will
have a value for **CKA_UNIQUE_ID** generated and assigned (See Section 4.4.1).

To partition the derivation keys so they can only derive a subset of keys the
attribute **CKA_DERIVE_TEMPLATE** can be used on the derivation keys to specify
an attribute set that will be added to attributes of the key to be derived. If
the attributes do not conflict with the user supplied attribute template, in
‘pTemplate’, then the derivation will proceed. The value of this attribute is an
attribute template and the size is the number of items in the template times the
size of **CK_ATTRIBUTE**. If this attribute is not present on the base
derivation keys then no additional attributes will be added. If any attribute
conflict occurs on an attempt to derive a key then the function SHALL return
**CKR_TEMPLATE_INCONSISTENT**.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE, CKR_KEY_TYPE_INCONSISTENT,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCOMPLETE,
CKR_TEMPLATE_INCONSISTENT, CKR_TOKEN_WRITE_PROTECTED, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hPublicKey, hPrivateKey, hKey;
CK_MECHANISM keyPairMechanism = {
  CKM_DH_PKCS_KEY_PAIR_GEN, NULL_PTR, 0
};
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE publicValue[128];
CK_BYTE otherPublicValue[128];
CK_MECHANISM mechanism = {
  CKM_DH_PKCS_DERIVE, otherPublicValue, sizeof(otherPublicValue)
};
CK_ATTRIBUTE template[] = {
  {CKA_VALUE, &publicValue, sizeof(publicValue)}
};
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_DES;
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE publicKeyTemplate[] = {
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)}
};
CK_ATTRIBUTE privateKeyTemplate[] = {
  {CKA_DERIVE, &true, sizeof(true)}
};
CK_ATTRIBUTE derivedKeyTemplate[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)}
};
CK_RV rv;

.
.
rv = C_GenerateKeyPair(
  hSession, &keyPairMechanism,
  publicKeyTemplate, 2,
  privateKeyTemplate, 1,
  &hPublicKey, &hPrivateKey);
if (rv == CKR_OK) {
  rv = C_GetAttributeValue(hSession, hPublicKey, template, 1);
  if (rv == CKR_OK) {
    /* Put other guy’s public value in otherPublicValue */
    .
    .
    rv = C_DeriveKey(
      hSession, &mechanism,
      hPrivateKey, derivedKeyTemplate, 4, &hKey);
    if (rv == CKR_OK) {
      .
      .
    }
  }
}
~~~

### C_WrapKeyAuthenticated

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_WrapKeyAuthenticated)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hWrappingKey,
    CK_OBJECT_HANDLE hKey,
    CK_BYTE_PTR pAssociatedData,
    CK_ULONG ulAssociatedDataLen,
    CK_BYTE_PTR pWrappedKey,
    CK_ULONG_PTR pulWrappedKeyLen
);
~~~

**C_WrapKeyAuthenticated** wraps (i.e., encrypts) a private or secret key.
_hSession_ is the session’s handle; _pMechanism_ points to the wrapping mechanism
with the message params; _hWrappingKey_ is the handle of the wrapping key; _hKey_ is
the handle of the key to be wrapped; _pAssociatedData_ and _ulAssociatedDataLen_
specify the associated data for an AEAD mechanism; _pWrappedKey_ points to the
location that receives the wrapped key; and _pulWrappedKeyLen_ points to the
location that receives the length of the wrapped key.

**C_WrapKeyAuthenticated** uses the convention described in section 5.2 on
producing output.

The CKA_WRAP attribute of the wrapping key, which indicates whether the key
supports wrapping, MUST be CK_TRUE. The **CKA_EXTRACTABLE** attribute of the key
to be wrapped MUST also be CK_TRUE.

If the key to be wrapped cannot be wrapped for some token-specific reason,
despite it having its **CKA_EXTRACTABLE** attribute set to CK_TRUE, then
**C_WrapKeyAuthenticated** fails with error code **CKR_KEY_NOT_WRAPPABLE**. If
it cannot be wrapped with the specified wrapping key and mechanism solely
because of its length, then **C_WrapKeyAuthenticated** fails with error code
**CKR_KEY_SIZE_RANGE**.

**C_WrapKeyAuthenticated** primary use case:

To wrap any secret or private key using an AEAD authenticated mechanism. This
allows the ability to use a provider generated (random) IV (GCM) or nonce (CCM)
using the standard **CK_XXX_MESSAGE_PARAMS** with a mechanism as opposed to
passing in the IV (GCM) or nonce (CCM). This IV can then be passed into the
mechanism **CK_XXX_MESSAGE_PARAMS** for **C_UnwrapKeyAuthenticated**. See
section 6.13.3 for further description of AES-GCM authenticated wrap/unwrap and
section 6.13.5 for AES-CCM authenticated wrap/unwrap.

Of course, tokens vary in which types of keys can actually be wrapped with which
mechanisms. 

To partition the wrapping keys so they can only wrap a subset of extractable
keys the attribute **CKA_WRAP_TEMPLATE** can be used on the wrapping key to
specify an attribute set that will be compared against the attributes of the key
to be wrapped. If all attributes match according to the **C_FindObject** rules
of attribute matching, then the wrap will proceed. The value of this attribute
is an attribute template, and the size is the number of items in the template
times the size of **CK_ATTRIBUTE**. If this attribute is not supplied, then any
template is acceptable. If an attribute is not present, it will not be checked.
If any attribute mismatch occurs on an attempt to wrap a key, then the function
SHALL return **CKR_KEY_HANDLE_INVALID**.

Return Values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_KEY_HANDLE_INVALID,
CKR_KEY_NOT_WRAPPABLE, CKR_KEY_SIZE_RANGE, CKR_KEY_UNEXTRACTABLE,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_WRAPPING_KEY_HANDLE_INVALID, CKR_WRAPPING_KEY_SIZE_RANGE,
CKR_WRAPPING_KEY_TYPE_INCONSISTENT.

Example: 

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hWrappingKey, hKey;
CK_BYTE iv[12];
CK_BYTE tag[16];
CK_BYTE auth[100];

CK_GCM_MESSAGE_PARAMS gcmParams = {
  iv,
  sizeof(iv) * 8,
  96,
  CKG_GENERATE,
  tag,
  sizeof(tag) * 8
};
CK_MECHANISM mechanism = {
  CKM_AES_GCM, gcmParams, sizeof(gcmParams)
};
CK_BYTE wrappedKey[32]; /* only the wrapped key returned*/
CK_ULONG ulWrappedKeyLen;
CK_RV rv;

ulWrappedKeyLen = sizeof(wrappedKey);
rv = C_WrapKeyAuthenticated(
  hSession, &mechanism, hWrappingKey, hKey,
  auth, sizeof(auth),
  wrappedKey, &ulWrappedKeyLen);

if (rv == CKR_OK) {
  .
  .
}
~~~

### C_UnwrapKeyAuthenticated

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_UnwrapKeyAuthenticated)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hUnwrappingKey,
    CK_BYTE_PTR pWrappedKey,
    CK_ULONG ulWrappedKeyLen,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulAttributeCount,
    CK_BYTE_PTR pAssociatedData,
    CK_ULONG ulAssociatedDataLen,
    CK_OBJECT_HANDLE_PTR phKey
);
~~~

**C_UnwrapKeyAuthenticated** unwraps (i.e. decrypts) a wrapped key, creating a
new private key or secret key object. _hSession_ is the session’s handle;
_pMechanism_ points to the unwrapping mechanism with the message params;
_hUnwrappingKey_ is the handle of the unwrapping key; _pWrappedKey_ points to
the wrapped key; _ulWrappedKeyLen_ is the length of the wrapped key; _pTemplate_
points to the template for the new key; _ulAttributeCount_ is the number of
attributes in the template; _pAssociatedData_ and _ulAssociatedDataLen_ specify
the associated data for an AEAD mechanism; _phKey_ points to the location that
receives the handle of the key.

The **CKA_UNWRAP** attribute of the unwrapping key, which indicates whether the
key supports unwrapping, MUST be CK_TRUE.

The new key will have the **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
and the **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE. The
**CKA_EXTRACTABLE** attribute is by default set to CK_TRUE.

Some mechanisms may modify, or attempt to modify, the contents of the
_pMechanism_ structure at the same time that the key is unwrapped.

If a call to **C_UnwrapKeyAuthenticated** cannot support the precise template
supplied to it, it will fail and return without creating any key object.

The key object created by a successful call to **C_UnwrapKeyAuthenticated** will
have its **CKA_LOCAL** attribute set to CK_FALSE. In addition, the object
created will have a value for **CKA_UNIQUE_ID** generated and assigned (see
section 4.4.1).

**C_UnwrapKeyAuthenticated** Primary use case:

* To unwrap any wrapped secret or private key using an AEAD Authenticated
  mechanism. This allows the ability to use a provider generated (random) IV
  (GCM) or nonce (CCM) from **C_WrapKeyAuthenticated** using the standard
  **CK_XXX_MESSAGE_PARAMS**. This IV can then be passed into the mechanism
  **CK_XXX_MESSAGE_PARAMS** for **C_UnwrapKeyAuthenticated**. See section 6.13.3 for
  further description of AES-GCM authenticated wrap/unwrap and section 6.13.5 for
  AES-CCM authenticated wrap/unwrap.

Of course, tokens vary in which types of keys can actually be unwrapped with
which mechanisms.

To partition the unwrapping keys so they can only unwrap a subset of keys the
attribute **CKA_UNWRAP_TEMPLATE** can be used on the unwrapping key to specify
an attribute set that will be added to attributes of the key to be unwrapped. If
the attributes do not conflict with the user supplied attribute template in
‘pTemplate’, then the unwrap will proceed. The value of this attribute is an
attribute template and the size is the number of items in the template times the
size of CK_ATTRIBUTE. If this attribute is not present on the unwrapping key
then no additional attributes will be added. If any attribute conflict occurs on
an attempt to unwrap a key then the function SHALL return
**CKR_TEMPLATE_INCONSISTENT**.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PARAMETER_SET_NOT_SUPPORTED, CKR_PIN_EXPIRED,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY,
CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT, CKR_TOKEN_WRITE_PROTECTED,
CKR_UNWRAPPING_KEY_HANDLE_INVALID, CKR_UNWRAPPING_KEY_SIZE_RANGE,
CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT, CKR_USER_NOT_LOGGED_IN,
CKR_WRAPPED_KEY_INVALID, CKR_WRAPPED_KEY_LEN_RANGE.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hUnwrappingKey, hKey;
CK_BYTE wrappedKey[32] = {...};
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_AES;
CK_BBOOL true = CK_TRUE;

CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)}
};
CK_RV rv;
CK_BYTE iv[] = {1 , 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }; /*value from wrap CKG_GENERATE */
CK_BYTE tag[16];
CK_BYTE auth[100];
CK_GCM_MESSAGE_PARAMS gcmParams = {
  iv,
  sizeof(iv) * 8,
  0, /* ignored */
  CKG_NO_GENERATE, /* ignored */
  tag, /* Tag returned from Wrap */
  sizeof(tag) * 8
};
CK_MECHANISM mechanism = {
  CKM_AES_GCM, gcmParams, sizeof(gcmParams)
};

.
.
rv = C_UnwrapKeyAuthenticated(
  hSession, &mechanism, hUnwrappingKey,
  wrappedKey, sizeof(wrappedKey),
  template, 4,
  auth, sizeof(auth), &hKey);

if (rv == CKR_OK) {
  .
  .
}
~~~
     
### C_EncapsulateKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_EncapsulateKey)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hPublicKey,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulAttributeCount,
    CK_BYTE_PTR pCiphertext, 
    CK_ULONG_PTR pulCiphertextLen, 
    CK_OBJECT_HANDLE_PTR phKey
);
~~~

**C_EncapulateKey** creates a new secret key object from a public key using a
KEM. _hSession_ is the session’s handle; _pMechanism_ points to a structure that
specifies the encapsulation mechanism; _hPublicKey_ is the handle of the public
key; _pTemplate_ points to the template for the new key; _ulAttributeCount_ is
the number of attributes in the template; _pCiphertext_ points to the location
that receives the ciphertext needed by decapsulate; _pulCiphertextLen_ points to
the location to receive the length; and _phKey_ points to the location that
receives the handle of the new key. If _pCiphertext_ is not big enough to hold
the required ciphertext, _pulCiphertextLen_ is set to the space needed to hold
_pCiphertext_ and **C_EncapsulateKey** returns **CKR_BUFFER_TOO_SMALL**. The
**CKA_ENCAPSULATE** attribute of the public key, which indicates whether the key
supports encapsulation, MUST be CK_TRUE.

The new key will have:

* the **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
* the **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE.
* the **CKA_EXTRACTABLE** set to the value of the input template with a default
  of CK_TRUE if not provided,
* the **CKA_LOCAL** attribute set to CK_FALSE, and
* the **CKA_UNIQUE_ID** attribute generated and assigned per section 4.4.1.

If a call to **C_EncapsulateKey** cannot support the precise template supplied
to it, it will fail and return without creating any key object.

To partition the encapsulation keys so they can only encapsulate a subset of
keys the attribute **CKA_ENCAPSULATE_TEMPLATE** can be used on the encapsulation
keys to specify an attribute set that will be added to attributes of the key to
be encapsulated. If the attributes do not conflict with the user supplied
attribute template, in ‘pTemplate’, then the encapsulation will proceed. The
value of this attribute is an attribute template and the size is the number of
items in the template times the size of **CK_ATTRIBUTE**. If this attribute is
not present on the encapsulating key then no additional attributes will be
added. If any attribute conflict occurs on an attempt to encapsulate a key then
the function SHALL return **CKR_KEY_HANDLE_INVALID**.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE, CKR_KEY_TYPE_INCONSISTENT,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_PARAMETER_SET_NOT_SUPPORTED, CKR_OPERATION_ACTIVE, CKR_PIN_EXPIRED,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY,
CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT, CKR_TOKEN_WRITE_PROTECTED,
CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hPublicKey, hKey;
CK_BYTE cipherText[128];
CK_MECHANISM mechanism = {
  CKM_ECDH, NULL_PTR, 0
};
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_AES;
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE keyTemplate[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)}
};
CK_RV rv;

.
.
ulCipherTextLen = sizeof(cipherText);
rv = C_EncapsulateKey(
  hSession, &mechanism, hPublicKey,
  keyTemplate, 4,
  cipherText, &ulCipherTextLen,
  &hKey);

if (rv == CKR_OK) {
    .
    .
}
~~~
     
### C_DecapsulateKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecapsulateKey)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hPrivateKey,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulAttributeCount,
    CK_BYTE_PTR pCiphertext,
    CK_ULONG ulCiphertextLen,
    CK_OBJECT_HANDLE_PTR phKey
);
~~~

**C_DecapsulateKey** creates a new secret key object based on the private key
and ciphertext generated by a prior encapsulate operation. This new key (called
a ‘shared key’ in most KEM documentation) is identical to the key returned by
**C_EncapsulateKey** when it was called with the matching public key and
returned the same ciphertext. This function is a KEM style function. _hSession_
is the session’s handle; _pMechanism_ points to the decapsulation mechanism;
_hPrivateKey_ is the handle of the decapsulation key; _pTemplate_ points to the
template for the new key; _ulAttributeCount_ is the number of attributes in the
template; _pCiphertext_ points to the ciphertext in the KEM protocol;
_ulCiphertextLen_ is the length of the ciphertext; _phKey_ points to the
location that receives the handle of the decapsulated key.

If a call to **C_DecapsulateKey** cannot support the precise template supplied
to it, it will fail and return without creating any key object.

The **CKA_DECAPSULATE** attribute of the private key, which indicates whether
the key supports decapsulation, MUST be CK_TRUE.

The new key will have:

* the **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
* the **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE.
* the **CKA_EXTRACTABLE** set to the value of the input template with a default
  of CK_TRUE if not provided,
* the **CKA_LOCAL** attribute set to CK_FALSE, and
* the **CKA_UNIQUE_ID** attribute generated and assigned per section 4.4.1.

Some mechanisms may modify, or attempt to modify, the contents of the
_pMechanism_ structure at the same time that the key is decapsulated.

If a call to **C_DecapsulateKey** cannot support the precise template supplied
to it, it will fail and return without creating any key object.

To partition the decapsulation keys so they can only decapsulate a subset of
keys the attribute **CKA_DECAPSULATE_TEMPLATE** can be used on the decapsulation
keys to specify an attribute set that will be added to attributes of the key to
be decapsulated. If the attributes do not conflict with the user supplied
attribute template, in ‘pTemplate’, then the decapsulation will proceed. The
value of this attribute is an attribute template and the size is the number of
items in the template times the size of **CK_ATTRIBUTE**. If this attribute is
not present on the decapsulating key then no additional attributes will be
added. If any attribute conflict occurs on an attempt to decapsulate a key then
the function SHALL return **CKR_TEMPLATE_INCONSISTENT**.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PARAMETER_SET_NOT_SUPPORTED, CKR_PIN_EXPIRED,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY,
CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT, CKR_TOKEN_WRITE_PROTECTED,
CKR_UNWRAPPING_KEY_HANDLE_INVALID, CKR_UNWRAPPING_KEY_SIZE_RANGE,
CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT, CKR_USER_NOT_LOGGED_IN,
CKR_WRAPPED_KEY_INVALID, CKR_WRAPPED_KEY_LEN_RANGE.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hPrivateKey, hKey;
CK_MECHANISM mechanism = {
  CKM_ECDH, NULL_PTR, 0
};
CK_BYTE cipherText[35] = {...};
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_AES;
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_DECRYPT, &true, sizeof(true)}
};
CK_RV rv;

.
.
rv = C_DecapsulateKey(
  hSession, &mechanism, hPrivateKey,
  template, 4,
  cipherText, sizeof(cipherText), 
  &hKey);

if (rv == CKR_OK) {
  .
  .
}
~~~
