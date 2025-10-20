## WTLS Mechanisms

Details can be found in [WTLS].

When comparing the existing TLS mechanisms with these extensions to support WTLS
one could argue that there would be no need to have distinct handling of the
client and server side of the handshake. However, since in WTLS the server and
client use different sequence numbers, there could be instances (e.g. when WTLS
is used to protect asynchronous protocols) where sequence numbers on the client
and server side differ, and hence this motivates the introduced split.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_WTLS_PRE_MASTER_KEY_GEN          |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_WTLS_MASTER_KEY_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_WTLS_MASTER_KEY_DERIVE_DH_ECC    |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE   |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE   |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_WTLS_PRF                         |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: WTLS Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_WTLS_PRE_MASTER_KEY_GEN
- CKM_WTLS_MASTER_KEY_DERIVE
- CKM_WTLS_MASTER_KEY_DERIVE_DH_ECC
- CKM_WTLS_PRF
- CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE
- CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE

### WTLS mechanism parameters

#### CK_WTLS_RANDOM_DATA
\  

**CK_WTLS_RANDOM_DATA** is a structure, which provides information about the
random data of a client and a server in a WTLS context. This structure is used
by the CKM_WTLS_MASTER_KEY_DERIVE mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_WTLS_RANDOM_DATA {
  CK_BYTE_PTR pClientRandom;
  CK_ULONG    ulClientRandomLen;
  CK_BYTE_PTR pServerRandom;
  CK_ULONG    ulServerRandomLen;
} CK_WTLS_RANDOM_DATA;
~~~

The fields of the structure have the following meanings:

_pClientRandom_
: pointer to the client’s random data

_pClientRandomLen_
: length in bytes of the client’s random data

_pServerRaondom_
: pointer to the server’s random data

_ulServerRandomLen_
: length in bytes of the server’s random data

**CK_WTLS_RANDOM_DATA_PTR** is a pointer to a **CK_WTLS_RANDOM_DATA**.

#### CK_WTLS_MASTER_KEY_DERIVE_PARAMS
\  

**CK_WTLS_MASTER_KEY_DERIVE_PARAMS** is a structure, which provides the
parameters to the CKM_WTLS_MASTER_KEY_DERIVE mechanism. It is defined as
follows:

~~~{.c}
typedef struct CK_WTLS_MASTER_KEY_DERIVE_PARAMS {
  CK_MECHANISM_TYPE   DigestMechanism;
  CK_WTLS_RANDOM_DATA RandomInfo;
  CK_BYTE_PTR         pVersion;
} CK_WTLS_MASTER_KEY_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_DigestMechanism_
: the mechanism type of the digest mechanism to be used (possible types can be
  found in [WTLS])

_RandomInfo_
: Client’s and server’s random data information

_pVersion_
: pointer to a CK_BYTE which receives the WTLS protocol version information

**CK_WTLS_MASTER_KEY_DERIVE_PARAMS_PTR** is a pointer to a
**CK_WTLS_MASTER_KEY_DERIVE_PARAMS**.

#### CK_WTLS_PRF_PARAMS
\  

**CK_WTLS_PRF_PARAMS** is a structure, which provides the parameters to the
CKM_WTLS_PRF mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_WTLS_PRF_PARAMS {
  CK_MECHANISM_TYPE DigestMechanism;
  CK_BYTE_PTR       pSeed;
  CK_ULONG          ulSeedLen;
  CK_BYTE_PTR       pLabel;
  CK_ULONG          ulLabelLen;
  CK_BYTE_PTR       pOutput;
  CK_ULONG_PTR      pulOutputLen;
} CK_WTLS_PRF_PARAMS;
~~~

The fields of the structure have the following meanings:

_Digest Mechanism_
: the mechanism type of the digest mechanism to be used (possible types can be
  found in [WTLS])

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

**CK_WTLS_PRF_PARAMS_PTR** is a pointer to a **CK_WTLS_PRF_PARAMS**.

#### CK_WTLS_KEY_MAT_OUT
\  

**CK_WTLS_KEY_MAT_OUT** is a structure that contains the resulting key handles
and initialization vectors after performing a C_DeriveKey function with the
**CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE** or with the
**CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_WTLS_KEY_MAT_OUT {
  CK_OBJECT_HANDLE hMacSecret;
  CK_OBJECT_HANDLE hKey;
  CK_BYTE_PTR      pIV;
} CK_WTLS_KEY_MAT_OUT;
~~~

The fields of the structure have the following meanings:

_hMacSecret_
: Key handle for the resulting MAC secret key

_hKey_
: Key handle for the resulting secret key

_pIV_
: Pointer to a location which receives the initialization vector (IV) created
  (if any)

**CK_WTLS_KEY_MAT_OUT** _PTR is a pointer to a **CK_WTLS_KEY_MAT_OUT**.

