## Session management functions

A typical application might perform the following series of steps to make use of
a token (note that there are other reasonable sequences of events that an
application might perform):

1. Select a token.
2. Make one or more calls to **C_OpenSession** to obtain one or more sessions
   with the token.
3. Call **C_Login** to log the user into the token. Since all sessions an
   application has with a token have a shared login state, **C_Login** only
needs to be called for one of the sessions.
4. Perform cryptographic operations using the sessions with the token.
5. Call **C_CloseSession** once for each session that the application has with
   the token, or call **C_CloseAllSessions** to close all the application’s
sessions simultaneously.

As has been observed, an application may have concurrent sessions with more than
one token. It is also possible for a token to have concurrent sessions with more
than one application.

Cryptoki provides the following functions for session management:

### C_OpenSession

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_OpenSession)(
    CK_SLOT_ID slotID,
    CK_FLAGS flags,
    CK_VOID_PTR pApplication,
    CK_NOTIFY Notify,
    CK_SESSION_HANDLE_PTR phSession
);
~~~

**C_OpenSession** opens a session between an application and a token in a
particular slot. _slotID_ is the slot’s ID; _flags_ indicates the type of
session; _pApplication_ is an application-defined pointer to be passed to the
notification callback; _Notify_ is the address of the notification callback
function (see Section 5.21); _phSession_ points to the location that receives
the handle for the new session.

When opening a session with **C_OpenSession**, the _flags_ parameter consists of
the logical OR of zero or more bit flags defined in the **CK_SESSION_INFO** data
type. For legacy reasons, the **CKF_SERIAL_SESSION** bit MUST always be set; if
a call to **C_OpenSession** does not have this bit set, the call should return
unsuccessfully with the error code **CKR_SESSION_PARALLEL_NOT_SUPPORTED**.

There may be a limit on the number of concurrent sessions an application may
have with the token, which may depend on whether the session is “read-only” or
“read/write”. An attempt to open a session which does not succeed because there
are too many existing sessions of some type should return **CKR_SESSION_COUNT**.

If the token is write-protected (as indicated in the **CK_TOKEN_INFO**
structure), then only read-only sessions may be opened with it.

If the application calling **C_OpenSession** already has a R/W SO session open
with the token, then any attempt to open a R/O session with the token fails with
error code **CKR_SESSION_READ_WRITE_SO_EXISTS** (see [PKCS11-UG] for further
details).

The _Notify_ callback function is used by Cryptoki to notify the application of
certain events. If the application does not wish to support callbacks, it should
pass a value of NULL_PTR as the Notify parameter. See Section 5.21 for more
information about application callbacks.

As of version 3.2 an application can request an asynchronous session by
providing the **CKF_ASYNC_SESSION** flag in the _flags_ parameter. If the token
does not support asynchronous operations, it should return
**CKR_SESSION_ASYNC_NOT_SUPPORTED**. Tokens must support synchronous sessions.
Tokens may support asynchronous sessions and may return **CKR_PENDING** if the
token determines that the operation will take a long time to conclude.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_SESSION_ASYNC_NOT_SUPPORTED, CKR_SESSION_COUNT,
CKR_SESSION_PARALLEL_NOT_SUPPORTED, CKR_SESSION_READ_WRITE_SO_EXISTS,
CKR_SLOT_ID_INVALID, CKR_TOKEN_NOT_PRESENT, CKR_TOKEN_NOT_RECOGNIZED,
CKR_TOKEN_WRITE_PROTECTED, CKR_ARGUMENTS_BAD.

Example: see **C_CloseSession**.

### C_CloseSession

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_CloseSession)(
    CK_SESSION_HANDLE hSession
);
~~~

**C_CloseSession** closes a session between an application and a token.
_hSession_ is the session’s handle. 

**C_CloseSession** cancels all pending operations whose ID has not been
retrieved using **C_AsyncGetID**. After a successful call to **C_CloseSession**
the caller should free any memory passed into functions that returned
**CKR_PENDING**.

When a session is closed, all session objects created by the session are
destroyed automatically, even if the application has other sessions “using” the
objects (see [PKCS11-UG] for further details).

If this function is successful and it closes the last session between the
application and the token, the login state of the token for the application
returns to public sessions. Any new sessions to the token opened by the
application will be either R/O Public or R/W Public sessions.

Depending on the token, when the last open session any application has with the
token is closed, the token may be “ejected” from its reader (if this capability
exists).

