// Copyright (c) 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#include "libxml/parser.h"
void ignore(void *ctx, const char *msg, ...) {
    // Error handler to avoid spam of error messages from libxml parser.
}
extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, size_t size) {
    xmlSetGenericErrorFunc(NULL, &ignore);
    auto doc = xmlReadMemory(reinterpret_cast<const char *>(data), size, "noname.xml", NULL, 0);
    //if (doc) {
    xmlFreeDoc(doc);
    xmlCleanupParser();
    //}
return 0;
}
