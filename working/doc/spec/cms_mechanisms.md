## CMS

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_CMS_SIG                          |     |  ✓  |  ✓   |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: CMS Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_CMS_SIG

### CMS Signature Mechanism Objects

These objects provide information relating to the **CKM_CMS_SIG** mechanism.
**CKM_CMS_SIG** mechanism object attributes represent information about
supported CMS signature attributes in the token. They are only present on tokens
supporting the **CKM_CMS_SIG** mechanism, but must be present on those tokens.

| Attribute                    | Data type  | Meaning                    |
|------------------------------|------------|----------------------------|
| CKA_REQUIRED_CMS_ATTRIBUTES  | Byte array | Attributes the token always will include in the set of CMS signed attributes |
| CKA_DEFAULT_CMS_ATTRIBUTES   | Byte array | Attributes the token will include in the set of CMS signed attributes in the absence of any attributes specified by the application |
| CKA_SUPPORTED_CMS_ATTRIBUTES | Byte array | Attributes the token may include in the set of CMS signed attributes upon request by the application |
table: CMS Signature Mechanism Object Attributes

The contents of each byte array will be a DER-encoded list of CMS Attributes
with optional accompanying values. Any attributes in the list shall be
identified with its object identifier, and any values shall be DER-encoded. The
list of attributes is defined in ASN.1 as:

~~~{.c}
Attributes ::= SET SIZE (1..MAX) OF Attribute
Attribute ::= SEQUENCE {
    attrType   OBJECT IDENTIFIER,
    attrValues SET OF ANY DEFINED BY OBJECT IDENTIFIER OPTIONAL
}
~~~

The client may not set any of the attributes.

### CMS mechanism parameters

#### CK_CMS_SIG_PARAMS
\  

**CK_CMS_SIG_PARAMS** is a structure that provides the parameters to the
**CKM_CMS_SIG** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_CMS_SIG_PARAMS {
  CK_OBJECT_HANDLE  certificateHandle;
  CK_MECHANISM_PTR  pSigningMechanism;
  CK_MECHANISM_PTR  pDigestMechanism;
  CK_UTF8CHAR_PTR   pContentType;
  CK_BYTE_PTR       pRequestedAttributes;
  CK_ULONG          ulRequestedAttributesLen;
  CK_BYTE_PTR       pRequiredAttributes;
  CK_ULONG          ulRequiredAttributesLen;
} CK_CMS_SIG_PARAMS;
~~~

The fields of the structure have the following meanings:

_certificateHandle_
: Object handle for a certificate associated with the signing key. The token may
  use information from this certificate to identify the signer in the SignerInfo
  result value. CertificateHandle may be NULL_PTR if the certificate is not
  available as a PKCS #11 object or if the calling application leaves the choice
  of certificate completely to the token.

_pSigningMechanism_
: Mechanism to use when signing a constructed CMS SignedAttributes value. E.g.
  **CKM_SHA1_RSA_PKCS**.

_pDigestMechanism_
: Mechanism to use when digesting the data. Value shall be NULL_PTR when the
  digest mechanism to use follows from the pSigningMechanism parameter.

_pContentType_
: NULL-terminated string indicating complete MIME Content-type of message to be
  signed; or the value NULL_PTR if the message is a MIME object (which the token
  can parse to determine its MIME Content-type if required). Use the value
  “application/octet-stream“ if the MIME type for the message is unknown or
  undefined. Note that the pContentType string shall conform to the syntax
  specified in [RFC 2045], i.e. any parameters needed for correct presentation
  of the content by the token (such as, for example, a non-default “charset”)
  must be present. The token must follow rules and procedures defined in
  [RFC 2045] when presenting the content.

_pRequestedAttributes_
: Pointer to DER-encoded list of CMS Attributes the caller requests to be
  included in the signed attributes. Token may freely ignore this list or modify
  any supplied values.

_ulRequestedAttributesLen_
: Length in bytes of the value pointed to by pRequestedAttributes