Despite the fact this **C_CloseSession** is supposed to close a session, the
return value **CKR_SESSION_CLOSED** is an _error_ return. It actually indicates
the (probably somewhat unlikely) event that while this function call was
executing, another call was made to **C_CloseSession** to close this particular
session, and that call finished executing first. Such uses of sessions are a bad
idea, and Cryptoki makes little promise of what will occur in general if an
application indulges in this sort of behavior.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
CK_SLOT_ID slotID;
CK_BYTE application;
CK_NOTIFY MyNotify;
CK_SESSION_HANDLE hSession;
CK_RV rv;

.
.
application = 17;
MyNotify = &EncryptionSessionCallback;
rv = C_OpenSession(
  slotID, CKF_SERIAL_SESSION | CKF_RW_SESSION,
		(CK_VOID_PTR) &application, MyNotify,
  &hSession);
if (rv == CKR_OK) {
  .
  .
  C_CloseSession(hSession);
}
~~~

### C_CloseAllSessions

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_CloseAllSessions)(
    CK_SLOT_ID slotID
);
~~~

**C_CloseAllSessions** closes all sessions an application has with a token.
_slotID_ specifies the token’s slot.

**C_CloseAllSessions** cancels all pending operations whose ID has not been
retrieved using **C_AsyncGetID**. After a successful call to
**C_CloseAllSessions** the caller should free any memory passed into functions
that returned **CKR_PENDING**.

When a session is closed, all session objects created by the session are
destroyed automatically.

After successful execution of this function, the login state of the token for
the application returns to public sessions. Any new sessions to the token opened
by the application will be either R/O Public or R/W Public sessions.

Depending on the token, when the last open session any application has with the
token is closed, the token may be “ejected” from its reader (if this capability
exists).

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_SLOT_ID_INVALID, CKR_TOKEN_NOT_PRESENT.

Example:

~~~{.c}
CK_SLOT_ID slotID;
CK_RV rv;

.
.
rv = C_CloseAllSessions(slotID);
~~~

### C_GetSessionInfo

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetSessionInfo)(
    CK_SESSION_HANDLE hSession,
    CK_SESSION_INFO_PTR pInfo
);
~~~

**C_GetSessionInfo** obtains information about a session. _hSession_ is the
session’s handle; _pInfo_ points to the location that receives the session
information.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_SESSION_INFO info;
CK_RV rv;

.
.
rv = C_GetSessionInfo(hSession, &info);
if (rv == CKR_OK) {
  if (info.state == CKS_RW_USER_FUNCTIONS) {
    .
    .
  }
  .
  .
}
~~~

### C_SessionCancel

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SessionCancel)(
    CK_SESSION_HANDLE hSession 
    CK_FLAGS flags 
);
~~~

**C_SessionCancel** terminates active session based operations. _hSession_ is
the session’s handle; _flags_ indicates the operations to cancel.

To identify which operation(s) should be terminated, the flags parameter should
be assigned the logical bitwise OR of one or more of the bit flags defined in
the CK_MECHANISM_INFO structure. **C_SessionCancel** will cancel a pending
operation matching the input flags including those whose ID has been retrieved
using **C_AsyncGetID**.

If no flags are set, the session state will not be modified and **CKR_OK** will
be returned.

If a flag is set for an operation that has not been initialized in the session,
the operation flag will be ignored and **C_SessionCancel** will behave as if the
operation flag was not set.

If any of the operations indicated by the _flags_ parameter cannot be cancelled,
**CKR_OPERATION_CANCEL_FAILED** must be returned. If multiple operation flags
were set and **CKR_OPERATION_CANCEL_FAILED** is returned, this function does not
provide any information about which operation(s) could not be cancelled. If an
application desires to know if any single operation could not be cancelled, the
application should not call **C_SessionCancel** with multiple flags set.

If **C_SessionCancel** is called from an application callback (see Section
5.21), no action will be taken by the library and **CKR_FUNCTION_FAILED** must
be returned. 

If **C_SessionCancel** is used to cancel one half of a dual-function operation,
the remaining operation should still be left in an active state. However, it is
expected that some Cryptoki implementations may not support this and return
**CKR_OPERATION_CANCEL_FAILED** unless flags for both operations are provided. 

After a successful call to **C_SessionCancel** the caller should free any memory
passed into functions that returned **CKR_PENDING** and were canceled.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_CANCEL_FAILED,
CKR_PENDING, CKR_TOKEN_NOT_PRESENT.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_RV rv;

