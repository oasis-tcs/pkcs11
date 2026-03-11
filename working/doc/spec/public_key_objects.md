## Public key objects

Public key objects (object class **CKO_PUBLIC_KEY**) hold public keys. The
following table defines the attributes common to all public keys, in addition
to the common attributes defined for this object class:

| Attribute           | Data type  | Meaning                             |
|---------------------|------------|-------------------------------------|
| CKA_SUBJECT ^8^     | Byte array | DER-encoding of the key subject name (default empty) |
| CKA_ENCRYPT ^8^     | CK_BBOOL   | CK_TRUE if key supports encryption^9^ |
| CKA_VERIFY ^8^      | CK_BBOOL   | CK_TRUE if key supports verification where the signature is an appendix to the data^9^ |
| CKA_VERIFY_RECOVER ^8^ | CK_BBOOL | CK_TRUE if key supports verification where the data is recovered from the signature^9^ |
| CKA_WRAP ^8^        | CK_BBOOL   | CK_TRUE if key supports wrapping (i.e., can be used to wrap other keys)^9^ |
| CKA_ENCAPSULATE ^8^ | CK_BBOOL   | CK_TRUE if key supports encapsulation (i.e., can be used in a KEM to create an encapsulated key and ciphertext for C_DecapsulateKey)^9^ |
| CKA_TRUSTED ^10^    | CK_BBOOL   | The key can be trusted for the application that it was created. The wrapping key can be used to wrap keys with  CKA_WRAP_WITH_TRUSTED set to CK_TRUE. |
| CKA_WRAP_TEMPLATE   | CK_ATTRIBUTE_PTR | For wrapping keys. The attribute template to match against any keys wrapped using this wrapping key. Keys that do not match cannot be wrapped. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
| CKA_ENCAPSULATE_TEMPLATE| CK_ATTRIBUTE_PTR | For encapsulating keys. The attribute template to match against any keys encapsulated using this encapsulating key. Keys that do not match cannot be encapsulated. The number of attributes in the array is the ulValueLen component of the attribute divided by the size of CK_ATTRIBUTE. |
| CKA_PUBLIC_KEY_INFO | Byte array | DER-encoding of the SubjectPublicKeyInfo for this public key. (MAY be empty, DEFAULT derived from the underlying public key data) |
| CKA_PUBLIC_CRC64_VALUE ^1,4,13^ | Byte array | The CRC-64-ECMA calculated over the public key object’s CKA_VALUE attribute unless otherwise specified in the mechanism description |
table: Common Public Key Attributes

 * Refer to Table 13 for footnotes

It is intended in the interests of interoperability that the subject name
and key identifier for a public key will be the same as those for the
corresponding certificate and private key. However, Cryptoki does not enforce
this, and it is not required that the certificate and private key also be
stored on the token.

To map between ISO/IEC 9594-8 (X.509) **keyUsage** flags for public keys and
the PKCS #11 attributes for public keys, use the following table.

| **Key usage flags for public keys in X.509 public key certificates** | **Corresponding cryptoki attributes for public keys.** |
|----------------------------------------------------------------------|--------------------------------------------------------|
| dataEncipherment                                                     | CKA_ENCRYPT                                            |
| digitalSignature, keyCertSign, cRLSign, nonRepudiation               | CKA_VERIFY                                             |
| digitalSignature, keyCertSign, cRLSign, nonRepudiation               | CKA_VERIFY_RECOVER                                     |
| keyAgreement                                                         | CKA_DERIVE                                             |
| keyEncipherment                                                      | CKA_WRAP                                               |
| keyAgreement, keyEncipherment                                        | CKA_ENCAPSULATE                                        |

table: Mapping of X.509 key usage flags to Cryptoki attributes for public keys

The value of the **CKA_PUBLIC_KEY_INFO** attribute is the DER encoded value
of SubjectPublicKeyInfo:

	SubjectPublicKeyInfo	::= SEQUENCE {
		algorithm		AlgorithmIdentifier,
		subjectPublicKey	BIT_STRING }

The encodings for the subjectPublicKey field are specified in the description
of the public key types in the appropriate sections for the key types defined
within this specification.
