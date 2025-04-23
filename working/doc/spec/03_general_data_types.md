# General data types

The general Cryptoki data types are described in the following subsections.
The data types for holding parameters for various mechanisms, and the pointers
to those parameters, are not described here; these types are described with
the information on the mechanisms themselves, in Section 6.

A C or C++ source file in a Cryptoki application or library can define all
these types (the types described here and the types that are specifically used
for particular mechanism parameters) by including the top-level Cryptoki
include file, pkcs11.h. pkcs11.h, in turn, includes the other Cryptoki include
files, pkcs11t.h and pkcs11f.h. A source file can also include just pkcs11t.h
(instead of pkcs11.h); this defines most (but not all) of the types specified
here.

When including either of these header files, a source file MUST specify the
preprocessor directives indicated in Section 2.

## General information

Cryptoki represents general information with the following types:

### CK_VERSION

**CK_VERSION** is a structure that describes the version of a Cryptoki
interface, a Cryptoki library, or an SSL or TLS implementation, or the
hardware or firmware version of a slot or token. It is defined as follows:

~~~{.c}
typedef struct CK_VERSION {
  CK_BYTE major;
  CK_BYTE minor;
} CK_VERSION;
~~~

The fields of the structure have the following meanings:


_major_
: major version number (the integer portion of the version)

_minor_
: minor version number (the hundredths portion of the version)


Example: For version 1.0, major = 1 and minor = 0. For version 2.10, major = 2
and minor = 10. Table 4 below lists the major and minor version values for the
officially published Cryptoki specifications.

| Version | major | minor |
|---------|-------|-------|
| 1.0     | 0x01  | 0x00  |
| 2.01    | 0x02  | 0x01  |
| 2.10    | 0x02  | 0x0a  |
| 2.11    | 0x02  | 0x0b  |
| 2.20    | 0x02  | 0x14  |
| 2.30    | 0x02  | 0x1e  |
| 2.40    | 0x02  | 0x28  |
| 3.0     | 0x03  | 0x00  |
| 3.1     | 0x03  | 0x01  |
| 3.2     | 0x03  | 0x02  |
table: Major and minor version values for published Cryptoki specifications

Minor revisions of the Cryptoki standard are always upwardly compatible within
the same major version number.

**CK_VERSION_PTR** is a pointer to a **CK_VERSION**.

### CK_INFO

**CK_INFO** provides general information about Cryptoki. It is defined as
follows:

~~~{.c}
typedef struct CK_INFO {
  CK_VERSION cryptokiVersion;
  CK_UTF8CHAR manufacturerID[32];
  CK_FLAGS flags;
  CK_UTF8CHAR libraryDescription[32];
  CK_VERSION libraryVersion;
} CK_INFO;
~~~

The fields of the structure have the following meanings:

_cryptokiVersion_
: Cryptoki interface version number, for compatibility with future revisions
  of this interface

_manufacturerID_
: ID of the Cryptoki library manufacturer. MUST be padded with the blank
  character (‘ ‘). Should not be null-terminated.

_flags_
: bit flags reserved for future versions. MUST be zero for this version

_libraryDescription_
: character-string description of the library. MUST be padded with the blank
  character (‘ ‘). Should not be null-terminated.

_libraryVersion_
: Cryptoki library version number


For libraries written to this document, the value of _cryptokiVersion_ should
match the version of this specification; the value of _libraryVersion_ is the
version number of the library software itself.

**CK_INFO_PTR** is a pointer to a **CK_INFO**.

### CK_NOTIFICATION

**CK_NOTIFICATION** holds the types of notifications that Cryptoki provides to
an application. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_NOTIFICATION;
~~~

For this version of Cryptoki, the following types of notifications are defined:

~~~{.c}
CKN_SURRENDER
~~~

The notifications have the following meanings:

_CKN_SURRENDER_
: Cryptoki is surrendering the execution of a function executing in a session
  so that the application may perform other operations. After performing any
  desired operations, the application should indicate to Cryptoki whether to
  continue or cancel the function (see Section 5.22.1).

## Slot and token types

Cryptoki represents slot and token information with the following types:

### CK_SLOT_ID

**CK_SLOT_ID** is a Cryptoki-assigned value that identifies a slot. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_SLOT_ID;
~~~

A list of **CK_SLOT_ID**s is returned by **C_GetSlotList**. A priori, _any_
value of **CK_SLOT_ID** can be a valid slot identifier—in particular, a
system may have a slot identified by the value 0. It need not have such a
slot, however.

**CK_SLOT_ID_PTR** is a pointer to a **CK_SLOT_ID**.

### CK_SLOT_INFO

**CK_SLOT_INFO** provides information about a slot. It is defined as follows:

~~~{.c}
typedef struct CK_SLOT_INFO {
  CK_UTF8CHAR slotDescription[64];
  CK_UTF8CHAR manufacturerID[32];
  CK_FLAGS flags;
  CK_VERSION hardwareVersion;
  CK_VERSION firmwareVersion;
} CK_SLOT_INFO;
~~~

The fields of the structure have the following meanings:

_slotDescription_
: character-string description of the slot. MUST be padded with the blank character (‘ ‘). MUST NOT be null-terminated.

_manufacturerID_
: ID of the slot manufacturer. MUST be padded with the blank character (‘ ‘). MUST NOT be null-terminated.

_flags_
: bits flags that provide capabilities of the slot.  The flags are defined below

_hardwareVersion_
: version number of the slot’s hardware

_firmwareVersion_
: version number of the slot’s firmware

The following table defines the flags field:

| Bit Flag             | Mask       | Meaning                   |
|----------------------|------------|---------------------------|
| CKF_TOKEN_PRESENT    | 0x00000001 | True if a token is present in the slot (e.g., a device is in the reader) |
| CKF_REMOVABLE_DEVICE | 0x00000002 | True if the reader supports removable devices |
| CKF_HW_SLOT          | 0x00000004 | True if the slot is a hardware slot, as opposed to a software slot implementing a “soft token” |
table: Slot Information Flags

Implementations should not imply an interpretation about the security
properties based on the **CKF_HW_SLOT**. The flag is intended purely as an
indicator that the slot is a physical realisation. How the implementation that
offers the physical slot implements mechanisms (software/firmware/hardware) is
unrelated to this flag.

For a given slot, the value of the **CKF_REMOVABLE_DEVICE** flag never changes.
In addition, if this flag is not set for a given slot, then the
**CKF_TOKEN_PRESENT** flag for that slot is always set. That is, if a slot does
not support a removable device, then that slot always has a token in it.

**CK_SLOT_INFO_PTR** is a pointer to a **CK_SLOT_INFO**.

### CK_TOKEN_INFO

**CK_TOKEN_INFO** provides information about a token. It is defined as follows:

~~~{.c}
typedef struct CK_TOKEN_INFO {
  CK_UTF8CHAR label[32];
  CK_UTF8CHAR manufacturerID[32];
  CK_UTF8CHAR model[16];
  CK_CHAR serialNumber[16];
  CK_FLAGS flags;
  CK_ULONG ulMaxSessionCount;
  CK_ULONG ulSessionCount;
  CK_ULONG ulMaxRwSessionCount;
  CK_ULONG ulRwSessionCount;
  CK_ULONG ulMaxPinLen;
  CK_ULONG ulMinPinLen;
  CK_ULONG ulTotalPublicMemory;
  CK_ULONG ulFreePublicMemory;
  CK_ULONG ulTotalPrivateMemory;
  CK_ULONG ulFreePrivateMemory;
  CK_VERSION hardwareVersion;
  CK_VERSION firmwareVersion;
  CK_CHAR utcTime[16];
} CK_TOKEN_INFO;
~~~

The fields of the structure have the following meanings:

_label_
: application-defined label, assigned during token initialization. MUST be
  padded with the blank character (‘ ‘). MUST NOT be null-terminated.

