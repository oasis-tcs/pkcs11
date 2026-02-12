## OTP mechanisms and parameters

The following table shows, for the OTP mechanisms defined in this document,
their support by different cryptographic operations. For any particular token,
of course, a particular operation may well support only a subset of the
mechanisms listed. There is also no guarantee that a token that supports one
mechanism for some operation supports any other mechanism for any other
operation (or even supports that same mechanism for any other operation).

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SECURID_KEY_GEN                  |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SECURID                          |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HOTP_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_HOTP                             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ACTI_KEY_GEN                     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ACTI                             |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: OTP mechanisms vs. applicable functions

The remainder of this section will present in detail the OTP mechanisms and the
parameters that are supplied to them.

### CK_OTP_PARAM_TYPE

**CK_OTP_PARAM_TYPE** is a value that identifies an OTP parameter type. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_OTP_PARAM_TYPE;
~~~

The following **CK_OTP_PARAM_TYPE** types are defined:

| Parameter            | Data type  | Meaning                                |
|----------------------|------------|----------------------------------------|
| CK_OTP_PIN           | RFC 2279 string | A UTF8 string containing a PIN for use when computing or verifying PIN-based OTP values. |
| CK_OTP_CHALLENGE     | Byte array | Challenge to use when computing or verifying challenge-based OTP values. |
| CK_OTP_TIME          | RFC 2279 string | UTC time value in the form YYYYMMDDhhmmss to use when computing or verifying time-based OTP values. |
| CK_OTP_COUNTER       | Byte array | Counter value to use when computing or verifying counter-based OTP values. |
| CK_OTP_FLAGS         | CK_FLAGS   | Bit flags indicating the characteristics of the sought OTP as defined below. |
| CK_OTP_OUTPUT_LENGTH | CK_ULONG   | Desired output length (overrides any default value). A Cryptoki library will return **CKR_MECHANISM_PARAM_INVALID** if a provided length value is not supported. |
| CK_OTP_OUTPUT_FORMAT | CK_ULONG   | Returned OTP format (allowed values are the same as for CKA_OTP_FORMAT). This parameter is only intended for **C_Sign** output, see paragraphs below. When not present, the returned OTP format will be the same as the value of the CKA_OTP_FORMAT attribute for the key in question. |
| CK_OTP_VALUE         | Byte array | An actual OTP value. This parameter type is intended for **C_Sign** output, see paragraphs below. |
table: OTP parameter types

The following table defines the possible values for the CK_OTP_FLAGS type:

| Bit flag              | Mask       | Meaning                               |
|-----------------------|------------|---------------------------------------|
| CKF_NEXT_OTP          | 0x00000001 | True (i.e. set) if the OTP computation shall be for the next OTP, rather than the current one (current being interpreted in the context of the algorithm, e.g. for the current counter value or current time window). A Cryptoki library shall return **CKR_MECHANISM_PARAM_INVALID** if the CKF_NEXT_OTP flag is set and the OTP mechanism in question does not support the concept of “next” OTP or the library is not capable of generating the next OTP1. |
| CKF_EXCLUDE_TIME      | 0x00000002 | True (i.e. set) if the OTP computation must not include a time value. Will have an effect only on mechanisms that do include a time value in the OTP computation and then only if the mechanism (and token) allows exclusion of this value. A Cryptoki library shall return **CKR_MECHANISM_PARAM_INVALID** if exclusion of the value is not allowed. |
| CKF_EXCLUDE_COUNTER   | 0x00000004 | True (i.e. set) if the OTP computation must not include a counter value. Will have an effect only on mechanisms that do include a counter value in the OTP computation and then only if the mechanism (and token) allows exclusion of this value. A Cryptoki library shall return **CKR_MECHANISM_PARAM_INVALID** if exclusion of the value is not allowed. |
| CKF_EXCLUDE_CHALLENGE | 0x00000008 | True (i.e. set) if the OTP computation must not include a challenge. Will have an effect only on mechanisms that do include a challenge in the OTP computation and then only if the mechanism (and token) allows exclusion of this value. A Cryptoki library shall return **CKR_MECHANISM_PARAM_INVALID** if exclusion of the value is not allowed. |
| CKF_EXCLUDE_PIN       | 0x00000010 | True (i.e. set) if the OTP computation must not include a PIN value. Will have an effect only on mechanisms that do include a PIN in the OTP computation and then only if the mechanism (and token) allows exclusion of this value. A Cryptoki library shall return **CKR_MECHANISM_PARAM_INVALID** if exclusion of the value is not allowed. |
| CKF_USER_FRIENDLY_OTP | 0x00000020 | True (i.e. set) if the OTP returned shall be in a form suitable for human consumption. If this flag is set, and the call is successful, then the returned CK_OTP_VALUE shall be a UTF8-encoded printable string. A Cryptoki library shall return **CKR_MECHANISM_PARAM_INVALID** if this flag is set when CKA_OTP_USER_FRIENDLY_MODE for the key in question is CK_FALSE. |
table: OTP Mechanism Flags