_pRequiredAttributes_
: Pointer to DER-encoded list of CMS Attributes (with accompanying values)
  required to be included in the resulting signed attributes. Token must not
  modify any supplied values. If the token does not support one or more of the
  attributes, or does not accept provided values, the signature operation will
  fail. The token will use its own default attributes when signing if both the
  pRequestedAttributes and pRequiredAttributes field are set to NULL_PTR.

_ulRequiredAttributesLen_
: Length in bytes, of the value pointed to by pRequiredAttributes.

**CK_CMS_SIG_PARAMS_PTR** is a pointer to a **CK_CMS_SIG_PARAMS**.

### CMS signatures

The CMS mechanism, denoted **CKM_CMS_SIG**, is a multi-purpose mechanism based
on the structures defined in [PKCS #7] and [RFC 5652]. It supports single- or
multiple-part signatures with and without message recovery. The mechanism is
intended for use with, e.g., PTDs (see [MeT-PTD]) or other capable tokens. The
token will construct a CMS SignedAttributes value and compute a signature on
this value. The content of the SignedAttributes value is decided by the token,
however the caller can suggest some attributes in the parameter
_pRequestedAttributes_. The caller can also require some attributes to be
present through the parameters _pRequiredAttributes_. The signature is computed
in accordance with the parameter _pSigningMechanism_.

When this mechanism is used in successful calls to **C_Sign** or
**C_SignFinal**, the pSignature return value will point to a DER-encoded value
of type SignerInfo. SignerInfo is defined in ASN.1 as follows (for a complete
definition of all fields and types, see [RFC 5652]):

~~~{.c}
SignerInfo ::= SEQUENCE {
  version             CMSVersion,
  sid                 SignerIdentifier,
  digestAlgorithm     DigestAlgorithmIdentifier,
  signedAttrs         [0] IMPLICIT SignedAttributes OPTIONAL,
  signatureAlgorithm  SignatureAlgorithmIdentifier,
  signature           SignatureValue,
  unsignedAttrs       [1] IMPLICIT UnsignedAttributes OPTIONAL
}
~~~

The _certificateHandle_ parameter, when set, helps the token populate the sid
field of the SignerInfo value. If _certificateHandle_ is NULL_PTR the choice of
a suitable certificate reference in the SignerInfo result value is left to the
token (the token could, e.g., interact with the user).

This mechanism shall not be used in calls to **C_Verify** or **C_VerifyFinal**
(use the _pSigningMechanism_ mechanism instead).

For the _pRequiredAttributes_ field, the token may have to interact with the
user to find out whether to accept a proposed value or not. The token should
never accept any proposed attribute values without some kind of confirmation
from its owner (but this could be through, e.g., configuration or policy
settings and not direct interaction). If a user rejects proposed values, or the
signature request as such, the value **CKR_FUNCTION_REJECTED** shall be
returned.

When possible, applications should use the **CKM_CMS_SIG** mechanism when
generating CMS-compatible signatures rather than lower-level mechanisms such as
**CKM_SHA1_RSA_PKCS**. This is especially true when the signatures are to be
made on content that the token is able to present to a user. Exceptions may
include those cases where the token does not support a particular signing
attribute. Note however that the token may refuse usage of a particular
signature key unless the content to be signed is known (i.e. the **CKM_CMS_SIG**
mechanism is used).

When a token does not have presentation capabilities, the PKCS #11-aware
application may avoid sending the whole message to the token by electing to use
a suitable signature mechanism (e.g. **CKM_RSA_PKCS**) as the
_pSigningMechanism_ value in the **CK_CMS_SIG_PARAMS** structure, and digesting
the message itself before passing it to the token.

PKCS #11-aware applications making use of tokens with presentation capabilities,
should attempt to provide messages to be signed by the token in a format
possible for the token to present to the user. Tokens that receive multipart
MIME-messages for which only certain parts are possible to present may fail the
signature operation with a return value of **CKR_DATA_INVALID**, but may also
choose to add a signing attribute indicating which parts of the message were
possible to present.
