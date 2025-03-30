## Wrapping/unwrapping private keys

Cryptoki Versions 2.01 and up allow the use of secret keys for wrapping and
unwrapping RSA private keys, Diffie-Hellman private keys, X9.42 Diffie-Hellman
private keys, short Weierstrass EC private keys, DSA private keys, HSS private
keys, XMSS/XMSSMT private keys, ML-DSA private keys, ML-KEM private keys and
SLH-DSA private keys. For wrapping, a private key is BER-encoded according to
[PKCS #8] PrivateKeyInfo ASN.1 type. [PKCS #8] requires an algorithm identifier
for the type of the private key. The object identifiers for the required
algorithm identifiers are as follows:

~~~{.c}
rsaEncryption OBJECT IDENTIFIER ::= { pkcs-1 1 }

dhKeyAgreement OBJECT IDENTIFIER ::= { pkcs-3 1 }

dhpublicnumber OBJECT IDENTIFIER ::= { iso(1) member-body(2) us(840) ansi-x942(10046) number-type(2) 1 }

id-ecPublicKey OBJECT IDENTIFIER ::= { iso(1) member-body(2) us(840) ansi-x9-62(10045) publicKeyType(2) 1 }

id-dsa OBJECT IDENTIFIER ::= { iso(1) member-body(2) us(840) x9-57(10040) x9cm(4) 1 }

id-ml-dsa-44 OBJECT IDENTIFIER ::= { nist-sigAlgs 17 }
id-ml-dsa-65 OBJECT IDENTIFIER ::= { nist-sigAlgs 18 }
id-ml-dsa-87 OBJECT IDENTIFIER ::= { nist-sigAlgs 19 }

id-slh-dsa-sha2-128s OBJECT IDENTIFIER ::= { nist-sigAlgs 20 }
id-slh-dsa-sha2-128f OBJECT IDENTIFIER ::= { nist-sigAlgs 21 }
id-slh-dsa-sha2-192s OBJECT IDENTIFIER ::= { nist-sigAlgs 22 }
id-slh-dsa-sha2-192f OBJECT IDENTIFIER ::= { nist-sigAlgs 23 }
id-slh-dsa-sha2-256s OBJECT IDENTIFIER ::= { nist-sigAlgs 24 }
id-slh-dsa-sha2-256f OBJECT IDENTIFIER ::= { nist-sigAlgs 25 }
id-slh-dsa-shake-128s OBJECT IDENTIFIER ::= { nist-sigAlgs 26 }
id-slh-dsa-shake-128f OBJECT IDENTIFIER ::= { nist-sigAlgs 27 }
id-slh-dsa-shake-192s OBJECT IDENTIFIER ::= { nist-sigAlgs 28 }
id-slh-dsa-shake-192f OBJECT IDENTIFIER ::= { nist-sigAlgs 29 }
id-slh-dsa-shake-256s OBJECT IDENTIFIER ::= { nist-sigAlgs 30 }
id-slh-dsa-shake-256f OBJECT IDENTIFIER ::= { nist-sigAlgs 31 }

id-hash-ml-dsa-44-with-sha512 OBJECT IDENTIFIER ::= { 
nist-sigAlgs 32 }
id-hash-ml-dsa-65-with-sha512 OBJECT IDENTIFIER ::= { 
nist-sigAlgs 33 }
id-hash-ml-dsa-87-with-sha512 OBJECT IDENTIFIER ::= { 
nist-sigAlgs 34 }

id-hash-slh-dsa-sha2-128s-with-sha256 OBJECT IDENTIFIER ::= { nist-sigAlgs 35 }
id-hash-slh-dsa-sha2-128f-with-sha256 OBJECT IDENTIFIER ::= { nist-sigAlgs 36 }
id-hash-slh-dsa-sha2-192s-with-sha512 OBJECT IDENTIFIER ::= { nist-sigAlgs 37 }
id-hash-slh-dsa-sha2-192f-with-sha512 OBJECT IDENTIFIER ::= { nist-sigAlgs 38 }
id-hash-slh-dsa-sha2-256s-with-sha512 OBJECT IDENTIFIER ::= { nist-sigAlgs 39 }
id-hash-slh-dsa-sha2-256f-with-sha512 OBJECT IDENTIFIER ::= { nist-sigAlgs 40 }
id-hash-slh-dsa-shake-128s-with-shake128 OBJECT IDENTIFIER ::= { nist-sigAlgs 41 }
id-hash-slh-dsa-shake-128f-with-shake128 OBJECT IDENTIFIER ::= { nist-sigAlgs 42 }
id-hash-slh-dsa-shake-192s-with-shake256 OBJECT IDENTIFIER ::= { nist-sigAlgs 43 }
id-hash-slh-dsa-shake-192f-with-shake256 OBJECT IDENTIFIER ::= { nist-sigAlgs 44 }
id-hash-slh-dsa-shake-256s-with-shake256 OBJECT IDENTIFIER ::= { nist-sigAlgs 45 }
id-hash-slh-dsa-shake-256f-with-shake256 OBJECT IDENTIFIER ::= { nist-sigAlgs 46 }

id-alg-ml-kem-512 OBJECT IDENTIFIER ::= { nist-kems 1 }
id-alg-ml-kem-768 OBJECT IDENTIFIER ::= { nist-kems 2 }
id-alg-ml-kem-1024 OBJECT IDENTIFIER ::= { nist-kems 3 }
~~~

where

~~~{.c}
pkcs-1 OBJECT IDENTIFIER ::= {
  iso(1) member-body(2) US(840) rsadsi(113549) pkcs(1) 1 }

pkcs-3 OBJECT IDENTIFIER ::= {
  iso(1) member-body(2) US(840) rsadsi(113549) pkcs(1) 3 }

nistAlgorithms OBJECT IDENTIFIER ::= { joint-iso-ccitt(2) country(16) us(840) organization(1) gov(101) csor(3) nistAlgorithm(4) }
nist-sigAlgs OBJECT IDENTIFIER ::= { nistAlgorithms 3 }
nist-kems OBJECT IDENTIFIER ::= { nistAlgorithms 4 }
~~

These parameters for the algorithm identifiers have the following types,
respectively:

~~~{.c}
NULL

DHParameter ::= SEQUENCE {
  prime				INTEGER,  -- p
  base				INTEGER,  -- g
  privateValueLength	INTEGER OPTIONAL
}

DomainParameters ::= SEQUENCE {
  prime				INTEGER,  -- p
  base				INTEGER,  -- g
  subprime			INTEGER,  -- q
  cofactor			INTEGER OPTIONAL,  -- j
  validationParms	ValidationParms OPTIONAL
}

ValidationParms ::= SEQUENCE {
  Seed			BIT STRING, -- seed
  PGenCounter	INTEGER     -- parameter verification
}

Parameters ::= CHOICE {
  ecParameters	ECParameters,
  namedCurve	CURVES.&id({CurveNames}),
  implicitlyCA	NULL
}

Dss-Parms ::= SEQUENCE {
  p INTEGER,
  q INTEGER,
  g INTEGER
}
~~~

For the X9.42 Diffie-Hellman domain parameters, the **cofactor** and the
**validationParms** optional fields should not be used when wrapping or
unwrapping X9.42 Diffie-Hellman private keys since their values are not stored
within the token.

For the EC domain parameters, the use of **namedCurve** is recommended over the
choice **ecParameters**. The choice **implicitlyCA** must not be used in
Cryptoki.

Within the PrivateKeyInfo type:

* RSA private keys are BER-encoded according to PKCS #1’s RSAPrivateKey ASN.1
  type. This type requires values to be present for all the attributes specific
  to Cryptoki’s RSA private key objects. In other words, if a Cryptoki library
  does not have values for an RSA private key’s **CKA_MODULUS**,
  **CKA_PUBLIC_EXPONENT**, **CKA_PRIVATE_EXPONENT**, **CKA_PRIME_**1,
  **CKA_PRIME_**2, **CKA_EXPONENT_**1, **CKA_EXPONENT_**2, and
  **CKA_COEFFICIENT** values, it must not create an RSAPrivateKey BER-encoding
  of the key, and so it must not prepare it for wrapping.
* Diffie-Hellman private keys are represented as BER-encoded ASN.1 type INTEGER.
* X9.42 Diffie-Hellman private keys are represented as BER-encoded ASN.1 type
  INTEGER.
* Short Weierstrass EC private keys are BER-encoded according to SECG [SEC 1]
  ECPrivateKey ASN.1 type:

~~~{.c}
ECPrivateKey ::= SEQUENCE {
	Version		INTEGER { ecPrivkeyVer1(1) } (ecPrivkeyVer1),
	privateKey	OCTET STRING,
	parameters	[0] Parameters OPTIONAL,
	publicKey	[1] BIT STRING OPTIONAL
}
~~~

Since the EC domain parameters are placed in the PKCS #8’s privateKeyAlgorithm
field, the optional **parameters** field in an ECPrivateKey must be omitted. A
Cryptoki application must be able to unwrap an ECPrivateKey that contains the
optional **publicKey** field; however, what is done with this **publicKey**
field is outside the scope of Cryptoki.

* DSA private keys are represented as BER-encoded ASN.1 type INTEGER.
* For ML-KEM and ML-DSA keys, the private key can be encoded with a seed, a
  value, or both. If only one of the two are supplied, unwrap may fail in some
tokens. Which encodings on wrap are specified is token specific.

Once a private key has been BER-encoded as a PrivateKeyInfo type, the resulting
string of bytes is encrypted with the secret key. This encryption is defined in
the section for the respective key wrapping mechanism.

Unwrapping a wrapped private key undoes the above procedure. The ciphertext is
decrypted as defined for the respective key unwrapping mechanism. The data
thereby obtained are parsed as a PrivateKeyInfo type. An error will result if
the original wrapped key does not decrypt properly, or if the decrypted data
does not parse properly, or its type does not match the key type specified in
the template for the new key. The unwrapping mechanism contributes only those
attributes specified in the PrivateKeyInfo type to the newly-unwrapped key;
other attributes must be specified in the template, or will take their default
values.

Earlier drafts of PKCS #11 Version 2.0 and Version 2.01 used the object
identifier

~~~{.c}
DSA OBJECT IDENTIFIER ::= { algorithm 12 }
algorithm OBJECT IDENTIFIER ::= {
  iso(1) identifier-organization(3) oiw(14) secsig(3) algorithm(2) }
~~~

with associated parameters

~~~{.c}
DSAParameters ::= SEQUENCE {
  prime1 INTEGER,  -- modulus p
  prime2 INTEGER,  -- modulus q
  base INTEGER  -- base g
}
~~~

for wrapping DSA private keys. Note that although the two structures for holding
DSA domain parameters appear identical when instances of them are encoded, the
two corresponding object identifiers are different.
