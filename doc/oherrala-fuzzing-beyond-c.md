class: center, middle

# Fuzzing beyond C

## Advanced Fuzzing Workshop
## OUSPG Open, 2016-06-28

---

# Self promotion

 * Ossi Herrala (@oherrala)
 * https://github.com/oherrala
 * Codenomicon / Synopsys / AbuseSA
 * Defensics fuzzers (IPv4, TLS, NFS, MPEG4, ..)
 * Sysadmin
 * Bachelor's thesis work as part of OUSPG Open
   * this fuzzing thingie is not that thesis..

---

# Agenda

1. Motivation
2. Haskell
3. Sample stub
4. Build it
5. Instrumentation
6. Example: X.509 "Exception is error"

## Feel free to ask at any time

---

# Motivation

### Languages with compilers that use LLVM include:

  ActionScript, Ada, C#, Common Lisp, Crystal, D, Delphi, Fortran,
  OpenGL Shading Language, Halide, **Haskell**, Java bytecode, Julia,
  Lua, Objective-C, Pony, Python, R, Ruby, Rust, Scala, Swift

Source: https://en.wikipedia.org/wiki/LLVM

### Fuzz libs of your favorite lang!

 * Software has bugs. Break the myth that *hype-of-the-month-language*
   will lead to safer world because it eliminates all the bugs.
 * Learn how your favorite language and libs behave under pressure

---

# Haskell

*standardized, general-purpose purely functional programming language, with non-strict semantics and strong static typing*

 * Standardized: There's specification how language works
 * General purpose: *a computer language that is broadly applicable across application domains (not DSL)*
 * Purely functional: *One typical approach to achieve this is by excluding destructive modifications (updates)*
 * Non-strict semantics: Aka lazy evaluation (infinite lists and recursions are ok)
 * Static typing: Type safety at compile time
 * Strong typing: "True == 1" is compile time error

Source: Wikipedia

---

# Sample stub in C

```C
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
 DoSomethingInterestingWithMyAPI(Data, Size);
 return 0;  // Non-zero return values are reserved for future use.
}
```

Source: http://llvm.org/docs/LibFuzzer.html

---

# Sample stub in Haskell

```haskell
testOneInputM :: CString -> CSize -> IO CInt
testOneInputM str size = do

  -- Convert C String into Haskell bytes (bytestring)
  bs <- BS.packCStringLen (str, fromIntegral size)

  -- Many decode functions want bytestring
  doSomethingInterestingWithMyAPI bs

  -- Non-zero return values are reserved for future use.
  return 0
```

C stub for comparison:

```C
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
 DoSomethingInterestingWithMyAPI(Data, Size);
 return 0;  // Non-zero return values are reserved for future use.
}
```

---

# Sample stub (boilerplate)

```haskell
{-# LANGUAGE ForeignFunctionInterface #-}

module Test where

import Foreign.C.Types
import Foreign.C.String
import qualified Data.ByteString as BS

foreign export ccall "LLVMFuzzerTestOneInput" testOneInputM
    :: CString -> CSize -> IO CInt
```

---

# Initialize Haskell Runtime (in 6 lines of C)

```c
#include "HsFFI.h"

int LLVMFuzzerInitialize(int *argc, char ***argv) {
  hs_init(argc, argv);
  return 0;
}
```

*The call to hs_init() initializes GHC's runtime system. Do NOT try
to invoke any Haskell functions before calling hs_init(): bad things
will undoubtedly happen.*

Source: https://downloads.haskell.org/~ghc/7.0.2/docs/html/users_guide/ffi-ghc.html


---

# GHC with LLVM/clang build stack

 1. Haskell compiler (GHC)
 2. C compiler (clang + SanitizerCoverage)
 3. Assembler (clang)
 4. LLVM Optimizer (LLVM)
 5. LLVM Compiler (LLVM)
 6. LLVM Mangler (GHC)
 7. Assembler (clang)
 8. Linker (clang + SanitizerCoverage)


---

# Build it

```sh
#!/bin/sh
set -ex

GHCOPTS="-package libfuzzer"

clang -Wall -c -I/opt/ghc/8.0.1/lib/ghc-8.0.1/include/ hsinit.c
ghc-asan ${GHCOPTS} -c test.hs
ghc-wrapper ${GHCOPTS} -no-hs-main -lFuzzer -o test test.o hsinit.o
```

