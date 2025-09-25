## Parallel function management functions

Cryptoki provides the following functions for managing parallel execution of
cryptographic functions. These functions exist only for backwards compatibility.

### C_GetFunctionStatus

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetFunctionStatus)(
    CK_SESSION_HANDLE hSession
);
~~~

In previous versions of Cryptoki, **C_GetFunctionStatus** obtained the status of
a function running in parallel with an application. Now, however,
**C_GetFunctionStatus** is a legacy function which should simply return the
value **CKR_FUNCTION_NOT_PARALLEL**.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_FUNCTION_FAILED,
CKR_FUNCTION_NOT_PARALLEL, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_CLOSED. 

### C_CancelFunction

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_CancelFunction)(
  CK_SESSION_HANDLE hSession
);
~~~

In previous versions of Cryptoki, **C_CancelFunction** cancelled a function
running in parallel with an application. Now, however, **C_CancelFunction** is a
legacy function which should simply return the value CKR_FUNCTION_NOT_PARALLEL.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_FUNCTION_FAILED,
CKR_FUNCTION_NOT_PARALLEL, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_CLOSED. 
