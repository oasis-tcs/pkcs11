## Chacha20/Poly1305 and Salsa20/Poly1305 Authenticated Encryption / Decryption

The stream ciphers Salsa20 and ChaCha20 are normally used in conjunction with
the Poly1305 authenticator, in such a construction they also provide
Authenticated Encryption with Associated Data (AEAD). This section defines the
combined mechanisms and their usage in an AEAD setting.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_CHACHA20_POLY1305                |  ✓  |     |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SALSA20_POLY1305                 |  ✓  |     |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Poly1305 Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_CHACHA20_POLY1305
- CKM_SALSA20_POLY1305

### Usage

Generic ChaCha20, Salsa20, Poly1305 modes are described in [CHACHA], [SALSA] and
[POLY1305]. To set up for ChaCha20/Poly1305 or Salsa20/Poly1305 use the
following process. ChaCha20/Poly1305 and Salsa20/Poly1305 both use
CK_SALSA20_CHACHA20_POLY1305_PARAMS for Encrypt, Decrypt and
CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS for MessageEncrypt, and MessageDecrypt.

Encrypt:

- Set the Nonce length _ulNonceLen_ in the parameter block. (this affects which
  variant of Chacha20 will be used: 64 bits → original, 96 bits → IETF, 192 bits
→ XChaCha20)
- Set the Nonce data _pNonce_ in the parameter block.
- Set the AAD data _pAAD_ and size _ulAADLen_ in the parameter block. _pAAD_ may
  be NULL if _ulAADLen_ is 0.
- Call **C_EncryptInit** for **CKM_CHACHA20_POLY1305** or
  **CKM_SALSA20_POLY1305** mechanism with parameters and key _K_.
- Call **C_Encrypt**, or **C_EncryptUpdate**^1^ **C_EncryptFinal**, for the
  plaintext obtaining ciphertext and authentication tag output.

Decrypt:

- Set the Nonce length _ulNonceLen_ in the parameter block. (this affects which
  variant of Chacha20 will be used: 64 bits → original, 96 bits → IETF, 192 bits
  → XChaCha20)
- Set the Nonce data pNonce in the parameter block.
- Set the AAD data _pAAD_ and size _ulAADLen_ in the parameter block. _pAAD_ may
  be NULL if _ulAADLen_ is 0.
- Call **C_DecryptInit** for **CKM_CHACHA20_POLY1305** or
  **CKM_SALSA20_POLY1305** mechanism with parameters and key _K_.
- Call **C_Decrypt**, or **C_DecryptUpdate**^1^ **C_DecryptFinal**, for the
  ciphertext, including the appended tag, obtaining plaintext output. Note:
  since **CKM_CHACHA20_POLY1305** and **CKM_SALSA20_POLY1305** are AEAD ciphers,
  no data should be returned until **C_Decrypt** or **C_DecryptFinal**.

MessageEncrypt:

- Set the Nonce length _ulNonceLen_ in the parameter block. (this affects which
  variant of Chacha20 will be used: 64 bits → original, 96 bits → IETF, 192 bits
  → XChaCha20)
- Set the Nonce data _pNonce_ in the parameter block.
- Set _pTag_ to hold the tag data returned from **C_EncryptMessage** or the
  final **C_EncryptMessageNext**.
- Call **C_MessageEncryptInit** for **CKM_CHACHA20_POLY1305** or
  **CKM_SALSA20_POLY1305** mechanism with key _K_.
- Call **C_EncryptMessage**, or **C_EncryptMessageBegin** followed by
  **C_EncryptMessageNext**^2^. The mechanism parameter is passed to all three of
  these functions.
- Call **C_MessageEncryptFinal** to close the message decryption.

MessageDecrypt:

- Set the Nonce length _ulNonceLen_ in the parameter block. (this affects which
  variant of Chacha20 will be used: 64 bits → original, 96 bits → IETF, 192 bits
  → XChaCha20)
- Set the Nonce data _pNonce_ in the parameter block.
- Set the tag data _pTag_ in the parameter block before **C_DecryptMessage** or the
  final **C_DecryptMessageNext**.
- Call **C_MessageDecryptInit** for **CKM_CHACHA20_POLY1305** or CKM_SALSA20_POLY1305
  mechanism with key _K_.
- Call **C_DecryptMessage**, or **C_DecryptMessageBegin** followed by
  **C_DecryptMessageNext**^3^. The mechanism parameter is passed to all three of
  these functions.
- Call **C_MessageDecryptFinal** to close the message decryption

_ulNonceLen_ is the length of the nonce in bits.

In Encrypt and Decrypt the tag is appended to the ciphertext. In MessageEncrypt
the tag is returned in the _pTag_ filed of
**CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS**. In MesssageDecrypt the tag is
provided by the _pTag_ field of **CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS**. The
application must provide 16 bytes of space for the tag.

The key type for _K_ must be compatible with **CKM_CHACHA20** or **CKM_SALSA20**
respectively and the C_EncryptInit/**C_DecryptInit** calls shall behave, with
respect to _K_, as if they were called directly with **CKM_CHACHA20** or
**CKM_SALSA20**, _K_ and NULL parameters.

Unlike the atomic Salsa20/ChaCha20 mechanism the AEAD mechanism based on them
does not expose the block counter, as the AEAD construction is based on a
message metaphor in which random access is not needed.

### ChaCha20/Poly1305 and Salsa20/Poly1305 Mechanism parameters

#### CK_SALSA20_CHACHA20_POLY1305_PARAMS
\  

**CK_SALSA20_CHACHA20_POLY1305_PARAMS** is a structure that provides the
parameters to the **CKM_CHACHA20_POLY1305** and **CKM_SALSA20_POLY1305**
mechanisms. It is defined as follows:

~~~{.c}
typedef struct CK_SALSA20_CHACHA20_POLY1305_PARAMS {
    CK_BYTE_PTR	pNonce;
    CK_ULONG	ulNonceLen;
    CK_BYTE_PTR	pAAD;
    CK_ULONG	ulAADLen;
} CK_SALSA20_CHACHA20_POLY1305_PARAMS;
~~~

The fields of the structure have the following meanings:

_pNonce_
: nonce (This should be never re-used with the same key.)

_ulNonceLen_
: length of nonce in bits (is 64 for original, 96 for IETF (only for chacha20)
  and 192 for xchacha20/xsalsa20 variant)

_pAAD_
: pointer to additional authentication data. This data is authenticated but not
  encrypted.

_ulAADLen_
: length of pAAD in bytes.

**CK_SALSA20_CHACHA20_POLY1305_PARAMS_PTR** is a pointer to a
**CK_SALSA20_CHACHA20_POLY1305_PARAMS**.

#### CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS
\  

**CK_CHACHA20POLY1305_PARAMS** is a structure that provides the parameters to
the **CKM_CHACHA20_POLY1305** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS {
    CK_BYTE_PTR	pNonce;
    CK_ULONG	ulNonceLen;
    CK_BYTE_PTR	pTag;
} CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS;
~~~

The fields of the structure have the following meanings:

_pNonce_
: pointer to nonce

_ulNonceLen_
: length of nonce in bits. The length of the influences which variant of the
  ChaCha20 will be used (64 original, 96 IETF(only for ChaCha20), 192
  XChaCha20/XSalsa20)

_pTag_
: location of the authentication tag which is returned on MessageEncrypt, and
  provided on MessageDecrypt.

**CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS_PTR** is a pointer to a
**CK_SALSA20_CHACHA20_POLY1305_MSG_PARAMS**.