#### CK_WTLS_KEY_MAT_PARAMS
\  

**CK_WTLS_KEY_MAT_PARAMS** is a structure that provides the parameters to the
**CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE** and the
**CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE** mechanisms. It is defined as follows:

~~~{.c}
typedef struct CK_WTLS_KEY_MAT_PARAMS {
  CK_MECHANISM_TYPE       DigestMechanism;
  CK_ULONG                ulMacSizeInBits;
  CK_ULONG                ulKeySizeInBits;
  CK_ULONG                ulIVSizeInBits;
  CK_ULONG                ulSequenceNumber;
  CK_BBOOL                bIsExport;
  CK_WTLS_RANDOM_DATA     RandomInfo;
  CK_WTLS_KEY_MAT_OUT_PTR pReturnedKeyMaterial;
} CK_WTLS_KEY_MAT_PARAMS;
~~~

The fields of the structure have the following meanings:

_Digest Mechanism_
: the mechanism type of the digest mechanism to be used (possible types can be
  found in [WTLS])

_ulMaxSizeInBits_
: the length (in bits) of the MACing key agreed upon during the protocol
  handshake phase

_ulKeySizeInBits_
: the length (in bits) of the secret key agreed upon during the handshake phase

_ulIVSizeInBits_
: the length (in bits) of the IV agreed upon during the handshake phase. If no
  IV is required, the length should be set to 0.

_ulSequenceNumber_
: the current sequence number used for records sent by the client and server
  respectively

_bIsExport_
: a boolean value which indicates whether the keys have to be derives for an
  export version of the protocol. If this value is true (i.e., the keys are
  exportable) then ulKeySizeInBits is the length of the key in bits before
  expansion. The length of the key after expansion is determined by the
  information found in the template sent along with this mechanism during a
  **C_DeriveKey** function call (either the **CKA_KEY_TYPE** or the
  **CKA_VALUE_LEN** attribute).

_RandomInfo_
: client’s and server’s random data information

_pReturnedKeyMaterial_
: points to a **CK_WTLS_KEY_MAT_OUT** structure which receives the handles for
  the keys generated and the IV

**CK_WTLS_KEY_MAT_PARAMS_PTR** is a pointer to a **CK_WTLS_KEY_MAT_PARAMS**.

### Pre master secret key generation for RSA key exchange suite

Pre master secret key generation for the RSA key exchange suite in WTLS denoted
**CKM_WTLS_PRE_MASTER_KEY_GEN**, is a mechanism, which generates a variable
length secret key. It is used to produce the pre master secret key for RSA key
exchange suite used in WTLS. This mechanism returns a handle to the pre master
secret key.

It has one parameter, a **CK_BYTE**, which provides the client’s WTLS version.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE** and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The template sent along with this mechanism during a **C_GenerateKey** call may
indicate that the object class is **CKO_SECRET_KEY**, the key type is
**CKK_GENERIC_SECRET**, and the **CKA_VALUE_LEN** attribute indicates the length
of the pre master secret key.

For this mechanism, the ulMinKeySize field of the **CK_MECHANISM_INFO**
structure shall indicate 20 bytes.

### Master secret key derivation

Master secret derivation in WTLS, denoted **CKM_WTLS_MASTER_KEY_DERIVE**, is a
mechanism used to derive a 20 byte generic secret key from variable length
secret key. It is used to produce the master secret key used in WTLS from the
pre master secret key. This mechanism returns the value of the client version,
which is built into the pre master secret key as well as a handle to the derived
master secret key.

It has a parameter, a **CK_WTLS_MASTER_KEY_DERIVE_PARAMS** structure, which
allows for passing the mechanism type of the digest mechanism to be used as well
as the passing of random data to the token as well as the returning of the
protocol version number which is part of the pre master secret key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The template sent along with this mechanism during a **C_DeriveKey** call may
indicate that the object class is **CKO_SECRET_KEY**, the key type is
**CKK_GENERIC_SECRET**, and the **CKA_VALUE_LEN** attribute has value 20.
However, since these facts are all implicit in the mechanism, there is no need
to specify any of them.

This mechanism has the following rules about key sensitivity and extractability:

The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for the
new key can both be specified to be either CK_TRUE or CK_FALSE. If omitted,
these attributes each take on some default value.

If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE, then
the derived key will as well. If the base key has its **CKA_ALWAYS_SENSITIVE**
attribute set to CK_TRUE, then the derived key has its **CKA_ALWAYS_SENSITIVE**
attribute set to the same value as its **CKA_SENSITIVE** attribute.

Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
CK_FALSE, then the derived key will, too. If the base key has its
**CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has its
**CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
**CKA_EXTRACTABLE** attribute.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure both indicate 20 bytes.

