## Message digesting functions

Cryptoki provides the following functions for digesting data: 

### C_DigestInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism
);
~~~

**C_DigestInit** initializes a message-digesting operation. _hSession_ is the
session’s handle; _pMechanism_ points to the digesting mechanism.

After calling **C_DigestInit**, the application can either call **C_Digest** to
digest data in a single part; or call **C_DigestUpdate** zero or more times,
followed by **C_DigestFinal**, to digest data in multiple parts. The
message-digesting operation is active until the application uses a call to
**C_Digest** or **C_DigestFinal** to actually obtain the message digest. To
process additional data (in single or multiple parts), the application MUST call
**C_DigestInit** again.

**C_DigestInit** can be called with _pMechanism_ set to NULL_PTR to terminate an
active message-digesting operation. If an operation has been initialized and it
cannot be cancelled, **CKR_OPERATION_CANCEL_FAILED** must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_MECHANISM_INVALID,
CKR_MECHANISM_PARAM_INVALID, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING,
CKR_PIN_EXPIRED, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_USER_NOT_LOGGED_IN, CKR_OPERATION_CANCEL_FAILED.

Example: see **C_DigestFinal**.

### C_Digest

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Digest)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pDigest,
    CK_ULONG_PTR pulDigestLen
);
~~~

**C_Digest** digests data in a single part. _hSession_ is the session’s handle,
_pData_ points to the data; _ulDataLen_ is the length of the data; _pDigest_
points to the location that receives the message digest; _pulDigestLen_ points
to the location that holds the length of the message digest.

**C_Digest** uses the convention described in Section 5.2 on producing output.

The digest operation MUST have been initialized with **C_DigestInit**. A call to
**C_Digest** always terminates the active digest operation unless it returns
**CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which returns
**CKR_OK**) to determine the length of the buffer needed to hold the message
digest.

**C_Digest** cannot be used to terminate a multi-part operation, and MUST be
called after **C_DigestInit** without intervening **C_DigestUpdate** calls.

The input data and digest output can be in the same place, i.e., it is OK if
_pData_ and _pDigest_ point to the same location.

**C_Digest** is equivalent to a sequence of **C_DigestUpdate** operations
followed by **C_DigestFinal**.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example: see **C_DigestFinal** for an example of similar functions.

### C_DigestUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen
);
~~~

**C_DigestUpdate** continues a multiple-part message-digesting operation,
processing another data part. _hSession_ is the session’s handle, _pPart_ points
to the data part; _ulPartLen_ is the length of the data part.

The message-digesting operation MUST have been initialized with
**C_DigestInit**. Calls to this function and **C_DigestKey** may be interspersed
any number of times in any order. A call to **C_DigestUpdate** which results in
an error terminates the current digest operation.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example: see **C_DigestFinal**.

### C_DigestKey

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestKey)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_DigestKey** continues a multiple-part message-digesting operation by
digesting the value of a secret key. _hSession_ is the session’s handle; _hKey_
is the handle of the secret key to be digested.

The message-digesting operation MUST have been initialized with
**C_DigestInit**. Calls to this function and **C_DigestUpdate** may be
interspersed any number of times in any order.

If the value of the supplied key cannot be digested purely for some reason
related to its length, **C_DigestKey** should return the error code
**CKR_KEY_SIZE_RANGE**.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_KEY_HANDLE_INVALID,
CKR_KEY_INDIGESTIBLE, CKR_KEY_SIZE_RANGE, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example: see **C_DigestFinal**.

### C_DigestFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestFinal)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pDigest,
    CK_ULONG_PTR pulDigestLen
);
~~~

**C_DigestFinal** finishes a multiple-part message-digesting operation,
returning the message digest. _hSession_ is the session’s handle; _pDigest_
points to the location that receives the message digest; _pulDigestLen_ points
to the location that holds the length of the message digest.

**C_DigestFinal** uses the convention described in Section 5.2 on producing
output.

The digest operation MUST have been initialized with **C_DigestInit**. A call to
**C_DigestFinal** always terminates the active digest operation unless it
returns **CKR_BUFFER_TOO_SMALL** or is a successful call (i.e., one which
returns **CKR_OK**) to determine the length of the buffer needed to hold the
message digest.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY,
CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_MD5, NULL_PTR, 0
};
CK_BYTE data[] = {...};
CK_BYTE digest[16];
CK_ULONG ulDigestLen;
CK_RV rv;

.
.
rv = C_DigestInit(hSession, &mechanism);
if (rv != CKR_OK) {
  .
  .
}

rv = C_DigestUpdate(hSession, data, sizeof(data));
if (rv != CKR_OK) {
  .
  .
}

rv = C_DigestKey(hSession, hKey);
if (rv != CKR_OK) {
  .
  .
}

ulDigestLen = sizeof(digest);
rv = C_DigestFinal(hSession, digest, &ulDigestLen);
.
.
~~~