Note: Even if **CKA_OTP_FORMAT** is not set to **CK_OTP_FORMAT_BINARY**, then
there may still be value in setting the **CKF_USER_FRIENDLY_OTP** flag (assuming
**CKA_OTP_USER_FRIENDLY_MODE** is **CK_TRUE**, of course) if the intent is for a
human to read the generated OTP value, since it may become shorter or otherwise
better suited for a user. Applications that do not intend to provide a returned
OTP value to a user should not set the **CKF_USER_FRIENDLY_OTP** flag.

### CK_OTP_PARAM

**CK_OTP_PARAM** is a structure that includes the type, value, and length of an
OTP parameter. It is defined as follows:

~~~{.c}
typedef struct CK_OTP_PARAM {
	CK_OTP_PARAM_TYPE type;
	CK_VOID_PTR pValue;
	CK_ULONG	ulValueLen;
} CK_OTP_PARAM;
~~~

The fields of the structure have the following meanings:

_type_
: the parameter type

_pValue_
: pointer to the value of the parameter

_ulValueLen_
: length in bytes of the value

If a parameter has no value, then _ulValueLen_ = 0, and the value of _pValue_ is
irrelevant. Note that _pValue_ is a “void” pointer, facilitating the passing of
arbitrary values. Both the application and the Cryptoki library must ensure that
the pointer can be safely cast to the expected type (i.e., without
word-alignment errors).

**CK_OTP_PARAM_PTR** is a pointer to a **CK_OTP_PARAM**.

### CK_OTP_PARAMS

**CK_OTP_PARAMS** is a structure that is used to provide parameters for OTP
mechanisms in a generic fashion. It is defined as follows:

~~~{.c}
typedef struct CK_OTP_PARAMS {
	CK_OTP_PARAM_PTR pParams;
	CK_ULONG ulCount;
} CK_OTP_PARAMS;
~~~

The fields of the structure have the following meanings:

_pParams_
: pointer to an array of OTP parameters

_ulCount_
: the number of parameters in the array

**CK_OTP_PARAMS_PTR** is a pointer to a **CK_OTP_PARAMS**.

When calling **C_SignInit** or **C_VerifyInit** with a mechanism that takes a
**CK_OTP_PARAMS** structure as a parameter, the **CK_OTP_PARAMS** structure
shall be populated in accordance with the **CKA_OTP_X_REQUIREMENT** key
attributes for the identified key, where **X** is PIN, CHALLENGE, TIME, or COUNTER.

For example, if **CKA_OTP_TIME_REQUIREMENT** = CK_OTP_PARAM_MANDATORY, then the
CK_OTP_TIME parameter shall be present. If **CKA_OTP_TIME_REQUIREMENT** =
CK_OTP_PARAM_OPTIONAL, then a CK_OTP_TIME parameter may be present. If it is not
present, then the library may collect it (during the **C_Sign** call). If
**CKA_OTP_TIME_REQUIREMENT** = CK_OTP_PARAM_IGNORED, then a provided CK_OTP_TIME
parameter will always be ignored. Additionally, a provided CK_OTP_TIME parameter
will always be ignored if **CKF_EXCLUDE_TIME** is set in a CK_OTP_FLAGS
parameter. Similarly, if this flag is set, a library will not attempt to collect
the value itself, and it will also instruct the token not to make use of any
internal value, subject to token policies. It is an error
(**CKR_MECHANISM_PARAM_INVALID**) to set the **CKF_EXCLUDE_TIME** flag when the
**CKA_OTP_TIME_REQUIREMENT** attribute is CK_OTP_PARAM_MANDATORY.

