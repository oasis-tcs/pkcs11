## Diffie-Hellman

+--------------------------------------+---------------------------------------------------+
|                                      |Functions                                          |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_DH_PKCS_KEY_PAIR_GEN             |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DH_PKCS_PARAMETER_GEN            |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_DH_PKCS_DERIVE                   |     |     |      |     |       |     |  ✓  |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X9_42_DH_KEY_PAIR_GEN            |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X9_42_DH_PARAMETER_GEN           |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X9_42_DH_DERIVE                  |     |     |      |     |       |     |  ✓  |  ✓   |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X9_42_DH_HYBRID_DERIVE           |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_X9_42_MQV_DERIVE                 |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Diffie-Hellman Mechanisms vs. Functions

### Definitions
This section defines the key type “**CKK_DH**” for type CK_KEY_TYPE as used in
the **CKA_KEY_TYPE** attribute of [DH] key objects.

Mechanisms:

- CKM_DH_PKCS_KEY_PAIR_GEN
- CKM_DH_PKCS_PARAMETER_GEN
- CKM_DH_PKCS_DERIVE
- CKM_X9_42_DH_KEY_PAIR_GEN
- CKM_X9_42_DH_PARAMETER_GEN
- CKM_X9_42_DH_DERIVE
- CKM_X9_42_DH_HYBRID_DERIVE
- CKM_X9_42_MQV_DERIVE

### Diffie-Hellman public key objects

Diffie-Hellman public key objects (object class **CKO_PUBLIC_KEY**, key type
**CKK_DH**) hold Diffie-Hellman public keys. The following table defines the
Diffie-Hellman public key object attributes, in addition to the common
attributes defined for this object class:

