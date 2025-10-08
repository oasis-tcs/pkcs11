## Elliptic Curve

The Elliptic Curve (EC) cryptosystem in this document was originally based on
the one described in the [ANSI X9.62] and [ANSI X9.63] standards developed by
the ANSI X9F1 working group.

The EC cryptosystem developed by the ANSI X9F1 working group was created at a
time when EC curves were always represented in their Weierstrass form. Since
that time, new curves represented in Edwards form ([RFC 8032]) and Montgomery
form ([RFC 7748]) have become more common. To support these new curves, the EC
cryptosystem in this document has been extended from the original. Additional
key generation mechanisms have been added as well as an additional signature
generation mechanism.

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_EC_KEY_PAIR_GEN                  |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_EC_KEY_PAIR_GEN_W_EXTRA_BITS     |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_EC_EDWARDS_KEY_PAIR_GEN          |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_EC_MONTGOMERY_KEY_PAIR_GEN       |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA                            |     | ✓^1^|      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA1                       |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA224                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA256                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA384                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA512                     |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA3_224                   |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA3_256                   |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA3_384                   |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDSA_SHA3_512                   |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_EDDSA                            |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_XEDDSA                           |     |  ✓  |      |     |       |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDH1_DERIVE                     |     |     |      |     |       |     |  ✓  |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDH1_COFACTOR_DERIVE            |     |     |      |     |       |     |  ✓  |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECMQV_DERIVE                     |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDH_AES_KEY_WRAP                |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDH_COF_AES_KEY_WRAP            |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_ECDH_X_AES_KEY_WRAP              |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Elliptic Curve Mechanisms vs. Functions

^1^ Single-part operations only

| Bit Flag            | Mask         | Meaning                                 |
|---------------------|--------------|-----------------------------------------|
| CKF_EC_F_P          | 0x00100000UL | True if the mechanism can be used with EC domain parameters over Fp |
| CKF_EC_F_2M         | 0x00200000UL | True if the mechanism can be used with EC domain parameters over F2m |
| CKF_EC_ECPARAMETERS | 0x00400000UL | True if the mechanism can be used with EC domain parameters of the choice ecParameters |
| CKF_EC_OID          | 0x00800000UL | True if the mechanism can be used with EC domain parameters of the choice oId |
| CKF_EC_UNCOMPRESS   | 0x01000000UL | True if the mechanism can be used with Elliptic Curve point uncompressed |
| CKF_EC_COMPRESS     | 0x02000000UL | True if the mechanism can be used with Elliptic Curve point compressed |
| CKF_EC_CURVENAME    | 0x04000000UL | True if the mechanism can be used with EC domain parameters of the choice curveName |
table: Mechanism Information Flags

Note: **CKF_EC_NAMEDCURVE** is deprecated with PKCS #11 3.00. It is replaced by
**CKF_EC_OID**.

In these standards, there are two different varieties of EC defined:

1. EC using a field with an odd prime number of elements (i.e. the finite field
   Fp).
2. EC using a field of characteristic two (i.e. the finite field F2m).

An EC key in Cryptoki contains information about which variety of EC it is
suited for. It is preferable that a Cryptoki library, which can perform EC
mechanisms, be capable of performing operations with the two varieties of EC,
however this is not required. The **CK_MECHANISM_INFO** structure **CKF_EC_F_P**
flag identifies a Cryptoki library supporting EC keys over Fp whereas the
**CKF_EC_F_2M** flag identifies a Cryptoki library supporting EC keys over F2m.
A Cryptoki library that can perform EC mechanisms must set either or both of
these flags for each EC mechanism.

In these specifications there are also four representation methods to define the
domain parameters for an EC key. Only the ecParameters, the **oId** and the
**curveName** choices are supported in Cryptoki. The CK_MECHANISM_INFO structure
**CKF_EC_ECPARAMETERS** flag identifies a Cryptoki library supporting the
**ecParameters** choice whereas the **CKF_EC_OID** flag identifies a Cryptoki
library supporting the **oId** choice, and the **CKF_EC_CURVENAME** flag
identifies a Cryptoki library supporting the **curveName** choice. A Cryptoki
library that can perform EC mechanisms must set the appropriate flag(s) for each
EC mechanism.

In these specifications, an EC public key (i.e. EC point Q) or the base point G
when the **ecParameters** choice is used can be represented as an octet string
of the uncompressed form or the compressed form. The CK_MECHANISM_INFO structure
**CKF_EC_UNCOMPRESS** flag identifies a Cryptoki library supporting the
uncompressed form whereas the **CKF_EC_COMPRESS** flag identifies a Cryptoki
library supporting the compressed form. A Cryptoki library that can perform EC
mechanisms must set either or both of these flags for each EC mechanism.

Note that an implementation of a Cryptoki library supporting EC with only one
variety, one representation of domain parameters or one form may encounter
difficulties achieving interoperability with other implementations.

If an attempt to create, generate, derive or unwrap an EC key of an unsupported
curve is made, the attempt should fail with the error code
**CKR_CURVE_NOT_SUPPORTED**. If an attempt to create, generate, derive, or
unwrap an EC key with invalid or of an unsupported representation of domain
parameters is made, that attempt should fail with the error code
**CKR_DOMAIN_PARAMS_INVALID**. If an attempt to create, generate, derive, or
unwrap an EC key of an unsupported form is made, that attempt should fail with
the error code **CKR_TEMPLATE_INCONSISTENT**.

### EC Signatures

For the purposes of these mechanisms, an ECDSA signature is an octet string of
even length which is at most two times _nLen_ octets, where nLen is the length
in octets of the base point order _n_. The signature octets correspond to the
concatenation of the ECDSA values _r_ and _s_, both represented as an octet
string of equal length of at most _nLen_ with the most significant byte first.
If _r_ and _s_ have different octet length, the shorter of both must be padded
with leading zero octets such that both have the same octet length. Loosely
spoken, the first half of the signature is _r_ and the second half is _s_. For
signatures created by a token, the resulting signature is always of length
_2nLen_. For signatures passed to a token for verification, the signature may
have a shorter length but must be composed as specified before. 

If the length of the hash value is larger than the bit length of _n_, only the
leftmost bits of the hash up to the length of _n_ will be used. Any truncation
is done by the token.

Note: For applications, it is recommended to encode the signature as an octet
string of length two times _nLen_ if possible. This ensures that the application
works with PKCS #11 modules which have been implemented based on an older
version of this document. Older versions required all signatures to have length
two times _nLen_. It may be impossible to encode the signature with the maximum
length of two times _nLen_ if the application just gets the integer values of
_r_ and _s_ (i.e. without leading zeros), but does not know the base point order
_n_, because _r_ and _s_ can have any value between zero and the base point
order _n_. 

An EdDSA signature is an octet string of even length which is two times _nLen_
octets, where nLen is calculated as EdDSA parameter b divided by 8. The
signature octets correspond to the concatenation of the EdDSA values R and S as
defined in [RFC 8032], both represented as an octet string of equal length of
nLen bytes in little endian order.

### Definitions

This section defines the key types “**CKK_EC**”, “**CKK_EC_EDWARDS**” and
“**CKK_EC_MONTGOMERY*” for type CK_KEY_TYPE as used in the **CKA_KEY_TYPE**
attribute of key objects.

Note: CKK_ECDSA is deprecated. It is replaced by CKK_EC.

Mechanisms:

