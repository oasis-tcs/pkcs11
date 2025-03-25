## Mechanism objects

### Definitions

This section defines the object class **CKO_MECHANISM** for type
CK_OBJECT_CLASS as used in the **CKA_CLASS** attribute of objects.

### Overview

Mechanism objects provide information about mechanisms supported by a device
beyond that given by the **CK_MECHANISM_INFO** structure.

| Attribute          | Data Type         | Meaning                        |
|--------------------|-------------------|--------------------------------|
| CKA_MECHANISM_TYPE | CK_MECHANISM_TYPE | The type of mechanism object   |
table: Common Mechanism Attributes

The **CKA_MECHANISM_TYPE** attribute may not be set.
