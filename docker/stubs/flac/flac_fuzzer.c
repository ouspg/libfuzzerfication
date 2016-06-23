#include <stdio.h>
#include <stdlib.h>
#include "share/compat.h"
#include "FLAC/stream_decoder.h"


extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
	FLAC__bool ok = true;
	FLAC__StreamDecoder *decoder = 0;
	FLAC__StreamDecoderInitStatus init_status;

	(void)FLAC__stream_decoder_set_md5_checking(decoder, true);

	// todo: todo

	return 0;
}
