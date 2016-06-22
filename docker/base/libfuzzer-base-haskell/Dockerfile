FROM ouspg/libfuzzer-base

MAINTAINER https://github.com/ouspg/libfuzzerification

ENV GHC_VERSION 8.0.1
ENV CABAL_VERSION 1.24
ENV GHC_LLVM 3.7

# https://launchpad.net/~hvr/+archive/ubuntu/ghc
COPY hvr-ghc.list /etc/apt/sources.list.d/
COPY hvr-ghc.key /tmp
RUN apt-key add /tmp/hvr-ghc.key

# GHC and requirements
RUN apt-get -y update && \
    apt-get -y install \
        cabal-install-${CABAL_VERSION} \
        ghc-${GHC_VERSION} \
        llvm-${GHC_LLVM}

# My devel tools
RUN apt-get -y install emacs-nox
COPY dotemacs /root/.emacs

# Set Clang as default compiler
RUN update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c89 /usr/bin/clang && \
    update-alternatives --set c99 /usr/bin/clang && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/clang 1

# GHC needs to find correct version of LLVM's opt and llc
RUN update-alternatives --install /usr/bin/opt opt /usr/bin/opt-${GHC_LLVM} 1 && \
    update-alternatives --install /usr/bin/llc llc /usr/bin/llc-${GHC_LLVM} 1

ENV PATH /opt/ghc/${GHC_VERSION}/bin/:/opt/cabal/${CABAL_VERSION}/bin/:${PATH}

COPY ghc-wrapper ghc-asan /usr/local/bin/
RUN chmod a+x /usr/local/bin/ghc-*

# Build and install our libfuzzer Haskell lib
WORKDIR /src/hs-libfuzzer
ADD hs-libfuzzer /src/hs-libfuzzer
RUN cd /src/hs-libfuzzer && \
    cabal update && \
    cabal install && \
    rm -rf /src/hs-libfuzzer

COPY cabal.config /root/.cabal/config

WORKDIR /haskell/
COPY src/hsinit.c src/test.hs src/build.sh /haskell/
