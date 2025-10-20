## Function return values

The Cryptoki interface possesses a large number of functions and return values.
In Section 5.1, we enumerate the various possible return values for Cryptoki
functions; most of the remainder of Section 5.1 details the behavior of Cryptoki
functions, including what values each of them may return.

Because of the complexity of the Cryptoki specification, it is recommended that
Cryptoki applications attempt to give some leeway when interpreting Cryptoki
functions’ return values. We have attempted to specify the behavior of Cryptoki
functions as completely as was feasible; nevertheless, there are presumably some
gaps. For example, it is possible that a particular error code which might apply
to a particular Cryptoki function is unfortunately not actually listed in the
description of that function as a possible error code. It is conceivable that
the developer of a Cryptoki library might nevertheless permit his/her
implementation of that function to return that error code. It would clearly be
somewhat ungraceful if a Cryptoki application using that library were to
terminate by abruptly dumping core upon receiving that error code for that
function. It would be far preferable for the application to examine the
function’s return value, see that it indicates some sort of error (even if the
application doesn’t know precisely what kind of error), and behave accordingly.

See Section 5.1.8 for some specific details on how a developer might attempt to
make an application that accommodates a range of behaviors from Cryptoki
libraries.

### Universal Cryptoki function return values

Any Cryptoki function can return any of the following values:

* CKR_GENERAL_ERROR: Some horrible, unrecoverable error has occurred. In the
  worst case, it is possible that the function only partially succeeded, and
  that the computer and/or token is in an inconsistent state.

* CKR_HOST_MEMORY: The computer that the Cryptoki library is running on has
  insufficient memory to perform the requested function.

* CKR_FUNCTION_FAILED: The requested function could not be performed, but
  detailed information about why not is not available in this error return. If
  the failed function uses a session, it is possible that the
  **CK_SESSION_INFO** structure that can be obtained by calling
  **C_GetSessionInfo** will hold useful information about what happened in its
  _ulDeviceError_ field. In any event, although the function call failed, the
  situation is not necessarily totally hopeless, as it is likely to be when
  CKR_GENERAL_ERROR is returned. Depending on what the root cause of the error
  actually was, it is possible that an attempt to make the exact same function
  call again would succeed.

* CKR_OPERATION_NOT_VALIDATED: The requested operation violates one or more of
  the token’s validation policies. Tokens may choose to return a more specific
  error (like CKR_ATTRIBUTE_VALUE_INVALID or CKR_DATA_LEN_RANGE).

* CKR_OK: The function executed successfully. Technically, CKR_OK is not quite a
  “universal” return value; in particular, the legacy functions
  **C_GetFunctionStatus** and **C_CancelFunction** (see Section 5.20) cannot
  return CKR_OK.

The relative priorities of these errors are in the order listed above, e.g., if
either of CKR_GENERAL_ERROR or CKR_HOST_MEMORY would be an appropriate error
return, then CKR_GENERAL_ERROR should be returned.

### Cryptoki function return values for functions that use a session handle

Any Cryptoki function that takes a session handle as one of its arguments (i.e.,
any Cryptoki function except for **C_Initialize**, **C_Finalize**,
**C_GetInfo**, **C_GetFunctionList**, **C_GetSlotList**, **C_GetSlotInfo**,
**C_GetTokenInfo**, **C_WaitForSlotEvent**, **C_GetMechanismList**,
**C_GetMechanismInfo**, **C_InitToken**, **C_OpenSession**, and
**C_CloseAllSessions**) can return the following values:

* CKR_SESSION_HANDLE_INVALID: The specified session handle was invalid at the
  time that the function was invoked. Note that this can happen if the session’s
  token is removed before the function invocation, since removing a token closes
  all sessions with it.

* CKR_DEVICE_REMOVED: The token was removed from its slot during the execution
  of the function.

* CKR_SESSION_CLOSED: The session was closed during the execution of the
  function.  Note that, as stated in [PKCS11-UG], the behavior of Cryptoki is
  undefined if multiple threads of an application attempt to access a common
  Cryptoki session simultaneously. Therefore, there is actually no guarantee
  that a function invocation could ever return the value CKR_SESSION_CLOSED.
  An example of multiple threads accessing a common session simultaneously is
  where one thread is using a session when another thread closes that same
  session.

