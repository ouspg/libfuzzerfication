#include <string.h>
#include <stdint.h>
#include "libavcodec/avcodec.h"
#include "libavutil/avutil.h"

#define INBUF_SIZE 4096
#define AUDIO_INBUF_SIZE 20480
#define AUDIO_REFILL_THRESH 4096

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  avcodec_register_all();

  picture = av_frame_alloc();
  parser = av_parser_init(AV_CODEC_ID_H264);

  AVPacket pkt;
  int got_picture = 0;
  int len = 0;

  av_init_packet(&pkt);

  avcodec_close(codec_context);
  av_free(codec_context);
  codec_context = NULL;


  return 0;
}
