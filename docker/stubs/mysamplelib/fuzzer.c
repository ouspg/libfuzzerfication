#include <stdio.h>
#include <stdint.h>
#include "mysamplelib.h"

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  (void) fuzzinginstyle(Data);
  return 0;  // Non-zero return values are reserved for future use.
}