The relative priorities of these errors are in the order listed above, e.g., if
either of CKR_SESSION_HANDLE_INVALID or CKR_DEVICE_REMOVED would be an
appropriate error return, then CKR_SESSION_HANDLE_INVALID should be returned.

In practice, it is often not crucial (or possible) for a Cryptoki library to be
able to make a distinction between a token being removed before a function
invocation and a token being removed _during_ a function execution.

### Cryptoki function return values for functions that use a token

Any Cryptoki function that uses a particular token (i.e., any Cryptoki function
except for **C_Initialize**, **C_Finalize**, **C_GetInfo**,
**C_GetFunctionList**, **C_GetSlotList**, **C_GetSlotInfo**, or
**C_WaitForSlotEvent**) can return any of the following values:

* CKR_DEVICE_MEMORY: The token does not have sufficient memory to perform the
  requested function.

* CKR_DEVICE_ERROR: Some problem has occurred with the token and/or slot. This
  error code can be returned by more than just the functions mentioned above; in
  particular, it is possible for **C_GetSlotInfo** to return CKR_DEVICE_ERROR.

* CKR_TOKEN_NOT_PRESENT: The token was not present in its slot at the time that
  the function was invoked.

* CKR_DEVICE_REMOVED: The token was removed from its slot during the execution
  of the function.

* CKR_TOKEN_NOT_INITIALIZED: The token is in factory state and C_InitToken (or
  an out of band initialization method) needs to be called before any other
  token related operations can be completed.

The relative priorities of these errors are in the order listed above, e.g., if
either of CKR_DEVICE_MEMORY or CKR_DEVICE_ERROR would be an appropriate error
return, then CKR_DEVICE_MEMORY should be returned.

In practice, it is often not critical (or possible) for a Cryptoki library to be
able to make a distinction between a token being removed before a function
invocation and a token being removed _during_ a function execution.

### Special return value for application-supplied callbacks

There is a special-purpose return value which is not returned by any function in
the actual Cryptoki API, but which may be returned by an application-supplied
callback function. It is:

* CKR_CANCEL: When a function executing in serial with an application decides to
  give the application a chance to do some work, it calls an
  application-supplied function with a **CKN_SURRENDER** callback (see Section
  5.21). If the callback returns the value CKR_CANCEL, then the function aborts
  and returns CKR_FUNCTION_CANCELED.

### Special return values for mutex-handling functions

There are two other special-purpose return values which are not returned by any
actual Cryptoki functions. These values may be returned by application-supplied
mutex-handling functions, and they may safely be ignored by application
developers who are not using their own threading model. They are:

* CKR_MUTEX_BAD: This error code can be returned by mutex-handling functions
  that are passed a bad mutex object as an argument. Unfortunately, it is
  possible for such a function not to recognize a bad mutex object. There is
  therefore no guarantee that such a function will successfully detect bad
  mutex objects and return this value.

* CKR_MUTEX_NOT_LOCKED: This error code can be returned by mutex-unlocking
  functions. It indicates that the mutex supplied to the mutex-unlocking
  function was not locked.

### All other Cryptoki function return values

Descriptions of the other Cryptoki function return values follow.
Except as mentioned in the descriptions of particular error codes, there are in
general no particular priorities among the errors listed below, i.e., if more
than one error code might apply to an execution of a function, then the function
may return any applicable error code.

* CKR_ACTION_PROHIBITED: This value can only be returned by **C_CopyObject**,,
  **C_SetAttributeValue**, and **C_DestroyObject**,. It denotes that the action
  may not be taken, either because of underlying policy restrictions on the
  token, or because the object has the relevant **CKA_COPYABLE**,
  **CKA_MODIFIABLE** or **CKA_DESTROYABLE** policy attribute set to CK_FALSE.

* CKR_ARGUMENTS_BAD: This is a rather generic error code which indicates that
  the arguments supplied to the Cryptoki function were in some way not
  appropriate.

* CKR_ATTRIBUTE_READ_ONLY: An attempt was made to set a value for an attribute
  which may not be set by the application, or which may not be modified by the
  application. See Section 4.1 for more information.

* CKR_ATTRIBUTE_SENSITIVE: An attempt was made to obtain the value of an
  attribute of an object which cannot be satisfied because the object is either
  sensitive or un-extractable.

* CKR_ATTRIBUTE_TYPE_INVALID: An invalid attribute type was specified in a
  template. See Section 4.1 for more information.

