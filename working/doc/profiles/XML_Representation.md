# PKCS#11 XML Representation

## Normalizing Names

PKCS#11 parameter and structure field names SHALL be normalized to create a
'CamelCase' format that would be suitable to be used as a variable name in
C/Java or an XML element name.

Hungarian notation type indicators are entirely omitted from names (i.e. _h_,
_ph_, _ul_, _pul_, and _p_ are omitted).

PKCS#11 function names are represented as-is (unchanged) as XML elements of the
same name.

## Omitted Items

PKCS#11 pointers for callback functions and reserved items are entirely omitted
(i.e. _pApplication_, _pReserved_, _Notify_ are not present).

Hungarian notation type indicators are entirely omitted from names (i.e. _h_,
_ph_, _ul_, _pul_, and _p_ are omitted).

## Value Representation

The value for PKCS#11 binary (_CK_BYTE_) information SHALL be encoded as
hexadecimal strings.

The value for PKCS#11 textual information (_CK_CHAR_, _CK_UTF8CHAR_) SHALL be
encoded as hex strings.

The value for PKCS#11 numeric information SHALL be encoded as integers or as
hexadecimal strings.

### Enumerated Type Representation

Each PKCS#11 type value SHALL be represented in string/text form using the
uppercase C macro name with the type prefix omitted. E.g. _CKR_OK_ has a
representation of _"OK"_.

### Boolean Representation

Each PKCS#11 boolean value (_CK_BBOOL_) SHALL be represented in string/text form
either as "true" (non-zero) or "false" (zero). No other representation SHALL be
used.

### Flag Type Representation

Each PKCS#11 flag value SHALL be represented using the uppercase C macro names
with the type prefix omitted for each bit. If multiple bit flags are set then
each SHALL be present separated by either a space (' ') or a pipe ('|')
character.

### Special Value Representation

For PKCS#11 `CK_ULONG` values which have special interpretation as
`CK_UNAVAILABLE_INFORMATION` or `CK_EFFECTIVELY_INFINITE` the string values
"UnavailableInformation" and "EffectivelyInfinite" SHOULD be used instead of the
numeric values to improve readability. This approach is used in the
`CK_TOKEN_INFO` structure for various count and length and size values.

### Function Call and Return Representation

PKCS#11 function calls are represented as an XML element of the same name
containing the input parameters each represented as XML elements and an XML
element of the same name as the PKCS#11 function name with an XML element
attribute named `rv` containing the return value. The XML element for the input
parameters is always immediately followed by the XML element for the output
results.

PKCS#11 parameters and structure members that are not arrays or lists are
represented as XML elements with the value of the parameter or structure member
contained within the XML element attribute value.

### Array and List Representation

PKCS#11 parameters and structure members that are arrays or lists are
represented as XML elements with the length of the array or list contained in
XML element attribute _length_ and the members of the array or list represented
as nested XML elements unless an XML element attribute-based representation has
been separately defined (e.g for _CK_ATTRIBUTE_). 

PKCS#11 parameters and structure member elements that represent the count of
arrays are omitted as input parameters as the lengths can be determined by a
count of the number of XML elements within the call or return XML element within
the element representing the PKCS#11 function call.

### Determining Array or List Length

The PKCS#11 approach of passing in a NULL pointer value and using an
input/output parameter to determine the required pointer buffer length for a
subsequent call SHALL be encoded as request where the XML element for pointer
has no specified value or length for the function call and the returned length
is contained in the XML element attribute _length_. 

### Hexadecimal String Encoding

Hexadecimal strings SHALL NOT include any white space. 

Hexadecimal strings SHALL use either uppercase 'A'-'F' or lowercase 'a'-'f'
along with '0' to '9'. 

Numeric values represented as hexadecimal strings SHALL begin with '0x'.

Binary values represented as hexadecimal strings SHOULD omit the '0x'. 

## XML Root Element

XML documents representing a sequence of PKCS#11 function calls and returns
SHALL have an XML root element of _PKCS11_. 

## XML Namespaces

If namespaces are necessary within a specific context, then each XML element
SHALL use the following namespace:

    `urn:oasis:tc:pkcs11:xmlns`

## XML Element Encoding

For XML, each function call is represented as a sequence of two XML element with
optional attributes.

The parameters to each call are represented as nested XML elements, and any
structures used within those parameters are represented as nested XML elements
within the nested XML elements.

The types of each parameter or structure element are fixed within the PKCS#11
specification and are not separately represented within the XML encoding. i.e.
the types are inherently known by implementations and are fixed, matching the
underlying C static type declaration.

### Boolean

XML value uses [XML-SCHEMA] type `xsd:Boolean`. The value SHALL be `FALSE`,
`false`, `TRUE` or `true`.

```xml
<TokenPresent value="false"/>
```

### Text String

XML value uses [XML-SCHEMA] type `xsd:string`

```xml
<Pin value="12345678"/>
```

### Byte String

XML value uses [XML-SCHEMA] type `xsd:hexBinary`

```xml
<EncryptedData value="8dce78ad"/>
```

### Enumerated Type

XML value uses [XML-SCHEMA] type `xsd:string` and is either a hexadecimal string
or the Enumerated Type Representation name. If an XSD with `xsd:enumeration`
restriction is used to define valid values parsers should also accept any
hexadecimal string in addition to the defined enumeration values to allow for
user extensions and non-textual encoding parsers.

```xml
<Type value="AES_CBC"/>
<Type value="0x00001082"/>
<Type value="4426"/>
```

### Function Call and Return

PKCS#11 function call and return SHALL be encoded as an XML element for the
function call with any required parameters as nested XML elements, followed by
an XML element for the function return with an XML element attribute of `rv`
containing the return code from the function call encoded as an Enumerated Type
and any output parameters as nested XML elements.

```xml
<C_Initialize/>
<C_Initialize rv="OK"/>
<C_GetSlotList>
  <TokenPresent value="false"/>
  <SlotList/>
</C_GetSlotList>
<C_GetSlotList rv="OK">
  <SlotList length="1"/>
</C_GetSlotList>
```

### Attribute

PKCS#11 attributes (`CK_ATTRIBUTE`) SHALL be encoded as an XML element with an
XML element attribute `type` containing the name of the PKCS#11 attribute and an
XML element attribute `value` containing the value of the attribute. Where the
PKCS#11 attribute has a specified type, the value SHALL be encoding using the
encoding rules for that type of PKCS#11 value.

```xml
<Attribute type="CLASS" value="SECRET_KEY"/>
<Attribute type="KEY_TYPE" value="AES"/>
<Attribute type="LABEL" value="timing-key"/>
<Attribute type="TOKEN" value="TRUE"/>
<Attribute type="PRIVATE" value="TRUE"/>
<Attribute type="EXTRACTABLE" value="TRUE"/>
<Attribute type="SENSITIVE" value="TRUE"/>
<Attribute type="ENCRYPT" value="TRUE"/>
<Attribute type="DECRYPT" value="TRUE"/>
<Attribute type="VALUE_LEN" value="16"/>
```

### XML Element Attributes

XML element attributes other than "type", "value", "length" and "rv" as defined
in this specification SHALL not be used. All other PKCS#11 concepts are
represented as XML elements and not XML element attributes.
