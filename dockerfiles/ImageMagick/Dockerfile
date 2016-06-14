FROM libfuzzer/base-fuzzer

MAINTAINER attekett@gmail.com

ENV TARGET 'ImageMagick'

RUN apt-get build-dep imagemagick -y && apt-get install libiomp5 libiomp-dev -y
RUN cd /src && git clone https://github.com/ImageMagick/ImageMagick.git

ADD ${TARGET}_fuzzer.c /src/$TARGET/
RUN mkdir -p /work/$TARGET/

ADD build.sh /src/scripts/

RUN bash /src/scripts/build.sh