rv = C_EncryptInit(hSession, &mechanism, hKey);
if (rv != CKR_OK)
{
   .
   .
}

rv = C_SessionCancel (hSession, CKF_ENCRYPT);
if (rv != CKR_OK)
{
   .
   .
}

rv = C_EncryptInit(hSession, &mechanism, hKey);
if (rv != CKR_OK)
{
   .
   .
}
~~~

Below are modifications to existing API descriptions to allow an alternate
method of cancelling individual operations. The additional text is highlighted.

### C_GetOperationState

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetOperationState)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pOperationState,
    CK_ULONG_PTR pulOperationStateLen
);
~~~

**C_GetOperationState** obtains a copy of the cryptographic operations state of
a session, encoded as a string of bytes. _hSession_ is the session’s handle;
_pOperationState_ points to the location that receives the state;
_pulOperationStateLen_ points to the location that receives the length in bytes
of the state.

Although the saved state output by **C_GetOperationState** is not really
produced by a “cryptographic mechanism”, **C_GetOperationState** nonetheless
uses the convention described in Section 5.2 on producing output.

Precisely what the “cryptographic operations state” this function saves is
varies from token to token; however, this state is what is provided as input to
**C_SetOperationState** to restore the cryptographic activities of a session.

Consider a session which is performing a message digest operation using SHA-1
(_i.e._, the session is using the **CKM_SHA_1** mechanism). Suppose that the
message digest operation was initialized properly, and that precisely 80 bytes
of data have been supplied so far as input to SHA-1. The application now wants
to “save the state” of this digest operation, so that it can continue it later.
In this particular case, since SHA-1 processes 512 bits (64 bytes) of input at a
time, the cryptographic operations state of the session most likely consists of
three distinct parts: the state of SHA-1’s 160-bit internal chaining variable;
the 16 bytes of unprocessed input data; and some administrative data indicating
that this saved state comes from a session which was performing SHA-1 hashing.
Taken together, these three pieces of information suffice to continue the
current hashing operation at a later time.

Consider next a session which is performing an encryption operation with DES (a
block cipher with a block size of 64 bits) in CBC (cipher-block chaining) mode
(i.e., the session is using the **CKM_DES_CBC** mechanism). Suppose that
precisely 22 bytes of data (in addition to an IV for the CBC mode) have been
supplied so far as input to DES, which means that the first two 8-byte blocks of
ciphertext have already been produced and output. In this case, the
cryptographic operations state of the session most likely consists of three or
four distinct parts: the second 8-byte block of ciphertext (this will be used
for cipher-block chaining to produce the next block of ciphertext); the 6 bytes
of data still awaiting encryption; some administrative data indicating that this
saved state comes from a session which was performing DES encryption in CBC
mode; and possibly the DES key being used for encryption (see
**C_SetOperationState** for more information on whether or not the key is
present in the saved state).

If a session is performing two cryptographic operations simultaneously (see
Section 5.14), then the cryptographic operations state of the session will
contain all the necessary information to restore both operations.

An attempt to save the cryptographic operations state of a session which does
not currently have some active savable cryptographic operation(s) (encryption,
decryption, digesting, signing without message recovery, verification without
message recovery, or some legal combination of two of these) should fail with
the error **CKR_OPERATION_NOT_INITIALIZED**.

An attempt to save the cryptographic operations state of a session which is
performing an appropriate cryptographic operation (or two), but which cannot be
satisfied for any of various reasons (certain necessary state information and/or
key information can’t leave the token, for example) should fail with the error
**CKR_STATE_UNSAVEABLE**.

Return values: CKR_BUFFER_TOO_SMALL, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_STATE_UNSAVEABLE, CKR_ARGUMENTS_BAD.

Example: see **C_SetOperationState**.

### C_SetOperationState

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SetOperationState)(
    CK_SESSION_HANDLE hSession,
    CK_BYTE_PTR pOperationState,
    CK_ULONG ulOperationStateLen,
    CK_OBJECT_HANDLE hEncryptionKey,
    CK_OBJECT_HANDLE hAuthenticationKey
);
~~~

