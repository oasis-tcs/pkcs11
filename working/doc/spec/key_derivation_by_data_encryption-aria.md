## Key derivation by data encryption - ARIA

These mechanisms allow derivation of keys using the result of an encryption
operation as the key value. They are for use with the **C_DeriveKey** function.

### Definitions

Mechanisms:

- CKM_ARIA_ECB_ENCRYPT_DATA
- CKM_ARIA_CBC_ENCRYPT_DATA

~~~{.c}
typedef struct CK_ARIA_CBC_ENCRYPT_DATA_PARAMS {
 CK_BYTE      iv[16];
  CK_BYTE_PTR  pData;
  CK_ULONG     length;
} CK_ARIA_CBC_ENCRYPT_DATA_PARAMS;

typedef CK_ARIA_CBC_ENCRYPT_DATA_PARAMS CK_PTR CK_ARIA_CBC_ENCRYPT_DATA_PARAMS_PTR;
~~~

### Mechanism Parameters

Uses **CK_ARIA_CBC_ENCRYPT_DATA_PARAMS**, and **CK_KEY_DERIVATION_STRING_DATA**. 

| Mechanism                 | Description                                |
|---------------------------|--------------------------------------------|
| CKM_ARIA_ECB_ENCRYPT_DATA | Uses CK_KEY_DERIVATION_STRING_DATA structure. Parameter is the data to be encrypted and must be a multiple of 16 long. |
| CKM_ARIA_CBC_ENCRYPT_DATA | Uses CK_ARIA_CBC_ENCRYPT_DATA_PARAMS. Parameter is an 16 byte IV value followed by the data. The data value part must be a multiple of 16 bytes long. |
table: Mechanism Parameters for Aria-based key derivation
