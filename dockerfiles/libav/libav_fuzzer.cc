#include <string.h>
#include <stdint.h>
#include "libavcodec/avcodec.h"

#define INBUF_SIZE 4096
#define AUDIO_INBUF_SIZE 20480
#define AUDIO_REFILL_THRESH 4096

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {

  c = avcodec_alloc_context3(codec);
  c->request_sample_fmt = AV_SAMPLE_FMT_S16;

  avpkt.data = inbuf;
  avpkt.size = fread(inbuf, 1, AUDIO_INBUF_SIZE, f);



     fclose(outfile);
     fclose(f);
     free(outbuf);

  return 0;
}
