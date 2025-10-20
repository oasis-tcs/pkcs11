## 1.2 Mechanisms

Details for TLS 1.2 and its key derivation and MAC mechanisms can be found in
[TLS12]. TLS 1.2 mechanisms differ from TLS 1.0 and 1.1 mechanisms in that the
base hash used in the underlying TLS PRF (pseudo-random function) can be
negotiated. Therefore each mechanism parameter for the TLS 1.2 mechanisms
contains a new value in the parameters structure to specify the hash function. 

This section also specifies **CKM_TLS12_MAC** which should be used in place of
**CKM_TLS_PRF** to calculate the verify_data in the TLS "finished" message.

This section also specifies **CKM_TLS_KDF** (and **CKM_TLS12_KDF)** that can be
used in place of **CKM_TLS_PRF** to implement key material exporters.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_TLS12_MASTER_KEY_DERIVE          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_MASTER_KEY_DERIVE_DH       |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE_DH|   |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_KEY_AND_MAC_DERIVE         |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_KEY_SAFE_DERIVE            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS_MAC                          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS_KDF                          |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_MAC                        |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_TLS12_KDF                        |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: TLS 1.2 Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_TLS12_MASTER_KEY_DERIVE
- CKM_TLS12_MASTER_KEY_DERIVE_DH
- CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE
- CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE_DH
- CKM_TLS12_KEY_AND_MAC_DERIVE
- CKM_TLS12_KEY_SAFE_DERIVE
- CKM_TLS_MAC
- CKM_TLS_KDF
- CKM_TLS12_MAC
- CKM_TLS12_KDF

### TLS 1.2 mechanism parameters

#### CK_TLS12_MASTER_KEY_DERIVE_PARAMS
\  

**CK_TLS12_MASTER_KEY_DERIVE_PARAMS** is a structure that provides the
parameters to the **CKM_TLS12_MASTER_KEY_DERIVE** mechanism. It is defined as
follows:

~~~{.c}
typedef struct CK_TLS12_MASTER_KEY_DERIVE_PARAMS {
  CK_SSL3_RANDOM_DATA RandomInfo;
  CK_VERSION_PTR pVersion;
  CK_MECHANISM_TYPE prfHashMechanism;
} CK_TLS12_MASTER_KEY_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_RandomInfo_
: client’s and server’s random data information as specified in section
  [6.39.2].

_pVersion_
: pointer to a **CK_VERSION** structure which receives the SSL protocol version
  information.

_prfHashMechanism_
: base hash used in the underlying TLS1.2 PRF operation used to derive the
  master key.

**CK_TLS12_MASTER_KEY_DERIVE_PARAMS_PTR** is a pointer to a
**CK_TLS12_MASTER_KEY_DERIVE_PARAMS**.

#### CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS
\  

**CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS** is a structure that provides the
parameters to the **CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE** mechanism. It is
defined as follows:

~~~{.c}
typedef struct CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS {
  CK_MECHANISM_TYPE prfHashMechanism;
  CK_BYTE_PTR pSessionHash;
  CK_ULONG ulSessionHashLen;
  CK_VERSION_PTR pVersion;
} CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfHashMechanism_
: base hash used in the underlying TLS1.2 PRF operation used to derive the
  master key.

_pSessionHash_
: pointer to the session hash data defined in [RFC 7627]. 

_ulSessionHashLen_
: length of the data pointed to by pSessionHash.

_pVersion_
: pointer to a **CK_VERSION** structure which receives the SSL protocol version
  information

**CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS_PTR** is a pointer to a
**CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS**.

#### CK_TLS12_KEY_MAT_PARAMS
\  

**CK_TLS12_KEY_MAT_PARAMS** is a structure that provides the parameters to the
**CKM_TLS12_KEY_AND_MAC_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_TLS12_KEY_MAT_PARAMS {
  CK_ULONG ulMacSizeInBits;
  CK_ULONG ulKeySizeInBits;
  CK_ULONG ulIVSizeInBits;
  CK_BBOOL bIsExport;
  CK_SSL3_RANDOM_DATA RandomInfo;
  CK_SSL3_KEY_MAT_OUT_PTR pReturnedKeyMaterial;
  CK_MECHANISM_TYPE prfHashMechanism;
} CK_TLS12_KEY_MAT_PARAMS;
~~~

The fields of the structure have the following meanings:

_ulMacSizeInBits_
: the length (in bits) of the MACing keys agreed upon during the protocol
  handshake phase. If no MAC key is required, the length should be set to 0.

_ulKeySizeInBits_
: the length (in bits) of the secret keys agreed upon during the protocol
  handshake phase 

_ulIVSizeInBits_
: the length (in bits) of the IV agreed upon during the protocol handshake
  phase. If no IV is required, the length should be set to 0 

_bIsExport_
: must be set to CK_FALSE because export cipher suites must not be used in TLS
  1.1 and later.

_RandomInfo_
: client’s and server’s random data information as specified in section
  [6.39.2].

_pReturnedKeyMaterial_
: points to a **CK_SSL3_KEY_MAT_OUT** structure as specified in section [6.39.2]
  which receives the handles for the keys generated and the IVs 

_prfHashMechanism_
: base hash used in the underlying TLS1.2 PRF operation used to derive the
  master key.

**CK_TLS12_KEY_MAT_PARAMS_PTR** is a pointer to a **CK_TLS12_KEY_MAT_PARAMS**.

#### CK_TLS_KDF_PARAMS
\  

**CK_TLS_KDF_PARAMS** is a structure that provides the parameters to the
**CKM_TLS_KDF** (and **CKM_TLS12_KDF)** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_TLS_KDF_PARAMS {
  CK_MECHANISM_TYPE prfMechanism;
  CK_BYTE_PTR pLabel;
  CK_ULONG ulLabelLength;
  CK_SSL3_RANDOM_DATA RandomInfo;
  CK_BYTE_PTR pContextData;
  CK_ULONG ulContextDataLength;
} CK_TLS_KDF_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfMechanism_
: the hash mechanism used in the TLS1.2 PRF construct or **CKM_TLS_PRF** to use
  with the TLS1.0 and 1.1 PRF construct. 

_pLabel_
: a pointer to the label for this key derivation 

_ulLabelLength_
: length of the label in bytes

_RandomInfo_
: the random data for the key derivation as specified in section [6.39.2]

_pContextData_
: a pointer to the context data for this key derivation. NULL_PTR if not present

_ulContextDataLength_
: length of the context data in bytes. 0 if not present.

**CK_TLS_KDF_PARAMS_PTR** is a pointer to a **CK_TLS_KDF_PARAMS**.

#### CK_TLS_MAC_PARAMS
\  

**CK_TLS_MAC_PARAMS** is a structure that provides the parameters to the
**CKM_TLS_MAC** (and **CKM_TLS12_MAC)** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_TLS_MAC_PARAMS {
  CK_MECHANISM_TYPE prfHashMechanism;
  CK_ULONG ulMacLength;
  CK_ULONG ulServerOrClient;
} CK_TLS_MAC_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfHashMechanism_
: the hash mechanism used in the TLS12 PRF construct or **CKM_TLS_PRF** to use
  with the TLS1.0 and 1.1 PRF construct. 

_ulMacLength_
: the length of the MAC tag required or offered. Always 12 octets in TLS 1.0 and
  1.1. Generally 12 octets, but may be negotiated to a longer value in TLS1.2.

_ulServerOrClient_
: 1 to use the label "server finished", 2 to use the label "client finished".
  All other values are invalid.

**CK_TLS_MAC_PARAMS_PTR** is a pointer to a **CK_TLS_MAC_PARAMS**.

#### CK_TLS_PRF_PARAMS
\  

**CK_TLS_PRF_PARAMS** is a structure, which provides the parameters to the
**CKM_TLS_PRF** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_TLS_PRF_PARAMS {
  CK_BYTE_PTR       pSeed;
  CK_ULONG          ulSeedLen;
  CK_BYTE_PTR       pLabel;
  CK_ULONG          ulLabelLen;
  CK_BYTE_PTR       pOutput;
  CK_ULONG_PTR      pulOutputLen;
} CK_TLS_PRF_PARAMS;
~~~

The fields of the structure have the following meanings:

_pSeed_
: pointer to the input seed

_ulSeedLen_
: length in bytes of the input seed

_pLabel_
: pointer to the identifying label

_ulLabelLen_
: length in bytes of the identifying label

_pOutput_
: pointer receiving the output of the operation

_pulOutputLen_
: pointer to the length in bytes that the output to be created shall have, has
  to hold the desired length as input and will receive the calculated length as
  output

