## LYNKS

### Definitions

Mechanisms:

- CKM_KEY_WRAP_LYNKS

### LYNKS key wrapping

The LYNKS key wrapping mechanism, denoted **CKM_KEY_WRAP_LYNKS**, is a mechanism
for wrapping and unwrapping secret keys with DES keys.  It MAY wrap any 8-byte
secret key, and it produces a 10-byte wrapped key, containing a cryptographic
checksum.

It does not have a parameter.

To wrap an 8-byte secret key _K_ with a DES key _W_, this mechanism performs the
following steps:

  1. Initialize two 16-bit integers, sum~1~ and sum~2~, to 0

  2. Loop through the bytes of _K_ from first to last.

  3. Set sum~1~= sum~1~+the key byte (treat the key byte as a number in the
     range 0-255).

  4. Set sum~2~= sum~2~+ sum~1~.

  5. Encrypt _K_ with _W_ in ECB mode, obtaining an encrypted key, _E_.

  6. Concatenate the last 6 bytes of _E_ with sum~2~, representing sum~2~
     most-significant bit first.  The result is an 8-byte block, _T_

  7. Encrypt _T_ with _W_ in ECB mode, obtaining an encrypted checksum, _C_.

  8. Concatenate _E_ with the last 2 bytes of _C_ to obtain the wrapped key.

When unwrapping a key with this mechanism, if the cryptographic checksum does
not check out properly, an error is returned.  In addition, if a DES key or CDMF
key is unwrapped with this mechanism, the parity bits on the wrapped key must be
set appropriately.  If they are not set properly, an error is returned.
