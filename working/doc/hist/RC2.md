## RC2

### Definitions

RC2 is a block cipher which is trademarked by RSA Security.  It has a variable
keysizse and an additional parameter, the “effective number of bits in the RC2
search space”, which MAY take on values in the range 1-1024, inclusive.  The
effective number of bits in the RC2 search space is sometimes specified by an
RC2 “version number”; this “version number” is not the same thing as the
“effective number of bits”, however.  There is a canonical way to convert from
one to the other.

This section defines the key type “CKK_RC2” for type CK_KEY_TYPE as used in the
CKA_KEY_TYPE attribute of key objects.

Mechanisms:

- CKM_RC2_KEY_GEN
- CKM_RC2_ECB
- CKM_RC2_CBC
- CKM_RC2_MAC
- CKM_RC2_MAC_GENERAL
- CKM_RC2_CBC_PAD

### RC2 secret key objects

RC2 secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_RC2**)
hold RC2 keys.  The following table defines the RC2 secret key object
attributes, in addition to the common attributes defined for this object class:


| Attribute           | Data type  | Meaning                      |
|---------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (1 to 128 bytes)   |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value |
table: RC2 Secret Key Object Attributes

Refer to [PKCS #11-Base] table 11 for footnotes

The following is a sample template for creating an RC2 secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_RC2;
CK_UTF8CHAR label[] = “An RC2 secret key object”; 
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

### RC2 mechanism parameters

#### CK_RC2_PARAMS; CK_RC2_PARAMS_PTR
\

**CK_RC2_PARAMS** provides the parameters to the **CKM_RC2_ECB** and
**CMK_RC2_MAC** mechanisms.  It holds the effective number of bits in the RC2
search space.  It is defined as follows:

```c
typedef CK_ULONG CK_RC2_PARAMS;
```

**CK_RC2_PARAMS_PTR** is a pointer to a **CK_RC2_PARAMS**.

#### CK_RC2_CBC_PARAMS; CK_RC2_CBC_PARAMS_PTR
\

**CK_RC2_CBC_PARAMS** is a structure that provides the parameters to the
**CKM_RC2_CBC** and **CKM_RC2_CBC_PAD** mechanisms.  It is defined as follows:

```c
typedef struct CK_RC2_CBC_PARAMS {
	CK_ULONG ulEffectiveBits;
	CK_BYTE iv[8];
} CK_RC2_CBC_PARAMS;
```

The fields of the structure have the following meanings:

_ulEffectiveBits_
: the effective number of bits in the RC2 search space

_iv_
: the initialization vector (IV) for cipher block chaining mode

**CK_RC2_CBC_PARAMS_PTR** is a pointer to a **CK_RC2_CBC_PARAMS**.

#### CK_RC2_MAC_GENERAL_PARAMS; CK_RC2_MAC_GENERAL_PARAMS_PTR
\

**CK_RC2_MAC_GENERAL_PARAMS** is a structure that provides the parameters to the
**CKM_RC2_MAC_GENERAL** mechanism.  It is defined as follows:

```c
typedef struct CK_RC2_MAC_GENERAL_PARAMS {
	CK_ULONG ulEffectiveBits;
	CK_ULONG ulMacLength;
} CK_RC2_MAC_GENERAL_PARAMS;
```

The fields of the structure have the following meanings:

_ulEffectiveBits_
: the effective number of bits in the RC2 search space

_ulMacLength_
: length of the MAC produced, in bytes

**CK_RC2_MAC_GENERAL_PARAMS_PTR** is a pointer to a
**CK_RC2_MAC_GENERAL_PARAMS**.

### RC2 key generation

The RC2 key generation mechanism, denoted **CKM_RC2_KEY_GEN**, is a key
generation mechanism for RSA Security’s block cipher RC2.

It does not have a parameter.

The mechanism generates RC2 keys with a particular length in bytes, as specified
in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key.  Other attributes supported by the RC2 key type
(specifically, the flags indicating which functions the key supports) MAY be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC2 key sizes, in
bits.

### RC2-ECB

RC2-ECB, denoted **CKM_RC2_ECB**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on RSA
Security’s block cipher RC2 and electronic codebook mode as defined in FIPS PUB
81.

It has a parameter, a **CK_RC2_PARAMS**, which indicates the effective number of
bits in the RC2 search space.

This mechanism MAY wrap and unwrap any secret key.  Of course, a particular
token MAY not be able to wrap/unwrap every secret key that it supports.  For
wrapping, the mechanism encrypts the value of the **CKA_VALUE** attribute of the
key that is wrapped, padded on the trailing end with up to seven null bytes so
that the resulting length is a multiple of eight.  The output data is the same
length as the padded input data.  It does not wrap the key type, key length, or
any other information about the key; the application must convey these
separately.

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length  | Output length        | Comments |
|-------------|----------|---------------|----------------------|----------|
| C_Encrypt   | RC2      | Multiple of 8 | Same as input length | No final part |
| C_Decrypt   | RC2      | Multiple of 8 | Same as input length | No final part |
| C_WrapKey   | RC2      | Any           | Input length rounded up to multiple of 8 | |
| C_UnwrapKey | RC2      | Multiple of 8 | Determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: RC2-ECB: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC2 effective
number of  bits.

### RC2-CBC

RC2_CBC, denoted **CKM_RC2_CBC**, is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping, based on RSA
Security’s block cipher RC2 and cipher-block chaining mode as defined in FIPS
PUB 81.

It has a parameter, a **CK_RC2_CBC_PARAMS** structure, where the first field
indicates the effective number of bits in the RC2 search space, and the next
field is the initialization vector for cipher block chaining mode.

This mechanism MAY wrap and unwrap any secret key.  Of course, a particular
token MAY not be able to wrap/unwrap every secret key that it supports.  For
wrapping, the mechanism encrypts the value of the **CKA_VALUE** attribute of the
key that is wrapped, padded on the trailing end with up to seven null bytes so
that the resulting length is a multiple of eight.  The output data is the same
length as the padded input data.  It does not wrap the key type, key length, or
any other information about the key; the application must convey these
separately. 

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key type must be specified in the
template.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length  | Output length        | Comments      |
|-------------|----------|---------------|----------------------|---------------|
| C_Encrypt   | RC2      | Multiple of 8 | Same as input length | No final part |
| C_Decrypt   | RC2      | Multiple of 8 | Same as input length | No final part |
| C_WrapKey   | RC2      | Any           | Input length rounded up to multiple of 8 | |
| C_UnwrapKey | RC2      | Multiple of 8 | Determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: RC2-CBC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC2 effective
number of bits.

### RC2-CBC with PKCS padding

RC2-CBC with PKCS padding, denoted **CKM_RC2_CBC_PAD**, is a mechanism for
single- and multiple-part encryption and decryption; key wrapping; and key
unwrapping, based on RSA Security’s block cipher RC2; cipher-block chaining mode
as defined in FIPS PUB 81; and the block cipher padding method detailed in PKCS
#7.

It has a parameter, a **CK_RC2_CBC_PARAMS** structure, where the first field
indicates the effective number of bits in the RC2 search space, and the next
field is the initialization vector.

The PKCS padding in this mechanism allows the length of the plaintext value to
be recovered from the ciphertext value.  Therefore, when unwrapping keys with
this mechanism, no value should be specified for the **CKA_VALUE_LEN**
attribute.

In addition to being able to wrap and unwrap secret keys, this mechanism MAY
wrap and unwrap RSA, Diffie-Hellman, X9.42 Diffie-Hellman, EC (also related to
ECDSA) and DSA private keys (see [PKCS #11-Curr], Miscellaneous simple key
derivation mechanisms for details).   The entries in the table below for data
length constraints when wrapping and unwrapping keys do not apply to wrapping
and unwrapping private keys.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length  | Output length                            |
|-------------|----------|---------------|------------------------------------------|
| C_Encrypt   | RC2      | Any           | Input length rounded up to multiple of 8 |
| C_Decrypt   | RC2      | Multiple of 8 | Between 1 and 8 bytes shorter than input length |
| C_WrapKey   | RC2      | Any           | Input length rounded up to multiple of 8 |
| C_UnwrapKey | RC2      | Multiple of 8 | Between 1 and 8 bytes shorter than input length |
table: RC2-CBC with PKCS Padding: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC2 effective
number of bits.

### General-length RC2-MAC

General-length RC2-MAC, denoted **CKM_RC2_MAC_GENERAL**, is a mechanism for
single- and multiple-part signatures and verification, based on RSA Security’s
block cipher RC2 and data authorization as defined in FIPS PUB 113.

It has a parameter, a **CK_RC2_MAC_GENERAL_PARAMS** structure, which specifies
the effective number of bits in the RC2 search space and the output length
desired from the mechanism.

The output bytes from this mechanism are taken from the start of the final RC2
cipher block produced in the MACing process.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length | Signature length                |
|----------|----------|-------------|---------------------------------|
| C_Sign   | RC2      | Any         | 0-8, as specified in parameters |
| C_Verify | RC2      | Any         | 0-8, as specified in parameters |
table: General-length RC2-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC2 effective
number of bits.

### RC2-MAC

RC2-MAC, denoted by **CKM_RC2_MAC**, is a special case of the general-length
RC2-MAC mechanism (see General-length RC2-MAC).  Instead of taking a
**CK_RC2_MAC_GENERAL_PARAMS** parameter, it takes a **CK_RC2_PARAMS** parameter,
which only contains the effective number of bits in the RC2 search space.
RC2-MAC produces and verifies 4-byte MACs.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type | Data length | Signature length |
|----------|----------|-------------|------------------|
| C_Sign   | RC2      | Any         | 4                |
| C_Verify | RC2      | Any         | 4                |
table: RC2-MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC2 effective
number of bits.
