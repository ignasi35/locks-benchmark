#!/bin/sh

# Linux only

vmstat 1 > vmstat.log &
java -Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -jar microbenchmarks.jar | tee microbenchmark.log

for job in `jobs -p`
do
    kill $job
done

