#!/bin/bash

#Print args for debug
echo "fuzz.sh args: $@"

#Use ramdisk for fuzzing.
#Docker has default shm mounted at /dev/shm
cd /dev/shm;
mkdir fuzzed;

#SIGINT trap
function control_c {
  echo  "*** Ouch! Exiting ***"
  exit $?
}
trap control_c SIGINT

#TODO: Check if we can unify parsers.

#ASAN-trace parser for instrumentation
function parse_asan_trace {

#Example trace:
#==1937== ERROR: AddressSanitizer: heap-buffer-overflow on address 0x60a60002bd58 at pc 0x7f187a7e4928 bp 0x7ffe8aea9c70 sp 0x7ffe8aea9c68
#READ of size 8 at 0x60a60002bd58 thread T0
#    #0 0x7f187a7e4927 (/root/lib.so.2.40.2+0x47927)
#    #1 0x7f187a7e44fe (/root/lib.so.2.40.2+0x474fe)
#    #2 0x7f187a8062a4 (/root/lib.so.2.40.2+0x692a4)
#
#Example output:
#heap-buffer-overflow-2a4-4fe-927

FILE=$1

ERROR=$(grep 'ERROR: AddressSanitizer: ' $FILE)

set -- $ERROR

#ASAN-trace has two different beginnings depending on build: 
#	1. "==<pid>==ERROR"
#	2. "==<pid>== ERROR" 
#Extra whitespace messes up indexes.

if grep -q 'ERROR' <<< $1; then 
	ERROR=$3
else
	ERROR=$4
fi


FRAME0=$(grep -oP '#0 0x\S+' $FILE | head -1)
FRAME1=$(grep -oP '#1 0x\S+' $FILE | head -1)
FRAME2=$(grep -oP '#2 0x\S+' $FILE | head -1)

FRAME0=${FRAME0:(-3)}
FRAME1=${FRAME1:(-3)}
FRAME2=${FRAME2:(-3)}

echo "$ERROR-$FRAME2-$FRAME1-$FRAME0"

}

#libFuzzer timeout-trace parser for instrumentation
function parse_timeout_trace {

#Example trace:
#==3833== ERROR: libFuzzer: timeout after 5 seconds
#    #0 0x4cc481 in __sanitizer_print_stack_trace /src/llvm/projects/compiler-rt/lib/asan/asan_stack.cc:38
#    #1 0x509a3a in fuzzer::Fuzzer::AlarmCallback() (/src/ImageMagick/ImageMagick_fuzzer+0x509a3a)
#    #2 0x5098ac in fuzzer::Fuzzer::StaticAlarmCallback() (/src/ImageMagick/ImageMagick_fuzzer+0x5098ac)
#    #3 0x528537 in fuzzer::AlarmHandler(int, siginfo_t*, void*) (/src/ImageMagick/ImageMagick_fuzzer+0x528537)
#    #4 0x7f6e55eb73cf  (/lib/x86_64-linux-gnu/libpthread.so.0+0x113cf)
#    #5 0x522dc3 in __sanitizer_cov_trace_cmp (/src/ImageMagick/ImageMagick_fuzzer+0x522dc3)
#    #6 0x7f6e573bf8b9 in ReadBlobStream (/usr/lib/libMagickCore-7.Q16HDRI.so.0+0x2ea8b9)
#    #7 0x7f6e573d35ee in ReadBlobByte (/usr/lib/libMagickCore-7.Q16HDRI.so.0+0x2fe5ee)
#    #8 0x7f6e57c68e49 in ReadDPXImage (/usr/lib/libMagickCore-7.Q16HDRI.so.0+0xb93e49)
#
#Example output:
#timeout-5ee-e49

FILE=$1

FINGERPRINT='timeout'

#timeout-trace always has stack frames from instrumentation, we filter these out.
#note: we cannot do this without symbolization
FILE=$(cat $FILE| grep -v 'in fuzzer' | grep -v '__sanitizer' | grep -v 'libpthread')

#Take first three frames and discard the first. 
#Timeout interrupts the current execution, so first valid frame can be with different
#address even in same function.
FRAMES=$(echo $FILE | grep -oP '#. 0x\S+' | head -3 | tail -2 | sed s/'#. '//g)

for foo in $FRAMES; do 
	FINGERPRINT="$FINGERPRINT-${foo:(-3)}"
done

echo "$FINGERPRINT"

}

TARGET=$(basename $1)
echo "Target: $TARGET"

export ASAN_SYMBOLIZER_PATH='/work/llvm/bin/llvm-symbolizer'
#ImageMagick sometimes tries to allocate huge amounts of memory, when it does ASAN allocator fails.
export ASAN_OPTIONS='allocator_may_return_null=1:detect_leaks=0:coverage=1:symbolize=1'


while true; do
	echo "Round."
		$@ 2>&1 | tee asan.txt
		cat ./asan.txt
		if [ "$(grep "ERROR: AddressSanitizer" ./asan.txt)" ]; then
			RESULT=$(parse_asan_trace ./asan.txt)
			echo "New crash: "$TARGET-$RESULT
			#Save results to the RESULTS_FOLDER 
			cp ./asan.txt /results/$TARGET-$RESULT.txt && echo "Report saved: /results/$TARGET-$RESULT.txt"
			cp /dev/shm/repro-file /results/$TARGET-$RESULT.repro && echo "Repro-file saved: /results/$TARGET-$RESULT.repro"
		elif [ "$(grep "ERROR: libFuzzer: timeout" ./asan.txt)" ]; then
			RESULT=$(parse_timeout_trace ./asan.txt)
			echo "New timeout: "$TARGET-$RESULT
			#Save results to the RESULTS_FOLDER 
			cp ./asan.txt /results/$TARGET-$RESULT.txt && echo "Report saved: /results/$TARGET-$RESULT.txt"
			cp /dev/shm/repro-file /results/$TARGET-$RESULT.repro && echo "Repro-file saved: /results/$TARGET-$RESULT.repro"
		fi
		#TODO: Add dictionary collection.
		rm asan.txt
	done
done
