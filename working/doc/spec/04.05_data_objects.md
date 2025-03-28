## Data objects

### Definitions

This section defines the object class **CKO_DATA** for type CK_OBJECT_CLASS
as used in the **CKA_CLASS** attribute of objects.

### Overview

Data objects (object class **CKO_DATA**) hold information defined by an
application. Other than providing access to it, Cryptoki does not attach any
special meaning to a data object. The following table lists the attributes
supported by data objects, in addition to the common attributes defined for
this object class:

| Attribute       | Data type      | Meaning                             |
|-----------------|----------------|-------------------------------------|
| CKA_APPLICATION | RFC2279 string | Description of the application that manages the object (default empty) |
| CKA_OBJECT_ID   | Byte array     | DER-encoding of the object identifier indicating the data object type (default empty) |
| CKA_VALUE       | Byte array     | Value of the object (default empty) |
table: Data Object Attributes

The **CKA_APPLICATION** attribute provides a means for applications to
indicate ownership of the data objects they manage. Cryptoki does not provide
a means of ensuring that only a particular application has access to a data
object, however.

The **CKA_OBJECT_ID** attribute provides an application independent and
expandable way to indicate the type of the data object value. Cryptoki does
not provide a means of insuring that the data object identifier matches the
data value.

The following is a sample template containing attributes for creating a data object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_DATA;
CK_UTF8CHAR label[] = “A data object”;
CK_UTF8CHAR application[] = “An application”;
CK_BYTE data[] = “Sample data”;
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_APPLICATION, application, sizeof(application)-1},
  {CKA_VALUE, data, sizeof(data)}
};
~~~
