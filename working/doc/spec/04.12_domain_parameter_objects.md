## Domain parameter objects

### Definitions

This section defines the object class **CKO_DOMAIN_PARAMETERS** for type
CK_OBJECT_CLASS as used in the **CKA_CLASS** attribute of objects.

### Overview

This object class was created to support the storage of certain algorithm's
extended parameters. DSA and DH both use domain parameters in the key-pair
generation step. In particular, some libraries support the generation of
domain parameters (originally out of scope for PKCS11) so the object class
was added.

To use a domain parameter object you MUST extract the attributes into a
template and supply them (still in the template) to the corresponding key-pair
generation function.

Domain parameter objects (object class **CKO_DOMAIN_PARAMETERS**) hold public
domain parameters.

The following table defines the attributes common to domain parameter objects
in addition to the common attributes defined for this object class:

| Attribute	       | Data Type   | Meaning                               |
|------------------|-------------|---------------------------------------|
| CKA_KEY_TYPE ^1^ | CK_KEY_TYPE | Type of key the domain parameters can be used to generate. |
| CKA_LOCAL ^2,4^  | CK_BBOOL    | CK_TRUE only if domain parameters were either |
|                  |             | • generated locally (i.e., on the token) with a **C_GenerateKey** |
|                  |             | • created with a **C_CopyObject** call as a copy of domain parameters which had its **CKA_LOCAL** attribute set to CK_TRUE |
table: Common Domain Parameter Attributes

 * Refer to Table 13 for footnotes

The **CKA_LOCAL** attribute has the value CK_TRUE if and only if the values
of the domain parameters were originally generated on the token by a
**C_GenerateKey** call.
