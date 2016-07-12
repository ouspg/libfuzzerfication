class: center, middle

## LibFuzzerfication stubs
## OUSPG Open, 2016-07-12

---

# Introduction
Purpose of libFuzzerfication is to do fuzz-testing for applications and libraries. Today we are going to write some libFuzzer stubs for libFuzzerfication.

Fuzzing is to automatically generate lots of test input to crash your code and to increase code coverage.
Some important terms:

Target:
- A function that consumes array of bytes and does something non trivial to them.

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
You need:
- Docker
- Clang, libFuzzer (included in libfuzzer-base image)

List of targets to fuzz:
- https://docs.google.com/spreadsheets/d/1oj0L44gKTn3wlrJk6b554b9o8H0r1bVfb6LJrw62BEE/pubhtml

---
# How to get started writing stubs?

First clone the repo:
```
git clone https://github.com/ouspg/libfuzzerfication.git
```

Second step is to build base image. Go to libfuzzerfication/docker directory and write:
```
# docker-compose build libfuzzer-base
```
Or alternatively pull the ready to go automagically built image from dockerhub:
```
# docker pull ouspg/libfuzzer-base
```

Then you can start developing:
```
# docker run -it --rm -v <host_dir>:<container_dir> --entrypoint bash <image>
```

---

Then you can implement a fuzzing target function that accepts a sequence of bytes, like this:

```
// libxml2_fuzzer.cc
#include "libxml/parser.h"
void ignore(void *ctx, const char *msg, ...) {
  // Error handler to avoid spam of error messages from libxml parser.
}
extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, size_t size) {
  xmlSetGenericErrorFunc(NULL, &ignore);
  auto doc = xmlReadMemory(reinterpret_cast<const char *>(data), size, "noname.xml", NULL, 0);
  //if (doc) {
    xmlFreeDoc(doc);
    xmlCleanupParser();
  //}
  return 0;
}
```

LibFuzzer is already installed in base image.
(Show build.sh and Dockerfile, show example)

---

libFuzzer output looks like this:

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
