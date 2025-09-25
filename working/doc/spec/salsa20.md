## Salsa20

Salsa20 is a secret-key stream cipher described in [SALSA].

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_SALSA20_KEY_GEN                  |     |     |      |     |   ✓   |     |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_SALSA20                          |  ✓  |     |      |     |       |  ✓  |     |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: Salsa20 Mechanisms vs. Functions

### Definitions

This section defines the key type “**CKK_SALSA20**” and “**CKK_SALSA20**” for
type **CK_KEY_TYPE** as used in the **CKA_KEY_TYPE** attribute of key objects.

Mechanisms:
- CKM_SALSA20_KEY_GEN
- CKM_SALSA20

### Salsa20 secret key objects

Salsa20 secret key objects (object class **CKO_SECRET_KEY**, key type
**CKK_SALSA20**) hold Salsa20 keys. The following table defines the Salsa20
secret key object attributes, in addition to the common attributes defined for
this object class:

| Attribute           | Data type  | Meaning                                 |
|---------------------|------------|-----------------------------------------|
| CKA_VALUE ^1,4,6,7^ | Byte array | Key length is fixed at 256 bits. Bit length restricted to a byte array. |
| CKA_VALUE_LEN ^2,3^ | CK_ULONG   | Length in bytes of key value            |
table: ChaCha20 Secret Key Object

The following is a sample template for creating a Salsa20 secret key object:

~~~{.c}
CK_OBJECT_CLASS class = CKO_SECRET_KEY;
CK_KEY_TYPE keyType = CKK_SALSA20;
CK_UTF8CHAR label[] = “A Salsa20 secret key object”;
CK_BYTE value[32] = {...};
CK_BBOOL true = CK_TRUE;
CK_ATTRIBUTE template[] = {
  {CKA_CLASS, &class, sizeof(class)},
  {CKA_KEY_TYPE, &keyType, sizeof(keyType)},
  {CKA_TOKEN, &true, sizeof(true)},
  {CKA_LABEL, label, sizeof(label)-1},
  {CKA_ENCRYPT, &true, sizeof(true)},
  {CKA_VALUE, value, sizeof(value)}
};
~~~

**CKA_CHECK_VALUE**: The value of this attribute is derived from the key object
by taking the first three bytes of the SHA-1 hash of the ChaCha20 secret key
object’s **CKA_VALUE** attribute.

### Salsa20 mechanism parameters

#### CK_SALSA20_PARAMS
\  

**CK_SALSA20_PARAMS** provides the parameters to the **CKM_SALSA20** mechanism.
It is defined as follows:

~~~{.c}
typedef struct CK_SALSA20_PARAMS {
	CK_BYTE_PTR	pBlockCounter;
	CK_BYTE_PTR	pNonce;
	CK_ULONG	ulNonceBits;
} CK_SALSA20_PARAMS;
~~~

The fields of the structure have the following meanings:

_pBlockCounter_
: pointer to block counter (64 bits)

_pNonce_
: nonce 

_ulNonceBits_
: size of the nonce in bits (64 for classic and 192 for XSalsa20)

The block counter is used to address 512 bit blocks in the stream. In certain
settings (e.g. disk encryption) it is necessary to address these blocks in
random order, thus this counter is exposed here.

**CK_SALSA20_PARAMS_PTR** is a pointer to **CK_SALSA20_PARAMS**.

### Salsa20 key generation

The Salsa20 key generation mechanism, denoted **CKM_SALSA20_KEY_GEN**, is a key
generation mechanism for Salsa20.

It does not have a parameter.

The mechanism generates Salsa20 keys of 256 bits.

The mechanism contributes the **CKA_CLASS**, **CKA_KEY_TYPE**, and **CKA_VALUE**
attributes to the new key. Other attributes supported by the key type
(specifically, the flags indicating which functions the key supports) may be
specified in the template for the key, or else are assigned default initial
values.

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of key sizes in
bytes. As a practical matter, the key size for Salsa20 is fixed at 256 bits.

### Salsa20 mechanism

Salsa20, denoted **CKM_SALSA20**, is a mechanism for single and multiple-part
encryption and decryption based on the Salsa20 stream cipher. Salsa20 comes in
two variants which only differ in the size and handling of their nonces,
affecting the safety of using random nonces.

Salsa20 has a parameter, **CK_SALSA20_PARAMS**, which indicates the nonce and
initial block counter value.

Constraints on key types and the length of input and output data are summarized
in the following table:

| Function  | Key type    | Input length | Output length | Comments       |
|-----------|-------------|--------------|---------------|----------------|
| C_Encrypt | CKK_SALSA20 | Any   | Same as input length | No final part  |
| C_Decrypt | CKK_SALSA20 | Any   | Same as input length | No final part  |
table: Salsa20: Key and Data Length

For this mechanism, the ulMinKeySize and ulMaxKeySize fields of the
**CK_MECHANISM_INFO** structure specify the supported range of ChaCha20 key
sizes, in bits.

| Variant  | Nonce   | Maximum message     | Nonce generation              |
|----------|---------|---------------------|-------------------------------|
| original | 64 bit  | Virtually unlimited | 1^st^ msg: nonce~0~=random    |
|          |         |                     | n^th^ msg: nonce~n-1~++       |
| XSalsa20 | 192 bit | Virtually unlimited | Each nonce can be randomly generated. |
table: Salsa20: Nonce sizes

Nonces must not ever be reused with the same key. However due to the birthday
paradox the original variant cannot guarantee that randomly generated nonces are
never repeating. Thus the recommended way to handle this is to generate the
first nonce randomly, then increase this for follow-up messages. Only the
XSalsa20 has large enough nonces so that it is virtually impossible to trigger
with randomly generated nonces the birthday paradox. 
