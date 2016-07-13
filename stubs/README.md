# libfuzzerfication stubs

# What are stubs?
This directory consists of libFuzzer stub files.

Stubs look like this:

```
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  DoSomething(Data, Size);
  return 0;  // Non-zero return values are reserved for future use.
}
```
Data is the data and size is the size to be tested.
