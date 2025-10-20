## Generic secret key

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_GENERIC_SECRET_KEY_GEN           |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Generic Secret Key Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_GENERIC_SECRET**” for type CK_KEY_TYPE
as used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_GENERIC_SECRET_KEY_GEN

### Generic secret key objects

Generic secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_GENERIC_SECRET**) hold generic secret keys. These keys do not support
encryption or decryption; however, other keys can be derived from them and they
can be used in HMAC operations. The following table defines the generic secret
key object attributes, in addition to the common attributes defined for this
object class:

These key types are used in several of the mechanisms described in this section.

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (arbitrary length)        |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value        |
table: Generic Secret Key Object Attributes

- Refer to Table 13 for footnotes

The following is a sample template for creating a generic secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_GENERIC_SECRET;
CK_UTF8CHAR label[] = “A generic secret key object”;
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_DERIVE, &true, sizeof(true)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

**CKA_CHECK_VALUE**: The value of this attribute is derived from the key object by
taking the first three bytes of the SHA-1 hash of the generic secret key
object’s **CKA_VALUE** attribute.

### Generic secret key generation

The generic secret key generation mechanism, denoted
**CKM_GENERIC_SECRET_KEY_GEN**, is used to generate generic secret keys. The
generated keys take on any attributes provided in the template passed to the
**C_GenerateKey** call, and the **CKA_VALUE_LEN** attribute specifies the length
of the key to be generated. 

It does not have a parameter.

The template supplied must specify a value for the **CKA_VALUE_LEN** attribute.
If the template specifies an object type and a class, they must have the
following values:

	CK_OBJECT_CLASS = CKO_SECRET_KEY;
	CK_KEY_TYPE = CKK_GENERIC_SECRET;

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of key sizes, in
bits.
