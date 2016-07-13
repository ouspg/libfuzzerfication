#include "HsFFI.h"

int LLVMFuzzerInitialize(int *argc, char ***argv) {
  hs_init(argc, argv);
  return 0;
}
