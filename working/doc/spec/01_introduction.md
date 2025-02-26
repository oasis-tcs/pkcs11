# Introduction

[All text is normative unless otherwise labeled]

This document describes the basic PKCS #11 token interface and token behavior.

The PKCS #11 standard specifies an application programming interface (API),
called “Cryptoki,” for devices that hold cryptographic information and
perform cryptographic functions. Cryptoki follows a simple object based
approach, addressing the goals of technology independence (any kind of
device) and resource sharing (multiple applications accessing multiple
devices), presenting to applications a common, logical view of the device
called a “cryptographic token”.

This document specifies the data types and functions available to an
application requiring cryptographic services using the ANSI C programming
language. The supplier of a Cryptoki library implementation typically provides
these data types and functions via ANSI C header files. Generic ANSI C header
files for Cryptoki are available from the PKCS #11 web page. This document and
up-to-date errata for Cryptoki will also be available from the same place.

This document also specifies details of cryptographic mechanisms (algorithms).

Additional documents may provide a generic, language-independent Cryptoki
interface and/or bindings between Cryptoki and other programming languages.

Cryptoki isolates an application from the details of the cryptographic device.
The application does not have to change to interface to a different type of
device or to run in a different environment; thus, the application is portable.
How Cryptoki provides this isolation is beyond the scope of this document,
although some conventions for the support of multiple types of device will be
addressed here and possibly in a separate document.

## Definitions

For the purposes of this standard, the following definitions apply:

**AES**
: Advanced Encryption Standard, as defined in FIPS PUB 197.

**API**
: Application programming interface.

**Application**
: Any computer program that calls the Cryptoki interface.

**ASN.1**
: Abstract Syntax Notation One, as defined in X.680.

**Attribute**
: A characteristic of an object.

**BER**
: Basic Encoding Rules, as defined in X.690.

**BLOWFISH**
: The Blowfish Encryption Algorithm of Bruce Schneier, www.schneier.com.

**CAMELLIA**
: The Camellia encryption algorithm, as defined in [RFC 3713].

**CBC**
: Cipher-Block Chaining mode, as defined in [FIPS PUB 81].

**Certificate**
: A signed message binding a subject name and a public key, or a subject name and a set of attributes.

**CDMF**
: Commercial Data Masking Facility, a block encipherment method specified by International Business Machines Corporation and based on DES.

**CMAC**
: Cipher-based Message Authenticate Code as defined in [NIST SP800-38B] and [RFC 4493].

**CMS**
: Cryptographic Message Syntax (see [RFC 5652])

**Cryptographic Device**
: A device storing cryptographic information and possibly performing cryptographic functions. May be implemented as a smart card, smart disk, PCMCIA card, or with some other technology, including software-only.

**Cryptoki**
: The Cryptographic Token Interface defined in this standard.

**Cryptoki library**
: A library that implements the functions specified in this standard.

**CT-KIP**
: Cryptographic Token Key Initialization Protocol (as defined in [CT-KIP])

**DER**
: Distinguished Encoding Rules, as defined in X.690.

**DES**
: Data Encryption Standard, as defined in [FIPS PUB 46-3].

**DSA**
: Digital Signature Algorithm, as defined in [FIPS PUB 186-4].

**EC**
: Elliptic Curve

**ECB**
: Electronic Codebook mode, as defined in [FIPS PUB 81].

**ECDH**
: Elliptic Curve Diffie-Hellman.

**ECDSA**
: Elliptic Curve DSA, as in [ANSI X9.62].

**ECMQV**
: Elliptic Curve Menezes-Qu-Vanstone

**GOST 28147-89**
: The encryption algorithm, as defined in Part 2 [GOST 28147-89] and [RFC 4357] [RFC 4490], and RFC [4491].

**GOST R 34.11-94**
: Hash algorithm, as defined in [GOST R 34.11-94] and [RFC 4357], [RFC 4490], and [RFC 4491].

**GOST R 34.10-2001**
: The digital signature algorithm, as defined in [GOST R 34.10-2001] and [RFC 4357], [RFC 4490], and [RFC 4491].

**IV**
: Initialization Vector.

**KEM**
: Key Encapsulation Mechanism.

**MAC**
: Message Authentication Code.

**Mechanism**
: A process for implementing a cryptographic operation.

**MQV**
: Menezes-Qu-Vanstone

**OAEP**
: Optimal Asymmetric Encryption Padding for RSA.

**Object**
: An item that is stored on a token. May be data, a certificate, or a key.

**PIN**
: Personal Identification Number.

**PKCS**
: Public-Key Cryptography Standards.

**PRF**
: Pseudo random function.

**PTD**
: Personal Trusted Device, as defined in [MeT-PTD]

**RSA**
: The RSA public-key cryptosystem.

**Reader**
: The means by which information is exchanged with a device.

**Session**
: A logical connection between an application and a token.

**SHA-1**
: The (revised) Secure Hash Algorithm with a 160-bit message digest, as defined in [FIPS PUB 180-4].

**SHA-224**
: The Secure Hash Algorithm with a 224-bit message digest, as defined in [FIPS PUB 180-4].

**SHA-256**
: The Secure Hash Algorithm with a 256-bit message digest, as defined in [FIPS PUB 180-4].

**SHA-384**
: The Secure Hash Algorithm with a 384-bit message digest, as defined in [FIPS PUB 180-4].

**SHA-512**
: The Secure Hash Algorithm with a 512-bit message digest, as defined in [FIPS PUB 180-4].

**Slot**
: A logical reader that potentially contains a token.

