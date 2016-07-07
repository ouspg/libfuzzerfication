#!/bin/bash

# This script is used to download the corpus archive and check its contents
# Minimizing and upload options to be included

sampledir=/srv/fuzzer/samples/

function dl_corpus () {
    curl -O --output $sampledir $CORPUS_URL/$CORPUS_ARCHIVE
    curl -O --output $sampledir $CORPUS_URL/$SHA256SUMS_FILE
}

funtion check_files () {
    cd $sampledir

    if $(sha256sum -c $SHA256SUMS_FILE); do
        mkdir tmp
        cd tmp
        tar -xf $sampledir/$CORPUS_ARCHIVE
        find . type -f -exec mv {} $sampledir \;
        rm -rf $sampledir/tmp

    else
        echo "Invalid corpus directory archive!"
        exit 1

    if $(sha256sum -c filelist.manifest); do
        echo "All files ok."
        rm filemanifest.txt
    else
        echo "Invalid files detected!"
        exit 1
}
