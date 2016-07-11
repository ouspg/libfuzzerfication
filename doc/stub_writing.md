class: center, middle

## LibFuzzerfication stubs
## OUSPG Open, 2016-07-12

---

# Introduction
Purpose of libFuzzerfication is to do fuzz-testing for applications and libraries. Today we are going to write some libFuzzer stubs for libFuzzerfication.

Fuzzing is to automatically generate lots of test input to crash your code and to increase code coverage.
Some important words:

Target:
- A function that consumes array of byters and does something non trivial to them.

Fuzzer engine
- A tool that needs a fuzz target with different random inputs

Corpus
- A set on inputs that are either valid or invalid.
- Collected manually or by fuzzing or by crawling from web
- Can be minimized (to have only files with different code coverage)

---
# Motivation
There have been lots of vulnerabilities in popular libraries that should have been (theoretically) easy to test. We want to offer easy way to fuzz-test these libraries and increase awareness about the situation. We also want this to be available to everyone.

---

# About libfuzzer
* LibFuzzer is open-source library (part of LLVM)
* Relies on compiler instrumentation to get coverage feedback
* It is linked with the library under test
* Works fully inside the running program (a process) -> Fast!

---

# How to get started writing stubs?
* You need:
- clang
- libFuzzer

* List of targets to fuzz:
- https://docs.google.com/spreadsheets/d/1oj0L44gKTn3wlrJk6b554b9o8H0r1bVfb6LJrw62BEE/pubhtml

---

The first step for using libFuzzer on a library is to implement a fuzzing target function that accepts a sequence of bytes, like this:

```
// fuzz_target.cc
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  DoSomethingInterestingWithMyAPI(Data, Size);
  return 0;  // Non-zero return values are reserved for future use.
}
```
---
Next, build the libFuzzer library as a static archive, without any sanitizer options. Note that the libFuzzer library contains the main() function:

```
svn co http://llvm.org/svn/llvm-project/llvm/trunk/lib/Fuzzer
# Alternative: get libFuzzer from a dedicated git mirror:
# git clone https://chromium.googlesource.com/chromium/llvm-project/llvm/lib/Fuzzer
clang++ -c -g -O2 -std=c++11 Fuzzer/*.cpp -IFuzzer
ar ruv libFuzzer.a Fuzzer*.o
```

clang -fsanitize-coverage=edge -fsanitize=address your_lib.cc fuzz_target.cc libFuzzer.a -o my_fuzzer

See: http://llvm.org/docs/LibFuzzer.html
---

```
INFO: Seed: 219835401
#0  READ   units: 202 exec/s: 0
#202    INITED cov: 2610 indir: 22 units: 145 exec/s: 0
#928    NEW    cov: 2611 indir: 22 units: 146 exec/s: 0 L: 19 MS: 1 ChangeBit-
#1859   NEW    cov: 2615 indir: 22 units: 147 exec/s: 1859 L: 11 MS: 2 ChangeASCIIInt-CrossOver-
#4096   pulse  cov: 2615 indir: 22 units: 147 exec/s: 2048
#4964   NEW    cov: 2616 indir: 22 units: 148 exec/s: 2482 L: 19 MS: 2 ChangeBit-ChangeASCIIInt-
#5599   NEW    cov: 2617 indir: 22 units: 149 exec/s: 1866 L: 23 MS: 2 ShuffleBytes-CrossOver-
#5673   NEW    cov: 2618 indir: 22 units: 150 exec/s: 1891 L: 31 MS: 1 CrossOver-
#5699   NEW    cov: 2628 indir: 22 units: 151 exec/s: 1899 L: 15 MS: 2 EraseByte-CrossOver-
#5809   NEW    cov: 2639 indir: 22 units: 152 exec/s: 1936 L: 210 MS: 2 ChangeBit-CrossOver-
#7596   NEW    cov: 2640 indir: 22 units: 153 exec/s: 1899 L: 186 MS: 4
```

The NEW line appears when libFuzzer finds new interesting input.

The pulse line shows current status and appears periodically

---

# Using docker

If you want to start using Docker you have to should read  [Docker documentation](https://docs.docker.com/) if you are not familiar with it. Before starting to write dockerfiles it is recommened to read [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

# How to run containers?
* Build base image
```
docker-compose build libfuzzer-base
```
* Run container (ImageMagick example)
```
docker-compose run imagemagick
```
* You can find other targets from docker-compose.yml
* libfuzzer-base includes fuzz.sh script for collecting results

# Developing
* Build image
* If you want to do developing (for ImageMagick in example) use:
```
docker run -it --rm -v <path>/<to>/docker/stubs/ImageMagick/:/src/src/ImageMagick --entrypoint bash <image>
```
This will run ImageMagick container with your development directory mounted inside container.
