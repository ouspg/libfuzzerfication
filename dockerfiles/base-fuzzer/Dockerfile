FROM libfuzzer/base-clang

MAINTAINER aizatsky@google.com

RUN mkdir /workspace
WORKDIR /workspace
VOLUME /workspace

RUN mkdir -p /work/libfuzzer

ENV sanitizer_flags="-fsanitize=address"
ENV cov_flags="-fsanitize-coverage=edge,indirect-calls,8bit-counters"

ENV ASAN_OPTIONS="symbolize=1"

RUN mkdir /out
VOLUME /out