_manufacturerID_
: ID of the device manufacturer. MUST be padded with the blank character
  (‘ ‘). MUST NOT be null-terminated.

_model_
: model of the device. MUST be padded with the blank character (‘ ‘).
  MUST NOT be null-terminated.

_serialNumber_
: character-string serial number of the device. MUST be padded with the
  blank character (‘ ‘). MUST NOT be null-terminated.

_flags_
: bit flags indicating capabilities and status of the device as defined below

_ulMaxSessionCount_
: maximum number of sessions that can be opened with the token at one time
  by a single application (see **CK_TOKEN_INFO Note** below)

_ulSessionCount_
: number of sessions that this application currently has open with the token
  (see **CK_TOKEN_INFO Note** below)

_ulMaxRwSessionCount_
: maximum number of read/write sessions that can be opened with the token at
  one time by a single application (see **CK_TOKEN_INFO Note** below)

_ulRwSessionCount_
: number of read/write sessions that this application currently has open with
  the token (see **CK_TOKEN_INFO Note** below)

_ulMaxPinLen_
: maximum length in bytes of the PIN

_ulMinPinLen_
: minimum length in bytes of the PIN

_ulTotalPublicMemory_
: the total amount of memory on the token in bytes in which public objects
  may be stored (see **CK_TOKEN_INFO Note** below)

_ulFreePublicMemory_
: the amount of free (unused) memory on the token in bytes for public
  objects (see **CK_TOKEN_INFO Note** below)

_ulTotalPrivateMemory_
: the total amount of memory on the token in bytes in which private objects
  may be stored (see **CK_TOKEN_INFO Note** below)

_ulFreePrivateMemory_
: the amount of free (unused) memory on the token in bytes for private
  objects (see **CK_TOKEN_INFO Note** below)

_hardwareVersion_
: version number of hardware

_firmwareVersion_
: version number of firmware

_utcTime_
: current time as a character-string of length 16, represented in the format
  YYYYMMDDhhmmssxx (4 characters for the year;  2 characters each for the
  month, the day, the hour, the minute, and the second; and 2 additional
  reserved ‘0’ characters). The value of this field only makes sense for
  tokens equipped with a clock, as indicated in the token information flags
  (see below)

The following table defines the flags field:

| Bit Flag                          | Mask       | Meaning           |
|-----------------------------------|------------|-------------------|
| CKF_RNG                           | 0x00000001 | True if the token has its own random number generator |
| CKF_WRITE_PROTECTED               | 0x00000002 | True if the token is write-protected (see below) |
| CKF_LOGIN_REQUIRED                | 0x00000004 | True if there are some cryptographic functions that a user MUST be logged in to perform |
| CKF_USER_PIN_INITIALIZED          | 0x00000008 | True if the normal user’s PIN has been initialized |
| CKF_RESTORE_KEY_NOT_NEEDED        | 0x00000020 | True if a successful save of a session’s cryptographic operations state always contains all keys needed to restore the state of the session |
| CKF_CLOCK_ON_TOKEN                | 0x00000040 | True if token has its own hardware clock |
| CKF_PROTECTED_AUTHENTICATION_PATH | 0x00000100 | True if token has a “protected authentication path”, whereby a user can log into the token without passing a PIN through the Cryptoki library |
| CKF_DUAL_CRYPTO_OPERATIONS        | 0x00000200 | True if a single session with the token can perform dual cryptographic  operations (see Section `5.17`) |
| CKF_TOKEN_INITIALIZED             | 0x00000400 | True if the token has been initializedusing C_InitToken or an equivalent mechanism outside the scope of this standard. Calling C_InitToken when this flag is set will cause the token to be reinitialized. |
| CKF_SECONDARY_AUTHENTICATION      | 0x00000800 | True if the token supports secondary authentication for private key objects. (Deprecated; new implementations MUST NOT set this flag) |
| CKF_USER_PIN_COUNT_LOW            | 0x00010000 | True if an incorrect user login PIN has been entered at least once since the last successful authentication. |
| CKF_USER_PIN_FINAL_TRY            | 0x00020000 | True if supplying an incorrect user PIN will cause it to become locked. |
| CKF_USER_PIN_LOCKED               | 0x00040000 | True if the user PIN has been locked. User login to the token is not possible. |
| CKF_USER_PIN_TO_BE_CHANGED        | 0x00080000 | True if the user PIN value is the default value set by token initialization or manufacturing, or the PIN has been expired by the card. |
| CKF_SO_PIN_COUNT_LOW              | 0x00100000 | True if an incorrect SO login PIN has been entered at least once since the last successful authentication. |
| CKF_SO_PIN_FINAL_TRY              | 0x00200000 | True if supplying an incorrect SO PIN will cause it to become locked. |
| CKF_SO_PIN_LOCKED                 | 0x00400000 | True if the SO PIN has been locked. SO login to the token  is not possible. |
| CKF_SO_PIN_TO_BE_CHANGED          | 0x00800000 | True if the SO PIN value is the default value set by token initialization or manufacturing, or the PIN has been expired by the card. |
| CKF_ERROR_STATE                   | 0x01000000 | True if the token failed a FIPS 140-2 self-test and entered an error state. |
| CKF_SEED_RANDOM_REQUIRED          | 0x02000000 | True if the token’s random number generator must be seeded or re-seeded using C_SeedRandom. |
| CKF_ASYNC_SESSION_SUPPORTED       | 0x04000000 | True if the token supports asynchronous sessions (see Section `5.21`). |
table: Token Information Flags

It is not specified in Cryptoki which type of random number generator, i.e.,
a true/physical or pseudo/deterministic or hybrid random number generator,
the token has when **CKF_RNG** is true.

Exactly what the **CKF_WRITE_PROTECTED** flag means is not specified in
Cryptoki. An application may be unable to perform certain actions on a
write-protected token; these actions can include any of the following,
among others:

* Creating/modifying/deleting any object on the token.
* Creating/modifying/deleting a token object on the token.
* Changing the SO’s PIN.
* Changing the normal user’s PIN.

The token may change the value of the **CKF_WRITE_PROTECTED** flag depending
on the session state to implement its object management policy. For instance,
the token may set the **CKF_WRITE_PROTECTED** flag unless the session state
is R/W SO or R/W User to implement a policy that does not allow any objects,
public or private, to be created, modified, or deleted unless the user has
successfully called **C_Login**.

The **CKF_USER_PIN_COUNT_LOW**, **CKF_SO_PIN_COUNT_LOW**,
**CKF_USER_PIN_FINAL_TRY**, and **CKF_SO_PIN_FINAL_TRY** flags may always be
set to false if the token does not support the functionality or will not
reveal the information because of its security policy.

The **CKF_USER_PIN_TO_BE_CHANGED** and **CKF_SO_PIN_TO_BE_CHANGED** flags may
always be set to false if the token does not support the functionality. If a
PIN is set to the default value, or has expired, the appropriate
**CKF_USER_PIN_TO_BE_CHANGED** or **CKF_SO_PIN_TO_BE_CHANGED** flag is set to
true. When either of these flags are true, logging in with the corresponding
PIN will succeed, but only the **C_SetPIN** function can be called. Calling
any other function that required the user to be logged in will cause
**CKR_PIN_EXPIRED** to be returned until **C_SetPIN** is called successfully.

**CK_TOKEN_INFO Note**: The fields ulMaxSessionCount, ulSessionCount,
ulMaxRwSessionCount, ulRwSessionCount, ulTotalPublicMemory, ulFreePublicMemory,
ulTotalPrivateMemory, and ulFreePrivateMemory can have the special value
CK_UNAVAILABLE_INFORMATION, which means that the token and/or library is unable
or unwilling to provide that information. In addition, the fields
ulMaxSessionCount and ulMaxRwSessionCount can have the special value
CK_EFFECTIVELY_INFINITE, which means that there is no practical limit on the
number of sessions (resp. R/W sessions) an application can have open with the
token.