**C_SetOperationState** restores the cryptographic operations state of a session
from a string of bytes obtained with **C_GetOperationState**. _hSession_ is the
session’s handle; _pOperationState_ points to the location holding the saved
state; _ulOperationStateLen_ holds the length of the saved state;
_hEncryptionKey_ holds a handle to the key which will be used for an ongoing
encryption or decryption operation in the restored session (or 0 if no
encryption or decryption key is needed, either because no such operation is
ongoing in the stored session or because all the necessary key information is
present in the saved state); _hAuthenticationKey_ holds a handle to the key
which will be used for an ongoing signature, MACing, or verification operation
in the restored session (or 0 if no such key is needed, either because no such
operation is ongoing in the stored session or because all the necessary key
information is present in the saved state).

The state need not have been obtained from the same session (the “source
session”) as it is being restored to (the “destination session”). However, the
source session and destination session should have a common session state
(_e.g._, **CKS_RW_USER_FUNCTIONS**), and should be with a common token. There is
also no guarantee that cryptographic operations state may be carried across
logins, or across different Cryptoki implementations.

If **C_SetOperationState** is supplied with alleged saved cryptographic
operations state which it can determine is not valid saved state (or is
cryptographic operations state from a session with a different session state, or
is cryptographic operations state from a different token), it fails with the
error **CKR_SAVED_STATE_INVALID**.

Saved state obtained from calls to **C_GetOperationState** may or may not
contain information about keys in use for ongoing cryptographic operations. If a
saved cryptographic operations state has an ongoing encryption or decryption
operation, and the key in use for the operation is not saved in the state, then
it MUST be supplied to **C_SetOperationState** in the _hEncryptionKey_ argument.
If it is not, then **C_SetOperationState** will fail and return the error
**CKR_KEY_NEEDED**. If the key in use for the operation is saved in the state,
then it can be supplied in the _hEncryptionKey_ argument, but this is not
required.

Similarly, if a saved cryptographic operations state has an ongoing signature,
MACing, or verification operation, and the key in use for the operation is not
saved in the state, then it MUST be supplied to **C_SetOperationState** in the
hAuthenticationKey argument. If it is not, then **C_SetOperationState** will
fail with the error **CKR_KEY_NEEDED**. If the key in use for the operation is
saved in the state, then it can be supplied in the hAuthenticationKey argument,
but this is not required.

If an irrelevant key is supplied to **C_SetOperationState** call (_e.g._, a
nonzero key handle is submitted in the _hEncryptionKey_ argument, but the saved
cryptographic operations state supplied does not have an ongoing encryption or
decryption operation, then **C_SetOperationState** fails with the error
**CKR_KEY_NOT_NEEDED**.

If a key is supplied as an argument to **C_SetOperationState**, and
**C_SetOperationState** can somehow detect that this key was not the key being
used in the source session for the supplied cryptographic operations state (it
may be able to detect this if the key or a hash of the key is present in the
saved state, for example), then **C_SetOperationState** fails with the error
**CKR_KEY_CHANGED**.

An application can look at the **CKF_RESTORE_KEY_NOT_NEEDED** flag in the flags
field of the **CK_TOKEN_INFO** field for a token to determine whether or not it
needs to supply key handles to **C_SetOperationState** calls. If this flag is
true, then a call to **C_SetOperationState** never needs a key handle to be
supplied to it. If this flag is false, then at least some of the time,
**C_SetOperationState** requires a key handle, and so the application should
probably always pass in any relevant key handles when restoring cryptographic
operations state to a session.

**C_SetOperationState** can successfully restore cryptographic operations state
to a session even if that session has active cryptographic or object search
operations when **C_SetOperationState** is called (the ongoing operations are
abruptly cancelled).

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_KEY_CHANGED, CKR_KEY_NEEDED, CKR_KEY_NOT_NEEDED, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SAVED_STATE_INVALID, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_ARGUMENTS_BAD.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_MECHANISM digestMechanism;
CK_BYTE_PTR pState;
CK_ULONG ulStateLen;
CK_BYTE data1[] = {0x01, 0x03, 0x05, 0x07};
CK_BYTE data2[] = {0x02, 0x04, 0x08};
CK_BYTE data3[] = {0x10, 0x0F, 0x0E, 0x0D, 0x0C};
CK_BYTE pDigest[20];
CK_ULONG ulDigestLen;
CK_RV rv;

.
.
/* Initialize hash operation */
rv = C_DigestInit(hSession, &digestMechanism);
assert(rv == CKR_OK);

/* Start hashing */
rv = C_DigestUpdate(hSession, data1, sizeof(data1));
assert(rv == CKR_OK);

/* Find out how big the state might be */
rv = C_GetOperationState(hSession, NULL_PTR, &ulStateLen);
assert(rv == CKR_OK);

/* Allocate some memory and then get the state */
pState = (CK_BYTE_PTR) malloc(ulStateLen);
rv = C_GetOperationState(hSession, pState, &ulStateLen);

/* Continue hashing */
rv = C_DigestUpdate(hSession, data2, sizeof(data2));
assert(rv == CKR_OK);

/* Restore state. No key handles needed */
rv = C_SetOperationState(hSession, pState, ulStateLen, 0, 0);
assert(rv == CKR_OK);

/* Continue hashing from where we saved state */
rv = C_DigestUpdate(hSession, data3, sizeof(data3));
assert(rv == CKR_OK);

/* Conclude hashing operation */
ulDigestLen = sizeof(pDigest);
rv = C_DigestFinal(hSession, pDigest, &ulDigestLen);
if (rv == CKR_OK) {
  /* pDigest[] now contains the hash of 0x01030507100F0E0D0C */
  .
  .
}
~~~

### C_Login

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Login)(
    CK_SESSION_HANDLE hSession,
    CK_USER_TYPE userType,
    CK_UTF8CHAR_PTR pPin,
    CK_ULONG ulPinLen
);
~~~

