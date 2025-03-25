## General-purpose functions

Cryptoki provides the following general-purpose functions:

### C_Initialize

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Initialize) {
    CK_VOID_PTR pInitArgs
);
~~~

**C_Initialize** initializes the Cryptoki library. _pInitArgs_ either has the
value NULL_PTR or points to a **CK_C_INITIALIZE_ARGS** structure containing
information on how the library should deal with multi-threaded access. If an
application will not be accessing Cryptoki through multiple threads
simultaneously, it can generally supply the value NULL_PTR to C_Initialize (the
consequences of supplying this value will be explained below).

If _pInitArgs_ is non-NULL_PTR, **C_Initialize** should cast it to a
**CK_C_INITIALIZE_ARGS_PTR** and then dereference the resulting pointer to
obtain the **CK_C_INITIALIZE_ARGS** fields _CreateMutex_, _DestroyMutex_,
_LockMutex_, _UnlockMutex_, _flags_, and _pReserved_. For this version of
Cryptoki, the value of _pReserved_ thereby obtained MUST be NULL_PTR; if it’s
not, then **C_Initialize** should return with the value **CKR_ARGUMENTS_BAD**.

If the **CKF_LIBRARY_CANT_CREATE_OS_THREADS** flag in the flags field is set,
that indicates that application threads which are executing calls to the
Cryptoki library are not permitted to use the native operation system calls to
spawn off new threads. In other words, the library’s code may not create its own
threads. If the library is unable to function properly under this restriction,
**C_Initialize** should return with the value **CKR_NEED_TO_CREATE_THREADS**.

A call to **C_Initialize** specifies one of four different ways to support
multi-threaded access via the value of the **CKF_OS_LOCKING_OK** flag in the
flags field and the values of the _CreateMutex_, _DestroyMutex_, _LockMutex_,
and _UnlockMutex_ function pointer fields:

1. If the flag isn’t set, and the function pointer fields aren’t supplied (i.e.,
   they all have the value NULL_PTR), that means that the application won’t be
   accessing the Cryptoki library from multiple threads simultaneously.
2. If the flag is set, and the function pointer fields aren’t supplied (i.e.,
   they all have the value NULL_PTR), that means that the application will be
   performing multi-threaded Cryptoki access, and the library needs to use the
   native operating system primitives to ensure safe multi-threaded access. If
   the library is unable to do this, **C_Initialize** should return with the
   value **CKR_CANT_LOCK**.
3. If the flag isn’t set, and the function pointer fields are supplied (i.e.,
   they all have non-NULL_PTR values), that means that the application will be
   performing multi-threaded Cryptoki access, and the library needs to use the
   supplied function pointers for mutex-handling to ensure safe multi-threaded
   access. If the library is unable to do this, **C_Initialize** should return
   with the value **CKR_CANT_LOCK**.
4. If the flag is set, and the function pointer fields are supplied (i.e., they
   all have non-NULL_PTR values), that means that the application will be
   performing multi-threaded Cryptoki access, and the library needs to use
   either the native operating system primitives or the supplied function
   pointers for mutex-handling to ensure safe multi-threaded access. If the
   library is unable to do this, **C_Initialize** should return with the value
   **CKR_CANT_LOCK**.

If some, but not all, of the supplied function pointers to **C_Initialize** are
non-NULL_PTR, then **C_Initialize** should return with the value
**CKR_ARGUMENTS_BAD**.

A call to **C_Initialize** with _pInitArgs_ set to NULL_PTR is treated like a
call to **C_Initialize** with _pInitArgs_ pointing to a **CK_C_INITIALIZE_ARGS**
which has the _CreateMutex_, _DestroyMutex_, _LockMutex_, _UnlockMutex_, and
_pReserved_ fields set to NULL_PTR, and has the _flags_ field set to 0.

**C_Initialize** should be the first Cryptoki call made by an application,
except for calls to **C_GetFunctionList**, **C_GetInterfaceList**, or
**C_GetInterface**. What this function actually does is
implementation-dependent; typically, it might cause Cryptoki to initialize its
internal memory buffers, or any other resources it requires.

If several applications are using Cryptoki, each one should call
**C_Initialize**. Every call to **C_Initialize** should (eventually) be
succeeded by a single call to **C_Finalize**. See [PKCS11-UG] for further
details.

Return values: CKR_ARGUMENTS_BAD, CKR_CANT_LOCK,
CKR_CRYPTOKI_ALREADY_INITIALIZED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_NEED_TO_CREATE_THREADS, CKR_OK.

Example: see **C_GetInfo**.

### C_Finalize

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Finalize)(
    CK_VOID_PTR pReserved
);
~~~