It is important to check these fields for these special values. This is
particularly true for CK_EFFECTIVELY_INFINITE, since an application seeing
this value in the ulMaxSessionCount or ulMaxRwSessionCount field would
otherwise conclude that it can’t open any sessions with the token, which is
far from being the case.

The upshot of all this is that the correct way to interpret (for example) the
ulMaxSessionCount field is something along the lines of the following:

~~~{.c}
CK_TOKEN_INFO info;
.
.
if ((CK_LONG) info.ulMaxSessionCount
    == CK_UNAVAILABLE_INFORMATION) {
  /* Token refuses to give value of ulMaxSessionCount */
  .
  .
} else if (info.ulMaxSessionCount == CK_EFFECTIVELY_INFINITE) {
  /* Application can open as many sessions as it wants */
  .
  .
} else {
  /* ulMaxSessionCount really does contain what it should */
  .
  .
}
~~~

CK_TOKEN_INFO_PTR is a pointer to a CK_TOKEN_INFO.

## Session types

Cryptoki represents session information with the following types:

### CK_SESSION_HANDLE

**CK_SESSION_HANDLE** is a Cryptoki-assigned value that identifies a session.
It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_SESSION_HANDLE;
~~~

_Valid session handles in Cryptoki always have nonzero values._ For developers’
convenience, Cryptoki defines the following symbolic value:

~~~{.c}
CK_INVALID_HANDLE
~~~

CK_SESSION_HANDLE_PTR is a pointer to a CK_SESSION_HANDLE.

### CK_USER_TYPE

**CK_USER_TYPE** holds the types of Cryptoki users described in [PKCS11-UG]
and, in addition, a context-specific type described in Section `4.10`. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_USER_TYPE;
~~~

For this version of Cryptoki, the following types of users are defined:

~~~{.c}
CKU_SO
CKU_USER
CKU_CONTEXT_SPECIFIC
~~~

### CK_STATE

**CK_STATE** holds the session state, as described in [PKCS11-UG]. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_STATE;
~~~

For this version of Cryptoki, the following session states are defined:

~~~{.c}
CKS_RO_PUBLIC_SESSION
CKS_RO_USER_FUNCTIONS
CKS_RW_PUBLIC_SESSION
CKS_RW_USER_FUNCTIONS
CKS_RW_SO_FUNCTIONS
~~~

### CK_SESSION_INFO

**CK_SESSION_INFO** provides information about a session. It is defined as
follows:

~~~{.c}
typedef struct CK_SESSION_INFO {
  CK_SLOT_ID slotID;
  CK_STATE state;
  CK_FLAGS flags;
  CK_ULONG ulDeviceError;
} CK_SESSION_INFO;
~~~

The fields of the structure have the following meanings:

_slotID_
: ID of the slot that interfaces with the token

_state_
: the state of the session

_flags_
: bit flags that define the type of session; the flags are defined below

_ulDeviceError_
: an error code defined by the cryptographic device. Used for errors not
  covered by Cryptoki.

The following table defines the flags field:

| Bit Flag           | Mask       | Meaning                        |
|--------------------|------------|--------------------------------|
| CKF_RW_SESSION     | 0x00000002 | True if the session is read/write; false if the session is read-only |
| CKF_SERIAL_SESSION | 0x00000004 | This flag is provided for backward compatibility, and should always be set to true |
| CKF_ASYNC_SESSION  | 0x00000008 | True if the session is asynchronous; false if the session is synchronous (see Section `5.21`) |
table: Session Information Flags

CK_SESSION_INFO_PTR is a pointer to a CK_SESSION_INFO.

## Object types

Cryptoki represents object information with the following types:

### CK_OBJECT_HANDLE

**CK_OBJECT_HANDLE** is a token-specific identifier for an object. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_OBJECT_HANDLE;
~~~

When an object is created or found on a token by an application, Cryptoki
assigns it an object handle for that application’s sessions to use to access
it. A particular object on a token does not necessarily have a handle which is
fixed for the lifetime of the object; however, if a particular session can use
a particular handle to access a particular object, then that session will
continue to be able to use that handle to access that object as long as the
session continues to exist, the object continues to exist, and the object
continues to be accessible to the session.

_Valid object handles in Cryptoki always have nonzero values._ For developers’
convenience, Cryptoki defines the following symbolic value:

~~~{.c}
CK_INVALID_HANDLE
~~~

CK_OBJECT_HANDLE_PTR is a pointer to a CK_OBJECT_HANDLE.

### CK_OBJECT_CLASS

**CK_OBJECT_CLASS** is a value that identifies the classes (or types) of
objects that Cryptoki recognizes. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_OBJECT_CLASS;
~~~

Object classes are defined with the objects that use them. The type is
specified on an object through the **CKA_CLASS** attribute of the object.

Vendor defined values for this type may also be specified.

~~~{.c}
CKO_VENDOR_DEFINED
~~~

Object classes **CKO_VENDOR_DEFINED** and above are permanently reserved for
token vendors. For interoperability, vendors should register their object
classes through the PKCS process.

CK_OBJECT_CLASS_PTR is a pointer to a CK_OBJECT_CLASS.

### CK_HW_FEATURE_TYPE

**CK_HW_FEATURE_TYPE** is a value that identifies a hardware feature type of a
device. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_HW_FEATURE_TYPE;
~~~

Hardware feature types are defined with the objects that use them. The type is
specified on an object through the **CKA_HW_FEATURE_TYPE** attribute of the
object.

Vendor defined values for this type may also be specified.

~~~{.c}
CKH_VENDOR_DEFINED
~~~

Feature types **CKH_VENDOR_DEFINED** and above are permanently reserved for
token vendors. For interoperability, vendors should register their feature
types through the PKCS process.

### CK_KEY_TYPE

**CK_KEY_TYPE** is a value that identifies a key type. It is defined as
follows:

~~~{.c}
typedef CK_ULONG CK_KEY_TYPE;
~~~

Key types are defined with the objects and mechanisms that use them. The key
type is specified on an object through the **CKA_KEY_TYPE** attribute of the
object.

Vendor defined values for this type may also be specified.

~~~{.c}
CKK_VENDOR_DEFINED
~~~

Key types **CKK_VENDOR_DEFINED** and above are permanently reserved for token
vendors. For interoperability, vendors should register their key types through
the PKCS process.

### CK_CERTIFICATE_TYPE

**CK_CERTIFICATE_TYPE** is a value that identifies a certificate type. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_CERTIFICATE_TYPE;
~~~

Certificate types are defined with the objects and mechanisms that use them.
The certificate type is specified on an object through the
**CKA_CERTIFICATE_TYPE** attribute of the object.

Vendor defined values for this type may also be specified.

~~~{.c}
CKC_VENDOR_DEFINED
~~~

Certificate types **CKC_VENDOR_DEFINED** and above are permanently reserved
for token vendors. For interoperability, vendors should register their
certificate types through the PKCS process.

### CK_CERTIFICATE_CATEGORY

**CK_CERTIFICATE_CATEGORY** is a value that identifies a certificate category.
It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_CERTIFICATE_CATEGORY;
~~~

For this version of Cryptoki, the following certificate categories are defined:

| Constant                             | Value        | Meaning     |
|--------------------------------------|--------------|-------------|
| CK_CERTIFICATE_CATEGORY_UNSPECIFIED  | 0x00000000UL | No category specified |
| CK_CERTIFICATE_CATEGORY_TOKEN_USER   | 0x00000001UL | Certificate belongs to owner of the token |
| CK_CERTIFICATE_CATEGORY_AUTHORITY	   | 0x00000002UL | Certificate belongs to a certificate authority |
| CK_CERTIFICATE_CATEGORY_OTHER_ENTITY | 0x00000003UL | Certificate belongs to an end entity (i.e.: not a CA) |
table: Certificate category values

### CK_ATTRIBUTE_TYPE

