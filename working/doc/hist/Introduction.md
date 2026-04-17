# Introduction

## IPR Policy

This specification is provided under the RF on RAND Terms Mode of the OASIS IPR Policy, the mode chosen when the Technical Committee was established. For information on whether any patents have been disclosed that may be essential to implementing this specification, and any offers of patent licensing terms, please refer to the Intellectual Property Rights section of the TC's web page (https://www.oasis-open.org/committees/pkcs11/ipr.php).

## Description of this Document

This document defines historical PKCS#11 mechanisms, that is, mechanisms that were defined for earlier versions of PKCS #11 but are no longer in general use.

## Terminology

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC2119].

## Definitions

For the purposes of this standard, the following definitions apply. Please refer to [PKCS#11-Base] for further definitions:

**BATON**
: MISSI’s BATON block cipher.

**CAST**
: Entrust Technologies’ proprietary symmetric block cipher.

**CAST3**
: Entrust Technologies’ proprietary symmetric block cipher.

**CAST128**
: Entrust Technologies’ symmetric block cipher.

**CDMF**
: Commercial Data Masking Facility, a block encipherment method specified by International Business Machines Corporation and based on DES.

**CMS**
: Cryptographic Message Syntax (see RFC 3369).

**DES**
: Data Encryption Standard, as defined in FIPS PUB 46-3.

**ECB**
: Electronic Codebook mode, as defined in FIPS PUB 81.

**FASTHASH**
: MISSI’s FASTHASH message-digesting algorithm.

**IDEA**
: Ascom Systec’s symmetric block cipher.

**IV**
: Initialization Vector.

**JUNIPER**
: MISSI’s JUNIPER block cipher.

**KEA**
: MISSI’s Key Exchange Algorithm.

**LYNKS**
: A smart card manufactured by SPYRUS.

**MAC**
: Message Authentication Code.

**MD2**
: RSA Security’s MD2 message-digest algorithm, as defined in RFC 6149.

**MD5**
: RSA Security’s MD5 message-digest algorithm, as defined in RFC 1321.

**PRF**
: Pseudo random function.

**RSA**
: The RSA public-key cryptosystem.

**RC2**
: RSA Security’s RC2 symmetric block cipher.

**RC4**
: RSA Security’s proprietary RC4 symmetric stream cipher.

**RC5**
: RSA Security’s RC5 symmetric block cipher.

**SET**
: The Secure Electronic Transaction protocol.

**SHA-1**
: The (revised) Secure Hash Algorithm with a 160-bit message digest, as defined in FIPS PUB 180-2.

**SKIPJACK**
: MISSI’s SKIPJACK block cipher.

## Normative References

**[PKCS #11-Base]**

PKCS #11 Cryptographic Token Interface Base Specification Version 2.40. Edited
by Susan Gleeson and Chris Zimman. Latest version.

URL: <http://docs.oasis-open.org/pkcs11/pkcs11-base/v2.40/pkcs11-base-v2.40.html.>

**[PKCS #11-Curr]**

PKCS #11 Cryptographic Token Interface Current Mechanisms Specification Version 2.40. Edited by Susan Gleeson and Chris Zimman. Latest version.

URL: <http://docs.oasis-open.org/pkcs11/pkcs11-curr/v2.40/pkcs11-curr-v2.40.html.>

**[PKCS #11-Prof]**

PKCS #11 Cryptographic Token Interface Profiles Version 2.40. Edited by Tim Hudson. Latest version.

URL: <http://docs.oasis-open.org/pkcs11/pkcs11-profiles/v2.40/pkcs11-profiles-v2.40.html.>

**[RFC2119]**

Bradner, S., “Key words for use in RFCs to Indicate Requirement Levels”, BCP 14, RFC 2119, March 1997.

URL: <http://www.ietf.org/rfc/rfc2119.txt.>

## Non-Normative References

**[ANSI C]**

ANSI/ISO. American National Standard for Programming Languages – C. 1990.

**[ANSI X9.31]**

Accredited Standards Committee X9. Digital Signatures Using Reversible Public Key Cryptography for the Financial Services Industry (rDSA). 1998.

**[ANSI X9.42]**

Accredited Standards Committee X9. Public Key Cryptography for the Financial Services Industry: Agreement of Symmetric Keys Using Discrete Logarithm Cryptography. 2003.

**[ANSI X9.62]**

Accredited Standards Committee X9. Public Key Cryptography for the Financial Services Industry: The Elliptic Curve Digital Signature Algorithm (ECDSA). 1998.

**[CC/PP]**

G. Klyne, F. Reynolds, C. , H. Ohto, J. Hjelm, M. H. Butler, L. Tran, Editors, W3C. Composite Capability/Preference Profiles (CC/PP): Structure and Vocabularies. 2004.

URL: <http://www.w3.org/TR/2004/REC-CCPP-struct-vocab-20040115/.>

**[CDPD]**

Ameritech Mobile Communications et al. Cellular Digital Packet Data System Specifications: Part 406: Airlink Security. 1993.

**[FIPS PUB 46-3]**

NIST. FIPS 46-3: Data Encryption Standard (DES). October 26, 2999.

URL: <http://csrc.nist.gov/publications/fips/index.html.>

**[FIPS PUB 81]**

NIST. FIPS 81: DES Modes of Operation. December 1980.

URL: <http://csrc.nist.gov/publications/fips/index.html.>

**[FIPS PUB 113]**

NIST. FIPS 113: Computer Data Authentication. May 30, 1985.

URL: <http://csrc.nist.gov/publications/fips/index.html.>

**[FIPS PUB 180-2]**

NIST. FIPS 180-2: Secure Hash Standard. August 1, 2002.

URL: <http://csrc.nist.gov/publications/fips/index.html.>

**[FORTEZZA CIPG]**

NSA, Workstation Security Products. FORTEZZA Cryptologic Interface Programmers Guide, Revision 1.52. November 1985.

**[GCS-API]**

X/Open Company Ltd. Generic Cryptographic Service API (GCS-API), Base – Draft 2. February 14, 1995.

**[ISO/IEC 7816-1]**

ISO/IEC 7816-1:2011. Identification Cards – Integrated circuit cards -- Part 1: Cards with contacts -- Physical Characteristics. 2011.

URL: <http://www.iso.org/iso/catalogue_detail.htm?csnumber=54089.>

**[ISO/IEC 7816-4]**

ISO/IEC 7618-4:2013. Identification Cards – Integrated circuit cards – Part 4: Organization, security and commands for interchange. 2013.

URL: <http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=54550.>

**[ISO/IEC 8824-1]**

ISO/IEC 8824-1:2008. Abstract Syntax Notation One (ASN.1): Specification of Base Notation. 2002.

URL: <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=54012.>

**[ISO/IEC 8825-1]**

ISO/IEC 8825-1:2008. Information Technology – ASN.1 Encoding Rules: Specification of Basic Encoding Rules (BER), Canonical Encoding Rules (CER), and Distinguished Encoding Rules (DER). 2008.

URL: <http://www.iso.org/iso/home/store/catalogue_ics/catalogue_detail_ics.htm?csnumber=54011&ics1=35&ics2=100&ics3=60.>

**[ISO/IEC 9594-1]**

ISO/IEC 9594-1:2008. Information Technology – Open System Interconnection – The Directory: Overview of Concepts, Models and Services. 2008.

URL: <http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=53364.>

**[ISO/IEC 9594-8]**

ISO/IEC 9594-8:2008. Information Technology – Open Systems Interconnection – The Directory: Public-key and Attribute Certificate Frameworks. 2008.

URL: <http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=53372.>

**[ISO/IEC 9796-2]**

ISO/IEC 9796-2:2010. Information Technology – Security Techniques – Digital Signature Scheme Giving Message Recovery – Part 2: Integer factorization based mechanisms. 2010.

URL: <http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=54788.>

**[Java MIDP]**

Java Community Process. Mobile Information Device Profile for Java 2 Micro Edition. November 2002.

URL: <http://jcp.org/jsr/detail/118.jsp.>

**[MeT-PTD]**

MeT. MeT PTD Definition – Personal Trusted Device Definition, Version 1.0. February 2003.

URL: <http://www.mobiletransaction.org.>

**[PCMCIA]**

Personal Computer Memory Card International Association. PC Card Standard, Release 2.1. July 1993.

**[PKCS #1]**

RSA Laboratories. RSA Cryptography Standard, v2.1. June 14, 2002.

URL: <ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1/pkcs-1v2-1.pdf.>

**[PKCS #3]**

RSA Laboratories. Diffie-Hellman Key-Agreement Standard, v1.4. November 1993.

**[PKCS #5]**

RSA Laboratories. Password-Based Encryption Standard, v2.0. March 26, 1999.

URL: <ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-5v2/pkcs-5v2-0a1.pdf.>

**[PKCS #7]**

RSA Laboratories. Cryptographic Message Syntax Standard, v1.6. November 1997.

URL: <ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-7/pkcs-7v16.pdf.>

**[PKCS #8]**

RSA Laboratories. Private-Key Information Syntax Standard, v1.2. November 1993.

URL: <ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-8/pkcs-8v1_2.asn.>

**[PKCS #11-UG]**

PKCS #11 Cryptographic Token Interface Usage Guide Version 2.40. Edited by John Leiseboer and Robert Griffin. Latest version.

URL: <http://docs.oasis-open.org/pkcs11/pkcs11-ug/v2.40/pkcs11-ug-v2.40.html.>

**[PKCS #12]**

RSA Laboratories. Personal Information Exchange Syntax Standard, v1.0. June 1999.

URL: <ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-12/pkcs-12v1.pdf.>

**[RFC 1321]**

R. Rivest. RFC 1321: The MD5 Message-Digest Algorithm. MIT Laboratory for Computer Science and RSA Data Security, Inc., April 1992.

URL: <http://www.rfc-editor.org/rfc/rfc1321.txt.>

**[RFC 3369]**

R. Houseley. RFC 3369: Cryptographic Message Syntax (CMS). August 2002.

URL: <http://www.rfc-editor.org/rfc/rfc3369.txt.>

**[RFC 6149]**

S. Turner and L. Chen. RFC 6149: MD2 to Historic Status. March, 2011.

URL: <http://www.rfc-editor.org/rfc/rfc6149.txt.>

**[SEC-1]**

Standards for Efficient Cryptography Group (SECG). Standards for Efficient Cryptography (SEC) 1: Elliptic Curve Cryptography. Version 1.0, September 20, 2000.

**[SEC-2]**

Standards for Efficient cryptography Group (SECG). Standards for Efficient Cryptography (SEC) 2: Recommended Elliptic Curve Domain Parameters. Version 1.0, September 20, 2000.

**[TLS]**

IETF. RFC 2246: The TLS Protocol Version 1.0. January 1999.

URL: <http://ieft.org/rfc/rfc2256.txt.>

**[WIM]**

WAP. Wireless Identity Module. – WAP-260-WIP-20010712.a. July 2001.

URL: <http://technical.openmobilealliance.org/tech/affiliates/LicenseAgreement.asp?DocName=/wap/wap-260-wim-20010712-a.pdf.>

**[WPKI]**

WAP. Wireless Application Protocol: Public Key Infrastructure Definition. – WAP-217-WPKI-20010424-a. April 2001.

URL: <http://technical.openmobilealliance.org/tech/affiliates/LicenseAgreement.asp?DocName=/wap/wap-217-wpki-20010424-a.pdf.>

**[WTLS]**

WAP. Wireless Transport Layer Security Version – WAP-261-WTLS-20010406-a. April 2001.

URL: <http://technical.openmobilealliance.org/tech/affiliates/LicenseAgreement.asp?DocName=/wap/wap-261-wtls-20010406-a.pdf.>

**[X.500]**

ITU-T. Information Technology – Open Systems Interconnection –The Directory: Overview of Concepts, Models and Services. February 2001. (Identical to ISO/IEC 9594-1).

**[X.509]**

ITU-T. Information Technology – Open Systems Interconnection – The Directory: Public-key and Attribute Certificate Frameworks. March 2000. (Identical to ISO/IEC 9594-8).

**[X.680]**

ITU-T. Information Technology – Abstract Syntax Notation One (ASN.1): Specification of Basic Notation. July 2002. (Identical to ISO/IEC 8824-1).

**[X.690]**

ITU-T. Information Technology – ASN.1 Encoding Rules: Specification of Basic Encoding Rules (BER), Canonical Encoding Rules (CER), and Distinguished Encoding Rules (DER). July 2002. (Identical to ISO/IEC 8825-1).
