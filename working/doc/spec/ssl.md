## SSL

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SSL3_PRE_MASTER_KEY_GEN          |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS_PRE_MASTER_KEY_GEN           |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SSL3_MASTER_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SSL3_MASTER_KEY_DERIVE_DH        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SSL3_KEY_AND_MAC_DERIVE          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SSL3_MD5_MAC                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SSL3_SHA1_MAC                    |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: SSL Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_SSL3_PRE_MASTER_KEY_GEN
- CKM_TLS_PRE_MASTER_KEY_GEN
- CKM_SSL3_MASTER_KEY_DERIVE
- CKM_SSL3_KEY_AND_MAC_DERIVE
- CKM_SSL3_MASTER_KEY_DERIVE_DH
- CKM_SSL3_MD5_MAC
- CKM_SSL3_SHA1_MAC

### SSL mechanism parameters

#### CK_SSL3_RANDOM_DATA
\  

**CK_SSL3_RANDOM_DATA** is a structure which provides information about the
random data of a client and a server in an SSL context. This structure is used
by both the **CKM_SSL3_MASTER_KEY_DERIVE** and the
**CKM_SSL3_KEY_AND_MAC_DERIVE** mechanisms. It is defined as follows:

~~~{.c}
typedef struct CK_SSL3_RANDOM_DATA {
	CK_BYTE_PTR	pClientRandom;
	CK_ULONG	ulClientRandomLen;
	CK_BYTE_PTR	pServerRandom;
	CK_ULONG	ulServerRandomLen;
}	CK_SSL3_RANDOM_DATA;
~~~

The fields of the structure have the following meanings:

_pClientRandom_
: pointer to the client’s random data

_ulClientRandomLen_
: length in bytes of the client’s random data

_pServerRandom_
: pointer to the server’s random data

_ulServerRandomLen_
: length in bytes of the server’s random data

#### CK_SSL3_MASTER_KEY_DERIVE_PARAMS
\  

**CK_SSL3_MASTER_KEY_DERIVE_PARAMS** is a structure that provides the parameters
to the **CKM_SSL3_MASTER_KEY_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_SSL3_MASTER_KEY_DERIVE_PARAMS {
	CK_SSL3_RANDOM_DATA	RandomInfo;
	CK_VERSION_PTR	pVersion;
}	CK_SSL3_MASTER_KEY_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_RandomInfo_
: client’s and server’s random data information.

_pVersion_
: pointer to a **CK_VERSION** structure which receives the SSL protocol version
  information

**CK_SSL3_MASTER_KEY_DERIVE_PARAMS_PTR** is a pointer to a
**CK_SSL3_MASTER_KEY_DERIVE_PARAMS**.

#### CK_SSL3_KEY_MAT_OUT
\  

**CK_SSL3_KEY_MAT_OUT** is a structure that contains the resulting key handles
and initialization vectors after performing a C_DeriveKey function with the
**CKM_SSL3_KEY_AND_MAC_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_SSL3_KEY_MAT_OUT {
	CK_OBJECT_HANDLE	hClientMacSecret;
	CK_OBJECT_HANDLE	hServerMacSecret;
	CK_OBJECT_HANDLE	hClientKey;
	CK_OBJECT_HANDLE	hServerKey;
	CK_BYTE_PTR	pIVClient;
	CK_BYTE_PTR	pIVServer;
}	CK_SSL3_KEY_MAT_OUT;
~~~

The fields of the structure have the following meanings:

_hClientMacSecret_
: key handle for the resulting Client MAC Secret key

_hServerMacSecret_
: key handle for the resulting Server MAC Secret key

_hClientKey_
: key handle for the resulting Client Secret key

_hServerKey_
: key handle for the resulting Server Secret key

_pIVClient_
: pointer to a location which receives the initialization vector (IV) created
  for the client (if any)

_pIVServer_
: pointer to a location which receives the initialization vector (IV) created
  for the server (if any)

**CK_SSL3_KEY_MAT_OUT_PTR** is a pointer to a **CK_SSL3_KEY_MAT_OUT**.

#### CK_SSL3_KEY_MAT_PARAMS
\  

**CK_SSL3_KEY_MAT_PARAMS** is a structure that provides the parameters to the
**CKM_SSL3_KEY_AND_MAC_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_SSL3_KEY_MAT_PARAMS {
	CK_ULONG	ulMacSizeInBits;
	CK_ULONG	ulKeySizeInBits;
	CK_ULONG	ulIVSizeInBits;
	CK_BBOOL	bIsExport;
	CK_SSL3_RANDOM_DATA	RandomInfo;
	CK_SSL3_KEY_MAT_OUT_PTR	pReturnedKeyMaterial;
}	CK_SSL3_KEY_MAT_PARAMS;
~~~

