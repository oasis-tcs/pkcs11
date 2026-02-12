## Storage Objects

This is not an object class; hence no **CKO_** definition is required. It is
a category of object classes with common attributes for the object classes
that follow.

| Attribute        | Data Type      | Meaning                             |
|------------------|----------------|-------------------------------------|
| CKA_TOKEN        | CK_BBOOL       | CK_TRUE if object is a token object; CK_FALSE if object is a session object.\
                                      Default is CK_FALSE. |
| CKA_PRIVATE      | CK_BBOOL       | CK_TRUE if object is a private object; CK_FALSE if object is a public object.\
                                      Default value is token-specific, and may depend on the values of other\
                                      attributes of the object. |
| CKA_MODIFIABLE   | CK_BBOOL       | CK_TRUE if object can be modified Default is CK_TRUE. |
| CKA_LABEL        | RFC2279 string | Description of the object (default empty). |
| CKA_COPYABLE     | CK_BBOOL       | CK_TRUE if object can be copied using C_CopyObject. Defaults to CK_TRUE.\
                                      Can’t be set to TRUE once it is set to FALSE. |
| CKA_DESTROYABLE  | CK_BBOOL       | CK_TRUE if the object can be destroyed using C_DestroyObject. Default is CK_TRUE. |
table: Common Storage Object Attributes

- Refer to Table 13 for footnotes

Only the **CKA_LABEL** attribute can be modified after the object is created.
(The **CKA_TOKEN**, **CKA_PRIVATE**, and **CKA_MODIFIABLE** attributes can
be changed in the process of copying an object, however.)

The **CKA_TOKEN** attribute identifies whether the object is a token object
or a session object.

When the **CKA_PRIVATE** attribute is CK_TRUE, a user may not access the
object until the user has been authenticated to the token.

The value of the **CKA_MODIFIABLE** attribute determines whether or not an
object is read-only.

The **CKA_LABEL** attribute is intended to assist users in browsing.

The value of the **CKA_COPYABLE** attribute determines whether or not an
object can be copied. This attribute can be used in conjunction with
**CKA_MODIFIABLE** to prevent changes to the permitted usages of keys and
other objects.

The value of the **CKA_DESTROYABLE** attribute determines whether the object
can be destroyed using **C_DestroyObject**.
