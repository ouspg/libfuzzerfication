FROM ubuntu:16.04
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y build-essential git clang

# Checkout & build libFuzzer
#
RUN mkdir /src /work && \
	cd /src && \
	git clone https://chromium.googlesource.com/chromium/llvm-project/llvm/lib/Fuzzer && \
	clang++ -c -g -O2 -std=c++11 Fuzzer/*.cpp -IFuzzer && \
	ar ruv libFuzzer.a Fuzzer*.o && \
	mkdir -p /work/libfuzzer && \ 
	cp libFuzzer.a /usr/local/lib

# Add fuzzing script
#
ADD ./fuzz.sh /src/scripts/fuzz.sh
RUN chmod +x /src/scripts/fuzz.sh

ENV PATH="/work/llvm/bin:$PATH"

	
