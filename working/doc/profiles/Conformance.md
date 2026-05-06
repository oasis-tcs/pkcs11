# Conformance

The baseline provider and consumer profiles provide the most basic functionality
that is expected of a conformant PKCS#11 consumer or provider. The complete
provider profile defines a PKCS#11 provider that implements the entire
specification. A PKCS#11 implementation conformant to this specification (the
PKCS#11 Profiles) SHALL meet all the conditions documented in one or more of the
following sections.

## Baseline Provider Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; 
2. SHALL support the Baseline Provider conditions (5.1) and; 
3. SHALL support one or more of the Baseline Provider Mandatory Test Cases
   (5.1.1).

## Complete Provider Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; 
2. SHALL support the Complete Provider conditions (5.2) and; 
3. SHALL support all of the provider conformance clauses contained within
   Conformance (6).

## Extended Provider Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; 
2. SHALL support the Extended Provider conditions (5.3) and; 
3. SHALL support one or more of the Extended Provider Mandatory Test Cases
   (5.3.1).

## Authentication Token Provider Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; 
2. SHALL support the Authentication Token conditions (5.4) and; 
3. SHALL support all of the Authentication Token Provider Mandatory Test Cases
   (5.4.1).

## Public Certificates Token Provider Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; 
2. SHALL support the Public Certificates Token conditions (5.5) and; 
3. SHALL support all of the Public Certificates Token Provider Mandatory Test
   Cases (5.5.1).

## HKDF TLS Token Provider Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; 
2. SHALL support the HKDF TLS Token conditions (5.6).

## Baseline Consumer Profile Conformance

PKCS#11 consumer implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; and
2. SHALL support the Baseline Consumer conditions (5.7).

## Authentication Token Consumer Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; and
2. SHALL support the Authentication Token conditions (5.4)

## Public Certificates Token Consumer Profile Conformance

PKCS#11 provider implementations conformant to this profile:

1. SHALL support [PKCS11_Spec]; and
2. SHALL support the Public Certificates Token conditions (5.5)
