## HMAC mechanisms

Refer to [RFC 2104] and [FIPS 198] for HMAC algorithm description. The HMAC
secret key shall correspond to the PKCS11 generic secret key type or the
mechanism specific key types (see mechanism definition). Such keys, for use with
HMAC operations can be created using **C_CreateObject**, **C_GenerateKey**, or
**C_UnwrapKey**.

The RFC also specifies test vectors for the various hash function based HMAC
mechanisms described in the respective hash mechanism descriptions. The RFC
should be consulted to obtain these test vectors.

### General block cipher mechanism parameters

### CK_MAC_GENERAL_PARAMS
\  

**CK_MAC_GENERAL_PARAMS** provides the parameters to the general-length MACing
mechanisms of the DES, DES3 (triple-DES), AES, Camellia, SEED, and ARIA ciphers.
It also provides the parameters to the general-length HMACing mechanisms
(i.e.,SHA-1, SHA-256, SHA-384, SHA-512, and SHA-512/T family) and the two SSL
3.0 MACing mechanisms, (i.e., MD5 and SHA-1). It holds the length of the MAC
that these mechanisms produce. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_MAC_GENERAL_PARAMS;
~~~

**CK_MAC_GENERAL_PARAMS_PTR** is a pointer to a **CK_MAC_GENERAL_PARAMS**.
