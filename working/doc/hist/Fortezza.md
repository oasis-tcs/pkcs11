## FORTEZZA timestamp

The FORTEZZA timestamp mechanism, denoted **CKM_FORTEZZA_TIMESTAMP**, is a
mechanism for single-part signatures and verification.  The signatures it
produces and verifies are DSA digital signatures over the provided hash value
and the current time.

**It has no parameters.**

Constraints on key types and the length of data are summarized in the following
table.  The input and output data MAY begin at the same location in memory.

| Function    | Key type        | Input Length | Output Length |
|-------------|-----------------|--------------|---------------|
| C_Sign^1^   | DSA private key | 20           | 40            |
| C_Verify^1^ | DSA public key  | 20,40^2^     | N/A           |
table 2: FORTEZZA Timestamp: Key and Data Length

^1^ Single-part operations only

^2^ Data length, signature length

For this mechanism, the ulMinKeySIze and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of DSA prime sizes,
in bits.
