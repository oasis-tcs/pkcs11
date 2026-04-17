## General block cipher

### Definitions

For brevity’s sake, the mechanisms for the DES, CAST, CAST3, CAST128, IDEA and
CDMF block ciphers are described together here.  Each of these ciphers ha the
following mechanisms, which are described in a templatized form.

This section defines the key types “CKK_DES”, “CKK_CAST”, “CKK_CAST3”,
“CKK_CAST128”, “CKK_IDEA” and “CKK_CDMF” for type CK_KEY_TYPE as used in the
CKA_KEY_TYPE attribute of key objects.

Mechanisms:

- CKM_DES_KEY_GEN
- CKM_DES_ECB
- CKM_DES_CBC
- CKM_DES_MAC
- CKM_DES_MAC_GENERAL
- CKM_DES_CBC_PAD
- CKM_CDMF_KEY_GEN
- CKM_CDMF_ECB
- CKM_CDMF_CBC
- CKM_CDMF_MAC
- CKM_CDMF_MAC_GENERAL
- CKM_CDMF_CBC_PAD
- CKM_DES_OFB64
- CKM_DES_OFB8
- CKM_DES_CFB64
- CKM_DES_CFB8
- CKM_CAST_KEY_GEN
- CKM_CAST_ECB
- CKM_CAST_CBC
- CKM_CAST_MAC
- CKM_CAST_MAC_GENERAL
- CKM_CAST_CBC_PAD
- CKM_CAST3_KEY_GEN
- CKM_CAST3_ECB
- CKM_CAST3_CBC
- CKM_CAST3_MAC
- CKM_CAST3_MAC_GENERAL
- CKM_CAST3_CBC_PAD
- CKM_CAST128_KEY_GEN
- CKM_CAST128_ECB
- CKM_CAST128_CBC
- CKM_CAST128_MAC
- CKM_CAST128_MAC_GENERAL
- CKM_CAST128_CBC_PAD
- CKM_IDEA_KEY_GEN
- CKM_IDEA_ECB
- CKM_IDEA_MAC
- CKM_IDEA_MAC_GENERAL
- CKM_IDEA_CBC_PAD

### DES secret key objects

DES secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_DES**)
hold single-length DES keys.  The following table defines the DES secret key
object attributes, in addition to the common attributes defined for this object
class:

| Attribute           | Data type  | Meaning                  |
|---------------------|------------|--------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (8 bytes long) |
table: DES Secret Key Object

