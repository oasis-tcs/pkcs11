## SSH Key Derivation

[RFC 4253] Section 7.2 defines the key derivation function (KDF) for the Secure
Shell (SSH) Transport Layer Protocol. Key exchange generates a shared secret *K*
and an exchange hash *H*. Encryption keys, integrity (MAC) keys, and initial IVs
for both directions (client-to-server and server-to-client) are derived from
*K*, *H*, a single-character key type identifier, and the *session_id*.

This section defines the **CKM_SSH_KDF** mechanism, which derives cryptographic
keys and keying material from a shared secret base key according to the SSH key
derivation procedure specified in [RFC 4253].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SSH_KDF                          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SSH Key Derivation Mechanisms vs. Functions

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported base
key size in bits.

### Definitions

Mechanisms:

- CKM_SSH_KDF

Derived Key Types:

- CKP_SSH_KDF_IV_CLIENT
- CKP_SSH_KDF_IV_SERVER
- CKP_SSH_KDF_ENC_CLIENT
- CKP_SSH_KDF_ENC_SERVER
- CKP_SSH_KDF_MAC_CLIENT
- CKP_SSH_KDF_MAC_SERVER

### Mechanism Parameters

#### CK_SSH_KDF_KEY_TYPE
\  

The **CK_SSH_KDF_KEY_TYPE** type is used to specify the type of keying material
to derive in accordance with [RFC 4253] Section 7.2. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_SSH_KDF_KEY_TYPE;

#define CKP_SSH_KDF_IV_CLIENT   1
#define CKP_SSH_KDF_IV_SERVER   2
#define CKP_SSH_KDF_ENC_CLIENT  3
#define CKP_SSH_KDF_ENC_SERVER  4
#define CKP_SSH_KDF_MAC_CLIENT  5
#define CKP_SSH_KDF_MAC_SERVER  6
~~~

#### CK_SSH_KDF_PARAMS
\  

**CK_SSH_KDF_PARAMS** is a structure that provides the parameters for the
**CKM_SSH_KDF** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_SSH_KDF_PARAMS {
  CK_MECHANISM_TYPE    prfHashMechanism;
  CK_SSH_KDF_KEY_TYPE  derivedKeyType;
  CK_BYTE_PTR          pExchangeHash;
  CK_ULONG             ulExchangeHashLen;
  CK_BYTE_PTR          pSessionId;
  CK_ULONG             ulSessionIdLen;
} CK_SSH_KDF_PARAMS;

typedef CK_SSH_KDF_PARAMS CK_PTR CK_SSH_KDF_PARAMS_PTR;
~~~

The fields of the **CK_SSH_KDF_PARAMS** structure have the following meaning:

_prfHashMechanism_
: hash mechanism used for the underlying hash function in the key derivation
  operation (e.g., **CKM_SHA256**, **CKM_SHA512**, **CKM_SHA_1**).

_derivedKeyType_
: specifies the type of keying material to derive, identified by one of the
  **CKP_SSH_KDF_*** constants.

_pExchangeHash_
: pointer to the exchange hash *H* produced during the key exchange.

_ulExchangeHashLen_
: length in bytes of the exchange hash pointed to by _pExchangeHash_.

_pSessionId_
: pointer to the session identifier.

_ulSessionIdLen_
: length in bytes of the session identifier pointed to by _pSessionId_.

The following table lists common hash mechanisms supported for _prfHashMechanism_:

| Hash Mechanism Identifiers         |
|------------------------------------|
| CKM_SHA_1                          |
| CKM_SHA224                         |
| CKM_SHA256                         |
| CKM_SHA384                         |
| CKM_SHA512                         |
| CKM_SHA3_224                       |
| CKM_SHA3_256                       |
| CKM_SHA3_384                       |
| CKM_SHA3_512                       |
table: SSH KDF Supported Hash Functions

The following table lists the standard values for _derivedKeyType_ defined in
[RFC 4253]:

| PKCS#11 Constant       | RFC Value | RFC 4253 Description                       |
|------------------------|-----------|--------------------------------------------|
| CKP_SSH_KDF_IV_CLIENT  |    'A'    | Initial IV to client (client to server)    |
| CKP_SSH_KDF_IV_SERVER  |    'B'    | Initial IV to server (server to client)    |
| CKP_SSH_KDF_ENC_CLIENT |    'C'    | Encryption key to client (client to server)|
| CKP_SSH_KDF_ENC_SERVER |    'D'    | Encryption key to server (server to client)|
| CKP_SSH_KDF_MAC_CLIENT |    'E'    | Integrity key to client (client to server) |
| CKP_SSH_KDF_MAC_SERVER |    'F'    | Integrity key to server (server to client) |
table: SSH KDF Derived Key Types

### SSH Key Derivation

The SSH Key Derivation mechanism, denoted **CKM_SSH_KDF**, derives a secret key
or keying material from a shared secret base key *K* (the _hBaseKey_ parameter
passed to **C_DeriveKey**).

