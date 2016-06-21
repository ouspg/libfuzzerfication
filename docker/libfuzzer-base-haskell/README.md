# Libfuzzer for Haskell libraries

Libfuzzer stubb should be in test.hs and then:

```
# cd /src
# ghc-asan -c test.hs
# ghc-wrapper -no-hs-main -o test test.o /work/libfuzzer/*.o
# file test
test: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=b73b57dfcd0b673600645f4b85d0e5694db0f69a, not stripped
```
