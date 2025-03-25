## Slot and token management functions

Cryptoki provides the following functions for slot and token management:

### C_GetSlotList

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetSlotList)(
    CK_BBOOL tokenPresent,
    CK_SLOT_ID_PTR pSlotList,
    CK_ULONG_PTR pulCount
);
~~~

**C_GetSlotList** is used to obtain a list of slots in the system. _tokenPresent_
indicates whether the list obtained includes only those slots with a token
present (CK_TRUE), or all slots (CK_FALSE); pulCount points to the location that
receives the number of slots.

There are two ways for an application to call **C_GetSlotList**:

1. If _pSlotList_ is NULL_PTR, then all that **C_GetSlotList** does is return
   (in _\*pulCount_) the number of slots, without actually returning a list of
   slots. The contents of the buffer pointed to by _pulCount_ on entry to
   **C_GetSlotList** has no meaning in this case, and the call returns the value
   **CKR_OK**.
2. If _pSlotList_ is not NULL_PTR, then _\*pulCount_ MUST contain the size (in
   terms of **CK_SLOT_ID** elements) of the buffer pointed to by _pSlotList_. If
   that buffer is large enough to hold the list of slots, then the list is
   returned in it, and **CKR_OK** is returned. If not, then the call to
   **C_GetSlotList** returns the value **CKR_BUFFER_TOO_SMALL**. In either case,
   the value _\*pulCount_ is set to hold the number of slots.

Because **C_GetSlotList** does not allocate any space of its own, an application
will often call **C_GetSlotList** twice (or sometimes even more times—if an
application is trying to get a list of all slots with a token present, then the
number of such slots can (unfortunately) change between when the application
asks for how many such slots there are and when the application asks for the
slots themselves). However, multiple calls to **C_GetSlotList** are by no means
_required_.

All slots which **C_GetSlotList** reports MUST be able to be queried as valid
slots by **C_GetSlotInfo**.  Furthermore, the set of slots accessible through a
Cryptoki library is checked at the time that **C_GetSlotList**, for list length
prediction (NULL _pSlotList_ argument) is called. If an application calls
**C_GetSlotList** with a non-NULL _pSlotList_, and then the user adds or removes
a hardware device, the changed slot list will only be visible and effective if
**C_GetSlotList** is called again with NULL. Even if **C_GetSlotList** is
successfully called this way, it may or may not be the case that the changed
slot list will be successfully recognized depending on the library
implementation. On some platforms, or earlier PKCS11 compliant libraries, it may
be necessary to successfully call **C_Initialize** or to restart the entire
system.

Return values: CKR_ARGUMENTS_BAD, CKR_BUFFER_TOO_SMALL,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK.

Example:

~~~{.c}
CK_ULONG ulSlotCount, ulSlotWithTokenCount;
CK_SLOT_ID_PTR pSlotList, pSlotWithTokenList;
CK_RV rv;

/* Get list of all slots */
rv = C_GetSlotList(CK_FALSE, NULL_PTR, &ulSlotCount);
if (rv == CKR_OK) {
  pSlotList =
    (CK_SLOT_ID_PTR) malloc(ulSlotCount*sizeof(CK_SLOT_ID));
  rv = C_GetSlotList(CK_FALSE, pSlotList, &ulSlotCount);
  if (rv == CKR_OK) {
    /* Now use that list of all slots */
    .
    .
  }

  free(pSlotList);
}

/* Get list of all slots with a token present */
pSlotWithTokenList = (CK_SLOT_ID_PTR) malloc(0);
ulSlotWithTokenCount = 0;
while (1) {
  rv = C_GetSlotList(
    CK_TRUE, pSlotWithTokenList, &ulSlotWithTokenCount);
  if (rv != CKR_BUFFER_TOO_SMALL)
    break;
  pSlotWithTokenList = realloc(
    pSlotWithTokenList,
    ulSlotWithTokenList*sizeof(CK_SLOT_ID));
}

if (rv == CKR_OK) {
  /* Now use that list of all slots with a token present */
  .
  .
}

free(pSlotWithTokenList);
~~~

