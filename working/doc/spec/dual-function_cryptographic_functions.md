## Dual-function cryptographic functions

Cryptoki provides the following functions to perform two cryptographic
operations “simultaneously” within a session. These functions are provided so as
to avoid unnecessarily passing data back and forth to and from a token.

### C_DigestEncryptUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestEncryptUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen,
    CK_BYTE_PTR pEncryptedPart,
    CK_ULONG_PTR pulEncryptedPartLen
);
~~~

**C_DigestEncryptUpdate** continues multiple-part digest and encryption
operations, processing another data part. _hSession_ is the session’s handle;
_pPart_ points to the data part; _ulPartLen_ is the length of the data part;
_pEncryptedPart_ points to the location that receives the digested and encrypted
data part; _pulEncryptedPartLen_ points to the location that holds the length of
the encrypted data part.

**C_DigestEncryptUpdate** uses the convention described in Section 5.2 on
producing output. If a **C_DigestEncryptUpdate** call does not produce encrypted
output (because an error occurs, or because _pEncryptedPart_ has the value
NULL_PTR, or because _pulEncryptedPartLen_ is too small to hold the entire
encrypted part output), then no plaintext is passed to the active digest
operation.

Digest and encryption operations MUST both be active (they MUST have been
initialized with **C_DigestInit** and **C_EncryptInit**, respectively). This
function may be called any number of times in succession, and may be
interspersed with **C_DigestUpdate**, **C_DigestKey**, and **C_EncryptUpdate**
calls (it would be somewhat unusual to intersperse calls to
**C_DigestEncryptUpdate** with calls to **C_DigestKey**, however).

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
#define BUF_SZ 512

CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_BYTE iv[8];
CK_MECHANISM digestMechanism = {
  CKM_MD5, NULL_PTR, 0
};
CK_MECHANISM encryptionMechanism = {
  CKM_DES_ECB, iv, sizeof(iv)
};
CK_BYTE encryptedData[BUF_SZ];
CK_ULONG ulEncryptedDataLen;
CK_BYTE digest[16];
CK_ULONG ulDigestLen;
CK_BYTE data[(2*BUF_SZ)+8];
CK_RV rv;
int i;

.
.
memset(iv, 0, sizeof(iv));
memset(data, ‘A’, ((2*BUF_SZ)+5));
rv = C_EncryptInit(hSession, &encryptionMechanism, hKey);
if (rv != CKR_OK) {
  .
  .
}
rv = C_DigestInit(hSession, &digestMechanism);
if (rv != CKR_OK) {
  .
  .
}

ulEncryptedDataLen = sizeof(encryptedData);
rv = C_DigestEncryptUpdate(
  hSession,
  &data[0], BUF_SZ,
  encryptedData, &ulEncryptedDataLen);
.
.
ulEncryptedDataLen = sizeof(encryptedData);
rv = C_DigestEncryptUpdate(
  hSession,
  &data[BUF_SZ], BUF_SZ,
  encryptedData, &ulEncryptedDataLen);
.
.

/*
 * The last portion of the buffer needs to be 
 * handled with separate calls to deal with 
 * padding issues in ECB mode
 */

/* First, complete the digest on the buffer */
rv = C_DigestUpdate(hSession, &data[BUF_SZ*2], 5);
.
.
ulDigestLen = sizeof(digest);
rv = C_DigestFinal(hSession, digest, &ulDigestLen);
.
.

/* Then, pad last part with 3 0x00 bytes, and complete encryption */
for(i=0;i<3;i++)
  data[((BUF_SZ*2)+5)+i] = 0x00;

/* Now, get second-to-last piece of ciphertext */
ulEncryptedDataLen = sizeof(encryptedData);
rv = C_EncryptUpdate(
  hSession,
  &data[BUF_SZ*2], 8,
  encryptedData, &ulEncryptedDataLen);
.
.

