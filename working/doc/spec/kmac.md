# KMAC

KMAC is a family of message authentication codes based on KECCAK, as defined
in [NIST SP800-185].

+----------------+---------------------------------------------------------+
|                | Functions                                               |
|                +-----+-----+------+-----+-----+-------+-----+-----+------+
| Mechanism      | ENC | SIG | SIGR | DIG | XOH | GENK  | WRP |     | ENCS |
|                |  &  |  &  |  &   |     |     |   &   |  &  | DRV |  &   |
|                | DEC | VER | VERR |     |     | GENKP | UWRP|     | DECS |
+================+:===:+:===:+:====:+:===:+:===:+:=====:+:===:+:===:+:====:+
| CKM_KMAC128    |     |  ✓  |      |     |  ✓  |       |     |     |      |
+----------------+-----+-----+------+-----+-----+-------+-----+-----+------+
| CKM_KMAC256    |     |  ✓  |      |     |  ✓  |       |     |     |      |
+----------------+-----+-----+------+-----+-----+-------+-----+-----+------+
table: Mechanisms vs. Functions

### Definitions

This section defines the key type **CKK_KMAC** for type `CK_KEY_TYPE` as
used in the `CKA_KEY_TYPE` attribute of key objects.

Mechanisms:

- CKM_KMAC128
- CKM_KMAC256

### KMAC key objects

KMAC key objects (object class **CKO_SECRET_KEY**, key type **CKK_KMAC**)
hold KMAC keys. These are secret keys used for the KMAC mechanism. The
following table defines the KMAC key object attributes, in addition to the
common attributes defined for this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key value (arbitrary length)        |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value        |
table: KMAC Key Object Attributes

- Refer to Table 13 for footnotes

### KMAC Mechanism parameters

**CKM_KMAC128** and **CKM_KMAC256** use the **CK_KMAC_PARAMS** structure.
This structure allows specification of the key, the MAC output length, and
an optional customization string.

#### CK_KMAC_PARAMS
\

~~~{.c}
typedef struct CK_KMAC_PARAMS {
    CK_OBJECT_HANDLE hKey;
    CK_ULONG         ulMacLength;
    CK_VOID_PTR      pCustomizationString;
    CK_ULONG         ulCustomizationStringLen;
} CK_KMAC_PARAMS;
~~~

The fields of the structure are:

_hKey_
: The handle to the key to be used in the KMAC operation. The key
  type must be `CKK_KMAC` or `CKK_GENERIC_SECRET`.

_ulMacLength_
: The desired output length of the MAC, in bytes. This corresponds
  to *L* in [NIST SP 800-185]. If *L* is set to 0 the KMAC function
  will be an arbitrary length output function called "XOF mode" in the
  NIST spec. Implementations are allowed to restrict the values they
  are willing to support for this parameter when it is set non a
  non-zero value. However implementations must support at least values
  between 16 and 256 bytes.

_pCustomizationString_
: A pointer to an optional customization string, *S*.

_ulCustomizationStringLen_
: The length in bytes of the customization string.
  If no customization string is provided, `pCustomizationString` must be
  `NULL_PTR` and `ulCustomizationStringLen` must be 0.

NOTE: Although [NIST SP 800-185] describes all values as bit strings of
arbitrary bit length, this specification restricts inputs and outputs to
byte sized lengths.

### KMAC Usage

The KMAC mechanisms, **CKM_KMAC128** and **CKM_KMAC256**, are used with the
Extensible Output Digesting Functions (**C_DigestXofInit**,
**C_DigestXofUpdate**, **C_DigestXofExtract**, and **C_DigestXofFinal**). The
`C_Sign` and `C_Verify` functions can also be used. They are based on [NIST SP
800-185]. These mechanisms are instances of the KMAC algorithm built on top of
cSHAKE.

**CKM_KMAC128** is KMAC with a 128-bit security strength.
**CKM_KMAC256** is KMAC with a 256-bit security strength.

Both mechanisms have a parameter, a **CK_KMAC_PARAMS** structure, which
specifies the key to use, the output length desired from the mechanism, and
an optional customization string.

Constraints on key types and the length of data are summarized in the
following table:

| Function        | Key type                        | Data length | Output length                       |
|-----------------|---------------------------------|-------------|-------------------------------------|
| C_DigestXof...  | CKK_KMAC, CKK_GENERIC_SECRET    | any         | ulMacLength or arbitrary if it is 0 |
| C_Sign...       | CKK_KMAC, CKK_GENERIC_SECRET    | any         | ulMacLength (must not be 0)         |
| C_Verify...     | CKK_KMAC, CKK_GENERIC_SECRET    | any         | ulMacLength (must not be 0)         |
table: KMAC: Key And Data Length

The key type must be `CKK_KMAC` or `CKK_GENERIC_SECRET`. The key can be of
arbitrary length, however it is recommended that the size of the key matches
the security strength of the mechanism it is used with. For **CKM_KMAC128**,
the key length should be at least 128 bits. For **CKM_KMAC256**, the key
length should be at least 256 bits.

When `ulMacLength` is set to 0 with the `C_DigestXof` functions, the mechanism
is in "XOF mode" and the output length is determined by the `ulOutputLen`
argument of `C_DigestXofExtract` and `C_DigestXofFinal`. When `ulMacLength` is
non-zero, the total output length from all calls to `C_DigestXofExtract` and
`C_DigestXofFinal` must equal `ulMacLength`.

For `C_Sign` and `C_Verify` functions, Extensible Output is not supported and
`ulMacLength` must not be zero. The size of the output signature for C_Sign
is determined by the ulMacLength, and for C_Verify the input signature length
must match ulMaxLength.

For these mechanisms, the _ulMinKeySize_ and _ulMaxKeySize_ fields of the
**CK_MECHANISM_INFO** structure specify the supported range of KMAC key
sizes, in bytes.

