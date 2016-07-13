set -e -x

docker build $* -t libfuzzer/libfuzzer-base libfuzzer-base/

docker build $* -t libfuzzer/libav libav/
