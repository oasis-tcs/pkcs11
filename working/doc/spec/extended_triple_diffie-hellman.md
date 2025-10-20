## Extended Triple Diffie-Hellman (x3dh)

The Extended Triple Diffie-Hellman mechanism described here is the one described
in [SIGNAL].

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_X3DH_INITIALIZE                  |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X3DH_RESPOND                     |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Extended Triple Diffie-Hellman Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_X3DH_INITIALIZE
- CKM_X3DH_RESPOND

### Extended Triple Diffie-Hellman key objects

Extended Triple Diffie-Hellman uses Elliptic Curve keys in Montgomery
representation (**CKK_EC_MONTGOMERY**). Three different kinds of keys are used,
they differ in their lifespan:

* identity keys are long-term keys, which identify the peer,
* prekeys are short-term keys, which should be rotated often (weekly to hourly)
* onetime prekeys are keys, which should be used only once.

Any peer intending to be contacted using X3DH must publish their so-called
prekey-bundle, consisting of their: 

* public Identity key, 
* current prekey, signed using XEDDSA with their identity key 
* optionally a batch of One-time public keys.

### Initiating an Extended Triple Diffie-Hellman key exchange

Initiating an Extended Triple Diffie-Hellman key exchange starts by retrieving
the following required public keys (the so-called prekey-bundle) of the other
peer: the Identity key, the signed public Prekey, and optionally one One-time
public key.

When the necessary key material is available, the initiating party calls
**CKM_X3DH_INITIALIZE**, also providing the following additional parameters:

* the initiator’s identity key
* the initiator’s ephemeral key (a fresh, one-time CKK_EC_MONTGOMERY type key)

**CK_X3DH_INITIATE_PARAMS** is a structure that provides the parameters to the
**CKM_X3DH_INITIALIZE** key exchange mechanism. The structure is defined as
follows:

~~~{.c}
typedef struct CK_X3DH_INITIATE_PARAMS {
	CK_X3DH_KDF_TYPE	kdf;
	CK_OBJECT_HANDLE	pPeer_identity;
	CK_OBJECT_HANDLE	pPeer_prekey;
	CK_BYTE_PTR	pPrekey_signature;
	CK_BYTE_PTR	pOnetime_key;
	CK_OBJECT_HANDLE	pOwn_identity;
	CK_OBJECT_HANDLE	pOwn_ephemeral;
}	CK_X3DH_INITIATE_PARAMS;
~~~

| Parameter         | Data type       | Meaning                          |
|-------------------|-----------------|----------------------------------|
| kdf               | CK_X3DH_KDF_TYPE | Key derivation function         |
| pPeer_identity    | Key handle | Peer’s public Identity key (from the prekey-bundle) |
| pPeer_prekey      | Key Handle | Peer’s public prekey (from the prekey-bundle) |
| pPrekey_signature | Byte array | XEDDSA signature of PEER_PREKEY (from prekey-bundle) |
| pOnetime_key      | Byte array | Optional one-time public prekey of peer (from the prekey-bundle) |
| pOwn_identity     | Key Handle | Initiators Identity key               |
| pOwn_ephemeral    | Key Handle | Initiators ephemeral key              |
table: Extended Triple Diffie-Hellman Initiate Message parameters

### Responding to an Extended Triple Diffie-Hellman key exchange

Responding an Extended Triple Diffie-Hellman key exchange is done by executing a
**CKM_X3DH_RESPOND** mechanism. **CK_X3DH_RESPOND_PARAMS** is a structure that
provides the parameters to the **CKM_X3DH_RESPOND** key exchange mechanism. All
these parameter should be supplied by the Initiator in a message to the
responder. The structure is defined as follows:

~~~{.c}
typedef struct CK_X3DH_RESPOND_PARAMS {
	CK_X3DH_KDF_TYPE	kdf;
	CK_BYTE_PTR	pIdentity_id;
	CK_BYTE_PTR	pPrekey_id;
	CK_BYTE_PTR	pOnetime_id;
	CK_OBJECT_HANDLE	pInitiator_identity;
	CK_BYTE_PTR	pInitiator_ephemeral;
}	CK_X3DH_RESPOND_PARAMS;
~~~

| Parameter            | Data type        | Meaning                      |
|----------------------|------------------|------------------------------|
| kdf                  | CK_X3DH_KDF_TYPE | Key derivation function      |
| pIdentity_id         | Byte array | Peer’s public Identity key identifier (from the prekey-bundle) |
| pPrekey_id           | Byte array | Peer’s public prekey identifier (from the prekey-bundle) |
| pOnetime_id          | Byte array | Optional one-time public prekey of peer (from the prekey-bundle) |
| pInitiator_identity  | Key handle | Initiators Identity key            |
| pInitiator_ephemeral | Byte array | Initiators ephemeral key           |
table: Extended Triple Diffie-Hellman 1st Message parameters

Where the \*_id fields are identifiers marking which key has been used from the
prekey-bundle, these identifiers could be the keys themselves.

This mechanism has the following rules about key sensitivity and
extractability^1^:

1) The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for the new
   key can both be specified to be either CK_TRUE or CK_FALSE. If omitted, these
   attributes each take on some default value.

2) If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE, then
   the derived key will as well. If the base key has its **CKA_ALWAYS_SENSITIVE**
   attribute set to CK_TRUE, then the derived key has its **CKA_ALWAYS_SENSITIVE**
   attribute set to the same value as its **CKA_SENSITIVE** attribute.

3) Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
   CK_FALSE, then the derived key will, too. If the base key has its
   **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
   its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
   **CKA_EXTRACTABLE** attribute.

### Extended Triple Diffie-Hellman parameters

#### CK_X3DH_KDF_TYPE
\  

**CK_X3DH_KDF_TYPE** is used to indicate the Key Derivation Function (KDF)
applied to derive keying data from a shared secret. The key derivation function
will be used by the X3DH key agreement schemes. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_X3DH_KDF_TYPE;
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
table: X3DH: Key Derivation Functions
