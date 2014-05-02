#!/bin/sh

for i in `seq 24`
do
    THREAD_DIR=$(printf '%03d-threads' $i)
    DATE=$(date "+%Y-%m-%d")
    TARGET_DIR="$DATE/$THREAD_DIR"

    mkdir -p $TARGET_DIR
    mv ${i}-threads-gc.log $TARGET_DIR/gc.log
    mv ${i}-threads-vmstat.log $TARGET_DIR/vmstat.log
    mv ${i}-threads-microbenchmark.log $TARGET_DIR/microbenchmark.log
done

