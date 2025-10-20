## AES with Counter


+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_AES_CTR                          |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: AES with Counter Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_AES_CTR

### AES with Counter mechanism parameters

#### CK_AES_CTR_PARAMS
\  

**CK_AES_CTR_PARAMS** is a structure that provides the parameters to the
**CKM_AES_CTR** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_AES_CTR_PARAMS {
	CK_ULONG	ulCounterBits;
	CK_BYTE	cb[16];
}	CK_AES_CTR_PARAMS;
~~~

_ulCounterBits_ specifies the number of bits in the counter block (_cb_) that
shall be incremented. This number shall be such that 0 < _ulCounterBits_ ≤ 128.
For any values outside this range the mechanism shall return
**CKR_MECHANISM_PARAM_INVALID**.

It's up to the caller to initialize all of the bits in the counter block
including the counter bits. The counter bits are the least significant bits of
the counter block (cb). They are a big-endian value usually starting with 1. The
rest of ‘cb’ is for the nonce, and maybe an optional IV.

E.g. as defined in [RFC 3686]:

~~~
    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                            Nonce                              |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                  Initialization Vector (IV)                   |
   |                                                               |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                         Block Counter                         |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

This construction permits each packet to consist of up to 2^32^-1 blocks =
4,294,967,295 blocks = 68,719,476,720 octets.

**CK_AES_CTR_PARAMS_PTR** is a pointer to a **CK_AES_CTR_PARAMS**.

### AES with Counter Encryption / Decryption

Generic AES counter mode is described in NIST Special Publication 800-38A and in
[RFC 3686]. These describe encryption using a counter block which may include a
nonce to guarantee uniqueness of the counter block. Since the nonce is not
incremented, the mechanism parameter must specify the number of counter bits in
the counter block.

The block counter is incremented by 1 after each block of plaintext is
processed. There is no support for any other increment functions in this
mechanism.

If an attempt to encrypt/decrypt is made which will cause an overflow of the
counter block’s counter bits, then the mechanism shall return
**CKR_DATA_LEN_RANGE**. Note that the mechanism should allow the final post
increment of the counter to overflow (if it implements it this way) but not
allow any further processing after this point. E.g. if ulCounterBits = 2 and the
counter bits start as 1 then only 3 blocks of data can be processed. 
