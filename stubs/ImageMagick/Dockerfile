FROM ouspg/libfuzzer-base

# Enviroment variables used by the fuzzer

ENV TARGET "ImageMagick"

# Install dependencies and fetch the source.

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get build-dep imagemagick -y && \
    apt-get install libiomp5 libiomp-dev -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /src && git clone https://github.com/ImageMagick/ImageMagick.git

ADD ImageMagick-fuzzer.c /src/ImageMagick/
RUN mkdir -p /work/ImageMagick/

ADD samples.tar.gz /

# Build

ADD build.sh /src/scripts/
RUN bash /src/scripts/build.sh
