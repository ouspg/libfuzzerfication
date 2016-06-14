FROM libfuzzer/base-fuzzer

MAINTAINER mikessu

RUN apt-get install -y libavcodec-dev nasm
RUN cd /src && git clone git://git.libav.org/libav.git libav
ADD libav_fuzzer.cc /src/libav/
#VOLUME /src/libav

ENV FUZZERS "/work/libav/libav_fuzzer"
ENV CXX "clang++"
ENV CXXFLAGS "-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
ENV LIBFUZZER_OBJS "/work/libav/*.o"
ENV LD_LIBRARY_PATH "/src/libav/.libs/"


RUN	mkdir -p /work/libfuzzer; \
	cd /work/libfuzzer; \
	for f in /src/llvm/lib/Fuzzer/*cpp; do $CXX -std=c++11 -fsanitize=address -IFuzzer -c $f & done; \
	wait

ADD build.sh /src/scripts/

RUN mkdir -p /work/libav/
RUN bash /src/scripts/build.sh