- CKM_EC_KEY_PAIR_GEN
- CKM_EC_EDWARDS_KEY_PAIR_GEN
- CKM_EC_MONTGOMERY_KEY_PAIR_GEN
- CKM_ECDSA
- CKM_ECDSA_SHA1
- CKM_ECDSA_SHA224
- CKM_ECDSA_SHA256
- CKM_ECDSA_SHA384
- CKM_ECDSA_SHA512
- CKM_ECDSA_SHA3_224
- CKM_ECDSA_SHA3_256
- CKM_ECDSA_SHA3_384
- CKM_ECDSA_SHA3_512
- CKM_EDDSA
- CKM_XEDDSA
- CKM_ECDH1_DERIVE
- CKM_ECDH1_COFACTOR_DERIVE
- CKM_ECMQV_DERIVE
- CKM_ECDH_AES_KEY_WRAP
- CKM_ECDH_COF_AES_KEY_WRAP
- CKM_ECDH_X_AES_KEY_WRAP
 
- CKD_NULL
- CKD_SHA1_KDF
- CKD_SHA224_KDF
- CKD_SHA256_KDF
- CKD_SHA384_KDF
- CKD_SHA512_KDF
- CKD_SHA3_224_KDF
- CKD_SHA3_256_KDF
- CKD_SHA3_384_KDF
- CKD_SHA3_512_KDF
- CKD_SHA1_KDF_SP800
- CKD_SHA224_KDF_SP800
- CKD_SHA256_KDF_SP800
- CKD_SHA384_KDF_SP800
- CKD_SHA512_KDF_SP800
- CKD_SHA3_224_KDF_SP800
- CKD_SHA3_256_KDF_SP800
- CKD_SHA3_384_KDF_SP800
- CKD_SHA3_512_KDF_SP800
- CKD_BLAKE2B_160_KDF
- CKD_BLAKE2B_256_KDF
- CKD_BLAKE2B_384_KDF
- CKD_BLAKE2B_512_KDF

### Short Weierstrass Elliptic Curve public key objects

Short Weierstrass EC public key objects (object class **CKO_PUBLIC_KEY**, key
type **CKK_EC**) hold EC public keys. The following table defines the EC public
key object attributes, in addition to the common attributes defined for this
object class:

| Attribute           | Data type  | Meaning                              |
|---------------------|------------|--------------------------------------|
| CKA_EC_PARAMS ^1,3^ | Byte array | DER-encoding of an ANSI X9.62 Parameters value |
| CKA_EC_POINT ^1,4^  | Byte array | DER-encoding of ANSI X9.62 ECPoint value Q |
table: Elliptic Curve Public Key Object Attributes

- Refer to Table 13 for footnotes

Note: **CKA_ECDSA_PARAMS** is deprecated. It is replaced by **CKA_EC_PARAMS**.

The **CKA_EC_PARAMS** attribute value is known as the “EC domain parameters” and
is defined in [ANSI X9.62] as a choice of three parameter representation methods
with the following syntax:

~~~{.c}
Parameters ::= CHOICE {
  ecParameters	ECParameters,
  oId	CURVES.&id({CurveNames}),
  implicitlyCA	NULL,
  curveName	PrintableString
}
~~~

This allows detailed specification of all required values using choice
**ecParameters**, the use of **oId** as an object identifier substitute for a
particular set of Elliptic Curve domain parameters, or **implicitlyCA** to
indicate that the domain parameters are explicitly defined elsewhere, or
**curveName** to specify a curve name as e.g. define in [ANSI X9.62],
[BRAINPOOL], [SEC 2], [LEGIFRANCE]. The use of **oId** or **curveName** is
recommended over the choice **ecParameters**. The choice **implicitlyCA** must
not be used in Cryptoki.

The following is a sample template for creating an short Weierstrass EC public
key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_EC;
CK_UTF8CHAR label[] = “An EC public key object”;
CK_BYTE ecParams[] = {...};
CK_BYTE ecPoint[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_EC_PARAMS, ecParams, sizeof(ecParams)},
  {CKA_EC_POINT, ecPoint, sizeof(ecPoint)}
};
~~~

### Short Weierstrass Elliptic Curve private key objects

Short Weierstrass EC private key objects (object class **CKO_PRIVATE_KEY**, key
type **CKK_EC**) hold EC private keys. See Section [6.3] for more information
about EC. The following table defines the EC private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute             | Data type   | Meaning                          |
|-----------------------|-------------|----------------------------------|
| CKA_EC_PARAMS ^1,4,6^ | Byte array  | DER-encoding of an ANSI X9.62 Parameters value |
| CKA_VALUE ^1,4,6,7^   | Big integer | ANSI X9.62 private value d |
table: Elliptic Curve Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_EC_PARAMS** attribute value is known as the “EC domain parameters” and
is defined in [ANSI X9.62] as a choice of three parameter representation methods
with the following syntax:

~~~{.c}
Parameters ::= CHOICE {
  ecParameters	ECParameters,
  oId		CURVES.&id({CurveNames}),
  implicitlyCA	NULL,
  curveName	PrintableString
}
~~~

This allows detailed specification of all required values using choice
**ecParameters**, the use of **oId** as an object identifier substitute for a
particular set of Elliptic Curve domain parameters, or **implicitlyCA** to
indicate that the domain parameters are explicitly defined elsewhere, or
**curveName** to specify a curve name as e.g. define in [ANSI X9.62],
[BRAINPOOL], [SEC 2], [LEGIFRANCE].  The use of **oId** or **curveName** is
recommended over the choice **ecParameters**. The choice **implicitlyCA** must
not be used in Cryptoki.Note that when generating an EC private key, the EC
domain parameters are not specified in the key’s template.  This is because EC
private keys are only generated as part of an EC key pair, and the EC domain
parameters for the pair are specified in the template for the EC public key.

The following is a sample template for creating an short Weierstrass EC private
key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_EC;
CK_UTF8CHAR label[] = “An EC private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE ecParams[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_SENSITIVE, &true, sizeof(true)},
  {CKA_DERIVE, &true, sizeof(true)},
  {CKA_EC_PARAMS, ecParams, sizeof(ecParams)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Edwards Elliptic Curve public key objects

Edwards EC public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_EC_EDWARDS**) hold Edwards EC public keys. The following table defines the
Edwards EC public key object attributes, in addition to the common attributes
defined for this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_EC_PARAMS ^1,3^ | Byte array | DER-encoding of a Parameters value as defined above |
| CKA_EC_POINT ^1,4^  | Byte array | Public key bytes in little endian order as defined in [RFC 8032] |
table: Edwards Elliptic Curve Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_EC_PARAMS** attribute value is known as the “EC domain parameters” and
is defined in [ANSI X9.62] as a choice of three parameter representation
methods. A 4th choice is added to support Edwards and Montgomery Elliptic
Curves. The **CKA_EC_PARAMS** attribute has the following syntax:

~~~{.c}
Parameters ::= CHOICE {
  ecParameters	ECParameters,
  oId	CURVES.&id({CurveNames}),
  implicitlyCA	NULL,
  curveName	PrintableString
}
~~~

Edwards EC public keys only support the use of the **curveName** selection to
specify a curve name as defined in [RFC 8032] and the use of the **oID**
selection to specify a curve through an EdDSA algorithm as defined in [RFC
8410]. Note that keys defined by [RFC 8032] and [RFC 8410] are incompatible.

The following is a sample template for creating an Edwards EC public key object
with Edwards25519 being specified as curveName:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_EC_EDWARDS;
CK_UTF8CHAR label[] = “An Edwards EC public key object”;
CK_BYTE ecParams[] = {0x13, 0x0c, 0x65, 0x64, 0x77, 0x61, 0x72, 0x64, 0x73, 0x32, 0x35, 0x35, 0x31, 0x39};
CK_BYTE ecPoint[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_EC_PARAMS, ecParams, sizeof(ecParams)},
  {CKA_EC_POINT, ecPoint, sizeof(ecPoint)}
};
~~~

### Edwards Elliptic Curve private key objects