**CK_ATTRIBUTE_TYPE** is a value that identifies an attribute type. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_ATTRIBUTE_TYPE;
~~~

Attributes are defined with the objects and mechanisms that use them.
Attributes are specified on an object as a list of type, length value items.
These are often specified as an attribute template.

Vendor defined values for this type may also be specified.

~~~{.c}
CKA_VENDOR_DEFINED
~~~

Attribute types **CKA_VENDOR_DEFINED** and above are permanently reserved for
token vendors. For interoperability, vendors should register their attribute
types through the PKCS process.

### CK_ATTRIBUTE

**CK_ATTRIBUTE** is a structure that includes the type, value, and length of
an attribute. It is defined as follows:

~~~{.c}
typedef struct CK_ATTRIBUTE {
  CK_ATTRIBUTE_TYPE type;
  CK_VOID_PTR pValue;
  CK_ULONG ulValueLen;
} CK_ATTRIBUTE;
~~~

The fields of the structure have the following meanings:

_type_
: the attribute type

_pValue_
: pointer to the value of the attribute

_ulValueLen_
: length in bytes of the value

If an attribute has no value, then _ulValueLen_ = 0, and the value of _pValue_
is irrelevant. An array of **CK_ATTRIBUTE**s is called a “template” and is
used for creating, manipulating and searching for objects. The order of the
attributes in a template never matters, even if the template contains
vendor-specific attributes. Note that _pValue_ is a “void” pointer,
facilitating the passing of arbitrary values. Both the application and Cryptoki
library MUST ensure that the pointer can be safely cast to the expected type
(i.e., without word-alignment errors).

The constant CK_UNAVAILABLE_INFORMATION is used in the ulValueLen field to
denote an invalid or unavailable value. See C_GetAttributeValue for further
details.

**CK_ATTRIBUTE_PTR** is a pointer to a **CK_ATTRIBUTE**.

### CK_DATE

**CK_DATE** is a structure that defines a date. It is defined as follows:

~~~{.c}
typedef struct CK_DATE {
  CK_CHAR year[4];
  CK_CHAR month[2];
  CK_CHAR day[2];
} CK_DATE;
~~~

The fields of the structure have the following meanings:

_year_
: the year (“1900” - “9999”)

_month_
: the month (“01” - “12”)

_day_
: the day (“01” - “31”)

The fields hold numeric characters from the character set in Table 3, not the
literal byte values.

When a Cryptoki object carries an attribute of this type, and the default
value of the attribute is specified to be "empty," then Cryptoki libraries
SHALL set the attribute's _ulValueLen_ to 0.

Note that implementations of previous versions of Cryptoki may have used other
methods to identify an "empty" attribute of type CK_DATE, and applications that
needs to interoperate with these libraries therefore have to be flexible in
what they accept as an empty value.

### CK_PROFILE_ID

**CK_PROFILE_ID** is an unsigend ulong value represting a specific token
profile. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_PROFILE_ID;
~~~

Profiles are defined in the PKCS #11 Cryptographic Token Interface Profiles
document. ID's greater than 0xffffffff may cause compatibility issues on
platforms that have CK_ULONG values of 32 bits, and should be avoided.

Vendor defined values for this type may also be specified.

~~~{.c}
CKP_VENDOR_DEFINED
~~~

Profile IDs **CKP_VENDOR_DEFINED** and above are permanently reserved for
token vendors. For interoperability, vendors should register their object
classes through the PKCS process.

_Valid Profile IDs in Cryptoki always have nonzero values._ For developers’
convenience, Cryptoki defines the following symbolic value:

~~~{.c}
CKP_INVALID_ID
~~~

CK_PROFILE_ID_PTR is a pointer to a CK_PROFILE_ID.

### CK_JAVA_MIDP_SECURITY_DOMAIN

**CK_JAVA_MIDP_SECURITY_DOMAIN** is a value that identifies the Java MIDP
security domain of a certificate. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_JAVA_MIDP_SECURITY_DOMAIN;
~~~

For this version of Cryptoki, the following security domains are defined. See
the [Java MIDP] specification for further information:

| Constant                        | Value        | Meaning             |
|---------------------------------|--------------|---------------------|
| CK_SECURITY_DOMAIN_UNSPECIFIED  | 0x00000000UL | No domain specified |
| CK_SECURITY_DOMAIN_MANUFACTURER | 0x00000001UL | Manufacturer protection domain |
| CK_SECURITY_DOMAIN_OPERATOR	  | 0x00000002UL | Operator protection domain     |
| CK_SECURITY_DOMAIN_THIRD_PARTY  | 0x00000003UL | Third party protection domain  |
table: Security domain values

## Data types for mechanisms

Cryptoki supports the following types for describing mechanisms and parameters
to them:

### CK_MECHANISM_TYPE

**CK_MECHANISM_TYPE** is a value that identifies a mechanism type. It is
defined as follows:

~~~{.c}
typedef CK_ULONG CK_MECHANISM_TYPE;
~~~

Mechanism types are defined with the objects and mechanism descriptions that
use them.

Vendor defined values for this type may also be specified.

~~~{.c}
CKM_VENDOR_DEFINED
~~~

Mechanism types **CKM_VENDOR_DEFINED** and above are permanently reserved for
token vendors. For interoperability, vendors should register their mechanism
types through the PKCS process.

**CK_MECHANISM_TYPE_PTR** is a pointer to a **CK_MECHANISM_TYPE**.

### CK_MECHANISM

**CK_MECHANISM** is a structure that specifies a particular mechanism and any
parameters it requires. It is defined as follows:

~~~{.c}
typedef struct CK_MECHANISM {
  CK_MECHANISM_TYPE mechanism;
  CK_VOID_PTR pParameter;
  CK_ULONG ulParameterLen;
} CK_MECHANISM;
~~~

The fields of the structure have the following meanings:

_mechanism_
: the type of mechanism

_pParameter_
: pointer to the parameter if required by the mechanism

_ulParameterLen_
: length in bytes of the parameter

Note that _pParameter_ is a “void” pointer, facilitating the passing of
arbitrary values. Both the application and the Cryptoki library MUST ensure
that the pointer can be safely cast to the expected type (i.e., without
word-alignment errors).

**CK_MECHANISM_PTR** is a pointer to a **CK_MECHANISM**.

### CK_MECHANISM_INFO

**CK_MECHANISM_INFO** is a structure that provides information about a
particular mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_MECHANISM_INFO {
  CK_ULONG ulMinKeySize;
  CK_ULONG ulMaxKeySize;
  CK_FLAGS flags;
} CK_MECHANISM_INFO;
~~~

The fields of the structure have the following meanings:

_ulMinKeySize_
: the minimum size of the key for the mechanism (whether this is measured
  in bits or in bytes is mechanism-dependent)

_ulMaxKeySize_
: the maximum size of the key for the mechanism (whether this is measured
  in bits or in bytes is mechanism-dependent)

_flags_
: bit flags specifying mechanism capabilities

For some mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields have
meaningless values.

The following table defines the flags field:

