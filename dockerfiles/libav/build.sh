#!/bin/bash

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls"
export LIBFUZZER_OBJS="/home/mikko/work/libfuzzer/*.o"

#Build libav
cd /home/mikko/src/libav
./configure --prefix=$HOME
#make -j4
#make install


#Build fuzzer
#$CXX $CFLAGS -std=c++11 -I$(pwd) /usr/lib/libMagick*.so -lxml2 -lm -lpthread -lz -lX11 -lfontconfig \
#			 -lfreetype -llzma -fopenmp -lpng -ltiff -lXext -lrt -ljbig -ljpeg -lcairo -lpango-1.0 \
#			 -lgobject-2.0 -lbz2 -lpangocairo-1.0 -llcms2 -llqr-1 -lfftw3 -lltdl \
#			 /work/libfuzzer/Fuzzer*.o  -o ImageMagick_fuzzer ImageMagick_fuzzer.c
