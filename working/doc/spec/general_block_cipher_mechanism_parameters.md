## General block cipher mechanism parameters

### Definitions
\  

**CK_MAC_GENERAL_PARAMS** provides the parameters to the general-length MACing
mechanisms of the DES, DES3 (triple-DES), AES, Camellia, SEED, and ARIA ciphers.
It also provides the parameters to the general-length HMACing mechanisms
(see section 6.22.2) and the two SSL
3.0 MACing mechanisms, i.e., MD5 and SHA-1. It holds the length of the MAC
that these mechanisms produce. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_MAC_GENERAL_PARAMS;
~~~

**CK_MAC_GENERAL_PARAMS_PTR** is a pointer to a **CK_MAC_GENERAL_PARAMS**.