### C_GetSlotInfo

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetSlotInfo)(
    CK_SLOT_ID slotID,
    CK_SLOT_INFO_PTR pInfo
);
~~~

**C_GetSlotInfo** obtains information about a particular slot in the system.
slotID is the ID of the slot; pInfo points to the location that receives the
slot information.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY,
CKR_OK, CKR_SLOT_ID_INVALID.

Example: see **C_GetTokenInfo**.

### C_GetTokenInfo

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetTokenInfo)(
    CK_SLOT_ID slotID,
    CK_TOKEN_INFO_PTR pInfo
);
~~~

**C_GetTokenInfo** obtains information about a particular token in the system.
_slotID_ is the ID of the token’s slot; _pInfo_ points to the location that
receives the token information.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_SLOT_ID_INVALID, CKR_TOKEN_NOT_PRESENT,
CKR_TOKEN_NOT_RECOGNIZED, CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_ULONG ulCount;
CK_SLOT_ID_PTR pSlotList;
CK_SLOT_INFO slotInfo;
CK_TOKEN_INFO tokenInfo;
CK_RV rv;

rv = C_GetSlotList(CK_FALSE, NULL_PTR, &ulCount);
if ((rv == CKR_OK) && (ulCount > 0)) {
  pSlotList = (CK_SLOT_ID_PTR) malloc(ulCount*sizeof(CK_SLOT_ID));
  rv = C_GetSlotList(CK_FALSE, pSlotList, &ulCount);
  assert(rv == CKR_OK);

  /* Get slot information for first slot */
  rv = C_GetSlotInfo(pSlotList[0], &slotInfo);
  assert(rv == CKR_OK);

  /* Get token information for first slot */
  rv = C_GetTokenInfo(pSlotList[0], &tokenInfo);
  if (rv == CKR_TOKEN_NOT_PRESENT) {
    .
    .
  }
  .
  .
  free(pSlotList);
}
~~~

### C_WaitForSlotEvent

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_WaitForSlotEvent)(
    CK_FLAGS flags,
    CK_SLOT_ID_PTR pSlot,
    CK_VOID_PTR pReserved
);
~~~

**C_WaitForSlotEvent** waits for a slot event, such as token insertion or token
removal, to occur. _flags_ determines whether or not the **C_WaitForSlotEvent**
call blocks (_i.e._, waits for a slot event to occur); _pSlot_ points to a
location which will receive the ID of the slot that the event occurred in.
_pReserved_ is reserved for future versions; for this version of Cryptoki, it
should be NULL_PTR.

At present, the only flag defined for use in the flags argument is
**CKF_DONT_BLOCK**:

Internally, each Cryptoki application has a flag for each slot which is used to
track whether or not any unrecognized events involving that slot have occurred.
When an application initially calls **C_Initialize**, every slot’s event flag is
cleared. Whenever a slot event occurs, the flag corresponding to the slot in
which the event occurred is set.

If **C_WaitForSlotEvent** is called with the **CKF_DONT_BLOCK** flag set in the
flags argument, and some slot’s event flag is set, then that event flag is
cleared, and the call returns with the ID of that slot in the location pointed
to by _pSlot_. If more than one slot’s event flag is set at the time of the
call, one such slot is chosen by the library to have its event flag cleared and
to have its slot ID returned.

If **C_WaitForSlotEvent** is called with the **CKF_DONT_BLOCK** flag set in the
flags argument, and no slot’s event flag is set, then the call returns with the
value **CKR_NO_EVENT**. In this case, the contents of the location pointed to by
pSlot when **C_WaitForSlotEvent** are undefined.

If **C_WaitForSlotEvent** is called with the **CKF_DONT_BLOCK** flag clear in
the _flags_ argument, then the call behaves as above, except that it will block.
That is, if no slot’s event flag is set at the time of the call,
**C_WaitForSlotEvent** will wait until some slot’s event flag becomes set. If a
thread of an application has a **C_WaitForSlotEvent** call blocking when another
thread of that application calls **C_Finalize**, the **C_WaitForSlotEvent** call
returns with the value CKR_CRYPTOKI_NOT_INITIALIZED.

