## Object management functions

Cryptoki provides the following functions for managing objects. Additional
functions provided specifically for managing key objects are described in
Section 5.18.

### C_CreateObject

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_CreateObject)(
    CK_SESSION_HANDLE hSession,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulCount,
    CK_OBJECT_HANDLE_PTR phObject
);
~~~

**C_CreateObject** creates a new object. _hSession_ is the session’s handle;
_pTemplate_ points to the object’s template; _ulCount_ is the number of
attributes in the template; _phObject_ points to the location that receives the
new object’s handle.

If a call to **C_CreateObject** cannot support the precise template supplied to
it, it will fail and return without creating any object.

If **C_CreateObject** is used to create a key object, the key object will have
its **CKA_LOCAL** attribute set to CK_FALSE. If that key object is a secret or
private key then the new key will have the **CKA_ALWAYS_SENSITIVE** attribute
set to CK_FALSE, and the **CKA_NEVER_EXTRACTABLE** attribute set to CK_FALSE.

Only session objects can be created during a read-only session. Only public
objects can be created unless the normal user is logged in.

Whenever an object is created, a value for **CKA_UNIQUE_ID** is generated and
assigned to the new object (See Section 4.4.1).

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_READ_ONLY,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_ATTRIBUTE_VALUE_INVALID,
CKR_CRYPTOKI_NOT_INITIALIZED, CKR_CURVE_NOT_SUPPORTED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_DOMAIN_PARAMS_INVALID,
CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PARAMETER_SET_NOT_SUPPORTED, CKR_PENDING,
CKR_PIN_EXPIRED, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCOMPLETE, CKR_TEMPLATE_INCONSISTENT,
CKR_TOKEN_WRITE_PROTECTED, CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE
  hData,
  hCertificate,
  hKey;
CK_OBJECT_CLASS
  dataClass = CKO_DATA,
  certificateClass = CKO_CERTIFICATE,
  keyClass = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_RSA;
CK_UTF8CHAR application[] = {“My Application”};
CK_BYTE dataValue[] = {...};
CK_BYTE subject[] = {...};
CK_BYTE id[] = {...};
CK_BYTE certificateValue[] = {...};
CK_BYTE modulus[] = {...};
CK_BYTE exponent[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE dataTemplate[] = {
  {CKA_CLASS, &dataClass, sizeof(dataClass)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_APPLICATION, application, sizeof(application)-1},
  {CKA_VALUE, dataValue, sizeof(dataValue)}
};
CK_ATTRIBUTE certificateTemplate[] = {
  {CKA_CLASS, &certificateClass, sizeof(certificateClass)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_VALUE, certificateValue, sizeof(certificateValue)}
};
CK_ATTRIBUTE keyTemplate[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_WRAP, &true, sizeof(true)},
  {CKA_MODULUS, modulus, sizeof(modulus)},
  {CKA_PUBLIC_EXPONENT, exponent, sizeof(exponent)}
};
CK_RV rv;

.
.
/* Create a data object */
rv = C_CreateObject(hSession, dataTemplate, 4, &hData);
if (rv == CKR_OK) {
  .
  .
}

/* Create a certificate object */
rv = C_CreateObject(
  hSession, certificateTemplate, 5, &hCertificate);
if (rv == CKR_OK) {
  .
  .
}

/* Create an RSA public key object */
rv = C_CreateObject(hSession, keyTemplate, 5, &hKey);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_CopyObject

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_CopyObject)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hObject,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulCount,
    CK_OBJECT_HANDLE_PTR phNewObject
);
~~~

**C_CopyObject** copies an object, creating a new object for the copy.
_hSession_ is the session’s handle; _hObject_ is the object’s handle;
_pTemplate_ points to the template for the new object; _ulCount_ is the number
of attributes in the template; _phNewObject_ points to the location that
receives the handle for the copy of the object.