| Bit Flag              | Mask       | Meaning                 |
|-----------------------|------------|-------------------------|
| CKF_HW                | 0x00000001 | True if the mechanism is performed by the device; false if the mechanism is performed in software |
| CKF_MESSAGE_ENCRYPT   | 0x00000002 | True if the mechanism can be used with C_MessageEncryptInit |
| CKF_MESSAGE_DECRYPT   | 0x00000004 | True if the mechanism can be used with C_MessageDecryptInit |
| CKF_MESSAGE_SIGN      | 0x00000008 | True if the mechanism can be used with C_MessageSignInit |
| CKF_MESSAGE_VERIFY    | 0x00000010 | True if the mechanism can be used with C_MessageVerifyInit |
| CKF_MULTI_MESSAGE     | 0x00000020 | True if the mechanism can be used with C_MessageBegin. One of CKF_MESSAGE_* flag must also be set. |
| CKF_FIND_OBJECTS      | 0x00000040 | This flag can be passed in as a parameter to C_SessionCancel to cancel an active object search operation. Any other use of this flag is outside the scope of this standard. |
| CKF_ENCRYPT           | 0x00000100 | True if the mechanism can be used with C_EncryptInit |
| CKF_DECRYPT           | 0x00000200 | True if the mechanism can be used with C_DecryptInit |
| CKF_DIGEST            | 0x00000400 | True if the mechanism can be used with C_DigestInit |
| CKF_SIGN              | 0x00000800 | True if the mechanism can be used with C_SignInit |
| CKF_SIGN_RECOVER      | 0x00001000 | True if the mechanism can be used with C_SignRecoverInit |
| CKF_VERIFY            | 0x00002000 | True if the mechanism can be used with C_VerifyInit and C_VerifySignatureInit |
| CKF_VERIFY_RECOVER    | 0x00004000 | True if the mechanism can be used with C_VerifyRecoverInit |
| CKF_GENERATE          | 0x00008000 | True if the mechanism can be used with C_GenerateKey |
| CKF_GENERATE_KEY_PAIR | 0x00010000 | True if the mechanism can be used with C_GenerateKeyPair |
| CKF_WRAP         | 0x00020000 | True if the mechanism can be used with C_WrapKey |
| CKF_UNWRAP       | 0x00040000 | True if the mechanism can be used with C_UnwrapKey |
| CKF_DERIVE       | 0x00080000 | True if the mechanism can be used with C_DeriveKey |
| CKF_ENCAPSULATE  | 0x10000000 | True if the mechanism can be used with C_EncapsulateKey |
| CKF_DECAPSULATE  | 0x20000000 | True if the mechanism can be used with C_DecapsulateKey |
| CKF_EXTENSION    | 0x80000000 | True if there is an extension to the flags; false if no extensions. MUST be false for this version. |
table: Mechanism Information Flags

**CK_MECHANISM_INFO_PTR** is a pointer to a **CK_MECHANISM_INFO**.

## Function types

Cryptoki represents information about functions with the following data types:

### CK_RV

**CK_RV** is a value that identifies the return value of a Cryptoki function.
It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_RV;
~~~

Vendor defined values for this type may also be specified.

~~~{.c}
CKR_VENDOR_DEFINED
~~~

Section `5.1` defines the meaning of each **CK_RV** value. Return values
**CKR_VENDOR_DEFINED** and above are permanently reserved for token vendors.
For interoperability, vendors should register their return values through the
PKCS process.

### CK_NOTIFY

**CK_NOTIFY** is the type of a pointer to a function used by Cryptoki to
perform notification callbacks. It is defined as follows:

~~~{.c}
typedef CK_CALLBACK_FUNCTION(CK_RV, CK_NOTIFY)(
  CK_SESSION_HANDLE hSession,
  CK_NOTIFICATION event,
  CK_VOID_PTR pApplication
);
~~~

The arguments to a notification callback function have the following meanings:

_hSession_
: The handle of the session performing the callback

_event_
: The type of notification callback

_pApplication_
: An application-defined value. This is the same value as was passed to
  C_OpenSession to open the session performing the callback

### CK_C_XXX

Cryptoki also defines an entire family of other function pointer types. For
each function **C_XXX** in the Cryptoki API (see Section `5` for detailed
information about each of them), Cryptoki defines a type **CK_C_XXX**, which
is a pointer to a function with the same arguments and return value as
**C_XXX** has. An appropriately-set variable of type CK_C_XXX may be used by
an application to call the Cryptoki function **C_XXX**.

### CK_FUNCTION_LIST

**CK_FUNCTION_LIST** is a structure which contains a Cryptoki version and a
function pointer to each function in the Cryptoki API. It is defined as
follows:

~~~{.c}
typedef struct CK_FUNCTION_LIST {
  CK_VERSION version;
  CK_C_Initialize C_Initialize;
  CK_C_Finalize C_Finalize;
  CK_C_GetInfo C_GetInfo;
  CK_C_GetFunctionList C_GetFunctionList;
  CK_C_GetSlotList C_GetSlotList;
  CK_C_GetSlotInfo C_GetSlotInfo;
  CK_C_GetTokenInfo C_GetTokenInfo;
  CK_C_GetMechanismList C_GetMechanismList;
  CK_C_GetMechanismInfo C_GetMechanismInfo;
  CK_C_InitToken C_InitToken;
  CK_C_InitPIN C_InitPIN;
  CK_C_SetPIN C_SetPIN;
  CK_C_OpenSession C_OpenSession;
  CK_C_CloseSession C_CloseSession;
  CK_C_CloseAllSessions C_CloseAllSessions;
  CK_C_GetSessionInfo C_GetSessionInfo;
  CK_C_GetOperationState C_GetOperationState;
  CK_C_SetOperationState C_SetOperationState;
  CK_C_Login C_Login;
  CK_C_Logout C_Logout;
  CK_C_CreateObject C_CreateObject;
  CK_C_CopyObject C_CopyObject;
  CK_C_DestroyObject C_DestroyObject;
  CK_C_GetObjectSize C_GetObjectSize;
  CK_C_GetAttributeValue C_GetAttributeValue;
  CK_C_SetAttributeValue C_SetAttributeValue;
  CK_C_FindObjectsInit C_FindObjectsInit;
  CK_C_FindObjects C_FindObjects;
  CK_C_FindObjectsFinal C_FindObjectsFinal;
  CK_C_EncryptInit C_EncryptInit;
  CK_C_Encrypt C_Encrypt;
  CK_C_EncryptUpdate C_EncryptUpdate;
  CK_C_EncryptFinal C_EncryptFinal;
  CK_C_DecryptInit C_DecryptInit;
  CK_C_Decrypt C_Decrypt;
  CK_C_DecryptUpdate C_DecryptUpdate;
  CK_C_DecryptFinal C_DecryptFinal;
  CK_C_DigestInit C_DigestInit;
  CK_C_Digest C_Digest;
  CK_C_DigestUpdate C_DigestUpdate;
  CK_C_DigestKey C_DigestKey;
  CK_C_DigestFinal C_DigestFinal;
  CK_C_SignInit C_SignInit;
  CK_C_Sign C_Sign;
  CK_C_SignUpdate C_SignUpdate;
  CK_C_SignFinal C_SignFinal;
  CK_C_SignRecoverInit C_SignRecoverInit;
  CK_C_SignRecover C_SignRecover;
  CK_C_VerifyInit C_VerifyInit;
  CK_C_Verify C_Verify;
  CK_C_VerifyUpdate C_VerifyUpdate;
  CK_C_VerifyFinal C_VerifyFinal;
  CK_C_VerifyRecoverInit C_VerifyRecoverInit;
  CK_C_VerifyRecover C_VerifyRecover;
  CK_C_DigestEncryptUpdate C_DigestEncryptUpdate;
  CK_C_DecryptDigestUpdate C_DecryptDigestUpdate;
  CK_C_SignEncryptUpdate C_SignEncryptUpdate;
  CK_C_DecryptVerifyUpdate C_DecryptVerifyUpdate;
  CK_C_GenerateKey C_GenerateKey;
  CK_C_GenerateKeyPair C_GenerateKeyPair;
  CK_C_WrapKey C_WrapKey;
  CK_C_UnwrapKey C_UnwrapKey;
  CK_C_DeriveKey C_DeriveKey;
  CK_C_SeedRandom C_SeedRandom;
  CK_C_GenerateRandom C_GenerateRandom;
  CK_C_GetFunctionStatus C_GetFunctionStatus;
  CK_C_CancelFunction C_CancelFunction;
  CK_C_WaitForSlotEvent C_WaitForSlotEvent;
} CK_FUNCTION_LIST;
~~~

