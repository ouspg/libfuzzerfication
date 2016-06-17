
all: test

test.o: test.hs
	ghc-asan -c test.hs

test: test.o /work/libfuzzer/*.o
	ghc-wrapper -no-hs-main -o test test.o /work/libfuzzer/*.o
