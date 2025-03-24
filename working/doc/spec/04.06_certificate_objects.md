## Certificate objects

### Definitions

This section defines the object class **CKO_CERTIFICATE** for type
CK_OBJECT_CLASS as used in the **CKA_CLASS** attribute of objects.

### Overview

Certificate objects (object class **CKO_CERTIFICATE**) hold public-key or
attribute certificates. Other than providing access to certificate objects,
Cryptoki does not attach any special meaning to certificates. The following
table defines the common certificate object attributes, in addition to the
common attributes defined for this object class:

| Attribute	           | Data type	        | Meaning                    |
|----------------------|--------------------|----------------------------|
| CKA_CERTIFICATE_TYPE ^1^ | CK_CERTIFICATE_TYPE | Type of certificate   |
| CKA_TRUSTED10        | CK_BBOOL           | The certificate can be trusted for the application that it was created. |
| CKA_CERTIFICATE_CATEGORY | CKA_CERTIFICATE_CATEGORY | (default CK_CERTIFICATE_CATEGORY_UNSPECIFIED) |
| CKA_CHECK_VALUE      | Byte array         | Checksum                   |
| CKA_START_DATE       | CK_DATE            | Start date for the certificate (default empty) |
| CKA_END_DATE         | CK_DATE            | End date for the certificate (default empty) |
| CKA_PUBLIC_KEY_INFO  | Byte array         | DER-encoding of the SubjectPublicKeyInfo for the public key contained in this certificate (default empty) |
table: Common Certificate Object Attributes

 * Refer to Table 13 for footnotes  


Cryptoki does not enforce the relationship of the **CKA_PUBLIC_KEY_INFO**
to the public key in the certificate, but does recommend that the key be
extracted from the certificate to create this value.

The **CKA_CERTIFICATE_TYPE** attribute may not be modified after an object
is created. This version of Cryptoki supports the following certificate
types:
 * X.509 public key certificate
 * WTLS public key certificate
 * X.509 attribute certificate

The **CKA_TRUSTED** attribute cannot be set to CK_TRUE by an application.
It MUST be set by a token initialization application or by the token’s SO.
Trusted certificates cannot be modified.

The **CKA_CERTIFICATE_CATEGORY** attribute is used to indicate if a stored
certificate is a user certificate for which the corresponding private key is
available on the token (“token user”), a CA certificate (“authority”), or
another end-entity certificate (“other entity”). This attribute may not be
modified after an object is created.

The **CKA_CERTIFICATE_CATEGORY** and **CKA_TRUSTED** attributes will together
be used to map to the categorization of the certificates.

**CKA_CHECK_VALUE**: The value of this attribute is derived from the
certificate by taking the first three bytes of the SHA-1 hash of the
certificate object’s **CKA_VALUE** attribute.

The **CKA_START_DATE** and **CKA_END_DATE** attributes are for reference
only; Cryptoki does not attach any special meaning to them. When present,
the application is responsible to set them to values that match the
certificate’s encoded “not before” and “not after” fields (if any).

### X.509 public key certificate objects

X.509 certificate objects (certificate type **CKC_X_509**) hold X.509 public
key certificates. The following table defines the X.509 certificate object
attributes, in addition to the common attributes defined for this object
class:

| Attribute	            | Data type	     | Meaning                        |
|-----------------------|----------------|--------------------------------|
| CKA_SUBJECT ^1^       | Byte array     | DER-encoding of the certificate subject name |
| CKA_ID                | Byte array     | Key identifier for public/private key pair (default empty) |
| CKA_ISSUER            | Byte array     | DER-encoding of the certificate issuer name (default empty) |
| CKA_SERIAL_NUMBER     | Byte array     | DER-encoding of the certificate serial number (default empty) |
| CKA_VALUE ^2^         | Byte array     | BER-encoding of the certificate |
| CKA_URL ^3^           | RFC2279 string | If not empty this attribute gives the URL where the complete certificate can be obtained (default empty) |
| CKA_HASH_OF_SUBJECT_PUBLIC_KEY ^4^ | Byte array | Hash of the subject public key (default empty). Hash algorithm is defined by CKA_NAME_HASH_ALGORITHM |
| CKA_HASH_OF_ISSUER_PUBLIC_KEY ^4^ | Byte array | Hash of the issuer public key (default empty). Hash algorithm is defined by CKA_NAME_HASH_ALGORITHM |
| CKA_JAVA_MIDP_SECURITY_DOMAIN | CK_JAVA_MIDP_SECURITY_DOMAIN | Java MIDP security domain. (default CK_SECURITY_DOMAIN_UNSPECIFIED) |
| CKA_NAME_HASH_ALGORITHM | CK_MECHANISM_TYPE | Defines the mechanism used to calculate CKA_HASH_OF_SUBJECT_PUBLIC_KEY and CKA_HASH_OF_ISSUER_PUBLIC_KEY. If the attribute is not present then the type defaults to SHA-1. |
table: X.509 Certificate Object Attributes

