## Functions for verifying signatures and MACs

Cryptoki provides the following functions for verifying signatures on data (for
the purposes of Cryptoki, these operations also encompass message authentication
codes): 

### C_VerifyInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_VerifyInit** initializes a verification operation, where the signature is an
appendix to the data. _hSession_ is the session’s handle; _pMechanism_ points to
the structure that specifies the verification mechanism; _hKey_ is the handle of
the verification key.

The **CKA_VERIFY** attribute of the verification key, which indicates whether
the key supports verification where the signature is an appendix to the data,
MUST be CK_TRUE.

After calling **C_VerifyInit**, the application can either call **C_Verify** to
verify a signature on data in a single part; or call **C_VerifyUpdate** one or
more times, followed by **C_VerifyFinal**, to verify a signature on data in
multiple parts. The verification operation is active until the application calls
**C_Verify** or **C_VerifyFinal**. To process additional data (in single or
multiple parts), the application MUST call **C_VerifyInit** again.

**C_VerifyInit** can be called with pMechanism set to NULL_PTR to terminate an
active verification operation. If an active operation has been initialized and
it cannot be cancelled, **CKR_OPERATION_CANCEL_FAILED** must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_VerifyFinal**.

### C_Verify

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Verify)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG ulSignatureLen
);
~~~

**C_Verify** verifies a signature in a single-part operation, where the
signature is an appendix to the data. _hSession_ is the session’s handle;
_pData_ points to the data; _ulDataLen_ is the length of the data; _pSignature_
points to the signature; _ulSignatureLen_ is the length of the signature.

The verification operation MUST have been initialized with **C_VerifyInit**. A
call to **C_Verify** always terminates the active verification operation.

A successful call to **C_Verify** should return either the value **CKR_OK**
(indicating that the supplied signature is valid) or **CKR_SIGNATURE_INVALID**
(indicating that the supplied signature is invalid). If the signature can be
seen to be invalid purely on the basis of its length, then
**CKR_SIGNATURE_LEN_RANGE** should be returned. In any of these cases, the
active signing operation is terminated.

**C_Verify** cannot be used to terminate a multi-part operation, and MUST be
called after **C_VerifyInit** without intervening **C_VerifyUpdate** calls.

For most mechanisms, **C_Verify** is equivalent to a sequence of
**C_VerifyUpdate** operations followed by **C_VerifyFinal**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_INVALID, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_INVALID, CKR_SIGNATURE_LEN_RANGE,
CKR_TOKEN_RESOURCE_EXCEEDED.

Example: see **C_VerifyFinal** for an example of similar functions.

### C_VerifyUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen
);
~~~

**C_VerifyUpdate** continues a multiple-part verification operation, processing
another data part. _hSession_ is the session’s handle, _pPart_ points to the
data part; _ulPartLen_ is the length of the data part.

The verification operation MUST have been initialized with **C_VerifyInit**.
This function may be called any number of times in succession. A call to
**C_VerifyUpdate** which results in an error terminates the current verification
operation.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_TOKEN_RESOURCE_EXCEEDED.

Example: see **C_VerifyFinal**.

### C_VerifyFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyFinal)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pSignature,
    CK_ULONG ulSignatureLen
);
~~~

**C_VerifyFinal** finishes a multiple-part verification operation, checking the
signature. _hSession_ is the session’s handle; _pSignature_ points to the
signature; _ulSignatureLen_ is the length of the signature.

The verification operation MUST have been initialized with **C_VerifyInit**. A
call to **C_VerifyFinal** always terminates the active verification operation.

A successful call to **C_VerifyFinal** should return either the value **CKR_OK**
(indicating that the supplied signature is valid) or **CKR_SIGNATURE_INVALID**
(indicating that the supplied signature is invalid). If the signature can be
seen to be invalid purely on the basis of its length, then
**CKR_SIGNATURE_LEN_RANGE** should be returned. In any of these cases, the
active verifying operation is terminated.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_INVALID,
CKR_SIGNATURE_LEN_RANGE, CKR_TOKEN_RESOURCE_EXCEEDED.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_DES_MAC, NULL_PTR, 0
};
CK_BYTE data[] = {...};
CK_BYTE mac[4];
CK_RV rv;

