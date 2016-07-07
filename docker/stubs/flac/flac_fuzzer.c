#include <stdio.h>
#include <stdlib.h>
#include "share/compat.h"
#include "FLAC/stream_decoder.h"

static void error_callback(const FLAC__StreamDecoder *decoder, FLAC__StreamDecoderErrorStatus status, void *client_data);
static FLAC__StreamDecoderWriteStatus write_callback(const FLAC__StreamDecoder *decoder, const FLAC__Frame *frame, const FLAC__int32 * const buffer[], void *client_data);

/*
"A function pointer matching this signature must be passed to FLAC__stream_decoder_init*_stream().
The supplied function will be called when the decoder needs more input data. The address of the buffer
to be filled is supplied, along with the number of bytes the buffer can hold. The callback may choose
to supply less data and modify the byte count but must be careful not to overflow the buffer.
The callback then returns a status code chosen from FLAC__StreamDecoderReadStatus."
ref https://xiph.org/flac/api/group__flac__stream__decoder.html
*/

static FLAC__StreamDecoderReadStatus read_callback( const FLAC__StreamDecoder *decoder, FLAC__byte buffer[], size_t *bytes, void *client_data)
{
  //FLAC_Data *data = (FLAC_Data *)client_data;
  //if(*bytes > 0) {
    //*bytes = fread(buffer, sizeof(FLAC__byte), *bytes, file);
    /*if(ferror(file))
      return FLAC__STREAM_DECODER_READ_STATUS_ABORT;
    else if(*bytes == 0)
      return FLAC__STREAM_DECODER_READ_STATUS_END_OF_STREAM;
    else
      return FLAC__STREAM_DECODER_READ_STATUS_CONTINUE;
    }
    else
      return FLAC__STREAM_DECODER_READ_STATUS_ABORT;*/
}


extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
	FLAC__bool ok = true;
	FLAC__StreamDecoder *decoder = 0;
	FLAC__StreamDecoderInitStatus init_status;

	// init decoder
	if((decoder = FLAC__stream_decoder_new()) == NULL) {
			fprintf(stderr, "ERROR: allocating decoder\n");
			return 1;
		}

	(void)FLAC__stream_decoder_set_md5_checking(decoder, true);

	//init_status = FLAC__stream_decoder_init_stream ( 	decoder,
	//																									read_callback,
	//																									/*seek_callback*/ NULL,
	//																									/*tell_callback*/ NULL,
	//																									/*length_callback*/ NULL,
	//																									/*eof_callback*/ NULL,
	//																									write_callback,
	//																									/*metadata_callback*/ NULL,
	//																									error_callback,
	//																									client_data);

	if(init_status != FLAC__STREAM_DECODER_INIT_STATUS_OK) {
		fprintf(stderr, "ERROR: initializing decoder: %s\n", FLAC__StreamDecoderInitStatusString[init_status]);
		ok = false;
	}

	if(ok) {
		ok = FLAC__stream_decoder_process_until_end_of_stream(decoder);
		fprintf(stderr, "decoding: %s\n", ok? "succeeded" : "FAILED");
		fprintf(stderr, "   state: %s\n", FLAC__StreamDecoderStateString[FLAC__stream_decoder_get_state(decoder)]);
	}

	FLAC__stream_decoder_delete(decoder);

	return 0;
}

void error_callback(const FLAC__StreamDecoder *decoder, FLAC__StreamDecoderErrorStatus status, void *client_data)
{
	(void)decoder, (void)client_data;
  fprintf(stderr, "Got error callback: %s\n", FLAC__StreamDecoderErrorStatusString[status]);
}
