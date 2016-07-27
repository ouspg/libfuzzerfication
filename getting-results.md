# Getting results

On every kind of failure libFuzzer prints a stack trace. It dumps reproducer file to disk and then exits the process. In libFuzzerfication fuzz.sh script takes care that fuzzer is started again and is running all the time.

Every stub's container saves repro file on host machine's $HOME/results directory. Also log including stack trace and other information is saved to results directory.

You can try to reproduce errors by starting a new container and mounting a repro file in it. After that you can run fuzzer stub with that repro.
