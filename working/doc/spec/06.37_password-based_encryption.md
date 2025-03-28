## PKCS #5 and PKCS #5-style password-based encryption (PBE)

The mechanisms in this section are for generating keys and IVs for performing
password-based encryption. The method used to generate keys and IVs is specified
in [PKCS #5].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_PBE_SHA1_DES3_EDE_CBC            |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_PBE_SHA1_DES2_EDE_CBC            |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_PBA_SHA1_WITH_SHA1_HMAC          |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_PKCS5_PBKD2                      |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: PKCS 5 Mechanisms vs. Functions
	Functions


### Definitions

Mechanisms:

- CKM_PBE_SHA1_DES3_EDE_CBC
- CKM_PBE_SHA1_DES2_EDE_CBC
- CKM_PKCS5_PBKD2
- CKM_PBA_SHA1_WITH_SHA1_HMAC

### Password-based encryption/authentication mechanism parameters

#### CK_PBE_PARAMS
\  

**CK_PBE_PARAMS** is a structure which provides all of the necessary information
required by the **CKM_PBE** mechanisms (see [PKCS #5] and [PKCS #12] for
information on the PBE generation mechanisms) and the
**CKM_PBA_SHA1_WITH_SHA1_HMAC** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_PBE_PARAMS {
	CK_BYTE_PTR	pInitVector;
	CK_UTF8CHAR_PTR	pPassword;
	CK_ULONG	ulPasswordLen;
	CK_BYTE_PTR	pSalt;
	CK_ULONG	ulSaltLen;
	CK_ULONG	ulIteration;
}	CK_PBE_PARAMS;
~~~

The fields of the structure have the following meanings:

_pInitVector_
: pointer to the location that receives the 8-byte initialization vector (IV),
  if an IV is required;

_pPassword_
: points to the password to be used in the PBE key generation;

_ulPasswordLen_
: length in bytes of the password information;

_pSalt_
: points to the salt to be used in the PBE key generation;

_ulSaltLen_
: length in bytes of the salt information;

_ulIteration_
: number of iterations required for the generation.

**CK_PBE_PARAMS_PTR** is a pointer to a CK_PBE_PARAMS.

### PKCS #5 PBKDF2 key generation mechanism parameters

#### CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE
\  

**CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE** is used to indicate the
Pseudo-Random Function (PRF) used to generate key bits using PKCS #5 PBKDF2. It
is defined as follows:

~~~{.c}
typedef CK_ULONG CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE;
~~~

The following PRFs are defined in [PKCS #5] v2.1. The following table lists the
defined functions.

| PRF Identifier                  | Value        | Parameter Type         |
|---------------------------------|--------------|------------------------|
| CKP_PKCS5_PBKD2_HMAC_SHA1       | 0x00000001UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
| CKP_PKCS5_PBKD2_HMAC_GOSTR3411  | 0x00000002UL | This PRF uses GOST R34.11-94 hash to produce secret key value. _pPrfData_ should point to DER-encoded OID, indicating GOSTR34.11-94 parameters. _ulPrfDataLen_ holds encoded OID length in bytes. If _pPrfData_ is set to NULL_PTR, then id-GostR3411-94-CryptoProParamSet parameters will be used ([RFC 4357], 11.2), and _ulPrfDataLen_ must be 0. |
| CKP_PKCS5_PBKD2_HMAC_SHA224     | 0x00000003UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
| CKP_PKCS5_PBKD2_HMAC_SHA256     | 0x00000004UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
| CKP_PKCS5_PBKD2_HMAC_SHA384     | 0x00000005UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
| CKP_PKCS5_PBKD2_HMAC_SHA512     | 0x00000006UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
| CKP_PKCS5_PBKD2_HMAC_SHA512_224 | 0x00000007UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
| CKP_PKCS5_PBKD2_HMAC_SHA512_256 | 0x00000008UL | No Parameter. pPrfData must be NULL and ulPrfDataLen must be zero. |
table: PKCS #5 PBKDF2 Key Generation: Pseudo-random functions

**CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE_PTR** is a pointer to a
**CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE**.

#### CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE
\  

**CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE** is used to indicate the source of the salt
value when deriving a key using PKCS #5 PBKDF2. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE;
~~~

The following salt value sources are defined in [PKCS #5] v2.1. The following
table lists the defined sources along with the corresponding data type for the
_pSaltSourceData_ field in the **CK_PKCS5_PBKD2_PARAMS2** structure defined
below.

| Source Identifier  | Value      | Data Type                            |
|--------------------|------------|--------------------------------------|
| CKZ_SALT_SPECIFIED | 0x00000001 | Array of CK_BYTE containing the value of the salt value. |
table: PKCS #5 PBKDF2 Key Generation: Salt sources

**CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE_PTR** is a pointer to a
**CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE**.

#### CK_PKCS5_PBKD2_PARAMS2
\  

**CK_PKCS5_PBKD2_PARAMS2** is a structure that provides the parameters to the
**CKM_PKCS5_PBKD2** mechanism. The structure is defined as follows:

~~~{.c}
typedef struct CK_PKCS5_PBKD2_PARAMS2 {
	CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE	saltSource;
	CK_VOID_PTR	pSaltSourceData;
	CK_ULONG	ulSaltSourceDataLen;
	CK_ULONG	iterations;
	CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE	prf;
	CK_VOID_PTR	pPrfData;
	CK_ULONG	ulPrfDataLen;
	CK_UTF8CHAR_PTR	pPassword;
	CK_ULONG	ulPasswordLen;
}	CK_PKCS5_PBKD2_PARAMS2;
~~~

The fields of the structure have the following meanings:

_saltSource_
: source of the salt value

_pSaltSourceData_
: data used as the input for the salt source

_ulSaltSourceDataLen _
: length of the salt source input

_iterations_
: number of iterations to perform when generating each block of random data

_prf _
: pseudo-random function used to generate the key

_pPrfData_
: data used as the input for PRF in addition to the salt value

_ulPrfDataLen_
: length of the input data for the PRF

_pPassword_
: points to the password to be used in the PBE key generation

_ulPasswordLen_
: length in bytes of the password information

**CK_PKCS5_PBKD2_PARAMS2_PTR** is a pointer to a **CK_PKCS5_PBKD2_PARAMS2**.

### PKCS #5 PBKD2 key generation

PKCS #5 PBKDF2 key generation, denoted **CKM_PKCS5_PBKD2**, is a mechanism used
for generating a secret key from a password and a salt value. This functionality
is defined in [PKCS #5] as PBKDF2.

It has a parameter, a **CK_PKCS5_PBKD2_PARAMS2** structure. The parameter
specifies the salt value source, pseudo-random function, and iteration count
used to generate the new key.

Since this mechanism can be used to generate any type of secret key, new key
templates must contain the **CKA_KEY_TYPE** and **CKA_VALUE_LEN** attributes. If
the key type has a fixed length the **CKA_VALUE_LEN** attribute may be omitted.
