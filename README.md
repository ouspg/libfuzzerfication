# libfuzzerfication
LibFuzzerfication project uses libFuzzer for fuzzing popular applications and libraries.

<img src="https://raw.githubusercontent.com/ouspg/libfuzzerfication/master/doc/pictures/fuzzing-lua.gif" width="716" height="393" alt="Fuzzing in action">

# About
Purpose of fuzzing is to automatically generate lots of test input and to make code crash and increase code coverage. [libFuzzer](http://llvm.org/docs/LibFuzzer.html) is a library for in-process, coverage-guided evolutionary fuzzing of other libraries. It is similiar to [American Fuzzy Lop (AFL)](http://lcamtuf.coredump.cx/afl/) but performs fuzzing inside single process and is much faster.

# Motivation
There have been lots of vulnerabilities in popular libraries that should have been (theoretically) easy to test. We want to offer easy way to fuzz-test these libraries and increase awareness about the situation. We also want this to be available to everyone.



# About libfuzzer
* LibFuzzer is open-source library (part of LLVM)
* Relies on compiler instrumentation to get coverage feedback
* It is linked with the library under test
* Works fully inside the running program (a process) -> Fast!

LibFuzzer itself can be built with any compiler without specific flags. Target code must be buit with Clang using [ASan](http://clang.llvm.org/docs/AddressSanitizer.html), [USan](http://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html) or [MSan](http://clang.llvm.org/docs/MemorySanitizer.html) and -fsanitize-coverage=edge
Optional features are: 8bit-counters,trace-cmp,indirect-calls

# How does this project work?
* You pull container from Dockerhub
* Start Writing your own libfuzzer stub
* Share dockerfile with other users
* Use libFuzzer to collect corpus so that other people can continue where you left off

You can start writing stubs without docker.

# Getting started
* You can get started by reading our [Getting started tutorial](https://github.com/ouspg/libfuzzerfication/blob/master/GETTING-STARTED.md)
* See example: [mysamplelib](https://github.com/ouspg/libfuzzerfication/tree/master/stubs/mysamplelib)

# Requirements
* [docker-machine version 0.7.0](https://docs.docker.com/machine/)
* [Docker version 1.11.2](https://www.docker.com/)
* [docker-compose version 1.7.1](https://docs.docker.com/compose/)

# Material
* [libFuzzer](http://llvm.org/docs/LibFuzzer.html)
* [SanitizerCoverage](http://clang.llvm.org/docs/SanitizerCoverage.html)
* You can find some nice examples from: [libfuzzer-bot repo](https://github.com/google/libfuzzer-bot)
* [libFuzzer in Chrome](https://chromium.googlesource.com/chromium/src/+/master/testing/libfuzzer/README.md)
* [Efficient Fuzzer](https://chromium.googlesource.com/chromium/src/+/master/testing/libfuzzer/efficient_fuzzer.md)

# Tracking
[Target tracking sheet](https://docs.google.com/spreadsheets/d/1oj0L44gKTn3wlrJk6b554b9o8H0r1bVfb6LJrw62BEE/pubhtml)

# Contributors

* Atte Kettunen ([@attekett](https://github.com/attekett)
* Mikko Yliniemi ([@mikessu](https://github.com/mikessu)
* Ossi Herrala ([@oherrala](https://github.com/oherrala))
* Jani Kenttälä ([@evilon](https://github.com/evilon))
* Marko Laakso ([@ikisusi](https://github.com/ikisusi))
* Pauli Huttunen ([@WhiteEyeDoll](https://github.com/WhiteEyeDoll))
* Joonas Kuorilehto ([@joneskoo](https://github.com/joneskoo))
* Ari Kauppi ([@arikauppi](https://github.com/arikauppi)


List of contributors: [Contributors](https://github.com/ouspg/libfuzzerfication/graphs/contributors)

Visit #ouspg @ IRCnet if you're interested!

This is part of [OUSPG-open](https://github.com/ouspg/ouspg-open)
