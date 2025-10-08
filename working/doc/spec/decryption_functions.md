## Decryption functions

Cryptoki provides the following functions for decrypting data: 

### C_DecryptInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_DecryptInit** initializes a decryption operation. _hSession_ is the
session’s handle; _pMechanism_ points to the decryption mechanism; _hKey_ is the
handle of the decryption key.

The **CKA_DECRYPT** attribute of the decryption key, which indicates whether the
key supports decryption, MUST be CK_TRUE.

After calling **C_DecryptInit**, the application can either call **C_Decrypt**
to decrypt data in a single part; or call **C_DecryptUpdate** zero or more
times, followed by **C_DecryptFinal**, to decrypt data in multiple parts. The
decryption operation is active until the application uses a call to
**C_Decrypt** or **C_DecryptFinal** to actually obtain the final piece of
plaintext. To process additional data (in single or multiple parts), the
application MUST call **C_DecryptInit** again.

**C_DecryptInit** can be called with __pMechanism__ set to NULL_PTR to terminate
an active decryption operation. If an active operation cannot be cancelled,
**CKR_OPERATION_CANCEL_FAILED** must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_DecryptFinal**.

### C_Decrypt

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Decrypt)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pEncryptedData,
    CK_ULONG ulEncryptedDataLen,
    CK_BYTE_PTR pData,
    CK_ULONG_PTR pulDataLen
);
~~~

**C_Decrypt** decrypts encrypted data in a single part. _hSession_ is the
session’s handle; _pEncryptedData_ points to the encrypted data;
_ulEncryptedDataLen_ is the length of the encrypted data; _pData_ points to the
location that receives the recovered data; _pulDataLen_ points to the location
that holds the length of the recovered data.

**C_Decrypt** uses the convention described in Section 5.2 on producing output.

The decryption operation MUST have been initialized with **C_DecryptInit**. A
call to **C_Decrypt** always terminates the active decryption operation unless
it returns **CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which
returns **CKR_OK**) to determine the length of the buffer needed to hold the
plaintext.

**C_Decrypt** cannot be used to terminate a multi-part operation, and MUST be
called after **C_DecryptInit** without intervening **C_DecryptUpdate** calls.

The ciphertext and plaintext can be in the same place, i.e., it is OK if
_pEncryptedData_ and _pData_ point to the same location.

If the input ciphertext data cannot be decrypted because it has an inappropriate
length, then either **CKR_ENCRYPTED_DATA_INVALID** or
**CKR_ENCRYPTED_DATA_LEN_RANGE** may be returned.

For most mechanisms, **C_Decrypt** is equivalent to a sequence of
**C_DecryptUpdate** operations followed by **C_DecryptFinal**.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID, CKR_ENCRYPTED_DATA_LEN_RANGE,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

Example: see **C_DecryptFinal** for an example of similar functions.

### C_DecryptUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pEncryptedPart,
    CK_ULONG ulEncryptedPartLen,
    CK_BYTE_PTR pPart,
    CK_ULONG_PTR pulPartLen
);
~~~

**C_DecryptUpdate** continues a multiple-part decryption operation, processing
another encrypted data part. _hSession_ is the session’s handle;
_pEncryptedPart_ points to the encrypted data part; _ulEncryptedPartLen_ is the
length of the encrypted data part; pPart points to the location that receives
the recovered data part; _pulPartLen_ points to the location that holds the
length of the recovered data part.

**C_DecryptUpdate** uses the convention described in Section 5.2 on producing
output.

The decryption operation MUST have been initialized with **C_DecryptInit**. This
function may be called any number of times in succession. A call to
**C_DecryptUpdate** which results in an error other than
**CKR_BUFFER_TOO_SMALL** terminates the current decryption operation.

The ciphertext and plaintext can be in the same place, i.e., it is OK if
_pEncryptedPart_ and _pPart_ point to the same location.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID, CKR_ENCRYPTED_DATA_LEN_RANGE,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

Example: See **C_DecryptFinal**.

### C_DecryptFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptFinal)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pLastPart,
    CK_ULONG_PTR pulLastPartLen
);
~~~

**C_DecryptFinal** finishes a multiple-part decryption operation. _hSession_ is
the session’s handle; _pLastPart_ points to the location that receives the last
recovered data part, if any; _pulLastPartLen_ points to the location that holds
the length of the last recovered data part.

**C_DecryptFinal** uses the convention described in Section 5.2 on producing
output.

The decryption operation MUST have been initialized with **C_DecryptInit**. A
call to **C_DecryptFinal** always terminates the active decryption operation
unless it returns **CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one
which returns **CKR_OK**) to determine the length of the buffer needed to hold
the plaintext.

If the input ciphertext data cannot be decrypted because it has an inappropriate
length, then either **CKR_ENCRYPTED_DATA_INVALID** or
**CKR_ENCRYPTED_DATA_LEN_RANGE** may be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID, CKR_ENCRYPTED_DATA_LEN_RANGE,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
#define CIPHERTEXT_BUF_SZ 256
#define PLAINTEXT_BUF_SZ 256

CK_ULONG firstEncryptedPieceLen, secondEncryptedPieceLen;
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_BYTE iv[8];
CK_MECHANISM mechanism = {
  CKM_DES_CBC_PAD, iv, sizeof(iv)
};
CK_BYTE data[PLAINTEXT_BUF_SZ];
CK_BYTE encryptedData[CIPHERTEXT_BUF_SZ];
CK_ULONG ulData1Len, ulData2Len, ulData3Len;
CK_RV rv;

.
.
firstEncryptedPieceLen = 90;
secondEncryptedPieceLen = CIPHERTEXT_BUF_SZ-firstEncryptedPieceLen;
rv = C_DecryptInit(hSession, &mechanism, hKey);
if (rv == CKR_OK) {
  /* Decrypt first piece */
  ulData1Len = sizeof(data);
  rv = C_DecryptUpdate(
    hSession,
    &encryptedData[0], firstEncryptedPieceLen,
    &data[0], &ulData1Len);
  if (rv != CKR_OK) {
    .
    .
  }

  /* Decrypt second piece */
  ulData2Len = sizeof(data)-ulData1Len;
  rv = C_DecryptUpdate(
    hSession,
    &encryptedData[firstEncryptedPieceLen],
    secondEncryptedPieceLen,
    &data[ulData1Len], &ulData2Len);
  if (rv != CKR_OK) {
    .
    .
  }

  /* Get last little decrypted bit */
  ulData3Len = sizeof(data)-ulData1Len-ulData2Len;
  rv = C_DecryptFinal(
    hSession,
    &data[ulData1Len+ulData2Len], &ulData3Len);
  if (rv != CKR_OK) {
     .
     .
  }
}
~~~
