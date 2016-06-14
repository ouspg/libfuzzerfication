
#ImageMagick sometimes tries to allocate huge amounts of memory, when it does ASAN allocator fails.
export ASAN_OPTIONS=allocator_may_return_null=1:detect_leaks=0

#Print args for debug
echo $@


/src/ImageMagick/ImageMagick_fuzzer -rss_limit_mb=4096 -detect_leaks=0 -artifact_prefix=/results/ -max_len=5000 -use_counters=1 -max_total_time=600 $@