The template may specify new values for any attributes of the object that can
ordinarily be modified (e.g., in the course of copying a secret key, a key’s
**CKA_EXTRACTABLE** attribute may be changed from CK_TRUE to CK_FALSE, but not
the other way around. If this change is made, the new key’s
**CKA_NEVER_EXTRACTABLE** attribute will have the value CK_FALSE. Similarly, the
template may specify that the new key’s **CKA_SENSITIVE** attribute be CK_TRUE;
the new key will have the same value for its **CKA_ALWAYS_SENSITIVE** attribute
as the original key). It may also specify new values of the **CKA_TOKEN** and
**CKA_PRIVATE** attributes (e.g., to copy a session object to a token object).
If the template specifies a value of an attribute which is incompatible with
other existing attributes of the object, the call fails with the return code
**CKR_TEMPLATE_INCONSISTENT**.

If a call to **C_CopyObject** cannot support the precise template supplied to
it, it will fail and return without creating any object. If the object indicated
by hObject has its **CKA_COPYABLE** attribute set to CK_FALSE, **C_CopyObject**
will return **CKR_ACTION_PROHIBITED**.

Whenever an object is copied, a new value for **CKA_UNIQUE_ID** is generated and
assigned to the new object (See Section 4.4.1).

Only session objects can be created during a read-only session. Only public
objects can be created unless the normal user is logged in.

Return values: CKR_ACTION_PROHIBITED, CKR_ARGUMENTS_BAD,
CKR_ATTRIBUTE_READ_ONLY, CKR_ATTRIBUTE_TYPE_INVALID,
CKR_ATTRIBUTE_VALUE_INVALID, CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OBJECT_HANDLE_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCONSISTENT, CKR_TOKEN_WRITE_PROTECTED,
CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hKey, hNewKey;
CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_DES;
CK_BYTE id[] = {...};
CK_BYTE keyValue[] = {...};
CK_BBOOL false = CK_FALSE;
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE keyTemplate[] = {
  {CKA_CLASS, &keyClass, sizeof(keyClass)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &false, sizeof(false)},
  {CKA_ID, id, sizeof(id)},
  {CKA_VALUE, keyValue, sizeof(keyValue)}
};
CK_ATTRIBUTE copyTemplate[] = {
  {CKA_TOKEN, &true, sizeof(true)}
};
CK_RV rv;

.
.
/* Create a DES secret key session object */
rv = C_CreateObject(hSession, keyTemplate, 5, &hKey);
if (rv == CKR_OK) {
  /* Create a copy which is a token object */
  rv = C_CopyObject(hSession, hKey, copyTemplate, 1, &hNewKey);
  .
  .
}
~~~

### C_DestroyObject

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_DestroyObject)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hObject
);
~~~

**C_DestroyObject** destroys an object. _hSession_ is the session’s handle; and
_hObject_ is the object’s handle.

Only session objects can be destroyed during a read-only session. Only public
objects can be destroyed unless the normal user is logged in.

Certain objects may not be destroyed. Calling **C_DestroyObject** on such
objects will result in the **CKR_ACTION_PROHIBITED** error code. An application
can consult the object's **CKA_DESTROYABLE** attribute to determine if an object
may be destroyed or not.

Return values: CKR_ACTION_PROHIBITED, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OBJECT_HANDLE_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID, CKR_SESSION_READ_ONLY, CKR_TOKEN_WRITE_PROTECTED.

Example: see **C_GetObjectSize**.

### C_GetObjectSize

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetObjectSize)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hObject,
    CK_ULONG_PTR pulSize
);
~~~

**C_GetObjectSize** gets the size of an object in bytes. _hSession_ is the
session’s handle; _hObject_ is the object’s handle; _pulSize_ points to the
location that receives the size in bytes of the object.

Cryptoki does not specify what the precise meaning of an object’s size is.
Intuitively, it is some measure of how much token memory the object takes up. If
an application deletes (say) a private object of size S, it might be reasonable
to assume that the ulFreePrivateMemory field of the token’s **CK_TOKEN_INFO**
structure increases by approximately S.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_INFORMATION_SENSITIVE,
CKR_OBJECT_HANDLE_INVALID, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hObject;
CK_OBJECT_CLASS dataClass = CKO_DATA;
CK_UTF8CHAR application[] = {“My Application”};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &dataClass, sizeof(dataClass)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_APPLICATION, application, sizeof(application)-1},
  {CKA_VALUE, value, sizeof(value)}
};
CK_ULONG ulSize;
CK_RV rv;