| Attribute       | Data type   | Meaning                                |
|-----------------|-------------|----------------------------------------|
| CKA_PRIME ^1,3^ | Big integer | Prime p                                |
| CKA_BASE ^1,3^  | Big integer | Base g                                 |
| CKA_VALUE ^1,4^ | Big integer | Public value y                         |
table: Diffie-Hellman Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME** and **CKA_BASE** attribute values are collectively the “Diffie-Hellman
domain parameters”. Depending on the token, there may be limits on the length of
the key components. See [PKCS #3] for more information on Diffie-Hellman keys.

The following is a sample template for creating a Diffie-Hellman public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_DH;
CK_UTF8CHAR label[] = “A Diffie-Hellman public key object”;
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### X9.42 Diffie-Hellman public key objects

X9.42 Diffie-Hellman public key objects (object class **CKO_PUBLIC_KEY**, key
type **CKK_X9_42_DH**) hold X9.42 Diffie-Hellman public keys. The following
table defines the X9.42 Diffie-Hellman public key object attributes, in addition
to the common attributes defined for this object class:

| Attribute          | Data type   | Meaning                              |
|--------------------|-------------|--------------------------------------|
| CKA_PRIME ^1,3^    | Big integer | Prime p (≥ 1024 bits, in steps of 256 bits) |
| CKA_BASE ^1,3^     | Big integer | Base g                               |
| CKA_SUBPRIME ^1,3^ | Big integer | Subprime q (≥ 160 bits)              |
| CKA_VALUE ^1,4^    | Big integer | Public value y                       |
table: X9.42 Diffie-Hellman Public Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME**, **CKA_BASE** and **CKA_SUBPRIME** attribute values are collectively the
“X9.42 Diffie-Hellman domain parameters”. See the [ANSI X9.42] standard for more
information on X9.42 Diffie-Hellman keys.

The following is a sample template for creating a X9.42 Diffie-Hellman public key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_X9_42_DH;
CK_UTF8CHAR label[] = “A X9.42 Diffie-Hellman public key object”;
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE subprime[] = {...};
CK_BYTE value[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_SUBPRIME, subprime, sizeof(subprime)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Diffie-Hellman private key objects

Diffie-Hellman private key objects (object class **CKO_PRIVATE_KEY**, key type
**CKK_DH**) hold Diffie-Hellman private keys. The following table defines the
Diffie-Hellman private key object attributes, in addition to the common
attributes defined for this object class:

| Attribute           | Data type   | Meaning                            |
|---------------------|-------------|------------------------------------|
| CKA_PRIME ^1,4,6^   | Big integer | Prime p                            |
| CKA_BASE ^1,4,6^    | Big integer | Base g                             |
| CKA_VALUE ^1,4,6,7^ | Big integer | Private value x                    |
| CKA_VALUE_BITS ^2^  | CK_ULONG    | Length in bits of private value x  |
table: Diffie-Hellman Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME** and **CKA_BASE** attribute values are collectively the
“Diffie-Hellman domain parameters”. Depending on the token, there may be limits
on the length of the key components. See [PKCS #3] for more information on
Diffie-Hellman keys.

Note that when generating a Diffie-Hellman private key, the Diffie-Hellman
parameters are not specified in the key’s template. This is because
Diffie-Hellman private keys are only generated as part of a Diffie-Hellman key
pair, and the Diffie-Hellman parameters for the pair are specified in the
template for the Diffie-Hellman public key.

The following is a sample template for creating a Diffie-Hellman private key
object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_DH;
CK_UTF8CHAR label[] = “A Diffie-Hellman private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
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
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### X9.42 Diffie-Hellman private key objects

X9.42 Diffie-Hellman private key objects (object class **CKO_PRIVATE_KEY**, key
type **CKK_X9_42_DH**) hold X9.42 Diffie-Hellman private keys. The following
table defines the X9.42 Diffie-Hellman private key object attributes, in
addition to the common attributes defined for this object class:

| Attribute            | Data type   | Meaning                            |
|----------------------|-------------|------------------------------------|
| CKA_PRIME ^1,4,6^    | Big integer | Prime p (≥ 1024 bits, in steps of 256 bits) |
| CKA_BASE ^1,4,6^     | Big integer | Base g                             |
| CKA_SUBPRIME ^1,4,6^ | Big integer | Subprime q (≥ 160 bits)            |
| CKA_VALUE ^1,4,6,7^  | Big integer | Private value x                    |
table: X9.42 Diffie-Hellman Private Key Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME**, **CKA_BASE** and **CKA_SUBPRIME** attribute values are
collectively the “X9.42 Diffie-Hellman domain parameters”. Depending on the
token, there may be limits on the length of the key components. See the [ANSI
X9.42] standard for more information on X9.42 Diffie-Hellman keys.

Note that when generating a X9.42 Diffie-Hellman private key, the X9.42
Diffie-Hellman domain parameters are not specified in the key’s template. This
is because X9.42 Diffie-Hellman private keys are only generated as part of a
X9.42 Diffie-Hellman key pair, and the X9.42 Diffie-Hellman domain parameters
for the pair are specified in the template for the X9.42 Diffie-Hellman public
key.

The following is a sample template for creating a X9.42 Diffie-Hellman private
key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_X9_42_DH;
CK_UTF8CHAR label[] = “A X9.42 Diffie-Hellman private key object”;
CK_BYTE subject[] = {...};
CK_BYTE id[] = {123};
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE subprime[] = {...};
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
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_SUBPRIME, subprime, sizeof(subprime)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

### Diffie-Hellman domain parameter objects

Diffie-Hellman domain parameter objects (object class **CKO_DOMAIN_PARAMETERS**,
key type **CKK_DH**) hold Diffie-Hellman domain parameters. The following table
defines the Diffie-Hellman domain parameter object attributes, in addition to
the common attributes defined for this object class:

| Attribute            | Data type   | Meaning                           |
|----------------------|-------------|-----------------------------------|
| CKA_PRIME ^1,4^      | Big integer | Prime p                           |
| CKA_BASE ^1,4^       | Big integer | Base g                            |
| CKA_PRIME_BITS ^2,3^ | CK_ULONG    | Length of the prime value.        |
table: Diffie-Hellman Domain Parameter Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME** and **CKA_BASE** attribute values are collectively the
“Diffie-Hellman domain parameters”. Depending on the token, there may be limits
on the length of the key components. See [PKCS #3] for more information on
Diffie-Hellman domain parameters.

The following is a sample template for creating a Diffie-Hellman domain
parameter object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_DOMAIN_PARAMETERS;
CK_KEY_TYPE keyType = CKK_DH;
CK_UTF8CHAR label[] = “A Diffie-Hellman domain parameters object”;
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)},
};
~~~

### X9.42 Diffie-Hellman domain parameters objects

X9.42 Diffie-Hellman domain parameters objects (object class
**CKO_DOMAIN_PARAMETERS**, key type **CKK_X9_42_DH**) hold X9.42 Diffie-Hellman
domain parameters. The following table defines the X9.42 Diffie-Hellman domain
parameters object attributes, in addition to the common attributes defined for
this object class:

| Attribute               | Data type   | Meaning                        |
|-------------------------|-------------|--------------------------------|
| CKA_PRIME ^1,4^         | Big integer | Prime p (≥ 1024 bits, in steps of 256 bits) |
| CKA_BASE ^1,4^          | Big integer | Base g                         |
| CKA_SUBPRIME ^1,4^      | Big integer | Subprime q (≥ 160 bits)        |
| CKA_PRIME_BITS ^2,3^    | CK_ULONG    | Length of the prime value.     |
| CKA_SUBPRIME_BITS ^2,3^ | CK_ULONG    | Length of the subprime value.  |
table: X9.42 Diffie-Hellman Domain Parameters Object Attributes

- Refer to Table 13 for footnotes

The **CKA_PRIME**, **CKA_BASE** and **CKA_SUBPRIME** attribute values are
collectively the “X9.42 Diffie-Hellman domain parameters”. Depending on the
token, there may be limits on the length of the domain parameters components.
See the [ANSI X9.42] standard for more information on X9.42 Diffie-Hellman
domain parameters.

The following is a sample template for creating a X9.42 Diffie-Hellman domain
parameters object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_DOMAIN_PARAMETERS;
CK_KEY_TYPE keyType = CKK_X9_42_DH;
CK_UTF8CHAR label[] = “A X9.42 Diffie-Hellman domain parameters object”;
CK_BYTE prime[] = {...};
CK_BYTE base[] = {...};
CK_BYTE subprime[] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_PRIME, prime, sizeof(prime)},
  {CKA_BASE, base, sizeof(base)},
  {CKA_SUBPRIME, subprime, sizeof(subprime)},
};
~~~

