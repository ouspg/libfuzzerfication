FROM ouspg/libfuzzer-base

RUN apt-get update && apt-get upgrade -y

RUN cd /src && git clone https://github.com/ouspg/libfuzzerfication.git

## temporary
RUN cd /src/libfuzzerfication && git checkout mysamplelib-stub

WORKDIR /src/libfuzzerfication/docker/stubs/mysamplelib
#RUN ./build.sh