* CKR_ATTRIBUTE_VALUE_INVALID: An invalid value was specified for a particular
  attribute in a template. See Section 4.1 for more information.

* CKR_BUFFER_TOO_SMALL: The output of the function is too large to fit in the
  supplied buffer.

* CKR_CANT_LOCK: This value can only be returned by **C_Initialize**. It means
  that the type of locking requested by the application for thread-safety is not
  available in this library, and so the application cannot make use of this
  library in the specified fashion.

* CKR_CRYPTOKI_ALREADY_INITIALIZED: This value can only be returned by
  **C_Initialize**. It means that the Cryptoki library has already been
  initialized (by a previous call to **C_Initialize** which did not have a
  matching **C_Finalize** call).

* CKR_CRYPTOKI_NOT_INITIALIZED: This value can be returned by any function other
  than **C_Initialize**,  **C_GetFunctionList**, **C_GetInterfaceList** and
  **C_GetInterface**. It indicates that the function cannot be executed because
  the Cryptoki library has not yet been initialized by a call to
  **C_Initialize**.

* CKR_CURVE_NOT_SUPPORTED: This curve is not supported by this token. Used with
  Elliptic Curve mechanisms.

* CKR_DATA_INVALID: The plaintext input data to a cryptographic operation is
  invalid. This return value has lower priority than CKR_DATA_LEN_RANGE.

* CKR_DATA_LEN_RANGE: The plaintext input data to a cryptographic operation has
  a bad length. Depending on the operation’s mechanism, this could mean that the
  plaintext data is too short, too long, or is not a multiple of some particular
  block size. This return value has higher priority than CKR_DATA_INVALID.

* CKR_DOMAIN_PARAMS_INVALID: Invalid or unsupported domain parameters were
  supplied to the function. Which representation methods of domain parameters
  are supported by a given mechanism can vary from token to token.

* CKR_ENCRYPTED_DATA_INVALID: The encrypted input to a decryption operation has
  been determined to be invalid ciphertext. This return value has lower priority
  than CKR_ENCRYPTED_DATA_LEN_RANGE.

* CKR_ENCRYPTED_DATA_LEN_RANGE: The ciphertext input to a decryption operation
  has been determined to be invalid ciphertext solely on the basis of its
  length.  Depending on the operation’s mechanism, this could mean that the
  ciphertext is too short, too long, or is not a multiple of some particular
  block size. This return value has higher priority than
  CKR_ENCRYPTED_DATA_INVALID.

* CKR_EXCEEDED_MAX_ITERATIONS: An iterative algorithm (for key pair generation,
  domain parameter generation etc.) failed because we have exceeded the maximum
  number of iterations. This error code has precedence over
  CKR_FUNCTION_FAILED.  Examples of iterative algorithms include DSA signature
  generation (retry if either r = 0 or s = 0) and generation of DSA primes p
  and q specified in [FIPS PUB 186-4].

* CKR_FIPS_SELF_TEST_FAILED: A FIPS 140-2 power-up self-test or conditional
  self-test failed. The token entered an error state. Future calls to
  cryptographic functions on the token will return CKR_GENERAL_ERROR.
  CKR_FIPS_SELF_TEST_FAILED has a higher precedence over CKR_GENERAL_ERROR.
  This error may be returned by **C_Initialize**, if a power-up self-test
  failed, by **C_GenerateRandom** or **C_SeedRandom**, if the continuous random
  number generator test failed, or by **C_GenerateKeyPair**, if the pair-wise
  consistency test failed.

* CKR_FUNCTION_CANCELED: The function was canceled in mid-execution. This
  happens to a cryptographic function if the function makes a **CKN_SURRENDER**
  application callback which returns CKR_CANCEL (see CKR_CANCEL). It also
  happens to a function that performs PIN entry through a protected path. The
  method used to cancel a protected path PIN entry operation is device
  dependent.

* CKR_FUNCTION_NOT_PARALLEL: There is currently no function executing in
  parallel in the specified session. This is a legacy error code which is only
  returned by the legacy functions **C_GetFunctionStatus** and
  **C_CancelFunction**.

* CKR_FUNCTION_NOT_SUPPORTED: The requested function is not supported by this
  Cryptoki library. Even unsupported functions in the Cryptoki API should have a
  “stub” in the library; this stub should simply return the value
  CKR_FUNCTION_NOT_SUPPORTED.