Each Cryptoki library has a static **CK_FUNCTION_LIST** structure, and a
pointer to it (or to a copy of it which is also owned by the library) may be
obtained by the **C_GetFunctionList** function (see Section `5.2`). The value
that this pointer points to can be used by an application to quickly find out
where the executable code for each function in the Cryptoki API is located.
Every function in the Cryptoki API MUST have an entry point defined in the
Cryptoki library’s **CK_FUNCTION_LIST** structure. If a particular function in
the Cryptoki API is not supported by a library, then the function pointer for
that function in the library’s **CK_FUNCTION_LIST** structure should point to
a function stub which simply returns **CKR_FUNCTION_NOT_SUPPORTED**.

In this structure ‘version’ is the cryptoki specification version number. The
major and minor versions must be set to 0x02 and 0x28 indicating a version
2.40 compatible structure. The updated function list table for this version
of the specification may be returned via **C_GetInterfaceList** or
**C_GetInterface**.

An application may or may not be able to modify a Cryptoki library’s static
**CK_FUNCTION_LIST** structure. Whether or not it can, it should never attempt
to do so.

PKCS #11 modules must not add new functions at the end of the
**CK_FUNCTION_LIST** that are not contained within the defined structure. If
a PKCS #11 module needs to define additional functions, they should be placed
within a vendor defined interface returned via **C_GetInterfaceList** or
**C_GetInterface**.

**CK_FUNCTION_LIST_PTR** is a pointer to a **CK_FUNCTION_LIST**.
**CK_FUNCTION_LIST_PTR_PTR** is a pointer to a **CK_FUNCTION_LIST_PTR**.

### CK_FUNCTION_LIST_3_0

**CK_FUNCTION_LIST_3_0** is a structure which contains the same function
pointers as in **CK_FUNCTION_LIST** and additional functions added to the end
of the structure that were defined in Cryptoki version 3.0. It is defined as
follows:

~~~{.c}
typedef struct CK_FUNCTION_LIST_3_0 {
  CK_VERSION version;
  CK_C_Initialize C_Initialize;
  CK_C_Finalize C_Finalize;
  CK_C_GetInfo C_GetInfo;
  CK_C_GetFunctionList C_GetFunctionList;
  CK_C_GetSlotList C_GetSlotList;
  CK_C_GetSlotInfo C_GetSlotInfo;
  CK_C_GetTokenInfo C_GetTokenInfo;
  CK_C_GetMechanismList C_GetMechanismList;
  CK_C_GetMechanismInfo C_GetMechanismInfo;
  CK_C_InitToken C_InitToken;
  CK_C_InitPIN C_InitPIN;
  CK_C_SetPIN C_SetPIN;
  CK_C_OpenSession C_OpenSession;
  CK_C_CloseSession C_CloseSession;
  CK_C_CloseAllSessions C_CloseAllSessions;
  CK_C_GetSessionInfo C_GetSessionInfo;
  CK_C_GetOperationState C_GetOperationState;
  CK_C_SetOperationState C_SetOperationState;
  CK_C_Login C_Login;
  CK_C_Logout C_Logout;
  CK_C_CreateObject C_CreateObject;
  CK_C_CopyObject C_CopyObject;
  CK_C_DestroyObject C_DestroyObject;
  CK_C_GetObjectSize C_GetObjectSize;
  CK_C_GetAttributeValue C_GetAttributeValue;
  CK_C_SetAttributeValue C_SetAttributeValue;
  CK_C_FindObjectsInit C_FindObjectsInit;
  CK_C_FindObjects C_FindObjects;
  CK_C_FindObjectsFinal C_FindObjectsFinal;
  CK_C_EncryptInit C_EncryptInit;
  CK_C_Encrypt C_Encrypt;
  CK_C_EncryptUpdate C_EncryptUpdate;
  CK_C_EncryptFinal C_EncryptFinal;
  CK_C_DecryptInit C_DecryptInit;
  CK_C_Decrypt C_Decrypt;
  CK_C_DecryptUpdate C_DecryptUpdate;
  CK_C_DecryptFinal C_DecryptFinal;
  CK_C_DigestInit C_DigestInit;
  CK_C_Digest C_Digest;
  CK_C_DigestUpdate C_DigestUpdate;
  CK_C_DigestKey C_DigestKey;
  CK_C_DigestFinal C_DigestFinal;
  CK_C_SignInit C_SignInit;
  CK_C_Sign C_Sign;
  CK_C_SignUpdate C_SignUpdate;
  CK_C_SignFinal C_SignFinal;
  CK_C_SignRecoverInit C_SignRecoverInit;
  CK_C_SignRecover C_SignRecover;
  CK_C_VerifyInit C_VerifyInit;
  CK_C_Verify C_Verify;
  CK_C_VerifyUpdate C_VerifyUpdate;
  CK_C_VerifyFinal C_VerifyFinal;
  CK_C_VerifyRecoverInit C_VerifyRecoverInit;
  CK_C_VerifyRecover C_VerifyRecover;
  CK_C_DigestEncryptUpdate C_DigestEncryptUpdate;
  CK_C_DecryptDigestUpdate C_DecryptDigestUpdate;
  CK_C_SignEncryptUpdate C_SignEncryptUpdate;
  CK_C_DecryptVerifyUpdate C_DecryptVerifyUpdate;
  CK_C_GenerateKey C_GenerateKey;
  CK_C_GenerateKeyPair C_GenerateKeyPair;
  CK_C_WrapKey C_WrapKey;
  CK_C_UnwrapKey C_UnwrapKey;
  CK_C_DeriveKey C_DeriveKey;
  CK_C_SeedRandom C_SeedRandom;
  CK_C_GenerateRandom C_GenerateRandom;
  CK_C_GetFunctionStatus C_GetFunctionStatus;
  CK_C_CancelFunction C_CancelFunction;
  CK_C_WaitForSlotEvent C_WaitForSlotEvent;
  CK_C_GetInterfaceList C_GetInterfaceList;
  CK_C_GetInterface C_GetInterface;
  CK_C_LoginUser C_LoginUser;
  CK_C_SessionCancel C_SessionCancel;
  CK_C_MessageEncryptInit C_MessageEncryptInit;
  CK_C_EncryptMessage C_EncryptMessage;
  CK_C_EncryptMessageBegin C_EncryptMessageBegin;
  CK_C_EncryptMessageNext C_EncryptMessageNext;
  CK_C_MessageEncryptFinal C_MessageEncryptFinal;
  CK_C_MessageDecryptInit C_MessageDecryptInit;
  CK_C_DecryptMessage C_DecryptMessage;
  CK_C_DecryptMessageBegin C_DecryptMessageBegin;
  CK_C_DecryptMessageNext C_DecryptMessageNext;
  CK_C_MessageDecryptFinal C_MessageDecryptFinal;
  CK_C_MessageSignInit C_MessageSignInit;
  CK_C_SignMessage C_SignMessage;
  CK_C_SignMessageBegin C_SignMessageBegin;
  CK_C_SignMessageNext C_SignMessageNext;
  CK_C_MessageSignFinal C_MessageSignFinal;
  CK_C_MessageVerifyInit C_MessageVerifyInit;
  CK_C_VerifyMessage C_VerifyMessage;
  CK_C_VerifyMessageBegin C_VerifyMessageBegin;
  CK_C_VerifyMessageNext C_VerifyMessageNext;
  CK_C_MessageVerifyFinal C_MessageVerifyFinal;
} CK_FUNCTION_LIST_3_0;
~~~

For a general description of **CK_FUNCTION_LIST_3_0** see **CK_FUNCTION_LIST**.

In this structure, _version_ is the cryptoki specification version number. It
should match the value of cryptokiVersion returned in the **CK_INFO**
structure, but must be 3.0 at minimum.

This function list may be returned via **C_GetInterfaceList** or
**C_GetInterface**

**CK_FUNCTION_LIST_3_0_PTR** is a pointer to a **CK_FUNCTION_LIST_3_0**.
**CK_FUNCTION_LIST_3_0_PTR_PTR** is a pointer to a **CK_FUNCTION_LIST_3_0_PTR**.

