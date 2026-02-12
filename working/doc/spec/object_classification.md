## Object Classification

Cryptoki objects are classified into two categories: storage objects and other
objects. Storage objects are those that are typically created by applications
and possess the attributes common to all storage objects. Other objects are
generally built-in or ephemeral objects that the token exposes to provide
information or functionality to applications.

| Object Class             | Description              |
|--------------------------|--------------------------|
| CKO_DATA                 | Data objects             |
| CKO_CERTIFICATE          | Certificate objects      |
| CKO_TRUST                | Trust objects            |
| CKO_PUBLIC_KEY           | Public key objects       |
| CKO_PRIVATE_KEY          | Private key objects      |
| CKO_SECRET_KEY           | Secret key objects       |
| CKO_DOMAIN_PARAMETERS    | Domain parameter objects |
table: Storage Objects

| Object Class             | Description              |
|--------------------------|--------------------------|
| CKO_HW_FEATURE           | Hardware feature objects |
| CKO_MECHANISM            | Mechanism objects        |
| CKO_PROFILE              | Profile objects          |
| CKO_VALIDATION           | Validation objects       |
table: Other Objects