**SSL**
: The Secure Sockets Layer 3.0 protocol.

**Subject Name**
: The X.500 distinguished name of the entity to which a key is assigned.

**SO**
: A Security Officer user.

**TLS**
: Transport Layer Security.

**Token**
: The logical view of a cryptographic device defined by Cryptoki.

**User**
: The person using an application that interfaces to Cryptoki.

**UTF-8**
: Universal Character Set (UCS) transformation format (UTF) that represents ISO 10646 and UNICODE strings with a variable number of octets.

**WTLS**
: Wireless Transport Layer Security.


## Symbols and abbreviations

The following symbols are used in this standard:

| Symbol | Definition     |
|--------|----------------|
| N/A    | Not applicable |
| R/O    | Read-only      |
| R/W    | Read/write     |
table: Symbols

The following prefixes are used in this standard:

| Prefix | Description                    |
|--------|--------------------------------|
| C_     | Function                       |
| CK_    | Data type or general constant  |
| CKA_   | Attribute                      |
| CKC_   | Certificate type               |
| CKD_   | Key derivation function        |
| CKF_   | Bit flag                       |
| CKG_   | Mask generation function       |
| CKH_   | Hardware feature type          |
| CKK_   | Key type                       |
| CKM_   | Mechanism type                 |
| CKN_   | Notification                   |
| CKO_   | Object class                   |
| CKP_   | Pseudo-random function         |
| CKS_   | Session state                  |
| CKR_   | Return value                   |
| CKU_   | User type                      |
| CKZ_   | Salt/Encoding parameter source |
| h      | a handle                       |
| ul     | a CK_ULONG                     |
| p      | a pointer                      |
| pb     | a pointer to a CK_BYTE         |
| ph     | a pointer to a handle          |
| pul    | a pointer to a CK_ULONG        |
table: Prefixes

Cryptoki is based on ANSI C types, and defines the following data types:

~~~{.c}
/* an unsigned 8-bit value */
typedef unsigned char CK_BYTE;

/* an unsigned 8-bit character */
typedef CK_BYTE CK_CHAR;

/* an 8-bit UTF-8 character */
typedef CK_BYTE CK_UTF8CHAR;

/* a BYTE-sized Boolean flag */
typedef CK_BYTE CK_BBOOL;

/* an unsigned value, at least 32 bits long */
typedef unsigned long int CK_ULONG;

/* a signed value, the same size as a CK_ULONG */
typedef long int CK_LONG;

/* at least 32 bits; each bit is a Boolean flag */
typedef CK_ULONG CK_FLAGS;
~~~

Cryptoki also uses pointers to some of these data types, as well as to the
type void, which are implementation-dependent. These pointer types are:

~~~{.c}
CK_BYTE_PTR      /* Pointer to a CK_BYTE */
CK_CHAR_PTR      /* Pointer to a CK_CHAR */
CK_UTF8CHAR_PTR  /* Pointer to a CK_UTF8CHAR */ 
CK_ULONG_PTR     /* Pointer to a CK_ULONG */
CK_VOID_PTR      /* Pointer to a void */
~~~

Cryptoki also defines a pointer to a CK_VOID_PTR, which is
implementation-dependent:

~~~{.c}
CK_VOID_PTR_PTR  /* Pointer to a CK_VOID_PTR */
~~~

In addition, Cryptoki defines a C-style NULL pointer, which is distinct from
any valid pointer:

~~~{.c}
NULL_PTR         /* A NULL pointer */
~~~

It follows that many of the data and pointer types will vary somewhat from one
environment to another (e.g., a CK_ULONG will sometimes be 32 bits, and
sometimes perhaps 64 bits). However, these details should not affect an
application, assuming it is compiled with Cryptoki header files consistent
with the Cryptoki library to which the application is linked.

All numbers and values expressed in this document are decimal, unless they are
preceded by “0x”, in which case they are hexadecimal values.

The *CK_CHAR* data type holds characters from the following table, taken from
[ANSI C]:

| Category           | Characters                                    |
|--------------------|-----------------------------------------------|
| Letters            | A B C D E F G H I J K L M N O P Q R S T U V W |
|                    | X Y Z a b c d e f g h i j k l m n o p q r s t |
|                    | u v w x y z                                   |
| Numbers            | 0 1 2 3 4 5 6 7 8 9                           |
| Graphic characters | ! “ # % & ‘ ( ) * + , - . / : ; < = > ? [ \ ] |
|                    | ^ _ { | } ~                                   |
| Blank character    | ‘ ‘                                           |
table: Character Set

The **CK_UTF8CHAR** data type holds UTF-8 encoded Unicode characters as
specified in [RFC 2279]. UTF-8 allows internationalization while maintaining
backward compatibility with the Local string definition of PKCS #11 version
2.01.

In Cryptoki, the **CK_BBOOL** data type is a Boolean type that can be true or
false. A zero value means false, and a nonzero value means true. Similarly,
an individual bit flag, **CKF_**..., can also be set (true) or unset (false).
For convenience, Cryptoki defines the following macros for use with values of
type **CK_BBOOL**:

~~~{.c}
#define CK_FALSE 0
#define CK_TRUE  1
~~~

For backwards compatibility, header files for this version of Cryptoki also
define TRUE and FALSE as (CK_DISABLE_TRUE_FALSE may be set by the application
vendor):

~~~{.c}
#ifndef CK_DISABLE_TRUE_FALSE
#ifndef FALSE
#define FALSE CK_FALSE
#endif

#ifndef TRUE
#define TRUE CK_TRUE
#endif
#endif
~~~
