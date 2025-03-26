## Callback functions

Cryptoki sessions can use function pointers of type **CK_NOTIFY** to notify the
application of certain events.

### Surrender callbacks

Cryptographic functions (_i.e._, any functions falling under one of these
categories: encryption functions; decryption functions; message digesting
functions; signing and MACing functions; functions for verifying signatures and
MACs; dual-purpose cryptographic functions; key management functions; random
number generation functions) executing in Cryptoki sessions can periodically
surrender control to the application who called them if the session they are
executing in had a notification callback function associated with it when it was
opened. They do this by calling the session’s callback with the arguments
(_hSession_, **CKN_SURRENDER**, _pApplication_), where _hSession_ is the
session’s handle and pApplication was supplied to **C_OpenSession** when the
session was opened.  Surrender callbacks should return either the value
**CKR_OK** (to indicate that Cryptoki should continue executing the function) or
the value **CKR_CANCEL** (to indicate that Cryptoki should abort execution of
the function). Of course, before returning one of these values, the callback
function can perform some computation, if desired.

A typical use of a surrender callback might be to give an application user
feedback during a lengthy key pair generation operation. Each time the
application receives a callback, it could display an additional “.” to the user.
It might also examine the keyboard’s activity since the last surrender callback,
and abort the key pair generation operation (probably by returning the value
**CKR_CANCEL**) if the user hit <ESCAPE>.

A Cryptoki library is not required to make any surrender callbacks.

### Vendor-defined callbacks

Library vendors can also define additional types of callbacks. Because of this
extension capability, application-supplied notification callback routines should
examine each callback they receive, and if they are unfamiliar with the type of
that callback, they should immediately give control back to the library by
returning with the value **CKR_OK**.
