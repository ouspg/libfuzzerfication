// Copyright (c) 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#include "libavcodec/avcodec.h"
void ignore(void *ctx, const char *msg, ...) {
  // Error handler to avoid spam of error messages from libxml parser.
}
extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, size_t size) {

  return 0;
}
