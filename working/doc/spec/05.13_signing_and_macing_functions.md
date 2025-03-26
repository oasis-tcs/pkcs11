## Signing and MACing functions

Cryptoki provides the following functions for signing data (for the purposes of
Cryptoki, these operations also encompass message authentication codes).

### C_SignInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_SignInit** initializes a signature operation, where the signature is an
appendix to the data. _hSession_ is the session’s handle; _pMechanism_ points to
the signature mechanism; _hKey_ is the handle of the signature key.

The **CKA_SIGN** attribute of the signature key, which indicates whether the key
supports signatures with appendix, MUST be CK_TRUE.

After calling **C_SignInit**, the application can either call **C_Sign** to sign
in a single part; or call **C_SignUpdate** one or more times, followed by
**C_SignFinal**, to sign data in multiple parts. The signature operation is
active until the application uses a call to **C_Sign** or **C_SignFinal** to
actually obtain the signature. To process additional data (in single or multiple
parts), the application MUST call **C_SignInit** again.

**C_SignInit** can be called with pMechanism set to NULL_PTR to terminate an
active signature operation. If an operation has been initialized and it cannot
be cancelled, **CKR_OPERATION_CANCEL_FAILED** must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED,CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_SignFinal**.

### C_Sign

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Sign)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG_PTR pulSignatureLen
);
~~~

**C_Sign** signs data in a single part, where the signature is an appendix to
the data. _hSession_ is the session’s handle; _pData_ points to the data;
_ulDataLen_ is the length of the data; _pSignature_ points to the location that
receives the signature; _pulSignatureLen_ points to the location that holds the
length of the signature.

**C_Sign** uses the convention described in Section 5.2 on producing output.

The signing operation MUST have been initialized with **C_SignInit**. A call to
**C_Sign** always terminates the active signing operation unless it returns
**CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which returns
**CKR_OK**) to determine the length of the buffer needed to hold the signature.

**C_Sign** cannot be used to terminate a multi-part operation, and MUST be
called after **C_SignInit** without intervening **C_SignUpdate** calls.

For most mechanisms, **C_Sign** is equivalent to a sequence of **C_SignUpdate**
operations followed by **C_SignFinal**.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_INVALID, CKR_DATA_LEN_RANGE,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_FUNCTION_REJECTED, CKR_TOKEN_RESOURCE_EXCEEDED.

Example: see **C_SignFinal** for an example of similar functions.

### C_SignUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen
);
~~~

**C_SignUpdate** continues a multiple-part signature operation, processing
another data part. _hSession_ is the session’s handle, _pPart_ points to the
data part; _ulPartLen_ is the length of the data part.

The signature operation MUST have been initialized with **C_SignInit**. This
function may be called any number of times in succession. A call to
**C_SignUpdate** which results in an error terminates the current signature
operation.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_TOKEN_RESOURCE_EXCEEDED.

Example: see **C_SignFinal**.

### C_SignFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignFinal)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pSignature,
    CK_ULONG_PTR pulSignatureLen
);
~~~

**C_SignFinal** finishes a multiple-part signature operation, returning the
signature. _hSession_ is the session’s handle; _pSignature_ points to the
location that receives the signature; _pulSignatureLen_ points to the location
that holds the length of the signature.

**C_SignFinal** uses the convention described in Section 5.2 on producing
output.

The signing operation MUST have been initialized with **C_SignInit**. A call to
**C_SignFinal** always terminates the active signing operation unless it returns
**CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which returns
**CKR_OK**) to determine the length of the buffer needed to hold the signature.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_LEN_RANGE, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_FUNCTION_REJECTED, CKR_TOKEN_RESOURCE_EXCEEDED.

Example: 

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_DES_MAC, NULL_PTR, 0
};
CK_BYTE data[] = {...};
CK_BYTE mac[4];
CK_ULONG ulMacLen;
CK_RV rv;

.
.
rv = C_SignInit(hSession, &mechanism, hKey);
if (rv == CKR_OK) {
  rv = C_SignUpdate(hSession, data, sizeof(data));
  .
  .
  ulMacLen = sizeof(mac);
  rv = C_SignFinal(hSession, mac, &ulMacLen);
  .
  .
}
~~~

### C_SignRecoverInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignRecoverInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_SignRecoverInit** initializes a signature operation, where the data can be
recovered from the signature. _hSession_ is the session’s handle; _pMechanism_
points to the structure that specifies the signature mechanism; _hKey_ is the
handle of the signature key.

The **CKA_SIGN_RECOVER** attribute of the signature key, which indicates whether
the key supports signatures where the data can be recovered from the signature,
MUST be CK_TRUE.

After calling **C_SignRecoverInit**, the application may call **C_SignRecover**
to sign in a single part. The signature operation is active until the
application uses a call to **C_SignRecover** to actually obtain the signature.
To process additional data in a single part, the application MUST call
**C_SignRecoverInit** again.

**C_SignRecoverInit** can be called with pMechanism set to NULL_PTR to terminate
an active signature with data recovery operation. If an active operation has
been initialized and it cannot be cancelled, **CKR_OPERATION_CANCEL_FAILED**
must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_KEY_FUNCTION_NOT_PERMITTED, CKR_KEY_HANDLE_INVALID, CKR_KEY_SIZE_RANGE,
CKR_KEY_TYPE_INCONSISTENT, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_SignRecover**.

### C_SignRecover

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SignRecover)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pSignature,
    CK_ULONG_PTR pulSignatureLen
);
~~~

**C_SignRecover** signs data in a single operation, where the data can be
recovered from the signature. _hSession_ is the session’s handle; _pData_ points
to the data; _uLDataLen_ is the length of the data; _pSignature_ points to the
location that receives the signature; _pulSignatureLen_ points to the location
that holds the length of the signature.

**C_SignRecover** uses the convention described in Section 5.2 on producing
output.

The signing operation MUST have been initialized with **C_SignRecoverInit**. A
call to **C_SignRecover** always terminates the active signing operation unless
it returns **CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which
returns **CKR_OK**) to determine the length of the buffer needed to hold the
signature.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DATA_INVALID, CKR_DATA_LEN_RANGE,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_TOKEN_RESOURCE_EXCEEDED.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_RSA_9796, NULL_PTR, 0
};
CK_BYTE data[] = {...};
CK_BYTE signature[128];
CK_ULONG ulSignatureLen;
CK_RV rv;

.
.
rv = C_SignRecoverInit(hSession, &mechanism, hKey);
if (rv == CKR_OK) {
  ulSignatureLen = sizeof(signature);
  rv = C_SignRecover(
    hSession, data, sizeof(data), signature, &ulSignatureLen);
  if (rv == CKR_OK) {
     .
     .
  }
}
~~~
