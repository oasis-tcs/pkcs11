## IKE Mechanisms

+--------------------------------------+---------------------------------------------------+
|                                      | Functions                                         |
|                                      +-----+-----+------+-----+-------+-----+-----+------+
| Mechanism                            | ENC | SIG | SIGR |     | GENK  | WRP |     | ENCS |
|                                      |  &  |  &  |  &   | DIG |   &   |  &  | DRV |  &   |
|                                      | DEC | VER | VERR |     | GENKP | UWRP|     | DECS |
+======================================+:===:+:===:+:====:+:===:+:=====:+:===:+:===:+:====:+
| CKM_IKE2_PRF_PLUS_DERIVE             |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_IKE_PRF_DERIVE                   |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_IKE1_PRF_DERIVE                  |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
| CKM_IKE1_EXTENDED_DERIVE             |     |     |      |     |       |     |  ✓  |      |
+--------------------------------------+-----+-----+------+-----+-------+-----+-----+------+
table: IKE Mechanisms vs. Functions

### Definitions

Mechanisms:

- CKM_IKE2_PRF_PLUS_DERIVE
- CKM_IKE_PRF_DERIVE
- CKM_IKE1_PRF_DERIVE
- CKM_IKE1_EXTENDED_DERIVE

### IKE mechanism parameters

#### CK_IKE2_PRF_PLUS_DERIVE_PARAMS
\  

**CK_IKE2_PRF_PLUS_DERIVE_PARAMS** is a structure that provides the parameters
to the **CKM_IKE2_PRF_PLUS_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_IKE2_PRF_PLUS_DERIVE_PARAMS {
    CK_MECHANISM_TYPE  prfMechanism;
    CK_BBOOL  bHasSeedKey;
    CK_OBJECT_HANDLE  hSeedKey;
    CK_BYTE_PTR  pSeedData;
    CK_ULONG  ulSeedDataLen;
} CK_IKE2_PRF_PLUS_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfMechanism_
: underlying MAC mechanism used to generate the prf

_bHasSeedKey_
: hSeed key is present

_hSeedKey_
: optional seed from key

_pSeedData_
: optional seed from data

_ulSeedDataLen_
: length of optional seed data. If no seed data is present this value is 0

**CK_IKE2_PRF_PLUS_DERIVE_PARAMS_PTR** is a pointer to a
**CK_IKE2_PRF_PLUS_DERIVE_PARAMS**.

#### CK_IKE_PRF_DERIVE_PARAMS
\  

**CK_IKE_PRF_DERIVE_PARAMS** is a structure that provides the parameters to the
**CKM_IKE_PRF_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_IKE_PRF_DERIVE_PARAMS {
    CK_MECHANISM_TYPE  prfMechanism;
    CK_BBOOL  bDataAsKey;
    CK_BBOOL  bRekey;
    CK_BYTE_PTR  pNi;
    CK_ULONG  ulNiLen;
    CK_BYTE_PTR  pNr;
    CK_ULONG  ulNrLen;
    CK_OBJECT_HANDLE  hNewKey;
 } CK_IKE_PRF_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfMechanism_
: underlying MAC mechanism used to generate the prf

_bDataAsKey_
: Ni||Nr is used as the key for the prf rather than baseKey

_bRekey_
: rekey operation. hNewKey must be present

_pNi_
: Ni value

_ulNiLen_
: length of Ni

_pNr_
: Nr value

_ulNrLen_
: length of Nr 

_hNewKey_
: New key value to drive the rekey.

**CK_IKE_PRF_DERIVE_PARAMS_PTR** is a pointer to a **CK_IKE_PRF_DERIVE_PARAMS**.

#### CK_IKE1_PRF_DERIVE_PARAMS
\  

**CK_IKE1_PRF_DERIVE_PARAMS** is a structure that provides the parameters to the
**CKM_IKE1_PRF_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_IKE1_PRF_DERIVE_PARAMS {
    CK_MECHANISM_TYPE  prfMechanism;
    CK_BBOOL  bHasPrevKey;
    CK_OBJECT_HANDLE  hKeygxy;
    CK_OBJECT_HANDLE  hPrevKey;
    CK_BYTE_PTR  pCKYi;
    CK_ULONG  ulCKYiLen;
    CK_BYTE_PTR  pCKYr;
    CK_ULONG  ulCKYrLen;
    CK_BYTE  keyNumber;
 } CK_IKE1_PRF_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfMechanism_
: underlying MAC mechanism used to generate the prf

_bHasPrevkey_
: hPrevKey is present

