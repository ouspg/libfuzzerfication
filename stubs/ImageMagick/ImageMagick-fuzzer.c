#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MagickCore/MagickCore.h"

/*
*We use BlobToImage to load input as an image, if successful destroy image.
*/

extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, size_t size) {
    Image *image;
    ImageInfo image_info;
    ExceptionInfo *exception;

    GetImageInfo(&image_info);
    exception = AcquireExceptionInfo();

    image = BlobToImage(&image_info, data, size, exception);

    if (exception->severity != UndefinedException) {
        //CatchException(exception);
    }

    if (image != (Image *) NULL) {
        DestroyImage(image);
    }

    DestroyExceptionInfo(exception);

    return 0;
}
