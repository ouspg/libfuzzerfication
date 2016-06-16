FROM ubuntu:16.04
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y build-essential make cmake ninja-build git python2.7

# Checkout & build llvm+clang+deps+libFuzzer
#
RUN mkdir /src /work && \ 
	cd /src && git clone --depth 1 http://llvm.org/git/llvm.git && \
	cd /src/llvm/tools && git clone --depth 1 http://llvm.org/git/clang.git && \
	cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/compiler-rt.git && \
	cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxx.git && \
	cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxxabi.git && \
	cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/lld.git && \
 	mkdir -p /work/llvm && cd /work/llvm && \
 	cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DLIBCXX_ENABLE_SHARED=OFF  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON /src/llvm && \ 
 	ninja && \
 	mkdir -p /work/libfuzzer && \ 
	cd /work/libfuzzer &&	\
	for f in /src/llvm/lib/Fuzzer/*cpp; do /work/llvm/bin/clang++ -std=c++11 -IFuzzer -c $f; done && \
 	rm -rf /src/llvm

RUN apt-get remove --purge -y cmake ninja-build python2.7 build-essential && apt-get autoremove -y
ADD ./fuzz.sh /src/scripts/fuzz.sh
RUN chmod +x /src/scripts/fuzz.sh

ENV PATH="/work/llvm/bin:$PATH"

	