### PKCS #3 Diffie-Hellman key pair generation

The PKCS #3 Diffie-Hellman key pair generation mechanism, denoted
**CKM_DH_PKCS_KEY_PAIR_GEN**, is a key pair generation mechanism based on
Diffie-Hellman key agreement, as defined in [PKCS #3]. This is what PKCS #3
calls “phase I”. It does not have a parameter.

The mechanism generates Diffie-Hellman public/private key pairs with a
particular prime and base, as specified in the **CKA_PRIME** and **CKA_BASE**
attributes of the template for the public key. If the **CKA_VALUE_BITS**
attribute of the private key is specified, the mechanism limits the length in
bits of the private value, as described in [PKCS #3]. 

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PRIME**, **CKA_BASE**, and **CKA_VALUE** (and the **CKA_VALUE_BITS**
attribute, if it is not already provided in the template) attributes to the new
private key; other attributes required by the Diffie-Hellman public and private
key types must be specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Diffie-Hellman
prime sizes, in bits.

### PKCS #3 Diffie-Hellman domain parameter generation

The PKCS #3 Diffie-Hellman domain parameter generation mechanism, denoted
**CKM_DH_PKCS_PARAMETER_GEN**, is a domain parameter generation mechanism based
on Diffie-Hellman key agreement, as defined in [PKCS #3].

It does not have a parameter.

The mechanism generates Diffie-Hellman domain parameters with a particular prime
length in bits, as specified in the **CKA_PRIME_BITS** attribute of the
template.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_PRIME**,
**CKA_BASE**, and **CKA_PRIME_BITS** attributes to the new object. Other
attributes supported by the Diffie-Hellman domain parameter types may also be
specified in the template, or else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Diffie-Hellman
prime sizes, in bits.

### PKCS #3 Diffie-Hellman key derivation

The PKCS #3 Diffie-Hellman key derivation mechanism, denoted
**CKM_DH_PKCS_DERIVE**, is a mechanism for key derivation based on
Diffie-Hellman key agreement, as defined in [PKCS #3]. This is what PKCS #3
calls “phase II”.

It has a parameter, which is the public value of the other party in the key
agreement protocol, represented as a Cryptoki “Big integer” (i.e., a sequence of
bytes, most-significant byte first).

This mechanism derives a secret key from a Diffie-Hellman private key and the
public value of the other party. It computes a Diffie-Hellman secret value from
the public value and private key according to [PKCS #3], and truncates the
result according to the **CKA_KEY_TYPE** attribute of the template and, if it
has one and the key type supports it, the **CKA_VALUE_LEN** attribute of the
template. (The truncation removes bytes from the leading end of the secret
value.) The mechanism contributes the result as the **CKA_VALUE** attribute of
the new key; other attributes required by the key type must be specified in the
template.

This mechanism has the following rules about key sensitivity and
extractability1:

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

When this mechanism is used in **C_EncapsulateKey** and **C_DecapsulateKey**,
the mechanism parameters _pPublicData_ and _ulPublicDataLen_ must be set to NULL
and 0 respectively. For **C_EncapsulateKey**, an ephemeral key pair is
generated.  The value of the generated public key is returned as the ciphertext.
The generated private key is used with public key provided in the API to
generate a symmetric key using Diffie Helman PKCS #3 Derive. For
**C_DecapsulateKey**, the ciphertext is used with the private key provided in
the API to generate a symmetric key using Diffie Helman PKCS #3 Derive.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of Diffie-Hellman
prime sizes, in bits.

### X9.42 Diffie-Hellman mechanism parameters

#### CK_X9_42_DH_KDF_TYPE
\  

**CK_X9_42_DH_KDF_TYPE** is used to indicate the Key Derivation Function (KDF)
applied to derive keying data from a shared secret. The key derivation function
will be used by the X9.42 Diffie-Hellman key agreement schemes. It is defined as
follows:

~~~{.c}
typedef CK_ULONG CK_X9_42_DH_KDF_TYPE;
~~~

The following table lists the defined functions.

| Source Identifier        |
|--------------------------|
| CKD_NULL                 |
| CKD_SHA1_KDF_ASN1        |
| CKD_SHA1_KDF_CONCATENATE |
table: X9.42 Diffie-Hellman Key Derivation Functions

The key derivation function **CKD_NULL** produces a raw shared secret value
without applying any key derivation function whereas the key derivation
functions **CKD_SHA1_KDF_ASN1** and **CKD_SHA1_KDF_CONCATENATE**, which are both
based on SHA-1, derive keying data from the shared secret value as defined in
the [ANSI X9.42] standard.

**CK_X9_42_DH_KDF_TYPE_PTR** is a pointer to a **CK_X9_42_DH_KDF_TYPE**.

#### CK_X9_42_DH1_DERIVE_PARAMS
\  

**CK_X9_42_DH1_DERIVE_PARAMS** is a structure that provides the parameters to
the CKM_X9_42_DH_DERIVE key derivation mechanism, where each party contributes
one key pair. The structure is defined as follows:

~~~{.c}
typedef struct CK_X9_42_DH1_DERIVE_PARAMS {
	CK_X9_42_DH_KDF_TYPE	kdf;
	CK_ULONG	ulOtherInfoLen;
	CK_BYTE_PTR	pOtherInfo;
	CK_ULONG	ulPublicDataLen;
	CK_BYTE_PTR	pPublicData;
}	CK_X9_42_DH1_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: key derivation function used on the shared secret value

_ulOtherInfoLen_
: the length in bytes of the other info

_pOtherInfo_
: some data shared between the two parties

_ulPublicDataLen_
: the length in bytes of the other party’s X9.42 Diffie-Hellman public key

_pPublicData_
: pointer to other party’s X9.42 Diffie-Hellman public key value

With the key derivation function CKD_NULL, _pOtherInfo_ must be NULL and
_ulOtherInfoLen_ must be zero. With the key derivation function
**CKD_SHA1_KDF_ASN1**, _pOtherInfo_ must be supplied, which contains an octet
string, specified in ASN.1 DER encoding, consisting of mandatory and optional
data shared by the two parties intending to share the shared secret. With the
key derivation function **CKD_SHA1_KDF_CONCATENATE**, an optional _pOtherInfo_
may be supplied, which consists of some data shared by the two parties intending
to share the shared secret. Otherwise, _pOtherInfo_ must be NULL and
ulOtherInfoLen must be zero.

**CK_X9_42_DH1_DERIVE_PARAMS_PTR** is a pointer to a
**CK_X9_42_DH1_DERIVE_PARAMS**.

#### CK_X9_42_DH2_DERIVE_PARAMS
\  

**CK_X9_42_DH2_DERIVE_PARAMS** is a structure that provides the parameters to
the **CKM_X9_42_DH_HYBRID_DERIVE** and **CKM_X9_42_MQV_DERIVE** key derivation
mechanisms, where each party contributes two key pairs. The structure is defined
as follows:

~~~{.c}
typedef struct CK_X9_42_DH2_DERIVE_PARAMS {
	CK_X9_42_DH_KDF_TYPE	kdf;
	CK_ULONG	ulOtherInfoLen;
	CK_BYTE_PTR	pOtherInfo;
	CK_ULONG	ulPublicDataLen;
	CK_BYTE_PTR	pPublicData;
	CK_ULONG	ulPrivateDataLen;
	CK_OBJECT_HANDLE	hPrivateData;
	CK_ULONG	ulPublicDataLen2;
	CK_BYTE_PTR	pPublicData2;
}	CK_X9_42_DH2_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: key derivation function used on the shared secret value

_ulOtherInfoLen_
: the length in bytes of the other info

_pOtherInfo_
: some data shared between the two parties

_ulPublicDataLen_
: the length in bytes of the other party’s first X9.42 Diffie-Hellman public key

_pPublicData_
: pointer to other party’s first X9.42 Diffie-Hellman public key value

_ulPrivateDataLen_
: the length in bytes of the second X9.42 Diffie-Hellman private key

_hPrivateData_
: key handle for second X9.42 Diffie-Hellman private key value

_ulPublicDataLen2_
: the length in bytes of the other party’s second X9.42 Diffie-Hellman public
  key

_pPublicData2_
: pointer to other party’s second X9.42 Diffie-Hellman public key value

With the key derivation function **CKD_NULL**, _pOtherInfo_ must be NULL and
_ulOtherInfoLen_ must be zero. With the key derivation function
**CKD_SHA1_KDF_ASN1**, _pOtherInfo_ must be supplied, which contains an octet
string, specified in ASN.1 DER encoding, consisting of mandatory and optional
data shared by the two parties intending to share the shared secret. With the
key derivation function **CKD_SHA1_KDF_CONCATENATE**, an optional _pOtherInfo_
may be supplied, which consists of some data shared by the two parties intending
to share the shared secret.  Otherwise, _pOtherInfo_ must be NULL and
_ulOtherInfoLen_ must be zero.

**CK_X9_42_DH2_DERIVE_PARAMS_PTR** is a pointer to a
**CK_X9_42_DH2_DERIVE_PARAMS**.

#### CK_X9_42_MQV_DERIVE_PARAMS
\  

**CK_X9_42_MQV_DERIVE_PARAMS** is a structure that provides the parameters to
the **CKM_X9_42_MQV_DERIVE** key derivation mechanism, where each party
contributes two key pairs. The structure is defined as follows:

~~~{.c}
typedef struct CK_X9_42_MQV_DERIVE_PARAMS {
	CK_X9_42_DH_KDF_TYPE	kdf;
	CK_ULONG	ulOtherInfoLen;
	CK_BYTE_PTR	pOtherInfo;
	CK_ULONG	ulPublicDataLen;
	CK_BYTE_PTR	pPublicData;
	CK_ULONG	ulPrivateDataLen;
	CK_OBJECT_HANDLE	hPrivateData;
	CK_ULONG	ulPublicDataLen2;
	CK_BYTE_PTR	pPublicData2;
	CK_OBJECT_HANDLE	publicKey;
}	CK_X9_42_MQV_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_kdf_
: key derivation function used on the shared secret value

_ulOtherInfoLen_
: the length in bytes of the other info

_pOtherInfo_
: some data shared between the two parties

_ulPublicDataLen_
: the length in bytes of the other party’s first X9.42 Diffie-Hellman public
  key

_pPublicData_
: pointer to other party’s first X9.42 Diffie-Hellman public key value

_ulPrivateDataLen_
: the length in bytes of the second X9.42 Diffie-Hellman private key

_hPrivateData_
: key handle for second X9.42 Diffie-Hellman private key value

_ulPublicDataLen2_
: the length in bytes of the other party’s second X9.42 Diffie-Hellman public
  key

_pPublicData2_
: pointer to other party’s second X9.42 Diffie-Hellman public key value

_publicKey_
: Handle to the first party’s ephemeral public key

With the key derivation function **CKD_NULL**, _pOtherInfo_ must be NULL and
_ulOtherInfoLen_ must be zero. With the key derivation function
**CKD_SHA1_KDF_ASN1**, _pOtherInfo_ must be supplied, which contains an octet
string, specified in ASN.1 DER encoding, consisting of mandatory and optional
data shared by the two parties intending to share the shared secret. With the
key derivation function **CKD_SHA1_KDF_CONCATENATE**, an optional _pOtherInfo_
may be supplied, which consists of some data shared by the two parties intending
to share the shared secret.  Otherwise, _pOtherInfo_ must be NULL and
_ulOtherInfoLen_ must be zero.

**CK_X9_42_MQV_DERIVE_PARAMS_PTR** is a pointer to a
**CK_X9_42_MQV_DERIVE_PARAMS**.

### X9.42 Diffie-Hellman key pair generation

The X9.42 Diffie-Hellman key pair generation mechanism, denoted
**CKM_X9_42_DH_KEY_PAIR_GEN**, is a key pair generation mechanism based on
Diffie-Hellman key agreement, as defined in the [ANSI X9.42] standard.

It does not have a parameter.

The mechanism generates X9.42 Diffie-Hellman public/private key pairs with a
particular prime, base and subprime, as specified in the **CKA_PRIME**,
**CKA_BASE** and **CKA_SUBPRIME** attributes of the template for the public key. 

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PRIME**, **CKA_BASE**, **CKA_SUBPRIME**, and **CKA_VALUE** attributes to
the new private key; other attributes required by the X9.42 Diffie-Hellman
public and private key types must be specified in the templates.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of X9.42
Diffie-Hellman prime sizes, in bits, for the **CKA_PRIME** attribute.

### X9.42 Diffie-Hellman domain parameter generation

The X9.42 Diffie-Hellman domain parameter generation mechanism, denoted
**CKM_X9_42_DH_PARAMETER_GEN**, is a domain parameters generation mechanism
based on X9.42 Diffie-Hellman key agreement, as defined in the [ANSI X9.42]
standard.

It does not have a parameter.

The mechanism generates X9.42 Diffie-Hellman domain parameters with particular
prime and subprime length in bits, as specified in the **CKA_PRIME_BITS** and
**CKA_SUBPRIME_BITS** attributes of the template for the domain parameters.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, **CKA_PRIME**,
**CKA_BASE**, **CKA_SUBPRIME**, **CKA_PRIME_BITS** and **CKA_SUBPRIME_BITS**
attributes to the new object. Other attributes supported by the X9.42
Diffie-Hellman domain parameter types may also be specified in the template for
the domain parameters, or else are assigned default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of X9.42
Diffie-Hellman prime sizes, in bits.

### X9.42 Diffie-Hellman key derivation

The X9.42 Diffie-Hellman key derivation mechanism, denoted
**CKM_X9_42_DH_DERIVE**, is a mechanism for key derivation based on the
Diffie-Hellman key agreement scheme, as defined in the [ANSI X9.42] standard,
where each party contributes one key pair, all using the same X9.42
Diffie-Hellman domain parameters.

It has a parameter, a **CK_X9_42_DH1_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.)  The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template. Note that
in order to validate this mechanism it may be required to use the **CKA_VALUE**
attribute as the key of a general-length MAC mechanism (e.g.
**CKM_SHA_1_HMAC_GENERAL**) over some test data.

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

When this mechanism is used in **C_EncapsulateKey** and **C_DecapsulateKey**,
the mechanism parameters _pPublicData_ and _ulPublicDataLen_ must be set to NULL
and 0 respectively. For **C_EncapsulateKey**, an ephemeral key pair is
generated.  The value of the generated public key is returned as the ciphertext.
The generated private key is used with public key provided in the API to
generate a symmetric key using Diffie Helman X9.42 Derive. For
**C_DecapsulateKey**, the ciphertext is used with the private key provided in
the API to generate a symmetric key using Diffie Helman X9.42 Derive.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of X9.42
Diffie-Hellman prime sizes, in bits, for the **CKA_PRIME** attribute.

### X9.42 Diffie-Hellman hybrid key derivation

The X9.42 Diffie-Hellman hybrid key derivation mechanism, denoted
**CKM_X9_42_DH_HYBRID_DERIVE**, is a mechanism for key derivation based on the
Diffie-Hellman hybrid key agreement scheme, as defined in the [ANSI X9.42]
standard, where each party contributes two key pair, all using the same X9.42
Diffie-Hellman domain parameters.

It has a parameter, a **CK_X9_42_DH2_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.)  The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template. Note that
in order to validate this mechanism it may be required to use the **CKA_VALUE**
attribute as the key of a general-length MAC mechanism (e.g.
**CKM_SHA_1_HMAC_GENERAL**) over some test data.

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
**CK_MECHANISM_INFO** structure specify the supported range of X9.42
Diffie-Hellman prime sizes, in bits, for the **CKA_PRIME** attribute.

### X9.42 Diffie-Hellman Menezes-Qu-Vanstone key derivation

The X9.42 Diffie-Hellman Menezes-Qu-Vanstone (MQV) key derivation mechanism,
denoted **CKM_X9_42_MQV_DERIVE**, is a mechanism for key derivation based the
MQV scheme, as defined in the [ANSI X9.42] standard, where each party
contributes two key pairs, all using the same X9.42 Diffie-Hellman domain
parameters.

It has a parameter, a **CK_X9_42_MQV_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.) The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template. Note that
in order to validate this mechanism it may be required to use the **CKA_VALUE**
attribute as the key of a general-length MAC mechanism (e.g.
**CKM_SHA_1_HMAC_GENERAL**) over some test data.

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
**CK_MECHANISM_INFO** structure specify the supported range of X9.42
Diffie-Hellman prime sizes, in bits, for the **CKA_PRIME** attribute.