Note that the **CK_BYTE** pointed to by the **CK_WTLS_MASTER_KEY_DERIVE_PARAMS**
structure’s pVersion field will be modified by the **C_DeriveKey** call. In
particular, when the call returns, this byte will hold the WTLS version
associated with the supplied pre master secret key.

Note that this mechanism is only useable for key exchange suites that use a
20-byte pre master secret key with an embedded version number. This includes the
RSA key exchange suites, but excludes the Diffie-Hellman and Elliptic Curve
Cryptography key exchange suites.

### Master secret key derivation for Diffie-Hellman and Elliptic Curve Cryptography

Master secret derivation for Diffie-Hellman and Elliptic Curve Cryptography in
WTLS, denoted **CKM_WTLS_MASTER_KEY_DERIVE_DH_ECC**, is a mechanism used to
derive a 20 byte generic secret key from variable length secret key. It is used
to produce the master secret key used in WTLS from the pre master secret key.
This mechanism returns a handle to the derived master secret key.

It has a parameter, a **CK_WTLS_MASTER_KEY_DERIVE_PARAMS** structure, which
allows for the passing of the mechanism type of the digest mechanism to be used
as well as random data to the token. The pVersion field of the structure must be
set to NULL_PTR since the version number is not embedded in the pre master
secret key as it is for RSA-like key exchange suites.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key (as well as the **CKA_VALUE_LEN** attribute, if it is
not supplied in the template). Other attributes may be specified in the
template, or else are assigned default values.

The template sent along with this mechanism during a **C_DeriveKey** call may
indicate that the object class is **CKO_SECRET_KEY**, the key type is
**CKK_GENERIC_SECRET**, and the **CKA_VALUE_LEN** attribute has value 20.
However, since these facts are all implicit in the mechanism, there is no need
to specify any of them.

This mechanism has the following rules about key sensitivity and extractability:

The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for the
new key can both be specified to be either CK_TRUE or CK_FALSE. If omitted,
these attributes each take on some default value.

If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE, then
the derived key will as well. If the base key has its **CKA_ALWAYS_SENSITIVE**
attribute set to CK_TRUE, then the derived key has its **CKA_ALWAYS_SENSITIVE**
attribute set to the same value as its **CKA_SENSITIVE** attribute.

Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
CK_FALSE, then the derived key will, too. If the base key has its
**CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has its
**CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
**CKA_EXTRACTABLE** attribute.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure both indicate 20 bytes.

Note that this mechanism is only useable for key exchange suites that do not use
a fixed length 20-byte pre master secret key with an embedded version number.
This includes the Diffie-Hellman and Elliptic Curve Cryptography key exchange
suites, but excludes the RSA key exchange suites.

### WTLS PRF (pseudorandom function)

PRF (pseudo random function) in WTLS, denoted **CKM_WTLS_PRF**, is a mechanism
used to produce a securely generated pseudo-random output of arbitrary length.
The keys it uses are generic secret keys.

It has a parameter, a **CK_WTLS_PRF_PARAMS** structure, which allows for passing
the mechanism type of the digest mechanism to be used, the passing of the input
seed and its length, the passing of an identifying label and its length and the
passing of the length of the output to the token and for receiving the output.

This mechanism produces securely generated pseudo-random output of the length
specified in the parameter.

This mechanism departs from the other key derivation mechanisms in Cryptoki in
not using the template sent along with this mechanism during a **C_DeriveKey**
function call, which means the template shall be a NULL_PTR. For most
key-derivation mechanisms, **C_DeriveKey** returns a single key handle as a
result of a successful completion. However, since the **CKM_WTLS_PRF** mechanism
returns the requested number of output bytes in the **CK_WTLS_PRF_PARAMS**
structure specified as the mechanism parameter, the parameter phKey passed to
**C_DeriveKey** is unnecessary and should be a NULL_PTR.

If a call to **C_DeriveKey** with this mechanism fails, then no output will be
generated.

### Server Key and MAC derivation

Server key, MAC and IV derivation in WTLS, denoted
**CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE**, is a mechanism used to derive the
appropriate cryptographic keying material used by a cipher suite from the master
secret key and random data. This mechanism returns the key handles for the keys
generated in the process, as well as the IV created.

It has a parameter, a **CK_WTLS_KEY_MAT_PARAMS** structure, which allows for the
passing of the mechanism type of the digest mechanism to be used, random data,
the characteristic of the cryptographic material for the given cipher suite, and
a pointer to a structure which receives the handles and IV which were generated.

This mechanism contributes to the creation of two distinct keys and returns one
IV (if an IV is requested by the caller) back to the caller. The keys are all
given an object class of **CKO_SECRET_KEY**. 

The MACing key (server write MAC secret) is always given a type of
**CKK_GENERIC_SECRET**. It is flagged as valid for signing, verification and
derivation operations.

