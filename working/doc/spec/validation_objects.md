## Validation objects

### Definitions

This section defines the object class **CKO_VALIDATION** for type
CK_OBJECT_CLASS as used in the **CKA_CLASS** attribute of objects.

### Overview

Validation objects (object class **CKO_VALIDATION**) describe which third
party validations the module conforms to. Validation objects are read only,
token objects.

| Attribute                | Data Type          | Meaning                 |
|--------------------------|--------------------|-------------------------|
| CKA_VALIDATION_TYPE      | CK_VALIDATION_TYPE | Identifier indicating the validation type |
| CKA_VALIDATION_VERSION   | CK_VERSION         | Version of the validation standard or specification |
| CKA_VALIDATION_LEVEL     | CK_ULONG           | Validation level, Meaning is Validation type specific |
| CKA_VALIDATION_MODULE_ID | CK_UTF8CHAR        | How the module is identified in the validation documentation |
| CKA_VALIDATION_FLAG      | CK_FLAGS           | Flags identifying this validation in sessions and objects |
| CKA_VALIDATION_AUTHORITY_TYPE | CK_VALIDATION_AUTHORITY_TYPE | Identifies the authority that issues the validation |
| CKA_VALIDATION_COUNTRY ^1^ | CK_UTF8CHAR      | 2 letter ISO country code |
| CKA_VALIDATION_CERTIFICATE_IDENTIFIER ^1^ | CK_UTF8CHAR | Identifier of the validation certificate |
| CKA_VALIDATION_CERTIFICATE_URI ^1^ | CK_UTF8CHAR | Validation authority URI from which information related to the validation is available. If the Validation Certificate URI is not provided, the validation object SHOULD include a Validation Vendor URI. |
| CKA_VALIDATION_VENDOR_URI ^1^ | CK_UTF8CHAR   | Validation Vendor URI from which information related to the validation is available. |
| CKA_VALIDATION_PROFILE ^1^ | CK_UTF8CHAR      | Profile used for validation |
table: Validation Object Attributes

^1^ Optional value; may be empty.

#### CK_VALIDATION_TYPE
\  

**CK_VALIDATION_TYPE** identifies the type of validation. It is defined as
follows:

~~~{.c}
typedef CK_ULONG CK_VALIDATION_TYPE;
typedef CK_VALIDATION_TYPE CK_PTR CK_VALIDATION_TYPE_PTR;
~~~

Valid values are:  
- CKV_TYPE_UNSPECIFIED  
- CKV_TYPE_SOFTWARE  
- CKV_TYPE_HARDWARE  
- CKV_TYPE_FIRMWARE  
- CKV_TYPE_HYBRID  

#### CK_VALIDATION_AUTHORITY_TYPE
\  

**CK_VALIDATION_AUTHORITY_TYPE** identifies the authority that issues the
validation. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_VALIDATION_AUTHORITY_TYPE;
typedef CK_VALIDATION_AUTHORITY_TYPE CK_PTR CK_VALIDATION_AUTHORITY_TYPE_PTR;
~~~

Valid values are:  
- CKV_AUTHORITY_TYPE_UNSPECIFIED  
- CKV_AUTHORITY_TYPE_NIST_CMVP  
- CKV_AUTHORITY_TYPE_COMMON_CRITERIA  

### Validation Indicators

Validation indicators are runtime indicators if a particular operation meets
the appropriate criteria for this module running under the given validation
rules. These rules will vary by validation type and even by different modules
using various validation types.

#### Session validation flags
\  

Sessions carry validation flags. These can be queried with
**C_GetSessionValidationFlags**. Session validation flags are defined as
follows:

~~~{.c}
typedef CK_ULONG CK_SESSION_VALIDATION_FLAGS_TYPE;
~~~

Valid values are:  
- CKS_LAST_VALIDATION_OK  

##### Last operation flags
\  

The last operation flag is set if the last operation that completed (the last
**C_XXXFinal**, or the last single short operation **C_WrapKey**,
**C_DeriveKey**, etc.) met all the requirements of a validated mechanism.
This allows access to the state of operations that don’t return a key object.

#### Key object state
\  

**CKA_OBJECT_VALIDATION_FLAGS** can only be set in ways conforming to the
module’s validation. Key objects typically take on the flags of the operation
that created them, but are subject to the modules requirements under the
module’s validation.

Application notes:

Applications should be prepared for changes in semantics as various
validations change their guidance.

Many of these operation chains, so in SSL, if the final key objects have the
appropriate flags set in **CKA_OBJECT_VALIDATION_FLAGS**, then it generally
means that all the operations (unwrap, key_derive, etc.) occurred in a manner
that matches the module’s validation, so the application would generally only
need to query the validation flags of the final keys.
