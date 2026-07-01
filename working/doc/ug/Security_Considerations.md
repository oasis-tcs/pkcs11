# Security considerations

## General Guidance

As an interface to cryptographic devices, Cryptoki provides a basis for security
in a computer or communications system. Two of the features of the interface
that facilitate such security are the following:

1. Access to private objects on the token, and possibly to cryptographic
   functions and/or certificates on the token as well, requires a PIN. Thus,
   possessing the cryptographic device that implements the token may not be
   sufficient to use it; the PIN may also be needed.
2. Additional protection can be given to private keys and secret keys by marking
   them as "sensitive" or "unextractable". Sensitive keys cannot be revealed in
   plaintext off the token, and unextractable keys cannot be revealed off the
   token even when encrypted (though they can still be used as keys).

It is expected that access to private, sensitive, or unextractable objects by
means other than Cryptoki (e.g., other programming interfaces, or reverse
engineering of the device) would be difficult.

If a device does not have a tamper-proof environment or protected memory in
which to store private and sensitive objects, the device may encrypt the objects
with a master key which is perhaps derived from the user's PIN. The particular
mechanism for protecting private objects is left to the device implementation,
however.

Based on these features it should be possible to design applications in such a
way that the token can provide adequate security for the objects the
applications manage.

Of course, cryptography is only one element of security, and the token is only
one component in a system. While the token itself may be secure, one must also
consider the security of the operating system by which the application
interfaces to it, especially since the PIN may be passed through the operating
system. This can make it easy for a rogue application on the operating system to
obtain the PIN; it is also possible that other devices monitoring communication
lines to the cryptographic device can obtain the PIN. Rogue applications and
devices may also change the commands sent to the cryptographic device to obtain
services other than what the application requested.

It is important to be sure that the system is secure against such attack.
Cryptoki may well play a role here; for instance, a token may be involved in the
"booting up" of the system.

We note that none of the attacks just described can compromise keys marked
"sensitive," since a key that is sensitive will always remain sensitive.
Similarly, a key that is unextractable cannot be modified to be extractable.

An application may also want to be sure that the token is "legitimate" in some
sense (for a variety of reasons, including export restrictions and basic
security). This is outside the scope of the present standard, but it can be
achieved by distributing the token with a built-in, certified public/private-key
pair, by which the token can prove its identity. The certificate would be signed
by an authority (presumably the one indicating that the token is "legitimate")
whose public key is known to the application. The application would verify the
certificate and challenge the token to prove its identity by signing a
time-varying message with its built-in private key.

Once a normal user has been authenticated to the token, Cryptoki does not
restrict which cryptographic operations the user may perform; the user may
perform any operation supported by the token. Some tokens may not even require
any type of authentication to make use of its cryptographic functions.

## Padding Oracle Attacks

To protect against chosen ciphertext attacks, like the Bleichenbacher attack,
use PKCS #1 Version 2, with OAEP, and disable support for PKCS #1, Version 1.5.

Furthermore, more specifically to smart card implementations, the requirement of
the PIN and a long open connection to the device is required to execute the
attack. For smartcard implementations, execution of these attacks requires
private key operations and a sufficiently long open connection. It is strongly
recommended that any applets exposing private key operations are protected using
an encrypted PIN (a PIN not submitted in the clear), and the session is closed
when not in use.
