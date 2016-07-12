#include <stdio.h>
#include <stdint.h>
#include "mysamplelib.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  (void) mysamplefunction(Data, Size);
  return 0;  // Non-zero return values are reserved for future use.
}