Edwards EC private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_EC_EDWARDS**) hold Edwards EC private keys. See Section [6.3] for more
information about EC. The following table defines the Edwards EC private key
object attributes, in addition to the common attributes defined for this object
class:

| Attribute             | Data type   | Meaning                          |
|-----------------------|-------------|----------------------------------|
| CKA_EC_PARAMS ^1,4,6^ | Byte array  | DER-encoding of a Parameters value as defined above |
| CKA_VALUE ^1,4,6,7^   | Big integer | Private key bytes in little endian order as defined in [RFC 8032] |
table: Edwards Elliptic Curve Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_EC_PARAMS** attribute value is known as the “EC domain parameters” and
is defined in [ANSI X9.62] as a choice of three parameter representation
methods. A 4th choice is added to support Edwards and Montgomery Elliptic
Curves. The **CKA_EC_PARAMS** attribute has the following syntax:

~~~{.c}
Parameters ::= CHOICE {
  ecParameters	ECParameters,
  oId	CURVES.&id({CurveNames}),
  implicitlyCA	NULL,
  curveName	PrintableString
}
~~~

Edwards EC private keys only support the use of the *curveName* selection to
specify a curve name as defined in [RFC 8032] and the use of the *oId* selection
to specify a curve through an EdDSA algorithm as defined in [RFC 8410]. Note
that keys defined by [RFC 8032] and [RFC 8410] are incompatible.

Note that when generating an Edwards EC private key, the EC domain parameters
are not specified in the key’s template. This is because Edwards EC private keys
are only generated as part of an Edwards EC key pair, and the EC domain
parameters for the pair are specified in the template for the Edwards EC public
key.

The following is a sample template for creating an Edwards EC private key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_EC_EDWARDS;
CK_UTF8CHAR label[] = “An Edwards EC private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE ecParams[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_SENSITIVE, &true, sizeof(true)},
  {CKA_DERIVE, &true, sizeof(true)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Montgomery Elliptic Curve public key objects

Montgomery EC public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_EC_MONTGOMERY**) hold Montgomery EC public keys. The following table
defines the Montgomery EC public key object attributes, in addition to the
common attributes defined for this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_EC_PARAMS ^1,3^ | Byte array | DER-encoding of a Parameters value as defined above |
| CKA_EC_POINT ^1,4^  | Byte array | Public key bytes in little endian order as defined in [RFC 7748] |
table: Montgomery Elliptic Curve Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_EC_PARAMS** attribute value is known as the “EC domain parameters” and
is defined in ANSI [X9.62] as a choice of three parameter representation
methods. A 4th choice is added to support Edwards and Montgomery Elliptic
Curves. The **CKA_EC_PARAMS** attribute has the following syntax:

~~~{.c}
Parameters ::= CHOICE {
  ecParameters	ECParameters,
  oId	CURVES.&id({CurveNames}),
  implicitlyCA	NULL,
  curveName	PrintableString
}
~~~

Montgomery EC public keys only support the use of the **curveName** selection to
specify a curve name as defined in [RFC 7748] and the use of the **oId**
selection to specify a curve through an ECDH algorithm as defined in [RFC 8410].
Note that keys defined by [RFC 7748] and [RFC 8410] are incompatible.

The following is a sample template for creating a Montgomery EC public key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_EC_MONTGOMERY;
CK_UTF8CHAR label[] = “A Montgomery EC public key object”;
CK_BYTE ecParams[] = {...};
CK_BYTE ecPoint[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_EC_PARAMS, ecParams, sizeof(ecParams)},
  {CKA_EC_POINT, ecPoint, sizeof(ecPoint)}
};
~~~

### Montgomery Elliptic Curve private key objects

Montgomery EC private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_EC_MONTGOMERY**) hold Montgomery EC private keys. See Section [6.3] for
more information about EC. The following table defines the Montgomery EC private
key object attributes, in addition to the common attributes defined for this
object class:

| Attribute             | Data type   | Meaning                          |
|-----------------------|-------------|----------------------------------|
| CKA_EC_PARAMS ^1,4,6^ | Byte array  | DER-encoding of a Parameters value as defined above |
| CKA_VALUE ^1,4,6,7^   | Big integer | Private key bytes in little endian order as defined in [RFC 7748] |
table: Montgomery Elliptic Curve Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_EC_PARAMS** attribute value is known as the “EC domain parameters” and
is defined in ANSI [X9.62] as a choice of three parameter representation
methods. A 4th choice is added to support Edwards and Montgomery Elliptic
Curves. The **CKA_EC_PARAMS** attribute has the following syntax:

~~~{.c}
Parameters ::= CHOICE {
  ecParameters	ECParameters,
  oId	CURVES.&id({CurveNames}),
  implicitlyCA	NULL,
  curveName	PrintableString
}
~~~

Montgomery EC private keys only support the use of the **curveName** selection
to specify a curve name as defined in [RFC7748] and the use of the **oId**
selection to specify a curve through an ECDH algorithm as defined in [RFC 8410].
Note that keys defined by [RFC 7748] and [RFC 8410] are incompatible.

Note that when generating a Montgomery EC private key, the EC domain parameters
are not specified in the key’s template. This is because Montgomery EC private
keys are only generated as part of a Montgomery EC key pair, and the EC domain
parameters for the pair are specified in the template for the Montgomery EC
public key.