The other key (server write key) is typed according to information found in the
template sent along with this mechanism during a **C_DeriveKey** function call.
By default, it is flagged as valid for encryption, decryption, and derivation
operations.

An IV (server write IV) will be generated and returned if the ulIVSizeInBits
field of the **CK_WTLS_KEY_MAT_PARAMS** field has a nonzero value. If it is
generated, its length in bits will agree with the value in the ulIVSizeInBits
field.

Both keys inherit the values of the **CKA_SENSITIVE**, **CKA_ALWAYS_SENSITIVE**,
**CKA_EXTRACTABLE**, and **CKA_NEVER_EXTRACTABLE** attributes from the base key.
The template provided to **C_DeriveKey** may not specify values for any of these
attributes that differ from those held by the base key.

Note that the **CK_WTLS_KEY_MAT_OUT** structure pointed to by the
**CK_WTLS_KEY_MAT_PARAMS** structure’s pReturnedKeyMaterial field will be
modified by the **C_DeriveKey** call. In particular, the two key handle fields
in the **CK_WTLS_KEY_MAT_OUT** structure will be modified to hold handles to the
newly created keys; in addition, the buffer pointed to by the
**CK_WTLS_KEY_MAT_OUT** structure’s pIV field will have the IV returned in them
(if an IV is requested by the caller). Therefore, this field must point to a
buffer with sufficient space to hold any IV that will be returned.

This mechanism departs from the other key derivation mechanisms in Cryptoki in
its returned information. For most key-derivation mechanisms, **C_DeriveKey**
returns a single key handle as a result of a successful completion. However,
since the **CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE** mechanism returns all of its
key handles in the **CK_WTLS_KEY_MAT_OUT** structure pointed to by the
**CK_WTLS_KEY_MAT_PARAMS** structure specified as the mechanism parameter, the
parameter phKey passed to **C_DeriveKey** is unnecessary and should be a
NULL_PTR.

If a call to **C_DeriveKey** with this mechanism fails, then none of the two
keys will be created.

### Client key and MAC derivation

Client key, MAC and IV derivation in WTLS, denoted
**CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE**, is a mechanism used to derive the
appropriate cryptographic keying material used by a cipher suite from the master
secret key and random data. This mechanism returns the key handles for the keys
generated in the process, as well as the IV created.

It has a parameter, a **CK_WTLS_KEY_MAT_PARAMS** structure, which allows for the
passing of the mechanism type of the digest mechanism to be used, random data,
the characteristic of the cryptographic material for the given cipher suite, and
a pointer to a structure which receives the handles and IV which were generated.

This mechanism contributes to the creation of two distinct keys and returns one
IV (if an IV is requested by the caller) back to the caller. The keys are all
given an object class of **CKO_SECRET_KEY**. 

The MACing key (client write MAC secret) is always given a type of
**CKK_GENERIC_SECRET**. It is flagged as valid for signing, verification and
derivation operations.

The other key (client write key) is typed according to information found in the
template sent along with this mechanism during a **C_DeriveKey** function call.
By default, it is flagged as valid for encryption, decryption, and derivation
operations.

An IV (client write IV) will be generated and returned if the ulIVSizeInBits
field of the **CK_WTLS_KEY_MAT_PARAMS** field has a nonzero value. If it is
generated, its length in bits will agree with the value in the ulIVSizeInBits
field.

Both keys inherit the values of the **CKA_SENSITIVE**, **CKA_ALWAYS_SENSITIVE**,
**CKA_EXTRACTABLE**, and **CKA_NEVER_EXTRACTABLE** attributes from the base key.
The template provided to **C_DeriveKey** may not specify values for any of these
attributes that differ from those held by the base key.

Note that the **CK_WTLS_KEY_MAT_OUT** structure pointed to by the
**CK_WTLS_KEY_MAT_PARAMS** structure’s pReturnedKeyMaterial field will be
modified by the **C_DeriveKey** call. In particular, the two key handle fields
in the **CK_WTLS_KEY_MAT_OUT** structure will be modified to hold handles to the
newly created keys; in addition, the buffer pointed to by the
**CK_WTLS_KEY_MAT_OUT** structure’s pIV field will have the IV returned in them
(if an IV is requested by the caller). Therefore, this field must point to a
buffer with sufficient space to hold any IV that will be returned.

This mechanism departs from the other key derivation mechanisms in Cryptoki in
its returned information. For most key-derivation mechanisms, **C_DeriveKey**
returns a single key handle as a result of a successful completion. However,
since the **CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE** mechanism returns all of its
key handles in the **CK_WTLS_KEY_MAT_OUT** structure pointed to by the
**CK_WTLS_KEY_MAT_PARAMS** structure specified as the mechanism parameter, the
parameter phKey passed to **C_DeriveKey** is unnecessary and should be a
NULL_PTR.

If a call to **C_DeriveKey** with this mechanism fails, then none of the two
keys will be created.
