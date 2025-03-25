# Functions
Cryptoki's functions are organized into the following categories:

* general-purpose functions (6 functions)
* slot and token management functions (9 functions)
* session management functions (11 functions)
* object management functions (9 functions)
* encryption functions (4 functions)
* message-based encryption functions (5 functions)
* decryption functions (4 functions)
* message-based decryption functions (5 functions)
* message digesting functions (5 functions)
* signing and MACing functions (6 functions)
* message-based signing functions (5 functions)
* functions for verifying signatures and MACs (10 functions)
* message-based functions for verifying signatures and MACs (5 functions)
* dual-purpose cryptographic functions (4 functions)
* key management functions (9 functions)
* random number generation functions (2 functions)
* parallel function management functions (2 functions)
* asynchronous function management functions (3 functions)

In addition to these functions, Cryptoki can use application-supplied
callback functions to notify an application of certain events, and can also
use application-supplied functions to handle mutex objects for safe
multi-threaded library access.

The Cryptoki API functions are presented in the following table:

+-------------+------------------------+----------------------------------+
| Category    | Function               | Description                      |
+=============+========================+==================================+
| General	  | C_Initialize	       | initializes Cryptoki             |
| purpose     +------------------------+----------------------------------+
| functions   | C_Finalize             | clean up miscellaneous           |
|             |                        | Cryptoki-associated resources    |
|             +------------------------+----------------------------------+
|             | C_GetInfo              | obtains general information      |
|             |                        | about Cryptoki                   |
|             +------------------------+----------------------------------+
|             | C_GetFunctionList      | obtains entry points of Cryptoki |
|             |                        | library functions                |
|             +------------------------+----------------------------------+
|             | C_GetInterfaceList     | obtains list of interfaces       |
|             |                        | supported by Cryptoki library    |
|             +------------------------+----------------------------------+
|             | C_GetInterface         | obtains interface specific entry |
|             |                        | points to Cryptoki library       |
|             |                        | functions                        |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Slot and    | C_GetSlotList          | obtains a list of slots in the   |
| token       |                        | system                           |
| management  +------------------------+----------------------------------+
| functions	  | C_GetSlotInfo          | obtains information about a      |
|             |                        | particular slot                  |
|             +------------------------+----------------------------------+
|             | C_GetTokenInfo         | obtains information about a      |
|             |                        | particular token                 |
|             +------------------------+----------------------------------+
|             | C_WaitForSlotEvent     | waits for a slot event (token    |
|             |                        | insertion, removal, etc.) to     |
|             |                        | occur                            |
|             +------------------------+----------------------------------+
|             | C_GetMechanismList     | obtains a list of mechanisms     |
|             |                        | supported by a token             |
|             +------------------------+----------------------------------+
|             | C_GetMechanismInfo     | obtains information about a      |
|             |                        | particular mechanism             |
|             +------------------------+----------------------------------+
|             | C_InitToken            | initializes a token              |
|             +------------------------+----------------------------------+
|             | C_InitPIN              | initializes the normal user’s PIN|
|             +------------------------+----------------------------------+
|             | C_SetPIN               | modifies the PIN of the current  |
|             |                        | user                             |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Session     | C_OpenSession          | opens a connection between an    |
| management  |                        | application and a particular     |
| functions   |                        | token or sets up an application  |
|             |                        | callback for token insertion     |
|             +------------------------+----------------------------------+
|             | C_CloseSession         | closes a session                 |
|             +------------------------+----------------------------------+
|             | C_CloseAllSessions     | closes all sessions with a token |
|             +------------------------+----------------------------------+
|             | C_GetSessionInfo       | obtains information about the    |
|             |                        | session                          |
|             +------------------------+----------------------------------+
|             | C_SessionCancel        | terminates active session based  |
|             |                        | operations                       |
|             +------------------------+----------------------------------+
|             | C_GetOperationState    | obtains the cryptographic        |
|             |                        | operations state of a session    |
|             +------------------------+----------------------------------+
|             | C_SetOperationState    | sets the cryptographic operations|
|             |                        | state of a session               |
|             +------------------------+----------------------------------+
|             | C_Login                | logs into a token                |
|             +------------------------+----------------------------------+
|             | C_LoginUser            | logs into a token with explicit  |
|             |                        | user name                        |
|             +------------------------+----------------------------------+
|             | C_Logout               | logs out from a token            |
|             +------------------------+----------------------------------+
|             | C_GetSessionValidaionF | fetches validation flags         |
|             | lags                   | from the session                 |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Object      | C_CreateObject         | creates an object                |
| management  +------------------------+----------------------------------+
| functions	  | C_CopyObject           | creates a copy of an object      |
|             +------------------------+----------------------------------+
|             | C_DestroyObject        | destroys an object               |
|             +------------------------+----------------------------------+
|             | C_GetObjectSize        | obtains the size of an object in |
|             |                        | bytes                            |
|             +------------------------+----------------------------------+
|             | C_GetAttributeValue    | obtains an attribute value of an |
|             |                        | object                           |
|             +------------------------+----------------------------------+
|             | C_SetAttributeValue    | modifies an attribute value of an|
|             |                        | object                           |
|             +------------------------+----------------------------------+
|             | C_FindObjectsInit      | initializes an object search     |
|             |                        | operation                        |
|             +------------------------+----------------------------------+
|             | C_FindObjects          | continues an object search       |
|             |                        | operation                        |
|             +------------------------+----------------------------------+
|             | C_FindObjectsFinal     | finishes an object search        |
|             |                        | operation                        |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Encryption  | C_EncryptInit          | initializes an encryption        |
| functions	  |                        | operation                        |
|             +------------------------+----------------------------------+
|             | C_Encrypt              | encrypts single-part data        |
|             +------------------------+----------------------------------+
|             | C_EncryptUpdate        | continues a multiple-part        |
|             |                        | encryption operation             |
|             +------------------------+----------------------------------+
|             | C_EncryptFinal         | finishes a multiple-part         |
|             |                        | encryption operation             |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Message-    | C_MessageEncryptInit   | initializes a message-based      |
| based	      |                        | encryption process               |
| Encryption  +------------------------+----------------------------------+
| Functions   | C_EncryptMessage       | encrypts a single-part message   |
|             +------------------------+----------------------------------+
|             | C_EncryptMessageBegin  | begins a multiple-part message   |
|             |                        | encryption operation             |
|             +------------------------+----------------------------------+
|             | C_EncryptMessageNext   | continues or finishes a          |
|             |                        | multiple-part message encryption |
|             |                        | operation                        |
|             +------------------------+----------------------------------+
|             | C_MessageEncryptFinal  | finishes a message-based         |
|             |                        | encryption process               |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Decryption  | C_DecryptInit          |initializes a decryption operation|
| Functions	  +------------------------+----------------------------------+
|             | C_Decrypt              | decrypts single-part encrypted   |
|             |                        | data                             |
|             +------------------------+----------------------------------+
|             | C_DecryptUpdate        | continues a multiple-part        |
|             |                        | decryption operation             |
|             +------------------------+----------------------------------+
|             | C_DecryptFinal         | finishes a multiple-part         |
|             |                        | decryption operation             |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Message-    | C_MessageDecryptInit   | initializes a message decryption |
| based       |                        | operation                        |
| Decryption  +------------------------+----------------------------------+
| Functions   | C_DecryptMessage       | decrypts single-part encrypted   |
|             |                        | data                             |
|             +------------------------+----------------------------------+
|             | C_DecryptMessageBegin  | starts a multiple-part message   |
|             |                        | decryption operation             |
|             +------------------------+----------------------------------+
|             | C_DecryptMessageNext   | Continues and finishes a         |
|             |                        | multiple-part message decryption |
|             |                        | operation                        |
|             +------------------------+----------------------------------+
|             | C_MessageDecryptFinal  | finishes a message decryption    |
|             |                        | operation                        |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Message     | C_DigestInit           | initializes a message-digesting  |
| Digesting   |	                       | operation                        |
| Functions	  +------------------------+----------------------------------+
|             | C_Digest               | digests single-part data         |
|             +------------------------+----------------------------------+
|             | C_DigestUpdate         | continues a multiple-part        |
|             |                        | digesting operation              |
|             +------------------------+----------------------------------+
|             | C_DigestKey            | digests a key                    |
|             +------------------------+----------------------------------+
|             | C_DigestFinal          | finishes a multiple-part         |
|             |                        | digesting operation              |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Signing     | C_SignInit             | initializes a signature operation|
| and MACing  +------------------------+----------------------------------+
| functions	  | C_Sign                 | signs single-part data           |
|             +------------------------+----------------------------------+
|             | C_SignUpdate           | continues a multiple-part        |
|             |                        | signature operation              |
|             +------------------------+----------------------------------+
|             | C_SignFinal            | finishes a multiple-part         |
|             |                        | signature operation              |
|             +------------------------+----------------------------------+
|             | C_SignRecoverInit      |initializes a signature operation,|
|             |                        | where the data can be recovered  |
|             |                        | from the signature               |
|             +------------------------+----------------------------------+
|             | C_SignRecover          | signs single-part data, where the|
|             |                        | data can be recovered from the   |
|             |                        | signature                        |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Message-    | C_MessageSignInit      | initializes a message signature  |
| based       |                        | operation                        |
| Signature   +------------------------+----------------------------------+
| functions   | C_SignMessage          | signs single-part data           |
|             +------------------------+----------------------------------+
|             | C_SignMessageBegin     | starts a multiple-part message   |
|             |                        | signature operation              |
|             +------------------------+----------------------------------+
|             | C_SignMessageNext      | continues and finishes a         |
|             |                        | multiple-part message signature  |
|             |                        | operation                        |
|             +------------------------+----------------------------------+
|             | C_MessageSignFinal     | finishes a message signature     |
|             |                        | operation                        |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Functions   | C_VerifyInit           | initializes a verification       |
| for         |                        | operation                        |
| verifying	  +------------------------+----------------------------------+
| signatures  | C_Verify               | verifies a signature on          |
| and MACs    |                        | single-part data                 |
|             +------------------------+----------------------------------+
|             | C_VerifyUpdate         | continues a multiple-part        |
|             |                        | verification operation           |
|             +------------------------+----------------------------------+
|             | C_VerifyFinal          | finishes a multiple-part         |
|             |                        | verification operation           |
|             +------------------------+----------------------------------+
|             | C_VerifyRecoverInit    | initializes a verification       |
|             |                        | operation where the data is      |
|             |                        | recovered from the signature     |
|             +------------------------+----------------------------------+
|             | C_VerifyRecover        | verifies a signature on          |
|             |                        | single-part data, where the data |
|             |                        | is recovered from the signature  |
|             +------------------------+----------------------------------+
|             | C_VerifySignatureInit  | initializes a verification       |
|             |                        | operation, passing the signature |
|             |                        | at initialization time.          |
|             +------------------------+----------------------------------+
|             | C_VerifySignature      | verifies a signature on          |
|             |                        | single-part data                 |
|             +------------------------+----------------------------------+
|             | C_VerifySignatureUpdate| continues a multiple-part        |
|             |                        | verification operation           |
|             +------------------------+----------------------------------+
|             | C_VerifySignatureFinal | finishes a multiple-part         |
|             |                        | verification operation           |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Message-    | C_MessageVerifyInit    | initializes a message            |
| based       |                        | verification operation           |
| Functions   +------------------------+----------------------------------+
| for         | C_VerifyMessage        | verifies a signature on          |
| verifying   |                        | single-part data                 |
| signatures  +------------------------+----------------------------------+
| and MACs    | C_VerifyMessageBegin   | starts a multiple-part message   |
|             |                        | verification operation           |
|             +------------------------+----------------------------------+
|             | C_VerifyMessageNext    | continues and finishes a         |
|             |                        | multiple-part message            |
|             |                        | verification operation           |
|             +------------------------+----------------------------------+
|             | C_MessageVerifyFinal   | finishes a message verification  |
|             |                        | operation                        |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Dual-purpose| C_DigestEncryptUpdate  | continues simultaneous           |
|cryptographic|                        | multiple-part digesting and      |
| functions	  |                        | encryption operations            |
|             +------------------------+----------------------------------+
|             | C_DecryptDigestUpdate  | continues simultaneous           |
|             |                        | multiple-part decryption and     |
|             |                        | digesting operations             |
|             +------------------------+----------------------------------+
|             | C_SignEncryptUpdate    | continues simultaneous           |
|             |                        | multiple-part signature and      |
|             |                        | encryption operations            |
|             +------------------------+----------------------------------+
|             | C_DecryptVerifyUpdate  | continues simultaneous           |
|             |                        | multiple-part decryption and     |
|             |                        | verification operations          |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Key         | C_GenerateKey          | generates a secret key           |
| management  +------------------------+----------------------------------+
| functions	  | C_GenerateKeyPair      |generates a public-key/private-key|
|             |                        | pair                             |
|             +------------------------+----------------------------------+
|             | C_WrapKey              | wraps (encrypts) a key           |
|             +------------------------+----------------------------------+
|             | C_UnwrapKey            | unwraps (decrypts) a key         |
|             +------------------------+----------------------------------+
|             | C_DeriveKey            | derives a key from a base key    |
|             +------------------------+----------------------------------+
|             | C_WrapKeyAuthenticated | authenticated key wrapping       |
|             |                        | (encryption) of a key            |
|             +------------------------+----------------------------------+
|             |C_UnwrapKeyAuthenticated| authenticated key unwrapping     |
|             |                        | (decryption) of a key            |
|             +------------------------+----------------------------------+
|             | C_EncapsulateKey       | generates a secret key from a    |
|             |                        | public key and returns the       |
|             |                        | encapsulated ciphertext (KEM)    |
|             +------------------------+----------------------------------+
|             | C_DecapsulateKey       | generates a secret key from a    |
|             |                        | private key and the previously   |
|             |                        | encapsulated ciphertext(KEM)     |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Randomn     | C_SeedRandom           | mixes in additional seed material|
| number      |                        | to the random number generator   |
| generation  +------------------------+----------------------------------+
| functions	  | C_GenerateRandom       | generates random data            |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Parallel    | C_GetFunctionStatus    | legacy function which always     |
| function    |                        | returns CKR_FUNCTION_NOT_PARALLEL|
| management  +------------------------+----------------------------------+
| functions   | C_CancelFunction       | legacy function which always     |
|             |                        | returns CKR_FUNCTION_NOT_PARALLEL|
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Asynchronous| C_AsyncComplete        | checks if an asynchronous        |
| function    |                        | function has completed           |
| management  +------------------------+----------------------------------+
| functions   | C_AsyncGetID           | persist an asynchronous operation|
|             |                        | past a C_Finalize call           |
|             +------------------------+----------------------------------+
|             | C_AsyncJoin            | reconnects the client application|
|             |                        | to an asynchronous operation     |
+-------------+------------------------+----------------------------------+
+-------------+------------------------+----------------------------------+
| Callback    |                        | application-supplied function to |
| function	  |                        | process notifications from       |
|             |                        | Cryptoki                         |
+-------------+------------------------+----------------------------------+
table: Summary of Cryptoki Functions

