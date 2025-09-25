## Conventions for functions returning output in a variable-length buffer

A number of the functions defined in Cryptoki return output produced by some
cryptographic mechanism. The amount of output returned by these functions is
returned in a variable-length application-supplied buffer. An example of a
function of this sort is **C_Encrypt**, which takes some plaintext as an
argument, and outputs a buffer full of ciphertext.

These functions have some common calling conventions, which we describe here.
Two of the arguments to the function are a pointer to the output buffer (say
pBuf) and a pointer to a location which will hold the length of the output
produced (say pulBufLen).  There are two ways for an application to call such a
function:

1. If pBuf is NULL_PTR, then all that the function does is return (in
   *pulBufLen) a number of bytes which would suffice to hold the cryptographic
   output produced from the input to the function. This number may somewhat
   exceed the precise number of bytes needed, but should not exceed it by a
   large amount.  **CKR_OK** is returned by the function.
2. If pBuf is not NULL_PTR, then \*pulBufLen MUST contain the size in bytes of
   the buffer pointed to by pBuf. If that buffer is large enough to hold the
   cryptographic output produced from the input to the function, then that
   cryptographic output is placed there, and **CKR_OK** is returned by the
   function and \*pulBufLen is set to the exact number of bytes returned. If the
   buffer is not large enough, then **CKR_BUFFER_TOO_SMALL** is returned and
   \*pulBufLen is set to at least the number of bytes needed to hold the
   cryptographic output produced from the input to the function.

NOTE: This is a change from previous specs. The problem is that in some decrypt
cases, the token doesn’t know how big a buffer is needed until the decrypt
completes. The act of doing decrypt can mess up the internal encryption state.
Many tokens already implement this relaxed behavior, tokens which implement the
more precise behavior are still compliant. The one corner case is applications
using a token that knows exactly how big the decryption is (through some out of
band means), could get **CKR_BUFFER_TOO_SMALL** returned when it supplied a
buffer exactly big enough to hold the decrypted value when it may previously
have succeeded.

All functions which use the above convention will explicitly say so.

Cryptographic functions which return output in a variable-length buffer should
always return as much output as can be computed from what has been passed in to
them thus far. As an example, consider a session which is performing a
multiple-part decryption operation with DES in cipher-block chaining mode with
PKCS padding. Suppose that, initially, 8 bytes of ciphertext are passed to the
**C_DecryptUpdate** function. The block size of DES is 8 bytes, but the PKCS
padding makes it unclear at this stage whether the ciphertext was produced from
encrypting a 0-byte string, or from encrypting some string of length at least 8
bytes. Hence the call to **C_DecryptUpdate** should return 0 bytes of
plaintext. If a single additional byte of ciphertext is supplied by a subsequent
call to **C_DecryptUpdate**, then that call should return 8 bytes of plaintext
(one full DES block).