.
.
rv = C_VerifyInit(hSession, &mechanism, hKey);
if (rv == CKR_OK) {
  rv = C_VerifyUpdate(hSession, data, sizeof(data));
  .
  .
  rv = C_VerifyFinal(hSession, mac, sizeof(mac));
  .
  .
}
~~~

### C_VerifyRecoverInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyRecoverInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_VerifyRecoverInit** initializes a signature verification operation, where
the data is recovered from the signature. _hSession_ is the session’s handle;
_pMechanism_ points to the structure that specifies the verification mechanism;
_hKey_ is the handle of the verification key.

The **CKA_VERIFY_RECOVER** attribute of the verification key, which indicates
whether the key supports verification where the data is recovered from the
signature, MUST be CK_TRUE.

After calling **C_VerifyRecoverInit**, the application may call
**C_VerifyRecover** to verify a signature on data in a single part. The
verification operation is active until the application uses a call to
**C_VerifyRecover** to actually obtain the recovered message.

**C_VerifyRecoverInit** can be called with _pMechanism_ set to NULL_PTR to
terminate an active verification with data recovery operation. If an active
operations has been initialized and it cannot be cancelled,
**CKR_OPERATION_CANCEL_FAILED** must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_VerifyRecover**.

### C_VerifyRecover

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifyRecover)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pSignature,
    CK_ULONG ulSignatureLen,
    CK_BYTE_PTR pData,
    CK_ULONG_PTR pulDataLen
);
~~~

**C_VerifyRecover** verifies a signature in a single-part operation, where the
data is recovered from the signature. _hSession_ is the session’s handle;
_pSignature_ points to the signature; _ulSignatureLen_ is the length of the
signature; _pData_ points to the location that receives the recovered data; and
_pulDataLen_ points to the location that holds the length of the recovered data.

**C_VerifyRecover** uses the convention described in Section 5.2 on producing
output.

The verification operation MUST have been initialized with
**C_VerifyRecoverInit**. A call to **C_VerifyRecover** always terminates the
active verification operation unless it returns **CKR_BUFFER_TOO_SMALL** or is a
successful call (i.e., one which returns **CKR_OK**) to determine the length of
the buffer needed to hold the recovered data.

A successful call to **C_VerifyRecover** should return either the value
**CKR_OK** (indicating that the supplied signature is valid) or
**CKR_SIGNATURE_INVALID** (indicating that the supplied signature is invalid).
If the signature can be seen to be invalid purely on the basis of its length,
then **CKR_SIGNATURE_LEN_RANGE** should be returned. The return codes
**CKR_SIGNATURE_INVALID** and **CKR_SIGNATURE_LEN_RANGE** have a higher priority
than the return code **CKR_BUFFER_TOO_SMALL**, i.e., if **C_VerifyRecover** is
supplied with an invalid signature, it will never return
**CKR_BUFFER_TOO_SMALL**.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_INVALID, CKR_DATA_LEN_RANGE,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_LEN_RANGE,
CKR_SIGNATURE_INVALID, CKR_TOKEN_RESOURCE_EXCEEDED.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_RSA_9796, NULL_PTR, 0
};
CK_BYTE data[] = {...};
CK_ULONG ulDataLen;
CK_BYTE signature[128];
CK_RV rv;

.
.
rv = C_VerifyRecoverInit(hSession, &mechanism, hKey);
if (rv == CKR_OK) {
  ulDataLen = sizeof(data);
  rv = C_VerifyRecover(
    hSession, signature, sizeof(signature), data, &ulDataLen);
  .
  .
}
~~~

### C_VerifySignatureInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifySignatureInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey,
    CK_BYTE_PTR pSignature,
    CK_ULONG ulSignatureLen
);
~~~

**C_VerifySignatureInit** initializes a verification operation, where the
signature is included as part of the initialization. _hSession_ is the session’s
handle; _pMechanism_ points to the structure that specifies the verification
mechanism; _hKey_ is the handle of the verification key; _pSignature_ points to
the signature; _ulSignatureLen_ is the length of the signature.

The **CKA_VERIFY** attribute of the verification key, which indicates whether
the key supports verification, MUST be CK_TRUE.