The following is a sample template for creating a Montgomery EC private key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_EC_MONTGOMERY;
CK_UTF8CHAR label[] = “A Montgomery EC private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE ecParams[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_SUBJECT, subject, sizeof(subject)},
  {CKA_ID, id, sizeof(id)},
  {CKA_SENSITIVE, &true, sizeof(true)},
  {CKA_DERIVE, &true, sizeof(true)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Elliptic Curve key pair generation

The short Weierstrass ECkey pair generation mechanism, denoted
**CKM_EC_KEY_PAIR_GEN**, is a key pair generation mechanism that uses the method
defined by the [ANSI X9.62] and [ANSI X9.63] standards.

The short Weierstrass EC key pair generation mechanism, denoted
CKM_EC_KEY_PAIR_GEN_W_EXTRA_BITS, is a key pair generation mechanism that uses
the method defined by [FIPS PUB 186-4] Appendix B.4.1.

These mechanisms do not have a parameter.

These mechanisms generate EC public/private key pairs with particular EC domain
parameters, as specified in the **CKA_EC_PARAMS** attribute of the template for
the public key. Note that this version of Cryptoki does not include a mechanism
for generating these EC domain parameters.

These mechanism contribute the **CKA_CLASS**, **CKA_KEY_TYPE**, and
**CKA_EC_POINT** attributes to the new public key and the **CKA_CLASS**,
**CKA_KEY_TYPE**, **CKA_EC_PARAMS** and **CKA_VALUE** attributes to the new
private key. Other attributes supported by the EC public and private key types
(specifically, the flags indicating which functions the keys support) may also
be specified in the templates for the keys, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For example, if a Cryptoki library
supports only ECDSA using a field of characteristic 2 which has between 2^200^
and 2^300^ elements, then _ulMinKeySize_ = 201 and _ulMaxKeySize_ = 301 (when
written in binary notation, the number 2200 consists of a 1 bit followed by 200
0 bits. It is therefore a 201-bit number. Similarly, 2^300^ is a 301-bit
number).

### Edwards Elliptic Curve key pair generation

The Edwards EC key pair generation mechanism, denoted
**CKM_EC_EDWARDS_KEY_PAIR_GEN**, is a key pair generation mechanism for EC keys over
curves represented in Edwards form.

This mechanism does not have a parameter.

The mechanism can only generate EC public/private key pairs over the curves
edwards25519 and edwards448 as defined in [RFC 8032] or the curves id-Ed25519
and id-Ed448 as defined in [RFC 8410]. These curves can only be specified in the
**CKA_EC_PARAMS** attribute of the template for the public key using the **curveName**
or the **oId** methods. Attempts to generate keys over these curves using any other
EC key pair generation mechanism will fail with **CKR_CURVE_NOT_SUPPORTED**.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and
**CKA_EC_POINT** attributes to the new public key and the **CKA_CLASS**,
**CKA_KEY_TYPE**, **CKA_EC_PARAMS** and **CKA_VALUE** attributes to the new
private key. Other attributes supported by the Edwards EC public and private key
types (specifically, the flags indicating which functions the keys support) may
also be specified in the templates for the keys, or else are assigned default
initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For this mechanism, the only allowed
values are 255 and 448 as [RFC 8032] only defines curves of these two sizes. A
Cryptoki implementation may support one or both of these curves and should set
the _ulMinKeySize_ and _ulMaxKeySize_ fields accordingly.

### Montgomery Elliptic Curve key pair generation

The Montgomery EC key pair generation mechanism, denoted
**CKM_EC_MONTGOMERY_KEY_PAIR_GEN**, is a key pair generation mechanism for EC
keys over curves represented in Montgomery form.

This mechanism does not have a parameter.

The mechanism can only generate Montgomery EC public/private key pairs over the
curves curve25519 and curve448 as defined in [RFC 7748] or the curves id-X25519
and id-X448 as defined in [RFC 8410]. These curves can only be specified in the
**CKA_EC_PARAMS** attribute of the template for the public key using the
**curveName** or **oId** methods. Attempts to generate keys over these curves
using any other EC key pair generation mechanism will fail with
**CKR_CURVE_NOT_SUPPORTED**.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and
**CKA_EC_POINT** attributes to the new public key and the **CKA_CLASS**,
**CKA_KEY_TYPE**, **CKA_EC_PARAMS** and **CKA_VALUE** attributes to the new
private key. Other attributes supported by the EC public and private key types
(specifically, the flags indicating which functions the keys support) may also
be specified in the templates for the keys, or else are assigned default initial
values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For this mechanism, the only allowed
values are 255 and 448 as [RFC 7748] only defines curves of these two sizes. A
Cryptoki implementation may support one or both of these curves and should set
the _ulMinKeySize_ and _ulMaxKeySize_ fields accordingly.

### ECDSA without hashing

Refer to section [6.3.1][EC Signatures] for signature encoding.

The ECDSA without hashing mechanism, denoted **CKM_ECDSA**, is a mechanism for
single-part signatures and verification for ECDSA. (This mechanism corresponds
only to the part of ECDSA that processes the hash value, which should not be
longer than 1024 bits; it does not compute the hash value.)

This mechanism does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function     | Key type           | Input length | Output length |
|--------------|--------------------|:------------:|:-------------:|
| C_Sign ^1^   | CKK_EC private key | any^3^       | _2nLen_       |
| C_Verify ^1^ | CKK_EC public key  | any^3^, ≤_2nLen_^2^ |	N/A    |
table: ECDSA without hashing: Key and Data Length

^1^ Single-part operations only.  
^2^ Data length, signature length.  
^3^ Input the entire raw digest. Internally, this will be truncated to the
    appropriate number of bits.  

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For example, if a Cryptoki library
supports only ECDSA using a field of characteristic 2 which has between 2^200^
and 2^300^ elements (inclusive), then _ulMinKeySize_ = 201 and _ulMaxKeySize_ =
301 (when written in binary notation, the number 2^200^ consists of a 1 bit
followed by 200 0 bits. It is therefore a 201-bit number. Similarly, 2^300^ is a
301-bit number).

### ECDSA with hashing

Refer to section [6.3.1][EC Signatures] for signature encoding.

The ECDSA with hashing mechanism, denoted **CKM_ECDSA_\<hash\>** where \<hash\>
identifies a hash function as per Table 69, is a mechanism for single- and
multiple-part signatures and verification for ECDSA. This mechanism computes the
entire ECDSA specification, including the hashing.

| Mechanism          | Hash function |
|--------------------|---------------|
| CKM_ECDSA_SHA1     | SHA-1         |
| CKM_ECDSA_SHA224   | SHA-224       |
| CKM_ECDSA_SHA256   | SHA-256       |
| CKM_ECDSA_SHA384   | SHA-384       |
| CKM_ECDSA_SHA512   | SHA-512       |
| CKM_ECDSA_SHA3_224 | SHA3-224      |
| CKM_ECDSA_SHA3_256 | SHA3-256      |
| CKM_ECDSA_SHA3_384 | SHA3-384      |
| CKM_ECDSA_SHA3_512 | SHA3-512      |
table: ECDSA with hashing: mechanisms and hash functions

This mechanism does not have a parameter.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type           | Input length | Output length |
|----------|--------------------|:------------:|:-------------:|
| C_Sign   | CKK_EC private key | any          | _2nLen_       |
| C_Verify | CKK_EC public key  | any, ≤_2nLen_^2^ | N/A       |
table: ECDSA with hashing: Key and Data Length

^2^ Data length, signature length.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For example, if a Cryptoki library
supports only ECDSA using a field of characteristic 2 which has between 2^200^
and 2^300^ elements, then _ulMinKeySize_ = 201 and _ulMaxKeySize_ = 301 (when
written in binary notation, the number 2^200^ consists of a 1 bit followed by
200 0 bits. It is therefore a 201-bit number. Similarly, 2^300^ is a 301-bit
number).

### EdDSA

The EdDSA mechanism, denoted **CKM_EDDSA**, is a mechanism for single-part and
multipart signatures and verification for EdDSA. This mechanism implements the
five EdDSA signature schemes defined in [RFC 8032] and [RFC 8410].

For curves according to [RFC 8032], this mechanism has an optional parameter, a
**CK_EDDSA_PARAMS** structure. The absence or presence of the parameter as well as
its content is used to identify which signature scheme is to be used. The
following table enumerates the five signature schemes defined in [RFC 8032] and
all supported permutations of the mechanism parameter and its content.

| Signature Scheme | Mechanism Param | phFlag | Context Data |
|------------------|-----------------|:------:|:------------:|
| Ed25519          | Not Required    | N/A    | N/A          |
| Ed25519ctx       | Required        | False  | Optional     |
| Ed25519ph        | Required        | True   | Optional     |
| Ed448            | Required        | False  | Optional     |
| Ed448ph          | Required        | True   | Optional     |
table: Mapping to RFC 8032 Signature Schemes

For curves according to [RFC 8410], the mechanism is implicitly given by the
curve, which is EdDSA in pure mode.

Constraints on key types and the length of data are summarized in the following
table:

| Function | Key type                   | Input length | Output length |
|----------|----------------------------|:------------:|:-------------:|
| C_Sign   | CKK_EC_EDWARDS private key	| any          | _2bLen_       |
| C_Verify | CKK_EC_EDWARDS public key  | any, ≤_2bLen_^2^ | N/A       |
table: EdDSA: Key and Data Length

^2^ Data length, signature length.

Note that for EdDSA in pure mode, Ed25519 and Ed448 the data must be processed
twice. Therefore, a token might need to cache all the data, especially when used
with **C_SignUpdate**/**C_VerifyUpdate**. If tokens are unable to do so they can
return **CKR_TOKEN_RESOURCE_EXCEEDED**.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For this mechanism, the only allowed
values are 255 and 448 as [RFC 8032] and [RFC 8410] only define curves of these
two sizes. A Cryptoki implementation may support one or both of these curves and
should set the _ulMinKeySize_ and _ulMaxKeySize_ fields accordingly.

### XEdDSA

The XEdDSA mechanism, denoted **CKM_XEDDSA**, is a mechanism for single-part
signatures and verification for XEdDSA. This mechanism implements the XEdDSA
signature scheme defined in [XEDDSA]. **CKM_XEDDSA** operates on
**CKK_EC_MONTGOMERY** type EC keys, which allows these keys to be used both for
signing/verification and for Diffie-Hellman style key-exchanges. This double use
is necessary for the Extended Triple Diffie-Hellman where the long-term identity
key is used to sign short-term keys and also contributes to the DH key-exchange.

This mechanism has a parameter, a **CK_XEDDSA_PARAMS** structure.

Table 73, XEdDSA: Key and Data Length
Function	Key type	Input length	Output length
C_Sign1	CKK_EC_MONTGOMERY private key	Any	2b
C_Verify1	CKK_EC_MONTGOMERY public key	any, ≤2b 2	N/A
1 Single-part operations only.
2 Data length, signature length.
For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the CK_MECHANISM_INFO structure specify the minimum and maximum supported number of bits in the field sizes, respectively. For this mechanism, the only allowed values are 255 and 448 as [XEDDSA] only defines curves of these two sizes. A Cryptoki implementation may support one or both of these curves and should set the ulMinKeySize and ulMaxKeySize fields accordingly.

### EC mechanism parameters

#### CK_EDDSA_PARAMS
\  

**CK_EDDSA_PARAMS** is a structure that provides the parameters for the
**CKM_EDDSA** signature mechanism. The structure is defined as follows:

~~~{.c}
typedef struct CK_EDDSA_PARAMS {
	CK_BBOOL	phFlag;
	CK_ULONG	ulContextDataLen;
	CK_BYTE_PTR	pContextData;
}	CK_EDDSA_PARAMS;
~~~

The fields of the structure have the following meanings:

_phFlag_
: a Boolean value which indicates if Pre-hashed variant of EdDSA should used

_ulContextDataLen_
: the length in bytes of the context data where 0 ≤ ulContextDataLen ≤ 255.

_pContextData_
: context data shared between the signer and verifier

**CK_EDDSA_PARAMS_PTR** is a pointer to a **CK_EDDSA_PARAMS**.

#### CK_XEDDSA_PARAMS
\  

**CK_XEDDSA_PARAMS** is a structure that provides the parameters for the
**CKM_XEDDSA** signature mechanism. The structure is defined as follows:

~~~{.c}
typedef struct CK_XEDDSA_PARAMS {
	CK_XEDDSA_HASH_TYPE	hash;
}	CK_XEDDSA_PARAMS;
~~~

The fields of the structure have the following meanings:

_hash_
: a Hash mechanism to be used by the mechanism.

**CK_XEDDSA_PARAMS_PTR** is a pointer to a **CK_XEDDSA_PARAMS**.

#### CK_XEDDSA_HASH_TYPE
\  

**CK_XEDDSA_HASH_TYPE** is used to indicate the hash function used in XEDDSA. It
is defined as follows:

~~~{.c}
typedef CK_ULONG CK_XEDDSA_HASH_TYPE;
~~~

The following table lists the defined functions.

| Source Identifier |
|-------------------|
| CKM_BLAKE2B_256   |
| CKM_BLAKE2B_512   |
| CKM_SHA3_256      |
| CKM_SHA3_512      |
| CKM_SHA256        |
| CKM_SHA512        |
table: EC: Key Derivation Functions

**CK_XEDDSA_HASH_TYPE_PTR** is a pointer to a **CK_XEDDSA_HASH_TYPE**.

#### CK_EC_KDF_TYPE
\  

**CK_EC_KDF_TYPE** is used to indicate the Key Derivation Function (KDF) applied
to derive keying data from a shared secret. The key derivation function will be
used by the EC key agreement schemes. It is defined as follows:

~~~{.c}
typedef CK_ULONG CK_EC_KDF_TYPE;
~~~

The following table lists the defined functions.

| Source Identifier      |
|------------------------|
| CKD_NULL               |
| CKD_SHA1_KDF           |
| CKD_SHA224_KDF         |
| CKD_SHA256_KDF         |
| CKD_SHA384_KDF         |
| CKD_SHA512_KDF         |
| CKD_SHA3_224_KDF       |
| CKD_SHA3_256_KDF       |
| CKD_SHA3_384_KDF       |
| CKD_SHA3_512_KDF       |
| CKD_SHA1_KDF_SP800     |
| CKD_SHA224_KDF_SP800   |
| CKD_SHA256_KDF_SP800   |
| CKD_SHA384_KDF_SP800   |
| CKD_SHA512_KDF_SP800   |
| CKD_SHA3_224_KDF_SP800 |
| CKD_SHA3_256_KDF_SP800 |
| CKD_SHA3_384_KDF_SP800 |
| CKD_SHA3_512_KDF_SP800 |
| CKD_BLAKE2B_160_KDF    |
| CKD_BLAKE2B_256_KDF    |
| CKD_BLAKE2B_384_KDF    |
| CKD_BLAKE2B_512_KDF    |
table: EC: Key Derivation Functions

The key derivation function **CKD_NULL** produces a raw shared secret value without
applying any key derivation function. 

The key derivation functions **CKD_SHA1_KDF**, **CKD_SHA224_KDF**,
**CKD_SHA384_KDF**, **CKD_SHA512_KDF**, **CKD_SHA3_224_KDF**,
**CKD_SHA3_256_KDF**, **CKD_SHA3_384_KDF**, **CKD_SHA3_512_KDF**, which are
based on SHA-1, SHA-224, SHA-384, SHA-512, SHA3-224, SHA3-256, SHA3-384,
SHA3-512 respectively, derive keying data from the shared secret value as
defined in [ANSI X9.63]. 

The key derivation functions **CKD_SHA1_KDF_SP800**, **CKD_SHA224_KDF_SP800**,
**CKD_SHA384_KDF_SP800**, **CKD_SHA512_KDF_SP800**, **CKD_SHA3_224_KDF_SP800**,
**CKD_SHA3_256_KDF_SP800**, **CKD_SHA3_384_KDF_SP800**,
**CKD_SHA3_512_KDF_SP800**, which are based on SHA-1, SHA-224, SHA-384, SHA-512,
SHA3-224, SHA3-256, SHA3-384, SHA3-512 respectively, derive keying data from the
shared secret value as defined in [NIST SP800-56A] section 5.8.1.1. 

The key derivation functions **CKD_BLAKE2B_160_KDF**, **CKD_BLAKE2B_256_KDF**,
**CKD_BLAKE2B_384_KDF**, **CKD_BLAKE2B_512_KDF**, which are based on the Blake2b
family of hashes, derive keying data from the shared secret value as defined in
[NIST SP800-56A] section 5.8.1.1. **CK_EC_KDF_TYPE_PTR** is a pointer to a
**CK_EC_KDF_TYPE**.

#### CK_ECDH1_DERIVE_PARAMS
\  

**CK_ECDH1_DERIVE_PARAMS** is a structure that provides the parameters for the
**CKM_ECDH1_DERIVE** and **CKM_ECDH1_COFACTOR_DERIVE** key derivation
mechanisms, where each party contributes one key pair. The structure is defined
as follows:

~~~{.c}
typedef struct CK_ECDH1_DERIVE_PARAMS {
	CK_EC_KDF_TYPE	kdf;
	CK_ULONG	ulSharedDataLen;
	CK_BYTE_PTR	pSharedData;
	CK_ULONG	ulPublicDataLen;
	CK_BYTE_PTR	pPublicData;
}	CK_ECDH1_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: key derivation function used on the shared secret value

_ulSharedDataLen_
: the length in bytes of the shared info

_pSharedData_
: some data shared between the two parties

_ulPublicDataLen_
: the length in bytes of the other party’s EC public key

_pPublicData_^1^
: pointer to other party’s EC public key value. For short Weierstrass EC keys: a
  token MUST be able to accept this value encoded as a raw octet string (as per
  section A.5.2 of [ANSI X9.62]). A token MAY, in addition, support accepting
  this value as a DER-encoded ECPoint (as per section E.6 of [ANSI X9.62]) i.e.
  the same as a CKA_EC_POINT encoding. The calling application is responsible
  for converting the offered public key to the compressed or uncompressed forms
  of these encodings if the token does not support the offered form. For
  Montgomery keys: the public key is provided as bytes in little endian order as
  defined in [RFC 7748].

With the key derivation function **CKD_NULL**, _pSharedData_ must be NULL and
_ulSharedDataLen_ must be zero. With the key derivation functions
**CKD_SHA1_KDF**, **CKD_SHA224_KDF**, **CKD_SHA384_KDF**, **CKD_SHA512_KDF**,
**CKD_SHA3_224_KDF**, **CKD_SHA3_256_KDF**, **CKD_SHA3_384_KDF**,
**CKD_SHA3_512_KDF**, **CKD_SHA1_KDF_SP800**, **CKD_SHA224_KDF_SP800**,
**CKD_SHA384_KDF_SP800**, **CKD_SHA512_KDF_SP800**, **CKD_SHA3_224_KDF_SP800**,
**CKD_SHA3_256_KDF_SP800**, **CKD_SHA3_384_KDF_SP800**,
**CKD_SHA3_512_KDF_SP800**, an optional _pSharedData_ may be supplied, which
consists of some data shared by the two parties intending to share the shared
secret. Otherwise, _pSharedData_ must be NULL and _ulSharedDataLen_ must be
zero.

**CK_ECDH1_DERIVE_PARAMS_PTR** is a pointer to a **CK_ECDH1_DERIVE_PARAMS**.

#### CK_ECDH2_DERIVE_PARAMS
\  

**CK_ECDH2_DERIVE_PARAMS** is a structure that provides the parameters to the
**CKM_ECMQV_DERIVE** key derivation mechanism, where each party contributes two
key pairs. The structure is defined as follows:

~~~{.c}
typedef struct CK_ECDH2_DERIVE_PARAMS {
	CK_EC_KDF_TYPE kdf;
	CK_ULONG ulSharedDataLen;
	CK_BYTE_PTR pSharedData;
	CK_ULONG ulPublicDataLen;
	CK_BYTE_PTR pPublicData;
	CK_ULONG ulPrivateDataLen;
	CK_OBJECT_HANDLE hPrivateData;
	CK_ULONG ulPublicDataLen2;
	CK_BYTE_PTR pPublicData2;
} CK_ECDH2_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: key derivation function used on the shared secret value

_ulSharedDataLen_
: the length in bytes of the shared info

_pSharedData_
: some data shared between the two parties

_ulPublicDataLen_
: the length in bytes of the other party’s first EC public key

_pPublicData_
: pointer to other party’s first EC public key value. Encoding rules are as per
  pPublicData  of CK_ECDH1_DERIVE_PARAMS

_ulPrivateDataLen_
: the length in bytes of the second EC private key

_hPrivateData_
: key handle for second EC private key value

_ulPublicDataLen2_
: the length in bytes of the other party’s second EC public key

_pPublicData2_
: pointer to other party’s second EC public key value. Encoding rules are as per
  pPublicData  of CK_ECDH1_DERIVE_PARAMS

With the key derivation function **CKD_NULL**, _pSharedData_ must be NULL and
_ulSharedDataLen_ must be zero. With the key derivation function
**CKD_SHA1_KDF**, an optional _pSharedData_ may be supplied, which consists of
some data shared by the two parties intending to share the shared secret.
Otherwise, _pSharedData_ must be NULL and _ulSharedDataLen_ must be zero.

**CK_ECDH2_DERIVE_PARAMS_PTR* is a pointer to a **CK_ECDH2_DERIVE_PARAMS**.

#### CK_ECMQV_DERIVE_PARAMS
\  

**CK_ECMQV_DERIVE_PARAMS** is a structure that provides the parameters to the
**CKM_ECMQV_DERIVE** key derivation mechanism, where each party contributes two
key pairs. The structure is defined as follows:

~~~{.c}
typedef struct CK_ECMQV_DERIVE_PARAMS {
	CK_EC_KDF_TYPE	kdf;
	CK_ULONG	ulSharedDataLen;
	CK_BYTE_PTR	pSharedData;
	CK_ULONG	ulPublicDataLen;
	CK_BYTE_PTR	pPublicData;
	CK_ULONG	ulPrivateDataLen;
	CK_OBJECT_HANDLE	hPrivateData;
	CK_ULONG	ulPublicDataLen2;
	CK_BYTE_PTR	pPublicData2;
	CK_OBJECT_HANDLE	publicKey;
}	CK_ECMQV_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: key derivation function used on the shared secret value

_ulSharedDataLen_
: the length in bytes of the shared info

_pSharedData_
: some data shared between the two parties

_ulPublicDataLen_
: the length in bytes of the other party’s first EC public key

_pPublicData_
: pointer to other party’s first EC public key value. Encoding rules are as per
  pPublicData  of CK_ECDH1_DERIVE_PARAMS

_ulPrivateDataLen_
: the length in bytes of the second EC private key

_hPrivateData_
: key handle for second EC private key value

_ulPublicDataLen2_
: the length in bytes of the other party’s second EC public key

_pPublicData2_
: pointer to other party’s second EC public key value. Encoding rules are as per
  pPublicData  of CK_ECDH1_DERIVE_PARAMS

_publicKey_
: Handle to the first party’s ephemeral public key

With the key derivation function **CKD_NULL**, _pSharedData_ must be NULL and
_ulSharedDataLen_ must be zero. With the key derivation functions
**CKD_SHA1_KDF**, **CKD_SHA224_KDF**, **CKD_SHA384_KDF**, **CKD_SHA512_KDF**,
**CKD_SHA3_224_KDF**, **CKD_SHA3_256_KDF**, **CKD_SHA3_384_KDF**,
**CKD_SHA3_512_KDF**, **CKD_SHA1_KDF_SP800**, **CKD_SHA224_KDF_SP800**,
**CKD_SHA384_KDF_SP800**, **CKD_SHA512_KDF_SP800**, **CKD_SHA3_224_KDF_SP800**,
**CKD_SHA3_256_KDF_SP800**, **CKD_SHA3_384_KDF_SP800**,
**CKD_SHA3_512_KDF_SP800**, an optional _pSharedData_ may be supplied, which
consists of some data shared by the two parties intending to share the shared
secret. Otherwise, _pSharedData_ must be NULL and _ulSharedDataLen_ must be
zero.

**CK_ECMQV_DERIVE_PARAMS_PTR** is a pointer to a **CK_ECMQV_DERIVE_PARAMS**.

### Elliptic Curve Diffie-Hellman key derivation

The Elliptic Curve Diffie-Hellman (ECDH) key derivation mechanism, denoted
**CKM_ECDH1_DERIVE**, is a mechanism for key derivation based on the Diffie-Hellman
version of the Elliptic Curve key agreement scheme, as defined in [ANSI X9.63]
for short Weierstrass EC keys and [RFC 7748] for Montgomery keys, where each
party contributes one key pair all using the same EC domain parameters.

It has a parameter, a **CK_ECDH1_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.) The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template.

This mechanism has the following rules about key sensitivity and extractability:

* The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
* If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
* Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For example, if a Cryptoki library
supports only EC using a field of characteristic 2 which has between 2^200^ and
2^300^ elements, then _ulMinKeySize_ = 201 and _ulMaxKeySize_ = 301 (when
written in binary notation, the number 2^200^ consists of a 1 bit followed by
200 0 bits.  It is therefore a 201-bit number. Similarly, 2^300^ is a 301-bit
number).

When this mechanism is used in **C_EncapsulateKey** and **C_DecapsulateKey**,
the mechanism parameters _pPublicData_ and _ulPublicDataLen_ must be set to NULL
and 0 respectively. For **C_EncapsulateKey**, an ephemeral key pair is
generated. The value of the generated public key is returned as the ciphertext.
The generated private key is used with public key provided in the API to
generate a symmetric key using EC Derive and has the same format as the public
key used in **C_DeriveKey**. For **C_DecapsulateKey**, the ciphertext is used
with the private key provided in the API to generate a symmetric key using EC
Derive.

Constraints on key types are summarized in the following table:

| Function         | Key type                    |
|------------------|-----------------------------|
| C_DeriveKey      | CKK_EC or CKK_EC_MONTGOMERY |
| C_EncapsulateKey | CKK_EC or CKK_EC_MONTGOMERY |
| C_DecapsulateKey | CKK_EC or CKK_EC_MONTGOMERY |
table: ECDH: Allowed Key Types

### Elliptic Curve Diffie-Hellman with cofactor key derivation

The Elliptic Curve Diffie-Hellman (ECDH) with cofactor key derivation mechanism,
denoted **CKM_ECDH1_COFACTOR_DERIVE**, is a mechanism for key derivation based
on the cofactor Diffie-Hellman version of the Elliptic Curve key agreement
scheme, as defined in [ANSI X9.63], where each party contributes one key pair
all using the same EC domain parameters. Cofactor multiplication is
computationally efficient and helps to prevent security problems like small
group attacks.

It has a parameter, a **CK_ECDH1_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.) The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template.

This mechanism has the following rules about key sensitivity and extractability:

* The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
* If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
* Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For example, if a Cryptoki library
supports only EC using a field of characteristic 2 which has between 2^200^ and
2^300^ elements, then _ulMinKeySize_ = 201 and _ulMaxKeySize_ = 301 (when
written in binary notation, the number 2^200^ consists of a 1 bit followed by
200 0 bits. It is therefore a 201-bit number. Similarly, 2^300^ is a 301-bit
number).

When this mechanism is used in **C_EncapsulateKey** and **C_DecapsulateKey**,
the mechanism parameters _pPublicData_ and _ulPublicDataLen_ must be set to NULL
and 0 respectively. For **C_EncapsulateKey**, an ephemeral key pair is
generated. The value of the generated public key is returned as the ciphertext.
The generated private key is used with public key provided in the API to
generate a symmetric key using EC Cofactor Derive and has the same format as the
public key used in **C_DeriveKey**. For **C_DecapsulateKey**, the ciphertext is
used with the private key provided in the API to generate a symmetric key using
EC Cofactor Derive.

Constraints on key types are summarized in the following table:

| Function         | Key type |
|------------------|----------|
| C_DeriveKey      | CKK_EC   |
| C_EncapsulateKey | CKK_EC   |
| C_DecapsulateKey | CKK_EC   |
table: ECDH with cofactor: Allowed Key Types

### Elliptic Curve Menezes-Qu-Vanstone key derivation

The Elliptic Curve Menezes-Qu-Vanstone (ECMQV) key derivation mechanism, denoted
**CKM_ECMQV_DERIVE**, is a mechanism for key derivation based the MQV version of the
Elliptic Curve key agreement scheme, as defined in [ANSI X9.63], where each
party contributes two key pairs all using the same EC domain parameters.

It has a parameter, a **CK_ECMQV_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.) The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template.

This mechanism has the following rules about key sensitivity and extractability:

* The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key can both be specified to be either CK_TRUE or CK_FALSE. If
  omitted, these attributes each take on some default value.
* If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to CK_FALSE,
  then the derived key will as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to CK_TRUE, then the derived key has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
* Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  CK_FALSE, then the derived key will, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to CK_TRUE, then the derived key has
  its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the minimum and maximum supported number
of bits in the field sizes, respectively. For example, if a Cryptoki library
supports only EC using a field of characteristic 2 which has between 2^200^ and
2^300^ elements, then _ulMinKeySize_ = 201 and _ulMaxKeySize_ = 301 (when
written in binary notation, the number 2^200^ consists of a 1 bit followed by
200 0 bits. It is therefore a 201-bit number. Similarly, 2^300^ is a 301-bit
number).

Constraints on key types are summarized in the following table:

| Function    | Key type |
|-------------|----------|
| C_DeriveKey | CKK_EC   |
table: ECDH MQV: Allowed Key Types

### ECDH AES KEY WRAP

Note: Mechanism **CKM_ECDH_AES_KEY_WRAP** is deprecated with PKCS #11 Version 3.2.
Use **CKM_ECDH_COF_AES_KEY_WRAP** and **CKM_ECDH_X_AES_KEY_WRAP** instead.
**CKM_ECDH_X_AES_KEY_WRAP** will work as **CKM_ECDH_AES_KEY_WRAP** applied to
CKK_EC_MONTGOMERY keys.

The ECDH AES KEY WRAP mechanism, denoted **CKM_ECDH_AES_KEY_WRAP**, is a mechanism
based on Elliptic Curve public-key crypto-system and the AES key wrap mechanism.
It supports single-part key wrapping; and key unwrapping. 

It has a parameter, a **CK_ECDH_AES_KEY_WRAP_PARAMS** structure. 

The mechanism can wrap and unwrap an asymmetric target key of any length and
type using an EC key. 

* A temporary AES key is derived from a temporary EC key and the wrapping EC key
  using the **CKM_ECDH1_DERIVE** mechanism.
* The derived AES key is used for wrapping the target key using the
  **CKM_AES_KEY_WRAP_KWP** mechanism. 

For wrapping, the mechanism -

* Generates a temporary random EC key (transport key) having the same parameters
  as the wrapping EC key (and domain parameters). Saves the transport key public
  key material.
* Performs ECDH operation using **CKM_ECDH1_DERIVE** with parameters of kdf,
  ulSharedDataLen and pSharedData using the private key of the transport EC key
  and the public key of wrapping EC key and gets the first ulAESKeyBits bits of
  the derived key to be the temporary AES key.
* Wraps the target key with the temporary AES key using **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key and EC transport private key.
* Concatenates public key material of the transport key and output the
  concatenated blob. The first part is the public key material of the transport
  key and the second part is the wrapped target key.

The private target key will be encoded as defined in section 6.7

The use of Attributes in the PrivateKeyInfo structure is OPTIONAL. In case of
conflicts between the object attribute template, and Attributes in the
PrivateKeyInfo structure, an error should be thrown.

For unwrapping, the mechanism - 

* Splits the input into two parts. The first part is the public key material of
  the transport key and the second part is the wrapped target key. The length of
  the first part is equal to the length of the public key material of the
  unwrapping EC key.  
  _Note: since the transport key and the wrapping EC key share the
  same domain, the length of the public key material of the transport key is the
  same length of the public key material of the unwrapping EC key._
* Performs ECDH operation using **CKM_ECDH1_DERIVE** with parameters of kdf,
  ulSharedDataLen and pSharedData using the private part of unwrapping EC key
  and the public part of the transport EC key and gets first ulAESKeyBits bits of
  the derived key to be the temporary AES key. 
* Un-wraps the target key from the second part with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key. 


+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_ECDH_AES_KEY_WRAP                |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: _CKM_ECDH_AES_KEY_WRAP_ Mechanisms vs. Functions

Constraints on key types are summarized in the following table:

| Function                | Key type                    |
|-------------------------|-----------------------------|
| C_WrapKey / C_UnwrapKey | CKK_EC or CKK_EC_MONTGOMERY |
table: ECDH AES Key Wrap: Allowed Key Types

### ECDH COFACTOR AES KEY WRAP

The ECDH COFACTOR AES KEY WRAP mechanism, denoted **CKM_ECDH_COF_AES_KEY_WRAP**,
is a mechanism based on elliptic curve public-key crypto-system and the AES key
wrap mechanism. It supports single-part key wrapping; and key unwrapping.

It has a parameter, a **CK_ECDH_AES_KEY_WRAP_PARAMS** structure. 

The mechanism can wrap and unwrap an asymmetric target key of any length and
type using a **CKK_EC key**. 

* A temporary AES key is derived from a temporary EC key and the wrapping EC key
  using the **CKM_ECDH1_COFACTOR_DERIVE** mechanism.
* The derived AES key is used for wrapping the target key using the
  **CKM_AES_KEY_WRAP_KWP** mechanism. 

For wrapping, the mechanism -

* Generates a temporary random EC key (transport key) having the same parameters
  as the wrapping EC key (and domain parameters). 
* Saves the transport key public key material as DER-encoded OCTET STRING of the
  ANSI X9.62 ECPoint value.
* Performs ECDH operation using **CKM_ECDH1_COFACTOR_DERIVE** with parameters of
  kdf, ulSharedDataLen and pSharedData using the private key of the transport EC
  key and the public key of wrapping EC key and gets the first ulAESKeyBits bits
  of the derived key to be the temporary AES key.
* Wraps the target key with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key and EC transport private key.
* Concatenates public key material of the transport key and output the
  concatenated blob. The first part is the public key material of the transport
  key and the second part is the wrapped target key.

The private target key will be encoded as defined in section [6.7]

The use of Attributes in the PrivateKeyInfo structure is OPTIONAL. In case of
conflicts between the object attribute template, and Attributes in the
PrivateKeyInfo structure, an error should be thrown.

For unwrapping, the mechanism -

* Splits the input into two parts. The first part is the public key material of
  the transport key and the second part is the wrapped target key. Since the
  public key material is a DER encoded OCTET STRING its length can be easily
  determined.
* Performs ECDH operation using **CKM_ECDH1_COFACTOR_DERIVE** with parameters of
  kdf, ulSharedDataLen and pSharedData using the private part of unwrapping EC
  key and the public part of the transport EC key and gets first ulAESKeyBits bits
  of the derived key to be the temporary AES key.
* Un-wraps the target key from the second part with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
*  Zeroizes the temporary AES key. 

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_ECDH_COF_AES_KEY_WRAP            |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: _CKM_ECDH_COF_AES_KEY_WRAP_ Mechanisms vs. Functions

Constraints on key types are summarized in the following table:

| Function                | Key type |
|-------------------------|----------|
| C_WrapKey / C_UnwrapKey | CKK_EC   |
table: ECDH COFACTOR AES Key Wrap: Allowed Key Types

### ECDH Montgomery AES KEY WRAP

The ECDH Montgomery AES KEY WRAP mechanism, denoted **CKM_ECDH_X_AES_KEY_WRAP**,
is a mechanism based on elliptic curve public-key crypto-system and the AES key
wrap mechanism. It supports single-part key wrapping; and key unwrapping.

It has a parameter, a **CK_ECDH_AES_KEY_WRAP_PARAMS** structure. 

The mechanism can wrap and unwrap an asymmetric target key of any length and
type using a **CKK_EC_MONTGOMERY** EC key. 

* A temporary AES key is derived from a temporary EC key and the wrapping EC key
  using the **CKM_ECDH1_DERIVE** mechanism.
* The derived AES key is used for wrapping the target key using the
  **CKM_AES_KEY_WRAP_KWP** mechanism. 

For wrapping, the mechanism -

* Generates a temporary random EC key (transport key) having the same parameters
  as the wrapping **CKK_EC_MONTGOMERY** EC key.
* Saves the transport key public key material as bytes in little endian order as
  defined in [RFC 7748]. (i.e. as encoded in the CKA_EC_POINT attribute of
  Montgomery public keys).
* Performs ECDH operation using **CKM_ECDH1_DERIVE** with parameters of kdf,
  ulSharedDataLen and pSharedData using the private key of the transport EC key
  and the public key of wrapping EC key and gets the first ulAESKeyBits bits of
  the derived key to be the temporary AES key.
* Wraps the target key with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key and EC transport private key.
* Concatenates public key material of the transport key and output the
  concatenated blob. The first part is the public key material of the transport
  key and the second part is the wrapped target key.

The private target key will be encoded as defined in section [6.7]

The use of Attributes in the PrivateKeyInfo structure is OPTIONAL. In case of
conflicts between the object attribute template, and Attributes in the
PrivateKeyInfo structure, an error should be thrown.

For unwrapping, the mechanism - 

* Splits the input into two parts. The first part is the public key material of
  the **CKK_EC_MONTGOMERY** transport key and the second part is the wrapped
  target key. The length of the first part is equal to the length of the public
  key material of the unwrapping **CKK_EC_MONTGOMERY** EC key.  
  _Note: since the transport key and the wrapping EC key share the same domain,
  the length of the public key material of the transport key is the same length
  as the public key material of the unwrapping EC key_.
* Performs ECDH operation using **CKM_ECDH1_DERIVE** with parameters of kdf,
  ulSharedDataLen and pSharedData using the private part of unwrapping EC key
  and the public part of the transport EC key and gets first ulAESKeyBits bits
  of the derived key to be the temporary AES key. 
* Un-wraps the target key from the second part with the temporary AES key using
  **CKM_AES_KEY_WRAP_KWP**.
* Zeroizes the temporary AES key. 

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_ECDH_X_AES_KEY_WRAP              |     |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: _CKM_ECDH_X_AES_KEY_WRAP_ Mechanisms vs. Functions

Constraints on key types are summarized in the following table:

| Function                | Key type          |
|-------------------------|-------------------|
| C_WrapKey / C_UnwrapKey | CKK_EC_MONTGOMERY |
table: ECDH Montgomery AES Key Wrap: Allowed Key Types

### ECDH AES KEY WRAP mechanism parameters

#### CK_ECDH_AES_KEY_WRAP_PARAMS
\  

**CK_ECDH_AES_KEY_WRAP_PARAMS** is a structure that provides the parameters to
the **CKM_ECDH_AES_KEY_WRAP**, **CKM_ECDH_COF_AES_KEY_WRAP** and
**CKM_ECDH_X_AES_KEY_WRAP** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_ECDH_AES_KEY_WRAP_PARAMS {
	CK_ULONG	ulAESKeyBits;
	CK_EC_KDF_TYPE	kdf;
	CK_ULONG	ulSharedDataLen;
	CK_BYTE_PTR	pSharedData;
}	CK_ECDH_AES_KEY_WRAP_PARAMS;
~~~

The fields of the structure have the following meanings:

_ulAESKeyBits_
: length of the temporary AES key in bits. Can be only 128, 192 or 256.

_kdf_
: key derivation function used on the shared secret value to generate AES key.

_ulSharedDataLen_
: the length in bytes of the shared info

_pSharedData_
: Some data shared between the two parties

CK_ECDH_AES_KEY_WRAP_PARAMS_PTR is a pointer to a CK_ECDH_AES_KEY_WRAP_PARAMS.

### FIPS 186-4

When **CKM_ECDSA** is operated in FIPS mode, the curves SHALL either be NIST
recommended curves (with a fixed set of domain parameters) or curves with domain
parameters generated as specified by [ANSI X9.62]. The NIST recommended curves
are:

P-192, P-224, P-256, P-384, P-521  
K-163, B-163, K-233, B-233  
K-283, B-283, K-409, B-409  
K-571, B-571  