/* Get last piece of ciphertext (should have length 0, here) */
ulEncryptedDataLen = sizeof(encryptedData);
rv = C_EncryptFinal(hSession, encryptedData, &ulEncryptedDataLen);
.
.
~~~

### C_DecryptDigestUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptDigestUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pEncryptedPart,
    CK_ULONG ulEncryptedPartLen,
    CK_BYTE_PTR pPart,
    CK_ULONG_PTR pulPartLen
);
~~~

**C_DecryptDigestUpdate** continues a multiple-part combined decryption and
digest operation, processing another data part. _hSession_ is the session’s
handle; _pEncryptedPart_ points to the encrypted data part; _ulEncryptedPartLen_
is the length of the encrypted data part; _pPart_ points to the location that
receives the recovered data part; _pulPartLen_ points to the location that holds
the length of the recovered data part.

**C_DecryptDigestUpdate** uses the convention described in Section 5.2 on
producing output. If a **C_DecryptDigestUpdate** call does not produce decrypted
output (because an error occurs, or because _pPart_ has the value NULL_PTR, or
because _pulPartLen_ is too small to hold the entire decrypted part output),
then no plaintext is passed to the active digest operation.

Decryption and digesting operations MUST both be active (they MUST have been
initialized with **C_DecryptInit** and **C_DigestInit**, respectively). This
function may be called any number of times in succession, and may be
interspersed with **C_DecryptUpdate**, **C_DigestUpdate**, and **C_DigestKey**
calls (it would be somewhat unusual to intersperse calls to
**C_DigestEncryptUpdate** with calls to **C_DigestKey**, however).

Use of **C_DecryptDigestUpdate** involves a pipelining issue that does not arise
when using **C_DigestEncryptUpdate**, the “inverse function” of
**C_DecryptDigestUpdate**. This is because when **C_DigestEncryptUpdate** is
called, precisely the same input is passed to both the active digesting
operation and the active encryption operation; however, when
**C_DecryptDigestUpdate** is called, the input passed to the active digesting
operation is the output of the active decryption operation. This issue comes up
only when the mechanism used for decryption performs padding.

In particular, envision a 24-byte ciphertext which was obtained by encrypting an
18-byte plaintext with DES in CBC mode with PKCS padding. Consider an
application which will simultaneously decrypt this ciphertext and digest the
original plaintext thereby obtained.

After initializing decryption and digesting operations, the application passes
the 24-byte ciphertext (3 DES blocks) into **C_DecryptDigestUpdate**.
**C_DecryptDigestUpdate** returns exactly 16 bytes of plaintext, since at this
point, Cryptoki doesn’t know if there’s more ciphertext coming, or if the last
block of ciphertext held any padding. These 16 bytes of plaintext are passed
into the active digesting operation.

Since there is no more ciphertext, the application calls **C_DecryptFinal**.
This tells Cryptoki that there’s no more ciphertext coming, and the call returns
the last 2 bytes of plaintext. However, since the active decryption and
digesting operations are linked only through the **C_DecryptDigestUpdate** call,
these 2 bytes of plaintext are not passed on to be digested.

A call to **C_DigestFinal**, therefore, would compute the message digest of the
first 16 bytes of the plaintext, not the message digest of the entire plaintext.
It is crucial that, before **C_DigestFinal** is called, the last 2 bytes of
plaintext get passed into the active digesting operation via a
**C_DigestUpdate** call.

Because of this, it is critical that when an application uses a padded
decryption mechanism with **C_DecryptDigestUpdate**, it knows exactly how much
plaintext has been passed into the active digesting operation. _Extreme caution
is warranted when using a padded decryption mechanism with
**C_DecryptDigestUpdate**_.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID, CKR_ENCRYPTED_DATA_LEN_RANGE,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
#define BUF_SZ 512

CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_BYTE iv[8];
CK_MECHANISM decryptionMechanism = {
  CKM_DES_ECB, iv, sizeof(iv)
};
CK_MECHANISM digestMechanism = {
  CKM_MD5, NULL_PTR, 0
};
CK_BYTE encryptedData[(2*BUF_SZ)+8];
CK_BYTE digest[16];
CK_ULONG ulDigestLen;
CK_BYTE data[BUF_SZ];
CK_ULONG ulDataLen, ulLastUpdateSize;
CK_RV rv;

.
.
memset(iv, 0, sizeof(iv));
memset(encryptedData, ‘A’, ((2*BUF_SZ)+8));
rv = C_DecryptInit(hSession, &decryptionMechanism, hKey);
if (rv != CKR_OK) {
  .
  .
}
rv = C_DigestInit(hSession, &digestMechanism);
if (rv != CKR_OK){
  .
  .
}

ulDataLen = sizeof(data);
rv = C_DecryptDigestUpdate(
  hSession,
  &encryptedData[0], BUF_SZ,
  data, &ulDataLen);
.
.
ulDataLen = sizeof(data);
rv = C_DecryptDigestUpdate(
  hSession,
  &encryptedData[BUF_SZ], BUF_SZ,
  data, &ulDataLen);
.
.

/*
 * The last portion of the buffer needs to be handled with 
 * separate calls to deal with padding issues in ECB mode
 */

/* First, complete the decryption of the buffer */
ulLastUpdateSize = sizeof(data);
rv = C_DecryptUpdate(
  hSession,
  &encryptedData[BUF_SZ*2], 8,
  data, &ulLastUpdateSize);
.
.
/* Get last piece of plaintext (should have length 0, here) */
ulDataLen = sizeof(data)-ulLastUpdateSize;
rv = C_DecryptFinal(hSession, &data[ulLastUpdateSize], &ulDataLen);
if (rv != CKR_OK) {
  .
  .
}

/* Digest last bit of plaintext */
rv = C_DigestUpdate(hSession, data, 5);
if (rv != CKR_OK) {
  .
  .
}
ulDigestLen = sizeof(digest);
rv = C_DigestFinal(hSession, digest, &ulDigestLen);
if (rv != CKR_OK) {
  .
  .
}
~~~

### C_SignEncryptUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignEncryptUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen,
    CK_BYTE_PTR pEncryptedPart,
    CK_ULONG_PTR pulEncryptedPartLen
);
~~~

**C_SignEncryptUpdate** continues a multiple-part combined signature and
encryption operation, processing another data part. _hSession_ is the session’s
handle; _pPart_ points to the data part; _ulPartLen_ is the length of the data
part; _pEncryptedPart_ points to the location that receives the digested and
encrypted data part; and _pulEncryptedPartLen_ points to the location that holds
the length of the encrypted data part.

**C_SignEncryptUpdate** uses the convention described in Section 5.2 on
producing output. If a **C_SignEncryptUpdate** call does not produce encrypted
output (because an error occurs, or because _pEncryptedPart_ has the value
NULL_PTR, or because _pulEncryptedPartLen_ is too small to hold the entire
encrypted part output), then no plaintext is passed to the active signing
operation.

Signature and encryption operations MUST both be active (they MUST have been
initialized with **C_SignInit** and **C_EncryptInit**, respectively). This
function may be called any number of times in succession, and may be
interspersed with **C_SignUpdate** and **C_EncryptUpdate** calls.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
#define BUF_SZ 512

CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hEncryptionKey, hMacKey;
CK_BYTE iv[8];
CK_MECHANISM signMechanism = {
  CKM_DES_MAC, NULL_PTR, 0
};
CK_MECHANISM encryptionMechanism = {
  CKM_DES_ECB, iv, sizeof(iv)
};
CK_BYTE encryptedData[BUF_SZ];
CK_ULONG ulEncryptedDataLen;
CK_BYTE MAC[4];
CK_ULONG ulMacLen;
CK_BYTE data[(2*BUF_SZ)+8];
CK_RV rv;
int i;

