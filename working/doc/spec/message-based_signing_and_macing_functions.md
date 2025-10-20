## Message-based signing and MACing functions

Message-based signature refers to the process of signing multiple messages using
the same signature mechanism and signature key.

Cryptoki provides the following functions for signing messages (for the purposes
of Cryptoki, these operations also encompass message authentication codes).

### C_MessageSignInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_MessageSignInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_MessageSignInit** initializes a message-based signature process, preparing a
session for one or more signature operations (where the signature is an appendix
to the data) that use the same signature mechanism and signature key. _hSession_
is the session’s handle; _pMechanism_ points to the signature mechanism; _hKey_
is the handle of the signature key.

The **CKA_SIGN** attribute of the signature key, which indicates whether the key
supports signatures with appendix, MUST be CK_TRUE.

After calling **C_MessageSignInit**, the application can either call
**C_SignMessage** to sign a message in a single part; or call
**C_SignMessageBegin**, followed by **C_SignMessageNext** one or more times, to
sign a message in multiple parts. This may be repeated several times. The
message-based signature process is active until the application calls
**C_MessageSignFinal** to finish the message-based signature process.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

### C_SignMessage

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignMessage)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG_PTR pulSignatureLen
);
~~~

**C_SignMessage** signs a message in a single part, where the signature is an
appendix to the message. **C_MessageSignInit** must previously been called on
the session. _hSession_ is the session’s handle; _pParameter_ and
_ulParameterLen_ specify any mechanism-specific parameters for the message
signature operation; _pData_ points to the data; _ulDataLen_ is the length of
the data; _pSignature_ points to the location that receives the signature;
_pulSignatureLen_ points to the location that holds the length of the signature.

Depending on the mechanism parameter passed to **C_MessageSignInit**, pParameter
may be either an input or an output parameter.

**C_SignMessage** uses the convention described in Section 5.2 on producing
output.

The message-based signing process MUST have been initialized with
**C_MessageSignInit**. A call to **C_SignMessage** begins and terminates a
message signing operation unless it returns **CKR_BUFFER_TOO_SMALL** to
determine the length of the buffer needed to hold the signature, or is a
successful call (i.e., one which returns **CKR_OK**). 

**C_SignMessage** cannot be called in the middle of a multi-part message signing
operation.

**C_SignMessage** does not finish the message-based signing process. Additional
**C_SignMessage** or **C_SignMessageBegin** and **C_SignMessageNext** calls may
be made on the session.

For most mechanisms, **C_SignMessage** is equivalent to **C_SignMessageBegin**
followed by a sequence of **C_SignMessageNext** operations.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_INVALID, CKR_DATA_LEN_RANGE,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_FUNCTION_REJECTED,
CKR_TOKEN_RESOURCE_EXCEEDED.

### C_SignMessageBegin

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignMessageBegin)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen
);
~~~

**C_SignMessageBegin** begins a multiple-part message signature operation, where
the signature is an appendix to the message. **C_MessageSignInit** must
previously been called on the session. _hSession_ is the session’s handle;
_pParameter_ and _ulParameterLen_ specify any mechanism-specific parameters for
the message signature operation.

Depending on the mechanism parameter passed to **C_MessageSignInit**, pParameter
may be either an input or an output parameter.

After calling **C_SignMessageBegin**, the application should call
**C_SignMessageNext** one or more times to sign the message in multiple parts.
The message signature operation is active until the application uses a call to
**C_SignMessageNext** with a non-NULL _pulSignatureLen_ to actually obtain the
signature. To process additional messages (in single or multiple parts), the
application MUST call **C_SignMessage** or **C_SignMessageBegin** again.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_TOKEN_RESOURCE_EXCEEDED.

### C_SignMessageNext

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignMessageNext)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pDataPart,
    CK_ULONG ulDataPartLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG_PTR pulSignatureLen
);
~~~

**C_SignMessageNext** continues a multiple-part message signature operation,
processing another data part, or finishes a multiple-part message signature
operation, returning the signature. _hSession_ is the session’s handle,
_pDataPart_ points to the data part; _pParameter_ and _ulParameterLen_ specify
any mechanism-specific parameters for the message signature operation;
_ulDataPartLen_ is the length of the data part; _pSignature_ points to the
location that receives the signature; _pulSignatureLen_ points to the location
that holds the length of the signature.

The _pulSignatureLen_ argument is set to NULL if there is more data part to
follow, or set to a non-NULL value (to receive the signature length) if this is
the last data part.

**C_SignMessageNext** uses the convention described in Section 5.2 on producing
output.

The message signing operation MUST have been started with
**C_SignMessageBegin**. This function may be called any number of times in
succession. A call to **C_SignMessageNext** with a NULL _pulSignatureLen_ which
results in an error terminates the current message signature operation. A call
to **C_SignMessageNext** with a non-NULL _pulSignatureLen_ always terminates the
active message signing operation unless it returns **CKR_BUFFER_TOO_SMALL** to
determine the length of the buffer needed to hold the signature, or is a
successful call (i.e., one which returns **CKR_OK**).

Although the last **C_SignMessageNext** call ends the signing of a message, it
does not finish the message-based signing process. Additional **C_SignMessage**
or **C_SignMessageBegin** and **C_SignMessageNext** calls may be made on the
session.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_FUNCTION_REJECTED,
CKR_TOKEN_RESOURCE_EXCEEDED.

### C_MessageSignFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_MessageSignFinal)(
    CK_SESSION_HANDLE hSession
);
~~~

**C_MessageSignFinal** finishes a message-based signing process. _hSession_ is
the session’s handle.

The message-based signing process MUST have been initialized with
**C_MessageSignInit**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_FUNCTION_REJECTED, CKR_TOKEN_RESOURCE_EXCEEDED.