After calling **C_VerifySignatureInit**, the application can either call
**C_VerifySignature** to verify a signature on data in a single part; or call
**C_VerifySignatureUpdate** one or more times, followed by
**C_VerifySignatureFinal**, to verify a signature on data in multiple parts. The
verification operation is active until the application calls
**C_VerifySignature** or **C_VerifySignatureFinal**. To process additional data
(in single or multiple parts), the application MUST call
**C_VerifySignatureInit** again.

Any mechanism that supports **C_VerifyInit** must also support
**C_VerifySignatureInit**.

If the value of _ulSignatureLen_ does not match the expected length this function
may return **CKR_SIGNATURE_LEN_RANGE** in which case no active operation is
initiated.

**C_VerifySignatureInit** can be called with _pMechanism_ set to NULL_PTR to
terminate an active verification operation. If an active operation has been
initialized and it cannot be cancelled, **CKR_OPERATION_CANCEL_FAILED** must be
returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_LEN_RANGE, CKR_USER_NOT_LOGGED_IN,
CKR_OPERATION_CANCEL_FAILED.

Example: see **C_VerifySignatureFinal**.

### C_VerifySignature

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifySignature)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen
);
~~~

**C_VerifySignature** verifies a signature in a single-part operation, where the
signature is an appendix to the data. _hSession_ is the session’s handle;
_pData_ points to the data; _ulDataLen_ is the length of the data.

The verification operation MUST have been initialized with
**C_VerifySignatureInit**. A call to **C_VerifySignature** always terminates the
active verification operation.

A successful call to **C_VerifySignature** should return either the value
**CKR_OK** (indicating that the supplied signature is valid) or
**CKR_SIGNATURE_INVALID** (indicating that the supplied signature is invalid).
In any of these cases, the active signing operation is terminated.

**C_VerifySignature** cannot be used to terminate a multi-part operation, and
MUST be called after **C_VerifySignatureInit** without intervening
**C_VerifySignatureUpdate** calls.

For most mechanisms, **C_VerifySignature** is equivalent to a sequence of
**C_VerifySignatureUpdate** operations followed by **C_VerifySignatureFinal**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_INVALID, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_NOT_INITIALIZED,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_INVALID,
CKR_SIGNATURE_LEN_RANGE, CKR_TOKEN_RESOURCE_EXCEEDED.

Example: see **C_VerifySignatureFinal**.
            
### C_VerifySignatureUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifySignatureUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen
);
~~~

**C_VerifySignatureUpdate** continues a multiple-part verification operation,
processing another data part. _hSession_ is the session’s handle, _pPart_ points
to the data part; _ulPartLen_ is the length of the data part.

The verification operation MUST have been initialized with
**C_VerifySignatureInit**. This function may be called any number of times in
succession. A call to **C_VerifySignatureUpdate** which results in an error
terminates the current verification operation.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_NOT_INITIALIZED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_TOKEN_RESOURCE_EXCEEDED.

Example: see **C_VerifySignatureFinal**.
            
### C_VerifySignatureFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_VerifySignatureFinal)(
    CK_SESSION_HANDLE hSession
);
~~~

**C_VerifySignatureFinal** finishes a multiple-part verification operation,
checking the signature. _hSession_ is the session’s handle.

The verification operation MUST have been initialized with
**C_VerifySignatureInit**. A call to **C_VerifySignatureFinal** always
terminates the active verification operation.

A successful call to **C_VerifySignatureFinal** should return either the value
**CKR_OK** (indicating that the supplied signature is valid) or
**CKR_SIGNATURE_INVALID** (indicating that the supplied signature is invalid).
In any of these cases, the active verifying operation is terminated.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_NOT_INITIALIZED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SIGNATURE_INVALID, CKR_SIGNATURE_LEN_RANGE,
CKR_TOKEN_RESOURCE_EXCEEDED.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_DES_MAC, NULL_PTR, 0
};
CK_BYTE data[] = {...};
CK_BYTE mac[4];
CK_RV rv;
.
.
rv = C_VerifySignatureInit(hSession, &mechanism, hKey, mac, sizeof(mac));
if (rv == CKR_OK) {
  rv = C_VerifySignatureUpdate(hSession, data, sizeof(data));
  .
  .
  rv = C_VerifySignatureFinal(hSession);
  .
  .
}
~~~
