## Asynchronous function management functions

Cryptoki provides the following functions for managing asynchronous execution of
cryptographic functions.
            
### C_AsyncComplete

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_AsyncComplete)(
    CK_SESSION_HANDLE hSession
    CK_UTF8CHAR_PTR pFunctionName,
    CK_ASYNC_DATA_PTR pResult
);
~~~

**C_AsyncComplete** checks if the function identified by _pFunctionName_ has
completed an asynchronous operation and, if so, returns the associated
result(s). _hSession_ is the session’s handle; _pFunctionName_ is the name of
the function whose state is being queried; _pResult_ is a pointer to a structure
to receive the result(s) if the function has completed. If the operation has not
completed, **CKR_PENDING** is returned, and the location pointed to by _pResult_
is not modified. If **C_AsyncComplete** returns an error other than
**CKR_PENDING**, the pValue item of _pResult_ is set to the address passed into
**C_AsyncJoin** as _pData_, or the address passed into the original call to
_pFunctionName_ as the variable-length output buffer, so that it may be freed if
dynamically allocated.

For functions that take a buffer in which to place the result of the operation:

* They must return **CKR_BUFFER_TOO_SMALL** if the input buffer is too small.
  They cannot return **CKR_PENDING**.
* Callers must ensure that the buffer passed into the original function remains
  available to the module for the duration of the operation.

Return values: This function’s return values are as returned by the function
identified by _pFunctionName_.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey;
CK_MECHANISM mechanism = {
  CKM_DES_MAC, NULL_PTR, 0
};

CK_BYTE data[] = {...};
CK_BYTE_PTR mac = NULL_PTR;
CK_ULONG ulMacLen = 0;
CK_RV rv;
.
.
rv = C_SignInit(hSession, &mechanism, hKey);
while (rv == CKR_PENDING)
{
  rv = C_AsyncComplete(hSession, (CK_UTF8CHAR_PTR)"C_SignInit", NULL_PTR);
  /* rv will contain CKR_PENDING if the operation is still running 
     or it will contain the return code from the C_SignInit operation */
}

if (rv == CKR_OK) 
{
  rv = C_SignUpdate(hSession, data, sizeof(data));
  while (rv == CKR_PENDING)
  {
    rv = C_AsyncComplete(hSession, (CK_UTF8CHAR_PTR)"C_SignUpdate", NULL_PTR);
    /* rv will contain CKR_PENDING if the operation is still running 
       or it will contain the return code from the C_SignUpdate operation */
  }
  .
  .
  rv = C_SignFinal(hSession, mac, &ulMacLen);
  if (rv == CKR_BUFFER_TOO_SMALL)
  {
    mac = (CK_BYTE_PTR)malloc(ulMacLen);
    rv = C_SignFinal(hSession, mac, &ulMacLen);
  }
  
  if (rv == CKR_PENDING)
  {
    .
    .
    CK_ASYNC_DATA result;
    result.ulVersion = 0;
    result.pValue = NULL_PTR;
    result.ulValue = 0;
    rv = C_AsyncComplete(hSession, (CK_UTF8CHAR_PTR)"C_SignFinal", &result);
    /* on success, result.pValue contains the pointer to the buffer input 
       to C_SignFinal i.e., on success, mac == result.pValue */
  }
}
~~~

### C_AsyncGetID

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_AsyncGetID)(
    CK_SESSION_HANDLE hSession
    CK_UTF8CHAR_PTR pFunctionName,
    CK_ULONG_PTR pulID
);
~~~

**C_AsyncGetID** is used to persist an operation past a **C_Finalize** call and
allow another instance of the client to reconnect after a call to
**C_Initialize**. **C_AsyncGetID** places a module dependent identifier for the
asynchronous operation being performed by the function identified by
_pFunctionName_. _hSession_ is the session’s handle; _pFunctionName_ is the name
of the function for which an identifier is being requested; _pulID_ is a pointer
to a ULONG to contain the identifier.

An attempt to obtain an identifier for a function that is not performing an
asynchronous operation should fail with the error
**CKR_OPERATION_NOT_INITIALIZED**.

An attempt to obtain an identifier for a function that is performing an
asynchronous operation, but for which the module is unable or unwilling to
persist past session close should fail with the error **CKR_STATE_UNSAVEABLE**.

After a successful call to **C_AsyncGetID** the caller should free any memory
passed into the original call to _pFunctionName_.

Return values: This function’s return values are CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_ARGUMENTS_BAD, CKR_TOKEN_NOT_PRESENT,
CKR_STATE_UNSAVEABLE.

### C_AsyncJoin

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_AsyncJoin)(
    CK_SESSION_HANDLE hSession
    CK_UTF8CHAR_PTR pFunctionName,
    CK_ULONG ulID,
    CK_BYTE_PTR pData,
    CK_ULONG ulData
);
~~~

**C_AsyncJoin** checks if the function identified by _pFunctionName_ and _ulID_
is a valid asynchronous operation and, if so, reconnects the client application
to the module using the buffer specified by _pData_ and _ulData_ in place of
those passed into the original call to _pFunctionName_. _hSession_ is the
session’s handle; _pFunctionName_ is the name of the function to join; _ulID_ is
an identifier returned by **C_AsyncGetID**; _pData_ is a pointer to a buffer to
contain the result once the function has completed; _ulData_ is the length in
bytes of the data.

This function follows the conventions in section 5.2 with respect to _pData_ and
_ulData_ if the function identified by _pFunctionName_ requires an output
buffer. If the function identified by _pFunctionName_ does not require an output
buffer _pData_ and _ulData_ should be ignored.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_ARGUMENTS_BAD, CKR_TOKEN_NOT_PRESENT, CKR_SAVED_STATE_INVALID,
CKR_BUFFER_TOO_SMALL.