.
.
rv = C_CreateObject(hSession, template, 4, &hObject);
if (rv == CKR_OK) {
  rv = C_GetObjectSize(hSession, hObject, &ulSize);
  if (rv != CKR_INFORMATION_SENSITIVE) {
    .
    .
  }

  rv = C_DestroyObject(hSession, hObject);
  .
  .
}
~~~

### C_GetAttributeValue

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_GetAttributeValue)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hObject,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulCount
);
~~~

**C_GetAttributeValue** obtains the value of one or more attributes of an
object. _hSession_ is the session’s handle; _hObject_ is the object’s handle;
_pTemplate_ points to a template that specifies which attribute values are to be
obtained, and receives the attribute values; _ulCount_ is the number of
attributes in the template.

For each (_type_, _pValue_, _ulValueLen_) triple in the template,
**C_GetAttributeValue** performs the following algorithm:

1. If the specified attribute (i.e., the attribute specified by the type field)
   for the object cannot be revealed because the object is sensitive or
   unextractable, then the ulValueLen field in that triple is modified to hold
   the value CK_UNAVAILABLE_INFORMATION.
2. Otherwise, if the specified value for the object is invalid (the object does
   not possess such an attribute), then the ulValueLen field in that triple is
   modified to hold the value CK_UNAVAILABLE_INFORMATION.
3. Otherwise, if the pValue field has the value NULL_PTR, then the ulValueLen
   field is modified to hold the exact length of the specified attribute for the
   object.
4. Otherwise, if the length specified in ulValueLen is large enough to hold the
   value of the specified attribute for the object, then that attribute is
   copied into the buffer located at pValue, and the ulValueLen field is
   modified to hold the exact length of the attribute.
5. Otherwise, the ulValueLen field is modified to hold the value
   CK_UNAVAILABLE_INFORMATION.

If case 1 applies to any of the requested attributes, then the call should
return the value **CKR_ATTRIBUTE_SENSITIVE**. If case 2 applies to any of the
requested attributes, then the call should return the value
**CKR_ATTRIBUTE_TYPE_INVALID**. If case 5 applies to any of the requested
attributes, then the call should return the value **CKR_BUFFER_TOO_SMALL**. As
usual, if more than one of these error codes is applicable, Cryptoki may return
any of them. Only if none of them applies to any of the requested attributes
will **CKR_OK** be returned.

In the special case of an attribute whose value is an array of attributes, for
example **CKA_WRAP_TEMPLATE**, where it is passed in with _pValue_ not NULL, the
length specified in ulValueLen MUST be large enough to hold all attributes in
the array. If the pValue of elements within the array is NULL_PTR then the
_ulValueLen_ of elements within the array will be set to the required length. If
the _pValue_ of elements within the array is not NULL_PTR, then the _ulValueLen_
element of attributes within the array MUST reflect the space that the
corresponding _pValue_ points to, and _pValue_ is filled in if there is
sufficient room. Therefore it is important to initialize the contents of a
buffer before calling **C_GetAttributeValue** to get such an array value. Note
that the type element of attributes within the array MUST be ignored on input
and MUST be set on output. If any _ulValueLen_ within the array isn't large
enough, it will be set to CK_UNAVAILABLE_INFORMATION and the function will
return **CKR_BUFFER_TOO_SMALL**, as it does if an attribute in the _pTemplate_
argument has _ulValueLen_ too small.  Note that any attribute whose value is an
array of attributes is identifiable by virtue of the attribute type having the
**CKF_ARRAY_ATTRIBUTE** bit set.

