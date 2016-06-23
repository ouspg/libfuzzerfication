FROM ouspg/libfuzzer-base

ENV TARGET 'libav'

MAINTAINER https://github.com/ouspg/libfuzzerification

#Install dependencies and fetch the source.

RUN apt-get install -y libavcodec-dev pkg-config && apt-get build-dep libavcodec-dev -y
RUN cd /src && git clone git://git.libav.org/libav.git libav
ADD libav_fuzzer.c /src/libav/

ADD ${TARGET}_fuzzer.c /src/$TARGET/
RUN mkdir -p /work/$TARGET/

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh

#Entrypoint and default args
#ENTRYPOINT /src/scripts/fuzz.sh
#CMD ['/samples/libfuzzer-libav']
