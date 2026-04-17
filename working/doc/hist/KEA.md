## KEA

### Definitions

This section defines the key type **CKK_KEA** for type **CK_KEY_TYPE** as used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:

- CKM_KEA_KEY_PAIR_GEN
- CKM_KEA_DERIVE

### KEA mechanism parameters

#### CK_KEA_DERIVE_PARAMS; CK_KEA_DERIVE_PARAMS_PTR
\

**CK_KEA_DERIVE_PARAMS** is a structure that provides the parameters to the
**CKM_KEA_DERIVE** mechanism. It is defined as follows:

```c
typedef struct CK_KEA_DERIVE_PARAMS {
  CK_BBOOL isSender;
  CK_ULONG ulRandomLen;
  CK_BYTE_PTR pRandomA;
  CK_BYTE_PTR pRandomB;
  CK_ULONG ulPublicDataLen;
  CK_BYTE_PTR pPublicData;
} CK_KEA_DERIVE_PARAMS;
```

The fields of the structure have the following meanings:

_isSender_
: Option for generating the key (called a TEK). The value is **CK_TRUE** if the
  sender (originator) generates the TEK, **CK_FALSE** if the recipient is
  regenerating the TEK

_ulRandomLen_
: the size of random Ra and Rb in bytes

_pRandomA_
: pointer to Ra data

_pRandomB_
: pointer to Rb data

_ulPublicDataLen_
: other party’s KEA public key size

_pPublicData_
: pointer to other party’s KEA public key value

**CK_KEA_DERIVE_PARAMS_PTR** is a pointer to a **CK_KEA_DERIVE_PARAMS**.

### KEA public key objects 

KEA public key objects (object class **CKO_PUBLIC_KEY**, key type **CKK_KEA**)
hold KEA public keys. The following table defines the KEA public key object
attributes, in addition to the common attributes defined for this object class:

| Attribute         | Data type   | Meaning                                         |
|-------------------|-------------|-------------------------------------------------|
| CKA_PRIME^1,3^    | Big integer | Prime p (512 to 1024 bits, in steps of 64 bits) |
| CKA_SUBPRIME^1,3^ | Big integer | Subprime q (160 bits)                           |
| CKA_BASE^1,3^     | Big integer | Base g (512 to 1024 bits, in steps of 64 bits)  |
| CKA_VALUE^1,4^    | Big integer | Public value y                                  |
table 3: KEA Public Key Object Attributes

