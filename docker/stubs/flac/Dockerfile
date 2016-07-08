FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification
ENV TARGET 'flac'

#Install dependencies and fetch the source.

RUN apt-get update && apt-get upgrade -y && apt-get install -y libflac-dev pkg-config libtool-bin && apt-get build-dep libflac-dev -y
RUN cd /src && git clone https://git.xiph.org/flac.git
ADD flac_fuzzer.cc /src/$TARGET/

#RUN mkdir -p /work/$TARGET/

#Build
ADD build.sh /src/$TARGET/
WORKDIR /src/flac
RUN bash ./build.sh

#Entrypoint and default args
#ENTRYPOINT /src/scripts/fuzz.sh
#CMD ['/samples/libfuzzer-flac']
