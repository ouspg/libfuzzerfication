FROM ubuntu:16.04

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y git clang nodejs && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Checkout & build libFuzzer

RUN mkdir /src /work && \
    cd /src && \
    git clone https://chromium.googlesource.com/chromium/llvm-project/llvm/lib/Fuzzer && \
    clang++ -c -g -O2 -std=c++11 Fuzzer/*.cpp -IFuzzer && \
    ar ruv libFuzzer.a Fuzzer*.o && \
    mkdir -p /work/libfuzzer && \
    mv libFuzzer.a /usr/local/lib && \
    rm *.o && \
    rm -rf Fuzzer


# Checkout minimizer

RUN cd /src && \
    git clone https://github.com/attekett/nipsu/ && \
    rm -rf ./nipsu/.git

# Add fuzzing script

ADD ./fuzz.sh /src/scripts/fuzz.sh
RUN chmod +x /src/scripts/fuzz.sh
