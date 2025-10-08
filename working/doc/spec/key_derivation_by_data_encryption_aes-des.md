## Key derivation by data encryption – DES & AES

These mechanisms allow derivation of keys using the result of an encryption
operation as the key value. They are for use with the **C_DeriveKey** function.

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_DES_ECB_ENCRYPT_DATA             |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES_CBC_ENCRYPT_DATA             |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_ECB_ENCRYPT_DATA            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DES3_CBC_ENCRYPT_DATA            |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_ECB_ENCRYPT_DATA             |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_AES_CBC_ENCRYPT_DATA             |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Key derivation by data encryption Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_DES_ECB_ENCRYPT_DATA
- CKM_DES_CBC_ENCRYPT_DATA
- CKM_DES3_ECB_ENCRYPT_DATA
- CKM_DES3_CBC_ENCRYPT_DATA
- CKM_AES_ECB_ENCRYPT_DATA
- CKM_AES_CBC_ENCRYPT_DATA

~~~{.c}
typedef struct CK_DES_CBC_ENCRYPT_DATA_PARAMS {
	CK_BYTE	iv[8];
	CK_BYTE_PTR	pData;
	CK_ULONG	length;
}	CK_DES_CBC_ENCRYPT_DATA_PARAMS;

typedef CK_DES_CBC_ENCRYPT_DATA_PARAMS CK_PTR CK_DES_CBC_ENCRYPT_DATA_PARAMS_PTR;

typedef struct CK_AES_CBC_ENCRYPT_DATA_PARAMS {
	CK_BYTE	iv[16];
	CK_BYTE_PTR	pData;
	CK_ULONG	length;
}	CK_AES_CBC_ENCRYPT_DATA_PARAMS;

typedef CK_AES_CBC_ENCRYPT_DATA_PARAMS CK_PTR
CK_AES_CBC_ENCRYPT_DATA_PARAMS_PTR;
~~~

### Mechanism Parameters

Uses CK_KEY_DERIVATION_STRING_DATA as defined in section [6.43.2]

| Mechanism               | Meaning                                      |
|-------------------------|----------------------------------------------|
CKM_DES_ECB_ENCRYPT_DATA CKM_DES3_ECB_ENCRYPT_DATA | Uses CK_KEY_DERIVATION_STRING_DATA structure. Parameter is the data to be encrypted and must be a multiple of 8 bytes long. |
CKM_AES_ECB_ENCRYPT_DATA  | Uses CK_KEY_DERIVATION_STRING_DATA structure. Parameter is the data to be encrypted and must be a multiple of 16 long. |
CKM_DES_CBC_ENCRYPT_DATA CKM_DES3_CBC_ENCRYPT_DATA | Uses CK_DES_CBC_ENCRYPT_DATA_PARAMS. Parameter is an 8 byte IV value followed by the data. The data value part must be a multiple of 8 bytes long. |
CKM_AES_CBC_ENCRYPT_DATA  | Uses CK_AES_CBC_ENCRYPT_DATA_PARAMS. Parameter is an 16 byte IV value followed by the data. The data value part must be a multiple of 16 bytes long. |
table: Mechanism Parameters

### Mechanism Description

The mechanisms will function by performing the encryption over the data provided
using the base key. The resulting ciphertext shall be used to create the key
value of the resulting key. If not all the ciphertext is used then the part
discarded will be from the trailing end (least significant bytes) of the
ciphertext data. The derived key shall be defined by the attribute template
supplied but constrained by the length of ciphertext available for the key value
and other normal PKCS11 derivation constraints. 

Attribute template handling, attribute defaulting and key value preparation will
operate as per the SHA-1 Key Derivation mechanism in section [6.20.5].

If the data is too short to make the requested key then the mechanism returns
**CKR_DATA_LEN_RANGE**.