_Although the parameters supplied to **C_Initialize** can in general allow for
safe multi-threaded access to a Cryptoki library, **C_WaitForSlotEvent** is
exceptional in that the behavior of Cryptoki is undefined if multiple threads of
a single application make simultaneous calls to **C_WaitForSlotEvent**_.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_NO_EVENT, CKR_OK.

Example:

~~~{.c}
CK_FLAGS flags = 0;
CK_SLOT_ID slotID;
CK_SLOT_INFO slotInfo;
CK_RV rv;
.
.
/* Block and wait for a slot event */
rv = C_WaitForSlotEvent(flags, &slotID, NULL_PTR);
assert(rv == CKR_OK);

/* See what’s up with that slot */
rv = C_GetSlotInfo(slotID, &slotInfo);
assert(rv == CKR_OK);
~~~

### C_GetMechanismList

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetMechanismList)(
    CK_SLOT_ID slotID,
    CK_MECHANISM_TYPE_PTR pMechanismList,
    CK_ULONG_PTR pulCount
);
~~~

**C_GetMechanismList** is used to obtain a list of mechanism types supported by
a token. _SlotID_ is the ID of the token’s slot; pulCount points to the location
that receives the number of mechanisms.

There are two ways for an application to call **C_GetMechanismList**:

1. If _pMechanismList_ is NULL_PTR, then all that **C_GetMechanismList** does is
   return (in _\*pulCount_) the number of mechanisms, without actually returning
   a list of mechanisms. The contents of _\*pulCount_ on entry to
   **C_GetMechanismList** has no meaning in this case, and the call returns the
   value **CKR_OK**.
2. If _pMechanismList_ is not NULL_PTR, then _\*pulCount_ MUST contain the size
   (in terms of **CK_MECHANISM_TYPE** elements) of the buffer pointed to by
   _pMechanismList_. If that buffer is large enough to hold the list of
   mechanisms, then the list is returned in it, and **CKR_OK** is returned. If
   not, then the call to **C_GetMechanismList** returns the value
   **CKR_BUFFER_TOO_SMALL**. In either case, the value _\*pulCount_ is set to
   hold the number of mechanisms.

Because **C_GetMechanismList** does not allocate any space of its own, an
application will often call **C_GetMechanismList** twice. However, this behavior
is by no means required.

Return values: CKR_BUFFER_TOO_SMALL, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_SLOT_ID_INVALID,
CKR_TOKEN_NOT_PRESENT, CKR_TOKEN_NOT_RECOGNIZED, CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SLOT_ID slotID;
CK_ULONG ulCount;
CK_MECHANISM_TYPE_PTR pMechanismList;
CK_RV rv;

.
.
rv = C_GetMechanismList(slotID, NULL_PTR, &ulCount);
if ((rv == CKR_OK) && (ulCount > 0)) {
  pMechanismList =
    (CK_MECHANISM_TYPE_PTR)
    malloc(ulCount*sizeof(CK_MECHANISM_TYPE));
  rv = C_GetMechanismList(slotID, pMechanismList, &ulCount);
  if (rv == CKR_OK) {
    .
    .
  }
  free(pMechanismList);
}
~~~

### C_GetMechanismInfo

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetMechanismInfo)(
    CK_SLOT_ID slotID,
    CK_MECHANISM_TYPE type,
    CK_MECHANISM_INFO_PTR pInfo
);
~~~

**C_GetMechanismInfo** obtains information about a particular mechanism possibly
supported by a token. _slotID_ is the ID of the token’s slot; type is the type
of mechanism; pInfo points to the location that receives the mechanism
information.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_MECHANISM_INVALID, CKR_OK, CKR_SLOT_ID_INVALID,
CKR_TOKEN_NOT_PRESENT, CKR_TOKEN_NOT_RECOGNIZED, CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SLOT_ID slotID;
CK_MECHANISM_INFO info;
CK_RV rv;

