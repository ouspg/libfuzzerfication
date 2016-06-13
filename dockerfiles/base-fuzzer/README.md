Base image for all project-specific fuzzer images. Contains driving scripts and capabilities for fuzzers.

## Creating New Fuzzer Image

You have to provide at least 2 files to define a fuzzer image:
  * `Dockerfile`
  * `build.sh`

#### Dockerfile

Use `RUN` directives to checkout project source into `/src/<project_name>` directory and `ADD` to add fuzzer source
code to the image. Define `FUZZERS` environment variable with final fuzzer
test binaries paths (space separated).

Example:

```
FROM libfuzzer/base-fuzzer

MAINTAINER me@example.com

RUN cd /src && svn co svn://vcs.exim.org/pcre2/code/trunk pcre2
ADD pcre2_fuzzer.cc /src/pcre2/
ENV FUZZERS "/work/pcre2/pcre2_fuzzer"
VOLUME /src/pcre2
```

The last `VOLUME` directive would ensure that you can mount exisiting project tree into a container.

The `libfuzzer/base-fuzzer` image defines `ONBUILD` directives that would add `build.sh` to `/src/script` folder.

#### build.sh

Should build the project. It is recommended to store build artifacts in `/work/<project_name>` directory so that they could be
reused between runs.

Use `$CC`, `$CXX`, `$CFLAGS`, `$CXXFLAGS` in your script.

When building fuzzer tests, link in `/src/libfuzzer/*.o` files.