**CK_TLS_PRF_PARAMS_PTR** is a pointer to a **CK_TLS_PRF_PARAMS**.

### TLS MAC

The TLS MAC mechanism is used to generate integrity tags for the TLS "finished"
message. It replaces the use of the **CKM_TLS_PRF** function for TLS1.0 and 1.1
and that mechanism is deprecated.

**CKM_TLS_MAC** takes a parameter of CK_TLS_MAC_PARAMS. To use this mechanism
with TLS1.0 and TLS1.1, use **CKM_TLS_PRF** as the value for prfMechanism in
place of a hash mechanism. Note: Although **CKM_TLS_PRF** is deprecated as a
mechanism for C_DeriveKey, the manifest value is retained for use with this
mechanism to indicate the use of the TLS1.0/1.1 pseudo-random function.

In TLS1.0 and 1.1 the "finished" message verify_data (i.e. the output signature
from the MAC mechanism) is always 12 bytes. In TLS1.2 the "finished" message
verify_data is a minimum of 12 bytes, defaults to 12 bytes, but may be
negotiated to longer length.

Note: **CKM_TLS12_MAC** is provided only for historical reasons and should be
considered deprecated. This mechanism shares the same behavior with
**CKM_TLS_MAC**.

| Function | Key type       | Data length | Signature length              |
|----------|----------------|-------------|-------------------------------|
| C_Sign   | generic secret | any         | ≥ 12 bytes                    |
| C_Verify | generic secret | any         | ≥ 12 bytes                    |
table: General-length TLS MAC: Key And Data Length

### Master key derivation

Master key derivation in TLS 1.2, denoted **CKM_TLS12_MASTER_KEY_DERIVE**, is a
mechanism used to derive one 48-byte generic secret key from another 48-byte
generic secret key. It is used to produce the "master_secret" key used in the
TLS protocol from the "pre_master" key. This mechanism returns the value of the
client version, which is built into the "pre_master" key as well as a handle to
the derived "master_secret" key. **CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE** is the
same as **CKM_TLS12_MASTER_KEY_DERIVE** except it uses [RFC 7627] as the method
to generate a new 48 byte generic secret key.

**CKM_TLS12_MASTER_KEY_DERIVE** has a parameter, a
**CK_TLS12_MASTER_KEY_DERIVE_PARAMS** structure, which allows for the passing of
random data to the token, the underlying prf used in the key derivation, as well
as the returning of the protocol version number which is part of the pre-master
key. This structure is defined in section [6.40.2].

**CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE** has a parameter, a
**CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS** structure, which allows for the
passing of session hash, the underlying prf used in the key derivation, as well
as the returning of the protocol version number which is part of the pre-master
key. This structure is defined in section [6.40.2].

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The mechanism also contributes the **CKA_ALLOWED_MECHANISMS** attribute
consisting only of **CKM_TLS12_KEY_AND_MAC_DERIVE**,
**CKM_TLS12_KEY_SAFE_DERIVE**, **CKM_TLS_KDF**, **CKM_TLS_MAC**. Additionally
implementations that support them can add the deprecated **CKM_TLS12_KDF** and
**CKM_TLS12_MAC** mechanisms.

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
**CK_SSL3_MASTER_KEY_DERIVE_PARAMS** structure’s pVersion field will be modified
by the **C_DeriveKey** call. In particular, when the call returns, this
structure will hold the SSL version associated with the supplied pre_master key.

Note that this mechanism is only useable for cipher suites that use a 48-byte
“pre_master” secret with an embedded version number. This includes the RSA
cipher suites, but excludes the Diffie-Hellman cipher suites.

### Master key derivation for Diffie-Hellman

Master key derivation for Diffie-Hellman in TLS 1.2, denoted
**CKM_TLS12_MASTER_KEY_DERIVE_DH** is a mechanism used to derive one 48-byte
generic secret key from another arbitrary length generic secret key. It is used
to produce the "master_secret" key used in the TLS protocol from the
"pre_master" key. **CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE_DH** is the same as
**CKM_TLS12_MASTER_KEY_DERIVE_DH** except it uses [RFC 7627] as the method to
generate a new 48 byte generic secret key.