The fields of the structure have the following meanings:

_ulMacSizeInBits_
: the length (in bits) of the MACing keys agreed upon during the protocol
  handshake phase

_ulKeySizeInBits_
: the length (in bits) of the secret keys agreed upon during the protocol
  handshake phase 

_ulIVSizeInBits_
: the length (in bits) of the IV agreed upon during the protocol handshake
  phase. If no IV is required, the length should be set to 0 

_bIsExport_
: a Boolean value which indicates whether the keys have to be derived for an
  export version of the protocol

_RandomInfo_
: client’s and server’s random data information.

_pReturnedKeyMaterial_
: points to a **CK_SSL3_KEY_MAT_OUT** structures which receives the handles for
  the keys generated and the IVs 

**CK_SSL3_KEY_MAT_PARAMS_PTR** is a pointer to a **CK_SSL3_KEY_MAT_PARAMS**.

### Pre-master key generation

Pre-master key generation in SSL 3.0, denoted **CKM_SSL3_PRE_MASTER_KEY_GEN**,
is a mechanism which generates a 48-byte generic secret key. It is used to
produce the "pre_master" key used in SSL version 3.0 for RSA-like cipher suites. 

It has one parameter, a **CK_VERSION** structure, which provides the client’s
SSL version number.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The template sent along with this mechanism during a C_GenerateKey call may
indicate that the object class is CKO_SECRET_KEY, the key type is
**CKK_GENERIC_SECRET**, and the **CKA_VALUE_LEN** attribute has value 48.
However, since these facts are all implicit in the mechanism, there is no need
to specify any of them.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure both indicate 48 bytes.

**CKM_TLS_PRE_MASTER_KEY_GEN** has identical functionality as
**CKM_SSL3_PRE_MASTER_KEY_GEN**. It exists only for historical reasons, please
use **CKM_SSL3_PRE_MASTER_KEY_GEN** instead. 

### Master key derivation

Master key derivation in SSL 3.0, denoted **CKM_SSL3_MASTER_KEY_DERIVE**, is a
mechanism used to derive one 48-byte generic secret key from another 48-byte
generic secret key. It is used to produce the "master_secret" key used in the
SSL protocol from the "pre_master" key. This mechanism returns the value of the
client version, which is built into the "pre_master" key as well as a handle to
the derived "master_secret" key.

It has a parameter, a CK_SSL3_MASTER_KEY_DERIVE_PARAMS structure, which allows
for the passing of random data to the token as well as the returning of the
protocol version number which is part of the pre-master key. This structure is
defined in section [6.39].

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template; otherwise they are assigned default values.

The template sent along with this mechanism during a **C_DeriveKey** call may
indicate that the object class is CKO_SECRET_KEY, the key type is
**CKK_GENERIC_SECRET**, and the **CKA_VALUE_LEN** attribute has value 48.
However, since these facts are all implicit in the mechanism, there is no need
to specify any of them.

This mechanism has the following rules about key sensitivity and extractability:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure both indicate 48 bytes.

Note that the **CK_VERSION** structure pointed to by the
**CK_SSL3_MASTER_KEY_DERIVE_PARAMS** structure’s _pVersion_ field will be modified
by the **C_DeriveKey** call. In particular, when the call returns, this
structure will hold the SSL version associated with the supplied pre_master key.

Note that this mechanism is only useable for cipher suites that use a 48-byte
“pre_master” secret with an embedded version number. This includes the RSA
cipher suites, but excludes the Diffie-Hellman cipher suites.

### Master key derivation for Diffie-Hellman

Master key derivation for Diffie-Hellman in SSL 3.0, denoted
**CKM_SSL3_MASTER_KEY_DERIVE_DH**, is a mechanism used to derive one 48-byte
generic secret key from another arbitrary length generic secret key. It is used
to produce the "master_secret" key used in the SSL protocol from the
"pre_master" key. 

It has a parameter, a **CK_SSL3_MASTER_KEY_DERIVE_PARAMS** structure, which
allows for the passing of random data to the token. This structure is defined in
section [6.39]. The pVersion field of the structure must be set to NULL_PTR
since the version number is not embedded in the "pre_master" key as it is for
RSA-like cipher suites.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The template sent along with this mechanism during a **C_DeriveKey** call may
indicate that the object class is CKO_SECRET_KEY, the key type is
**CKK_GENERIC_SECRET**, and the **CKA_VALUE_LEN** attribute has value 48.
However, since these facts are all implicit in the mechanism, there is no need
to specify any of them.

This mechanism has the following rules about key sensitivity and extractability:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure both indicate 48 bytes.

