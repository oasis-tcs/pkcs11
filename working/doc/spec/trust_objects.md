## Trust objects

### Definitions

This section defines the object class CKO_TRUST for type CK_OBJECT_CLASS as
used in the CKA_CLASS attribute of objects.

CK_TRUST is defined as:

~~~{.c}
typedef CK_ULONG CK_TRUST;
~~~

and can have the following values: CKT_TRUSTED, CKT_TRUST_ANCHOR,
CKT_NOT_TRUSTED, CKT_TRUST_MUST_VERIFY_TRUST, or CKT_TRUST_UNKNOWN.

### Overview

Trust objects (object class **CKO_TRUST**) bind trusted usages to individual
certificates. Trust objects for a given certificate are accessed using the
**CKA_ISSUER** and **CKA_SERIAL_NUMBER** attributes, and may be confirmed by
comparing **CKA_HASH_OF_CERTIFICATE** with a recomputed hash value. The
corresponding certificate does not necessarily have to exist in the same
token as its trust object. Multiple trust objects for the same certificate
can exist in different tokens, but each token should have no more than one
trust object for a given certificate.

| Attribute	                  | Data Type  | Meaning                      |
|-----------------------------|------------|------------------------------|
| CKA_ISSUER ^1^              | Byte array | DER-encoding of the certificate issuer name (default empty) |
| CKA_SERIAL_NUMBER ^1^       | Byte array | DER-encoding of the certificate serial number (default empty) |
| CKA_HASH_OF_CERTIFICATE ^2^ | Byte array | cryptographic hash of the certificate computed by CKA_NAME_HASH_ALGORITHM (default empty) |
| CKA_NAME_HASH_ALGORITHM ^2^ | CK_MECHANISM_TYPE |mechanism used to calculate CKA_HASH_OF_CERTIFICATE (defaults to SHA-1 if not present) |
| CKA_TRUST_SERVER_AUTH ^3^	  | CK_TRUST   | trust for authenticating the server in a client/server interaction (as in TLS/SSL/SSH) |
| CKA_TRUST_CLIENT_AUTH ^3^	  | CK_TRUST   | trust for authenticating the client in a client/server interaction (as in TLS/SSL/SSH) |
| CKA_TRUST_CODE_SIGNING ^3^  | CK_TRUST   |trust for authenticating a code fragment |
| CKA_TRUST_EMAIL_PROTECTION ^3^ | CK_TRUST | trust for authenticating an email user |
| CKA_TRUST_IPSEC_IKE ^3^     | CK_TRUST   | trust for IPSEC |
| CKA_TRUST_TIME_STAMPING ^3^ | CK_TRUST   | trust for Timestamping |
| CKA_TRUST_OCSP_SIGNING ^3^  | CK_TRUST   | trust for OCSP Signing |
table: Trust Object Attributes

^1^ MUST be specified when the object is created.  
^2^ MUST be specified when the object is created unless all trust attributes
    are CKT_TRUST_UNKNOWN, or CKT_NOT_TRUSTED.  
^3^ Missing CKA_TRUST_XXX attributes are treated as CKT_TRUST_UNKNOWN.  

**CKA_TRUST_XXX** attributes map roughly to Certificate EKU values, and carry
the same semantics. If **CKA_MODIFIABLE** is not set in the template, it
defaults to CK_TRUE; if **CKA_PRIVATE** is not set in the template, it
defaults to CK_FALSE.

To obtain the effective trust attributes for a given certificate, the typical
application will first:

 1. identify the tokens containing a Trust object with matching **CKA_ISSUER**
    and **CKA_SERIAL_NUMBER** (and optionally check that
    **CKA_HASH_OF_CERTIFICATE** agrees with the hash of the certificate
    computed using **CKA_NAME_HASH_ALGORITHM**),
 2. determine which of those Trust objects should be processed (presumably
    according to an established security policy), and
 3. arrange the selected Trust objects in a list sorted in order of increasing
    priority.

Now, taking the first Trust object in the list as the initial working Trust
object (WTO) with all omitted attributes assumed to have the value
**CKT_TRUST_UNKNOWN**, the remaining Trust objects in the list are iteratively
merged into it as follows:
 * if the value of a trust attribute in the current object is
   **CKT_TRUST_UNKNOWN**, that attribute is left unchanged in the WTO,
 * otherwise, the current attribute value replaces the attribute value in
   the WTO.

Note that at any step of this process, an attribute value of
**CKT_TRUST_MUST_VERIFY_TRUST** in the current Trust object resets any trust
or distrust assigned to that attribute in the WTO by a lower priority token.

When the process is complete, the final (“effective”) trust attribute values
are to be interpreted as follows:

CKT_TRUSTED
: the certificate is trusted for the associated operation

CKT_TRUST_ANCHOR
: the certificate is trusted as a root signing certificate for chain
  validation of a cert that is trusted for the associate operation; this
  applies even when the certificate is not self-signed and when the
  certificate does not have the proper attributes to be CA certificate

CKT_NOT_TRUSTED
: the certificate is explicitly not trusted for the associated operation,
  nor can trust chain through the certificate to an otherwise trusted root;
  this attribute can be used to ‘revoke’ intermediate CA certificates that
  have been compromised without removing trust from the parent certificate

CKT_TRUST_MUST_VERIFY_TRUST

CKT_TRUST_UNKNOWN
: the certificate is neither trusted nor untrusted for the associated
  operation

Note that when processing a certificate chain, applications may use the
various Trust objects to override trust attributes that would otherwise be
associated with each certificate solely based on EKUs and other extensions
encountered along the chain.

The following is a sample template for creating an X.509 certificate object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_CERTIFICATE;
CK_UTF8CHAR label[] = “A certificate object”;
CK_BYTE issuer[] = {...}; // matches certificate’s issuer 
CK_BYTE serialNumber[] = {...}; // matches certificate’s serialNumber
CK_BYTE certificate[] = {...};
CK_BBOOL true = CK_TRUE;
CK_TRUST trustAnchor = CKT_TRUST_ANCHOR;
CK_TRUST notTrusted = CKT_NOT_TRUSTED;
CK_MECHANISM_TYPE hashMec = CKM_SHA256;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_ISSUER, issuer, sizeof(issuer)},
  {CKA_SERIAL_NUBMER, serialNumber, sizeof(serialNumber)},
  {CKA_HASH_OF_CERTIIFICATE, hash(hashMec,certificate, sizeof(certificate),hashLen(hashMec)},
  {CKA_NAME_HASH_ALGORITHM, &hashMech, sizeof(hashMech)},
  {CKA_TRUST_SERVER_AUTH, &trustAnchor, sizeof(trustAnchor) },
  {CKA_TRUST_CODE_SIGNING, &notTrusted, sizeof(notTrusted) }
   // other attributes are CKT_TRUST_UNKNOWN if not included here.
};
~~~