_hKeygxy_
: handle to the exchanged g^xy key

_hPrevKey_
: handle to the previously derived key

_pCKYi_
: CKYi value

_ulCKYiLen_
: length of CKYi

_pCKYr_
: CKYr value

_ulCKYrLen_
: length of CKYr 

_keyNumber_
: unique number for this key derivation

**CK_IKE1_PRF_DERIVE_PARAMS_PTR** is a pointer to a
**CK_IKE1_PRF_DERIVE_PARAMS**.

#### CK_IKE1_EXTENDED_DERIVE_PARAMS
\  

**CK_IKE1_EXTENDED_DERIVE_PARAMS** is a structure that provides the parameters
to the **CKM_IKE1_EXTENDED_DERIVE** mechanism. It is defined as follows:

~~~{.c}
typedef struct CK_IKE1_EXTENDED_DERIVE_PARAMS {
    CK_MECHANISM_TYPE  prfMechanism;
    CK_BBOOL  bHasKeygxy;
    CK_OBJECT_HANDLE  hKeygxy;
    CK_BYTE_PTR  pExtraData;
    CK_ULONG  ulExtraDataLen;
} CK_IKE1_EXTENDED_DERIVE_PARAMS;
~~~

The fields of the structure have the following meanings:

_prfMechanism_
: underlying MAC mechanism used to generate the prf

_bHasKeygxy_
: 	hKeygxy key is present

_hKeygxy_
: optional key g^xy

_pExtraData_
: 	optional extra data

_ulExtraDataLen_
: length of optional extra data. If no extra data is present this value is 0

**CK_IKE2_PRF_PLUS_DERIVE_PARAMS_PTR** is a pointer to a
**CK_IKE2_PRF_PLUS_DERIVE_PARAMS**.

### IKE PRF DERIVE

The IKE PRF Derive mechanism denoted **CKM_IKE_PRF_DERIVE** is used in IPSEC
both IKEv1 and IKEv2 to generate an initial key that is used to generate
additional keys. It takes a **CK_IKE_PRF_DERIVE_PARAMS** as a mechanism
parameter. baseKey is the base key passed into **C_DeriveKey**. baseKey must be
of type **CKK_GENERIC_SECRET** if bDataAsKey is TRUE and the key type of the
underlying prf if bDataAsKey is FALSE. hNewKey must be of type
**CKK_GENERIC_SECRET**. Depending on the parameter settings, it generates keys
with a **CKA_VALUE** of:

1. prf(pNi|pNr, baseKey); (bDataAsKey=TRUE, bRekey=FALSE)
2. prf(baseKey, pNi|pNr); (bDataAsKkey=FALSE, bRekey=FALSE)
3. prf(baseKey, ValueOf(hNewKey)| pNi | pNr); (bDataAsKey=FALSE, bRekey=TRUE)

The resulting output key is always the length of the underlying prf. The
combination of bDataAsKey=TRUE and bRekey=TRUE is not allowed. If both are set,
**CKR_ARGUMENTS_BAD** is returned.

Case 1 is used in

a. ikev2 ([RFC 5996]) baseKey is called g^ir, the output is called SKEYSEED
b. ikev1 ([RFC 2409]) baseKey is called g^ir, the output is called SKEYID

Case 2 is used in ikev1 ([RFC 2409]) inkey is called pre-shared-key, output is called SKEYID

Case 3 is used in ikev2 ([RFC 5996]) rekey case, baseKey is SK_d, hNewKey is
g^ir (new), the output is called SKEYSEED. The derived key will have a length of
the length of the underlying prf. If **CKA_VALUE_LEN** is specified, it must
equal the underlying prf or **CKR_KEY_SIZE_RANGE** is returned. If
**CKA_KEY_TYPE** is not specified in the template, it will be the underlying key
type of the prf.

### IKEv1 PRF DERIVE

The IKEv1 PRF Derive mechanism denoted **CKM_IKE1_PRF_DERIVE** is used in IPSEC
IKEv1 to generate various additional keys from the initial SKEYID. It takes a
**CK_IKE1_PRF_DERIVE_PARAMS** as a mechanism parameter. SKEYID is the base key
passed into **C_DeriveKey**. 

This mechanism derives a key with **CKA_VALUE** set to either:

~~~
prf(baseKey, ValueOf(hKeygxy) || pCKYi || pCKYr || key_number)
~~~

or

~~~
prf(baseKey, ValueOf(hPrevKey) || ValueOf(hKeygxy) || pCKYi || pCKYr || key_number)
~~~

depending on the state of bHasPrevKey.

