#include "mysamplelib.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  (void) fuzzinginstyle(Data, Size);
  return 0;  // Non-zero return values are reserved for future use.
}