Execution of a Cryptoki function call is in general an all-or-nothing affair,
i.e., a function call accomplishes either its entire goal, or nothing at all.

* If a Cryptoki function executes successfully, it returns the value
  **CKR_OK**.
* If a Cryptoki function does not execute successfully, it returns some value
  other than **CKR_OK**, and the token is in the same state as it was in
  prior to the function call. If the function call was supposed to modify the
  contents of certain memory addresses on the host computer, these memory
  addresses may have been modified, despite the failure of the function.
* Some Cryptoki function may return **CKR_PENDING** to indicate that function
  execution has not finished yet. For details see Section 5.21.
* In unusual (and extremely unpleasant!) circumstances, a function can fail
  with the return value **CKR_GENERAL_ERROR**. When this happens, the token
  and/or host computer may be in an inconsistent state, and the goals of the
  function may have been partially achieved.

There are a small number of Cryptoki functions whose return values do not
behave precisely as described above; these exceptions are documented
individually with the description of the functions themselves.

A Cryptoki library need not support every function in the Cryptoki API.
However, even an unsupported function MUST have a “stub” in the library which
simply returns the value **CKR_FUNCTION_NOT_SUPPORTED**. The function’s entry
in the library’s **CK_FUNCTION_LIST** structure (as obtained by
**C_GetFunctionList**) should point to this stub function (see Section 3.6).
