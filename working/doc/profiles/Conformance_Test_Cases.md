# Conformance Test Cases

The test cases define a sequence of PKCS#11 function calls with specified input
and output parameters.

Each test case is provided in the XML format specified in PKCS#11 XML
Representation (4) intended to be both human-readable and usable by automated
tools.

Each test case has a unique label (the section name) which includes indication
of mandatory (-M-) or optional (-O-) status and the specification version major
and minor numbers as part of the identifier.

The test cases may depend on a specific configuration of a PKCS#11 provider and
consumer and being configured in a manner consistent with the test case
assumptions.

Where possible the flow of identifiers between tests, date values, and other
dynamic items are indicated using symbolic identifiers – in actual request and
response messages these dynamic values will be filled in with valid values.

Symbolic identifiers SHALL be of the form `${ParameterName}`. Wherever a symbolic
identifier occurs in a test case the implementation must replace it with a
reasonable appearing datum of the expected type. 

The symbolic identifier may reference return parameters or array or list items
by index number. Array index numbers SHALL be of the form
`${ParameterName[ArrayIndex]}` and the first element SHALL be indicated by index
zero.

The symbolic identifier may reference elements nested within other elements.
Nested references SHALL be of the form `${ParameterName.SubElement}` and MAY also
include an array index.

Note: the values for the returned items are illustrative. Actual values from a
real consumer or provider MAY vary as specified in section 3.1.

## Permitted Test Case Variations

Whilst the test cases provided in a Profile define the allowed call and return
content, some inherent variations MAY occur and are permitted within a
successfully completed test case.

Each test case MAY include allowed variations in the description of the test
case in addition to the variations noted in this section.

Other variations not explicitly noted in this section SHALL be deemed
non-conformant.

### Variable Items

An implementation conformant to a Profile MAY vary the following values
(expressed using the XML name for the items):

Provider specific information within the `Info`, `SlotInfo` and `TokenInfo` elements:

1. `LibraryDescription`
2. `LibraryVersion`
3. `ManufacturerID`
4. `SlotDescription`
5. `HardwareVersion`
6. `FirmwareVersion`
7. `serialNumber`
8. `label`
9. `model`
10. `utcTime`

Session specific information:

1. `SlotID`
2. `Object` 
3. `Session`

Object specific information:

1. `Object`

Operation specific information:

1. `Data`
2. `EncryptedData`
3. `RandomData`

Attribute specific information:

1. `VALUE`
2. `PUBLIC_EXPONENT`
3. `PRIVATE_EXPONENT`
4. `PRIME_1`
5. `PRIME_2`
6. `EXPONENT_1`
7. `EXPONENT_2`
8. `COEFFICIENT`
9. `PRIME`
10. `SUBPRIME`
11. `BASE`
12. `EC_POINT`
13. `UNIQUE_ID`

### Variable behavior

An implementation conformant to a Profile SHALL allow variation of the following
behavior:

1. A test may omit the clean-up functions at the end of the test provided there
   is a separate mechanism to remove the created objects during testing.
2. A test may omit the test identifiers in various attributes if the consumer is
   unable to include them in calls.
3. The number of entries and order of entries in the list returned in the
   _C_GetSlotList_, _C_GetMechanismList_, and _C_GetInterfaceList_ functions may
   vary, provided that at least one entry within the list matches the logical
   context of the test case.
