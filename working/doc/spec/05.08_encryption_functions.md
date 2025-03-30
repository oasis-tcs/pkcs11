## Encryption functions

Cryptoki provides the following functions for encrypting data: 

### C_EncryptInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_EncryptInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_EncryptInit** initializes an encryption operation. _hSession_ is the
session’s handle; _pMechanism_ points to the encryption mechanism; _-hKey_ is
the handle of the encryption key.

The **CKA_ENCRYPT** attribute of the encryption key, which indicates whether the
key supports encryption, MUST be CK_TRUE.

After calling **C_EncryptInit**, the application can either call **C_Encrypt**
to encrypt data in a single part; or call **C_EncryptUpdate** zero or more
times, followed by **C_EncryptFinal**, to encrypt data in multiple parts. The
encryption operation is active until the application uses a call to
**C_Encrypt** or **C_EncryptFinal** to _actually obtain_ the final piece of
ciphertext. To process additional data (in single or multiple parts), the
application MUST call **C_EncryptInit** again.

**C_EncryptInit** can be called with _pMechanism_ set to NULL_PTR to terminate
an active encryption operation. If an active operation operations cannot be
cancelled, **CKR_OPERATION_CANCEL_FAILED** must be returned.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_EncryptFinal**.

### C_Encrypt

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Encrypt)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pEncryptedData,
    CK_ULONG_PTR pulEncryptedDataLen
);
~~~

**C_Encrypt** encrypts single-part data. _hSession_ is the session’s handle;
_pData_ points to the data; _ulDataLen_ is the length in bytes of the data;
_pEncryptedData_ points to the location that receives the encrypted data;
_pulEncryptedDataLen_ points to the location that holds the length in bytes of
the encrypted data.

**C_Encrypt** uses the convention described in Section 5.2 on producing output.

The encryption operation MUST have been initialized with **C_EncryptInit**. A
call to **C_Encrypt** always terminates the active encryption operation unless
it returns **CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which
returns CKR_OK) to determine the length of the buffer needed to hold the
ciphertext.

**C_Encrypt** cannot be used to terminate a multi-part operation, and MUST be
called after **C_EncryptInit** without intervening **C_EncryptUpdate** calls.

For some encryption mechanisms, the input plaintext data has certain length
constraints (either because the mechanism can only encrypt relatively short
pieces of plaintext, or because the mechanism’s input data MUST consist of an
integral number of blocks). If these constraints are not satisfied, then
**C_Encrypt** will fail with return code CKR_DATA_LEN_RANGE.

The plaintext and ciphertext can be in the same place, _i.e._, it is OK if
_pData_ and _pEncryptedData_ point to the same location.

For most mechanisms, **C_Encrypt** is equivalent to a sequence of
**C_EncryptUpdate** operations followed by **C_EncryptFinal**.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_INVALID, CKR_DATA_LEN_RANGE,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example: see **C_EncryptFinal** for an example of similar functions.

### C_EncryptUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_EncryptUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen,
    CK_BYTE_PTR pEncryptedPart,
    CK_ULONG_PTR pulEncryptedPartLen
);
~~~

**C_EncryptUpdate** continues a multiple-part encryption operation, processing
another data part. _hSession_ is the session’s handle; _pPart_ points to the
data part; _ulPartLen_ is the length of the data part; _pEncryptedPart_ points
to the location that receives the encrypted data part; _pulEncryptedPartLen_
points to the location that holds the length in bytes of the encrypted data
part.

**C_EncryptUpdate** uses the convention described in Section 5.2 on producing
output.

The encryption operation MUST have been initialized with **C_EncryptInit**. This
function may be called any number of times in succession. A call to
**C_EncryptUpdate** which results in an error other than
**CKR_BUFFER_TOO_SMALL** terminates the current encryption operation.

The plaintext and ciphertext can be in the same place, _i.e._, it is OK if
_pPart_ and _pEncryptedPart_ point to the same location.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example: see **C_EncryptFinal**.

### C_EncryptFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_EncryptFinal)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pLastEncryptedPart,
    CK_ULONG_PTR pulLastEncryptedPartLen
);
~~~

**C_EncryptFinal** finishes a multiple-part encryption operation. _hSession_ is
the session’s handle; _pLastEncryptedPart_ points to the location that receives
the last encrypted data part, if any; _pulLastEncryptedPartLen_ points to the
location that holds the length of the last encrypted data part.

**C_EncryptFinal** uses the convention described in Section 5.2 on producing
output.

The encryption operation MUST have been initialized with **C_EncryptInit**. A
call to **C_EncryptFinal** always terminates the active encryption operation
unless it returns **CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one
which returns **CKR_OK**) to determine the length of the buffer needed to hold
the ciphertext.

For some multi-part encryption mechanisms, the input plaintext data has certain
length constraints, because the mechanism’s input data MUST consist of an
integral number of blocks. If these constraints are not satisfied, then
**C_EncryptFinal** will fail with return code **CKR_DATA_LEN_RANGE**.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
#define PLAINTEXT_BUF_SZ 200
#define CIPHERTEXT_BUF_SZ 256

CK_ULONG firstPieceLen, secondPieceLen;
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_BYTE iv[8];
CK_MECHANISM mechanism = {
  CKM_DES_CBC_PAD, iv, sizeof(iv)
};
CK_BYTE data[PLAINTEXT_BUF_SZ];
CK_BYTE encryptedData[CIPHERTEXT_BUF_SZ];
CK_ULONG ulEncryptedData1Len;
CK_ULONG ulEncryptedData2Len;
CK_ULONG ulEncryptedData3Len;
CK_RV rv;

.
.
firstPieceLen = 90;
secondPieceLen = PLAINTEXT_BUF_SZ-firstPieceLen;
rv = C_EncryptInit(hSession, &mechanism, hKey);
if (rv == CKR_OK) {
  /* Encrypt first piece */
  ulEncryptedData1Len = sizeof(encryptedData);
  rv = C_EncryptUpdate(
    hSession,
    &data[0], firstPieceLen,
    &encryptedData[0], &ulEncryptedData1Len);
  if (rv != CKR_OK) {
     .
     .
  }

  /* Encrypt second piece */
  ulEncryptedData2Len = sizeof(encryptedData)-ulEncryptedData1Len;
  rv = C_EncryptUpdate(
    hSession,
    &data[firstPieceLen], secondPieceLen,
    &encryptedData[ulEncryptedData1Len], &ulEncryptedData2Len);
  if (rv != CKR_OK) {
     .
     .
  }

  /* Get last little encrypted bit */
  ulEncryptedData3Len =
    sizeof(encryptedData)-ulEncryptedData1Len-ulEncryptedData2Len;
  rv = C_EncryptFinal(
    hSession,
    &encryptedData[ulEncryptedData1Len+ulEncryptedData2Len],
    &ulEncryptedData3Len);
  if (rv != CKR_OK) {
     .
     .
  }
}
~~~
