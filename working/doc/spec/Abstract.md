---
title: 'PKCS #11 Specification Version 3.3'
author: 'Committee Specification Working Draft 1'
date: '25 February 2025'
abstract: |
  **This stage:**

  <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.3/csd01/pkcs11-spec-v3.2-csd01.pdf>
  (Authoritative)

  <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.2/csd01/pkcs11-spec-v3.2-csd01.html>

  **Previous stage:**

  N/A

  **Latest stage:**

  <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.3/pkcs11-spec-v3.3.pdf> (Authoritative)

  <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.3/pkcs11-spec-v3.3.html>

  **Technical Committee:**

  OASIS PKCS 11 TC

  **Chairs:**

  Valerie Fenwick <vfenwick@apple.com>, Apple, Inc.

  Robert Relyea <rrelyea@redhat.com>, Red Hat, Inc.

  **Editors:**

  Dieter Bong <dieter.bong@utimaco.com>, Utimaco IS GmbH

  Greg Scott <greg.scott@cryptsoft.com>, Cryptsoft Pty Ltd

  **Additional artifacts:**

  This prose specification is one component of a Work Product that also includes
  PKCS #11 header files:

  * [pkcs11.h](https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.3/csd01/include/pkcs11-v3.3/pkcs11.h)
  * [pkcs11f.h](https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.3/csd01/include/pkcs11-v3.3/pkcs11f.h)
  * [pkcs11t.h](https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.3/csd01/include/pkcs11-v3.3/pkcs11t.h)

  **Related work:**

  This specification replaces or supersedes:

  * PKCS #11 Specification Version 3.2. Edited by Dieter Bong and Tony Cox. OASIS Standard.
    Latest stage: <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.1/pkcs11-spec-v3.1.html>.

  This specification is related to:

  * PKCS #11 Profiles Version 3.2. Edited by Tim Hudson.  
    Latest stage: <https://docs.oasis-open.org/pkcs11/pkcs11-profiles/v3.2/pkcs11-profiles-v3.2.html>.
  * PKCS #11 Usage Guide Version 3.2. Edited by Dieter Bong.  
    Latest stage: <https://docs.oasis-open.org/pkcs11/pkcs11-ug/v3.2/pkcs11-ug-v3.2.html>.

  **Abstract:**

  This document defines data types, functions and other basic components of the
  PKCS #11 Cryptoki interface.

  **Status:**

  This document was last revised or approved by the OASIS PKCS 11 TC on the above
  date. The level of approval is also listed above. Check the "Latest stage"
  location noted above for possible later revisions of this document. Any other
  numbered Versions and other technical work produced by the Technical Committee
  (TC) are listed at <https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=pkcs11#technical>.
  
  TC members should send comments on this document to the TC's email list. Others
  should send comments to the TC's public comment list, after subscribing to it
  by following the instructions at the "Send A Comment" button on the TC's web
  page at <https://www.oasis-open.org/committees/pkcs11/>.
  
  This specification is provided under the RF on RAND Terms Mode of the OASIS
  IPR Policy, the mode chosen when the Technical Committee was established. For
  information on whether any patents have been disclosed that may be essential
  to implementing this specification, and any offers of patent licensing terms,
  please refer to the Intellectual Property Rights section of the TC's web page
  (<https://www.oasis-open.org/committees/pkcs11/ipr.php>).
  
  Note that any machine-readable content (Computer Language Definitions)
  declared Normative for this Work Product is provided in separate plain text
  files. In the event of a discrepancy between any such plain text file and
  display content in the Work Product's prose narrative document(s), the content
  in the separate plain text file prevails.

  **Key words:**

  The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
  "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
  document are to be interpreted as described in BCP 14 [RFC 2119] and [RFC 8174]
  when, and only when, they appear in all capitals, as shown here.

  **Citation format:**

  When referencing this document, the following citation format should be used:

  [PKCS11-Spec-v3.2]

  PKCS #11 Specification Version 3.2. Edited by Dieter Bong and Greg Scott. 13
  September 2023.

  OASIS Committee Specification Draft 01. <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.2/csd01/pkcs11-spec-v3.2-csd01.html>.

  Latest stage: <https://docs.oasis-open.org/pkcs11/pkcs11-spec/v3.2/pkcs11-spec-v3.2.html>.  

  **Notices:**

  Copyright © OASIS Open 2025. All Rights Reserved.
  Distributed under the terms of the [OASIS IPR Policy](https://www.oasis-open.org/policies-guidelines/ipr/).
  For complete copyright information please see the full Notices section in an Appendix below.
maxwidth: 80%
---
