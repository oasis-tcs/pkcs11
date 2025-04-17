## Message-based decryption functions

Message-based decryption refers to the process of decrypting multiple encrypted
messages using the same decryption mechanism and decryption key. The decryption
mechanism can be either an authenticated encryption with associated data (AEAD)
algorithm or a pure encryption algorithm.  Cryptoki provides the following
functions for message-based decryption.

### C_MessageDecryptInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_MessageDecryptInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_MessageDecryptInit** initializes a message-based decryption process,
preparing a session for one or more decryption operations that use the same
decryption mechanism and decryption key. _hSession_ is the session’s handle;
_pMechanism_ points to the decryption mechanism; _hKey_ is the handle of the
decryption key.

The **CKA_DECRYPT** attribute of the decryption key, which indicates whether the
key supports decryption, MUST be CK_TRUE.

After calling **C_MessageDecryptInit**, the application can either call
**C_DecryptMessage** to decrypt an encrypted message in a single part; or call
**C_DecryptMessageBegin**, followed by **C_DecryptMessageNext** one or more
times, to decrypt an encrypted message in multiple parts. This may be repeated
several times. The message-based decryption process is active until the
application uses a call to **C_MessageDecryptFinal** to finish the message-based
decryption process.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

### C_DecryptMessage

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptMessage)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pAssociatedData,
    CK_ULONG ulAssociatedDataLen,
    CK_BYTE_PTR pCiphertext,
    CK_ULONG ulCiphertextLen,
    CK_BYTE_PTR pPlaintext,
    CK_ULONG_PTR pulPlaintextLen
);
~~~

**C_DecryptMessage** decrypts an encrypted message in a single part. _hSession_
is the session’s handle; _pParameter_ and _ulParameterLen_ specify any
mechanism-specific parameters for the message decryption operation;
_pAssociatedData_ and _ulAssociatedDataLen_ specify the associated data for an
AEAD mechanism; _pCiphertext_ points to the encrypted message; _ulCiphertextLen_
is the length of the encrypted message; _pPlaintext_ points to the location that
receives the recovered message; _pulPlaintextLen_ points to the location that
holds the length of the recovered message.

Typically, _pParameter_ is an initialization vector (IV) or nonce. Unlike the
_pParameter_ parameter of **C_EncryptMessage**, _pParameter_ is always an input
parameter.

If the decryption mechanism is not AEAD, _pAssociatedData_ and
_ulAssociatedDataLen_ are not used and should be set to (NULL, 0).

**C_DecryptMessage** uses the convention described in Section 5.2 on producing
output.  The message-based decryption process MUST have been initialized with
**C_MessageDecryptInit**. A call to **C_DecryptMessage** begins and terminates a
message decryption operation.

**C_DecryptMessage** cannot be called in the middle of a multi-part message
decryption operation.

The ciphertext and plaintext can be in the same place, i.e., it is OK if
_pCiphertext_ and _pPlaintext_ point to the same location.

If the input ciphertext data cannot be decrypted because it has an inappropriate
length, then either **CKR_ENCRYPTED_DATA_INVALID** or
**CKR_ENCRYPTED_DATA_LEN_RANGE** may be returned.

If the decryption mechanism is an AEAD algorithm and the authenticity of the
associated data or ciphertext cannot be verified, then
**CKR_AEAD_DECRYPT_FAILED** is returned.

For most mechanisms, **C_DecryptMessage** is equivalent to
**C_DecryptMessageBegin** followed by a sequence of **C_DecryptMessageNext**
operations.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID, CKR_ENCRYPTED_DATA_LEN_RANGE,
CKR_AEAD_DECRYPT_FAILED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_OPERATION_CANCEL_FAILED.

### C_DecryptMessageBegin

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptMessageBegin)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pAssociatedData,
    CK_ULONG ulAssociatedDataLen
);
~~~

**C_DecryptMessageBegin** begins a multiple-part message decryption operation.
_hSession_ is the session’s handle; _pParameter_ and _ulParameterLen_ specify
any mechanism-specific parameters for the message decryption operation;
_pAssociatedData_ and _ulAssociatedDataLen_ specify the associated data for an
AEAD mechanism.

