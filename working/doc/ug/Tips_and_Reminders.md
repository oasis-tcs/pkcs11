# Cryptoki tips and reminders

## Operations, sessions, and threads

In Cryptoki, there are several different types of operations which can be
"active" in a session. An active operation is essentially one which takes more
than one Cryptoki function call to perform. The types of active operations are
object searching; encryption; decryption; message-digesting; signature with
appendix; signature with recovery; verification with appendix; and verification
with recovery.

A given session can have 0, 1, or 2 operations active at a time. It can only
have 2 operations active simultaneously if the token supports this; moreover,
those two operations must be one of the four following pairs of operations:
digesting and encryption; decryption and digesting; signing and encryption;
decryption and verification.

If an application attempts to initialize an operation (make it active) in a
session, but this cannot be accomplished because of some other active
operation(s), the application receives the error value CKR_OPERATION_ACTIVE.
This error value can also be received if a session has an active operation and
the application attempts to use that session to perform any of various
operations which do not become "active", but which require cryptographic
processing, such as using the token's random number generator, or
generating/wrapping/unwrapping/deriving a key.

To abandon an active operation an application may have to complete the operation
and discard the result. Closing the session will also have this effect.
Alternatively, the library may allow active operations to be abandoned by the
application, simply by allowing initialization for some other operation. In this
case CKR_OPERATION_ACTIVE will not be returned but the previous active operation
will be unusable.

Different threads of an application should never share sessions, unless they are
extremely careful not to make function calls at the same time. This is true even
if the Cryptoki library was initialized with locking enabled for thread-safety.

## Multiple application access behavior

When multiple applications, or multiple threads within an application, are
accessing a set of common objects the issue of object protection becomes
important. This is especially the case when application A activates an operation
using object O, and application B attempts to delete O before application A has
finished the operation. Unfortunately, variation in device capabilities makes an
absolute behavior specification impractical. General guidelines are presented
here for object protection behavior.

Whenever possible, deleting an object in one application should not cause that
object to become unavailable to another application or thread that is using the
object in an active operation until that operation is complete. For instance,
application A has begun a signature operation with private key P and application
B attempts to delete P while the signature is in progress. In this case, one of
two things should happen. The object is deleted from the device, but the
operation is allowed to complete because the operation uses a temporary copy of
the object, or the delete operation blocks until the signature operation has
completed. If neither of these actions can be supported by an implementation,
then the error code CKR_OBJECT_HANDLE_INVALID may be returned to application A
to indicate that the key being used to perform its active operation has been
deleted.

Whenever possible, changing the value of an object attribute should impact the
behavior of active operations in other applications or threads. If this cannot
be supported by an implementation, then the appropriate error code indicating
the reason for the failure should be returned to the application with the active
operation.

## Objects, attributes, and templates

In general, a Cryptoki function which requires a template for an object needs
the template to specify - either explicitly or implicitly - any attributes that
are not specified elsewhere. If a template specifies a particular attribute more
than once, the function can return CKR_TEMPLATE_INVALID or it can choose a
particular value of the attribute from among those specified and use that value.
In any event, object attributes are always single-valued.

## Signing with recovery

Signing with recovery is a general alternative to ordinary digital signatures
("signing with appendix") which is supported by certain mechanisms. Recall that
for ordinary digital signatures, a signature of a message is computed as some
function of the message and the signer's private key; this signature can then be
used (together with the message and the signer's public key) as input to the
verification process, which yields a simple "signature valid/signature invalid"
decision.

Signing with recovery also creates a signature from a message and the signer's
private key. However, to verify this signature, no message is required as input.
Only the signature and the signer's public key are input to the verification
process, and the verification process outputs either "signature invalid" or - if
the signature is valid - the original message.

Consider a simple example with the **CKM_RSA_X_509** mechanism. Here, a message
is a byte string which we will consider to be a number modulo n (the signer's
RSA modulus). When this mechanism is used for ordinary digital signatures
(signatures with appendix), a signature is computed by raising the message to
the signer's private exponent modulo n. To verify this signature, a verifier
raises the signature to the signer's public exponent modulo n, and accepts the
signature as valid if and only if the result matches the original message.

If `CKM_RSA_X_509` is used to create signatures with recovery, the signatures
are produced in exactly the same fashion. For this particular mechanism, any
number modulo n is a valid signature. To recover the message from a signature,
the signature is raised to the signer's public exponent modulo n.