### CK_FUNCTION_LIST_3_2

**CK_FUNCTION_LIST_3_2** is a structure which contains the same function
pointers as in **CK_FUNCTION_LIST_3_0** and additional functions added to the
end of the structure that were defined in Cryptoki version 3.2. It is defined
as follows:

~~~{.c}
typedef struct CK_FUNCTION_LIST_3_2 {
  CK_VERSION version;
  CK_C_Initialize C_Initialize;
  CK_C_Finalize C_Finalize;
  CK_C_GetInfo C_GetInfo;
  CK_C_GetFunctionList C_GetFunctionList;
  CK_C_GetSlotList C_GetSlotList;
  CK_C_GetSlotInfo C_GetSlotInfo;
  CK_C_GetTokenInfo C_GetTokenInfo;
  CK_C_GetMechanismList C_GetMechanismList;
  CK_C_GetMechanismInfo C_GetMechanismInfo;
  CK_C_InitToken C_InitToken;
  CK_C_InitPIN C_InitPIN;
  CK_C_SetPIN C_SetPIN;
  CK_C_OpenSession C_OpenSession;
  CK_C_CloseSession C_CloseSession;
  CK_C_CloseAllSessions C_CloseAllSessions;
  CK_C_GetSessionInfo C_GetSessionInfo;
  CK_C_GetOperationState C_GetOperationState;
  CK_C_SetOperationState C_SetOperationState;
  CK_C_Login C_Login;
  CK_C_Logout C_Logout;
  CK_C_CreateObject C_CreateObject;
  CK_C_CopyObject C_CopyObject;
  CK_C_DestroyObject C_DestroyObject;
  CK_C_GetObjectSize C_GetObjectSize;
  CK_C_GetAttributeValue C_GetAttributeValue;
  CK_C_SetAttributeValue C_SetAttributeValue;
  CK_C_FindObjectsInit C_FindObjectsInit;
  CK_C_FindObjects C_FindObjects;
  CK_C_FindObjectsFinal C_FindObjectsFinal;
  CK_C_EncryptInit C_EncryptInit;
  CK_C_Encrypt C_Encrypt;
  CK_C_EncryptUpdate C_EncryptUpdate;
  CK_C_EncryptFinal C_EncryptFinal;
  CK_C_DecryptInit C_DecryptInit;
  CK_C_Decrypt C_Decrypt;
  CK_C_DecryptUpdate C_DecryptUpdate;
  CK_C_DecryptFinal C_DecryptFinal;
  CK_C_DigestInit C_DigestInit;
  CK_C_Digest C_Digest;
  CK_C_DigestUpdate C_DigestUpdate;
  CK_C_DigestKey C_DigestKey;
  CK_C_DigestFinal C_DigestFinal;
  CK_C_SignInit C_SignInit;
  CK_C_Sign C_Sign;
  CK_C_SignUpdate C_SignUpdate;
  CK_C_SignFinal C_SignFinal;
  CK_C_SignRecoverInit C_SignRecoverInit;
  CK_C_SignRecover C_SignRecover;
  CK_C_VerifyInit C_VerifyInit;
  CK_C_Verify C_Verify;
  CK_C_VerifyUpdate C_VerifyUpdate;
  CK_C_VerifyFinal C_VerifyFinal;
  CK_C_VerifyRecoverInit C_VerifyRecoverInit;
  CK_C_VerifyRecover C_VerifyRecover;
  CK_C_DigestEncryptUpdate C_DigestEncryptUpdate;
  CK_C_DecryptDigestUpdate C_DecryptDigestUpdate;
  CK_C_SignEncryptUpdate C_SignEncryptUpdate;
  CK_C_DecryptVerifyUpdate C_DecryptVerifyUpdate;
  CK_C_GenerateKey C_GenerateKey;
  CK_C_GenerateKeyPair C_GenerateKeyPair;
  CK_C_WrapKey C_WrapKey;
  CK_C_UnwrapKey C_UnwrapKey;
  CK_C_DeriveKey C_DeriveKey;
  CK_C_SeedRandom C_SeedRandom;
  CK_C_GenerateRandom C_GenerateRandom;
  CK_C_GetFunctionStatus C_GetFunctionStatus;
  CK_C_CancelFunction C_CancelFunction;
  CK_C_WaitForSlotEvent C_WaitForSlotEvent;
  CK_C_GetInterfaceList C_GetInterfaceList;
  CK_C_GetInterface C_GetInterface;
  CK_C_LoginUser C_LoginUser;
  CK_C_SessionCancel C_SessionCancel;
  CK_C_MessageEncryptInit C_MessageEncryptInit;
  CK_C_EncryptMessage C_EncryptMessage;
  CK_C_EncryptMessageBegin C_EncryptMessageBegin;
  CK_C_EncryptMessageNext C_EncryptMessageNext;
  CK_C_MessageEncryptFinal C_MessageEncryptFinal;
  CK_C_MessageDecryptInit C_MessageDecryptInit;
  CK_C_DecryptMessage C_DecryptMessage;
  CK_C_DecryptMessageBegin C_DecryptMessageBegin;
  CK_C_DecryptMessageNext C_DecryptMessageNext;
  CK_C_MessageDecryptFinal C_MessageDecryptFinal;
  CK_C_MessageSignInit C_MessageSignInit;
  CK_C_SignMessage C_SignMessage;
  CK_C_SignMessageBegin C_SignMessageBegin;
  CK_C_SignMessageNext C_SignMessageNext;
  CK_C_MessageSignFinal C_MessageSignFinal;
  CK_C_MessageVerifyInit C_MessageVerifyInit;
  CK_C_VerifyMessage C_VerifyMessage;
  CK_C_VerifyMessageBegin C_VerifyMessageBegin;
  CK_C_VerifyMessageNext C_VerifyMessageNext;
  CK_C_MessageVerifyFinal C_MessageVerifyFinal;
  CK_C_EncapsulateKey C_EncapsulateKey;
  CK_C_DecapsulateKey C_DecapsulateKey;
  CK_C_VerifySignatureInit C_VerifySignatureInit;
  CK_C_VerifySignature C_VerifySignature;
  CK_C_VerifySignatureUpdate C_VerifySignatureUpdate;
  CK_C_VerifySignatureFinal C_VerifySignatureFinal;
  CK_C_GetSessionValidationFlags C_GetSessionValidationFlags;
  CK_C_AsyncComplete C_AsyncComplete;
  CK_C_AsyncGetID C_AsyncGetID;
  CK_C_AsyncJoin C_AsyncJoin;
} CK_FUNCTION_LIST_3_2;
~~~

For a general description of **CK_FUNCTION_LIST_3_2** see **CK_FUNCTION_LIST**.

In this structure, _version_ is the cryptoki specification version number. It
should match the value of cryptokiVersion returned in the **CK_INFO**
structure, but must be 3.2 at minimum.

This function list may be returned via **C_GetInterfaceList** or
**C_GetInterface**

**CK_FUNCTION_LIST_3_2_PTR** is a pointer to a **CK_FUNCTION_LIST_3_2**.
**CK_FUNCTION_LIST_3_2_PTR_PTR** is a pointer to a
**CK_FUNCTION_LIST_3_2_PTR**.

### CK_INTERFACE

**CK_INTERFACE** is a structure which contains an interface name with a
function list and flag. It is defined as follows:

~~~{.c}
typedef struct CK_INTERFACE {
  CK_UTF8CHAR_PTR pInterfaceName;
  CK_VOID_PTR     pFunctionList;
  CK_FLAGS        flags;
} CK_INTERFACE;
~~~

The fields of the structure have the following meanings:

_pInterfaceName_
: the name of the interface

_pFunctionList_
: the interface function list which must always begin with a CK_VERSION
  structure as the first field

_flags_
: bit flags specifying interface capabilities