**C_Login** logs a user into a token. _hSession_ is a session handle; _userType_
is the user type; _pPin_ points to the user’s PIN; _ulPinLen_ is the length of
the PIN.  This standard allows PIN values to contain any valid UTF8 character,
but the token may impose subset restrictions.

When the user type is either **CKU_SO** or **CKU_USER**, if the call succeeds,
each of the application's sessions will enter either the "R/W SO Functions"
state, the "R/W User Functions" state, or the "R/O User Functions" state. If the
user type is **CKU_CONTEXT_SPECIFIC**, the behavior of **C_Login** depends on
the context in which it is called. Improper use of this user type will result in
a return value **CKR_OPERATION_NOT_INITIALIZED**.

If the token has a “protected authentication path”, as indicated by the
**CKF_PROTECTED_AUTHENTICATION_PATH** flag in its **CK_TOKEN_INFO** being set,
then that means that there is some way for a user to be authenticated to the
token without having to send a PIN through the Cryptoki library. One such
possibility is that the user enters a PIN on a PIN pad on the token itself, or
on the slot device.  Or the user might not even use a PIN—authentication could
be achieved by some fingerprint-reading device, for example. To log into a token
with a protected authentication path, the _pPin_ parameter to **C_Login** should
be NULL_PTR. When **C_Login** returns, whatever authentication method supported
by the token will have been performed; a return value of **CKR_OK** means that
the user was successfully authenticated, and a return value of
**CKR_PIN_INCORRECT** means that the user was denied access.

If there are any active cryptographic or object finding operations in an
application’s session, and then **C_Login** is successfully executed by that
application, it may or may not be the case that those operations are still
active. Therefore, before logging in, any active operations should be finished.

If the application calling **C_Login** has a R/O session open with the token,
then it will be unable to log the SO into a session (see [PKCS11-UG] for further
details). An attempt to do this will result in the error code
**CKR_SESSION_READ_ONLY_EXISTS**.

**C_Login** may be called repeatedly, without intervening **C_Logout** calls, if
(and only if) a key with the **CKA_ALWAYS_AUTHENTICATE** attribute set to
CK_TRUE exists, and the user needs to do cryptographic operation on this key.
See further Section 4.10.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_PIN_INCORRECT, CKR_PIN_LOCKED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY_EXISTS,
CKR_USER_ALREADY_LOGGED_IN, CKR_USER_ANOTHER_ALREADY_LOGGED_IN,
CKR_USER_PIN_NOT_INITIALIZED, CKR_USER_TOO_MANY_TYPES, CKR_USER_TYPE_INVALID.

Example: see **C_Logout**.

### C_LoginUser

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_LoginUser)(
    CK_SESSION_HANDLE hSession,
    CK_USER_TYPE userType,
    CK_UTF8CHAR_PTR pPin,
    CK_ULONG ulPinLen,
    CK_UTF8CHAR_PTR pUsername,
    CK_ULONG ulUsernameLen
);
~~~

**C_LoginUser** logs a user into a token. _hSession_ is a session handle;
_userType_ is the user type; _pPin_ points to the user’s PIN; _ulPinLen_ is the
length of the PIN, _pUsername_ points to the user name, _ulUsernameLen_ is the
length of the user name. This standard allows PIN and user name values to
contain any valid UTF8 character, but the token may impose subset restrictions. 