Refer to [PKCS #11-Base] table 11 for footnotes

DES keys MUST have their parity bits properly set as described in FIPS PUB 46-3.
Attempting to create or unwrap a DES key with incorrect parity MUST return an
error.

The following is a sample template for creating a DES secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_DES;
CK_UTF8CHAR label[] = “A DES secret key object”;
CK_BYTE value[8] = {…};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_ENCRYPT, &true, sizeof(true)},
	{CKA_VALUE, value, sizeof(value}
};
```

CKA_CHECK_VALUE:  The value of this attribute is derived from the key object by
taking the first three bytes of the ECB encryption of a single block of null
(0x00) bytes, using the default cipher associated with the key type of the
secret key object.

### CAST secret key objects

CAST secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_CAST**)
hold CAST keys.  The following table defines the CAST secret key object
attributes, in addition to the common attributes defined for this object class:

| Attribute             | Data type  | Meaning                      |
|-----------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^   | Byte array | Key value (1 to 8 bytes)     |
| CKA_VALUE_LEN ^2,3,6^ | CK_ULONG   | Length in bytes of key value |
table: CAST Secret Key Object Attributes

Refer to [PKCS #11-Base] table 11 for footnotes

The following is a sample template for creating a CAST secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_CAST;
CK_UTF8CHAR label[] = “A CAST secret key object”;
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

### CAST3 secret key objects

CAST3 secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_CAST3**) hold CAST3 keys.  The following table defines the CAST3 secret
key object attributes, in addition to the common attributes defines for this
object class:

| Attribute             | Data type  | Meaning                      |
|-----------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^   | Byte array | Key value (1 to 8 bytes)     |
| CKA_VALUE_LEN ^2,3,6^ | CK_ULONG   | Length in bytes of key value |
table: CAST3 Secret Key Object Attributes

Refer to [PKCS #11-Base] table 11 for footnotes

The following is a sample template for creating a CAST3 secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_CAST3;
CK_UTF8CHAR label[] = “A CAST3 secret key object”;
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

### CAST128 secret key objects

CAST128 secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_CAST128**) hold CAST128 keys.  The following table defines the CAST128
secret key object attributes, in addition to the common attributes defines for
this object class:

| Attribute             | Data type  | Meaning                      |
|-----------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^   | Byte array | Key value (1 to 16 bytes)    |
| CKA_VALUE_LEN ^2,3,6^ | CK_ULONG   | Length in bytes of key value |
table: CAST128 Secret Key Object Attributes

Refer to [PKCS #11-Base] table 11 for footnotes

The following is a sample template for creating a CAST128 secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_CAST128;
CK_UTF8CHAR label[] = “A CAST128 secret key object”;
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

### IDEA secret key objects

IDEA secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_IDEA**)
hold IDEA keys.  The following table defines the IDEA secret key object
attributes, in addition to the common attributes defines for this object class:

| Attribute           | Data type  | Meaning                   |
|---------------------|------------|---------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (16 bytes long) |
table: IDEA Secret Key Object

Refer to [PKCS #11-Base] table 11 for footnotes

The following is a sample template for creating an IDEA secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_IDEA;
CK_UTF8CHAR label[] = “An IDEA secret key object”;
CK_BYTE value[16] = {…};
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

### CDMF secret key objects

IDEA secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_CDMF**) hold CDMF keys.  The following table defines the CDMF secret key
object attributes, in addition to the common attributes defines for this object
class:

| Attribute           | Data type  | Meaning                  |
|---------------------|------------|--------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (8 bytes long) |
table: CDMF Secret Key Object

Refer to [PKCS #11-Base] table 11 for footnotes

CDMF keys MUST have their parity bits properly set in exactly the same fashion
described for DES keys in FIPS PUB 46-3.  Attempting to create or unwrap a CDMF
key with incorrect parity MUST return an error.

The following is a sample template for creating a CDMF secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_CDMF;
CK_UTF8CHAR label[] = “A CDMF secret key object”;
CK_BYTE value[8] = {…};
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

### General block cipher mechanism parameters

#### CK_MAC_GENERAL_PARAMS; CK_MAC_GENERAL_PARAMS_PTR
\

**CK_MAC_GENERAL_PARAMS** provides the parameters to the general-length MACing
mechanisms of the DES, DES3 (triple-DES), CAST, CAST3, CAST128, IDEA, CDMF and
AES ciphers.  It also provides the parameters to the general-length HMACing
mechanisms (i.e., MD2, MD5, SHA-1, SHA-256, SHA-384, SHA-512, RIPEMD-128 and
RIPEMD-160) and the two SSL 3.0 MACing mechanisms, (i.e., MD5 and SHA-1).  It
holds the length of the MAC that these mechanisms produce.  It is defined as
follows:

```c
typedef CK_ULONG CK_MAC_GENERAL_PARAMS;
```

**CK_MAC_GENERAL_PARAMS_PTR** is a pointer to a **CK_MAC_GENERAL_PARAMS**.

### General block cipher key generation

Cipher \<NAME\> has a key generation mechanism, “\<NAME\> key generation”, denoted
by **CKM_**\<NAME\>**\_KEY_GEN**.

This mechanism does not have a parameter.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key.  Other attributes supported by the key type
(specifically, the flags indicating which functions the key supports) MAY be
specified in the template for the key, or else are assigned default initial
values.

When DES keys or CDMF keys are generated, their parity bits are set properly, as
specified in FIPS PUB 46-3.  Similarly, when a triple-DES key is generated, each
of the DES keys comprising it has its parity bits set properly.

When DES or CDMF keys are generated, it is token-dependent whether or not it is
possible for “weak” or “semi-weak” keys to be generated.  Similarly, when
triple-DES keys are generated, it is token-dependent whether or not it is
possible for any of the component DES keys to be “weak” or “semi-weak” keys.

When CAST, CAST3, or CAST128 keys are generated, the template for the secret key
must specify a **CKA_VALUE_LEN** attribute.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure MAY be used.  The CAST, CAST3, and CAST128
ciphers have variable key sizes, and so for the key generation mechanisms for
these ciphers, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of key sizes, in
bytes.  For the DES, DES3 (triple-DES), IDEA and CDMF ciphers, these fields and
not used.

### General block cipher ECB

Cipher \<NAME\> has an electronic codebook mechanism, “\<NAME\>-ECB”, denoted
**CKM_**\<NAME\>**\_ECB**.  It is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping with <NAME>.

It does not have a parameter.

This mechanism MAY wrap and unwrap any secret key.  Of course, a particular
token MAY not be able to wrap/unwrap every secret key that it supports.  For
wrapping, the mechanism encrypts the value of the **CKA_VALUE** attribute of the
key that is wrapped, padded on the trailing end with null bytes so that the
resulting length is a multiple of \<NAME\>’s blocksize.  The output data is the
same length as the padded input data.  It does not wrap the key type, key length
or any other information about the key; the application must convey these
separately.

For unwrapping, the mechanism decrypts the wrapped key, and truncates the result
according to the **CKA_KEY_TYPE** attribute of the template and, if it has one,
and the key type supports it, the **CKA_VALUE_LEN** attribute of the template.
The mechanism contributes the result as the **CKA_VALUE** attribute of the new
key; other attributes required by the key must be specified in the template.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length          | Output length        | Comments      |
|-------------|----------|-----------------------|----------------------|---------------|
| C_Encrypt   | \<NAME\> | Multiple of blocksize | Same as input length | No final part |
| C_Decrypt   | \<NAME\> | Multiple of blocksize | Same as input length | No final part |
| C_WrapKey   | \<NAME\> | Any                   | Input length rounded up to multiple of blocksize | |
| C_UnwrapKey | \<NAME\> | Any                   | Determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: General Block Cipher ECB: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySIze_ fields of the
**CK_MECHANISM_INFO** structure MAY be used.  The CAST, CAST3, and CAST128
ciphers have variable key sizes, and so for these ciphers, the _ulMinKeySize_
and _ulMaxKeySize_ fields of the **CK_MECHANISM_INFO** structure specify the
supported range of key sizes, in bytes.  For the DES, DES3 (triple-DES), IDEA
and CDMF ciphers, these fields are not used.

### General block cipher CBC

Cipher \<NAME\> has a cipher-block chaining mode, “\<NAME\>-CBC”, denoted
**CKM_**\<NAME\>**\_CBC**. It is a mechanism for single- and multiple-part
encryption and decryption; key wrapping; and key unwrapping with <NAME>.

It has a parameter, an initialization vector for cipher block chaining mode.
The initialization vector has the same length as \<NAME\>’s blocksize.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length          | Output length        | Comments      |
|-------------|----------|-----------------------|------------------------------------------------------------|---------------|
| C_Encrypt   | \<NAME\> | Multiple of blocksize | Same as input length | No final part |
| C_Decrypt   | \<NAME\> | Multiple of blocksize | Same as input length | No final part |
| C_WrapKey   | \<NAME\> | Any                   | Input length rounded up to multiple of blocksize | |
| C_UnwrapKey | \<NAME\> | Any                   | Determined by type of key being unwrapped or CKA_VALUE_LEN | |
table: General Block Cipher CBC; Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure MAY be used.  The CAST, CAST3, and CAST128
ciphers have variable key sizes, and so for these ciphers, the _ulMinKeySize_
and _ulMaxKeySize_ fields of the **CK_MECHANISM_INFO** structure specify the
supported range of key sizes, in bytes.  For the DES, DES3 (triple-DES), IDEA,
and CDMF ciphers, these fields are not used.

### General block cipher CBC with PCKS padding

Cipher \<NAME\> has a cipher-block chaining mode with PKCS padding,
“\<NAME\>-CBC with PKCS padding”, denoted **CKM_**\<NAME\>**\_CBC_PAD**.  It is
a mechanism for single- and multiple-part encryption and decryption; key
wrapping; and key unwrapping with \<NAME\>.  All ciphertext is padded with PKCS
padding.

It has a parameter, an initialization vector for cipher block chaining mode.
The initialization vector has the same length as \<NAME\>’s blocksize.

The PKCS padding in this mechanism allows the length of the plaintext value to
be recovered from the ciphertext value.  Therefore, when unwrapping keys with
this mechanism, no value should be specified for the **CKA_VALUE_LEN**
attribute.

In addition to being able to wrap and unwrap secret keys, this mechanism MAY
wrap and unwrap RSA, Diffie-Hellman, X9.42 Diffie-Hellman, EC (also related to
ECDSA) and DSA private keys.  The entries in the table below for data length
constraints when wrapping and unwrapping keys to not apply to wrapping and
unwrapping private keys.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length          | Output length                        |
|-------------|----------|-----------------------|--------------------------------------|
| C_Encrypt   | \<NAME\> | Any                   | Input length rounded up to multiple of blocksize        |
| C_Decrypt   | \<NAME\> | Multiple of blocksize | Between 1 and blocksize bytes shorter than input length |
| C_WrapKey   | \<NAME\> | Any                   | Input length rounded up to multiple of blocksize        |
| C_UnwrapKey | \<NAME\> | Multiple of blocksize | Between 1 and blocksize bytes shorter than input length |
table: General Block Cipher CBC with PKCS Padding:  Key and Data Length

For this mechanism, the _ulMinKeySIze_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure MAY be used.  The CAST, CAST3 and CAST128
ciphers have variable key sizes, and so for these ciphers, the _ulMinKeySize_
and _ulMaxKeySize_ fields of the **CK_MECHANISM_INFO** structure specify the
supported range of key sizes, in bytes.  For the DES, DES3 (triple-DES), IDEA,
and CDMF ciphers, these fields are not used.

### General-length general block cipher MAC

Cipher \<NAME\> has a general-length MACing mode, “General-length \<NAME\>-MAC”,
denoted **CKM_**\<NAME\>**\_MAC_GENERAL**.  It is a mechanism for single-and
multiple-part signatures and verification, based on the \<NAME\> encryption
algorithm and data authentication as defined in FIPS PUB 113.

It has a parameter, a **CK_MAC_GENERAL_PARAMS**, which specifies the size of the
output.

The output bytes from this mechanism are taken from the start of the final
cipher block produced in the MACing process.

Constraints on key types and the length of input and output data are summarized
in the following table:

| Function | Key type | Data length | Signature length                     |
|----------|----------|-------------|--------------------------------------|
| C_Sign   | \<NAME\> | Any         | 0-blocksize, depending on parameters |
| C_Verify | \<NAME\> | Any         | 0-blocksize, depending on parameters |
table: General-length General Block Cipher MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure MAY be used.  The CAST, CAST3, and CAST128
ciphers have variable key sizes, and so for these ciphers, the _ulMinKeySize_
and _ulMaxKeySize_ fields of the **CK_MECHANISM_INFO** structure specify the
supported range of key sizes, in bytes.  For the DES, DES3 (triple-DES), IDEA
and CDMF ciphers, these fields are not used.

### General block cipher MAC

Cipher \<NAME\> has a MACing mechanism, “\<NAME\>-MAC”, denoted
**CKM_**\<NAME\>**\_MAC**.  This mechanism is a special case of the
**CKM_**\<NAME\>**\_MAC_GENERAL** mechanism described above.  It produces an
output of size half as large as <NAME>’s blocksize.

This mechanism has no parameters.

Constraints on key types and the length of data are summarized in the following table:

| Function | Key type | Data length | Signature length |
|----------|----------|-------------|------------------|
| C_Sign   | \<NAME\> | Any         | [blocksize/2]    |
| C_Verify | \<NAME\> | Any         | [blocksize/2]    |
table: General Block cipher MAC: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure MAY be used.  The CAST, CAST3, and CAST128
ciphers have variable key sizes, and so for these ciphers, the _ulMinKeySize_
and _ulMaxKeySize_ fields of the **CK_MECHANISM_INFO** structure specify the
supported range of key sizes, in bytes.  For the DES, DES3 (triple-DES), IDEA
and CDMF ciphers, these fields are not used.
