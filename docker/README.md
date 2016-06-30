
# libfuzzerfication dockerfiles

# libfuzzerfication stubs

# Getting started
* Decide what program you want to fuzz. You can see [Protecode list of top 50 libraries](https://github.com/ouspg/libfuzzerfication/blob/master/doc/protecode-sc-top-components-native-20160609.txt) as an example.
* Install Clang. Clang version distributed with most Linux distribution is too old. You should get it from [trunk](http://clang.llvm.org/get_started.html) or use Clang binaries from Chromium developers.
* Build libFuzzer without any sanitizer options.
* Link with libFuzzer.a

You will find instructions to getting started with libFuzzer and some examples from here:
http://llvm.org/docs/LibFuzzer.html

You can start by writing fuzzing target function that accepts byte sequence (Data) and size of sequence (Size) as input . Very simple libFuzzer stub looks like this:

```
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  DoSomething(Data, Size);
  return 0;  // Non-zero return values are reserved for future use.
}
```

LibFuzzer uses corpus of sample inputs to test the code. Corpus is a set of valid and invalid inputs for the target. Corpus is usually collected manually, by fuzzing or by crawling from web. For example, for graphics library for example corpus should hold different image files. Fuzzer generates mutations for these files automatically which are then tested again. If mutations trigger new code pathes under test the mutations are saved to corpus. It is possible to minimize corpus but still preserve code coverage.

You can easily get started with stubs by installing Clang and libFuzzer without Docker.

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