- Refer to [PKCS #11-Base] table 11 for footnotes

The **CKA_PRIME**, **CKA_SUBPRIME** and **CKA_BASE** attribute values are
collectively the “KEA domain parameters”.

The following is a sample template for creating a KEA public key object:

```c
CK_OBJECT_CLASS class = CKO_PUBLIC_KEY;
CK_KEY_TYPE keyType = CKK_KEA;
CK_UTF8CHAR label[] = “A KEA public key object”;
CK_BYTE prime[] = {…};
CK_BYTE subprime[] = {…};
CK_BYTE base[] = {…};
CK_BYTE value[] = {…};
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label)-1},
	{CKA_PRIME, prime, sizeof(prime)},
	{CKA_SUBPRIME, subprime, sizeof(subprime)},
	{CKA_BASE, base, sizeof(base)},
	{CKA_VALUE, value, sizeof(value)}
};
```

### KEA private key objects

KEA private key objects (object class **CKO_PRIVATE_KEY**, key type **CKK_KEA**)
hold KEA private keys. The following table defines the KEA private key object
attributes, in addition to the common attributes defined for this object class:

| Attribute           | Data type   | Meaning                                         |
|---------------------|-------------|-------------------------------------------------|
| CKA_PRIME^1,4,6^    | Big integer | Prime p (512 to 1024 bits, in steps of 64 bits) |
| CKA_SUBPRIME^1,4,6^ | Big integer | Subprime q (160 bits)                           |
| CKA_BASE^1,4,6^     | Big integer | Base g (512 to 1024 bits, in steps of 64 bits)  |
| CKA_VALUE^1,4,6,7^  | Big integer | Private value x                                 |
table 4: KEA Private Key Object Attributes

Refer to [PKCS #11-Base] table 11 for footnotes

The **CKA_PRIME**, **CKA_SUBPRIME** and **CKA_BASE** attribute values are
collectively the “KEA domain parameters”.

Note that when generating a KEA private key, the KEA parameters are not
specified in the key’s template. This is because KEA private keys are only
generated as part of a KEA key pair, and the KEA parameters for the pair are
specified in the template for the KEA public key.

The following is a sample template for creating a KEA private key object:

```c
CK_OBJECT_CLASS class = CKO_PRIVATE_KEY;
CK_KEY_TYPE keyType = CKK_KEA;
CK_UTF8CHAR label[] = “A KEA private key object”;
CK_BYTE subject[] = {…};
CK_BYTE id[] = {123};
CK_BYTE prime[] = {…};
CK_BYTE subprime[] = {…};
CK_BYTE base[] = {…};
CK_BYTE value[] = {…];
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
	{CKA_CLASS, &class, sizeof(class)},
	{CKA_KEY_TYPE, &keyType, sizeof(keyType)},Algorithm, as defined by NISTS
	{CKA_TOKEN, &true, sizeof(true)},
	{CKA_LABEL, label, sizeof(label) -1},
	{CKA_SUBJECT, subject, sizeof(subject)},
	{CKA_ID, id, sizeof(id)},
	{CKA_SENSITIVE, &true, sizeof(true)},
	{CKA_DERIVE, &true, sizeof(true)},
	{CKA_PRIME, prime, sizeof(prime)},
	{CKA_SUBPRIME, subprime, sizeof(subprime)},
	{CKA_BASE, base, sizeof(base)],
	{CKA_VALUE, value, sizeof(value)}
};	
```

### KEA key pair generation

The KEA key pair generation mechanism, denoted **CKM_KEA_KEY_PAIR_GEN**,
generates key pairs for the Key Exchange Algorithm, as defined by NIST’s
“SKIPJACK and KEA Algorithm Specification Version 2.0”, 29 May 1998.

It does not have a parameter.

The mechanism generates KEA public/private key pairs with a particular prime,
subprime and base, as specified in the **CKA_PRIME**, **CKA_SUBPRIME**, and
**CKA_BASE** attributes of the template for the public key. Note that this
version of Cryptoki does not include a mechanism for generating these KEA domain
parameters.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE** and **CKA_VALUE**
attributes to the new public key and the **CKA_CLASS**, **CKA_KEY_TYPE**,
**CKA_PRIME**, **CKA_SUBPRIME**, **CKA_BASE**, and **CKA_VALUE** attributes to
the new private key. Other attributes supported by the KEA public and private
key types (specifically, the flags indicating which functions the keys support)
MAY also be specified in the templates for the keys, or else are assigned
default initial values.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of KEA prime sizes,
in bits.

### KEA key derivation

The KEA key derivation mechanism, denoted **CKM_KEA_DERIVE**, is a mechanism for
key derivation based on KEA, the Key Exchange Algorithm, as defined by NIST’s
“SKIPJACK and KEA Algorithm Specification Version 2.0”, 29 May 1998.

It has a parameter, a **CK_KEA_DERIVE_PARAMS** structure.

This mechanism derives a secret value, and truncates the result according to the
**CKA_KEY_TYPE** attribute of the template and, if it has one and the key type
supports it, the **CKA_VALUE_LEN** attribute of the template. (The truncation
removes bytes from the leading end of the secret value.) The mechanism
contributes the result as the **CKA_VALUE** attribute of the new key; other
attributes required by the key type must be specified in the template.

As defined in the Specification, KEA MAY be used in two different operational
modes: full mode and e-mail mode. Full mode is a two-phase key derivation
sequence that requires real-time parameter exchange between two parties. E-mail
mode is a one-phase key derivation sequence that does not require real-time
parameter exchange. By convention, e-mail mode is designated by use of a fixed
value of one (1) for the KEA parameter R~b~ (_pRandomB_).

The operation of this mechanism depends on two of the values in the supplied
**CK_KEA_DERIVE_PARAMS** structure, as detailed in the table below. Note that in
all cases, the data buffers pointed to by the parameter structure fields
_pRandomA_ and _pRandomB_ must be allocated by the caller prior to invoking
**C_DeriveKey**. Also, the values pointed to by _pRandomA_ and _pRandomB_ are
represented as Cryptoki “Big integer” data (i.e., a sequence of bytes, most
significant byte first).

| **Value of boolean** _isSender_ | **Value of big integer** _pRandomB_ | Token Action (after checking parameter and template values) |
|----------------|-----------------|-------------------------------------------------------------|
| CK_TRUE        | 0               | Compute KEA Ra value, store it in pRandomA, return CKR_OK. No derived key object is created. |
| CK_TRUE        | 1               | Compute KEA Ra value, store it in pRandomA, derive key value using e-mail mode, create key object, return CKR_OK. |
| CK_TRUE        | >1              | Compute KEA Ra value, store it in pRandomA, derive key value using full mode, create key object, return CKR_OK |
| CK_FALSE       | 0               | Compute KEA Rb value, store it in pRandomB, return CKR_OK. No derived key object is created. |
| CK_FALSE       | 1               | Derive key value using e-mail mode, create key object, return CKR_OK. |
| CK_FALSE       | >1              | Derive key value using full mode, create key object, return CKR_OK. |
table 5: KEA Parameter Values and Operations

Note that the parameter value _pRandomB_ == 0 is a flag that the KEA mechanism
is being invoked to compute the party’s public random value (Ra or Rb, for
sender or recipient, respectively), not to derive a key. In these cases, any
object template supplied as the **C_DeriveKey** _pTemplate_ argument should be
ignored.

This mechanism has the following rules about key sensitivity and
extractability^1^:

- The **CKA_SENSITIVE** and **CKA_EXTRACTABLE** attributes in the template for
  the new key MAY both be specified to be either **CK_TRUE** or **CK_FALSE**. If
  omitted, these attributes each take on some default value.
- If the base key has its **CKA_ALWAYS_SENSITIVE** attribute set to
  **CK_FALSE**, then the derived key MUST as well. If the base key has its
  **CKA_ALWAYS_SENSITIVE** attribute set to **CK_TRUE**, then the derived has
  its **CKA_ALWAYS_SENSITIVE** attribute set to the same value as its
  **CKA_SENSITIVE** attribute.
- Similarly, if the base key has its **CKA_NEVER_EXTRACTABLE** attribute set to
  **CK_FALSE**, then the derived key MUST, too. If the base key has its
  **CKA_NEVER_EXTRACTABLE** attribute set to **CK_TRUE**, then the derived key
  has its **CKA_NEVER_EXTRACTABLE** attribute set to the opposite value from its
  **CKA_EXTRACTABLE** attribute.

For this mechanism, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of KEA prime sizes,
in bits.

Note that the rules regarding the **CKA_SENSITIVE**, **CKA_EXTRACTABLE**,
**CKA_ALWAYS_SENSITIVE**, and **CKA_NEVER_EXTRACTABLE** attributes have changed
in version 2.11 to match the policy used by other key derivation mechanisms such
as **CKM_SSL3_MASTER_KEY_DERIVE**.