Note that the error codes **CKR_ATTRIBUTE_SENSITIVE**,
**CKR_ATTRIBUTE_TYPE_INVALID**, and **CKR_BUFFER_TOO_SMALL** do not denote true
errors for **C_GetAttributeValue**.  If a call to **C_GetAttributeValue**
returns any of these three values, then the call MUST nonetheless have processed
every attribute in the template supplied to **C_GetAttributeValue**. Each
attribute in the template whose value _can be_ returned by the call to
**C_GetAttributeValue** _will be_ returned by the call to
**C_GetAttributeValue**.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_SENSITIVE,
CKR_ATTRIBUTE_TYPE_INVALID, CKR_BUFFER_TOO_SMALL, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OBJECT_HANDLE_INVALID, CKR_OK,
CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hObject;
CK_BYTE_PTR pModulus, pExponent;
CK_ATTRIBUTE template[] = {
  {CKA_MODULUS, NULL_PTR, 0},
  {CKA_PUBLIC_EXPONENT, NULL_PTR, 0}
};
CK_RV rv;

.
.
rv = C_GetAttributeValue(hSession, hObject, template, 2);
if (rv == CKR_OK) {
  pModulus = (CK_BYTE_PTR) malloc(template[0].ulValueLen);
  template[0].pValue = pModulus;
  /* template[0].ulValueLen was set by C_GetAttributeValue */

  pExponent = (CK_BYTE_PTR) malloc(template[1].ulValueLen);
  template[1].pValue = pExponent;
  /* template[1].ulValueLen was set by C_GetAttributeValue */

  rv = C_GetAttributeValue(hSession, hObject, template, 2);
  if (rv == CKR_OK) {
    .
    .
  }
  free(pModulus);
  free(pExponent);
}
~~~

### C_SetAttributeValue

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_SetAttributeValue)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE hObject,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulCount
);
~~~

**C_SetAttributeValue** modifies the value of one or more attributes of an
object. _hSession_ is the session’s handle; _hObject_ is the object’s handle;
_pTemplate_ points to a template that specifies which attribute values are to be
modified and their new values; _ulCount_ is the number of attributes in the
template.

Certain objects may not be modified. Calling **C_SetAttributeValue** on such
objects will result in the **CKR_ACTION_PROHIBITED** error code. An application
can consult the object's **CKA_MODIFIABLE** attribute to determine if an object
may be modified or not.

Only session objects can be modified during a read-only session.

The template may specify new values for any attributes of the object that can be
modified. If the template specifies a value of an attribute which is
incompatible with other existing attributes of the object, the call fails with
the return code **CKR_TEMPLATE_INCONSISTENT**.

Not all attributes can be modified; see Section 4.1.2 for more details.

Return values: CKR_ACTION_PROHIBITED, CKR_ARGUMENTS_BAD,
CKR_ATTRIBUTE_READ_ONLY, CKR_ATTRIBUTE_TYPE_INVALID,
CKR_ATTRIBUTE_VALUE_INVALID, CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OBJECT_HANDLE_INVALID, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_PENDING, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID,
CKR_SESSION_READ_ONLY, CKR_TEMPLATE_INCONSISTENT, CKR_TOKEN_WRITE_PROTECTED,
CKR_USER_NOT_LOGGED_IN.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hObject;
CK_UTF8CHAR label[] = {“New label”};
CK_ATTRIBUTE template[] = {
  {CKA_LABEL, label, sizeof(label)-1}
};
CK_RV rv;

.
.
rv = C_SetAttributeValue(hSession, hObject, template, 1);
if (rv == CKR_OK) {
  .
  .
}
~~~

### C_FindObjectsInit

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_FindObjectsInit)(
    CK_SESSION_HANDLE hSession,
    CK_ATTRIBUTE_PTR pTemplate,
    CK_ULONG ulCount
);
~~~

**C_FindObjectsInit** initializes a search for token and session objects that
match a template. _hSession_ is the session’s handle; _pTemplate_ points to a
search template that specifies the attribute values to match; _ulCount_ is the
number of attributes in the search template. The matching criterion is an exact
byte-for-byte match with all attributes in the template. To find all objects,
set ulCount to 0.

