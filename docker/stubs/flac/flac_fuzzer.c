#include <stdio.h>
#include <stdlib.h>
#include "share/compat.h"
#include "FLAC/stream_decoder.h"


extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
	FLAC__bool ok = true;
	FLAC__StreamDecoder *decoder = 0;
	FLAC__StreamDecoderInitStatus init_status;

	if((decoder = FLAC__stream_decoder_new()) == NULL) {
			fprintf(stderr, "ERROR: allocating decoder\n");
			return 1;
		}

		(void)FLAC__stream_decoder_set_md5_checking(decoder, true);
  //init_status = FLAC__stream_decoder_init_stream(decoder, data, write_callback, metadata_callback, error_callback, /*client_data=*/fout);
	if(init_status != FLAC__STREAM_DECODER_INIT_STATUS_OK) {
		fprintf(stderr, "ERROR: initializing decoder: %s\n", FLAC__StreamDecoderInitStatusString[init_status]);
		ok = false;
	}

	if(ok) {
		ok = FLAC__stream_decoder_process_until_end_of_stream(decoder);
		//fprintf(stderr, "decoding: %s\n", ok? "succeeded" : "FAILED");
		//fprintf(stderr, "   state: %s\n", FLAC__StreamDecoderStateString[FLAC__stream_decoder_get_state(decoder)]);
	}

	FLAC__stream_decoder_delete(decoder);

	return 0;
}