**C_Finalize** is called to indicate that an application is finished with the
Cryptoki library. It should be the last Cryptoki call made by an application.
The _pReserved_ parameter is reserved for future versions; for this version, it
should be set to NULL_PTR (if **C_Finalize** is called with a non-NULL_PTR value
for _pReserved_, it should return the value **CKR_ARGUMENTS_BAD**.

If several applications are using Cryptoki, each one should call **C_Finalize**.
Each application’s call to **C_Finalize** should be preceded by a single call to
**C_Initialize**; in between the two calls, an application can make calls to
other Cryptoki functions. See [PKCS11-UG] for further details.

Despite the fact that the parameters supplied to **C_Initialize** can in general
allow for safe multi-threaded access to a Cryptoki library, the behavior of
**C_Finalize** is nevertheless undefined if it is called by an application while
other threads of the application are making Cryptoki calls. The exception to
this exceptional behavior of **C_Finalize** occurs when a thread calls
**C_Finalize** while another of the application’s threads is blocking on
Cryptoki’s **C_WaitForSlotEvent** function.  When this happens, the blocked
thread becomes unblocked and returns the value **CKR_CRYPTOKI_NOT_INITIALIZED**.
See **C_WaitForSlotEvent** for more information.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK.

Example: see **C_GetInfo**.

### C_GetInfo

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetInfo)(
    CK_INFO_PTR pInfo
);
~~~

**C_GetInfo** returns general information about Cryptoki. _pInfo_ points to the
location that receives the information.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK.

Example:

~~~{.c}
CK_INFO info;
CK_RV rv;
CK_C_INITIALIZE_ARGS InitArgs;

InitArgs.CreateMutex = &MyCreateMutex;
InitArgs.DestroyMutex = &MyDestroyMutex;
InitArgs.LockMutex = &MyLockMutex;
InitArgs.UnlockMutex = &MyUnlockMutex;
InitArgs.flags = CKF_OS_LOCKING_OK;
InitArgs.pReserved = NULL_PTR;

rv = C_Initialize((CK_VOID_PTR)&InitArgs);
assert(rv == CKR_OK);

rv = C_GetInfo(&info);
assert(rv == CKR_OK);
if(info.cryptokiVersion.major == 2) {
  /* Do lots of interesting cryptographic things with the token */
  .
  .
}

rv = C_Finalize(NULL_PTR);
assert(rv == CKR_OK);
~~~

### C_GetFunctionList

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetFunctionList)(
    CK_FUNCTION_LIST_PTR_PTR ppFunctionList
);
~~~

**C_GetFunctionList** obtains a pointer to the Cryptoki library’s list of
function pointers. _ppFunctionList_ points to a value which will receive a
pointer to the library’s **CK_FUNCTION_LIST** structure, which in turn contains
function pointers for all the Cryptoki API routines in the library. _The pointer
thus obtained may point into memory which is owned by the Cryptoki library, and
which may or may not be writable_. Whether or not this is the case, no attempt
should be made to write to this memory.

**C_GetFunctionList**, **C_GetInterfaceList**, and **C_GetInterface** are the
only Cryptoki functions which an application may call before calling
**C_Initialize**. It is provided to make it easier and faster for applications
to use shared Cryptoki libraries and to use more than one Cryptoki library
simultaneously.

Return values: CKR_ARGUMENTS_BAD, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK.

Example:

~~~{.c}
CK_FUNCTION_LIST_PTR pFunctionList;
CK_C_Initialize pC_Initialize;
CK_RV rv;

/* It’s OK to call C_GetFunctionList before calling C_Initialize */
rv = C_GetFunctionList(&pFunctionList);
assert(rv == CKR_OK);
pC_Initialize = pFunctionList -> C_Initialize;

/* Call the C_Initialize function in the library */
rv = (*pC_Initialize)(NULL_PTR);
~~~

### C_GetInterfaceList

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetInterfaceList)(
    CK_INTERFACE_PTR      pInterfaceList,
    CK_ULONG_PTR          pulCount
);
~~~

**C_GetInterfaceList** is used to obtain a list of interfaces supported by a
Cryptoki library. pulCount points to the location that receives the number of
interfaces.

There are two ways for an application to call **C_GetInterfaceList**:

1. If _pInterfaceList_ is NULL_PTR, then all that **C_GetInterfaceList** does is
   return (in _\*pulCount_) the number of interfaces, without actually returning
   a list of interfaces. The contents of _\*pulCount_ on entry to
   **C_GetInterfaceList** has no meaning in this case, and the call returns the
   value **CKR_OK**.
2. If _pIntrerfaceList_ is not NULL_PTR, then _\*pulCount_ MUST contain the size
   (in terms of **CK_INTERFACE** elements) of the buffer pointed to by
   _pInterfaceList_.  If that buffer is large enough to hold the list of
   interfaces, then the list is returned in it, and **CKR_OK** is returned. If
   not, then the call to **C_GetInterfaceList** returns the value
   **CKR_BUFFER_TOO_SMALL**. In either case, the value _\*pulCount_ is set to
   hold the number of interfaces.

Because **C_GetInterfaceList** does not allocate any space of its own, an
application will often call **C_GetInterfaceList** twice. However, this behavior
is by no means required.

**C_GetInterfaceList** obtains (in _\*pFunctionList_ of each interface) a
pointer to the Cryptoki library’s list of function pointers. The pointer thus
obtained may point into memory which is owned by the Cryptoki library, and which
may or may not be writable. Whether or not this is the case, no attempt should
be made to write to this memory. The same caveat applies to the interface names
returned.