^1^MUST be specified when the object is created.  
^2^MUST be specified when the object is created. MUST be non-empty if **CKA_URL** is empty.  
^3^MUST be non-empty if **CKA_VALUE** is empty.  
^4^Can only be empty if **CKA_URL** is empty.  

Only the **CKA_ID**, **CKA_ISSUER**, and **CKA_SERIAL_NUMBER** attributes
may be modified after the object is created.

The **CKA_ID** attribute is intended as a means of distinguishing multiple
public-key/private-key pairs held by the same subject (whether stored in the
same token or not). (Since the keys are distinguished by subject name as
well as identifier, it is possible that keys for different subjects may have
the same **CKA_ID** value without introducing any ambiguity.)

It is intended in the interests of interoperability that the subject name
and key identifier for a certificate will be the same as those for the
corresponding public and private keys (though it is not required that all
be stored in the same token). However, Cryptoki does not enforce this
association, or even the uniqueness of the key identifier for a given
subject; in particular, an application may leave the key identifier empty.

The **CKA_ISSUER** and **CKA_SERIAL_NUMBER** attributes are for
compatibility with [PKCS #7] and Privacy Enhanced Mail [RFC 1421]. Note that
with the version 3 extensions to X.509 certificates, the key identifier may
be carried in the certificate. It is intended that the **CKA_ID** value be
identical to the key identifier in such a certificate extension, although
this will not be enforced by Cryptoki.

The **CKA_URL** attribute enables the support for storage of the URL where
the certificate can be found instead of the certificate itself. Storage of a
URL instead of the complete certificate is often used in mobile environments.

The **CKA_HASH_OF_SUBJECT_PUBLIC_KEY** and **CKA_HASH_OF_ISSUER_PUBLIC_KEY**
attributes are used to store the hashes of the public keys of the subject
and the issuer. They are particularly important when only the URL is
available to be able to correlate a certificate with a private key and when
searching for the certificate of the issuer. The hash algorithm is defined
by **CKA_NAME_HASH_ALGORITHM**.

The **CKA_JAVA_MIDP_SECURITY_DOMAIN** attribute associates a certificate
with a Java MIDP security domain.

The following is a sample template for creating an X.509 certificate object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_CERTIFICATE;
CK_CERTIFICATE_TYPE certType = CKC_X_509;
CK_UTF8CHAR label[] = “A certificate object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE certificate[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_CERTIFICATE_TYPE, &certType, sizeof(certType)};
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_VALUE, certificate, sizeof(certificate)}
};
~~~

### WTLS public key certificate objects

WTLS certificate objects (certificate type **CKC_WTLS**) hold WTLS public key
certificates. The following table defines the WTLS certificate object
attributes, in addition to the common attributes defined for this object
class.

| Attribute	            | Data type	     | Meaning                        |
|-----------------------|----------------|--------------------------------|
| CKA_SUBJECT ^1^       | Byte array     | WTLS-encoding (Identifier type) of the certificate subject |
| CKA_ISSUER            | Byte array     | WTLS-encoding (Identifier type) of the certificate issuer (default empty) |
| CKA_VALUE ^2^         | Byte array     | WTLS-encoding of the certificate |
| CKA_URL ^3^           | RFC2279 string | If not empty this attribute gives the URL where the complete certificate can be obtained |
| CKA_HASH_OF_SUBJECT_PUBLIC_KEY ^4^ | Byte array | SHA-1 hash of the subject public key (default empty). Hash algorithm is defined by CKA_NAME_HASH_ALGORITHM |
| CKA_HASH_OF_ISSUER_PUBLIC_KEY ^4^ | Byte array | SHA-1 hash of the issuer public key (default empty). Hash algorithm is defined by CKA_NAME_HASH_ALGORITHM |
| CKA_NAME_HASH_ALGORITHM | CK_MECHANISM_TYPE | Defines the mechanism used to calculate CKA_HASH_OF_SUBJECT_PUBLIC_KEY and CKA_HASH_OF_ISSUER_PUBLIC_KEY. If the attribute is not present then the type defaults to SHA-1. |
table: WTLS Certificate Object Attributes

