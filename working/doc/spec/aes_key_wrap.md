## AES Key Wrap

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_AES_KEY_WRAP                     |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_KEY_WRAP_PAD                 |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_KEY_WRAP_KWP                 |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_KEY_WRAP_PKCS7               |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: AES Key Wrap Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_AES_KEY_WRAP
- CKM_AES_KEY_WRAP_PAD
- CKM_AES_KEY_WRAP_KWP
- CKM_AES_KEY_WRAP_PKCS7

### AES Key Wrap Mechanism parameters

The mechanisms will accept an optional mechanism parameter as the Initialization
vector which, if present, must be a fixed size array of 8 bytes for
**CKM_AES_KEY_WRAP** and **CKM_AES_KEY_WRAP_PKCS7**, resp. 4 bytes for
**CKM_AES_KEY_WRAP_KWP**; and, if NULL, will use the default initial value
defined in section 4.3 resp. 6.2 / 6.3 of [AES KEYWRAP].

The type of this parameter is CK_BYTE_PTR and the pointer points to the array of
bytes to be used as the initial value. The length shall be either 0 and the
pointer NULL; or 8 for **CKM_AES_KEY_WRAP** and **CKM_AES_KEY_WRAP_PKCS7**,
resp. 4 for **CKM_AES_KEY_WRAP_KWP**, and the pointer non-NULL.

### AES Key Wrap 

The mechanisms support only single-part operations, i.e. single part wrapping
and unwrapping, and single-part encryption and decryption.

#### CKM_AES_KEY_WRAP
\ 

The **CKM_AES_KEY_WRAP** mechanism can wrap a key of any length. A secret key
whose length is not a multiple of the AES Key Wrap semiblock size (8 bytes) will
be zero padded to fit. Semiblock size is defined in section 5.2 of [AES
KEYWRAP]. A private key will be encoded as defined in section 6.7; the encoded
private key will be zero padded to fit if necessary.

The **CKM_AES_KEY_WRAP** mechanism can only encrypt a block of data whose size
is an exact multiple of the AES Key Wrap algorithm semiblock size.

For unwrapping, the mechanism decrypts the wrapped key. In case of a secret key,
it truncates the result according to the CKA_KEY_TYPE attribute of the template
and, if it has one and the key type supports it, the CKA_VALUE_LEN attribute of
the template. The length specified in the template must not be less than n-7
bytes, where n is the length of the wrapped key. In case of a private key, the
mechanism parses the encoding as defined in section 6.7 and ignores trailing
zero bytes.

#### CKM_AES_KEY_WRAP_PAD
\ 

The **CKM_AES_KEY_WRAP_PAD** mechanism is deprecated. **CKM_AES_KEY_WRAP_KWP**
resp. **CKM_AES_KEY_WRAP_PKCS7** shall be used instead.

#### CKM_AES_KEY_WRAP_KWP
\ 

The **CKM_AES_KEY_WRAP_KWP** mechanism can wrap a key or encrypt block of data
of any length. The input is zero-padded and wrapped / encrypted as defined in
section 6.3 of [AES KEYWRAP], which produces same results as RFC 5649.

#### CKM_AES_KEY_WRAP_PKCS7
\ 

The **CKM_AES_KEY_WRAP_PKCS7** mechanism can wrap a key or encrypt a block of
data of any length. It does the padding detailed in [PKCS #7] of inputs (keys or
data blocks) up to a semiblock size to make it an exact multiple of AES Key Wrap
algorithm semiblock size (8bytes), always producing wrapped output that is
larger than the input key/data to be wrapped. This padding is done by the token
before being passed to the AES key wrap algorithm, which then wraps / encrypts
the padded block of data as defined in section 6.2 of [AES KEYWRAP].
