# Base Profiles

The following subsections describe currently-defined profiles related to the use
of PKCS #11. The profiles define classes of PKCS #11 functionality to which an
implementation can declare conformance.

## Baseline Provider

A PKCS #11 provider makes cryptographic functionality available to a consuming
application in terms of the PKCS #11 API.

This profile specifies the most basic functionality that would be expected of a
conformant PKCS #11 provider – the ability to provide information about the
capabilities of the cryptographic services provided.

An implementation conforms to this specification as a Baseline Provider if it
meets the following conditions:

1. Supports the conditions required by the PKCS#11 Provider Implementation
   Conformance clauses [PKCS11_Spec]
2. Supports the following data types [PKCS11_Spec]:
   a. _CK_VERSION_
   b. _CK_INFO_
   c. _CK_SLOT_ID_
   d. _CK_SLOT_INFO_
   e. _CK_TOKEN_INFO_
   f. _CK_SESSION_HANDLE_
   g. _CK_USER_TYPE_
   h. _CK_SESSION_INFO_
   i. _CK_OBJECT_HANDLE_
   j. _CK_OBJECT_CLASS_
   k. _CK_ATTRIBUTE_TYPE_
   l. _CK_ATTRIBUTE_
   m. _CK_PROFILE_ID_
   n. _CK_RV_
   o. _CK_FUNCTION_LIST_
   p. _CK_INTERFACE_
   q. _CK_C_INITIALIZE_ARGS_
3. Supports the following attributes [PKCS11_Spec]:
   a. _CKA_CLASS_
   b. _CKA_TOKEN_
   c. _CKA_VALUE _
   d. _CKA_ID_
   e. _CKA_PRIVATE_
   f. _CKA_MODIFIABLE_
   g. _CKA_LABEL_
   h. _CKA_UNIQUE_IDENTIFIER_
   i. _CKA_PROFILE_ID_
4. Supports the following objects [PKCS11_Spec]:
   a. _CKO_PROFILE_ with value _CKP_BASELINE_PROVIDER_
5. Supports the following functions [PKCS11_Spec]:
   a. _C_GetFunctionList_
   b. _C_GetInterfaceList_
   c. _C_GetInterface_
   d. _C_Initialize_
   e. _C_Finalize_
   f. _C_GetInfo_
   g. _C_GetSlotList_
   h. _C_GetSlotInfo_
   i. _C_GetTokenInfo_
   j. _C_OpenSession_
   k. _C_CloseSession_
   l. _C_GetSessionInfo _
   m. _C_FindObjectsInit_
   n. _C_FindObjects_
   o. _C_FindObjectsFinal_
   p. _C_GetAttributeValue_
6. Supports the following mechanisms:
   a. None specified
7. Supports _Error Handling_ [PKCS11_Spec] for any supported object, function or
   mechanism
8. Optionally supports any clause within [PKCS11_Spec] that is not listed above
9. Optionally supports extensions outside the scope of this standard (e.g.,
   vendor defined extensions, conformance clauses) that do not contradict any
   PKCS #11 requirements

### Baseline Provider Mandatory Test Cases

#### BL-M-1-32

See `test-cases/pkcs11-v3.2/mandatory/BL-M-1-32.xml`

## Complete Provider

A PKCS #11 provider makes cryptographic functionality available to a consuming
application in terms of the PKCS #11 API.

This profile specifies the functionality that would be expected of a conformant
PKCS #11 provider that implements the entire specification.

An implementation conforms to this specification as a Complete Provider if it
meets the following conditions:

1. Supports the conditions required by the _PKCS#11 Provider Implementation
   Conformance_ clauses [PKCS11_Spec]
