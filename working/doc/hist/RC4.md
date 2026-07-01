## RC4

### Definitions

This section defines the key type “CKK_RC4” for type CK_KEY_TYPE as used in the
CKA_KEY_TYPE attribute of key objects.

Mechanisms:

- CKM_RC4_KEY_GEN
- CKM_RC4

### RC4 secret key objects

RC4 secret key objects (object class **CKO_SECRET_KEY**, key type **CKK_RC4**)
hold RC4 keys.  The following table defines the RC4 secret key object
attributes, in addition to the common attributes defined for this object class:

| Attribute           | Data type  | Meaning                      |
|---------------------|------------|------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (1 to 256 bytes)   |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value |
table: RC4 Secret Key Object Attributes

Refer to [PKCS #11-Base] table 11 for footnotes

The following is a sample template for creating an RC4 secret key object:

```c
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_RC4;
CK_UTF8CHAR label[] = “An RC4 secret key object”; 
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

### RC4 key generation

The RC4 key generation mechanism, denoted **CKM_RC4_KEY_GEN**, is a key
generation mechanism for RSA Security’s stream cipher RC4.

It does not have a parameter.

The mechanism generates RC4 keys with a particular length in bytes, as specified
in the **CKA_VALUE_LEN** attribute of the template for the key.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key.  Other attributes supported by the RC4 key type
(specifically, the flags indicating which functions the key supports) MAY be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC4 key sizes, in
bits.

### RC4 mechanism

RC4, denoted **CKM_RC4**, is a mechanism for single- and multiple-part
encryption and decryption based on RSA Security’s stream cipher RC4.

It does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function    | Key type | Input length  | Output length        | Comments      |
|-------------|----------|---------------|----------------------|---------------|
| C_Encrypt   | RC4      | Any           | Same as input length | No final part |
| C_Decrypt   | RC4      | Any           | Same as input length | No final part |
table: RC4: Key and Data Length

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of RC4 key sizes, in
bits.
