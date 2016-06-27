FROM ubuntu:16.04
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y git clang nodejs curl ca-certificates && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# Checkout & build libFuzzer
#
RUN mkdir /src /work && \
	cd /src && \
	git clone https://chromium.googlesource.com/chromium/llvm-project/llvm/lib/Fuzzer && \
	clang++ -c -g -O2 -std=c++11 Fuzzer/*.cpp -IFuzzer && \
	ar ruv libFuzzer.a Fuzzer*.o && \
	mkdir -p /work/libfuzzer && \
	mv libFuzzer.a /usr/local/lib && \
	rm *.o && \
	rm -rf Fuzzer


#Checkout minimizer
#
RUN cd src && \
	git clone https://github.com/attekett/nipsu/ && \
	rm -rf ./nipsu/.git

# Add fuzzing script
#
ADD ./fuzz.sh /src/scripts/fuzz.sh
RUN chmod +x /src/scripts/fuzz.sh

ENV PATH="/work/llvm/bin:$PATH"
