## SET

### Definitions

Mechanisms:

- CKM_KEY_WRAP_SET_OAEP

### SET mechanism parameters

#### CK_KEY_WRAP_SET_OAEP_PARAMS; CK_KEY_WRAP_SET_OAEP_PARAMS_PTR
\

**CK_KEY_WRAP_SET_OAEP_PARAMS** is a structure that provides the parameters to
the **CKM_KEY_WRAP_SET_OAEP** mechanism.  It is defined as follows:

```c
typedef struct CK_KEY_WRAP_SET_OAEP_PARAMS {
	CK_BYTE bBC;
	CK_BYTE_PTR pX;
	CK_ULONG ulXLen;
} CK_KEY_WRAP_SET_OAEP_PARAMS;
```

The fields of the structure have the following meanings:

_bBC_
: block contents byte

_pX_
: concatenation of hash of plaintext data (if present) and extra data (if
  present)

_ulXLen_
: length in bytes of concatenation of hash of plaintext data (if present) and
  extra data (if present).  0 if neither is present.

**CK_KEY_WRAP_SET_OAEP_PARAMS_PTR** is a pointer to a
**CK_KEY_WRAP_SET_OAEP_PARAMS**.

### OAEP key wrapping for SET

The OAEP key wrapping for SET mechanism, denoted **CKM_KEY_WRAP_SET_OAEP**, is a
mechanism for wrapping and unwrapping a DES key with an RSA key.  The hash of
some plaintext data and/or some extra data MAY be wrapped together with the DES
key.  This mechanism is defined in the SET protocol specifications.

It takes a parameter, a **CK_KEY_WRAP_SET_OAEP_PARAMS** structure.  This
structure holds the “Block Contents” byte of the data and the concatenation of
the hash of plaintext data (if present) and the extra data to be wrapped (if
present).  If neither the hash nor the extra data is present, this is indicated
by the _ulXLen_ field having the value 0.

When this mechanism is used to unwrap a key, the concatenation of the hash of
plaintext data (if present) and the extra data (if present) is returned
following the convention described [PKCS #11-Curr], Miscellaneous simple key
derivation mechanisms.  Note that if the inputs to **C_UnwrapKey** are such that
the extra data is not returned (e.g. the buffer supplied in the
**CK_KEY_WRAP_SET_OAEP_PARAMS** structure is NULL_PTR), then the unwrapped key
object MUST NOT be created, either.

Be aware that when this mechanism is used to unwrap a key, the _bBC_ and _pX_
fields of the parameter supplied to the mechanism MAY be modified.

If an application uses **C_UnwrapKey** with **CKM_KEY_WRAP_SET_OAEP**, it may be
preferable for it simply to allocate a 128-byte buffer for the concatenation of
the hash of plaintext data and the extra data (this concatenation  MUST NOT be
larger than 128 bytes), rather than calling **C_UnwrapKey** twice.  Each call of
**C_UnwrapKey** with **CKM_KEY_WRAP_SET_OAEP** requires an RSA decryption
operation to be performed, and this computational overhead MAY be avoided by
this means.
