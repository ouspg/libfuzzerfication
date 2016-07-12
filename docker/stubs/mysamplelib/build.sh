clang++ -fsanitize=address \
        -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp \
        mysamplelib.c fuzzer.c -lFuzzer -o fuzzer