After calling **C_FindObjectsInit**, the application may call **C_FindObjects**
one or more times to obtain handles for objects matching the template, and then
eventually call **C_FindObjectsFinal** to finish the active search operation. At
most one search operation may be active at a given time in a given session.

The object search operation will only find objects that the session can view.
For example, an object search in an “R/W Public Session” will not find any
private objects (even if one of the attributes in the search template specifies
that the search is for private objects).

If a search operation is active, and objects are created or destroyed which fit
the search template for the active search operation, then those objects may or
may not be found by the search operation. Note that this means that, under these
circumstances, the search operation may return invalid object handles.

Even though **C_FindObjectsInit** can return the values
**CKR_ATTRIBUTE_TYPE_INVALID** and **CKR_ATTRIBUTE_VALUE_INVALID**, it is not
required to. For example, if it is given a search template with nonexistent
attributes in it, it can return **CKR_ATTRIBUTE_TYPE_INVALID**, or it can
initialize a search operation which will match no objects and return CKR_OK.

If the **CKA_UNIQUE_ID** attribute is present in the search template, either
zero or one objects will be found, since at most one object can have any
particular CKA_UNIQUE_ID value.

Return values: CKR_ARGUMENTS_BAD, CKR_ATTRIBUTE_TYPE_INVALID,
CKR_ATTRIBUTE_VALUE_INVALID, CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_PENDING, CKR_PIN_EXPIRED,
CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example: see **C_FindObjectsFinal**.

### C_FindObjects

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_FindObjects)(
    CK_SESSION_HANDLE hSession,
    CK_OBJECT_HANDLE_PTR phObject,
    CK_ULONG ulMaxObjectCount,
    CK_ULONG_PTR pulObjectCount
);
~~~

**C_FindObjects** continues a search for token and session objects that match a
template, obtaining additional object handles. _hSession_ is the session’s
handle; _phObject_ points to the location that receives the list (array) of
additional object handles; _ulMaxObjectCount_ is the maximum number of object
handles to be returned; _pulObjectCount_ points to the location that receives
the actual number of object handles returned.

If there are no more objects matching the template, then the location that
_pulObjectCount_ points to receives the value 0.

The search MUST have been initialized with **C_FindObjectsInit**.

Return values: CKR_ARGUMENTS_BAD, CKR_CRYPTOKI_NOT_INITIALIZED,
CKR_DEVICE_ERROR, CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED,
CKR_GENERAL_ERROR, CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE,
CKR_OPERATION_NOT_INITIALIZED, CKR_PENDING, CKR_SESSION_CLOSED,
CKR_SESSION_HANDLE_INVALID.

Example: see **C_FindObjectsFinal**.

### C_FindObjectsFinal

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_FindObjectsFinal)(
    CK_SESSION_HANDLE hSession
);
~~~

**C_FindObjectsFinal** terminates a search for token and session objects.
_hSession_ is the session’s handle.

Return values: CKR_CRYPTOKI_NOT_INITIALIZED, CKR_DEVICE_ERROR,
CKR_DEVICE_MEMORY, CKR_DEVICE_REMOVED, CKR_FUNCTION_FAILED, CKR_GENERAL_ERROR,
CKR_HOST_MEMORY, CKR_OK, CKR_OPERATION_ACTIVE, CKR_OPERATION_NOT_INITIALIZED,
CKR_PENDING, CKR_SESSION_CLOSED, CKR_SESSION_HANDLE_INVALID.

Example:

~~~{.c}
CK_SESSION_HANDLE hSession;
CK_OBJECT_HANDLE hObject;
CK_ULONG ulObjectCount;
CK_RV rv;

.
.
rv = C_FindObjectsInit(hSession, NULL_PTR, 0);
assert(rv == CKR_OK);
while (1) {
  rv = C_FindObjects(hSession, &hObject, 1, &ulObjectCount);
  if (rv != CKR_OK || ulObjectCount == 0)
    break;
  .
  .
}

rv = C_FindObjectsFinal(hSession);
assert(rv == CKR_OK);
~~~
