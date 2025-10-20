## Hardware Feature Objects

### Definitions

This section defines the object class **CKO_HW_FEATURE** for type
CK_OBJECT_CLASS as used in the CKA_CLASS attribute of objects.

### Overview

Hardware feature objects (**CKO_HW_FEATURE**) represent features of the
device. They provide an easily expandable method for introducing new
value-based features to the Cryptoki interface.

_Table 15, Hardware Feature Common Attributes_

| Attribute              | Data Type          | Meaning                 |
|------------------------|--------------------|-------------------------|
| CKA_HW_FEATURE_TYPE^1^ | CK_HW_FEATURE_TYPE | Hardware feature (type) |
- Refer to Table 13 for footnotes

### Clock

#### Definition
\  

The **CKA_HW_FEATURE_TYPE** attribute takes the value **CKH_CLOCK** of type
CK_HW_FEATURE_TYPE.

#### Description
\  

Clock objects represent real-time clocks that exist on the device. This
represents the same clock source as the utcTime field in the **CK_TOKEN_INFO**
structure.

_Table 16, Clock Object Attributes_

| Attribute | Data Type   | Meaning                                       |
|-----------|-------------|-----------------------------------------------|
| CKA_VALUE | CK_CHAR[16] | Current time as a character-string of length  |
|           |             | 16, represented in the format YYYYMMDDhhmmssxx|
|           |             | (4 characters for the year;  2 characters each|
|           |             | for the month, the day, the hour, the minute, |
|           |             | and the second; and 2 additional reserved ‘0’ |
|           |             | characters).                                  |

The **CKA_VALUE** attribute may be set using the **C_SetAttributeValue**
function if permitted by the device. The session used to set the time MUST
be logged in. The device may require the SO to be the user logged in to
modify the time value. **C_SetAttributeValue** will return the error
**CKR_USER_NOT_LOGGED_IN** to indicate that a different user type is
required to set the value.

### Monotonic Counter Objects

#### Definition
\  

The **CKA_HW_FEATURE_TYPE** attribute takes the value
**CKH_MONOTONIC_COUNTER** of type CK_HW_FEATURE_TYPE.

#### Description
\  

Monotonic counter objects represent hardware counters that exist on the
device. The counter is guaranteed to increase each time its value is read,
but not necessarily by one. This might be used by an application for
generating serial numbers to get some assurance of uniqueness per token.

_Table 17, Monotonic Counter Attributes_

| Attribute            | Data Type  | Meaning                             |
|----------------------|------------|-------------------------------------|
| CKA_RESET_ON_INIT^1^ | CK_BBOOL   | The value of the counter will reset |
|                      |            | to a previously returned value if   |
|                      |            | the token is initialized using      |
|                      |            | **C_InitToken**.                    |
| CKA_HAS_RESET^1^     | CK_BBOOL   | The value of the counter has been   |
|                      |            | reset at least once at some point   |
|                      |            | in time.                            |
| CKA_VALUE^1^         | Byte array | The current version of the monotonic|
|                      |            | counter. The value is returned in   |
|                      |            | big endian order.                   |
^1^Read Only

The **CKA_VALUE** attribute may not be set by the client.

### User Interface Objects

#### Definition
\  

The **CKA_HW_FEATURE_TYPE** attribute takes the value **CKH_USER_INTERFACE**
of type CK_HW_FEATURE_TYPE.

#### Description
\  

User interface objects represent the presentation capabilities of the device.

_Table 18, User Interface Object Attributes_

| Attribute            | Data type       | Meaning                        |
|----------------------|-----------------|--------------------------------|
| CKA_PIXEL_X          | CK_ULONG        | Screen resolution (in pixels) in X-axis (e.g. 1280) |
| CKA_PIXEL_Y          | CK_ULONG        | Screen resolution (in pixels) in Y-axis (e.g. 1024) |
| CKA_RESOLUTION       | CK_ULONG        | DPI, pixels per inch                 |
| CKA_CHAR_ROWS        | CK_ULONG        | For character-oriented displays; number of character rows (e.g. 24) |
| CKA_CHAR_COLUMNS     | CK_ULONG        | For character-oriented displays: number of character columns (e.g. 80).\
                                           If display is of proportional-font type, this is the width of the display in “em”-s (letter “M”), see [CC/PP] Struct. |
| CKA_COLOR            | CK_BBOOL        | Color support                        |
| CKA_BITS_PER_PIXEL   | CK_ULONG        | The number of bits of color or grayscale information per pixel. |
| CKA_CHAR_SETS        | RFC 2279 string | String indicating supported character sets, as defined by IANA MIBenum sets (<http://www.iana.org>).\
                                           Supported character sets are separated with “;”.\
                                           E.g. a token supporting iso-8859-1 and US-ASCII would set the attribute value to “4;3”. |
| CKA_ENCODING_METHODS | RFC 2279 string | String indicating supported content transfer encoding methods, as defined by IANA (<http://www.iana.org>).\
                                           Supported methods are separated with “;”.\
                                           E.g. a token supporting 7bit, 8bit and base64 could set the attribute value to “7bit;8bit;base64”. |
| CKA_MIME_TYPES       | RFC 2279 string | String indicating supported (presentable) MIME-types, as defined by IANA (<http://www.iana.org>).\
                                           Supported types are separated with “;”.\
                                           E.g. a token supporting MIME types "a/b", "a/c" and "a/d" would set the attribute value to “a/b;a/c;a/d”. |

The selection of attributes, and associated data types, has been done in an
attempt to stay as aligned with [RFC 2534] and [CC/PP] Struct as possible.
The special value CK_UNAVAILABLE_INFORMATION may be used for CK_ULONG-based
attributes when information is not available or applicable.

None of the attribute values may be set by an application.

The value of the **CKA_ENCODING_METHODS** attribute may be used when the
application needs to send MIME objects with encoded content to the token.
