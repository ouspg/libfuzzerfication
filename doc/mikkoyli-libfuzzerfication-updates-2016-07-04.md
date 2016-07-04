class: center, middle

## LibFuzzerfication updates
## OUSPG Open, 2016-07-04

---

# Team

* Mikko Yliniemi (@mikessu)
* Atte Kettunen (@attekett)
* Pauli Huttunen (@WhiteEyeDoll)

---

LibFuzzerfication is a project thats purpose is to do fuzz-testing for applications and libraries.

<img src="https://raw.githubusercontent.com/ouspg/libfuzzerfication/master/pictures/fuzzing_lua.gif" width="716" height="393" alt="Fuzzing in action">

Example of lua fuzz test running.

---
# Motivation
There have been lots of vulnerabilities in popular libraries that should have been (theoretically) easy to test. We want to offer easy way to fuzz-test these libraries and increase awareness about the situation. We also want this to be available to everyone.

---

# About libfuzzer
* LibFuzzer is open-source library (part of LLVM)
* Relies on compiler instrumentation to get coverage feedback
* It is linked with the library under test
* Works fully in process -> Fast!

---

# What we have done this far?

* We have currently following stubs in repository:
- haskell-x509 (@oherrala)
- ImageMagick (@attekett)
- libav (@mikessu)
- libxml2 (@attekett)

# After last session:

* Lua stub was committed by Joonas Kuorilehto (@joneskoo)
* libxslt stub was committed by Ari Kauppi (@kauppi


---
# Docker base image

* This project is using docker
* We are using ubuntu:16.04 as base image
* libFuzzer is included in base image
* Nipsu minimizer is also included in base image (Crash repro minifier for ASan-instrumented commandline tools.)
* Fuzz.sh script is used as entrypoint, it takes care of running fuzz tests and gathering results

(show libfuzzer-base dockerfile)

---
# Docker images for stubs

* Every stub has its own dockerfile
* Images are created from dockerfiles
* Containers are run to do the testing

(show example stub dockerfile for libav)

---

# Under development
* libflac stub is currently under development
* Make fuzzing in container to run as non root user
* Pauli (@WhiteEyeDoll) is currently working to get fuzzing running in Google cloud

---

# Documentation

We are working to make participating this project easy. Documentation is being written and improved all the time. You can find documentation from github. We are trying to make it easy to get started with libFuzzer.

https://github.com/ouspg/libfuzzerfication

---

# Feel free to contribute
* Everyone can contribute

# How does this project work?
* You pull container from Dockerhub
* Start Writing your own libfuzzer stub
* Share dockerfile with other users
* Use libFuzzer to collect corpus so that other people can continue where you left off

You can start writing stubs without docker.

Visit #ouspg @ IRCnet if you're interested!

---
