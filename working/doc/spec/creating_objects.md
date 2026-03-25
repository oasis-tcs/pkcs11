## Creating, modifying, and copying objects

All Cryptoki functions that create, modify, or copy objects take a template as
one of their arguments, where the template specifies attribute values.

Cryptographic functions that create objects (see Section [5.19][Key management
functions]) may also contribute some additional attribute values themselves;
which attributes have values contributed by a cryptographic function call
depends on which cryptographic mechanism is being performed (see section
[6][Mechanisms] and [PKCS11-Hist] for specification of mechanisms for PKCS #11).

In any case, all the required attributes supported by an object class that do
not have default values MUST be specified when an object is created, either in
the template or by the function itself.

### Creating objects

Objects may be created with the Cryptoki functions **C_CreateObject** (see
Section [5.7][Object management functions]), **C_GenerateKey**,
**C_GenerateKeyPair**, **C_UnwrapKey**, **C_DeriveKey**, **C_EncapsulateKey**,
and **C_DecapsulateKey** (see Section [5.19][Key management functions]). In
addition, copying an existing object (with the function **C_CopyObject**) also
creates a new object, but we consider this type of object creation separately in
Section [4.1.3][Copying objects].

Note: Generally only objects that are considered Storage Objects (Section
[4.4][Storage Objects]) can be created on a token, other kinds of object are
generally built-in and attempting to create new objects of those kinds will
result in an error.

Attempting to create an object with any of these functions requires an
appropriate template to be supplied.

#. If the supplied template specifies a value for an invalid attribute, then
   the attempt should fail with the error code **CKR_ATTRIBUTE_TYPE_INVALID**.
   An attribute is valid if it is either one of the attributes described in
   the Cryptoki specification or an additional vendor-specific attribute
   supported by the library and token.

#. If the supplied template specifies an invalid value for a valid attribute,
   then the attempt should fail with the error code
   **CKR_ATTRIBUTE_VALUE_INVALID**. The valid values for Cryptoki attributes
   are described in the Cryptoki specification.

#. If the supplied template specifies a value for a read-only attribute, then
   the attempt should fail with the error code **CKR_ATTRIBUTE_READ_ONLY**.
   Whether or not a given Cryptoki attribute is read-only is explicitly stated
   in the Cryptoki specification; however, a particular library and token may
   be even more restrictive than Cryptoki specifies. In other words, an
   attribute which Cryptoki says is not read-only may nonetheless be read-only
   under certain circumstances (i.e., in conjunction with some combinations of
   other attributes) for a particular library and token. Whether or not a
   given non-Cryptoki attribute is read-only is obviously outside the scope of
   Cryptoki.

#. If the attribute values in the supplied template, together with any default
   attribute values and any attribute values contributed to the object by the
   object-creation function itself, are insufficient to fully specify the
   object to create, then the attempt should fail with the error code
   **CKR_TEMPLATE_INCOMPLETE**.

#. If the attribute values in the supplied template, together with any default
   attribute values and any attribute values contributed to the object by the
   object-creation function itself, are inconsistent, then the attempt should
   fail with the error code **CKR_TEMPLATE_INCONSISTENT**. A set of attribute
   values is inconsistent if not all of its members can be satisfied
   simultaneously by the token, although each value individually is valid in
   Cryptoki. One example of an inconsistent template would be using a template
   which specifies two different values for the same attribute. Another
   example would be trying to create a secret key object with an attribute
   which is appropriate for various types of public keys or private keys, but
   not for secret keys. A final example would be a template with an attribute
   that violates some token specific requirement. Note that this final example
   of an inconsistent template is token-dependent—on a different token, such a
   template might not be inconsistent.

#. If the supplied template specifies the same value for a particular attribute
   more than once (or the template specifies the same value for a particular
   attribute that the object-creation function itself contributes to the
   object), then the behavior of Cryptoki is not completely specified. The
   attempt to create an object can either succeed — thereby creating the same
   object that would have been created if the multiply-specified attribute had
   only appeared once — or it can fail with error code
   **CKR_TEMPLATE_INCONSISTENT**. Library developers are encouraged to make
   their libraries behave as though the attribute had only appeared once in the
   template; application developers are strongly encouraged never to put a
   particular attribute into a particular template more than once.

If more than one of the situations listed above applies to an attempt to create
an object, then the error code returned from the attempt can be any of the
error codes from above that applies.

### Modifying objects

Objects may be modified with the Cryptoki function **C_SetAttributeValue** (see
`Section [5.7][Object management functions]). The template supplied to
**C_SetAttributeValue** can contain new values for attributes which the object
already possesses; values for attributes which the object does not yet possess;
or both.

Some attributes of an object may be modified after the object has been created,
and some may not. In addition, attributes which Cryptoki specifies are
modifiable may actually not be modifiable on some tokens. That is, if a
Cryptoki attribute is described as being modifiable, that really means only
that it is modifiable insofar as the Cryptoki specification is concerned. A
particular token might not actually support modification of some such
attributes. Furthermore, whether or not a particular attribute of an object on
a particular token is modifiable might depend on the values of certain
attributes of the object. For example, a secret key object’s **CKA_SENSITIVE**
attribute can be changed from CK_FALSE to CK_TRUE, but not the other way
around.

All the scenarios in Section [4.1.1][Creating objects] — and the error codes
they return — apply to modifying objects with **C_SetAttributeValue**, except
for the possibility of a template being incomplete.

### Copying objects

Unless an object's **CKA_COPYABLE** (see [Table 19]()) attribute is set to
CK_FALSE, it may be copied with the Cryptoki function **C_CopyObject** (see
Section [5.6.11][xxxxxxxxxx]. In the process of copying an object,
**C_CopyObject** also modifies the attributes of the newly-created copy
according to an application-supplied template.

The Cryptoki attributes which can be modified during the course of a
**C_CopyObject** operation are the same as the Cryptoki attributes which are
described as being modifiable, plus the four special attributes **CKA_TOKEN**,
**CKA_PRIVATE**, **CKA_MODIFIABLE** and **CKA_DESTROYABLE**. To be more
precise, these attributes are modifiable during the course of a
**C_CopyObject** operation insofar as the Cryptoki specification is concerned.
A particular token might not actually support modification of some such
attributes during the course of a **C_CopyObject** operation. Furthermore,
whether or not a particular attribute of an object on a particular token is
modifiable during the course of a **C_CopyObject** operation might depend on
the values of certain attributes of the object. For example, a secret key
object’s **CKA_SENSITIVE** attribute can be changed from CK_FALSE to CK_TRUE
during the course of a **C_CopyObject** operation, but not the other way
around.

If the **CKA_COPYABLE** attribute of the object to be copied is set to
CK_FALSE, **C_CopyObject** returns **CKR_ACTION_PROHIBITED**. Otherwise, the
scenarios described in 10.1.1 - and the error codes they return - apply to
copying objects with **C_CopyObject**, except for the possibility of a
template being incomplete.