.
.
memset(iv, 0, sizeof(iv));
memset(data, ‘A’, ((2*BUF_SZ)+5));
rv = C_EncryptInit(hSession, &encryptionMechanism, hEncryptionKey);
if (rv != CKR_OK) {
  .
  .
}
rv = C_SignInit(hSession, &signMechanism, hMacKey);
if (rv != CKR_OK) {
  .
  .
}

ulEncryptedDataLen = sizeof(encryptedData);
rv = C_SignEncryptUpdate(
  hSession,
  &data[0], BUF_SZ,
  encryptedData, &ulEncryptedDataLen);
.
.
ulEncryptedDataLen = sizeof(encryptedData);
rv = C_SignEncryptUpdate(
  hSession,
  &data[BUF_SZ], BUF_SZ,
  encryptedData, &ulEncryptedDataLen);
.
.

/*
 * The last portion of the buffer needs to be handled with 
 * separate calls to deal with padding issues in ECB mode
 */

/* First, complete the signature on the buffer */
rv = C_SignUpdate(hSession, &data[BUF_SZ*2], 5);
.
.
ulMacLen = sizeof(MAC);
rv = C_SignFinal(hSession, MAC, &ulMacLen);
.
.

/* Then pad last part with 3 0x00 bytes, and complete encryption */
for(i=0;i<3;i++)
  data[((BUF_SZ*2)+5)+i] = 0x00;

/* Now, get second-to-last piece of ciphertext */
ulEncryptedDataLen = sizeof(encryptedData);
rv = C_EncryptUpdate(
  hSession,
  &data[BUF_SZ*2], 8,
  encryptedData, &ulEncryptedDataLen);
.
.

/* Get last piece of ciphertext (should have length 0, here) */
ulEncryptedDataLen = sizeof(encryptedData);
rv = C_EncryptFinal(hSession, encryptedData, &ulEncryptedDataLen);
.
.
~~~

### C_DecryptVerifyUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptVerifyUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pEncryptedPart,
    CK_ULONG ulEncryptedPartLen,
    CK_BYTE_PTR pPart,
    CK_ULONG_PTR pulPartLen
);
~~~

**C_DecryptVerifyUpdate** continues a multiple-part combined decryption and
verification operation, processing another data part. _hSession_ is the
session’s handle; _pEncryptedPart_ points to the encrypted data;
_ulEncryptedPartLen_ is the length of the encrypted data; _pPart_ points to the
location that receives the recovered data; and _pulPartLen_ points to the
location that holds the length of the recovered data.

**C_DecryptVerifyUpdate** uses the convention described in Section 5.2 on
producing output. If a **C_DecryptVerifyUpdate** call does not produce decrypted
output (because an error occurs, or because _pPart_ has the value NULL_PTR, or
because _pulPartLen_ is too small to hold the entire encrypted part output),
then no plaintext is passed to the active verification operation.

Decryption and signature operations MUST both be active (they MUST have been
initialized with **C_DecryptInit** and **C_VerifyInit**, respectively). This
function may be called any number of times in succession, and may be
interspersed with **C_DecryptUpdate** and **C_VerifyUpdate** calls.

Use of **C_DecryptVerifyUpdate** involves a pipelining issue that does not arise
when using **C_SignEncryptUpdate**, the “inverse function” of
**C_DecryptVerifyUpdate**. This is because when **C_SignEncryptUpdate** is
called, precisely the same input is passed to both the active signing operation
and the active encryption operation; however, when **C_DecryptVerifyUpdate** is
called, the input passed to the active verifying operation is the output of the
active decryption operation. This issue comes up only when the mechanism used
for decryption performs padding.

In particular, envision a 24-byte ciphertext which was obtained by encrypting an
18-byte plaintext with DES in CBC mode with PKCS padding. Consider an
application which will simultaneously decrypt this ciphertext and verify a
signature on the original plaintext thereby obtained.