The key type of baseKey must be the key type of the prf, and the key type of
hKeygxy must be **CKK_GENERIC_SECRET**. The key type of hPrevKey can be any key
type.
 
This is defined in [RFC 2409]. For each of the following keys.

~~~
baseKey is  SKEYID,    hKeygxy is g^xy
for outKey = SKEYID_d, bHasPrevKey = false, key_number = 0
for outKey = SKEYID_a, hPrevKey= SKEYID_d,   key_number = 1
for outKey = SKEYID_e, hPrevKey= SKEYID_a,   key_number = 2
~~~

If **CKA_VALUE_LEN** is not specified, the resulting key will be the length of
the prf. If **CKA_VALUE_LEN** is greater then the prf, **CKR_KEY_SIZE_RANGE** is
returned. If it is less the key is truncated taking the left most bytes. The
value **CKA_KEY_TYPE** must be specified in the template or
**CKR_TEMPLATE_INCOMPLETE** is returned.

### IKEv2 PRF PLUS DERIVE

The IKEv2 PRF PLUS Derive mechanism denoted **CKM_IKE2_PRF_PLUS_DERIVE** is used
in IPSEC IKEv2 to derive various additional keys from the initial SKEYSEED. It
takes a **CK_IKE2_PRF_PLUS_DERIVE_PARAMS** as a mechanism parameter. SKEYSEED is
the base key passed into **C_DeriveKey**. The key type of baseKey must be the
key type of the underlying prf. This mechanism uses the base key and a feedback
version of the prf to generate a single key with sufficient bytes to cover all
additional keys. The application will then use **CKM_EXTRACT_KEY_FROM_KEY**
several times to pull out the various keys. **CKA_VALUE_LEN** must be set in the
template and its value must not be bigger than 255 times the size of the prf
function output or **CKR_KEY_SIZE_RANGE** will be returned. If **CKA_KEY_TYPE**
is not specified, the output key type will be **CKK_GENERIC_SECRET**.

This mechanism derives a key with a **CKA_VALUE** of (from [RFC 5996]):

~~~ 
prfplus = T1 | T2 | T3 | T4 |... Tn
 where:
     T1 = prf(K, S  | 0x01)
     T2 = prf(K, T1 | S | 0x02)
     T3 = prf(K, T3 | S | 0x03)
     T4 = prf(K, T4 | S | 0x04)
          .
     Tn = prf(K, T(n-1) | n)
     K = baseKey, S = valueOf(hSeedKey) | pSeedData
~~~

### IKEv1 Extended Derive


The IKE Extended Derive mechanism denoted **CKM_IKE1_EXTENDED_DERIVE** is used
in IPSEC IKEv1 to derive longer keys than **CKM_IKE1_EXTENDED_DERIVE** can from
the initial SKEYID. It is used to support [RFC 2409] appendix B and section 5.5
(Quick Mode). It takes a **CK_IKE1_EXTENDED_DERIVE_PARAMS** as a mechanism
parameter. SKEYID is the base key passed into **C_DeriveKey**. **CKA_VALUE_LEN**
must be set in the template and its value must not be bigger than 255 times the
size of the prf function output or **CKR_KEY_SIZE_RANGE** will be returned. If
**CKA_KEY_TYPE** is not specified, the output key type will be
**CKK_GENERIC_SECRET**. The key type of SKEYID must be the key type of the prf,
and the key type of hKeygxy (if present) must be **CKK_GENERIC_SECRET**.

This mechanism derives a key with **CKA_VALUE** (from [RFC 2409] appendix B and
section 5.5):

~~~
 Ka = K1 | K2 | K3 | K4 |... Kn
 where:
       K1 = prf(K, valueOf(hKeygxy)|pExtraData)
          or
            prf(K,0x00) if bHashKeygxy is FALSE and ulExtraData is 0
       K2 = prf(K, K1|valueOf(hKeygxy)|pExtraData)
       K3 = prf(K, K2|valueOf(hKeygxy)|pExtraData)
       K4 = prf(K, K3|valueOf(hKeygxy)|pExtraData)
            .
       Kn = prf(K, K(n-1)|valueOf(hKeygxy)|pExtraData)
       K = baseKey
~~~

If **CKA_VALUE_LEN** is less then or equal to the prf length and bHasKeygxy is
**CK_FALSE**, then the new key is simply the base key truncated to
**CKA_VALUE_LEN** (specified in RFC 2409 appendix B). Otherwise the prf is
executed and the derived keys value is **CKA_VALUE_LEN** bytes of the resulting
prf.
