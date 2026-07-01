## SKIPJACK

### Definitions

This section defines the key type “CKK_SKIPJACK” for type CK_KEY_TYPE as used in
the CKA_KEY_TYPE attribute of key objects.

Mechanisms:

- CKM_SKIPJACK_KEY_GEN
- CKM_SKIPJACK_ECB64
- CKM_SKIPJACK_CBC64
- CKM_SKIPJACK_OFB64
- CKM_SKIPJACK_CFB64
- CKM_SKIPJACK_CFB32
- CKM_SKIPJACK_CFB16
- CKM_SKIPJACK_CFB8
- CKM_SKIPJACK_WRAP
- CKM_SKIPJACK_PRIVATE_WRAP
- CKM_SKIPJACK_RELAYX

### SKIPJACK secret key objects

SKIPJACK secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_SKIPJACK**) holds a single-length MEK or a TEK.  The following table
defines the SKIPJACK secret object attributes, in addition to the common
attributes defined for this object class:

| Attribute           | Data type  | Meaning                   |
|---------------------|------------|---------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (12 bytes long) |
table: SKIPJACK Secret Key Object

Refer to [PKCS #11-Base] table 11 for footnotes

SKIPJACK keys have 16 checksum bits, and these bits must be properly set.
Attempting to create or unwrap a SKIPJACK key with incorrect checksum bits MUST
return an error.

It is not clear that any tokens exist (or ever will exist) which permit an
application to create a SKIPJACK key with a specified value.  Nonetheless, we
provide templates for doing so.

The following is a sample template for creating a SKIPJACK MEK secret key
object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_SKIPJACK;
CK_UTF8CHAR label[] = “A SKIPJACK MEK secret key object”; 
CK_BYTE value[12] = {…};
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

The following is a sample template for creating a SKIPJACK TEK secret key
object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_SKIPJACK;
CK_UTF8CHAR label[] = “A SKIPJACK TEK secret key object”;
CK_BYTE value[12] = {…};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_ENCRYPT, &true, sizeof(true)},
	{CKA_WRAP, &true, sizeof(true)},
	{CKA_VALUE, value, sizeof(value)}
};
```

### SKIPJACK mechanism parameters

#### CK_SKIPJACK_PRIVATE_WRAP_PARAMS; CK_SKIPJACK_PRIVATE_WRAP_PARAMS_PTR
\

**CK_SKIPJACK_PRIVATE_WRAP_PARAMS** is a structure that provides the parameters
to the **CKM_SKIPJACK_PRIVATE_WRAP** mechanism.  It is defined as follows:

```c
typedef struct  CK_SKIPJACK_PRIVATE_WRAP_PARAMS {
	CK_ULONG ulPasswordLen;
	CK_BYTE_PTR pPassword;
	CK_ULONG ulPublicDataLen;
	CK_BYTE_PTR pPublicData;
	CK_ULONG ulPandGLen;
	CK_ULONG ulQLen;
	CK_ULONG ulRandomLen;
	CK_BYTE_PTR pRandomA;
	CK_BYTE_PTR pPrimeP;
	CK_BYTE_PTR pBaseG;
	CK_BYTE_PTR pSubprimeQ;
} CK_SKIPJACK_PRIVATE_WRAP_PARAMS;
```

The fields of the structure have the following meanings:

_ulPasswordLen_
: length of the password

_pPassword_
: pointer to the buffer which contains the user-supplied password

_ulPublicDataLen_
: other party’s key exchange public key size

_pPublicData_
: pointer to other party’s key exchange public key value

_ulPandGLen_
: length of prime and base values

_ulQLen_
: length of subprime value

_ulRandomLen_
: size of random Ra, in bytes

_pPrimeP_
: pointer to Prime, p, value

_pBaseG_
: pointer to Base, b, value

_pSubprimeQ_
: pointer to Subprime, q, value

**CK_SKIPJACK_PRIVATE_WRAP_PARAMS_PTR** is a pointer to a **CK_PRIVATE_WRAP_PARAMS**.

#### CK_SKIPJACK_RELAYX_PARAMS; CK_SKIPJACK_RELAYX_PARAMS_PTR
\

**CK_SKIPJACK_RELAYX_PARAMS** is a structure that provides the parameters to the
**CKM_SKIPJACK_RELAYX** mechanism.  It is defined as follows:

```c
typedef struct CK_SKIPJACK_RELAYX_PARAMS {
	CK_ULONG ulOldWrappedXLen;
	CK_BYTE_PTR pOldWrappedX;
	CK_ULONG ulOldPasswordLen;
	CK_BYTE_PTR pOldPassword;
	CK_ULONG ulOldPublicDataLen;
	CK_BYTE_PTR pOldPublicData;
	CK_ULONG ulOldRandomLen;
	CK_BYTE_PTR pOldRandomA;
	CK_ULONG ulNewPasswordLen;
	CK_BYTE_PTR pNewPassword;
	CK_ULONG ulNewPublicDataLen;
	CK_BYTE_PTR pNewPublicData;
	CK_ULONG ulNewRandomLen;
	CK_BYTE_PTR pNewRandomA;
} CK_SKIPJACK_RELAYX_PARAMS;
```

The fields of the structure have the following meanings:

_ulOldWrappedLen_
: length of old wrapped key in bytes

_pOldWrappedX_
: pointer to old wrapper key

_ulOldPasswordLen_
: length of the old password

_pOldPassword_
: pointer to the buffer which contains the old user-supplied password

_ulOldPublicDataLen_
: old key exchange public key size

_pOldPublicData_
: pointer to old key exchange public key value

_ulOldRandomLen_
: size of old random Ra in bytes

_pOldRandomA_
: pointer to old Ra data

_ulNewPasswordLen_
: length of the new password

_pNewPassword_
: pointer to the buffer which contains the new user-supplied password

_ulNewPublicDataLen_
: new key exchange public key size

_pNewPublicData_
: pointer to new key exchange public key value

_ulNewRandomLen_
: size of new random Ra in bytes

_pNewRandomA_
: pointer to new Ra data

**CK_SKIPJACK_RELAYX_PARAMS_PTR** is a pointer to a
**CK_SKIPJACK_RELAYX_PARAMS**.

### SKIPJACK key generation

The SKIPJACK key generation mechanism, denoted **CKM_SKIPJACK_KEY_GEN**, is a
key generation mechanism for SKIPJACK.  The output of this mechanism is called a
Message Encryption Key (MEK).

It does not have a parameter.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key.

### SKIPJACK-ECB64

SKIPJACK-ECB64, denoted **CKM_SKIPJACK_ECB64**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 64-bit electronic
codebook mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application cant specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
table: SKIPJACK-ECB64: Data and Length

### SKIPJACK-CBC64

SKIPJACK-CBC64, denoted **CKM_SKIPJACK_CBC64**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 64-bit output feedback
mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application MAY NOT specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
table: SKIPJACK-CBC64: Data and Length

### SKIPJACK-OFB64

SKIPJACK-OFB64, denoted **CKM_SKIPJACK_OFB64**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 64-bit output feedback
mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application MAY NOT specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
table: SKIPJACK-OFB64: Data and Length

### SKIPJACK-CFB64

SKIPJACK-CFB64, denoted **CKM_SKIPJACK_CFB64**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 64-bit cipher feedback
mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application MAY NOT specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 8 | Same as input length | No final part |
table: SKIPJACK-CFB64: Data and Length

### SKIPJACK-CFB32

SKIPJACK-CFB32, denoted **CKM_SKIPJACK_CFB32**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 32-bit cipher feedback
mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application MAY NOT specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 4 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 4 | Same as input length | No final part |
table: SKIPJACK-CFB32: Data and Length

### SKIPJACK-CFB16

SKIPJACK-CFB16, denoted **CKM_SKIPJACK_CFB16**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 16-bit cipher feedback
mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application MAY NOT specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 4 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 4 | Same as input length | No final part |
table: SKIPJACK-CFB16: Data and Length

### SKIPJACK-CFB8

SKIPJACK-CFB8, denoted **CKM_SKIPJACK_CFB8**, is a mechanism for single- and
multiple-part encryption and decryption with SKIPJACK in 8-bit cipher feedback
mode as defined in FIPS PUB 185.

It has a parameter, a 24-byte initialization vector.  During an encryption
operation, this IV is set to some value generated by the token – in other words,
the application MAY NOT specify a particular IV when encrypting.  It MAY, of
course, specify a particular IV when decrypting.

Constraints on key types and the length of data are summarized in the following
table:

| Function  | Key type | Input length  | Output length        | Comments      |
|-----------|----------|---------------|----------------------|---------------|
| C_Encrypt | SKIPJACK | Multiple of 4 | Same as input length | No final part |
| C_Decrypt | SKIPJACK | Multiple of 4 | Same as input length | No final part |
table: SKIPJACK-CFB8: Data and Length

### SKIPJACK-WRAP

The SKIPJACK-WRAP mechanism, denoted **CKM_SKIPJACK_WRAP**, is used to wrap and
unwrap a secret key (MEK).  It MAY wrap or unwrap SKIPJACK, BATON, and JUNIPER
keys.

It does not have a parameter.

### SKIPJACK-PRIVATE-WRAP

The SKIPJACK-PRIVATE-WRAP mechanism, denoted **CKM_SKIPJACK_PRIVATE_WRAP**, is
used to wrap and unwrap a private key.  It MAY wrap KEA and DSA private keys.

It has a parameter, a **CK_SKIPJACK_PRIVATE_WRAP_PARAMS** structure.

### SKIPJACK-RELAYX

The SKIPJACK-RELAYX mechanism, denoted **CKM_SKIPJACK_RELAYX**, is used with the
**C_WrapKey** function to “change the wrapping” on a private key which was
wrapped with the SKIPJACK-PRIVATE-WRAP mechanism (See Section  2.8.13).

It has a parameter, a **CK_SKIPJACK_RELAYX_PARAMS** structure.

Although the SKIPJACK-RELAYX mechanism is used with **C_WrapKey**, it differs
from other key-wrapping mechanisms.  Other key-wrapping mechanisms take a key
handle as one of the arguments to **C_WrapKey**; however for the SKIPJACK_RELAYX
mechanism, the [always invalid] value 0 should be passed as the key handle for
**C_WrapKey**, and the already-wrapped key should be passed in as part of the
**CK_SKIPJACK_RELAYX_PARAMS** structure.