* CKR_FUNCTION_REJECTED: The signature request is rejected by the user.

* CKR_INFORMATION_SENSITIVE: The information requested could not be obtained
  because the token considers it sensitive, and is not able or willing to reveal
  it.

* CKR_KEY_CHANGED: This value is only returned by **C_SetOperationState**. It
  indicates that one of the keys specified is not the same key that was being
  used in the original saved session.

* CKR_KEY_FUNCTION_NOT_PERMITTED: An attempt has been made to use a key for a
  cryptographic purpose that the key’s attributes are not set to allow it to do.
  For example, to use a key for performing encryption, that key MUST have its
  **CKA_ENCRYPT** attribute set to CK_TRUE (the fact that the key MUST have a
  **CKA_ENCRYPT** attribute implies that the key cannot be a private key). This
  return value has lower priority than CKR_KEY_TYPE_INCONSISTENT.

* CKR_KEY_HANDLE_INVALID: The specified key handle is not valid. It may be the
  case that the specified handle is a valid handle for an object which is not a
  key. We reiterate here that 0 is never a valid key handle.

* CKR_KEY_INDIGESTIBLE: This error code can only be returned by
  **C_DigestKey**. It indicates that the value of the specified key cannot be
  digested for some reason (perhaps the key isn’t a secret key, or perhaps the
  token simply can’t digest this kind of key).

* CKR_KEY_NEEDED: This value is only returned by **C_SetOperationState**. It
  indicates that the session state cannot be restored because
  **C_SetOperationState** needs to be supplied with one or more keys that were
  being used in the original saved session.

* CKR_KEY_NOT_NEEDED: An extraneous key was supplied to
  **C_SetOperationState**. For example, an attempt was made to restore a
  session that had been performing a message digesting operation, and an
  encryption key was supplied.

* CKR_KEY_NOT_WRAPPABLE: Although the specified private or secret key does not
  have its **CKA_EXTRACTABLE** attribute set to CK_FALSE, Cryptoki (or the
  token) is unable to wrap the key as requested (possibly the token can only
  wrap a given key with certain types of keys, and the wrapping key specified is
  not one of these types). Compare with CKR_KEY_UNEXTRACTABLE.

* CKR_KEY_SIZE_RANGE: Although the requested keyed cryptographic operation could
  in principle be carried out, this Cryptoki library (or the token) is unable to
  actually do it because the supplied key‘s size is outside the range of key
  sizes that it can handle.

* CKR_KEY_TYPE_INCONSISTENT: The specified key is not the correct type of key to
  use with the specified mechanism. This return value has a higher priority than
  CKR_KEY_FUNCTION_NOT_PERMITTED.

* CKR_KEY_UNEXTRACTABLE: The specified private or secret key can’t be wrapped
  because its **CKA_EXTRACTABLE** attribute is set to CK_FALSE. Compare with
  CKR_KEY_NOT_WRAPPABLE.

* CKR_LIBRARY_LOAD_FAILED: The Cryptoki library could not load a dependent
  shared library.

* CKR_MECHANISM_INVALID: An invalid mechanism was specified to the cryptographic
  operation. This error code is an appropriate return value if an unknown
  mechanism was specified or if the mechanism specified cannot be used in the
  selected token with the selected function.

* CKR_MECHANISM_PARAM_INVALID: Invalid parameters were supplied to the mechanism
  specified to the cryptographic operation. Which parameter values are supported
  by a given mechanism can vary from token to token.

* CKR_NEED_TO_CREATE_THREADS: This value can only be returned by
  **C_Initialize**. It is returned when two conditions hold:
  1. The application called **C_Initialize** in a way which tells the Cryptoki
     library that application threads executing calls to the library cannot use
     native operating system methods to spawn new threads.
  2. The library cannot function properly without being able to spawn new
     threads in the above fashion.

* CKR_NO_EVENT: This value can only be returned by **C_WaitForSlotEvent**. It
  is returned when **C_WaitForSlotEvent** is called in non-blocking mode and
  there are no new slot events to return.

* CKR_OBJECT_HANDLE_INVALID: The specified object handle is not valid. We
  reiterate here that 0 is never a valid object handle.

