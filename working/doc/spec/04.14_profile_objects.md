## Profile objects

### Definitions

This section defines the object class **CKO_PROFILE** for type
CK_OBJECT_CLASS as used in the **CKA_CLASS** attribute of objects.

### Overview

Profile objects (object class **CKO_PROFILE**) describe which PKCS #11
profiles the token implements. Profiles are defined in the OASIS PKCS #11
Cryptographic Token Interface Profiles document. A given token can
contain more than one profile ID. The following table lists the attributes
supported by profile objects, in addition to the common attributes defined
for this object class:

| Attribute       | Data type     | Meaning                              |
|-----------------|---------------|--------------------------------------|
| CKA_PROFILE_ID  | CK_PROFILE_ID | ID of the supported profile.         |
table: Profile Object Attributes

The **CKA_PROFILE_ID** attribute identifies a profile that the token
supports.
