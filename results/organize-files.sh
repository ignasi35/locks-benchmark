#!/bin/sh

for d in `ls *.log | perl -pe 's/(-vmstat|-gc|-microbenchmark).log//' | sort | uniq`
do
    RUN_DIR=$d
    DATE=$(date "+%Y-%m-%d")
    TARGET_DIR="$DATE/$RUN_DIR"

    mkdir -p $TARGET_DIR
    mv ${d}-gc.log $TARGET_DIR/gc.log
    mv ${d}-vmstat.log $TARGET_DIR/vmstat.log
    mv ${d}-microbenchmark.log $TARGET_DIR/microbenchmark.log
done