* CKR_OPERATION_ACTIVE: There is already an active operation (or combination of
  active operations) which prevents Cryptoki from activating the specified
  operation. For example, an active object-searching operation would prevent
  Cryptoki from activating an encryption operation with **C_EncryptInit**. Or,
  an active digesting operation and an active encryption operation would prevent
  Cryptoki from activating a signature operation. Or, on a token which doesn’t
  support simultaneous dual cryptographic operations in a session (see the
  description of the **CKF_DUAL_CRYPTO_OPERATIONS** flag in the
  **CK_TOKEN_INFO** structure), an active signature operation would prevent
  Cryptoki from activating an encryption operation.

* CKR_OPERATION_NOT_INITIALIZED: There is no active operation of an appropriate
  type in the specified session. For example, an application cannot call
  **C_Encrypt** in a session without having called **C_EncryptInit** first to
  activate an encryption operation.

* CKR_PARAMETER_SET_NOT_SUPPORTED: This parameter set is not supported by this
  token. Used with XMSS, XMSSMT, ML-KEM, ML-DSA and SLH-DSA mechanisms.

* CKR_PENDING: This value is returned if the operation is running
  asynchronously.

* CKR_PIN_EXPIRED: The specified PIN has expired, and the requested operation
  cannot be carried out unless **C_SetPIN** is called to change the PIN value.
  Whether or not the normal user’s PIN on a token ever expires varies from token
  to token.

* CKR_PIN_INCORRECT: The specified PIN is incorrect, i.e., does not match the
  PIN stored on the token. More generally-- when authentication to the token
  involves something other than a PIN-- the attempt to authenticate the user
  has failed.

* CKR_PIN_INVALID: The specified PIN has invalid characters in it. This return
  code only applies to functions which attempt to set a PIN.

* CKR_PIN_LEN_RANGE: The specified PIN is too long or too short. This return
  code only applies to functions which attempt to set a PIN.

* CKR_PIN_LOCKED: The specified PIN is “locked”, and cannot be used. That is,
  because some particular number of failed authentication attempts has been
  reached, the token is unwilling to permit further attempts at authentication.
  Depending on the token, the specified PIN may or may not remain locked
  indefinitely.

* CKR_PIN_TOO_WEAK: The specified PIN is too weak so that it could be easy to
  guess. If the PIN is too short, CKR_PIN_LEN_RANGE should be returned instead.
  This return code only applies to functions which attempt to set a PIN.

* CKR_PUBLIC_KEY_INVALID: The public key fails a public key validation. For
  example, an EC public key fails the public key validation specified in
  Section 5.2.2 of [ANSI X9.62]. This error code may be returned by
  **C_CreateObject**, when the public key is created, or by **C_VerifyInit**,
  **C_VerifySignatureInit** or **C_VerifyRecoverInit**, when the public key is
  used. It may also be returned by **C_DeriveKey**, in preference to
  CKR_MECHANISM_PARAM_INVALID, if the other party's public key specified in the
  mechanism's parameters is invalid.

* CKR_RANDOM_NO_RNG: This value can be returned by **C_SeedRandom** and
  **C_GenerateRandom**. It indicates that the specified token doesn’t have a
  random number generator. This return value has higher priority than
  CKR_RANDOM_SEED_NOT_SUPPORTED.

* CKR_RANDOM_SEED_NOT_SUPPORTED: This value can only be returned by
  **C_SeedRandom**. It indicates that the token’s random number generator does
  not accept seeding from an application. This return value has lower priority
  than CKR_RANDOM_NO_RNG.

* CKR_SAVED_STATE_INVALID: This value can only be returned by
  **C_SetOperationState**. It indicates that the supplied saved cryptographic
  operations state is invalid, and so it cannot be restored to the specified
  session.

* CKR_SEED_RANDOM_REQUIRED: This value can only be returned by
  **C_GenerateRandom**. It indicates that the token’s random number generator
  has not yet been seeded, or requires re-seeding, by **C_SeedRandom**.

* CKR_SESSION_ASYN**C_NOT**_SUPPORTED: This value is returned if the token
  doesn’t support async operations.

* CKR_SESSION_COUNT: This value can only be returned by **C_OpenSession**. It
  indicates that the attempt to open a session failed, either because the token
  has too many sessions already open, or because the token has too many
  read/write sessions already open.