When the user type is either **CKU_SO** or **CKU_USER**, if the call succeeds,
each of the application's sessions will enter either the "R/W SO Functions"
state, the "R/W User Functions" state, or the "R/O User Functions" state. If the
user type is **CKU_CONTEXT_SPECIFIC**, the behavior of **C_LoginUser** depends
on the context in which it is called. Improper use of this user type will result
in a return value **CKR_OPERATION_NOT_INITIALIZED**. 

If the token has a “protected authentication path”, as indicated by the
**CKF_PROTECTED_AUTHENTICATION_PATH** flag in its **CK_TOKEN_INFO** being set,
then that means that there is some way for a user to be authenticated to the
token without having to send a PIN through the Cryptoki library. One such
possibility is that the user enters a PIN on a PIN pad on the token itself, or
on the slot device.  The user might not even use a PIN—authentication could be
achieved by some fingerprint-reading device, for example. To log into a token
with a protected authentication path, the _pPin_ parameter to **C_LoginUser**
should be NULL_PTR.  When **C_LoginUser** returns, whatever authentication
method supported by the token will have been performed; a return value of
**CKR_OK** means that the user was successfully authenticated, and a return
value of **CKR_PIN_INCORRECT** means that the user was denied access. 

If there are any active cryptographic or object finding operations in an
application’s session, and then **C_LoginUser** is successfully executed by that
application, it may or may not be the case that those operations are still
active. Therefore, before logging in, any active operations should be finished. 

If the application calling **C_LoginUser** has a R/O session open with the
token, then it will be unable to log the SO into a session (see [PKCS11-UG] for
further details). An attempt to do this will result in the error code
**CKR_SESSION_READ_ONLY_EXISTS**. 

**C_LoginUser** may be called repeatedly, without intervening **C_Logout**
calls, if (and only if) a key with the **CKA_ALWAYS_AUTHENTICATE** attribute set
to CK_TRUE exists, and the user needs to do cryptographic operation on this key.
See further Section 4.10. 

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_CANCELED,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING,
CKR_PIN_INCORRECT, CKR_PIN_LOCKED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY_EXISTS,
CKR_USER_ALREADY_LOGGED_IN, CKR_USER_ANOTHER_ALREADY_LOGGED_IN,
CKR_USER_PIN_NOT_INITIALIZED, CKR_USER_TOO_MANY_TYPES, CKR_USER_TYPE_INVALID. 

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_UTF8CHAR userPin[] = {“MyPIN”};
CK_UTF8CHAR userName[] = {“MyUserName”};
CK_RV rv;

rv = C_LoginUser(hSession, CKU_USER, userPin, sizeof(userPin)-1, userName,
sizeof(userName)-1);
if (rv == CKR_OK) {
  .
  .
  rv = C_Logout(hSession);
  if (rv == CKR_OK) {
    .
    .
  }
}
~~~

### C_Logout

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Logout)(
    CK_SESSION_HANDLE hSession
);
~~~

**C_Logout** logs a user out from a token. _hSession_ is the session’s handle.
Depending on the current user type, if the call succeeds, each of the
application’s sessions will enter either the “R/W Public Session” state or the
“R/O Public Session” state.

When **C_Logout** successfully executes, any of the application’s handles to
private objects become invalid (even if a user is later logged back into the
token, those handles remain invalid). In addition, all private session objects
from sessions belonging to the application are destroyed.

If there are any active cryptographic or object-finding operations in an
application’s session, and then **C_Logout** is successfully executed by that
application, it may or may not be the case that those operations are still
active. Therefore, before logging out, any active operations should be finished.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_UTF8CHAR userPin[] = {“MyPIN”};
CK_RV rv;

rv = C_Login(hSession, CKU_USER, userPin, sizeof(userPin)-1);
if (rv == CKR_OK) {
  .
  .
  rv = C_Logout(hSession);
  if (rv == CKR_OK) {
    .
    .
  }
}
~~~
     
### C_GetSessionValidationFlags

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetSessionValidationFlags)(
    CK_SESSION_HANDLE hSession,
    CK_SESSION_VALIDATION_FLAGS_TYPE type,
    CK_FLAGS_PTR pFlags,
);
~~~

**C_GetSessionValidationFlags** fetches the requested flags from the session.
See Validation indicators (section 4.15.3.1) for meaning and semantics for these
flags. Applications are responsible for the appropriate locking to protect
session to get a meaningful result from this call.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.
