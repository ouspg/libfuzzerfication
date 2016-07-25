# Purpose

This is a [libfuzzerfication stub](https://github.com/ouspg/libfuzzerfication)
for demonstration purposes.

`mysamplelib` is a simple library that provides `mysamplefunction()`-function as
a target for Fuzz-testing. `mysamplefunction()` takes two arguments: the "string"
to be tested as test input and the length of the test input.
Test input is compared against the target string `"Fuzzing in Style!"`. The
portion of the string that has been guessed successfully is displayed. The comparison is
implemented with an artificial nested `if`-construct to simulate the
basic block structure of a real protocol or file format parser. This
approach makes `mysamplefunction()` a "realistic" parser-type target for
the coverage guided fuzzing.

What is included?

 * [`samplelib`](mysamplelib.c)-library with `mysamplefunction()`-function as test target
 * [`mysamplelib-fuzzer`](mysamplelib-fuzzer.c)-stub to act as the interface between the `libfuzzer` and the test target
 * [`build.sh`](build.sh)-script to build the library, and the stub and to link them with the fuzzer
 * [`dictionary.txt`](dictionary.txt)-file as a sample dictionary for dictionary aided fuzzing strategy
 * [`samples/`](samples/)-directory as a sample corpus for the corpus aided fuzzing strategy
 * [`Dockerfile`](Dockerfile) to make this demonstration easily repeatable

Last but not least. There is at least one *crash-boom-bang* (read beyond bounds)
bug that the fuzzer should find.

# Building

```console
$ docker build -t mysamplelib-fuzzer .
```

# Running

## Starting the container

```console
$ docker run -ti --rm mysamplelib-fuzzer
```

## Running the fuzzer

```console
$ ./fuzzer
INFO: Seed: 50837522
INFO: -max_len is not provided, using 64
INFO: A corpus is not provided, starting from an empty corpus
#0      READ   units: 1 exec/s: 0
#1      INITED cov: 12 bits: 12 units: 1 exec/s: 0
#2      NEW    cov: 15 bits: 15 units: 2 exec/s: 0 L: 64 MS: 0

--- You fail ---
...
--- You fail ---
F
...
Fuzz i
--- You fail ---
Fuzz in Style!
*** Grand success ***
Fuzz in
--- You fail ---
...
==33==ERROR: AddressSanitizer: global-buffer-overflow on address 0x000000518e0f at pc 0x00000048b390 bp 0x7fff6c865350 sp 0x7fff6c864b00
READ of size 16 at 0x000000518e0f thread T0
...
```

# Running with different fuzzing strategies

Following examples use `-seed=` to make results repeatable.
In normal fuzzing you would **not** want to fix the seed.

Four different fuzzing strategies are summaries below and details on how to run them are given as separate examples.

fuzzing strategy | attempts until crash found
---------------- | ---------------------------
coverage only | 9488
dictionary | 3064
corpus | 1374
corpus from fuzzing | 149

## Coverage guided fuzzing

```console
$ ./fuzzer -seed=2016 corpus | wc -l
INFO: Seed: 2016
INFO: -max_len is not provided, using 64
INFO: A corpus is not provided, starting from an empty corpus
...
==276==ERROR: AddressSanitizer: global-buffer-overflow on address 0x000000518e0f at pc 0x00000048b390 bp 0x7ffe3a3c9f50 sp 0x7ffe3a3c9700
...
9488
```

## Coverage guided fuzzing with dictionary

```console
$ ./fuzzer -seed=2016 -dict=./dictionary.txt | wc -l
Dictionary: 2 entries
INFO: Seed: 2016
INFO: -max_len is not provided, using 64
INFO: A corpus is not provided, starting from an empty corpus
...
==247==ERROR: AddressSanitizer: global-buffer-overflow on address 0x000000518e0f at pc 0x00000048b390 bp 0x7fff8aa71150 sp 0x7fff8aa70900
...
3064
```

## Coverage guided fuzzing with corpus (samples)

```console
$ ./fuzzer -seed=2016 corpus | wc -l
INFO: Seed: 2016
INFO: -max_len is not provided, using 64
...
==283==ERROR: AddressSanitizer: global-buffer-overflow on address 0x000000518e0f
 at pc 0x00000048b390 bp 0x7ffd0cdde950 sp 0x7ffd0cdde100
...
1374
```

## Coverage guided fuzzing with new corpus (from previous run)

```console
$ ./fuzzer -seed=2016 corpus | wc -l
INFO: Seed: 2016
INFO: -max_len is not provided, using 64
...
==234==ERROR: AddressSanitizer: global-buffer-overflow on address 0x000000518e0f at pc 0x00000048b390 bp 0x7ffc7f4b5750 sp 0x7ffc7f4b4f00
...
149
```

# Further work

It appears that changing the compiler optimizations (`-On`) has a radical impact
on the fuzzer performance with this sample test target. This setup would allow
us to to study it further.

Furthermore, in addition to using the `libfuzzer` as the coverage guided fuzzer
we could implement a simple brute force fuzzer and output guided brute force
fuzzer for this test target. We could also document how to run the [american
fuzzy lop](http://lcamtuf.coredump.cx/afl/)-fuzzer (afl) against this target.
Then we could compare all these alternative approaches.