* CKR_SESSION_EXISTS: This value can only be returned by **C_InitToken**. It
  indicates that a session with the token is already open, and so the token
  cannot be initialized.

* CKR_SESSION_PARALLEL_NOT_SUPPORTED: The specified token does not support
  parallel sessions. This is a legacy error code—in Cryptoki Version 2.01 and
  up, no token supports parallel sessions. CKR_SESSION_PARALLEL_NOT_SUPPORTED
  can only be returned by **C_OpenSession**, and it is only returned when
  **C_OpenSession** is called in a particular [deprecated] way.

* CKR_SESSION_READ_ONLY: The specified session was unable to accomplish the
  desired action because it is a read-only session. This return value has lower
  priority than CKR_TOKEN_WRITE_PROTECTED.

* CKR_SESSION_READ_ONLY_EXISTS: A read-only session already exists, and so the
  SO cannot be logged in.

* CKR_SESSION_READ_WRITE_SO_EXISTS: A read/write SO session already exists, and
  so a read-only session cannot be opened.

* CKR_SIGNATURE_LEN_RANGE: The provided signature/MAC can be seen to be invalid
  solely on the basis of its length. This return value has higher priority than
  CKR_SIGNATURE_INVALID.

* CKR_SIGNATURE_INVALID: The provided signature/MAC is invalid. This return
  value has lower priority than CKR_SIGNATURE_LEN_RANGE.

* CKR_SLOT_ID_INVALID: The specified slot ID is not valid.

* CKR_STATE_UNSAVEABLE: The cryptographic operations state of the specified
  session cannot be saved for some reason (possibly the token is simply unable
  to save the current state). This return value has lower priority than
  CKR_OPERATION_NOT_INITIALIZED.

* CKR_TEMPLATE_INCOMPLETE: The template specified for creating an object is
  incomplete, and lacks some necessary attributes. See Section 4.1 for more
  information.

* CKR_TEMPLATE_INCONSISTENT: The template specified for creating an object has
  conflicting attributes. See Section 4.1 for more information.

* CKR_TOKEN_NOT_RECOGNIZED: The Cryptoki library and/or slot does not recognize
  the token in the slot.

* CKR_TOKEN_WRITE_PROTECTED: The requested action could not be performed because
  the token is write-protected. This return value has higher priority than
  CKR_SESSION_READ_ONLY.

* CKR_UNWRAPPING_KEY_HANDLE_INVALID: This value can only be returned by
  **C_UnwrapKey**. It indicates that the key handle specified to be used to
  unwrap another key is not valid.

* CKR_UNWRAPPING_KEY_SIZE_RANGE: This value can only be returned by
  **C_UnwrapKey**. It indicates that although the requested unwrapping
  operation could in principle be carried out, this Cryptoki library (or the
  token) is unable to actually do it because the supplied key’s size is outside
  the range of key sizes that it can handle.

* CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT: This value can only be returned by
  **C_UnwrapKey**. It indicates that the type of the key specified to unwrap
  another key is not consistent with the mechanism specified for unwrapping.

* CKR_USER_ALREADY_LOGGED_IN: This value can only be returned by **C_Login**. It
  indicates that the specified user cannot be logged into the session, because
  it is already logged into the session. For example, if an application has an
  open SO session, and it attempts to log the SO into it, it will receive this
  error code.

* CKR_USER_ANOTHER_ALREADY_LOGGED_IN: This value can only be returned by
  **C_Login**. It indicates that the specified user cannot be logged into the
  session, because another user is already logged into the session. For
  example, if an application has an open SO session, and it attempts to log the
  normal user into it, it will receive this error code.

* CKR_USER_NOT_LOGGED_IN: The desired action cannot be performed because the
  appropriate user (or an appropriate user) is not logged in. One example is
  that a session cannot be logged out unless it is logged in. Another example is
  that a private object cannot be created on a token unless the session
  attempting to create it is logged in as the normal user. A final example is
  that cryptographic operations on certain tokens cannot be performed unless the
  normal user is logged in.

* CKR_USER_PIN_NOT_INITIALIZED: This value can only be returned by **C_Login**.
  It indicates that the normal user’s PIN has not yet been initialized with
  **C_InitPIN**.