The interface name “PKCS 11” is reserved for use by interfaces defined within
the cryptoki specification.

Interfaces starting with the string: “Vendor ” are reserved for vendor use and
will not oetherwise be defined as interfaces in the PKCS #11 specification.
Vendors should supply new functions with interface names of “Vendor {vendor
name}”. For example “Vendor ACME Inc”.

The following table defines the flags field:

| Bit Flag                | Mask       | Meaning                |
|-------------------------|------------|------------------------|
| CKF_INTERFACE_FORK_SAFE | 0x00000001 | The returned interface will have fork tolerant semantics.  When the application forks, each process will get its own copy of all session objects, session states, login states, and encryption states. Each process will also maintain access to token objects with their previously supplied handles.|
table: CK_INTERFACE Flags

**CK_INTERFACE_PTR** is a pointer to a **CK_INTERFACE**.
**CK_INTERFACE_PTR_PTR** is a pointer to a **CK_INTERFACE_PTR**.

### CK_ASYNC_DATA

**CK_ASYNC_DATA** is a structure used by asynchronous function management
functions. It is defined as follows:

~~~{.c}
typedef struct CK_ASYNC_DATA {
  CK_ULONG ulVersion;
  CK_BYTE_PTR pValue;
  CK_ULONG ulValue;
  CK_OBJECT_HANDLE hObject;
  CK_OBJECT_HANDLE hAdditionalObject;
} CK_ASYNC_DATA;
~~~

The fields of the structure have the following meanings:

_ulVersion_
: version of this structure; always 0 for this version of Cryptoki

_pValue_
: on completion contains a pointer to the original input buffer, caller is
  responsible for this memory

_ulValue_
: size of the result

_hObject_
: receives the handle for an object resulting from the operation

_hAdditionalObject_
: receives the handle for an additional object resulting from the operation

**CK_ASYNC_DATA_PTR** is a pointer to a **CK_ASYNC_DATA**.

## Locking-related types

The types in this section are provided solely for applications which need to
access Cryptoki from multiple threads simultaneously. Applications which will
not do this need not use any of these types.

### CK_CREATEMUTEX

**CK_CREATEMUTEX** is the type of a pointer to an application-supplied
function which creates a new mutex object and returns a pointer to it. It is
defined as follows:

~~~{.c}
typedef CK_CALLBACK_FUNCTION(CK_RV, CK_CREATEMUTEX)(
  CK_VOID_PTR_PTR ppMutex
);
~~~

Calling a **CK_CREATEMUTEX** function returns the pointer to the new mutex
object in the location pointed to by ppMutex. Such a function should return
one of the following values:

~~~{.c}
CKR_OK, CKR_GENERAL_ERROR
CKR_HOST_MEMORY
~~~

### CK_DESTROYMUTEX

**CK_DESTROYMUTEX** is the type of a pointer to an application-supplied
function which destroys an existing mutex object. It is defined as follows:

~~~{.c}
typedef CK_CALLBACK_FUNCTION(CK_RV, CK_DESTROYMUTEX)(
  CK_VOID_PTR pMutex
);
~~~

The argument to a **CK_DESTROYMUTEX** function is a pointer to the mutex
object to be destroyed. Such a function should return one of the following
values:

~~~{.c}
CKR_OK, CKR_GENERAL_ERROR
CKR_HOST_MEMORY
CKR_MUTEX_BAD
~~~

### CK_LOCKMUTEX and CK_UNLOCKMUTEX

**CK_LOCKMUTEX** is the type of a pointer to an application-supplied function
which locks an existing mutex object. **CK_UNLOCKMUTEX** is the type of a
pointer to an application-supplied function which unlocks an existing mutex
object. The proper behavior for these types of functions is as follows:

* If a CK_LOCKMUTEX function is called on a mutex which is not locked, the
  calling thread obtains a lock on that mutex and returns.
* If a CK_LOCKMUTEX function is called on a mutex which is locked by some
  thread other than the calling thread, the calling thread blocks and waits
  for that mutex to be unlocked.
* If a CK_LOCKMUTEX function is called on a mutex which is locked by the
  calling thread, the behavior of the function call is undefined.
* If a CK_UNLOCKMUTEX function is called on a mutex which is locked by the
  calling thread, that mutex is unlocked and the function call returns.
  Furthermore:
  * If exactly one thread was blocking on that particular mutex, then that
    thread stops blocking, obtains a lock on that mutex, and its
    CK_LOCKMUTEX call returns.
  * If more than one thread was blocking on that particular mutex, then
    exactly one of the blocking threads is selected somehow. That lucky
    thread stops blocking, obtains a lock on the mutex, and its
    CK_LOCKMUTEX call returns. All other threads blocking on that particular
    mutex continue to block.
* If a CK_UNLOCKMUTEX function is called on a mutex which is not locked, then
  the function call returns the error code **CKR_MUTEX_NOT_LOCKED**.
* If a CK_UNLOCKMUTEX function is called on a mutex which is locked by some
  thread other than the calling thread, the behavior of the function call is
  undefined.

**CK_LOCKMUTEX** is defined as follows:

~~~{.c}
typedef CK_CALLBACK_FUNCTION(CK_RV, CK_LOCKMUTEX)(
  CK_VOID_PTR pMutex
);
~~~

The argument to a CK_LOCKMUTEX function is a pointer to the mutex object to be
locked. Such a function should return one of the following values:

~~~{.c}
CKR_OK, CKR_GENERAL_ERROR
CKR_HOST_MEMORY,
CKR_MUTEX_BAD
~~~

**CK_UNLOCKMUTEX** is defined as follows:

~~~{.c}
typedef CK_CALLBACK_FUNCTION(CK_RV, CK_UNLOCKMUTEX)(
  CK_VOID_PTR pMutex
);
~~~

The argument to a CK_UNLOCKMUTEX function is a pointer to the mutex object to
be unlocked. Such a function should return one of the following values:

~~~{.c}
CKR_OK, CKR_GENERAL_ERROR
CKR_HOST_MEMORY
CKR_MUTEX_BAD
CKR_MUTEX_NOT_LOCKED
~~~

### CK_C_INITIALIZE_ARGS

**CK_C_INITIALIZE_ARGS** is a structure containing the optional arguments for
the **C_Initialize** function. For this version of Cryptoki, these optional
arguments are all concerned with the way the library deals with threads.
**CK_C_INITIALIZE_ARGS** is defined as follows:

~~~ {#mycode .c}
typedef struct CK_C_INITIALIZE_ARGS {
  CK_CREATEMUTEX CreateMutex;
  CK_DESTROYMUTEX DestroyMutex;
  CK_LOCKMUTEX LockMutex;
  CK_UNLOCKMUTEX UnlockMutex;
  CK_FLAGS flags;
  CK_VOID_PTR pReserved;
} CK_C_INITIALIZE_ARGS;
~~~

The fields of the structure have the following meanings:

_CreateMutex_
: pointer to a function to use for creating mutex objects

_DestroyMutex_
: pointer to a function to use for destroying mutex objects

_LockMutex_
: pointer to a function to use for locking mutex objects

_UnlockMutex_
: pointer to a function to use for unlocking mutex objects

_flags_
: bit flags specifying options for C_Initialize; the flags are defined below

_pReserved_
: reserved for future use. Should be NULL_PTR for this version of Cryptoki

The following table defines the flags field:

| Bit Flag                           | Mask       | Meaning     |
|------------------------------------|------------|-------------|
| CKF_LIBRARY_CANT_CREATE_OS_THREADS | 0x00000001 | True if application threads which are executing calls to the library may not use native operating system calls to spawn new threads; false if they may |
| CKF_OS_LOCKING_OK                  | 0x00000002 | True if the library can use the native operation system threading model for locking; false otherwise |
table: C_Initialize Parameter Flags

**CK_C_INITIALIZE_ARGS_PTR** is a pointer to a **CK_C_INITIALIZE_ARGS**
