# Platform and compiler-dependent directives for C or C++

There is a large array of Cryptoki-related data types that are defined in the
Cryptoki header files. Certain packing and pointer-related aspects of these
types are platform and compiler-dependent; these aspects are therefore
resolved on a platform-by-platform (or compiler-by-compiler) basis outside of
the Cryptoki header files by means of preprocessor directives.

This means that when writing C or C++ code, certain preprocessor directives
MUST be issued before including a Cryptoki header file. These directives are
described in the remainder of this section.

Plattform specific implementation hints can be found in the pkcs11.h header file.

## Structure packing

Cryptoki structures are packed to occupy as little space as is possible.
Cryptoki structures SHALL be packed with 1-byte alignment.

## Pointer-related macros

Because different platforms and compilers have different ways of dealing with
different types of pointers, the following 6 macros SHALL be set outside the
scope of Cryptoki:

* **CK_PTR**

CK_PTR is the “indirection string” a given platform and compiler uses to make
a pointer to an object. It is used in the following fashion:

~~~{.c}
typedef CK_BYTE CK_PTR CK_BYTE_PTR;
~~~

* **CK_DECLARE_FUNCTION**

`CK_DECLARE_FUNCTION(returnType, name)`, when followed by a
parentheses-enclosed list of arguments and a semicolon, declares a Cryptoki
API function in a Cryptoki library. returnType is the return type of the
function, and name is its name. It SHALL be used in the following fashion:

~~~{.c}
CK_DECLARE_FUNCTION(CK_RV, C_Initialize)(
  CK_VOID_PTR pReserved
);
~~~

* **CK_DECLARE_FUNCTION_POINTER**

`CK_DECLARE_FUNCTION_POINTER(returnType, name)`, when followed by a
parentheses-enclosed list of arguments and a semicolon, declares a variable or
type which is a pointer to a Cryptoki API function in a Cryptoki library.
returnType is the return type of the function, and name is its name. It SHALL
be used in either of the following fashions to define a function pointer
variable, myC_Initialize, which can point to a C_Initialize function in a
Cryptoki library (note that neither of the following code snippets actually
assigns a value to myC_Initialize):

~~~{.c}
CK_DECLARE_FUNCTION_POINTER(CK_RV, myC_Initialize)(
  CK_VOID_PTR pReserved
);
~~~

or:

~~~{.c}
typedef CK_DECLARE_FUNCTION_POINTER(CK_RV, myC_InitializeType)(
  CK_VOID_PTR pReserved
);
myC_InitializeType myC_Initialize;
~~~

* **CK_CALLBACK_FUNCTION**

`CK_CALLBACK_FUNCTION(returnType, name)`, when followed by a
parentheses-enclosed list of arguments and a semicolon, declares a variable or
type which is a pointer to an application callback function that can be used
by a Cryptoki API function in a Cryptoki library. returnType is the return
type of the function, and name is its name. It SHALL be used in either of the
following fashions to define a function pointer variable, myCallback, which
can point to an application callback which takes arguments args and returns a
CK_RV (note that neither of the following code snippets actually assigns a
value to myCallback):

~~~{.c}
CK_CALLBACK_FUNCTION(CK_RV, myCallback)(args);
~~~

or:

~~~{.c}
typedef CK_CALLBACK_FUNCTION(CK_RV, myCallbackType)(args);
myCallbackType myCallback;
~~~

* **NULL_PTR**

NULL_PTR is the value of a NULL pointer. In any ANSI C environment—and in many
others as well—NULL_PTR SHALL be defined simply as 0.