Note that this mechanism is only useable for cipher suites that do not use a
fixed length 48-byte “pre_master” secret with an embedded version number. This
includes the Diffie-Hellman cipher suites, but excludes the RSA cipher suites.

### Key and MAC derivation

Key, MAC and IV derivation in SSL 3.0, denoted **CKM_SSL3_KEY_AND_MAC_DERIVE**,
is a mechanism used to derive the appropriate cryptographic keying material used
by a "CipherSuite" from the "master_secret" key and random data. This mechanism
returns the key handles for the keys generated in the process, as well as the
IVs created.

It has a parameter, a **CK_SSL3_KEY_MAT_PARAMS** structure, which allows for the
passing of random data as well as the characteristic of the cryptographic
material for the given CipherSuite and a pointer to a structure which receives
the handles and IVs which were generated. This structure is defined in section
[6.39].

This mechanism contributes to the creation of four distinct keys on the token
and returns two IVs (if IVs are requested by the caller) back to the caller. The
keys are all given an object class of CKO_SECRET_KEY. 

The two MACing keys ("client_write_MAC_secret" and "server_write_MAC_secret")
are always given a type of **CKK_GENERIC_SECRET**. They are flagged as valid for
signing, verification, and derivation operations.

The other two keys ("client_write_key" and "server_write_key") are typed
according to information found in the template sent along with this mechanism
during a **C_DeriveKey** function call. By default, they are flagged as valid
for encryption, decryption, and derivation operations.

IVs will be generated and returned if the ulIVSizeInBits field of the
**CK_SSL3_KEY_MAT_PARAMS** field has a nonzero value. If they are generated,
their length in bits will agree with the value in the ulIVSizeInBits field.

All four keys inherit the values of the **CKA_SENSITIVE**,
**CKA_ALWAYS_SENSITIVE**, **CKA_EXTRACTABLE**, and **CKA_NEVER_EXTRACTABLE**
attributes from the base key. The template provided to **C_DeriveKey** may not
specify values for any of these attributes which differ from those held by the
base key.

Note that the **CK_SSL3_KEY_MAT_OUT** structure pointed to by the
**CK_SSL3_KEY_MAT_PARAMS** structure’s pReturnedKeyMaterial field will be
modified by the **C_DeriveKey** call. In particular, the four key handle fields
in the **CK_SSL3_KEY_MAT_OUT** structure will be modified to hold handles to the
newly-created keys; in addition, the buffers pointed to by the
**CK_SSL3_KEY_MAT_OUT** structure’s pIVClient and pIVServer fields will have IVs
returned in them (if IVs are requested by the caller). Therefore, these two
fields must point to buffers with sufficient space to hold any IVs that will be
returned.

This mechanism departs from the other key derivation mechanisms in Cryptoki in
its returned information. For most key-derivation mechanisms, **C_DeriveKey**
returns a single key handle as a result of a successful completion. However,
since the **CKM_SSL3_KEY_AND_MAC_DERIVE** mechanism returns all of its key
handles in the **CK_SSL3_KEY_MAT_OUT** structure pointed to by the
**CK_SSL3_KEY_MAT_PARAMS** structure specified as the mechanism parameter, the
parameter phKey passed to **C_DeriveKey** is unnecessary, and should be a
NULL_PTR.

If a call to **C_DeriveKey** with this mechanism fails, then none of the four
keys will be created on the token.

### MD5 MACing in SSL 3.0

MD5 MACing in SSL3.0, denoted **CKM_SSL3_MD5_MAC**, is a mechanism for single-
and multiple-part signatures (data authentication) and verification using MD5,
based on the SSL 3.0 protocol. This technique is very similar to the HMAC
technique.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which specifies the length in
bytes of the signatures produced by this mechanism.

Constraints on key types and the length of input and output data are summarized
in the following table:

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | generic secret | any         | 4-8, depending on parameters  |
| C_Verify | generic secret | any         | 4-8, depending on parameters  |
table: MD5 MACing in SSL 3.0: Key And Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of generic secret
key sizes, in bits.

### SHA-1 MACing in SSL 3.0

SHA-1 MACing in SSL3.0, denoted **CKM_SSL3_SHA1_MAC**, is a mechanism for
single- and multiple-part signatures (data authentication) and verification
using SHA-1, based on the SSL 3.0 protocol. This technique is very similar to
the HMAC technique.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which specifies the length in
bytes of the signatures produced by this mechanism.

Constraints on key types and the length of input and output data are summarized
in the following table:

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | generic secret | any         | 4-8, depending on parameters  |
| C_Verify | generic secret | any         | 4-8, depending on parameters  |
table: SHA-1 MACing in SSL 3.0: Key And Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of generic secret
key sizes, in bits.