The above discussion holds for all **CKA_OTP_X_REQUIREMENT** attributes (i.e.,
**CKA_OTP_PIN_REQUIREMENT**, **CKA_OTP_CHALLENGE_REQUIREMENT**,
**CKA_OTP_COUNTER_REQUIREMENT**, **CKA_OTP_TIME_REQUIREMENT**). A library may
set a particular **CKA_OTP_X_REQUIREMENT** attribute to CK_OTP_PARAM_OPTIONAL
even if it is required by the mechanism as long as the token (or the library
itself) has the capability of providing the value to the computation. One
example of this is a token with an on-board clock.

In addition, applications may use the CK_OTP_FLAGS, the CK_OTP_OUTPUT_FORMAT and
the **CKA_OTP_LENGTH** parameters to set additional parameters.

### CK_OTP_SIGNATURE_INFO

**CK_OTP_SIGNATURE_INFO** is a structure that is returned by all OTP mechanisms
in successful calls to **C_Sign** (**C_SignFinal**). The structure informs
applications of actual parameter values used in particular OTP computations in
addition to the OTP value itself. It is used by all mechanisms for which the key
belongs to the class **CKO_OTP_KEY** and is defined as follows:

~~~{.c}
typedef struct CK_OTP_SIGNATURE_INFO {
	CK_OTP_PARAM_PTR pParams;
	CK_ULONG ulCount;
} CK_OTP_SIGNATURE_INFO;
~~~

The fields of the structure have the following meanings:

_pParams_
: pointer to an array of OTP parameter values

_ulCount_
: the number of parameters in the array

After successful calls to **C_Sign** or **C_SignFinal** with an OTP mechanism,
the _pSignature_ parameter will be set to point to a **CK_OTP_SIGNATURE_INFO**
structure. One of the parameters in this structure will be the OTP value itself,
identified with the **CK_OTP_VALUE** tag. Other parameters may be present for
informational purposes, e.g. the actual time used in the OTP calculation. In
order to simplify OTP validations, authentication protocols may permit
authenticating parties to send some or all of these parameters in addition to
OTP values themselves. Applications should therefore check for their presence in
returned **CK_OTP_SIGNATURE_INFO** values whenever such circumstances apply.

Since **C_Sign** and **C_SignFinal** follows the convention described in section
[5.2] on producing output, a call to **C_Sign** (or **C_SignFinal**) with
_pSignature_ set to NULL_PTR will return (in the _pulSignatureLen_ parameter)
the required number of bytes to hold the **CK_OTP_SIGNATURE_INFO** structure as
well as all the data in all its **CK_OTP_PARAM** components. If an application
allocates a memory block based on this information, it shall therefore not
subsequently de-allocate components of such a received value but rather
de-allocate the complete **CK_OTP_PARAMS** structure itself. A Cryptoki library
that is called with a non-NULL _pSignature_ pointer will assume that it points
to a contiguous memory block of the size indicated by the _pulSignatureLen_
parameter.

When verifying an OTP value using an OTP mechanism, _pSignature_ shall be set to
the OTP value itself, e.g. the value of the **CK_OTP_VALUE** component of a
**CK_OTP_PARAM** structure returned by a call to **C_Sign**. The
**CK_OTP_PARAM** value supplied in the **C_VerifyInit** call sets the values to
use in the verification operation.

**CK_OTP_SIGNATURE_INFO_PTR** points to a **CK_OTP_SIGNATURE_INFO**.

## RSA SecurID

### RSA SecurID secret key objects

RSA SecurID secret key objects (object class **CKO_OTP_KEY**, key type
**CKK_SECURID**) hold RSA SecurID secret keys. The following table defines the
RSA SecurID secret key object attributes, in addition to the common attributes
defined for this object class:

| Attribute                 | Data type | Meaning                            |
|---------------------------|-----------|------------------------------------|
| CKA_OTP_TIME_INTERVAL ^1^ | CK_ULONG  | Interval between OTP values produced with this key, in seconds. Default is 60. |
table: RSA SecurID secret key object attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating an RSA SecurID secret key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_OTP_KEY;
CK_KEY_TYPE keyType = CKK_SECURID;
CK_DATE endDate = {...};
CK_UTF8CHAR label[] = “RSA SecurID secret key object”;
CK_BYTE keyId[]= {...};
CK_ULONG outputFormat = CK_OTP_FORMAT_DECIMAL;
CK_ULONG outputLength = 6;
CK_ULONG needPIN = CK_OTP_PARAM_MANDATORY;
CK_ULONG timeInterval = 60;
CK_BYTE value[] = {...};
   CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_END_DATE, &endDate, sizeof(endDate)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_SENSITIVE, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_SIGN, &true, sizeof(true)},
	{CKA_VERIFY, &true, sizeof(true)},
	{CKA_ID, keyId, sizeof(keyId)},
	{CKA_OTP_FORMAT, &outputFormat, sizeof(outputFormat)},
	{CKA_OTP_LENGTH, &outputLength, sizeof(outputLength)},
	{CKA_OTP_PIN_REQUIREMENT, &needPIN, sizeof(needPIN)},
	{CKA_OTP_TIME_INTERVAL, &timeInterval, sizeof(timeInterval)},
	{CKA_VALUE, value, sizeof(value)}
};
~~~