After initializing decryption and verification operations, the application
passes the 24-byte ciphertext (3 DES blocks) into **C_DecryptVerifyUpdate**.
**C_DecryptVerifyUpdate** returns exactly 16 bytes of plaintext, since at this
point, Cryptoki doesn’t know if there’s more ciphertext coming, or if the last
block of ciphertext held any padding. These 16 bytes of plaintext are passed
into the active verification operation.

Since there is no more ciphertext, the application calls **C_DecryptFinal**.
This tells Cryptoki that there’s no more ciphertext coming, and the call returns
the last 2 bytes of plaintext. However, since the active decryption and
verification operations are linked only through the **C_DecryptVerifyUpdate**
call, these 2 bytes of plaintext are not passed on to the verification
mechanism.

A call to **C_VerifyFinal**, therefore, would verify whether or not the
signature supplied is a valid signature on the first 16 bytes of the plaintext,
not on the entire plaintext. It is crucial that, before **C_VerifyFinal** is
called, the last 2 bytes of plaintext get passed into the active verification
operation via a **C_VerifyUpdate** call.

Because of this, it is critical that when an application uses a padded
decryption mechanism with **C_DecryptVerifyUpdate**, it knows exactly how much
plaintext has been passed into the active verification operation. _Extreme
caution is warranted when using a padded decryption mechanism with
**C_DecryptVerifyUpdate**_.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID,
CKR_ENCRYPTED_DATA_LEN_RANGE, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
#define BUF_SZ 512

CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hDecryptionKey, hMacKey;
CK_BYTE iv[8];
CK_MECHANISM decryptionMechanism = {
  CKM_DES_ECB, iv, sizeof(iv)
};
CK_MECHANISM verifyMechanism = {
  CKM_DES_MAC, NULL_PTR, 0
};
CK_BYTE encryptedData[(2*BUF_SZ)+8];
CK_BYTE MAC[4];
CK_ULONG ulMacLen;
CK_BYTE data[BUF_SZ];
CK_ULONG ulDataLen, ulLastUpdateSize;
CK_RV rv;

.
.
memset(iv, 0, sizeof(iv));
memset(encryptedData, ‘A’, ((2*BUF_SZ)+8));
rv = C_DecryptInit(hSession, &decryptionMechanism, hDecryptionKey);
if (rv != CKR_OK) {
  .
  .
}
rv = C_VerifyInit(hSession, &verifyMechanism, hMacKey);
if (rv != CKR_OK){
  .
  .
}

ulDataLen = sizeof(data);
rv = C_DecryptVerifyUpdate(
  hSession,
  &encryptedData[0], BUF_SZ,
  data, &ulDataLen);
.
.
ulDataLen = sizeof(data);
rv = C_DecryptVerifyUpdate(
  hSession,
  &encryptedData[BUF_SZ], BUF_SZ,
  data, &ulDataLen);
.
.

/*
 * The last portion of the buffer needs to be handled with 
 * separate calls to deal with padding issues in ECB mode
 */

/* First, complete the decryption of the buffer */
ulLastUpdateSize = sizeof(data);
rv = C_DecryptUpdate(
  hSession,
  &encryptedData[BUF_SZ*2], 8,
  data, &ulLastUpdateSize);
.
.
/* Get last little piece of plaintext. Should have length 0 */
ulDataLen = sizeof(data)-ulLastUpdateSize;
rv = C_DecryptFinal(hSession, &data[ulLastUpdateSize], &ulDataLen);
if (rv != CKR_OK) {
  .
  .
}

/* Send last bit of plaintext to verification operation */
rv = C_VerifyUpdate(hSession, data, 5);
if (rv != CKR_OK) {
  .
  .
}
rv = C_VerifyFinal(hSession, MAC, ulMacLen);
if (rv == CKR_SIGNATURE_INVALID) {
  .
  .
}
~~~
