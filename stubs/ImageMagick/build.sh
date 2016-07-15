#!/bin/bash

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"

#Build ImageMagick

cd /src/ImageMagick
./configure --prefix=/usr/ --without-magick-plus-plus --without-perl --without-threads --without-tiff --with-gslib=no --without-dps
make -j4
make install


#Build fuzzer

$CXX $CFLAGS -std=c++11 -I$(pwd) /usr/lib/libMagick*.so -lxml2 -lm -lpthread -lz -lX11 -lfontconfig \
            -lfreetype -llzma -fopenmp -lpng -ltiff -lXext -lrt -ljbig -ljpeg -lcairo -lpango-1.0 \
            -lgobject-2.0 -lbz2 -lpangocairo-1.0 -llcms2 -llqr-1 -lfftw3 -lltdl \
            -lFuzzer -o ImageMagick_fuzzer ImageMagick_fuzzer.c

#Ghostcript is annoying

apt-get remove ghostscript -y