### RSA SecurID key generation

The RSA SecurID key generation mechanism, denoted **CKM_SECURID_KEY_GEN**, is a
key generation mechanism for the RSA SecurID algorithm.

It does not have a parameter.

The mechanism generates RSA SecurID keys with a particular set of attributes as
specified in the template for the key.

The mechanism contributes at least the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_VALUE_LEN**, and **CKA_VALUE** attributes to the new key. Other attributes
supported by the RSA SecurID key type may be specified in the template for the
key, or else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of SecurID key
sizes, in bytes.

### SecurID OTP generation and validation

**CKM_SECURID** is the mechanism for the retrieval and verification of RSA
SecurID OTP values.

The mechanism takes a pointer to a **CK_OTP_PARAMS** structure as a parameter.

When signing or verifying using the **CKM_SECURID** mechanism, _pData_ shall be
set to NULL_PTR and _ulDataLen_ shall be set to 0.

### Return values

Support for the **CKM_SECURID** mechanism extends the set of return values for
**C_Verify** with the following values:

- **CKR_NEW_PIN_MODE**: The supplied OTP was not accepted, and the library
  requests a new OTP computed using a new PIN. The new PIN is set through means
  out of scope for this document.
- **CKR_NEXT_OTP**: The supplied OTP was correct but indicated a larger than
  normal drift in the token's internal state (e.g. clock, counter). To ensure
  this was not due to a temporary problem, the application should provide the
  next one-time password to the library for verification.

## OATH HOTP

### OATH HOTP secret key objects

HOTP secret key objects (object class **CKO_OTP_KEY**, key type **CKK_HOTP**)
hold generic secret keys and associated counter values.

The **CKA_OTP_COUNTER** value may be set at key generation; however, some tokens
may set it to a fixed initial value. Depending on the token’s security policy,
this value may not be modified and/or may not be revealed if the object has its
**CKA_SENSITIVE** attribute set to CK_TRUE or its **CKA_EXTRACTABLE** attribute
set to CK_FALSE.

For HOTP keys, the **CKA_OTP_COUNTER** value shall be an 8 bytes unsigned
integer in big endian (i.e. network byte order) form. The same holds true for a
**CK_OTP_COUNTER** value in a **CK_OTP_PARAM** structure.

The following is a sample template for creating a HOTP secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_OTP_KEY;
CK_KEY_TYPE keyType = CKK_HOTP;
CK_UTF8CHAR label[] = “HOTP secret key object”;
CK_BYTE keyId[]= {...};
CK_ULONG outputFormat = CK_OTP_FORMAT_DECIMAL;
CK_ULONG outputLength = 6;
CK_DATE endDate = {...};
CK_BYTE counterValue[8] = {0};
CK_BYTE value[] = {...};
   CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_END_DATE, &endDate, sizeof(endDate)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_SENSITIVE, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_SIGN, &true, sizeof(true)},
	{CKA_VERIFY, &true, sizeof(true)},
	{CKA_ID, keyId, sizeof(keyId)},
	{CKA_OTP_FORMAT, &outputFormat, sizeof(outputFormat)},
	{CKA_OTP_LENGTH, &outputLength, sizeof(outputLength)},
	{CKA_OTP_COUNTER, counterValue, sizeof(counterValue)},
	{CKA_VALUE, value, sizeof(value)}
};
~~~

### HOTP key generation

The HOTP key generation mechanism, denoted **CKM_HOTP_KEY_GEN**, is a key
generation mechanism for the HOTP algorithm.

It does not have a parameter.

The mechanism generates HOTP keys with a particular set of attributes as
specified in the template for the key.

