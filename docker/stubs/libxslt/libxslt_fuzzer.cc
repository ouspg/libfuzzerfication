#include <stdio.h>

void ignore(void *ctx, const char *msg, ...) {
}
extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, size_t size) {
  return 0;
}
