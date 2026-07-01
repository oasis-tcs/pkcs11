## RC5

### Definitions

RC5 is a parameterizable block cipher patented by RSA Security.  It has a
variable wordsize, a variable keysize, and a variable number of rounds.  The
blocksize of RC5 is equal to twice its wordsize.

This section defines the key type “CKK_RC5” for type CK_KEY_TYPE as used in the
CKA_KEY_TYPE attribute of key objects.

Mechanisms:

- CKM_RC5_KEY_GEN
- CKM_RC5_ECB
- CKM_RC5_CBC
- CKM_RC5_MAC
- CKM_RC5_MAC_GENERAL
- CMK_RC5_CBC_PAD

### RC5 secret key objects

RC5 secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_RC5**)
hold RC5 keys.  The following table defines the RC5 secret key object
attributes, in addition to the common attributes defined for this object class.

| Attribute             | Data type  | Meaning                      |
|-----------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^   | Byte array | Key value (0 to 255 bytes)   |
| CKA_VALUE_LEN ^2,3,6^ | CK_ULONG   | Length in bytes of key value |
table: RC5 Secret Key Object

Refer to [PKCS #11-Base]  table 11 for footnotes

The following is a sample template for creating an RC5 secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_RC5;
CK_UTF8CHAR label[] = “An RC5 secret key object”;
CK_BYTE value[] = {…};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_ENCRYPT, &true, sizeof(true)},
	{CKA_VALUE, value, sizeof(value)}
};
```

### RC5 mechanism parameters

#### CK_RC5_PARAMS; CK_RC5_PARAMS_PTR
\

**CK_RC5_PARAMS** provides the parameters to the **CKM_RC5_ECB** and **CKM_RC5_MAC** mechanisms.  It is defined as follows:

```c
typedef struct CK_RC5_PARAMS {
	CK_ULONG ulWordsize;
	CK_ULONG ulRounds;
} CK_RC5_PARAMS;
```

The fields of the structure have the following meanings:

_ulWordsize_
: wordsize of RC5 cipher in bytes

_ulRounds_
: number of rounds of RC5 encipherment

**CK_RC5_PARAMS_PTR** is a pointer to a **CK_RC5_PARAMS**.

#### CK_RC5_CBC_PARAMS; CK_RC5_CBC_PARAMS_PTR
\

**CK_RC5_CBC_PARAMS** is a structure that provides the parameters to the **CKM_RC5_CBC** and **CKM_RC5_CBC_PAD** mechanisms.  It is defined as follows:

```c
typedef struct CK_RC5_CBC_PARAMS {
	CK_ULONG ulWordsize;
	CK_ULONG ulRounds;
	CK_BYTE_PTR pIv;
	CK_ULONG ulIvLen;
} CK_RC5_CBC_PARAMS;
```

The fields of the structure have the following meanings:

_ulwordSize_
: wordsize of RC5 cipher in bytes

_ulRounds_
: number of rounds of RC5 encipherment

_pIV_
: pointer to initialization vector (IV) for CBC encryption

_ulIVLen_
: length of initialization vector (must be same as blocksize)

**CK_RC5_CBC_PARAMS_PTR** is a pointer to a **CK_RC5_CBC_PARAMS**.

#### CK_RC5_MAC_GENERAL_PARAMS; CK_RC5_MAC_GENERAL_PARAMS_PTR
\

**CK_RC5_MAC_GENERAL_PARAMS** is a structure that provides the parameters to the
**CKM_RC5_MAC_GENERAL** mechanism.  It is defined as follows:

```c
typedef struct CK_RC5_MAC_GENERAL_PARAMS {
	CK_ULONG ulWordsize;
	CK_ULONG ulRounds;
	CK_ULONG ulMacLength;
} CK_RC5_MAC_GENERAL_PARAMS;
```

The fields of the structure have the following meanings:

_ulwordSize_
: wordsize of RC5 cipher in bytes

_ulRounds_
: number of rounds of RC5 encipherment

_ulMacLength_
: length of the MAC produced, in bytes

**CK_RC5_MAC_GENERAL_PARAMS_PTR** is a pointer to a **CK_RC5_MAC_GENERAL_PARAMS**.

### RC5 key generation

The RC5 key generation mechanism, denoted **CKM_RC5_KEY_GEN**, is a key
generation mechanism for RSA Security’s block cipher RC5.

It does not have a parameter.

The mechanism generates RC5 keys with a particular length in bytes, as specified
in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key.  Other attributes supported by the RC5 key type
(specifically, the flags indicating which functions the key supports) MAY be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySIze_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC5 key sizes, in
bytes.

### RC5-ECB

RC5-ECB, denoted **CKM_RC5_ECB**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on RSA
Security’s block cipher RC5 and electronic codebook mode as defined in FIPS PUB
81.

It has a parameter, **CK_RC5_PARAMS**, which indicates the wordsize and number
of rounds of encryption to use.

This mechanism MAY wrap and unwrap any secret key.  Of course, a particular
token MAY not be able to wrap/unwrap every secret key that it supports.  For
wrapping, the mechanism encrypts the value of the **CKA_VALUE** attribute of the
key that is wrapped, padded on the trailing end with null bytes so that the
resulting length is a multiple of the cipher blocksize (twice the wordsize).
The output data is the same length as the padded input data.  It does not wrap
the key type, key length, or any other information about the key; the
application must convey these separately.

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attributes of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length          | Output length        | Comments      |
|-------------|----------|-----------------------|----------------------|---------------|
| C_Encrypt   | RC5      | Multiple of blocksize | Same as input length | No final part |
| C_Decrypt   | RC5      | Multiple of blocksize | Same as input length | No final part |
| C_WrapKey   | RC5      | Any                   | Input length rounded up to multiple of blocksize | |
| C_UnwrapKey | RC5      | Multiple of blocksize | Determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: RC5-ECB Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC5 key sizes, in
bytes.

### RC5-CBC

RC5-CBC, denoted **CKM_RC5_CBC**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on RSA
Security’s block cipher RC5 and cipher-block chaining mode as defined in FIPS
PUB 81.

It has a parameter, a **CK_RC5_CBC_PARAMS** structure, which specifies the
wordsize and number of rounds of encryption to use, as well as the
initialization vector for cipher block chaining mode.

This mechanism MAY wrap and unwrap any secret key.  Of course, a particular
token MAY not be able to wrap/unwrap every secret key that it supports.  For
wrapping, the mechanism encrypts the value of the **CKA_VALUE** attribute of the
key that is wrapped, padded on the trailing end with up to seven null bytes so
that the resulting length is a multiple of eight.  The output data is the same
length as the padded input data.  It does not wrap the key type, key length, or
any other information about the key; the application must convey these
separately.

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute for the template, and, if it has
one, and the key type supports it, the **CKA_VALUE_LEN** attribute of the
template.  The mechanism contributes the result as the **CKA_VALUE** attribute
of the new key; other attributes required by the key type must be specified in
the template.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length          | Output length        | Comments      |
|-------------|----------|-----------------------|----------------------|---------------|
| C_Encrypt   | RC5      | Multiple of blocksize | Same as input length | No final part |
| C_Decrypt   | RC5      | Multiple of blocksize | Same as input length | No final part |
| C_WrapKey   | RC5      | Any                   | Input length rounded up to multiple of blocksize | |
| C_UnwrapKey | RC5      | Multiple of blocksize | Determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: RC5-CBC Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC5 key sizes, in
bytes.

### RC5-CBC with PKCS padding

RC5-CBC with PKCS padding, denoted **CKM_RC5_CBC_PAD**, is a mechanism for
single- and multiple-part encryption and decryption; key wrapping; and key
unwrapping, based on RSA Security’s block cipher RC5; cipher block chaining mode
as defined in FIPS PUB 81; and the block cipher padding method detailed in PKCS
#7.

It has a parameter, a **CK_RC5_CBC_PARAMS** structure, which specifies the
wordsize and number of rounds of encryption to use, as well as the
initialization vector for cipher block chaining mode.

The PKCS padding in this mechanism allows the length of the plaintext value to
be recovered from the ciphertext value.  Therefore, when unwrapping keys with
this mechanism, no value should be specified for the **CKA_VALUE_LEN**
attribute.

In addition to being able to wrap an unwrap secret keys, this mechanism MAY wrap
and unwrap RSA, Diffie-Hellman, X9.42 Diffie-Hellman, EC (also related to ECDSA)
and DSA private keys.  The entries in the table below for data length
constraints when wrapping and unwrapping keys do not apply to wrapping and
unwrapping private keys.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length          | Output length              |
|-------------|----------|-----------------------|----------------------------|
| C_Encrypt   | RC5      | Any                   | Input length rounded up to multiple of blocksize |
| C_Decrypt   | RC5      | Multiple of blocksize | Between 1 and blocksize bytes shorter than input length |
| C_WrapKey   | RC5      | Any                   | Input length rounded up to multiple of blocksize |
| C_UnwrapKey | RC5      | Multiple of blocksize | Between 1 and blocksize bytes shorter than input length |
table: RC5-CBC with PKCS Padding; Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC5 key sizes, in
bytes.

### General-length RC5-MAC

General-length RC5-MAC, denoted **CKM_RC5_MAC_GENERAL**, is a mechanism for
single- and multiple-part signatures and verification, based on RSA Security’s
block cipher RC5 and data authentication as defined in FIPS PUB 113.

It has a parameter, a **CK_RC5_MAC_GENERAL_PARAMS** structure, which specifies
the wordsize and number of rounds of encryption to use and the output length
desired from the mechanism.

The output bytes from this mechanism are taken from the start of the final RC5
cipher block produced in the MACing process.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length | Signature length                        |
|----------|----------|-------------|-----------------------------------------|
| C_Sign   | RC5      | Any         | 0-blocksize, as specified in parameters |
| C_Verify | RC5      | Any         | 0-blocksize, as specified in parameters |
table: General-length RC2-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySIze_ fields of the **CK_MECHANISM_INFO** structure specify the supported range of RC5 key sizes, in bytes.

### RC5-MAC

RC5-MAC, denoted by **CKM_RC5_MAC**, is a special case of the general-length
RC5-MAC mechanism.  Instead of taking a **CK_RC5_MAC_GENERAL_PARAMS** parameter,
it takes a **CK_RC5_PARAMS** parameter.  RC5-MAC produces and verifies MACs half
as large as the RC5 blocksize.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length | Signature length             |
|----------|----------|-------------|------------------------------|
| C_Sign   | RC5      | Any         | RC5 wordsize = [blocksize/2] |
| C_Verify | RC5      | Any         | RC5 wordsize = [blocksize/2] |
table: RC5-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC5 key sizes, in
bytes.
