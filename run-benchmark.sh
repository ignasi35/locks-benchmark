#!/bin/sh

# Linux only

for NB_THREADS in `seq 100`
do
    vmstat 1 > $NB_THREADS-threads-vmstat.log &
    java -Xloggc:$NB_THREADS-threads-gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -jar microbenchmarks.jar -t $NB_THREADS | tee $NB_THREADS-threads-microbenchmark.log
    for job in `jobs -p`
    do
        kill $job
    done
done