Typically, _pParameter_ is an initialization vector (IV) or nonce. Unlike the
_pParameter_ parameter of **C_EncryptMessageBegin**, _pParameter_ is always an
input parameter.

If the decryption mechanism is not AEAD, _pAssociatedData_ and
_ulAssociatedDataLen_ are not used and should be set to (NULL, 0).

After calling **C_DecryptMessageBegin**, the application should call
**C_DecryptMessageNext** one or more times to decrypt the encrypted message in
multiple parts. The message decryption operation is active until the application
uses a call to **C_DecryptMessageNext** with flags=**CKF_END_OF_MESSAGE** to
actually obtain the final piece of plaintext. To process additional encrypted
messages (in single or multiple parts), the application MUST call
**C_DecryptMessage** or **C_DecryptMessageBegin** again.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

### C_DecryptMessageNext

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DecryptMessageNext)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pCiphertextPart,
    CK_ULONG ulCiphertextPartLen,
    CK_BYTE_PTR pPlaintextPart,
    CK_ULONG_PTR pulPlaintextPartLen,
    CK_FLAGS flags
);
~~~

**C_DecryptMessageNext** continues a multiple-part message decryption operation,
processing another encrypted message part. _hSession_ is the session’s handle;
_pParameter_ and _ulParameterLen_ specify any mechanism-specific parameters for
the message decryption operation; _pCiphertextPart_ points to the encrypted
message part; _ulCiphertextPartLen_ is the length of the encrypted message part;
_pPlaintextPart_ points to the location that receives the recovered message
part; _pulPlaintextPartLen_ points to the location that holds the length of the
recovered message part; _flags_ is set to 0 if there is more ciphertext data to
follow, or set to **CKF_END_OF_MESSAGE** if this is the last ciphertext part.

Typically, _pParameter_ is an initialization vector (IV) or nonce. Unlike the
_pParameter_ parameter of **C_EncryptMessageNext**, _pParameter_ is always an
input parameter.

**C_DecryptMessageNext** uses the convention described in Section 5.2 on
producing output.

The message decryption operation MUST have been started with
**C_DecryptMessageBegin**. This function may be called any number of times in
succession. A call to **C_DecryptMessageNext** with flags=0 which results in an
error other than **CKR_BUFFER_TOO_SMALL** terminates the current message
decryption operation. A call to **C_DecryptMessageNext** with
flags=**CKF_END_OF_MESSAGE** always terminates the active message decryption
operation unless it returns **CKR_BUFFER_TOO_SMALL** or is a successful call
(i.e., one which returns **CKR_OK**) to determine the length of the buffer
needed to hold the plaintext.

The ciphertext and plaintext can be in the same place, i.e., it is OK if
_pCiphertextPart_ and _pPlaintextPart_ point to the same location.

Although the last **C_DecryptMessageNext** call ends the decryption of a
message, it does not finish the message-based decryption process. Additional
**C_DecryptMessage** or **C_DecryptMessageBegin** and **C_DecryptMessageNext**
calls may be made on the session.

If the input ciphertext data cannot be decrypted because it has an inappropriate
length, then either **CKR_ENCRYPTED_DATA_INVALID** or
**CKR_ENCRYPTED_DATA_LEN_RANGE** may be returned by the last
**C_DecryptMessageNext** call.

If the decryption mechanism is an AEAD algorithm and the authenticity of the
associated data or ciphertext cannot be verified, then
**CKR_AEAD_DECRYPT_FAILED** is returned by the last **C_DecryptMessageNext**
call.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_ENCRYPTED_DATA_INVALID, CKR_ENCRYPTED_DATA_LEN_RANGE,
CKR_AEAD_DECRYPT_FAILED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

### C_MessageDecryptFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_MessageDecryptFinal)(
    CK_SESSION_HANDLE hSession 
);
~~~

**C_MessageDecryptFinal** finishes a message-based decryption process.
_hSession_ is the session’s handle.

The message-based decryption process MUST have been initialized with
**C_MessageDecryptInit**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.
