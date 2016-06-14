

export CXXFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CXX="clang++"
export CFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export CC="clang"
export LDFLAGS="-fsanitize=address -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp"
export LIBFUZZER_OBJS="/work/libfuzzer/*.o"

mkdir -p /work/libfuzzer; 
cd /work/libfuzzer; 
for f in /src/llvm/lib/Fuzzer/*cpp; do 
	$CXX -std=c++11 -fsanitize=address -IFuzzer -c $f 
done 

cd /src/ImageMagick
./configure --without-threads --disable-openmp --without-gslib --without-dpsv --with-modules
make -j4

#$CXX $CXXFLAGS -std=c++11 -I$(pwd) $(pwd)/MagickCore/*.o $(pwd)/coders/*.o $(pwd)/filters/*.o \
#			-lxml2 -lm -lpthread -lz -lX11 -lfontconfig -lfreetype -llzma -fopenmp -lpng -ltiff \
#			-lXext -lrt -ljbig -ljpeg -lcairo -lpango-1.0 -lgobject-2.0 -lbz2 -lpangocairo-1.0 \
#			$LIBFUZZER_OBJS -o ImageMagick_fuzzer ImageMagick_fuzzer.c

$CXX $CFLAGS -std=c++11 -I$(pwd) $(pwd)/MagickCore/*.o  -lxml2 -lm -lpthread -lz -lX11 -lfontconfig \
			 -lfreetype -llzma -fopenmp -lpng -ltiff -lXext -lrt -ljbig -ljpeg -lcairo -lpango-1.0 \
			 -lgobject-2.0 -lbz2 -lpangocairo-1.0 -llcms2 -llqr-1 -lfftw3 -lltdl \
			 /work/libfuzzer/Fuzzer*.o  -o ImageMagick_fuzzer ImageMagick_fuzzer.c 


