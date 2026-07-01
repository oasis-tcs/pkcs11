# Profiles

This document defines a selected set of conformance clauses which form PKCS #11
Profiles. A profile may be standalone or may be specified in terms of changes
relative to another profile.

The PKCS 11 TC also welcomes proposals for new profiles. PKCS 11 TC members are
encouraged to submit these proposals to the PKCS 11 TC for consideration for
inclusion in a future version of this TC-approved document. 

## Profile Requirements

The following items SHALL be addressed by each profile: 

  1. Specify the versions of the PKCS#11 specification that SHALL be supported
     if versions other than [PKCS11_Spec] are supported
  2. Specify the list of additional data types that SHALL be supported
  3. Specify the list of additional attributes that SHALL be supported
  4. Specify the list of additional objects that SHALL be supported
  5. Specify the list of additional functions that SHALL be supported
  6. Specify the list of additional mechanisms that SHALL be supported
  7. Specify any other requirements that SHALL be supported
  8. Specify any mandatory test cases that SHALL be supported by conforming
     implementations
  9. Specify optional test cases that MAY be supported by conforming
     implementations

Note: items may be specified either directly in a profile or by reference to
other profiles. Where another profile is referenced as required, the combination
of the requirements of all referenced required profiles (directly or indirectly)
SHALL apply.

## Guidelines for other Profiles

Any vendor or organization, such as other standards bodies, MAY create a PKCS#11
Profile and publish it.

1. The profile SHALL be publicly available.
2. The PKCS11 Technical Committee SHALL be formally advised of the availability
   of the profile and the location of the published profile.
3. The profile SHALL meet all the requirements of section 2.1 
4. The PKCS11 Technical Committee SHOULD review the profile prior to final
   publication.

## Defined Profile Identifiers

Profile objects (object class **CKO_PROFILE**) describe which PKCS #11 profiles a
provider implements.

The **CKA_PROFILE_ID** attribute identifies a profile that the provider implements.

| Attributes     | Data Types    | Meaning                    |
|----------------|---------------|----------------------------|
| CKA_PROFILE_ID | CK_PROFILE_ID | ID of the supported profile|
table: CKA_PROFILE_ID attribute

The following table defines the **CK_PROFILE_ID** values:

| Constant                      | Meaning                                   |
|-------------------------------|-------------------------------------------|
| CKP_INVALID_ID                | Invalid Profile                           |
| CKP_BASELINE_PROVIDER         | Baseline Provider                         |
| CKP_EXTENDED_PROVIDER         | Extended Provider                         |
| CKP_AUTHENTICATION_TOKEN      | Authentication Token Provider or Consumer |
| CKP_PUBLIC_CERTIFICATES_TOKEN | Public Certificates Token Provider or Consumer|
| CKP_COMPLETE_PROVIDER         | Complete Provider                         |
| CKP_HKDF_TLS_TOKEN            | HKDF TLS Token                            |
| CKP_VENDOR_DEFINED            | Vendor defined                            |
table: CK_PROFILE_ID values