The mechanism contributes at least the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_OTP_COUNTER**, **CKA_VALUE** and **CKA_VALUE_LEN** attributes to the new
key. Other attributes supported by the HOTP key type may be specified in the
template for the key, or else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of HOTP key sizes,
in bytes.

### HOTP OTP generation and validation

**CKM_HOTP** is the mechanism for the retrieval and verification of HOTP OTP
values based on the current internal counter, or a provided counter.

The mechanism takes a pointer to a **CK_OTP_PARAMS** structure as a parameter.

As for the **CKM_SECURID** mechanism, when signing or verifying using the
**CKM_HOTP** mechanism, pData shall be set to NULL_PTR and ulDataLen shall be
set to 0.

For verify operations, the counter value **CK_OTP_COUNTER** must be provided as
a **CK_OTP_PARAM** parameter to **C_VerifyInit**. When verifying an OTP value
using the **CKM_HOTP** mechanism, pSignature shall be set to the OTP value
itself, e.g. the value of the **CK_OTP_VALUE** component of a **CK_OTP_PARAM**
structure in the case of an earlier call to **C_Sign**.

## ActivIdentity ACTI

### ACTI secret key objects

ACTI secret key objects (object class **CKO_OTP_KEY**, key type **CKK_ACTI**)
hold ActivIdentity ACTI secret keys.

For ACTI keys, the **CKA_OTP_COUNTER** value shall be an 8 bytes unsigned
integer in big endian (i.e. network byte order) form. The same holds true for
the **CK_OTP_COUNTER** value in the **CK_OTP_PARAM** structure.

The **CKA_OTP_COUNTER** value may be set at key generation; however, some tokens
may set it to a fixed initial value. Depending on the token’s security policy,
this value may not be modified and/or may not be revealed if the object has its
**CKA_SENSITIVE** attribute set to CK_TRUE or its **CKA_EXTRACTABLE** attribute
set to CK_FALSE.

The **CKA_OTP_TIME** value may be set at key generation; however, some tokens
may set it to a fixed initial value. Depending on the token’s security policy,
this value may not be modified and/or may not be revealed if the object has its
**CKA_SENSITIVE** attribute set to CK_TRUE or its **CKA_EXTRACTABLE** attribute
set to CK_FALSE.

The following is a sample template for creating an ACTI secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_OTP_KEY;
CK_KEY_TYPE keyType = CKK_ACTI;
CK_UTF8CHAR label[] = “ACTI secret key object”;
CK_BYTE keyId[]= {...};
CK_ULONG outputFormat = CK_OTP_FORMAT_DECIMAL;
CK_ULONG outputLength = 6;
CK_DATE endDate = {...};
CK_BYTE counterValue[8] = {0};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_END_DATE, &endDate, sizeof(endDate)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_SENSITIVE, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_SIGN, &true, sizeof(true)},
	{CKA_VERIFY, &true, sizeof(true)},
	{CKA_ID, keyId, sizeof(keyId)},
	{CKA_OTP_FORMAT, &outputFormat,
	sizeof(outputFormat)},
	{CKA_OTP_LENGTH, &outputLength,
	sizeof(outputLength)},
	{CKA_OTP_COUNTER, counterValue,
	sizeof(counterValue)},
	{CKA_VALUE, value, sizeof(value)}
};
~~~

### ACTI key generation

The ACTI key generation mechanism, denoted **CKM_ACTI_KEY_GEN**, is a key
generation mechanism for the ACTI algorithm.

It does not have a parameter.

The mechanism generates ACTI keys with a particular set of attributes as
specified in the template for the key.

The mechanism contributes at least the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_VALUE** and **CKA_VALUE_LEN** attributes to the new key. Other attributes
supported by the ACTI key type may be specified in the template for the key, or
else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ACTI key sizes,
in bytes.

### ACTI OTP generation and validation

**CKM_ACTI** is the mechanism for the retrieval and verification of ACTI OTP
values.

The mechanism takes a pointer to a **CK_OTP_PARAMS** structure as a parameter.

When signing or verifying using the **CKM_ACTI** mechanism, _pData_ shall be set
to NULL_PTR and _ulDataLen_ shall be set to 0.

When verifying an OTP value using the **CKM_ACTI** mechanism, _pSignature_ shall
be set to the OTP value itself, e.g. the value of the **CK_OTP_VALUE** component
of a **CK_OTP_PARAM** structure in the case of an earlier call to **C_Sign**.