^1^MUST be specified when the object is created. Can only be empty if **CKA_VALUE** is empty.  
^2^MUST be specified when the object is created. MUST be non-empty if **CKA_URL** is empty.  
^3^MUST be non-empty if **CKA_VALUE** is empty.  
^4^Can only be empty if **CKA_URL** is empty.  

Only the **CKA_ISSUER** attribute may be modified after the object has
been created.

The encoding for the **CKA_SUBJECT**, **CKA_ISSUER**, and **CKA_VALUE**
attributes can be found in [WTLS].

The **CKA_URL** attribute enables the support for storage of the URL where
the certificate can be found instead of the certificate itself. Storage of
a URL instead of the complete certificate is often used in mobile
environments.

The **CKA_HASH_OF_SUBJECT_PUBLIC_KEY** and **CKA_HASH_OF_ISSUER_PUBLIC_KEY**
attributes are used to store the hashes of the public keys of the subject
and the issuer. They are particularly important when only the URL is
available to be able to correlate a certificate with a private key and when
searching for the certificate of the issuer. The hash algorithm is defined
by **CKA_NAME_HASH_ALGORITHM**.

The following is a sample template for creating a WTLS certificate object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_CERTIFICATE;
CK_CERTIFICATE_TYPE certType = CKC_WTLS;
CK_UTF8CHAR label[] = “A certificate object”;
CK_BYTE subject[] = {...};
CK_BYTE certificate[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] =
{
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_CERTIFICATE_TYPE, &certType, sizeof(certType)};
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_VALUE, certificate, sizeof(certificate)}
};
~~~

### X.509 attribute certificate objects

X.509 attribute certificate objects (certificate type **CKC_X_509_ATTR_CERT**)
hold X.509 attribute certificates. The following table defines the X.509
attribute certificate object attributes, in addition to the common attributes
defined for this object class: 

| Attribute	            | Data type	     | Meaning                        |
|-----------------------|----------------|--------------------------------|
| CKA_OWNER ^1^         | Byte array     | DER-encoding of the attribute certificate's subject field. This is distinct from the CKA_SUBJECT attribute contained in CKC_X_509 certificates because the ASN.1 syntax and encoding are different. |
| CKA_AC_ISSUER         | Byte array     | DER-encoding of the attribute certificate's issuer field. This is distinct from the CKA_ISSUER attribute contained in CKC_X_509 certificates because the ASN.1 syntax and encoding are different. (default empty) |
| CKA_SERIAL_NUMBER     | Byte array     | DER-encoding of the certificate serial number. (default empty) |
| CKA_ATTR_TYPES        | Byte array     | BER-encoding of a sequence of object identifier values corresponding to the attribute types contained in the certificate. When present, this field offers an opportunity for applications to search for a particular attribute certificate without fetching and parsing the certificate itself. (default empty) |
| CKA_VALUE ^1^         | Byte array     | BER-encoding of the certificate. |
table: X.509 Attribute Certificate Object Attributes

^1^MUST be specified when the object is created  

Only the **CKA_AC_ISSUER**, **CKA_SERIAL_NUMBER** and **CKA_ATTR_TYPES**
attributes may be modified after the object is created.

The following is a sample template for creating an X.509 attribute
certificate object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_CERTIFICATE;
CK_CERTIFICATE_TYPE certType = CKC_X_509_ATTR_CERT;
CK_UTF8CHAR label[] = "An attribute certificate object";
CK_BYTE owner[] = {...};
CK_BYTE certificate[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_CERTIFICATE_TYPE, &certType, sizeof(certType)};
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_OWNER, owner, sizeof(owner)},
  {CKA_VALUE, certificate, sizeof(certificate)}
};
~~~
