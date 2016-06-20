#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern "C" {
#include "libavcodec/avcodec.h"
#include "libavutil/avutil.h"
}

#define INBUF_SIZE 4096
#define AUDIO_INBUF_SIZE 20480
#define AUDIO_REFILL_THRESH 4096


extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {

  /* register all the codecs */
  avcodec_register_all();

  AVCodec *codec;
  AVCodecContext *c= NULL;
  int len;
  FILE *f, *outfile;
  uint8_t inbuf[AUDIO_INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE];
  AVPacket avpkt;
  AVFrame *decoded_frame = NULL;

  av_init_packet(&avpkt);

  codec = avcodec_find_decoder(AV_CODEC_ID_MP2);
      if (!codec) {
          fprintf(stderr, "codec not found\n");
          exit(1);
      }

  c = avcodec_alloc_context3(codec);

  if (avcodec_open2(c, codec, NULL) < 0) {
           fprintf(stderr, "could not open codec\n");
           exit(1);
       }

  /* decode until eof */
  avpkt.data = inbuf;
  avpkt.size = fread(inbuf, 1, AUDIO_INBUF_SIZE, f);

  while (avpkt.size > 0) {
  int got_frame = 0;

  if (!decoded_frame) {
    if (!(decoded_frame = av_frame_alloc())) {
      fprintf(stderr, "out of memory\n");
      exit(1);
      }
  }

  len = avcodec_decode_audio4(c, decoded_frame, &got_frame, &avpkt);
  if (len < 0) {
    fprintf(stderr, "Error while decoding\n");
    exit(1);
  }

  avpkt.size -= len;
  avpkt.data += len;
  if (avpkt.size < AUDIO_REFILL_THRESH) {
      memmove(inbuf, avpkt.data, avpkt.size);
      avpkt.data = inbuf;
      len = fread(avpkt.data + avpkt.size, 1,
                           AUDIO_INBUF_SIZE - avpkt.size, f);
      if (len > 0)
          avpkt.size += len;
      }
    }

  avcodec_close(c);
  av_free(c);

  return 0;
}
