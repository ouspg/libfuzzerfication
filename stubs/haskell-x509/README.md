# Haskell-x509

# Purpose

Use Haskell's FFI (foreign function interface), export Haskell function via FFI (using C Calling Convention) and minimal layer of C to initialize Haskell runtime.
Compilation produces object file named test.o which can be linked with libFuzzer. After that we use Haskell packagin tools to enable SanitizerCoverage.

See presentation [https://github.com/ouspg/libfuzzerfication/blob/master/doc/presentation-oherrala-fuzzing-beyond-c.md](Fuzzing beyond C) by oherrala.

# Building

# Running