**CKM_TLS12_MASTER_KEY_DERIVE_DH** has a parameter, a
**CK_TLS12_MASTER_KEY_DERIVE_PARAMS** structure, which allows for the passing of
random data to the token and the underlying prf used to generate the key. This
structure is defined in section 6.40.2. The pVersion field of the structure must
be set to NULL_PTR since the version number is not embedded in the "pre_master"
key as it is for RSA-like cipher suites.

**CKM_TLS12_EXTENDED_MASTER_KEY_DERIVE_DH** has a parameter, a
**CK_TLS12_EXTENDED_MASTER_KEY_DERIVE_PARAMS** structure, which allows for the
passing of session hash to the token and the underlying prf used to generate the
key. This structure is defined in section 6.40.2. The pVersion field of the
structure must be set to NULL_PTR since the version number is not embedded in
the "pre_master" key as it is for RSA-like cipher suites.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The mechanism also contributes the **CKA_ALLOWED_MECHANISMS** attribute
consisting only of **CKM_TLS12_KEY_AND_MAC_DERIVE**,
**CKM_TLS12_KEY_SAFE_DERIVE**, **CKM_TLS_KDF**, **CKM_TLS_MAC**. Additionally
implementations that support them can add the deprecated **CKM_TLS12_KDF** and
**CKM_TLS12_MAC** mechanisms.

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
**CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has its
**CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
**CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
**CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has its
**CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
**CKA_EXTRACTABLE** attribute.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure both indicate 48 bytes.  Note that this
mechanism is only useable for cipher suites that do not use a fixed length
48-byte “pre_master” secret with an embedded version number. This includes the
Diffie-Hellman cipher suites, but excludes the RSA cipher suites.

### Key and MAC derivation

Key, MAC and IV derivation in TLS 1.2, denoted **CKM_TLS12_KEY_AND_MAC_DERIVE**,
is a mechanism used to derive the appropriate cryptographic keying material used
by a "CipherSuite" from the "master_secret" key and random data. This mechanism
returns the key handles for the keys generated in the process, as well as the
IVs created.

It has a parameter, a **CK_SSL3_KEY_MAT_PARAMS** structure, which allows for the
passing of random data as well as the characteristic of the cryptographic
material for the given CipherSuite and a pointer to a structure which receives
the handles and IVs which were generated. This structure is defined in section
[6.39.2].

This mechanism contributes to the creation of four distinct keys on the token
and returns two IVs (if IVs are requested by the caller) back to the caller. The
keys are all given an object class of **CKO_SECRET_KEY**. 

The two MACing keys ("client_write_MAC_secret" and "server_write_MAC_secret")
(if present) are always given a type of **CKK_GENERIC_SECRET**. They are flagged
as valid for signing and verification.

The other two keys ("client_write_key" and "server_write_key") are typed
according to information found in the template sent along with this mechanism
during a **C_DeriveKey** function call. By default, they are flagged as valid
for encryption, decryption, and derivation operations.

For **CKM_TLS12_KEY_AND_MAC_DERIVE**, IVs will be generated and returned if the
_ulIVSizeInBits_ field of the **CK_SSL3_KEY_MAT_PARAMS** field has a nonzero
value. If they are generated, their length in bits will agree with the value in
the _ulIVSizeInBits_ field.

~~~
Note Well: **CKM_TLS12_KEY_AND_MAC_DERIVE** produces both private (key) and
public (IV) data. It is possible to "leak" private data by the simple expedient
of decreasing the length of private data requested. E.g. Setting ulMacSizeInBits
and ulKeySizeInBits to 0 (or other lengths less than the key size) will result
in the private key data being placed in the destination designated for the IV's.
Repeated calls with the same master key and same RandomInfo but with differing
lengths for the private key material will result in different data being leaked.
~~~

All four keys inherit the values of the **CKA_SENSITIVE**,
**CKA_ALWAYS_SENSITIVE**, **CKA_EXTRACTABLE**, and **CKA_NEVER_EXTRACTABLE**
attributes from the base key. The template provided to **C_DeriveKey** may not
specify values for any of these attributes which differ from those held by the
base key.

Note that the **CK_SSL3_KEY_MAT_OUT** structure pointed to by the
**CK_SSL3_KEY_MAT_PARAMS** structure’s _pReturnedKeyMaterial_ field will be
modified by the **C_DeriveKey** call. In particular, the four key handle fields
in the **CK_SSL3_KEY_MAT_OUT** structure will be modified to hold handles to the
newly-created keys; in addition, the buffers pointed to by the
**CK_SSL3_KEY_MAT_OUT** structure’s _pIVClient_ and _pIVServer_ fields will have
IVs returned in them (if IVs are requested by the caller). Therefore, these two
fields must point to buffers with sufficient space to hold any IVs that will be
returned.

