#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern "C" {
#include "libavcodec/avcodec.h"
#include "libavutil/avutil.h"
#include "libavutil/mathematics.h"
}

#define INBUF_SIZE 4096
#define AUDIO_INBUF_SIZE 20480
#define AUDIO_REFILL_THRESH 4096


//TODO: Remove extra check etc.
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    avcodec_register_all();
    av_log_set_level(-1);
    AVCodec *codec;
    AVCodecContext *c= NULL;
    int len;
    AVPacket avpkt;
    AVFrame *decoded_frame = NULL;
    //printf("New file.\n");

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
    //TODO: Check that the data is actually read as it should.
    avpkt.data = (uint8_t *) data;
    avpkt.size = size; //fread(inbuf, 1, AUDIO_INBUF_SIZE, f);

    while (avpkt.size > 0) {
        int got_frame = 0;

        decoded_frame = av_frame_alloc();


        len = avcodec_decode_audio4(c, decoded_frame, &got_frame, &avpkt);
        //printf("len: %d\n",len);
        if (len < 0) {
            //fprintf(stderr, "Error while decoding\n");
            break;
        }

        avpkt.size -= len;
        avpkt.data += len;

    }

    avcodec_close(c);
    av_free(c);

    return 0;
}
