## Double Ratchet

The Double Ratchet is a key management algorithm managing the ongoing renewal
and maintenance of short-lived session keys providing forward secrecy and
break-in recovery for encrypt/decrypt operations. The algorithm is described in
[DoubleRatchet]. The Signal protocol uses X3DH to exchange a shared secret in
the first step, which is then used to derive a Double Ratchet secret key.

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_X2RATCHET_INITIALIZE             |     |     |      |     |       |     |  ✓  |      |	
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X2RATCHET_RESPOND                |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X2RATCHET_ENCRYPT                |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X2RATCHET_DECRYPT                |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Double Ratchet Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_X2RATCHET**” for type CK_KEY_TYPE as
used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_X2RATCHET_INITIALIZE
-  CKM_X2RATCHET_RESPOND
- CKM_X2RATCHET_ENCRYPT
- CKM_X2RATCHET_DECRYPT

### Double Ratchet secret key objects

Double Ratchet secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_X2RATCHET**) hold Double Ratchet keys. Double Ratchet secret keys can only
be derived from shared secret keys using the mechanism
**CKM_X2RATCHET_INITIALIZE** or **CKM_X2RATCHET_RESPOND**. In the Signal
protocol these are seeded with the shared secret derived from an Extended Triple
Diffie-Hellman [X3DH] key-exchange. The following table defines the Double
Ratchet secret key object attributes, in addition to the common attributes
defined for this object class:

| Attribute                | Data type  | Meaning                        |
|--------------------------|------------|--------------------------------|
| CKA_X2RATCHET_RK         | Byte array | Root key                       |
| CKA_X2RATCHET_HKS        | Byte array | Sender Header key              |
| CKA_X2RATCHET_HKR        | Byte array | Receiver Header key            |
| CKA_X2RATCHET_NHKS       | Byte array | Next Sender Header Key         |
| CKA_X2RATCHET_NHKR       | Byte array | Next Receiver Header Key       |
| CKA_X2RATCHET_CKS        | Byte array | Sender Chain key               |
| CKA_X2RATCHET_CKR        | Byte array | Receiver Chain key             |
| CKA_X2RATCHET_DHS        | Byte array | Sender DH secret key           |
| CKA_X2RATCHET_DHP        | Byte array | Sender DH public key           |
| CKA_X2RATCHET_DHR        | Byte array | Receiver DH public key         |
| CKA_X2RATCHET_NS         | ULONG      | Message number send            |
| CKA_X2RATCHET_NR         | ULONG      | Message number receive         |
| CKA_X2RATCHET_PNS        | ULONG      | Previous message number send   |
| CKA_X2RATCHET_BOBS1STMSG | BOOL       | Is this bob and has he ever sent a message? |
| CKA_X2RATCHET_ISALICE    | BOOL       | Is this Alice?                 |
| CKA_X2RATCHET_BAGSIZE    | ULONG      | How many out-of-order keys do we store |
| CKA_X2RATCHET_BAG        | Byte array | Out-of-order keys              |
table: Double Ratchet Secret Key Object Attributes

### Double Ratchet key derivation

The Double Ratchet key derivation mechanisms depend on who is the initiating
party, and who the receiving, denoted **CKM_X2RATCHET_INITIALIZE** and
**CKM_X2RATCHET_RESPOND**, are the key derivation mechanisms for the Double
Ratchet. Usually, the keys are derived from a shared secret by executing a X3DH
key exchange.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Additionally, the attribute flags indicating which
functions the key supports are also contributed by the mechanism.

For this mechanism, the only allowed values are 255 and 448 as [RFC 8032] only
defines curves of these two sizes. A Cryptoki implementation may support one or
both of these curves and should set the _ulMinKeySize_ and _ulMaxKeySize_ fields
accordingly.

#### CK_X2RATCHET_INITIALIZE_PARAMS
\  

