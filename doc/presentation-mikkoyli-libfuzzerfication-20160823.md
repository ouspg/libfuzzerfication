class: center, middle

## LibFuzzerfication - fuzzing for the rest of us
## 2016-08-23

---
Purpose of libFuzzerfication is to do fuzz-testing for applications and libraries to see if new vulnerabilities are found.

<img src="https://raw.githubusercontent.com/ouspg/libfuzzerfication/master/pictures/fuzzing_lua.gif" width="716" height="393" alt="Fuzzing in action">

Example of fuzz test running.

---
# Why?

* We wanted to do some fuzz testing for popular libraries.
* Purpose was to create a social startup. We wanted to increase awareness about situation.
* Purpose was that people could easily run libfuzzer on their own computer or cloud

---

# When

* I was working as summer trainee for 3 month in ouspg
* During this time also people contributed this project

---

# About libfuzzer
* LibFuzzer is open-source library (part of LLVM)
* It is similiar to AFL (American Fuzzy LOP)
* Works inside process (function) -> faster
* libFuzzer itself is compiled without any specific flags
* Target is compiled with fresh clang using MSan, ASan or USan

---

# Stubs

We have following stubs:
* ImageMagick
* haskell-x509
* libmad
* libxml2
* libxslt
* lua
* mysamplelib
* zlib
* rust [WIP]

---

# How?

* We used docker to automate the deployment of applications inside software containers.
* We have dockerfile for every fuzzer
* Image can be built from dockerfile
* Container can be run from image

# Findings

* We fuzzed ImageMagick and found use after free
* libxml and others were also fuzzed but nothing special was found (these are already heavily fuzzed)
* Purpose is to fuzz rust also

# More info

https://github.com/ouspg/libfuzzerfication

---