**C_GetFunctionList**, **C_GetInterfaceList**, and **C_GetInterface** are the
only Cryptoki functions which an application may call before calling
**C_Initialize**. It is provided to make it easier and faster for applications
to use shared Cryptoki libraries and to use more than one Cryptoki library
simultaneously.

Return values: CKR_BUFFER_TOO_SMALL, CKR_ARGUMENTS_BAD, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK.

Example:

~~~{.c}
CK_ULONG ulCount=0;
CK_INTERFACE_PTR interfaceList=NULL;
CK_RV rv;
int I;

/* get number of interfaces */
rv = C_GetInterfaceList(NULL,&ulCount);
if (rv == CKR_OK) {
  /* get copy of interfaces */
  interfaceList = (CK_INTERFACE_PTR)malloc(ulCount*sizeof(CK_INTERFACE));
  rv = C_GetInterfaceList(interfaceList,&ulCount);
  for(i=0;i<ulCount;i++) {
    printf("interface %s version %d.%d funcs %p flags 0x%lu\n",
	interfaceList[i].pInterfaceName,
	((CK_VERSION *)interfaceList[i].pFunctionList)->major,
	((CK_VERSION *)interfaceList[i].pFunctionList)->minor,
        interfaceList[i].pFunctionList,
	interfaceList[i].flags);
  }
}
~~~

### C_GetInterface

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV,C_GetInterface)(
    CK_UTF8CHAR_PTR       pInterfaceName,
    CK_VERSION_PTR        pVersion,
    CK_INTERFACE_PTR_PTR  ppInterface,
    CK_FLAGS              flags
);
~~~

**C_GetInterface** is used to obtain an interface supported by a Cryptoki
library. pInterfaceName specifies the name of the interface, pVersion specifies
the interface version, ppInterface points to the location that receives the
interface, flags specifies the required interface flags.

There are multiple ways for an application to specify a particular interface
when calling **C_GetInterface**:

1. If pInterfaceName is not NULL_PTR, the name of the interface returned must
   match. If pInterfaceName is NULL_PTR, the cryptoki library can return a
   default interface of its choice
2. If pVersion is not NULL_PTR, the version of the interface returned must
   match. If pVersion is NULL_PTR, the cryptoki library can return an interface
   of any version
3. If flags is non-zero, the interface returned must match all of the supplied
   flag values (but may include additional flags not specified). If flags is 0,
   the cryptoki library can return an interface with any flags

**C_GetInterface** obtains (in *pFunctionList of each interface) a pointer to
the Cryptoki library’s list of function pointers. The pointer thus obtained may
point into memory which is owned by the Cryptoki library, and which may or may
not be writable. Whether or not this is the case, no attempt should be made to
write to this memory. The same caveat applies to the interface names returned.

**C_GetFunctionList**, **C_GetInterfaceList**, and **C_GetInterface** are the
only Cryptoki functions which an application may call before calling
**C_Initialize**. It is provided to make it easier and faster for applications
to use shared Cryptoki libraries and to use more than one Cryptoki library
simultaneously.

Return values: CKR_BUFFER_TOO_SMALL, CKR_ARGUMENTS_BAD, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK.

Example:

~~~{.c}
CK_INTERFACE_PTR interface;
CK_RV rv;
CK_VERSION version;
CK_FLAGS flags=CKF_ INTERFACE_FORK_SAFE;

/* get default interface */
rv = C_GetInterface(NULL,NULL,&interface,flags);
if (rv == CKR_OK) {
  printf("interface %s version %d.%d funcs %p flags 0x%lu\n",
	interface->pInterfaceName,
	((CK_VERSION *)interface->pFunctionList)->major,
	((CK_VERSION *)interface->pFunctionList)->minor,
	interface->pFunctionList,
	interface->flags);
}

/* get default standard interface */
rv = C_GetInterface((CK_UTF8CHAR_PTR)"PKCS 11",NULL,&interface,flags);
if (rv == CKR_OK) {
  printf("interface %s version %d.%d funcs %p flags 0x%lu\n",
	interface->pInterfaceName,
	((CK_VERSION *)interface->pFunctionList)->major,
	((CK_VERSION *)interface->pFunctionList)->minor,
	interface->pFunctionList,
	interface->flags);
}

/* get specific standard version interface */
version.major=3;
version.minor=0;
rv = C_GetInterface((CK_UTF8CHAR_PTR)"PKCS 11",&version,&interface,flags);
if (rv == CKR_OK) {
  CK_FUNCTION_LIST_3_0_PTR pkcs11=interface->pFunctionList;
  
  /* ... use the new functions */
  pkcs11->C_LoginUser(hSession,userType,pPin,ulPinLen,
                                                  pUsername,ulUsernameLen);
}

/* get specific vendor version interface */
version.major=1;
version.minor=0;
rv = C_GetInterface((CK_UTF8CHAR_PTR)
                        "Vendor VendorName",&version,&interface,flags);
if (rv == CKR_OK) {
  CK_FUNCTION_LIST_VENDOR_1_0_PTR pkcs11=interface->pFunctionList;
  
  /* ... use vendor specific functions */
  pkcs11->C_VendorFunction1(param1,param2,param3);
}
~~~