**CK_X2RATCHET_INITIALIZE_PARAMS** provides the parameters to the
**CKM_X2RATCHET_INITIALIZE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_X2RATCHET_INITIALIZE_PARAMS {
	CK_BYTE_PTR	sk;
	CK_OBJECT_HANDLE	peer_public_prekey;
	CK_OBJECT_HANDLE	peer_public_identity;
	CK_OBJECT_HANDLE	own_public_identity;
	CK_BBOOL	bEncryptedHeader;
	CK_ULONG	eCurve;
	CK_MECHANISM_TYPE	aeadMechanism;
	CK_X2RATCHET_KDF_TYPE	kdfMechanism;
}	CK_X2RATCHET_INITIALIZE_PARAMS;
~~~

The fields of the structure have the following meanings:

_sk_
: the shared secret with peer (derived using X3DH)

_peers_public_prekey_
: Peer’s public prekey which the Initiator used in the X3DH

_peers_public_identity_
: Peer’s public identity which the Initiator used in the X3DH

_own_public_identity_
: Initiators public identity as used in the X3DH

_bEncryptedHeader_
: whether the headers are encrypted

_eCurve_
: 255 for curve 25519 or 448 for curve 448

_aeadMechanism_
: a mechanism supporting AEAD encryption

_kdfMechanism_
: a Key Derivation Mechanism, such as CKD_BLAKE2B_512_KDF

#### CK_X2RATCHET_RESPOND_PARAMS
\  

**CK_X2RATCHET_RESPOND_PARAMS** provides the parameters to the
CKM_X2RATCHET_RESPOND mechanism. It is defined as follows:

~~~{.c}
Typedef struct CK_X2RATCHET_RESPOND_PARAMS {
	CK_BYTE_PTR	sk;
	CK_OBJECT_HANDLE	own_prekey;
	CK_OBJECT_HANDLE	initiator_identity;
	CK_OBJECT_HANDLE	own_public_identity;
	CK_BBOOL	bEncryptedHeader;
	CK_ULONG	eCurve;
	CK_MECHANISM_TYPE	aeadMechanism;
	CK_X2RATCHET_KDF_TYPE	kdfMechanism;
}	CK_X2RATCHET_RESPOND_PARAMS;
~~~

The fields of the structure have the following meanings:

_sk_
: shared secret with the Initiator

_own_prekey_
: Own Prekey pair that the Initiator used

_initiator_identity_
: Initiator’s public identity key used

_own_public_identity_
: as used in the prekey bundle by the initiator in the X3DH

_bEncryptedHeader_
: whether the headers are encrypted

_eCurve_
: 255 for curve 25519 or 448 for curve 448

_aeadMechanism_
: a mechanism supporting AEAD encryption

_kdfMechanism_
: a Key Derivation Mechanism, such as CKD_BLAKE2B_512_KDF

### Double Ratchet Encryption mechanism

The Double Ratchet encryption mechanism, denoted **CKM_X2RATCHET_ENCRYPT** and
**CKM_X2RATCHET_DECRYPT**, are mechanisms for single part encryption and
decryption based on the Double Ratchet and its underlying AEAD cipher.

### Double Ratchet parameters

#### CK_X2RATCHET_KDF_TYPE
\  

**CK_X2RATCHET_KDF_TYPE** is used to indicate the Key Derivation Function (KDF)
applied to derive keying data from a shared secret. The key derivation function
will be used by the X key derivation scheme. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_X2RATCHET_KDF_TYPE;
~~~

The following table lists the defined functions.

| Source Identifier   |
|---------------------|
| CKD_NULL            |
| CKD_BLAKE2B_256_KDF |
| CKD_BLAKE2B_512_KDF |
| CKD_SHA3_256_KDF    |
| CKD_SHA256_KDF      |
| CKD_SHA3_512_KDF    |
| CKD_SHA512_KDF      |
table: X2RATCHET: Key Derivation Functions