2. Supports all data types [PKCS11_Spec]
3. Supports all attributes [PKCS11_Spec]
4. Supports all objects [PKCS11_Spec]
5. Supports all functions [PKCS11_Spec]
6. Supports all mechanisms [PKCS11_Spec] Section 6
7. Supports Error Handling [PKCS11_Spec]
8. Optionally supports extensions outside the scope of this standard (e.g.,
   vendor defined extensions, conformance clauses) that do not contradict any
   PKCS #11 requirements

## Extended Provider

This profile builds on the PKCS#11 Baseline Provider to add support for
mechanism-based usage.

An implementation conforms to this specification as an Extended Provider if it
meets the following conditions:

1. Supports the conditions required by the PKCS #11 conformance clauses
   ([PKCS11_Spec] Section 7 (PKCS#11 Implementation Conformance)
2. Supports the conditions required by the PKCS #11 Baseline Provider clauses
   section 5.1.
3. Supports the following data types [PKCS11_Spec]:
   a. _CK_MECHANISM_TYPE_
   b. _CK_MECHANISM_
4. Supports the following attributes [PKCS11_Spec]:
   a. _None specified_
5. Supports the following objects [PKCS11_Spec]:
   a. _CKO_PROFILE_ with value _CKP_EXTENDED_PROVIDER_
6. Supports the following functions [PKCS11_Spec]:
   a. _C_GetMechanismList_
   b. _C_GetMechanismInfo_
   c. _C_Login_
   d. _C_LoginUser_
   e. _C_Logout_
7. Supports the following mechanisms:
   a. None specified 
8. Supports _Error Handling_ [PKCS11_Spec] for any supported object, function or
   mechanism
9. Optionally supports any clause within [PKCS11_Spec] that is not listed above
10. Optionally supports extensions outside the scope of this standard (e.g.,
    vendor defined extensions, conformance clauses) that do not contradict any
    PKCS #11 requirements

### Extended Provider Mandatory Test Cases

#### EXT-M-1-32

See `test-cases/pkcs11-v3.2/mandatory/EXT-M-1-32.xml`

## Authentication Token

This profile builds on the PKCS #11 Baseline Provider and/or Baseline Consumer
profiles to provide for use in the context of an authentication token.

An implementation conforms to this specification as an Authentication Token if it
meets the following conditions:

1. If the implementation is a consumer then it SHALL support the conditions
   required by the PKCS #11 Baseline Consumer Clause (Section 5.7)
2. If the implementation is a provider then it SHALL support the conditions
   required by the PKCS #11 Baseline Provider Clause (Section 5.1)
3. Supports the following data types [PKCS11_Spec]:
   a. None specified
4. Supports the following attributes [PKCS11_Spec]:
   a. None specified
5. Supports the following objects [PKCS11_Spec]:
   a. _CKO_PRIVATE_KEY_
   b. _CKO_PUBLIC_KEY_
   c. _CKO_PROFILE_ with value _CKP_AUTHENTICATION_TOKEN_
6. Supports the following functions [PKCS11_Spec]:
   a. _C_Login_
   b. _C_LoginUser_
   c. _C_Logout_
   d. _C_SignInit_
   e. _C_Sign_ and/or _C_SignUpdate_ and _C_SignFinal_
7. Supports the following mechanisms:
   a. None specified
8. Supports _Error Handling_ [PKCS11_Spec] for any supported object, function or
   mechanism
9. Optionally supports any clause within [PKCS11_Spec] that is not listed above
10. Optionally supports extensions outside the scope of this standard (e.g.,
    vendor defined extensions, conformance clauses) that do not contradict any
    PKCS #11 requirements.

### Authentication Token Provider Mandatory Test Cases

#### AUTH-M-1-32

See `test-cases/pkcs11-v3.2/mandatory/AUTH-M-1-32.xml`

## Public Certificates Token

This profile builds on the PKCS #11 Baseline Provider and/or Baseline Consumer
profiles to provide for use in the context of a public certificates token.

An implementation conforms to this specification as a Public Certificates Token
if it meets the following conditions:

1. If the implementation is a consumer then it SHALL support the conditions
   required by the PKCS #11 Baseline Consumer Clause (Section 5.7)
2. If the implementation is a provider then it SHALL support the conditions
   required by the PKCS #11 Baseline Provider Clause (Section 5.1)
3. Supports the following data types [PKCS11_Spec]:
   a. None specified
4. Supports the following attributes [PKCS11_Spec]:
   a. None specified
5. Supports the following objects [PKCS11_Spec]:
   a. _CKO_CERTIFICATE_
   b. _CKO_PROFILE_ with value _CKP_PUBLIC_CERTIFICATES_TOKEN_
6. Supports the following functions [PKCS11_Spec]:
   a. None specified
7. Supports the following mechanisms [PKCS11_Spec]:
   a. None specified
8. Supports the following object location requirements:
   a. All certificates are publicly readable, able to be found on the token
      without a login having been performed
   b. All certificates for which a matching private key also exists on the token
      must have a matching _CKA_ID_ attribute for the certificate and private
      key
   c. One or more of the following conditions must be met:
      i.  The matching private key for a certificate can be found via
          _C_FindObjects_ using the matching _CKA_ID_ value without a login
          having been performed;
      ii. The matching public key for a certificate can be found via
          _C_FindObjects_ using the matching _CKA_ID_ value without a login
          having been performed
9. Supports _Error Handling_ [PKCS11_Spec] for any supported object, function or
   mechanism
10. Optionally supports any clause within [PKCS11_Spec] that is not listed above
11. Optionally supports extensions outside the scope of this standard (e.g.,
    vendor defined extensions, conformance clauses) that do not contradict any
    PKCS #11 requirements. 

### Public Certificates Token Provider Mandatory Test Cases

#### CERT-M-1-32

See `test-cases/pkcs11-v3.2/mandatory/CERT-M-1-32.xml`

## HKDF TLS Token

This profile builds on the PKCS #11 Baseline Provider and/or Baseline Consumer
profiles to provide for use in the context of TLS 1.3 connections using the
CKM_HKDF_DERIVE_DATA mechanism.

An implementation conforms to this specification as an HKDF TLS Token if it
meets the following conditions:

1. If the implementation is a consumer then it SHALL support the conditions
   required by the PKCS #11 Baseline Consumer Clause (Section 5.7)
2. If the implementation is a provider then it SHALL support the conditions
   required by the PKCS #11 Baseline Provider Clause (Section 5.1)
3. Supports the following data types [PKCS11_Spec]:
   b. _CK_HKDF_PARAMS_
4. Supports the following attributes [PKCS11_Spec]:
   a. _None specified_
5. Supports the following objects [PKCS11_Spec]:
   a. _CKO_DATA_
   b. _CKO_SECRET_KEY_
   c. _CKO_PROFILE_ with value _CKP_HKDF_TLS_TOKEN_
6. Supports the following functions [PKCS11_Spec]:
   a. _C_DeriveKey_
7. Supports the following mechanisms:
   a. _CKM_HKDF_DATA_

      A conformant provider SHALL not reject derive requests based on the pInfo
      value if the following pInfo values are given:

      i. The string L1,L2,"tls iv",0 (L1, L2, 0x74, 0x6c, 0x73, 0x20, 0x69,
         0x76, 0x00) where L1 is the most significant byte of CKA_VALUE_LEN and
         L2 is the least significant byte of CKA_VALUE_LEN.
      ii. The string L1,L2,"tls quic iv",0 (L1, L2, 0x74, 0x6c, 0x73, 0x20,
          0x71, 0x75, 0x69, 0x63, 0x20, 0x69, 0x76, 0x00) where L1 is the most
          significant byte of CKA_VALUE_LEN and L2 is the least significant byte
          of CKA_VALUE_LEN.

      A conformant provider MAY accept other values for pInfo.

8. Supports Error Handling [PKCS11_Spec] for any supported object, function or
   mechanism
9. Optionally supports any clause within [PKCS11_Spec] that is not listed above
10. Optionally supports extensions outside the scope of this standard (e.g.,
    vendor defined extensions, conformance clauses) that do not contradict any
    PKCS #11 requirements.

## Baseline Consumer 

A PKCS #11 consumer calls a PKCS #11 provider implementation of the PKCS #11 API
in order to use the cryptographic functionality from that provider.

This profile specifies the most basic functionality that would be expected of a
conformant PKCS #11 consumer – the ability to consume information via the
cryptographic services offered by a provider.

An implementation conforms to this specification as a Baseline Consumer if it
meets the following conditions:

1. Supports the conditions required by the PKCS#11 Consumer Implementation
   Conformance clauses [PKCS11_Spec]
2. Supports the following data types [PKCS11_Spec]:
   a. _CK_VERSION_
   b. _CK_INFO_
   c. _CK_SLOT_ID_
   d. _CK_SLOT_INFO_
   e. _CK_TOKEN_INFO_
   f. _CK_SESSION_HANDLE_
   g. _CK_USER_TYPE_
   h. _CK_SESSION_INFO_
   i. _CK_OBJECT_HANDLE_
   j. _CK_OBJECT_CLASS_
   k. _CK_ATTRIBUTE_TYPE_
   l. _CK_ATTRIBUTE_
   m. _CK_RV_
   n. _CK_FUNCTION_LIST_
   o. _CK_C_INITIALIZE_ARGS_
   p. _CK_INTERFACE (if C_GetInterfaceList and C_GetInterface is supported)_
3. Supports the following attributes [PKCS11_Spec]:
   a. _CKA_CLASS_
   b. _CKA_VALUE_
4. Supports the following objects:
   a. None specified
5. Supports the following functions [PKCS11_Spec]:
   a. _C_GetFunctionList_ or _C_GetInterfaceList_ and _C_GetInterface _
   b. _C_Initialize_
   c. _C_Finalize_
   d. _C_GetInfo_
   e. _C_GetSlotList_
   f. _C_GetSlotInfo_
   g. _C_GetTokenInfo_
   h. _C_OpenSession_
   i. _C_CloseSession_
6. Supports the following mechanisms:
   a. None specified
7. Supports _Error Handling_ [PKCS11_Spec] for any supported object, function or
   mechanism
8. Optionally supports any clause within [PKCS11_Spec] that is not listed above
9. Optionally supports extensions outside the scope of this standard (e.g.,
   vendor defined extensions, conformance clauses) that do not contradict any
   PKCS #11 requirements

## Extended Consumer

This profile builds on the PKCS#11 Baseline Consumer profile to add support for
mechanism-based usage.

An implementation conforms to this specification as an Extended Consumer if it
meets the following conditions:

1. Supports the conditions required by the PKCS11 conformance clauses
   ([PKCS11_Spec] Section 7 (PKCS#11 Implementation Conformance)
2. Supports the conditions required by the PKCS11 Baseline Consumer clauses
   section 5.7
3. Supports the following data types [PKCS11_Spec]:
   a. _CK_MECHANISM_TYPE_
   b. _CK_MECHANISM_
4. Supports the following attributes [PKCS11_Spec]:
   a. _None specified_
5. Supports the following objects [PKCS11_Spec]:
   a. _None specified_
6. Supports the following functions [PKCS11_Spec]:
   a. _C_GetMechanismList_
   b. _C_GetMechanismInfo_
7. Supports the following mechanisms:
   a. None specified
8. Supports Error Handling [PKCS11_Spec] for any supported object, function or
   mechanism
9. Optionally supports any clause within [PKCS11_Spec] that is not listed above
10. Optionally supports extensions outside the scope of this standard (e.g.,
    vendor defined extensions, conformance clauses) that do not contradict any
    PKCS #11 requirements
