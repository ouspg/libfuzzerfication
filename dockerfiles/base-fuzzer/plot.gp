# expects following variables set by -e:
# - filenames - list of files to load data from
# - outputfile - file to write report to.
# - maintitle - main graph title.

## load data

set datafile separator ","

set table $data_block_cov
plot for [file in filenames] file using 1:2

set table $data_bits
plot for [file in filenames] file using 1:3

set table $data_ccov
plot for [file in filenames] file using 1:4

set table $data_corpus
plot for [file in filenames] file using 1:5

set table $data_speed
plot for [file in filenames] file using 1:6

set table $data_tbm
plot for [file in filenames] file using 1:7

unset table

set datafile separator whitespace

## process data
stats $data_block_cov name "BlockCov" nooutput
stats $data_bits name "Bits" nooutput
stats $data_corpus name "Corpus" nooutput
stats $data_speed name "Speed" nooutput
stats $data_ccov name "Ccov" nooutput

## plot

set terminal pdf size 8, 8
set output outputfile
set multiplot layout 3,2 title maintitle noenhanced
set nokey
set pointsize .5
#set logscale x

set tics font ", 8"

set title "block coverage"
set label 2 gprintf("max = %g", BlockCov_max_y) at graph 0.8, graph 0.1 font ", 8"
plot for [IDX=1:BlockCov_blocks] $data_block_cov index (IDX-1)

set title "bits"
set label 2 gprintf("max = %g", Bits_max_y) at graph 0.8, graph 0.1 font ", 8"
plot for [IDX=1:BlockCov_blocks] $data_bits index (IDX-1)

set title "corpus size"
set label 2 gprintf("max = %g", Corpus_max_y) at graph 0.8, graph 0.1 font ", 8"
plot for [IDX=1:BlockCov_blocks] $data_corpus index (IDX-1)

set title "speed"
set label 2 gprintf("max = %g", Speed_max_y) at graph 0.8, graph 0.1 font ", 8"
plot for [IDX=1:BlockCov_blocks] $data_speed index (IDX-1)

set title "caller coverage"
set label 2 gprintf("max = %g", Ccov_max_y) at graph 0.8, graph 0.1 font ", 8"
plot for [IDX=1:BlockCov_blocks] $data_ccov index (IDX-1)

set title "tbms"
set label 2 ""
plot for [IDX=1:BlockCov_blocks] $data_tbm index (IDX-1)