* CKR_USER_TOO_MANY_TYPES: An attempt was made to have more distinct users
  simultaneously logged into the token than the token and/or library permits.
  For example, if some application has an open SO session, and another
  application attempts to log the normal user into a session, the attempt may
  return this error. It is not required to, however. Only if the simultaneous
  distinct users cannot be supported does **C_Login** have to return this value.
  Note that this error code generalizes to true multi-user tokens.

* CKR_USER_TYPE_INVALID: An invalid value was specified as a **CK_USER_TYPE**.
  Valid types are **CKU_SO**, **CKU_USER**, and **CKU_CONTEXT**_SPECIFIC.

* CKR_WRAPPED_KEY_INVALID: This value can only be returned by **C_UnwrapKey**.
  It indicates that the provided wrapped key is not valid. If a call is made to
  **C_UnwrapKey** to unwrap a particular type of key (i.e., some particular key
  type is specified in the template provided to **C_UnwrapKey**), and the
  wrapped key provided to **C_UnwrapKey** is recognizably not a wrapped key of
  the proper type, then **C_UnwrapKey** should return CKR_WRAPPED_KEY_INVALID.
  This return value has lower priority than CKR_WRAPPED_KEY_LEN_RANGE.

* CKR_WRAPPED_KEY_LEN_RANGE: This value can only be returned by **C_UnwrapKey**.
  It indicates that the provided wrapped key can be seen to be invalid solely on
  the basis of its length. This return value has higher priority than
  CKR_WRAPPED_KEY_INVALID.

* CKR_WRAPPING_KEY_HANDLE_INVALID: This value can only be returned by
  **C_WrapKey**.  It indicates that the key handle specified to be used to wrap
  another key is not valid.

* CKR_WRAPPING_KEY_SIZE_RANGE: This value can only be returned by
  **C_WrapKey**. It indicates that although the requested wrapping operation
  could in principle be carried out, this Cryptoki library (or the token) is
  unable to actually do it because the supplied wrapping key’s size is outside
  the range of key sizes that it can handle.

* CKR_WRAPPING_KEY_TYPE_INCONSISTENT: This value can only be returned by
  **C_WrapKey**. It indicates that the type of the key specified to wrap
  another key is not consistent with the mechanism specified for wrapping.

* CKR_OPERATION_CANCEL_FAILED: This value can only be returned by
  **C_SessionCancel**. It means that one or more of the requested operations
  could not be cancelled for implementation or vendor-specific reasons.

### More on relative priorities of Cryptoki errors

In general, when a Cryptoki call is made, error codes from Section 5.1.1 (other
than **CKR_OK**) take precedence over error codes from Section 5.1.2, which take
precedence over error codes from Section 5.1.3, which take precedence over error
codes from Section 5.1.6. One minor implication of this is that functions that
use a session handle (i.e., most functions!) never return the error code
**CKR_TOKEN_NOT_PRESENT** (they return **CKR_SESSION_HANDLE_INVALID** instead).
Other than these precedences, if more than one error code applies to the result
of a Cryptoki call, any of the applicable error codes may be returned.
Exceptions to this rule will be explicitly mentioned in the descriptions of
functions.

### Error code “gotchas”

Here is a short list of a few particular things about return values that
Cryptoki developers might want to be aware of:

1. As mentioned in Sections 5.1.2 and 5.1.3, a Cryptoki library may not be able
   to make a distinction between a token being removed before a function
   invocation and a token being removed during a function invocation.
2. As mentioned in Section 5.1.2, an application should never count on getting a
   **CKR_SESSION_CLOSED** error.
3. The difference between **CKR_DATA_INVALID** and **CKR_DATA_LEN_RANGE** can be
   somewhat subtle. Unless an application needs to be able to distinguish
   between these return values, it is best to always treat them equivalently.
4. Similarly, the difference between **CKR_ENCRYPTED_DATA_INVALID** and
   **CKR_ENCRYPTED_DATA_LEN_RANGE**, and between **CKR_WRAPPED_KEY_INVALID** and
   **CKR_WRAPPED_KEY_LEN_RANGE**, can be subtle, and it may be best to treat
   these return values equivalently.
5. Even with the guidance of Section 4.1, it can be difficult for a Cryptoki
   library developer to know which of **CKR_ATTRIBUTE_VALUE_INVALID**,
   **CKR_TEMPLATE_INCOMPLETE**, or **CKR_TEMPLATE_INCONSISTENT** to return. When
   possible, it is recommended that application developers be generous in their
   interpretations of these error codes.
