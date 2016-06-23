FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification
ENV TARGET 'flac'

#Install dependencies and fetch the source.

RUN apt-get update && apt-get upgrade -y && apt-get install -y libflac-dev pkg-config libtool-bin && apt-get build-dep libflac-dev -y
RUN cd /src && git clone https://git.xiph.org/flac.git
ADD flac_fuzzer.c /src/flac/

ADD ${TARGET}_fuzzer.c /src/$TARGET/
RUN mkdir -p /work/$TARGET/

#Build
ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh

#Entrypoint and default args
#ENTRYPOINT /src/scripts/fuzz.sh
#CMD ['/samples/libfuzzer-flac']
