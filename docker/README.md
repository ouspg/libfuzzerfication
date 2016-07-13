# Getting started locally
* Decide what you want to fuzz. You can see [Target tracking sheet](https://docs.google.com/spreadsheets/d/1oj0L44gKTn3wlrJk6b554b9o8H0r1bVfb6LJrw62BEE/pubhtml) as an example.
* Install Clang. Clang version distributed with most Linux distribution is too old. You should get it from [trunk](http://clang.llvm.org/get_started.html) or use Clang binaries from Chromium developers.
* Build libFuzzer without any sanitizer options.
* Link with libFuzzer.a

You will find instructions to getting started with libFuzzer and some examples from here:
http://llvm.org/docs/LibFuzzer.html

You can start by creating a new .cc file and define fuzzing target function that takes byte sequence (Data) and size of sequence (Size) as input . Very simple libFuzzer stub looks like this:

```
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  DoSomething(Data, Size); // Your fuzzing code here
  return 0;  // Non-zero return values are reserved for future use.
}
```

LibFuzzer uses corpus of sample inputs to test the code. Corpus is a set of valid and invalid inputs for the target. Corpus is usually collected manually, by fuzzing or by crawling from web. For example, for graphics library for example corpus should hold different image files. Fuzzer generates mutations for these files automatically which are then tested again. If mutations trigger new code pathes under test the mutations are saved to corpus. It is possible to minimize corpus but still preserve code coverage.

You can easily get started with stubs by installing Clang and libFuzzer locally. Your fuzzer should produce output like this:
```
INFO: Seed: 219835401
#0	READ   units: 202 exec/s: 0
#202	INITED cov: 2610 indir: 22 units: 145 exec/s: 0
#928	NEW    cov: 2611 indir: 22 units: 146 exec/s: 0 L: 19 MS: 1 ChangeBit-
#1859	NEW    cov: 2615 indir: 22 units: 147 exec/s: 1859 L: 11 MS: 2 ChangeASCIIInt-CrossOver-
#4096	pulse  cov: 2615 indir: 22 units: 147 exec/s: 2048
#4964	NEW    cov: 2616 indir: 22 units: 148 exec/s: 2482 L: 19 MS: 2 ChangeBit-ChangeASCIIInt-
#5599	NEW    cov: 2617 indir: 22 units: 149 exec/s: 1866 L: 23 MS: 2 ShuffleBytes-CrossOver-
#5673	NEW    cov: 2618 indir: 22 units: 150 exec/s: 1891 L: 31 MS: 1 CrossOver-
#5699	NEW    cov: 2628 indir: 22 units: 151 exec/s: 1899 L: 15 MS: 2 EraseByte-CrossOver-
#5809	NEW    cov: 2639 indir: 22 units: 152 exec/s: 1936 L: 210 MS: 2 ChangeBit-CrossOver-
#7596	NEW    cov: 2640 indir: 22 units: 153 exec/s: 1899 L: 186 MS: 4

```
The NEW line appears when libFuzzer finds new interesting input.

The pulse line shows current status and appears periodically

# Using docker

If you want to start using Docker you have to should read  [Docker documentation](https://docs.docker.com/) if you are not familiar with it. Before starting to write dockerfiles it is recommened to read [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

# How to run containers?

* Get base image

```
docker pull ouspg/libfuzzer-base
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
