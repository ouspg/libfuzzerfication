FROM libfuzzer/base-fuzzer

MAINTAINER aizatsky@google.com

RUN apt-get install -y liblzma-dev
RUN apt-get build-dep libxml2 -y
RUN cd /src && git clone git://git.gnome.org/libxml2
ADD libxml2_fuzzer.cc /src/libxml2/
#VOLUME /src/libxml2

ENV FUZZERS "/work/libxml2/libxml2_fuzzer"
ENV FUZZER_DICTIONARY "/src/libxml2/xml.dict"
ENV CXX "clang++"
ENV CXXFLAGS "-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
ENV LIBFUZZER_OBJS "/work/libfuzzer/*.o"
ENV LD_LIBRARY_PATH "/src/libxml2/.libs/"
#RUN mkdir -p /work/libfuzzer && cd /work/libfuzzer \
#  && cp /src/llvm/lib/Fuzzer/*.h . \
#  && /work/llvm/bin/clang++ -g -std=c++11 -stdlib=libc++ -fsanitize=address -c /src/llvm/lib/Fuzzer/*.cpp -I.


RUN	mkdir -p /work/libfuzzer; \
	cd /work/libfuzzer; \
	for f in /src/llvm/lib/Fuzzer/*cpp; do $CXX -std=c++11 -fsanitize=address -IFuzzer -c $f & done; \
	wait


ADD xml.dict /src/libxml2/

ADD build.sh /src/scripts/

RUN mkdir -p /work/libxml2/
RUN bash /src/scripts/build.sh