.
.
/* Get information about the CKM_MD2 mechanism for this token */
rv = C_GetMechanismInfo(slotID, CKM_MD2, &info);
if (rv == CKR_OK) {
  if (info.flags & CKF_DIGEST) {
    .
    .
  }
}
~~~

### C_InitToken

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_InitToken)(
    CK_SLOT_ID slotID,
    CK_UTF8CHAR_PTR pPin,
    CK_ULONG ulPinLen,
    CK_UTF8CHAR_PTR pLabel
);
~~~

**C_InitToken** initializes a token. _slotID_ is the ID of the token’s slot;
_pPin_ points to the SO’s initial PIN (which need not be null-terminated);
_ulPinLen_ is the length in bytes of the PIN; _pLabel_ points to the 32-byte
label of the token (which MUST be padded with blank characters, and which MUST
not be null-terminated). This standard allows PIN values to contain any valid
UTF8 character, but the token may impose subset restrictions.

If the token has not been initialized (i.e. new from the factory), then the
_pPin_ parameter becomes the initial value of the SO PIN. If the token is being
reinitialized, the _pPin_ parameter is checked against the existing SO PIN to
authorize the initialization operation. In both cases, the SO PIN is the value
_pPin_ after the function completes successfully. If the SO PIN is lost, then
the card MUST be reinitialized using a mechanism outside the scope of this
standard.  The **CKF_TOKEN_INITIALIZED** flag in the **CK_TOKEN_INFO** structure
indicates the action that will result from calling **C_InitToken**. If set, the
token will be reinitialized, and the client MUST supply the existing SO password
in _pPin_.

When a token is initialized, all objects that can be destroyed are destroyed
(_i.e._, all except for “indestructible” objects such as keys built into the
token). Also, access by the normal user is disabled until the SO sets the normal
user’s PIN. Depending on the token, some “default” objects may be created, and
attributes of some objects may be set to default values.

If the token has a “protected authentication path”, as indicated by the
**CKF_PROTECTED_AUTHENTICATION_PATH** flag in its **CK_TOKEN_INFO** being set,
then that means that there is some way for a user to be authenticated to the
token without having the application send a PIN through the Cryptoki library.
One such possibility is that the user enters a PIN on a PINpad on the token
itself, or on the slot device. To initialize a token with such a protected
authentication path, the _pPin_ parameter to **C_InitToken** should be NULL_PTR.
During the execution of **C_InitToken**, the SO’s PIN will be entered through
the protected authentication path.

If the token has a protected authentication path other than a PINpad, then it is
token-dependent whether or not **C_InitToken** can be used to initialize the
token.

A token cannot be initialized if Cryptoki detects that any application has an
open session with it; when a call to **C_InitToken** is made under such
circumstances, the call fails with error CKR_SESSION_EXISTS. Unfortunately, it
may happen when **C_InitToken** is called that some other application does have
an open session with the token, but Cryptoki cannot detect this, because it
cannot detect anything about other applications using the token. If this is the
case, then the consequences of the **C_InitToken** call are undefined.

The **C_InitToken** function may not be sufficient to properly initialize
complex tokens. In these situations, an initialization mechanism outside the
scope of Cryptoki MUST be employed. The definition of “complex token” is product
specific.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_PIN_INCORRECT, CKR_PIN_LOCKED, CKR_SESSION_EXISTS, CKR_SLOT_ID_INVALID,
CKR_TOKEN_NOT_PRESENT, CKR_TOKEN_NOT_RECOGNIZED, CKR_TOKEN_WRITE_PROTECTED,
CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SLOT_ID slotID;
CK_UTF8CHAR pin[] = {“MyPIN”};
CK_UTF8CHAR label[32];
CK_RV rv;

.
.
memset(label, ‘ ’, sizeof(label));
memcpy(label, “My first token”, strlen(“My first token”));
rv = C_InitToken(slotID, pin, strlen(pin), label);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_InitPIN

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_InitPIN)(
    CK_SESSION_HANDLE hSession,
    CK_UTF8CHAR_PTR pPin,
    CK_ULONG ulPinLen
);
~~~

