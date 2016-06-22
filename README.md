
# libfuzzerfication

<img src="https://raw.githubusercontent.com/ouspg/libfuzzerfication/master/pictures/fuzzing.png" width="500" height="284" alt="Fuzzing in action">

# Synopsis
Fuzz-testing is software design technique that involves providing pseudo-random data to the inputs of a computer program. The program is used to monitor for crashes or failing built-in code assertions or for finding potential memory leaks. This project uses [libFuzzer](http://llvm.org/docs/LibFuzzer.html) and purpose is to make it easy to find vulnerabilities from commonly used libraries. We have list of top 50 most used libraries from [Protecode SC](http://www.codenomicon.com/products/appcheck/).

"LibFuzzer is a library for in-process, coverage-guided, evolutionary fuzzing of other libraries.
LibFuzzer is similar in concept to [American Fuzzy Lop (AFL)](http://lcamtuf.coredump.cx/afl/), but it performs all of its fuzzing inside a single process. This in-process fuzzing can be more restrictive and fragile, but is potentially much faster as there is no overhead for process start-up."
http://llvm.org/docs/LibFuzzer.html

# Motivation
There have been lots of vulnerabilities in popular libraries that should have been (theoretically) easy to test. We want to offer easy way to fuzz-test these libraries and increase awareness about the situation. We also want this to be available to everyone.

Currently our top targets are:
* libxslt
* speex
* libflac
* gstreamer

Google cloud is going to be used for scale.

You're welcome to collaborate!

This is part of [OUSPG-open](https://github.com/ouspg/ouspg-open)

# How does it work?
* Pull container from Dockerhub
* Write your own libfuzzer stub
* Share dockerfile with other users
* Use libFuzzer to collect corpus so that other people can continue where you left off

# Requirements
* [docker-machine version 0.7.0](https://docs.docker.com/machine/)
* [Docker version 1.11.2](https://www.docker.com/)
* [docker-compose version 1.7.1](https://docs.docker.com/compose/)

# About libfuzzer
* For fuzzing "libs"
* requires stub "main" to hook the function to be tested & lib init
* stub + lib compiled with asan/msan/ubsan
* uses the sanitizer
* clang build -> C/C++
* Fast!

# Material

* [libFuzzer](http://llvm.org/docs/LibFuzzer.html)
* [SanitizerCoverage](http://clang.llvm.org/docs/SanitizerCoverage.html)
* You can find some nice examples from: [libfuzzer-bot repo](https://github.com/google/libfuzzer-bot)
* [libFuzzer in Chrome](https://chromium.googlesource.com/chromium/src/+/master/testing/libfuzzer/README.md)
* [Efficient Fuzzer](https://chromium.googlesource.com/chromium/src/+/master/testing/libfuzzer/efficient_fuzzer.m

# Contributors
* Mikko Yliniemi (@mikessu)
* Atte Kettunen (@attekett)
* Pauli Huttunen (@WhiteEyeDoll)
* ... you?