---

## ghc-wrapper
```sh
ghc                \
    -threaded      \
    -fforce-recomp \
    -fllvm         \ # Use LLVM backend
    -pgmP=clang    \ # C preprocessor
    -pgmc=clang    \ # C compiler
    -pgma=clang    \ # Assembler
    -pgml=clang++  \ # Linker
    $*
```

## ghc-asan
```sh
ghc-wrapper                                                                 \
    -optc="-g" -optl="-g"                                                   \
    -optc="-fsanitize=address"                                              \
    -optc="-fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp" \
    -optl="-fsanitize=address"                                              \
    -optl="-fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp" \
    $*
```

---

# Instrumentation

## did it break or did it behave well?

 * Crashes (the real ones)
 * "Crashes" (runtime handled things smoothly and exited program)
 * Exceptions (produces "crashes". can be caught and handled)
   * For example when function returns errors as sum type
 * Other?

*''The program is then monitored for exceptions such as crashes, or
failing built-in code assertions or for finding potential memory
leaks.''*

Source: Wikipedia

---

# Exception is error

```
Ok, modules loaded: none.
Prelude> :set -XOverloadedStrings
Prelude> import Data.X509

Prelude Data.X509> :t Data.X509.decodeSignedCertificate
Data.X509.decodeSignedCertificate
  :: Data.ByteString.Internal.ByteString
     -> Either String SignedCertificate
```

This is how it should work:
```
Prelude Data.X509> Data.X509.decodeSignedCertificate "hello world"
Left "ParsingPartial"
```

This is wrong behavior:
```

Data.X509.decodeSignedCertificate "\DLE;\217:\131'';\189:!&6!!Ly\222(\167ri'\186;)(U\240:;:})*:t;\226(;::\189:\239')\ENQ,)(*3\248V)$\FS*\169"
*** Exception: sequence not a primitive
```

---

# "Exception is error" instrumentation

```haskell
decode :: BS.ByteString
       -> IO (Either SomeException (Either String X509.SignedCertificate))
decode = try . evaluate . X509.decodeSignedCertificate

testOneInputM :: CString -> CSize -> IO CInt
testOneInputM str size = do
  bs <- BS.packCStringLen (str, fromIntegral size)

  result <- decode bs
  case result of
    Right _  -> return ()
    Left err -> do
      let err' = show err
      putStrLn $ "Exception: " ++ err'
      storeTestCase err' bs

  return 0
```

---

# 1M test cases for X.509 lib

## "Exception is error" instrumentation

* `time ./test -runs=1000000`
* `real 0m3.682s  user 0m3.250s  sys 0m0.480s`
* Results:
```
error, called at ./Data/ASN1/Prim.hs:172:54 in asn1-encoding-0.9.4-G3Eu427lfih60n7Hu41ILm:Data.ASN1.Prim
error, called at ./Data/ASN1/Serialize.hs:40:24 in asn1-encoding-0.9.4-G3Eu427lfih60n7Hu41ILm:Data.ASN1.Serialize
(6 times) StreamUnexpectedSituation "Header (ASN1Header ...)"
TypeDecodingFailed "Null: data length not within bound"
TypeDecodingFailed "bitstring: skip number not within bound 42 "<bytes removed>"
TypeDecodingFailed "boolean: length not within bound"
TypeDecodingFailed "time format invalid for TimeGeneralized : contains non ASCII characters"
TypeDecodingFailed "time format invalid for TimeUTC : contains non ASCII characters"
TypeNotImplemented "EMBEDDED PDV"
TypeNotImplemented "External"
TypeNotImplemented "Object Descriptor"
TypeNotImplemented "RELATIVE-OID"
TypeNotImplemented "real"
not canonical encoding of tag
sequence not a primitive
```

---

# Summary

 * It is possible to fuzz beyond C
 * It can produce results
 * Is libfuzzer The Tool?

## Challenges

 * Instrumentation
 * Compiling

## Sources

 * https://github.com/ouspg/libfuzzerfication/


---

class: center, middle

# Fuzzing beyond C

### Advanced Fuzzing Workshop
### OUSPG Open, 2016-06-28

# Questions ?
