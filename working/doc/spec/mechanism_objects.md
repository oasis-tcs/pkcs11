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
| CKA_SUPPORTED_PARAMETER_SETS | CK_ULONG_PTR | Array of parameter sets suported
by the mechanism. The number of entries in the array is the ulValueLen component
of the attribute divided by the size of CK_ULONG |
| CKA_FLAGS | CK_FLAGS | Bit flags specifying mechanism capabilities |
table: Common Mechanism Attributes

The **CKO_MECHANISM** object allows applications to probe information about what
parameter sets are supported by specific mechanisms. This is used to signal to
applications partial implementations of mechanisms where not all the parameter
sets are supported (perhaps because new parameters were added in a later
specification).

For example, if a token supports only fast paraemter sets for the
**CKM_SLH_DSA** mechanism, the **CKO_MECHANISM** object representing this
mechanism will contain a **CKA_SUPPORTED_PARAMETER_SETS** array with only
parameters like **CKP_SLH_DSA_SHA2_128F** but none of the small ones like
**CKP_SLH_DSA_SHA2_128S**.

Note: applications SHOULD verify the parameter set they want to use is supported
by the speific mechanism they intend to use and not make assumptions based on
the presence of objects on the token or related mechanisms.  For example related
mechanism (like CKM_ML_KEM and CKM_ML_KEM_KEY_PAIR_GEN) may not necessarily
support the same set of parameters if a token can import and use but not
generate keys with certain parameters, possibly because a security certification
allow to use old keys for verification operations but do not allow generating
new keys with parameter ets considered weak.

The **CKA_MECHANISM_TYPE** is required to allow applications to find information
about a specific mechanism.