**C_InitPIN** initializes the normal user’s PIN. _hSession_ is the session’s
handle; _pPin_ points to the normal user’s PIN; ulPinLen is the length in bytes of
the PIN. This standard allows PIN values to contain any valid UTF8 character,
but the token may impose subset restrictions.

**C_InitPIN** can only be called in the “R/W SO Functions” state. An attempt to
call it from a session in any other state fails with error
**CKR_USER_NOT_LOGGED_IN**.

If the token has a “protected authentication path”, as indicated by the
**CKF_PROTECTED_AUTHENTICATION_PATH** flag in its **CK_TOKEN_INFO** being set,
then that means that there is some way for a user to be authenticated to the
token without having to send a PIN through the Cryptoki library. One such
possibility is that the user enters a PIN on a PIN pad on the token itself, or
on the slot device.  To initialize the normal user’s PIN on a token with such a
protected authentication path, the pPin parameter to **C_InitPIN** should be
NULL_PTR.  During the execution of **C_InitPIN**, the SO will enter the new PIN
through the protected authentication path.

If the token has a protected authentication path other than a PIN pad, then it
is token-dependent whether or not **C_InitPIN** can be used to initialize the
normal user’s token access.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_INVALID, CKR_PIN_LEN_RANGE,
CKR_SESSION_CLOSED, CKR_SESSION_READ_ONLY, CKR_SESSION_HANDLE_INVALID,
CKR_TOKEN_WRITE_PROTECTED, CKR_USER_NOT_LOGGED_IN, CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_UTF8CHAR newPin[]= {“NewPIN”};
CK_RV rv;

rv = C_InitPIN(hSession, newPin, sizeof(newPin)-1);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_SetPIN

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SetPIN)(
    CK_SESSION_HANDLE hSession,
    CK_UTF8CHAR_PTR pOldPin,
    CK_ULONG ulOldLen,
    CK_UTF8CHAR_PTR pNewPin,
    CK_ULONG ulNewLen
);
~~~

**C_SetPIN** modifies the PIN of the user that is currently logged in, or the
**CKU_USER** PIN if the session is not logged in. _hSession_ is the session’s
handle; _pOldPin_ points to the old PIN; _ulOldLen_ is the length in bytes of
the old PIN; _pNewPin_ points to the new PIN; _ulNewLen_ is the length in bytes
of the new PIN.  This standard allows PIN values to contain any valid UTF8
character, but the token may impose subset restrictions.

**C_SetPIN** can only be called in the “R/W Public Session” state, “R/W SO
Functions” state, or “R/W User Functions” state. An attempt to call it from a
session in any other state fails with error **CKR_SESSION_READ_ONLY**.

If the token has a “protected authentication path”, as indicated by the
**CKF_PROTECTED_AUTHENTICATION_PATH** flag in its **CK_TOKEN_INFO** being set,
then that means that there is some way for a user to be authenticated to the
token without having to send a PIN through the Cryptoki library. One such
possibility is that the user enters a PIN on a PIN pad on the token itself, or
on the slot device.  To modify the current user’s PIN on a token with such a
protected authentication path, the _pOldPin_ and _pNewPin_ parameters to
**C_SetPIN** should be NULL_PTR.  During the execution of **C_SetPIN**, the
current user will enter the old PIN and the new PIN through the protected
authentication path. It is not specified how the PIN pad should be used to enter
two PINs; this varies.

If the token has a protected authentication path other than a PIN pad, then it
is token-dependent whether or not **C_SetPIN** can be used to modify the current
user’s PIN.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_INCORRECT, CKR_PIN_INVALID,
CKR_PIN_LEN_RANGE, CKR_PIN_LOCKED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY, CKR_TOKEN_WRITE_PROTECTED,
CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_UTF8CHAR oldPin[] = {“OldPIN”};
CK_UTF8CHAR newPin[] = {“NewPIN”};
CK_RV rv;

rv = C_SetPIN(
  hSession, oldPin, sizeof(oldPin)-1, newPin, sizeof(newPin)-1);
if (rv == CKR_OK) {
  .
  .
}
~~~
