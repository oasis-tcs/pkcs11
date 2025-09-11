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

## Extensible Output Digesting Functions

Cryptoki provides the following functions for extensible output functions
(XOFs). These functions are similar to the message digesting functions,
but can produce a variable-length output. The overall operation is split
into an "absorb" phase, where input data is processed, and a "squeeze"
phase, where output data is generated. Keyed XOFs such as KMAC are
supported by passing a key handle in the mechanism parameter to the
initialization function.

### C_DigestXofInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestXofInit)(
    CK_SESSION_HANDLE hSession,
    CK_MECHANISM_PTR pMechanism
);
~~~

**C_DigestXofInit** initializes an extensible output hashing operation.
_hSession_ is the session’s handle; _pMechanism_ points to the digesting
mechanism. For keyed XOFs, _pMechanism_ should contain the handle of the key
to be used.

After calling **C_DigestXofInit**, the application can call
**C_DigestXofUpdate** zero or more times to provide the data to be hashed (the
"absorb" phase), followed by one or more calls to **C_DigestXofExtract** to
retrieve the output (the "squeeze" phase). The extensible output hashing
operation is active until it is explicitly terminated. To process a new
message, the application MUST call **C_DigestXofInit** again.

**C_DigestXofInit** can be called with _pMechanism_ set to NULL_PTR to
terminate an active extensible output hashing operation. If an operation has
been initialized and it cannot be cancelled, **CKR_OPERATION_CANCEL_FAILED**
must be returned.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_MECHANISM_INVALID, CKR_MECHANISM_PARAM_INVALID,
CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN,
CKR_OPERATION_CANCEL_FAILED.

### C_DigestXof

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestXof)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pData,
    CK_ULONG ulDataLen,
    CK_BYTE_PTR pOutput,
    CK_ULONG ulOutputLen
);
~~~

**C_DigestXof** hashes data in a single part for an extensible output function.
_hSession_ is the session’s handle, _pData_ points to the data; _ulDataLen_ is
the length of the data; _pOutput_ points to the location that receives the
output; _ulOutputLen_ specifies the number of bytes to be generated.

The hashing operation MUST have been initialized with **C_DigestXofInit**. A
call to **C_DigestXof** always terminates the active hashing operation.

**C_DigestXof** cannot be used to terminate a multi-part operation, and MUST
be called after **C_DigestXofInit** without intervening **C_DigestXofUpdate**
or **C_DigestXofExtract** calls.

**C_DigestXof** is equivalent to a single call to **C_DigestXofUpdate** with the
provided data, followed by a single call to **C_DigestXofFinal** with the
provided output buffer and length.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

### C_DigestXofUpdate

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestXofUpdate)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pPart,
    CK_ULONG ulPartLen
);
~~~

**C_DigestXofUpdate** continues a multiple-part extensible output hashing
operation, processing another data part in the "absorb" phase. _hSession_
is the session’s handle, _pPart_ points to the data part; _ulPartLen_ is
the length of the data part.

The operation MUST have been initialized with **C_DigestXofInit**. This
function may be called any number of times. A call to **C_DigestXofUpdate**
which results in an error terminates the current operation.

Whether or not this function can be called after **C_DigestXofExtract** has
been called for the current operation is mechanism-specific. For example,
the SHAKE mechanism allows interleaving "absorb" (**C_DigestXofUpdate**) and
"squeeze" (**C_DigestXofExtract**) calls. If the mechanism does not support
inputing more data after **C_DigestXofExtract** has been called once, then
this function will return **CKR_EXCEEDED_MAX_ITERATIONS**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_EXCEEDED_MAX_ITERATIONS, CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

### C_DigestXofExtract

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestXofExtract)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pOutput,
    CK_ULONG ulOutputLen
);
~~~

**C_DigestXofExtract** continues an extensible output hashing operation by
generating a portion of the output in the "squeeze" phase. _hSession_ is
the session’s handle; _pOutput_ points to the location that receives the
output data; _ulOutputLen_ specifies the number of bytes to be generated.

The operation MUST have been initialized with **C_DigestXofInit** and may
have been updated with one or more calls to **C_DigestXofUpdate**. The first
call to **C_DigestXofExtract** begins the "squeeze" phase. Whether or not
further Update calls are permitted is mechanism specific. For example,
the SHAKE mechanism allows interleaving "absorb" (**C_DigestXofUpdate**)
and "squeeze" (**C_DigestXofExtract**) calls.

This function may be called multiple times to generate a variable-length
digest.  Each call will continue generating output from where the previous
call left off.  The operation remains active until explicitly terminated by a
call to **C_DigestXofFinal** or a calls to **C_DigestXofInit** with a NULL
_pMechanism_.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

### C_DigestXofFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestXofFinal)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pOutput,
    CK_ULONG ulOutputLen
);
~~~

**C_DigestXofFinal** finishes a multiple-part extensible output hashing
operation, optionally returning a final portion of the output. _hSession_
is the session’s handle; _pOutput_ points to the location that receives
the output data; _ulOutputLen_ specifies the number of bytes to be
generated. If _ulOutputLen_ is zero, _pOutput_ is ignored.

The operation MUST have been initialized with **C_DigestXofInit**. A call
to **C_DigestXofFinal** always terminates the active extensible output
hashing operation. To start another operation the application MUST call
**C_DigestXofInit** again.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED,
CKR_FUNCTION_CANCELED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

### C_DigestXofKeyValue

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DigestXofKeyValue)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hKey
);
~~~

**C_DigestXofKeyValue** continues a multiple-part message-digesting operation
by digesting the value of a secret key. _hSession_ is the session’s handle;
_hKey_ is the handle of the secret key to be digested.

The message-digesting operation MUST have been initialized with
**C_DigestXofInit**. Calls to this function and **C_DigestXofUpdate** or
**C_DigestXofExtract** may be interspersed any number of times in any order.

If the value of the supplied key cannot be digested purely for some reason
related to its length, **C_DigestXofKeyValue** should return the error code
**CKR_KEY_SIZE_RANGE**.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_KEY_HANDLE_INVALID,
CKR_KEY_INDIGESTIBLE, CKR_KEY_SIZE_RANGE, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey; /* Handle to a secret key for KMAC */
CK_BYTE customizationString[] = "My Customization";

/*
 * For C_DigestXofInit with a keyed XOF like KMAC, the key handle is
 * passed in the mechanism parameters. The following example assumes
 * a CK_KMAC_PARAMS struct that can hold the key handle.
 */
CK_KMAC_PARAMS kmacParams = {
  hKey,
  32,   /* MAC length in bytes (256 bits) */
  customizationString,
  sizeof(customizationString) - 1
};
CK_MECHANISM mechanism = {
  CKM_KMAC_256, &kmacParams, sizeof(kmacParams)
};
CK_BYTE data[] = {...};
CK_BYTE mac[32];
CK_RV rv;

.
.
.
rv = C_DigestXofInit(hSession, &mechanism);
if (rv != CKR_OK) {
  .
  .
}

rv = C_DigestXofUpdate(hSession, data, sizeof(data));
if (rv != CKR_OK) {
  .
  .
}

rv = C_DigestXofExtract(hSession, mac, sizeof(mac));
if (rv != CKR_OK) {
  .
  .
}

rv = C_DigestXofFinal(hSession, NULL_PTR, 0);
if (rv != CKR_OK) {
  .
  .
}
~~~