The base key *K* is encoded as a multiple-precision integer (`mpint`) per
[RFC 4251]. Specifically, *K* is formatted as a 4-byte big-endian unsigned length
followed by the integer in two's-complement big-endian representation, using the
minimum number of bytes (with a leading `0x00` byte if the most significant bit
is set).

The key derivation produces keying material according to [RFC 4253] Section 7.2:

_K_~1~ = HASH(_K_ || _H_ || _X_ || _session_id_)

where _X_ is the single ASCII character byte ('A' through 'F') corresponding to
the specified _derivedKeyType_, _H_ is the exchange hash, and _session_id_ is
the session identifier.

If the requested key length (specified by the **CKA_VALUE_LEN** attribute in
the template) exceeds the digest length of the selected hash function, the key
is extended by computing additional hash blocks:

_K_~2~ = HASH(_K_ || _H_ || _K_~1~)  
_K_~3~ = HASH(_K_ || _H_ || _K_~1~ || _K_~2~)  
…  
_K_~n~ = HASH(_K_ || _H_ || _K_~1~ || _K_~2~ || … || _K_~n-1~)  

The derived key value is assigned the first **CKA_VALUE_LEN** bytes of the
concatenation _K_~1~ || _K_~2~ || _K_~3~ || …

### Key Derivation Attribute Rules

For each derived key type, the token automatically sets the appropriate key
attributes according to the purpose of the keying material:

- For **CKP_SSH_KDF_IV_CLIENT** and **CKP_SSH_KDF_IV_SERVER**:
  It is allowed to provide a template that specifies the **CKA_CLASS** as
  **CKO_DATA**, or as **CKO_SECRET_KEY** with **CKA_KEY_TYPE** of
  **CKK_GENERIC_SECRET**. In the latter case, the token will set
  **CKA_EXTRACTABLE** to **CK_TRUE**, **CKA_SENSITIVE** to **CK_FALSE**, and set
  any other attributes needed to allow retrieving the **CKA_VALUE** via
  **C_GetAttributeValue**.

- For **CKP_SSH_KDF_ENC_CLIENT** and **CKP_SSH_KDF_ENC_SERVER**:
  The **CKA_KEY_TYPE** *SHOULD* be provided in the template, and the token will
  automatically set **CKA_ENCRYPT** and **CKA_DECRYPT** to **CK_TRUE**.

- For **CKP_SSH_KDF_MAC_CLIENT** and **CKP_SSH_KDF_MAC_SERVER**:
  The template *SHOULD* provide **CKA_KEY_TYPE**, and the token will
  automatically set **CKA_SIGN** and **CKA_VERIFY** to **CK_TRUE**.

Additionally, the following general rules apply to key sensitivity and extractability:

The **CKM_SSH_KDF** mechanism has the following rules about key sensitivity and
extractability:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the derived key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes take on their default values or the values defined
  in the base key.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE,
  then the derived key will have its **CKA_ALWAYS_SENSITIVE** attribute set to
  the same value as its **CKA_SENSITIVE** attribute. Otherwise, the derived key
  will have its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE.
- If the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE,
  then the derived key will have its **CKA_NEVER_EXTRACTABLE** attribute set to
  the opposite value of its **CKA_EXTRACTABLE** attribute. Otherwise, the derived
  key will have its **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE.

### Sample SSH Key Derivation

The following sample code illustrates deriving a 256-bit AES encryption key for
the client-to-server direction using **CKM_SSH_KDF**:

~~~{.c}
CK_OBJECT_HANDLE hBaseKey;
CK_OBJECT_HANDLE hDerivedKey;
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_AES;
CK_ULONG ulKeyLen = 32;
CK_BBOOL bTrue = CK_TRUE;

CK_ATTRIBUTE derivedKeyTemplate[] = {
  { CKA_CLASS, &keyClass, sizeof(keyClass) },
  { CKA_KEY_TYPE, &keyType, sizeof(keyType) },
  { CKA_VALUE_LEN, &ulKeyLen, sizeof(ulKeyLen) },
  { CKA_ENCRYPT, &bTrue, sizeof(bTrue) }
};

CK_SSH_KDF_PARAMS sshKdfParams = {
  CKM_SHA256,
  CKP_SSH_KDF_ENC_CLIENT,
  baExchangeHash,
  ulExchangeHashLen,
  baSessionId,
  ulSessionIdLen
};

CK_MECHANISM mechanism = {
  CKM_SSH_KDF,
  &sshKdfParams,
  sizeof(sshKdfParams)
};

rv = C_DeriveKey(
  hSession,
  &mechanism,
  hBaseKey,
  derivedKeyTemplate,
  sizeof(derivedKeyTemplate) / sizeof(CK_ATTRIBUTE),
  &hDerivedKey);
~~~
