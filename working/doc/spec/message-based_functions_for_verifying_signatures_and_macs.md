## Message-based functions for verifying signatures and MACs

Message-based verification refers to the process of verifying signatures on
multiple messages using the same verification mechanism and verification key.

Cryptoki provides the following functions for verifying signatures on messages
(for the purposes of Cryptoki, these operations also encompass message
authentication codes).

### C_MessageVerifyInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_MessageVerifyInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_MessageVerifyInit** initializes a message-based verification process,
preparing a session for one or more verification operations (where the signature
is an appendix to the data) that use the same verification mechanism and
verification key. _hSession_ is the session’s handle; _pMechanism_ points to the
structure that specifies the verification mechanism; _hKey_ is the handle of the
verification key.

The **CKA_VERIFY** attribute of the verification key, which indicates whether
the key supports verification where the signature is an appendix to the data,
MUST be CK_TRUE.

After calling **C_MessageVerifyInit**, the application can either call
**C_VerifyMessage** to verify a signature on a message in a single part; or call
**C_VerifyMessageBegin**, followed by **C_VerifyMessageNext** one or more times,
to verify a signature on a message in multiple parts. This may be repeated
several times. The message-based verification process is active until the
application calls **C_MessageVerifyFinal** to finish the message-based
verification process.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

### C_VerifyMessage

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyMessage)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG ulSignatureLen
);
~~~

**C_VerifyMessage** verifies a signature on a message in a single part
operation, where the signature is an appendix to the data.
**C_MessageVerifyInit** must previously been called on the session. _hSession_
is the session’s handle; _pParameter_ and _ulParameterLen_ specify any
mechanism-specific parameters for the message verification operation; _pData_
points to the data; _ulDataLen_ is the length of the data; _pSignature_ points
to the signature; _ulSignatureLen_ is the length of the signature.

Unlike the _pParameter_ parameter of **C_SignMessage**, _pParameter_ is always
an input parameter.

The message-based verification process MUST have been initialized with
**C_MessageVerifyInit**. A call to **C_VerifyMessage** starts and terminates a
message verification operation.

A successful call to **C_VerifyMessage** should return either the value
**CKR_OK** (indicating that the supplied signature is valid) or
**CKR_SIGNATURE_INVALID** (indicating that the supplied signature is invalid).
If the signature can be seen to be invalid purely on the basis of its length,
then **CKR_SIGNATURE_LEN_RANGE** should be returned.

**C_VerifyMessage** does not finish the message-based verification process.
Additional **C_VerifyMessage** or **C_VerifyMessageBegin** and
**C_VerifyMessageNext** calls may be made on the session.

For most mechanisms, **C_VerifyMessage** is equivalent to
**C_VerifyMessageBegin** followed by a sequence of **C_VerifyMessageNext**
operations.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_INVALID, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_MECHANISM_PARAM_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_INVALID,
CKR_SIGNATURE_LEN_RANGE, CKR_TOKEN_RESOURCE_EXCEEDED.

### C_VerifyMessageBegin

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyMessageBegin)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen
);
~~~

**C_VerifyMessageBegin** begins a multiple-part message verification operation,
where the signature is an appendix to the message. **C_MessageVerifyInit** must
previously been called on the session. _hSession_ is the session’s handle;
_pParameter_ and _ulParameterLen_ specify any mechanism-specific parameters for
the message verification operation.

Unlike the _pParameter_ parameter of **C_SignMessageBegin**, _pParameter_ is
always an input parameter.

After calling **C_VerifyMessageBegin**, the application should call
**C_VerifyMessageNext** one or more times to verify a signature on a message in
multiple parts. The message verification operation is active until the
application calls **C_VerifyMessageNext** with a non-NULL pSignature. To process
additional messages (in single or multiple parts), the application MUST call
**C_VerifyMessage** or **C_VerifyMessageBegin** again.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

### C_VerifyMessageNext

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyMessageNext)(
    CK_SESSION_HANDLE hSession,
    CK_VOID_PTR pParameter,
    CK_ULONG ulParameterLen,
    CK_BYTE_PTR pDataPart,
    CK_ULONG ulDataPartLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG ulSignatureLen
);
~~~

**C_VerifyMessageNext** continues a multiple-part message verification
operation, processing another data part, or finishes a multiple-part message
verification operation, checking the signature. _hSession_ is the session’s
handle, _pParameter_ and _ulParameterLen_ specify any mechanism-specific
parameters for the message verification operation, _pPart_ points to the data
part; _ulPartLen_ is the length of the data part; _pSignature_ points to the
signature; _ulSignatureLen_ is the length of the signature.

The _pSignature_ argument is set to NULL if there is more data part to follow,
or set to a non-NULL value (pointing to the signature to verify) if this is the
last data part.

The message verification operation MUST have been started with
**C_VerifyMessageBegin**. This function may be called any number of times in
succession. A call to **C_VerifyMessageNext** with a NULL _pSignature_ which
results in an error terminates the current message verification operation. A
call to **C_VerifyMessageNext** with a non-NULL _pSignature_ always terminates
the active message verification operation.

A successful call to **C_VerifyMessageNext** with a non-NULL _pSignature_ should
return either the value **CKR_OK** (indicating that the supplied signature is
valid) or **CKR_SIGNATURE_INVALID** (indicating that the supplied signature is
invalid). If the signature can be seen to be invalid purely on the basis of its
length, then **CKR_SIGNATURE_LEN_RANGE** should be returned. In any of these
cases, the active message verifying operation is terminated.

Although the last **C_VerifyMessageNext** call ends the verification of a
message, it does not finish the message-based verification process. Additional
**C_VerifyMessage** or **C_VerifyMessageBegin** and **C_VerifyMessageNext**
calls may be made on the session.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_INVALID, CKR_SIGNATURE_LEN_RANGE,
CKR_TOKEN_RESOURCE_EXCEEDED.

### C_MessageVerifyFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV,C_MessageVerifyFinal)(
    CK_SESSION_HANDLE hSession
);
~~~

**C_MessageVerifyFinal** finishes a message-based verification process.
_hSession_ is the session’s handle.

The message-based verification process MUST have been initialized with
**C_MessageVerifyInit**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_TOKEN_RESOURCE_EXCEEDED.
