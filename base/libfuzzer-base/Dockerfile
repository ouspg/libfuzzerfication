FROM ubuntu:16.04

# Get upgrades and install clang and nodejs

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git clang nodejs && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create fuzzer user

RUN useradd fuzzer
RUN mkdir -p /samples /results
RUN chown fuzzer /samples && chown fuzzer /results

# Checkout & build libFuzzer

RUN mkdir /src /work && \
    cd /src && \
    git clone https://chromium.googlesource.com/chromium/llvm-project/llvm/lib/Fuzzer && \
    cd Fuzzer && \
    git checkout 34a77f5afc4efc03323a70e4f68b092f36f8a89b && \
    cd /src && \
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
