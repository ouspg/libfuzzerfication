#include <unistd.h>
#include <stdint.h>

#include "mad.h"

struct buffer {
    unsigned char const *start;
    unsigned long length;
};

static
enum mad_flow input(void *data,
                    struct mad_stream *stream)
{
    struct buffer *buffer = (struct buffer*) data;

    if (!buffer->length)
        return MAD_FLOW_STOP;

    mad_stream_buffer(stream, buffer->start, buffer->length);

    buffer->length = 0;

    return MAD_FLOW_CONTINUE;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    struct buffer buffer;
    struct mad_decoder decoder;

    /* initialize our private message structure */

    buffer.start  = Data;
    buffer.length = Size;

  /* configure input, output, and error functions */

    mad_decoder_init(&decoder, &buffer,
                    input, 0 /* header */,
                    0 /* filter */,
                    0 /* output */,
                    0, 0 /* message */);

  /* start decoding */

  mad_decoder_run(&decoder, MAD_DECODER_MODE_SYNC);

    /* release the decoder */

    mad_decoder_finish(&decoder);

    return 0;
}
