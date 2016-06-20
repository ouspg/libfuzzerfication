FROM ouspg/libfuzzer-base-haskell

MAINTAINER https://github.com/ouspg/libfuzzerification

WORKDIR /src
RUN cabal update && cabal install x509
COPY test.hs build.sh /src/
RUN sh ./build.sh