This mechanism departs from the other key derivation mechanisms in Cryptoki in
its returned information. For most key-derivation mechanisms, **C_DeriveKey**
returns a single key handle as a result of a successful completion. However,
since the **CKM_TLS12_KEY_AND_MAC_DERIVE** mechanism returns all of its key
handles in the **CK_SSL3_KEY_MAT_OUT** structure pointed to by the
**CK_SSL3_KEY_MAT_PARAMS** structure specified as the mechanism parameter, the
parameter _phKey_ passed to **C_DeriveKey** is unnecessary, and should be a
NULL_PTR.

If a call to **C_DeriveKey** with this mechanism fails, then none of the four
keys will be created on the token.

### CKM_TLS12_KEY_SAFE_DERIVE

**CKM_TLS12_KEY_SAFE_DERIVE** is identical to **CKM_TLS12_KEY_AND_MAC_DERIVE**
except that it shall never produce IV data, and the _ulIvSizeInBits_ field of
**CK_TLS12_KEY_MAT_PARAMS** is ignored and treated as 0. All of the other
conditions and behavior described for **CKM_TLS12_KEY_AND_MAC_DERIVE**, with the
exception of the black box warning, apply to this mechanism. 

**CKM_TLS12_KEY_SAFE_DERIVE** is provided as a separate mechanism to allow a
client to control the export of IV material (and possible leaking of key
material) through the use of the **CKA_ALLOWED_MECHANISMS** key attribute.

### Generic Key Derivation using the TLS PRF

**CKM_TLS_KDF** is the mechanism defined in [RFC 5705]. It uses the TLS key
material and TLS PRF function to produce additional key material for protocols
that want to leverage the TLS key negotiation mechanism. **CKM_TLS_KDF** has a
parameter of **CK_TLS_KDF_PARAMS**. If the protocol using this mechanism does
not use context information, the _pContextData_ field shall be set to NULL_PTR
and the _ulContextDataLength_ field shall be set to 0.

To use this mechanism with TLS1.0 and TLS1.1, use **CKM_TLS_PRF** as the value
for prfMechanism in place of a hash mechanism. Note: Although **CKM_TLS_PRF** is
deprecated as a mechanism for **C_DeriveKey**, the manifest value is retained
for use with this mechanism to indicate the use of the TLS1.0/1.1 Pseudo-random
function.

This mechanism can be used to derive multiple keys (e.g. similar to
**CKM_TLS12_KEY_AND_MAC_DERIVE)** by first deriving the key stream as a
**CKK_GENERIC_SECRET** of the necessary length and doing subsequent derives
against that derived key using the **CKM_EXTRACT_KEY_FROM_KEY** mechanism to
split the key stream into the actual operational keys.

The mechanism should not be used with the labels defined for use with TLS, but
the token does not enforce this behavior.

This mechanism has the following rules about key sensitivity and extractability:

- If the original key has its **CKA_SENSITIVE** attribute set to CK_TRUE, so
  does the derived key. If not, then the derived key’s **CKA_SENSITIVE**
  attribute is set either from the supplied template or from the original key.
- Similarly, if the original key has its **CKA_EXTRACTABLE** attribute set to
  CK_FALSE, so does the derived key. If not, then the derived key’s
  **CKA_EXTRACTABLE** attribute is set either from the supplied template or from
  the original key.
- The derived key’s **CKA_ALWAYS_SENSITIVE** attribute is set to CK_TRUE if and
  only if the original key has its **CKA_ALWAYS_SENSITIVE** attribute set to
  CK_TRUE.
- Similarly, the derived key’s **CKA_NEVER_EXTRACTABLE** attribute is set to
  CK_TRUE if and only if the original key has its **CKA_NEVER_EXTRACTABLE**
  attribute set to CK_TRUE.

### Deprecated TLS 1.2 mechanisms

**CKM_TLS12_KDF** and **CKM_TLS12_MAC** are considered aliases of the
corresponding **CKM_TLS_KDF** and **CKM_TLS_MAC** mechanisms and behave
identically. These mechanisms are available with a different identifier for
historical reasons and are considered deprecated.
