FROM ouspg/libfuzzer-base

RUN apt-get update && apt-get upgrade -y

RUN cd /src && git clone https://github.com/ouspg/libfuzzerfication.git

WORKDIR /src/libfuzzerfication/docker/stubs/

RUN git checkout mysamplelib-stub && cd mysamplelib && build.sh
