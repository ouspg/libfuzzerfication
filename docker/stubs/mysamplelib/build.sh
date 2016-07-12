clang -fsanitize=address \
      -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp \
      mysamplelib.c fuzzer.c -L/usr/local/lib -lFuzzer -o fuzzer
